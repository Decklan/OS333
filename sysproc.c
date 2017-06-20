#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "uproc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
}

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
  uint xticks;
  
  xticks = ticks;
  return xticks;
}

//Turn of the computer
int sys_halt(void){
  cprintf("Shutting down ...\n");
// outw (0xB004, 0x0 | 0x2000);  // changed in newest version of QEMU
  outw( 0x604, 0x0 | 0x2000);
  return 0;
}

// My implementation of sys_date()
int
sys_date(void)
{
  struct rtcdate *d;

  if (argptr(0, (void*)&d, sizeof(*d)) < 0)
    return -1;
  // MY CODE HERE
  cmostime(d);       
  return 0; 
}

// My implementation of sys_getuid
uint
sys_getuid(void)
{
  return proc->uid;
}

// My implementation of sys_getgid
uint
sys_getgid(void)
{
  return proc->gid;
}

// My implementation of sys_getppid
uint
sys_getppid(void)
{
  return proc->parent ? proc->parent->pid : proc->pid;
}


// Implementation of sys_setuid
int 
sys_setuid(void)
{
  int id; // uid argument
  // Grab argument off the stack and store in id
  if(argint(0, &id) < 0)
    return -1;
  if(id < 0 || id > 32767)
    return -1;
  proc->uid = id; 
  return 0;
}

// Implementation of sys_setgid
int
sys_setgid(void)
{
  int id; // gid argument 
  // Grab argument off the stack and store in id
  if(argint(0, &id) < 0)
    return -1;
  if(id < 0 || id > 32767)
    return -1;
  proc->gid = id;
  return 0;
}

// Implementation of sys_getprocs
int
sys_getprocs(void)
{
  int m; // Max arg
  struct uproc* table;
  if(argint(0, &m) < 0)
    return -1;
  if (m < 0)
    return -1;
  if(argptr(1, (void*)&table, m) < 0)
    return -1;
  return getproc_helper(m, table);
}

#ifdef CS333_P3P4
// Implementation of sys_setpriority
int
sys_setpriority(void)
{
  int pid;
  int prio;

  if(argint(0, &pid) < 0)
    return -1;
  if(argint(1, &prio) < 0)
    return -1;
  return set_priority(pid, prio);
}
#endif








