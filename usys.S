#include "syscall.h"
#include "traps.h"

#define SYSCALL(name) \
  .globl name; \
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
SYSCALL(exit)
SYSCALL(wait)
SYSCALL(pipe)
SYSCALL(read)
SYSCALL(write)
SYSCALL(close)
SYSCALL(kill)
SYSCALL(exec)
SYSCALL(open)
SYSCALL(mknod)
SYSCALL(unlink)
SYSCALL(fstat)
SYSCALL(link)
SYSCALL(mkdir)
SYSCALL(chdir)
SYSCALL(dup)
SYSCALL(getpid)
SYSCALL(sbrk)
SYSCALL(sleep)
SYSCALL(uptime)
SYSCALL(halt)
SYSCALL(date)        #p1
SYSCALL(getuid)      #p2
SYSCALL(getgid)      #p2
SYSCALL(getppid)     #p2
SYSCALL(setuid)      #p2
SYSCALL(setgid)      #p2
SYSCALL(getprocs)    #p2
SYSCALL(setpriority) #p4
SYSCALL(chmod)       #p5
SYSCALL(chown)       #p5
SYSCALL(chgrp)       #p5
