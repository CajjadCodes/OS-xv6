
_showInfo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char* argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
	showInfo();
   6:	e8 18 03 00 00       	call   323 <showInfo>
	exit();
   b:	e8 53 02 00 00       	call   263 <exit>

00000010 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  10:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  11:	31 c0                	xor    %eax,%eax
{
  13:	89 e5                	mov    %esp,%ebp
  15:	53                   	push   %ebx
  16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  19:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  20:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  24:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  27:	83 c0 01             	add    $0x1,%eax
  2a:	84 d2                	test   %dl,%dl
  2c:	75 f2                	jne    20 <strcpy+0x10>
    ;
  return os;
}
  2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  31:	89 c8                	mov    %ecx,%eax
  33:	c9                   	leave  
  34:	c3                   	ret    
  35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000040 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	53                   	push   %ebx
  44:	8b 4d 08             	mov    0x8(%ebp),%ecx
  47:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  4a:	0f b6 01             	movzbl (%ecx),%eax
  4d:	0f b6 1a             	movzbl (%edx),%ebx
  50:	84 c0                	test   %al,%al
  52:	75 1d                	jne    71 <strcmp+0x31>
  54:	eb 2a                	jmp    80 <strcmp+0x40>
  56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  5d:	8d 76 00             	lea    0x0(%esi),%esi
  60:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
  64:	83 c1 01             	add    $0x1,%ecx
  67:	83 c2 01             	add    $0x1,%edx
  return (uchar)*p - (uchar)*q;
  6a:	0f b6 1a             	movzbl (%edx),%ebx
  while(*p && *p == *q)
  6d:	84 c0                	test   %al,%al
  6f:	74 0f                	je     80 <strcmp+0x40>
  71:	38 d8                	cmp    %bl,%al
  73:	74 eb                	je     60 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
  75:	29 d8                	sub    %ebx,%eax
}
  77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  7a:	c9                   	leave  
  7b:	c3                   	ret    
  7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  80:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  82:	29 d8                	sub    %ebx,%eax
}
  84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  87:	c9                   	leave  
  88:	c3                   	ret    
  89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000090 <strlen>:

uint
strlen(const char *s)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  96:	80 3a 00             	cmpb   $0x0,(%edx)
  99:	74 15                	je     b0 <strlen+0x20>
  9b:	31 c0                	xor    %eax,%eax
  9d:	8d 76 00             	lea    0x0(%esi),%esi
  a0:	83 c0 01             	add    $0x1,%eax
  a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  a7:	89 c1                	mov    %eax,%ecx
  a9:	75 f5                	jne    a0 <strlen+0x10>
    ;
  return n;
}
  ab:	89 c8                	mov    %ecx,%eax
  ad:	5d                   	pop    %ebp
  ae:	c3                   	ret    
  af:	90                   	nop
  for(n = 0; s[n]; n++)
  b0:	31 c9                	xor    %ecx,%ecx
}
  b2:	5d                   	pop    %ebp
  b3:	89 c8                	mov    %ecx,%eax
  b5:	c3                   	ret    
  b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bd:	8d 76 00             	lea    0x0(%esi),%esi

000000c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
  c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	89 d7                	mov    %edx,%edi
  cf:	fc                   	cld    
  d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  d5:	89 d0                	mov    %edx,%eax
  d7:	c9                   	leave  
  d8:	c3                   	ret    
  d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000000e0 <strchr>:

char*
strchr(const char *s, char c)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  ea:	0f b6 10             	movzbl (%eax),%edx
  ed:	84 d2                	test   %dl,%dl
  ef:	75 12                	jne    103 <strchr+0x23>
  f1:	eb 1d                	jmp    110 <strchr+0x30>
  f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f7:	90                   	nop
  f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  fc:	83 c0 01             	add    $0x1,%eax
  ff:	84 d2                	test   %dl,%dl
 101:	74 0d                	je     110 <strchr+0x30>
    if(*s == c)
 103:	38 d1                	cmp    %dl,%cl
 105:	75 f1                	jne    f8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    
 109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 110:	31 c0                	xor    %eax,%eax
}
 112:	5d                   	pop    %ebp
 113:	c3                   	ret    
 114:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 11f:	90                   	nop

00000120 <gets>:

char*
gets(char *buf, int max)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 125:	31 f6                	xor    %esi,%esi
{
 127:	53                   	push   %ebx
 128:	89 f3                	mov    %esi,%ebx
 12a:	83 ec 1c             	sub    $0x1c,%esp
 12d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 130:	eb 2f                	jmp    161 <gets+0x41>
 132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 138:	83 ec 04             	sub    $0x4,%esp
 13b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 13e:	6a 01                	push   $0x1
 140:	50                   	push   %eax
 141:	6a 00                	push   $0x0
 143:	e8 33 01 00 00       	call   27b <read>
    if(cc < 1)
 148:	83 c4 10             	add    $0x10,%esp
 14b:	85 c0                	test   %eax,%eax
 14d:	7e 1c                	jle    16b <gets+0x4b>
      break;
    buf[i++] = c;
 14f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    if(c == '\n' || c == '\r')
 153:	83 c7 01             	add    $0x1,%edi
    buf[i++] = c;
 156:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 159:	3c 0a                	cmp    $0xa,%al
 15b:	74 23                	je     180 <gets+0x60>
 15d:	3c 0d                	cmp    $0xd,%al
 15f:	74 1f                	je     180 <gets+0x60>
  for(i=0; i+1 < max; ){
 161:	83 c3 01             	add    $0x1,%ebx
    buf[i++] = c;
 164:	89 fe                	mov    %edi,%esi
  for(i=0; i+1 < max; ){
 166:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 169:	7c cd                	jl     138 <gets+0x18>
 16b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 170:	c6 03 00             	movb   $0x0,(%ebx)
}
 173:	8d 65 f4             	lea    -0xc(%ebp),%esp
 176:	5b                   	pop    %ebx
 177:	5e                   	pop    %esi
 178:	5f                   	pop    %edi
 179:	5d                   	pop    %ebp
 17a:	c3                   	ret    
 17b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 17f:	90                   	nop
  buf[i] = '\0';
 180:	8b 75 08             	mov    0x8(%ebp),%esi
}
 183:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 186:	01 de                	add    %ebx,%esi
 188:	89 f3                	mov    %esi,%ebx
 18a:	c6 03 00             	movb   $0x0,(%ebx)
}
 18d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 190:	5b                   	pop    %ebx
 191:	5e                   	pop    %esi
 192:	5f                   	pop    %edi
 193:	5d                   	pop    %ebp
 194:	c3                   	ret    
 195:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	56                   	push   %esi
 1a4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a5:	83 ec 08             	sub    $0x8,%esp
 1a8:	6a 00                	push   $0x0
 1aa:	ff 75 08             	pushl  0x8(%ebp)
 1ad:	e8 f1 00 00 00       	call   2a3 <open>
  if(fd < 0)
 1b2:	83 c4 10             	add    $0x10,%esp
 1b5:	85 c0                	test   %eax,%eax
 1b7:	78 27                	js     1e0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 1b9:	83 ec 08             	sub    $0x8,%esp
 1bc:	ff 75 0c             	pushl  0xc(%ebp)
 1bf:	89 c3                	mov    %eax,%ebx
 1c1:	50                   	push   %eax
 1c2:	e8 f4 00 00 00       	call   2bb <fstat>
  close(fd);
 1c7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1ca:	89 c6                	mov    %eax,%esi
  close(fd);
 1cc:	e8 ba 00 00 00       	call   28b <close>
  return r;
 1d1:	83 c4 10             	add    $0x10,%esp
}
 1d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1d7:	89 f0                	mov    %esi,%eax
 1d9:	5b                   	pop    %ebx
 1da:	5e                   	pop    %esi
 1db:	5d                   	pop    %ebp
 1dc:	c3                   	ret    
 1dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1e5:	eb ed                	jmp    1d4 <stat+0x34>
 1e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ee:	66 90                	xchg   %ax,%ax

000001f0 <atoi>:

int
atoi(const char *s)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	53                   	push   %ebx
 1f4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f7:	0f be 02             	movsbl (%edx),%eax
 1fa:	8d 48 d0             	lea    -0x30(%eax),%ecx
 1fd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 200:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 205:	77 1e                	ja     225 <atoi+0x35>
 207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 210:	83 c2 01             	add    $0x1,%edx
 213:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 216:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 21a:	0f be 02             	movsbl (%edx),%eax
 21d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 220:	80 fb 09             	cmp    $0x9,%bl
 223:	76 eb                	jbe    210 <atoi+0x20>
  return n;
}
 225:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 228:	89 c8                	mov    %ecx,%eax
 22a:	c9                   	leave  
 22b:	c3                   	ret    
 22c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000230 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	57                   	push   %edi
 234:	8b 45 10             	mov    0x10(%ebp),%eax
 237:	8b 55 08             	mov    0x8(%ebp),%edx
 23a:	56                   	push   %esi
 23b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 23e:	85 c0                	test   %eax,%eax
 240:	7e 13                	jle    255 <memmove+0x25>
 242:	01 d0                	add    %edx,%eax
  dst = vdst;
 244:	89 d7                	mov    %edx,%edi
 246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 250:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 251:	39 f8                	cmp    %edi,%eax
 253:	75 fb                	jne    250 <memmove+0x20>
  return vdst;
}
 255:	5e                   	pop    %esi
 256:	89 d0                	mov    %edx,%eax
 258:	5f                   	pop    %edi
 259:	5d                   	pop    %ebp
 25a:	c3                   	ret    

0000025b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 25b:	b8 01 00 00 00       	mov    $0x1,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret    

00000263 <exit>:
SYSCALL(exit)
 263:	b8 02 00 00 00       	mov    $0x2,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret    

0000026b <wait>:
SYSCALL(wait)
 26b:	b8 03 00 00 00       	mov    $0x3,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <pipe>:
SYSCALL(pipe)
 273:	b8 04 00 00 00       	mov    $0x4,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <read>:
SYSCALL(read)
 27b:	b8 05 00 00 00       	mov    $0x5,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <write>:
SYSCALL(write)
 283:	b8 10 00 00 00       	mov    $0x10,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <close>:
SYSCALL(close)
 28b:	b8 15 00 00 00       	mov    $0x15,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <kill>:
SYSCALL(kill)
 293:	b8 06 00 00 00       	mov    $0x6,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <exec>:
SYSCALL(exec)
 29b:	b8 07 00 00 00       	mov    $0x7,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <open>:
SYSCALL(open)
 2a3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <mknod>:
SYSCALL(mknod)
 2ab:	b8 11 00 00 00       	mov    $0x11,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <unlink>:
SYSCALL(unlink)
 2b3:	b8 12 00 00 00       	mov    $0x12,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <fstat>:
SYSCALL(fstat)
 2bb:	b8 08 00 00 00       	mov    $0x8,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <link>:
SYSCALL(link)
 2c3:	b8 13 00 00 00       	mov    $0x13,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <mkdir>:
SYSCALL(mkdir)
 2cb:	b8 14 00 00 00       	mov    $0x14,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <chdir>:
SYSCALL(chdir)
 2d3:	b8 09 00 00 00       	mov    $0x9,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <dup>:
SYSCALL(dup)
 2db:	b8 0a 00 00 00       	mov    $0xa,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <getpid>:
SYSCALL(getpid)
 2e3:	b8 0b 00 00 00       	mov    $0xb,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <sbrk>:
SYSCALL(sbrk)
 2eb:	b8 0c 00 00 00       	mov    $0xc,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <sleep>:
SYSCALL(sleep)
 2f3:	b8 0d 00 00 00       	mov    $0xd,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <uptime>:
SYSCALL(uptime)
 2fb:	b8 0e 00 00 00       	mov    $0xe,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <changeQueue>:
SYSCALL(changeQueue)
 303:	b8 16 00 00 00       	mov    $0x16,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <setTicket>:
SYSCALL(setTicket)
 30b:	b8 17 00 00 00       	mov    $0x17,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <setProcessParameters>:
SYSCALL(setProcessParameters)
 313:	b8 18 00 00 00       	mov    $0x18,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <setSystemParameters>:
SYSCALL(setSystemParameters)
 31b:	b8 19 00 00 00       	mov    $0x19,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <showInfo>:
SYSCALL(showInfo)
 323:	b8 1a 00 00 00       	mov    $0x1a,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    
 32b:	66 90                	xchg   %ax,%ax
 32d:	66 90                	xchg   %ax,%ax
 32f:	90                   	nop

00000330 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	57                   	push   %edi
 334:	56                   	push   %esi
 335:	53                   	push   %ebx
 336:	83 ec 3c             	sub    $0x3c,%esp
 339:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 33c:	89 d1                	mov    %edx,%ecx
{
 33e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 341:	85 d2                	test   %edx,%edx
 343:	0f 89 7f 00 00 00    	jns    3c8 <printint+0x98>
 349:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 34d:	74 79                	je     3c8 <printint+0x98>
    neg = 1;
 34f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 356:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 358:	31 db                	xor    %ebx,%ebx
 35a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 35d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 360:	89 c8                	mov    %ecx,%eax
 362:	31 d2                	xor    %edx,%edx
 364:	89 cf                	mov    %ecx,%edi
 366:	f7 75 c4             	divl   -0x3c(%ebp)
 369:	0f b6 92 50 07 00 00 	movzbl 0x750(%edx),%edx
 370:	89 45 c0             	mov    %eax,-0x40(%ebp)
 373:	89 d8                	mov    %ebx,%eax
 375:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 378:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 37b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 37e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 381:	76 dd                	jbe    360 <printint+0x30>
  if(neg)
 383:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 386:	85 c9                	test   %ecx,%ecx
 388:	74 0c                	je     396 <printint+0x66>
    buf[i++] = '-';
 38a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 38f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 391:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 396:	8b 7d b8             	mov    -0x48(%ebp),%edi
 399:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 39d:	eb 07                	jmp    3a6 <printint+0x76>
 39f:	90                   	nop
    putc(fd, buf[i]);
 3a0:	0f b6 13             	movzbl (%ebx),%edx
 3a3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 3a6:	83 ec 04             	sub    $0x4,%esp
 3a9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 3ac:	6a 01                	push   $0x1
 3ae:	56                   	push   %esi
 3af:	57                   	push   %edi
 3b0:	e8 ce fe ff ff       	call   283 <write>
  while(--i >= 0)
 3b5:	83 c4 10             	add    $0x10,%esp
 3b8:	39 de                	cmp    %ebx,%esi
 3ba:	75 e4                	jne    3a0 <printint+0x70>
}
 3bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3bf:	5b                   	pop    %ebx
 3c0:	5e                   	pop    %esi
 3c1:	5f                   	pop    %edi
 3c2:	5d                   	pop    %ebp
 3c3:	c3                   	ret    
 3c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 3c8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 3cf:	eb 87                	jmp    358 <printint+0x28>
 3d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3df:	90                   	nop

000003e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	56                   	push   %esi
 3e5:	53                   	push   %ebx
 3e6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3e9:	8b 75 0c             	mov    0xc(%ebp),%esi
 3ec:	0f b6 1e             	movzbl (%esi),%ebx
 3ef:	84 db                	test   %bl,%bl
 3f1:	0f 84 b8 00 00 00    	je     4af <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 3f7:	8d 45 10             	lea    0x10(%ebp),%eax
 3fa:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 3fd:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 400:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 402:	89 45 d0             	mov    %eax,-0x30(%ebp)
 405:	eb 37                	jmp    43e <printf+0x5e>
 407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 40e:	66 90                	xchg   %ax,%ax
 410:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 413:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 418:	83 f8 25             	cmp    $0x25,%eax
 41b:	74 17                	je     434 <printf+0x54>
  write(fd, &c, 1);
 41d:	83 ec 04             	sub    $0x4,%esp
 420:	88 5d e7             	mov    %bl,-0x19(%ebp)
 423:	6a 01                	push   $0x1
 425:	57                   	push   %edi
 426:	ff 75 08             	pushl  0x8(%ebp)
 429:	e8 55 fe ff ff       	call   283 <write>
 42e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 431:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 434:	0f b6 1e             	movzbl (%esi),%ebx
 437:	83 c6 01             	add    $0x1,%esi
 43a:	84 db                	test   %bl,%bl
 43c:	74 71                	je     4af <printf+0xcf>
    c = fmt[i] & 0xff;
 43e:	0f be cb             	movsbl %bl,%ecx
 441:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 444:	85 d2                	test   %edx,%edx
 446:	74 c8                	je     410 <printf+0x30>
      }
    } else if(state == '%'){
 448:	83 fa 25             	cmp    $0x25,%edx
 44b:	75 e7                	jne    434 <printf+0x54>
      if(c == 'd'){
 44d:	83 f8 64             	cmp    $0x64,%eax
 450:	0f 84 9a 00 00 00    	je     4f0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 456:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 45c:	83 f9 70             	cmp    $0x70,%ecx
 45f:	74 5f                	je     4c0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 461:	83 f8 73             	cmp    $0x73,%eax
 464:	0f 84 d6 00 00 00    	je     540 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 46a:	83 f8 63             	cmp    $0x63,%eax
 46d:	0f 84 8d 00 00 00    	je     500 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 473:	83 f8 25             	cmp    $0x25,%eax
 476:	0f 84 b4 00 00 00    	je     530 <printf+0x150>
  write(fd, &c, 1);
 47c:	83 ec 04             	sub    $0x4,%esp
 47f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 483:	6a 01                	push   $0x1
 485:	57                   	push   %edi
 486:	ff 75 08             	pushl  0x8(%ebp)
 489:	e8 f5 fd ff ff       	call   283 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 48e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 491:	83 c4 0c             	add    $0xc,%esp
 494:	6a 01                	push   $0x1
  for(i = 0; fmt[i]; i++){
 496:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 499:	57                   	push   %edi
 49a:	ff 75 08             	pushl  0x8(%ebp)
 49d:	e8 e1 fd ff ff       	call   283 <write>
  for(i = 0; fmt[i]; i++){
 4a2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 4a6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 4a9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 4ab:	84 db                	test   %bl,%bl
 4ad:	75 8f                	jne    43e <printf+0x5e>
    }
  }
}
 4af:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b2:	5b                   	pop    %ebx
 4b3:	5e                   	pop    %esi
 4b4:	5f                   	pop    %edi
 4b5:	5d                   	pop    %ebp
 4b6:	c3                   	ret    
 4b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4be:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 4c0:	83 ec 0c             	sub    $0xc,%esp
 4c3:	b9 10 00 00 00       	mov    $0x10,%ecx
 4c8:	6a 00                	push   $0x0
 4ca:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4cd:	8b 45 08             	mov    0x8(%ebp),%eax
 4d0:	8b 13                	mov    (%ebx),%edx
 4d2:	e8 59 fe ff ff       	call   330 <printint>
        ap++;
 4d7:	89 d8                	mov    %ebx,%eax
 4d9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4dc:	31 d2                	xor    %edx,%edx
        ap++;
 4de:	83 c0 04             	add    $0x4,%eax
 4e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4e4:	e9 4b ff ff ff       	jmp    434 <printf+0x54>
 4e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 4f0:	83 ec 0c             	sub    $0xc,%esp
 4f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4f8:	6a 01                	push   $0x1
 4fa:	eb ce                	jmp    4ca <printf+0xea>
 4fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 500:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 503:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 506:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 508:	6a 01                	push   $0x1
        ap++;
 50a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 50d:	57                   	push   %edi
 50e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 511:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 514:	e8 6a fd ff ff       	call   283 <write>
        ap++;
 519:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 51c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 51f:	31 d2                	xor    %edx,%edx
 521:	e9 0e ff ff ff       	jmp    434 <printf+0x54>
 526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 530:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 533:	83 ec 04             	sub    $0x4,%esp
 536:	e9 59 ff ff ff       	jmp    494 <printf+0xb4>
 53b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 53f:	90                   	nop
        s = (char*)*ap;
 540:	8b 45 d0             	mov    -0x30(%ebp),%eax
 543:	8b 18                	mov    (%eax),%ebx
        ap++;
 545:	83 c0 04             	add    $0x4,%eax
 548:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 54b:	85 db                	test   %ebx,%ebx
 54d:	74 17                	je     566 <printf+0x186>
        while(*s != 0){
 54f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 552:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 554:	84 c0                	test   %al,%al
 556:	0f 84 d8 fe ff ff    	je     434 <printf+0x54>
 55c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 55f:	89 de                	mov    %ebx,%esi
 561:	8b 5d 08             	mov    0x8(%ebp),%ebx
 564:	eb 1a                	jmp    580 <printf+0x1a0>
          s = "(null)";
 566:	bb 48 07 00 00       	mov    $0x748,%ebx
        while(*s != 0){
 56b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 56e:	b8 28 00 00 00       	mov    $0x28,%eax
 573:	89 de                	mov    %ebx,%esi
 575:	8b 5d 08             	mov    0x8(%ebp),%ebx
 578:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 57f:	90                   	nop
  write(fd, &c, 1);
 580:	83 ec 04             	sub    $0x4,%esp
          s++;
 583:	83 c6 01             	add    $0x1,%esi
 586:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 589:	6a 01                	push   $0x1
 58b:	57                   	push   %edi
 58c:	53                   	push   %ebx
 58d:	e8 f1 fc ff ff       	call   283 <write>
        while(*s != 0){
 592:	0f b6 06             	movzbl (%esi),%eax
 595:	83 c4 10             	add    $0x10,%esp
 598:	84 c0                	test   %al,%al
 59a:	75 e4                	jne    580 <printf+0x1a0>
      state = 0;
 59c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 59f:	31 d2                	xor    %edx,%edx
 5a1:	e9 8e fe ff ff       	jmp    434 <printf+0x54>
 5a6:	66 90                	xchg   %ax,%ax
 5a8:	66 90                	xchg   %ax,%ax
 5aa:	66 90                	xchg   %ax,%ax
 5ac:	66 90                	xchg   %ax,%ax
 5ae:	66 90                	xchg   %ax,%ax

000005b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b1:	a1 ec 09 00 00       	mov    0x9ec,%eax
{
 5b6:	89 e5                	mov    %esp,%ebp
 5b8:	57                   	push   %edi
 5b9:	56                   	push   %esi
 5ba:	53                   	push   %ebx
 5bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 5be:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5c8:	89 c2                	mov    %eax,%edx
 5ca:	8b 00                	mov    (%eax),%eax
 5cc:	39 ca                	cmp    %ecx,%edx
 5ce:	73 30                	jae    600 <free+0x50>
 5d0:	39 c1                	cmp    %eax,%ecx
 5d2:	72 04                	jb     5d8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d4:	39 c2                	cmp    %eax,%edx
 5d6:	72 f0                	jb     5c8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5d8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5db:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5de:	39 f8                	cmp    %edi,%eax
 5e0:	74 30                	je     612 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5e2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 5e5:	8b 42 04             	mov    0x4(%edx),%eax
 5e8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5eb:	39 f1                	cmp    %esi,%ecx
 5ed:	74 3a                	je     629 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5ef:	89 0a                	mov    %ecx,(%edx)
  freep = p;
}
 5f1:	5b                   	pop    %ebx
  freep = p;
 5f2:	89 15 ec 09 00 00    	mov    %edx,0x9ec
}
 5f8:	5e                   	pop    %esi
 5f9:	5f                   	pop    %edi
 5fa:	5d                   	pop    %ebp
 5fb:	c3                   	ret    
 5fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 600:	39 c2                	cmp    %eax,%edx
 602:	72 c4                	jb     5c8 <free+0x18>
 604:	39 c1                	cmp    %eax,%ecx
 606:	73 c0                	jae    5c8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 608:	8b 73 fc             	mov    -0x4(%ebx),%esi
 60b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 60e:	39 f8                	cmp    %edi,%eax
 610:	75 d0                	jne    5e2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 612:	03 70 04             	add    0x4(%eax),%esi
 615:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 618:	8b 02                	mov    (%edx),%eax
 61a:	8b 00                	mov    (%eax),%eax
 61c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 61f:	8b 42 04             	mov    0x4(%edx),%eax
 622:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 625:	39 f1                	cmp    %esi,%ecx
 627:	75 c6                	jne    5ef <free+0x3f>
    p->s.size += bp->s.size;
 629:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 62c:	89 15 ec 09 00 00    	mov    %edx,0x9ec
    p->s.size += bp->s.size;
 632:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 635:	8b 43 f8             	mov    -0x8(%ebx),%eax
 638:	89 02                	mov    %eax,(%edx)
}
 63a:	5b                   	pop    %ebx
 63b:	5e                   	pop    %esi
 63c:	5f                   	pop    %edi
 63d:	5d                   	pop    %ebp
 63e:	c3                   	ret    
 63f:	90                   	nop

00000640 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
 646:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 649:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 64c:	8b 3d ec 09 00 00    	mov    0x9ec,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 652:	8d 70 07             	lea    0x7(%eax),%esi
 655:	c1 ee 03             	shr    $0x3,%esi
 658:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 65b:	85 ff                	test   %edi,%edi
 65d:	0f 84 ad 00 00 00    	je     710 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 663:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 665:	8b 48 04             	mov    0x4(%eax),%ecx
 668:	39 f1                	cmp    %esi,%ecx
 66a:	73 71                	jae    6dd <malloc+0x9d>
 66c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 672:	bb 00 10 00 00       	mov    $0x1000,%ebx
 677:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 67a:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 681:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 684:	eb 1b                	jmp    6a1 <malloc+0x61>
 686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 68d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 690:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 692:	8b 4a 04             	mov    0x4(%edx),%ecx
 695:	39 f1                	cmp    %esi,%ecx
 697:	73 4f                	jae    6e8 <malloc+0xa8>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 699:	8b 3d ec 09 00 00    	mov    0x9ec,%edi
 69f:	89 d0                	mov    %edx,%eax
 6a1:	39 c7                	cmp    %eax,%edi
 6a3:	75 eb                	jne    690 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 6a5:	83 ec 0c             	sub    $0xc,%esp
 6a8:	ff 75 e4             	pushl  -0x1c(%ebp)
 6ab:	e8 3b fc ff ff       	call   2eb <sbrk>
  if(p == (char*)-1)
 6b0:	83 c4 10             	add    $0x10,%esp
 6b3:	83 f8 ff             	cmp    $0xffffffff,%eax
 6b6:	74 1b                	je     6d3 <malloc+0x93>
  hp->s.size = nu;
 6b8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6bb:	83 ec 0c             	sub    $0xc,%esp
 6be:	83 c0 08             	add    $0x8,%eax
 6c1:	50                   	push   %eax
 6c2:	e8 e9 fe ff ff       	call   5b0 <free>
  return freep;
 6c7:	a1 ec 09 00 00       	mov    0x9ec,%eax
      if((p = morecore(nunits)) == 0)
 6cc:	83 c4 10             	add    $0x10,%esp
 6cf:	85 c0                	test   %eax,%eax
 6d1:	75 bd                	jne    690 <malloc+0x50>
        return 0;
  }
}
 6d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 6d6:	31 c0                	xor    %eax,%eax
}
 6d8:	5b                   	pop    %ebx
 6d9:	5e                   	pop    %esi
 6da:	5f                   	pop    %edi
 6db:	5d                   	pop    %ebp
 6dc:	c3                   	ret    
    if(p->s.size >= nunits){
 6dd:	89 c2                	mov    %eax,%edx
 6df:	89 f8                	mov    %edi,%eax
 6e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 6e8:	39 ce                	cmp    %ecx,%esi
 6ea:	74 54                	je     740 <malloc+0x100>
        p->s.size -= nunits;
 6ec:	29 f1                	sub    %esi,%ecx
 6ee:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 6f1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 6f4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 6f7:	a3 ec 09 00 00       	mov    %eax,0x9ec
}
 6fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 6ff:	8d 42 08             	lea    0x8(%edx),%eax
}
 702:	5b                   	pop    %ebx
 703:	5e                   	pop    %esi
 704:	5f                   	pop    %edi
 705:	5d                   	pop    %ebp
 706:	c3                   	ret    
 707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 70e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 710:	c7 05 ec 09 00 00 f0 	movl   $0x9f0,0x9ec
 717:	09 00 00 
    base.s.size = 0;
 71a:	bf f0 09 00 00       	mov    $0x9f0,%edi
    base.s.ptr = freep = prevp = &base;
 71f:	c7 05 f0 09 00 00 f0 	movl   $0x9f0,0x9f0
 726:	09 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 729:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 72b:	c7 05 f4 09 00 00 00 	movl   $0x0,0x9f4
 732:	00 00 00 
    if(p->s.size >= nunits){
 735:	e9 32 ff ff ff       	jmp    66c <malloc+0x2c>
 73a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 740:	8b 0a                	mov    (%edx),%ecx
 742:	89 08                	mov    %ecx,(%eax)
 744:	eb b1                	jmp    6f7 <malloc+0xb7>
