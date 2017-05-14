#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "uproc.h"

#ifdef P4
#define TICKS_TO_PROMOTE 500
#define MAX 5
#endif

// New struct holding state lists
struct StateLists {
  struct proc* free;
  struct proc* embryo;
  #ifndef P4
  struct proc* ready;
  #else
  struct proc* ready[MAX+1];
  #endif
  struct proc* running;
  struct proc* sleep;
  struct proc* zombie;
};

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
  struct StateLists pLists;             // P3: Added pLists
  #ifdef P4
  uint promote_at_time;                 // P4: Default promotion time 
  #endif
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

// Helper functions declared static
static void wakeup1(void *chan);
static void assert_state(struct proc* p, enum procstate state);
static int remove_from_list(struct proc** sList, struct proc* p);
static int add_to_list(struct proc** sList, enum procstate state, struct proc* p);
static int add_to_ready(struct proc* p, enum procstate state);
static void exit_helper(struct proc** sList);
static void wait_helper(struct proc** sList, int* hk);
#ifdef P4
static int search_and_set(struct proc** sList, int pid, int prio);
static int search_and_set_ready(int pid, int prio);
#endif

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  #ifndef CS333_P3P4
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  #else
  // Check to make sure the ptable has free procs available
  // remove from list wont return a negative number in this
  // case because we check p and the list against null before
  // passing it in to the function. 
  p = ptable.pLists.free;
  if (p) {
    remove_from_list(&ptable.pLists.free, p);
    assert_state(p, UNUSED);
    goto found;
  } 
  #endif
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  #ifdef CS333_P3P4
  // Process is checked against null before it reaches this function
  // so this function won't fail at this point.
  add_to_list(&ptable.pLists.embryo, EMBRYO, p);
  #endif
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    acquire(&ptable.lock);
    #ifdef CS333_P3P4
    remove_from_list(&ptable.pLists.embryo, p);
    assert_state(p, EMBRYO);
    #endif
    p->state = UNUSED;
    #ifdef CS333_P3P4
    add_to_list(&ptable.pLists.free, UNUSED, p);
    #endif
    release(&ptable.lock);
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  p->start_ticks = ticks; // My code Allocate start ticks to global ticks variable
  p->cpu_ticks_total = 0; // My code p2
  p->cpu_ticks_in = 0;    // My code p2
  #ifdef P4
  p->priority = 0;        // My code p4
  #endif
  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  acquire(&ptable.lock);
  ptable.pLists.free = 0;
  ptable.pLists.embryo = 0;
  ptable.pLists.running = 0;
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;
  #ifndef P4
  ptable.pLists.ready = 0;
  #else
  for (int i = 0; i < MAX+1; i++)
    ptable.pLists.ready[i] = 0;
  #endif

  // Loop through ptable adding procs to free
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    add_to_list(&ptable.pLists.free, UNUSED, p);  

  #ifdef P4
  ptable.promote_at_time = 500;                         // P4: Init promote time to 5 seconds..
  #endif
  release(&ptable.lock);
  
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
  p->uid = DEFAULTUID; // p2
  p->gid = DEFAULTGID; // p2

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  #ifdef CS333_P3P4
  acquire(&ptable.lock);
  remove_from_list(&ptable.pLists.embryo, p);
  assert_state(p, EMBRYO);
  #endif
  p->state = RUNNABLE;
  #ifdef CS333_P3P4
  // Since it is the first process to be made I directly add to
  // the front of the ready list. Ocurrences after this use the
  // add to ready function.
  #ifndef P4                                                                 // NEW IFNDEF P4
  ptable.pLists.ready = p;
  #else
  ptable.pLists.ready[0] = p;
  #endif
  p->next = 0;
  release(&ptable.lock);
  #endif
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    #ifdef CS333_P3P4
    acquire(&ptable.lock);
    int code = remove_from_list(&ptable.pLists.embryo, np);
    if (code < 0)
      panic("ERROR: Couldn't remove from embryo.");
    assert_state(np, EMBRYO);
    #endif
    np->state = UNUSED;
    #ifdef CS333_P3P4
    int code2 = add_to_list(&ptable.pLists.free, UNUSED, np);
    if (code2 < 0)
      panic("ERROR: Couldn't add process back to free.");
    release(&ptable.lock);
    #endif
    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;
  // I'm pretty sure that this is where we put the uid/gid copy
  np -> uid = proc -> uid; // p2
  np -> gid = proc -> gid; // p2

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));
 
  pid = np->pid;

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.embryo, np);
  assert_state(np, EMBRYO);
  #endif
  np->state = RUNNABLE;
  #ifdef CS333_P3P4
  add_to_ready(np, RUNNABLE);
  #endif
  release(&ptable.lock);
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifndef CS333_P3P4
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

#else
void
exit(void)
{
  struct proc* p;
  int fd;

  if (proc == initproc)
    panic("init exiting");

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++) {
    if(proc->ofile[fd]) {
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Run exit helper to check process parents against the
  // currently running process. 
  exit_helper(&ptable.pLists.embryo);
  #ifndef P4
  exit_helper(&ptable.pLists.ready);
  #else
  for (int i = 0; i < MAX+1; i++)
    exit_helper(&ptable.pLists.ready[i]);
  #endif
  exit_helper(&ptable.pLists.running);
  exit_helper(&ptable.pLists.sleep);

  // Search zombie list separately due to the potential need
  // to wake up initproc as well.
  p = ptable.pLists.zombie;
  while (p) {
    if (p->parent == proc) {
      p->parent = initproc;
      wakeup1(initproc);
    }
    p = p->next;
  }

  remove_from_list(&ptable.pLists.running, proc);
  assert_state(proc, RUNNING);
  proc->state = ZOMBIE;
  add_to_list(&ptable.pLists.zombie, ZOMBIE, proc);
  sched();
  panic("zombie exit");
}
#endif

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifndef CS333_P3P4
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}

#else
int
wait(void)
{
  struct proc* p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;) {
    // Scan through table looking for zombie children
    havekids = 0;

    // Run wait helper function to search each list and check
    // if process parent is the currently running process and
    // set havekids to 1 if that is the case.
    wait_helper(&ptable.pLists.embryo, &havekids);
    #ifndef P4
    wait_helper(&ptable.pLists.ready, &havekids);
    #else
    for (int i = 0; i < MAX+1; i++)
      wait_helper(&ptable.pLists.ready[i], &havekids);
    #endif
    wait_helper(&ptable.pLists.running, &havekids);
    wait_helper(&ptable.pLists.sleep, &havekids);

    // Search zombie list separately due to the potential need
    // to deallocate the process and move it to the free list.
    p = ptable.pLists.zombie;
    while (p) {
      if (p->parent == proc) {
        havekids = 1;
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        remove_from_list(&ptable.pLists.zombie, p);
        assert_state(p, ZOMBIE);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->priority = 0;
        add_to_list(&ptable.pLists.free, UNUSED, p);
        release(&ptable.lock);
        return pid;
      }
      p = p->next;
    }

    // No point waiting if we don't have any children
    if (!havekids || proc->killed) {
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit. (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
#endif

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
#ifndef CS333_P3P4
// original xv6 scheduler. Use if CS333_P3P4 NOT defined.
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
      p->cpu_ticks_in = ticks; // My code p2
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}

#else
void
scheduler(void)
{
  struct proc* p;
  int idle;  // for checking if processor is idle
  #ifdef P4
  uint promo; // Stores ticks value as scheduler runs 
  #endif

  for(;;) {

    // Enable interrupts on this processor.
    sti();
    idle = 1;   // assume idle unless we schedule a process
    
    acquire(&ptable.lock);
    #ifdef P4
    promo = ticks; // Set promo to ticks and check if promo needs to happen
    if (promo == ptable.promote_at_time) {
      //Perform promotion here
      //Increment promote_at_time
      ptable.promote_at_time = ticks + TICKS_TO_PROMOTE;
    }
    #endif    
    
    for (int i = 0; i < MAX+1; i++) {
      p = ptable.pLists.ready[i];                                              // P4 changes
      if(p) {
        remove_from_list(&ptable.pLists.ready[i], p);
        assert_state(p, RUNNABLE);
        idle = 0;  // not idle this timeslice
        proc = p;
        switchuvm(p);
        p->state = RUNNING;
        add_to_list(&ptable.pLists.running, RUNNING, p);
        p->cpu_ticks_in = ticks;  // My code p3
        swtch(&cpu->scheduler, proc->context);
        switchkvm();
    
        // Process is done running for now.
        // It should have changed its p->state before coming back.
        proc = 0; 
      }
    }

    release(&ptable.lock);
    if (idle) {
      sti();
      hlt();
    }
  }
}
#endif

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
#ifndef CS333_P3P4
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in; // My code p2
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}
#else
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in; // My code p2
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.running, proc);
  assert_state(proc, RUNNING);
  #endif
  proc->state = RUNNABLE;
  #ifdef CS333_P3P4
  add_to_ready(proc, RUNNABLE);
  #endif
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
    acquire(&ptable.lock);
    if (lk) release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.running, proc);
  assert_state(proc, RUNNING);
  #endif
  proc->state = SLEEPING;
  #ifdef CS333_P3P4
  add_to_list(&ptable.pLists.sleep, SLEEPING, proc);
  #endif
  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
    release(&ptable.lock);
    if (lk) acquire(lk);
  }
}

//PAGEBREAK!
#ifndef CS333_P3P4
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
  struct proc* p = ptable.pLists.sleep;
  while (p) {
    if (p->chan == chan) {
      remove_from_list(&ptable.pLists.sleep, p);
      assert_state(p, SLEEPING);
      p->state = RUNNABLE;
      add_to_ready(p, RUNNABLE);
    }
    p = p->next;
  }
}
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
#ifndef CS333_P3P4
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

#else
int
kill(int pid)
{
  struct proc* p;

  acquire(&ptable.lock);
  // Search through embryo
  p = ptable.pLists.embryo;
  while (p) {
    if (p->pid == pid) {
      p->killed = 1;
      release(&ptable.lock);
      return 0;
    }
    p = p->next;
  }
  // Search through ready
  for (int i = 0; i < MAX+1; i++) {                 // P4 changes
    p = ptable.pLists.ready[i];
    while (p) {
      if (p->pid == pid) {
        p->killed = 1;
        release(&ptable.lock);
        return 0;
      }
      p = p->next;
    }
  }
  // Search through embryo
  p = ptable.pLists.running;
  while (p) {
    if (p->pid == pid) {
      p->killed = 1;
      release(&ptable.lock);
      return 0;
    }
    p = p->next;
  }
  // Search through embryo
  p = ptable.pLists.sleep;
  while (p) {
    if (p->pid == pid) {
      p->killed = 1;
      remove_from_list(&ptable.pLists.sleep, p);
      assert_state(p, SLEEPING);
      p->state = RUNNABLE;
      add_to_ready(p, RUNNABLE);
      release(&ptable.lock);
      return 0;
    }
    p = p->next;
  }

  release(&ptable.lock);
  return -1;
}
#endif

static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
};


//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  cprintf("%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "Prio", "State", "Elapsed", "CPU", "PCs");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    uint seconds = (ticks - p->start_ticks)/100;
    uint partial_seconds = (ticks - p->start_ticks)%100;
    cprintf("%d\t %s\t %d\t %d\t", p->pid, p->name, p->uid, p->gid);
    if (p->parent)
      cprintf(" %d\t", p->parent->pid);
    else
      cprintf(" %d\t", p->pid);
    cprintf(" %d\t %s\t %d.", p->priority, state, seconds);
    if (partial_seconds < 10)
	cprintf("0");
    cprintf("%d\t", partial_seconds);
    uint cpu_seconds = p->cpu_ticks_total/100;
    uint cpu_partial_seconds = p->cpu_ticks_total%100;
    if (cpu_partial_seconds < 10)
      cprintf("  %d.0%d\t", cpu_seconds, cpu_partial_seconds);
    else
      cprintf("  %d.%d\t", cpu_seconds, cpu_partial_seconds);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

int
getproc_helper(int m, struct uproc* table)
{
  struct proc* p;
  int i = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC] && i < m; p++)
  {
    if (p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING)
    {
      table[i].pid = p->pid;
      table[i].uid = p->uid;
      table[i].gid = p->gid;
      if (p->parent)
        table[i].ppid = p->parent->pid;
      else
        table[i].ppid = p->pid;
      table[i].priority = p->priority;
      table[i].elapsed_ticks = (ticks - p->start_ticks);
      table[i].CPU_total_ticks = p->cpu_ticks_total;
      table[i].size = p->sz;
      strncpy(table[i].state, states[p->state], sizeof(p->state)+1);
      strncpy(table[i].name, p->name, sizeof(p->name)+1);
      i++;
    }
  }
  return i;  
}

// Counts the number of procs in the free list when ctrl-f is pressed
void
free_length(void)
{
  acquire(&ptable.lock);
  struct proc* f = ptable.pLists.free;
  int count = 0;
  if (!f) {
    cprintf("Free List Size: %d\n", count);
    release(&ptable.lock);
  }
  while (f)
  {
    ++count;
    f = f->next;
  }
  cprintf("Free List Size: %d\n", count);
  release(&ptable.lock);
}

// Displays the PIDs of all processes in the ready list
void
display_ready(void)
{
  acquire(&ptable.lock);
  #ifndef P4
  struct proc* r = ptable.pLists.ready;
  if (!r) {
    cprintf("No processes currently in ready.\n");
    release(&ptable.lock);
    return;
  }
  cprintf("Ready List Processes:\n");
  while (r) {
    if (!r->next)
      cprintf("%d\n", r->pid);
    else
      cprintf("%d -> ", r->pid);
    r = r->next;
  }
  #else
  cprintf("Ready List Processes:\n");
  for (int i = 0; i < MAX+1; i++) {
    cprintf("List %d: ", i);
    struct proc* r = ptable.pLists.ready[i];
    if (!r) {
      cprintf("\n");
      continue;
    }
    while (r) {
      if (!r->next)
        cprintf("%d\n", r->pid);
      else
        cprintf("%d -> ", r->pid);
      r = r->next;
    }
  }
  #endif
  release(&ptable.lock);
  return;
}

// Displays the PIDs of all processes in the sleep list
void
display_sleep(void)
{
  acquire(&ptable.lock);
  struct proc* s = ptable.pLists.sleep;
  if (!s) {
    cprintf("No processes currently in sleep.\n");
    release(&ptable.lock);
    return;
  }
  cprintf("Sleep List Processes:\n");
  while (s) {
    if (!s->next)
      cprintf("%d\n", s->pid);
    else
      cprintf("%d -> ", s->pid);
    s = s->next;
  }
  release(&ptable.lock);
  return;
}

// Displays the PID/PPID of processes in the zombie list
void display_zombie(void)
{
  acquire(&ptable.lock);
  struct proc* z = ptable.pLists.zombie;
  if (!z) {
    cprintf("No processes currently in zombie.\n");
    release(&ptable.lock);
    return;
  }
  cprintf("Zombie List Processes(/PPIDs)\n");
  while (z) {
    if (!z->next) {
      cprintf("(%d", z->pid);
      if (z->parent)
        cprintf(", %d)\n", z->parent->pid);
      else
        cprintf(", %d)\n", z->pid);
    }
    else {
      cprintf("(%d", z->pid);
      if (z->parent)
        cprintf(", %d) -> ", z->parent->pid);
      else
        cprintf(", %d) -> ", z->pid);
    }
    z = z->next;
  }
  release(&ptable.lock);
  return;
}

// Implementation of assert_state function
static void
assert_state(struct proc* p, enum procstate state)
{
  if (p->state == state)
    return;
  panic("ERROR: States do not match.");
}

// Implementation of remove_from_list
static int
remove_from_list(struct proc** sList, struct proc* p)
{
  if (!p)
    return -1;
  if (!sList)
    return -1;
  struct proc* curr = *sList;
  struct proc* prev;
  if (p == curr) {
    *sList = p->next;
    p->next = 0;
    return 1;
  }
  while (curr->next) {
    prev = curr;
    curr = curr->next;
    if (p == curr) {
      prev->next = p->next;
      p->next = 0;
      return 1;
    }
  }
  return -1;
}

// Implementation of add_to_list
static int
add_to_list(struct proc** sList, enum procstate state, struct proc* p)
{
  if (!p)
    return -1;
  assert_state(p, state);
  p->next = *sList;
  *sList = p;
  return 0;
}

// Implementation of add_to_ready
static int
add_to_ready(struct proc* p, enum procstate state)
{
  if (!p)
    return -1;
  assert_state(p, state);
  #ifndef P4
  if (!ptable.pLists.ready) {
    p->next = ptable.pLists.ready;
    ptable.pLists.ready = p;
    return 1;
  }
  struct proc* t = ptable.pLists.ready;
  while (t->next)
    t = t->next;
  t->next = p;
  p->next = 0;
  return 0;
  #else                                                   // NEW ADD_TO_READY
  if (!ptable.pLists.ready[p->priority]) {
    p->next = ptable.pLists.ready[p->priority];
    ptable.pLists.ready[p->priority] = p;
    return 1;
  }
  struct proc* t = ptable.pLists.ready[p->priority];
  while (t->next)
    t = t->next;
  t->next = p;
  p->next = 0;
  return 0;
  #endif
}

// Implementation of exit helper function
static void
exit_helper(struct proc** sList)
{
  struct proc* p = *sList;
  while (p) {
    if (p->parent == proc)
      p->parent = initproc;
    p = p->next;
  }
}

// Implementation of wait helper function
static void
wait_helper(struct proc** sList, int* hk)
{
  struct proc* p = *sList;
  while (p) {
    if (p->parent == proc)
      *hk = 1;
    p = p->next;
  }
}

#ifdef P4
// Implementation of helper for set priority system call
int
set_priority(int pid, int priority)
{
  if (pid < 0)
    return -1;
  if (priority < 0 || priority > MAX)
    return -1;

  int hold = holding(&ptable.lock);
  if (!hold) acquire(&ptable.lock);
  if (search_and_set(&ptable.pLists.running, pid, priority) == 0) {
    if (!hold) release(&ptable.lock);
    return 0;
  }
  if (search_and_set(&ptable.pLists.sleep, pid, priority) == 0) {
    if (!hold) release(&ptable.lock);
    return 0;
  }
  if (search_and_set_ready(pid, priority) == 0) {
    if (!hold) release(&ptable.lock);
    return 0;
  }
  if (!hold) release(&ptable.lock);
  return -1; // Failed to find process with PID matching arg pid
}
#endif

#ifdef P4
// Searches a list for a proc with PID pid and sets its priority
// to the value passed in via prio argument
// NEVER USED OUTSIDE OF A LOCKED SECTION OF CODE
static int 
search_and_set(struct proc** sList, int pid, int prio)
{
  if (!sList)
    return -1; // Null list
  struct proc* p = *sList;
  while (p) {
    if (p->pid == pid) {
      if (p->priority == prio)
        return 1; // No change necessary 
      else {
        p->priority = prio;
        return 0; // Success!
      }
    }
    p = p->next;
  }
  return -2; // Not found
}
#endif

#ifdef P4
// Specifically handles the ready list since the process also needs
// to be moved to a different ready queue.
// NEVER USED OUTSIDE OF A LOCKED SECTION OF CODE
static int
search_and_set_ready(int pid, int prio)
{
  for (int i = 0; i < MAX+1; i++) {
    if (!ptable.pLists.ready[i])
      continue;
    struct proc* p = ptable.pLists.ready[i];
    while (p) {
      if (p->pid == pid) {
        if (p->priority == prio)
          return -1; // No changes need to be made since prio already matches
        else {
          p->priority = prio;
          remove_from_list(&ptable.pLists.ready[i], p);
          assert_state(p, RUNNABLE);
          add_to_ready(p, RUNNABLE);
          return 0;
        }
      }
      p = p->next;  
    }
  }
  return -1;
}
#endif














