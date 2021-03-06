#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "syscall.h"

// User code makes a system call with INT T_SYSCALL.
// System call number in %eax.
// Arguments on the stack, from the user call to the C
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
  return 0;
}

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
}

// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}

extern int sys_chdir(void);
extern int sys_close(void);
extern int sys_dup(void);
extern int sys_exec(void);
extern int sys_exit(void);
extern int sys_fork(void);
extern int sys_fstat(void);
extern int sys_getpid(void);
extern int sys_kill(void);
extern int sys_link(void);
extern int sys_mkdir(void);
extern int sys_mknod(void);
extern int sys_open(void);
extern int sys_pipe(void);
extern int sys_read(void);
extern int sys_sbrk(void);
extern int sys_sleep(void);
extern int sys_unlink(void);
extern int sys_wait(void);
extern int sys_write(void);
extern int sys_uptime(void);
extern int sys_halt(void);
extern int sys_date(void);        // p1
extern int sys_getuid(void);      // p2
extern int sys_getgid(void);      // p2
extern int sys_getppid(void);     // p2
extern int sys_setuid(void);      // p2
extern int sys_setgid(void);      // p2
extern int sys_getprocs(void);    // p2
extern int sys_setpriority(void); // p4
extern int sys_chmod(void);       // p5
extern int sys_chown(void);       // p5
extern int sys_chgrp(void);       // p5

static int (*syscalls[])(void) = {
[SYS_fork]        sys_fork,
[SYS_exit]        sys_exit,
[SYS_wait]        sys_wait,
[SYS_pipe]        sys_pipe,
[SYS_read]        sys_read,
[SYS_kill]        sys_kill,
[SYS_exec]        sys_exec,
[SYS_fstat]       sys_fstat,
[SYS_chdir]       sys_chdir,
[SYS_dup]         sys_dup,
[SYS_getpid]      sys_getpid,
[SYS_sbrk]        sys_sbrk,
[SYS_sleep]       sys_sleep,
[SYS_uptime]      sys_uptime,
[SYS_open]        sys_open,
[SYS_write]       sys_write,
[SYS_mknod]       sys_mknod,
[SYS_unlink]      sys_unlink,
[SYS_link]        sys_link,
[SYS_mkdir]       sys_mkdir,
[SYS_close]       sys_close,
[SYS_halt]        sys_halt,
[SYS_date]        sys_date,        // p1
[SYS_getuid]      sys_getuid,      // p2
[SYS_getgid]      sys_getgid,      // p2
[SYS_getppid]     sys_getppid,     // p2
[SYS_setuid]      sys_setuid,      // p2
[SYS_setgid]      sys_setgid,      // p2
[SYS_getprocs]    sys_getprocs,    // p2
[SYS_setpriority] sys_setpriority, // p4
[SYS_chmod]       sys_chmod,       // p5
[SYS_chown]       sys_chown,       // p5
[SYS_chgrp]       sys_chgrp,       // p5
};

// put data structure for printing out system call invocation information here
#ifdef PRINT_SYSCALLS
static char *syscallnames[] = {
[SYS_fork]        "fork",
[SYS_exit]        "exit",
[SYS_wait]        "wait",
[SYS_pipe]        "pipe",
[SYS_read]        "read",
[SYS_kill]        "kill",
[SYS_exec]        "exec",
[SYS_fstat]       "fstat",
[SYS_chdir]       "chdir",
[SYS_dup]         "dup",
[SYS_getpid]      "getpid",
[SYS_sbrk]        "sbrk",
[SYS_sleep]       "sleep",
[SYS_uptime]      "uptime",
[SYS_open]        "open",
[SYS_write]       "write",
[SYS_mknod]       "mknod",
[SYS_unlink]      "unlink",
[SYS_link]        "link",
[SYS_mkdir]       "mkdir",
[SYS_close]       "close",
[SYS_halt]        "halt",
[SYS_date]        "date",        // p1
[SYS_getuid]      "getuid",      // p2
[SYS_getgid]      "getgid",      // p2
[SYS_getppid]     "getppid",     // p2
[SYS_setuid]      "setuid",      // p2
[SYS_setgid]      "setgid",      // p2
[SYS_getprocs]    "getprocs",    // p2
[SYS_setpriority] "setpriority", // p4
[SYS_chmod]       "chmod",       // p5
[SYS_chown]       "chown",       // p5
[SYS_chgrp]       "chgrp",       // p5
};
#endif 

void
syscall(void)
{
  int num;

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
// some code goes here
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
