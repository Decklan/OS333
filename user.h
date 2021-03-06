struct stat;
struct rtcdate;
struct uproc; // p2

// system calls
int fork(void);
int exit(void) __attribute__((noreturn));
int wait(void);
int pipe(int*);
int write(int, void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(char*, char**);
int open(char*, int);
int mknod(char*, short, short);
int unlink(char*);
int fstat(int fd, struct stat*);
int link(char*, char*);
int mkdir(char*);
int chdir(char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);
int halt(void);
int date(struct rtcdate*);                   // p1
uint getuid(void);                           // p2
uint getgid(void);                           // p2
uint getppid(void);                          // p2
int setuid(uint);                            // p2
int setgid(uint);                            // p2
int getprocs(uint max, struct uproc* table); // p2
int setpriority(int pid, int priority);      // p4
int chmod(char *pathname, int mode);         // p5
int chown(char *pathname, int owner);        // p5
int chgrp(char *pathname, int owner);        // p5

// ulib.c
int stat(char*, struct stat*);
char* strcpy(char*, char*);
void *memmove(void*, void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void printf(int, char*, ...);
char* gets(char*, int max);
uint strlen(char*);
void* memset(void*, int, uint);
void* malloc(uint);
void free(void*);
int atoi(const char*);
