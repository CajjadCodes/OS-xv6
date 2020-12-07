
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 68 08 00 00       	push   $0x868
  19:	e8 a5 03 00 00       	call   3c3 <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	0f 88 df 00 00 00    	js     108 <main+0x108>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 00                	push   $0x0
  2e:	e8 c8 03 00 00       	call   3fb <dup>
  dup(0);  // stderr
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 bc 03 00 00       	call   3fb <dup>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(;;){
    printf(1, "init: starting sh\n");
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	68 70 08 00 00       	push   $0x870
  50:	6a 01                	push   $0x1
  52:	e8 a9 04 00 00       	call   500 <printf>
    printf(1,"Group Members:\n");
  57:	58                   	pop    %eax
  58:	5a                   	pop    %edx
  59:	68 83 08 00 00       	push   $0x883
  5e:	6a 01                	push   $0x1
  60:	e8 9b 04 00 00       	call   500 <printf>
    printf(1,"Mohammad Azimpour\n");
  65:	59                   	pop    %ecx
  66:	5b                   	pop    %ebx
  67:	68 93 08 00 00       	push   $0x893
  6c:	6a 01                	push   $0x1
  6e:	e8 8d 04 00 00       	call   500 <printf>
    printf(1,"Amirali Ataei Naeini\n");
  73:	58                   	pop    %eax
  74:	5a                   	pop    %edx
  75:	68 a6 08 00 00       	push   $0x8a6
  7a:	6a 01                	push   $0x1
  7c:	e8 7f 04 00 00       	call   500 <printf>
    printf(1,"Sajjad Gandom Malmiri\n");
  81:	59                   	pop    %ecx
  82:	5b                   	pop    %ebx
  83:	68 bc 08 00 00       	push   $0x8bc
  88:	6a 01                	push   $0x1
  8a:	e8 71 04 00 00       	call   500 <printf>
    printf(1, "init: starting sh\n");
  8f:	58                   	pop    %eax
  90:	5a                   	pop    %edx
  91:	68 70 08 00 00       	push   $0x870
  96:	6a 01                	push   $0x1
  98:	e8 63 04 00 00       	call   500 <printf>
    
    pid = fork();
  9d:	e8 d9 02 00 00       	call   37b <fork>
    if(pid < 0){
  a2:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  a5:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  a7:	85 c0                	test   %eax,%eax
  a9:	78 26                	js     d1 <main+0xd1>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  ab:	74 37                	je     e4 <main+0xe4>
  ad:	8d 76 00             	lea    0x0(%esi),%esi
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  b0:	e8 d6 02 00 00       	call   38b <wait>
  b5:	85 c0                	test   %eax,%eax
  b7:	78 8f                	js     48 <main+0x48>
  b9:	39 c3                	cmp    %eax,%ebx
  bb:	74 8b                	je     48 <main+0x48>
      printf(1, "zombie!\n");
  bd:	83 ec 08             	sub    $0x8,%esp
  c0:	68 ff 08 00 00       	push   $0x8ff
  c5:	6a 01                	push   $0x1
  c7:	e8 34 04 00 00       	call   500 <printf>
  cc:	83 c4 10             	add    $0x10,%esp
  cf:	eb df                	jmp    b0 <main+0xb0>
      printf(1, "init: fork failed\n");
  d1:	53                   	push   %ebx
  d2:	53                   	push   %ebx
  d3:	68 d3 08 00 00       	push   $0x8d3
  d8:	6a 01                	push   $0x1
  da:	e8 21 04 00 00       	call   500 <printf>
      exit();
  df:	e8 9f 02 00 00       	call   383 <exit>
      exec("sh", argv);
  e4:	50                   	push   %eax
  e5:	50                   	push   %eax
  e6:	68 b8 0b 00 00       	push   $0xbb8
  eb:	68 e6 08 00 00       	push   $0x8e6
  f0:	e8 c6 02 00 00       	call   3bb <exec>
      printf(1, "init: exec sh failed\n");
  f5:	5a                   	pop    %edx
  f6:	59                   	pop    %ecx
  f7:	68 e9 08 00 00       	push   $0x8e9
  fc:	6a 01                	push   $0x1
  fe:	e8 fd 03 00 00       	call   500 <printf>
      exit();
 103:	e8 7b 02 00 00       	call   383 <exit>
    mknod("console", 1, 1);
 108:	51                   	push   %ecx
 109:	6a 01                	push   $0x1
 10b:	6a 01                	push   $0x1
 10d:	68 68 08 00 00       	push   $0x868
 112:	e8 b4 02 00 00       	call   3cb <mknod>
    open("console", O_RDWR);
 117:	5b                   	pop    %ebx
 118:	58                   	pop    %eax
 119:	6a 02                	push   $0x2
 11b:	68 68 08 00 00       	push   $0x868
 120:	e8 9e 02 00 00       	call   3c3 <open>
 125:	83 c4 10             	add    $0x10,%esp
 128:	e9 fc fe ff ff       	jmp    29 <main+0x29>
 12d:	66 90                	xchg   %ax,%ax
 12f:	90                   	nop

00000130 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 130:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 131:	31 c0                	xor    %eax,%eax
{
 133:	89 e5                	mov    %esp,%ebp
 135:	53                   	push   %ebx
 136:	8b 4d 08             	mov    0x8(%ebp),%ecx
 139:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 13c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 140:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 144:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 147:	83 c0 01             	add    $0x1,%eax
 14a:	84 d2                	test   %dl,%dl
 14c:	75 f2                	jne    140 <strcpy+0x10>
    ;
  return os;
}
 14e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 151:	89 c8                	mov    %ecx,%eax
 153:	c9                   	leave  
 154:	c3                   	ret    
 155:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	53                   	push   %ebx
 164:	8b 4d 08             	mov    0x8(%ebp),%ecx
 167:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 16a:	0f b6 01             	movzbl (%ecx),%eax
 16d:	0f b6 1a             	movzbl (%edx),%ebx
 170:	84 c0                	test   %al,%al
 172:	75 1d                	jne    191 <strcmp+0x31>
 174:	eb 2a                	jmp    1a0 <strcmp+0x40>
 176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 17d:	8d 76 00             	lea    0x0(%esi),%esi
 180:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 184:	83 c1 01             	add    $0x1,%ecx
 187:	83 c2 01             	add    $0x1,%edx
  return (uchar)*p - (uchar)*q;
 18a:	0f b6 1a             	movzbl (%edx),%ebx
  while(*p && *p == *q)
 18d:	84 c0                	test   %al,%al
 18f:	74 0f                	je     1a0 <strcmp+0x40>
 191:	38 d8                	cmp    %bl,%al
 193:	74 eb                	je     180 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 195:	29 d8                	sub    %ebx,%eax
}
 197:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 19a:	c9                   	leave  
 19b:	c3                   	ret    
 19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1a0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 1a2:	29 d8                	sub    %ebx,%eax
}
 1a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1a7:	c9                   	leave  
 1a8:	c3                   	ret    
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001b0 <strlen>:

uint
strlen(const char *s)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1b6:	80 3a 00             	cmpb   $0x0,(%edx)
 1b9:	74 15                	je     1d0 <strlen+0x20>
 1bb:	31 c0                	xor    %eax,%eax
 1bd:	8d 76 00             	lea    0x0(%esi),%esi
 1c0:	83 c0 01             	add    $0x1,%eax
 1c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1c7:	89 c1                	mov    %eax,%ecx
 1c9:	75 f5                	jne    1c0 <strlen+0x10>
    ;
  return n;
}
 1cb:	89 c8                	mov    %ecx,%eax
 1cd:	5d                   	pop    %ebp
 1ce:	c3                   	ret    
 1cf:	90                   	nop
  for(n = 0; s[n]; n++)
 1d0:	31 c9                	xor    %ecx,%ecx
}
 1d2:	5d                   	pop    %ebp
 1d3:	89 c8                	mov    %ecx,%eax
 1d5:	c3                   	ret    
 1d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1dd:	8d 76 00             	lea    0x0(%esi),%esi

000001e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	57                   	push   %edi
 1e4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ed:	89 d7                	mov    %edx,%edi
 1ef:	fc                   	cld    
 1f0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1f2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1f5:	89 d0                	mov    %edx,%eax
 1f7:	c9                   	leave  
 1f8:	c3                   	ret    
 1f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000200 <strchr>:

char*
strchr(const char *s, char c)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	8b 45 08             	mov    0x8(%ebp),%eax
 206:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 20a:	0f b6 10             	movzbl (%eax),%edx
 20d:	84 d2                	test   %dl,%dl
 20f:	75 12                	jne    223 <strchr+0x23>
 211:	eb 1d                	jmp    230 <strchr+0x30>
 213:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 217:	90                   	nop
 218:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 21c:	83 c0 01             	add    $0x1,%eax
 21f:	84 d2                	test   %dl,%dl
 221:	74 0d                	je     230 <strchr+0x30>
    if(*s == c)
 223:	38 d1                	cmp    %dl,%cl
 225:	75 f1                	jne    218 <strchr+0x18>
      return (char*)s;
  return 0;
}
 227:	5d                   	pop    %ebp
 228:	c3                   	ret    
 229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 230:	31 c0                	xor    %eax,%eax
}
 232:	5d                   	pop    %ebp
 233:	c3                   	ret    
 234:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 23f:	90                   	nop

00000240 <gets>:

char*
gets(char *buf, int max)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	57                   	push   %edi
 244:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 245:	31 f6                	xor    %esi,%esi
{
 247:	53                   	push   %ebx
 248:	89 f3                	mov    %esi,%ebx
 24a:	83 ec 1c             	sub    $0x1c,%esp
 24d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 250:	eb 2f                	jmp    281 <gets+0x41>
 252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 258:	83 ec 04             	sub    $0x4,%esp
 25b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 25e:	6a 01                	push   $0x1
 260:	50                   	push   %eax
 261:	6a 00                	push   $0x0
 263:	e8 33 01 00 00       	call   39b <read>
    if(cc < 1)
 268:	83 c4 10             	add    $0x10,%esp
 26b:	85 c0                	test   %eax,%eax
 26d:	7e 1c                	jle    28b <gets+0x4b>
      break;
    buf[i++] = c;
 26f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    if(c == '\n' || c == '\r')
 273:	83 c7 01             	add    $0x1,%edi
    buf[i++] = c;
 276:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 279:	3c 0a                	cmp    $0xa,%al
 27b:	74 23                	je     2a0 <gets+0x60>
 27d:	3c 0d                	cmp    $0xd,%al
 27f:	74 1f                	je     2a0 <gets+0x60>
  for(i=0; i+1 < max; ){
 281:	83 c3 01             	add    $0x1,%ebx
    buf[i++] = c;
 284:	89 fe                	mov    %edi,%esi
  for(i=0; i+1 < max; ){
 286:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 289:	7c cd                	jl     258 <gets+0x18>
 28b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 290:	c6 03 00             	movb   $0x0,(%ebx)
}
 293:	8d 65 f4             	lea    -0xc(%ebp),%esp
 296:	5b                   	pop    %ebx
 297:	5e                   	pop    %esi
 298:	5f                   	pop    %edi
 299:	5d                   	pop    %ebp
 29a:	c3                   	ret    
 29b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 29f:	90                   	nop
  buf[i] = '\0';
 2a0:	8b 75 08             	mov    0x8(%ebp),%esi
}
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 2a6:	01 de                	add    %ebx,%esi
 2a8:	89 f3                	mov    %esi,%ebx
 2aa:	c6 03 00             	movb   $0x0,(%ebx)
}
 2ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2b0:	5b                   	pop    %ebx
 2b1:	5e                   	pop    %esi
 2b2:	5f                   	pop    %edi
 2b3:	5d                   	pop    %ebp
 2b4:	c3                   	ret    
 2b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	56                   	push   %esi
 2c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c5:	83 ec 08             	sub    $0x8,%esp
 2c8:	6a 00                	push   $0x0
 2ca:	ff 75 08             	pushl  0x8(%ebp)
 2cd:	e8 f1 00 00 00       	call   3c3 <open>
  if(fd < 0)
 2d2:	83 c4 10             	add    $0x10,%esp
 2d5:	85 c0                	test   %eax,%eax
 2d7:	78 27                	js     300 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 2d9:	83 ec 08             	sub    $0x8,%esp
 2dc:	ff 75 0c             	pushl  0xc(%ebp)
 2df:	89 c3                	mov    %eax,%ebx
 2e1:	50                   	push   %eax
 2e2:	e8 f4 00 00 00       	call   3db <fstat>
  close(fd);
 2e7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2ea:	89 c6                	mov    %eax,%esi
  close(fd);
 2ec:	e8 ba 00 00 00       	call   3ab <close>
  return r;
 2f1:	83 c4 10             	add    $0x10,%esp
}
 2f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2f7:	89 f0                	mov    %esi,%eax
 2f9:	5b                   	pop    %ebx
 2fa:	5e                   	pop    %esi
 2fb:	5d                   	pop    %ebp
 2fc:	c3                   	ret    
 2fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 300:	be ff ff ff ff       	mov    $0xffffffff,%esi
 305:	eb ed                	jmp    2f4 <stat+0x34>
 307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30e:	66 90                	xchg   %ax,%ax

00000310 <atoi>:

int
atoi(const char *s)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	53                   	push   %ebx
 314:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 317:	0f be 02             	movsbl (%edx),%eax
 31a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 31d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 320:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 325:	77 1e                	ja     345 <atoi+0x35>
 327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 32e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 330:	83 c2 01             	add    $0x1,%edx
 333:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 336:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 33a:	0f be 02             	movsbl (%edx),%eax
 33d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 340:	80 fb 09             	cmp    $0x9,%bl
 343:	76 eb                	jbe    330 <atoi+0x20>
  return n;
}
 345:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 348:	89 c8                	mov    %ecx,%eax
 34a:	c9                   	leave  
 34b:	c3                   	ret    
 34c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000350 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	8b 45 10             	mov    0x10(%ebp),%eax
 357:	8b 55 08             	mov    0x8(%ebp),%edx
 35a:	56                   	push   %esi
 35b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35e:	85 c0                	test   %eax,%eax
 360:	7e 13                	jle    375 <memmove+0x25>
 362:	01 d0                	add    %edx,%eax
  dst = vdst;
 364:	89 d7                	mov    %edx,%edi
 366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 370:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 371:	39 f8                	cmp    %edi,%eax
 373:	75 fb                	jne    370 <memmove+0x20>
  return vdst;
}
 375:	5e                   	pop    %esi
 376:	89 d0                	mov    %edx,%eax
 378:	5f                   	pop    %edi
 379:	5d                   	pop    %ebp
 37a:	c3                   	ret    

0000037b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 37b:	b8 01 00 00 00       	mov    $0x1,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <exit>:
SYSCALL(exit)
 383:	b8 02 00 00 00       	mov    $0x2,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <wait>:
SYSCALL(wait)
 38b:	b8 03 00 00 00       	mov    $0x3,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <pipe>:
SYSCALL(pipe)
 393:	b8 04 00 00 00       	mov    $0x4,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <read>:
SYSCALL(read)
 39b:	b8 05 00 00 00       	mov    $0x5,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <write>:
SYSCALL(write)
 3a3:	b8 10 00 00 00       	mov    $0x10,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <close>:
SYSCALL(close)
 3ab:	b8 15 00 00 00       	mov    $0x15,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <kill>:
SYSCALL(kill)
 3b3:	b8 06 00 00 00       	mov    $0x6,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <exec>:
SYSCALL(exec)
 3bb:	b8 07 00 00 00       	mov    $0x7,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <open>:
SYSCALL(open)
 3c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <mknod>:
SYSCALL(mknod)
 3cb:	b8 11 00 00 00       	mov    $0x11,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <unlink>:
SYSCALL(unlink)
 3d3:	b8 12 00 00 00       	mov    $0x12,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <fstat>:
SYSCALL(fstat)
 3db:	b8 08 00 00 00       	mov    $0x8,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <link>:
SYSCALL(link)
 3e3:	b8 13 00 00 00       	mov    $0x13,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <mkdir>:
SYSCALL(mkdir)
 3eb:	b8 14 00 00 00       	mov    $0x14,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <chdir>:
SYSCALL(chdir)
 3f3:	b8 09 00 00 00       	mov    $0x9,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <dup>:
SYSCALL(dup)
 3fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <getpid>:
SYSCALL(getpid)
 403:	b8 0b 00 00 00       	mov    $0xb,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <sbrk>:
SYSCALL(sbrk)
 40b:	b8 0c 00 00 00       	mov    $0xc,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <sleep>:
SYSCALL(sleep)
 413:	b8 0d 00 00 00       	mov    $0xd,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <uptime>:
SYSCALL(uptime)
 41b:	b8 0e 00 00 00       	mov    $0xe,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <changeQueue>:
SYSCALL(changeQueue)
 423:	b8 16 00 00 00       	mov    $0x16,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <setTicket>:
SYSCALL(setTicket)
 42b:	b8 17 00 00 00       	mov    $0x17,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <setProcessParameters>:
SYSCALL(setProcessParameters)
 433:	b8 18 00 00 00       	mov    $0x18,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <setSystemParameters>:
SYSCALL(setSystemParameters)
 43b:	b8 19 00 00 00       	mov    $0x19,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <showInfo>:
SYSCALL(showInfo)
 443:	b8 1a 00 00 00       	mov    $0x1a,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    
 44b:	66 90                	xchg   %ax,%ax
 44d:	66 90                	xchg   %ax,%ax
 44f:	90                   	nop

00000450 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	56                   	push   %esi
 455:	53                   	push   %ebx
 456:	83 ec 3c             	sub    $0x3c,%esp
 459:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 45c:	89 d1                	mov    %edx,%ecx
{
 45e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 461:	85 d2                	test   %edx,%edx
 463:	0f 89 7f 00 00 00    	jns    4e8 <printint+0x98>
 469:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 46d:	74 79                	je     4e8 <printint+0x98>
    neg = 1;
 46f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 476:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 478:	31 db                	xor    %ebx,%ebx
 47a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 47d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 480:	89 c8                	mov    %ecx,%eax
 482:	31 d2                	xor    %edx,%edx
 484:	89 cf                	mov    %ecx,%edi
 486:	f7 75 c4             	divl   -0x3c(%ebp)
 489:	0f b6 92 10 09 00 00 	movzbl 0x910(%edx),%edx
 490:	89 45 c0             	mov    %eax,-0x40(%ebp)
 493:	89 d8                	mov    %ebx,%eax
 495:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 498:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 49b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 49e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 4a1:	76 dd                	jbe    480 <printint+0x30>
  if(neg)
 4a3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 4a6:	85 c9                	test   %ecx,%ecx
 4a8:	74 0c                	je     4b6 <printint+0x66>
    buf[i++] = '-';
 4aa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 4af:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 4b1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 4b6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 4b9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 4bd:	eb 07                	jmp    4c6 <printint+0x76>
 4bf:	90                   	nop
    putc(fd, buf[i]);
 4c0:	0f b6 13             	movzbl (%ebx),%edx
 4c3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 4c6:	83 ec 04             	sub    $0x4,%esp
 4c9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 4cc:	6a 01                	push   $0x1
 4ce:	56                   	push   %esi
 4cf:	57                   	push   %edi
 4d0:	e8 ce fe ff ff       	call   3a3 <write>
  while(--i >= 0)
 4d5:	83 c4 10             	add    $0x10,%esp
 4d8:	39 de                	cmp    %ebx,%esi
 4da:	75 e4                	jne    4c0 <printint+0x70>
}
 4dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4df:	5b                   	pop    %ebx
 4e0:	5e                   	pop    %esi
 4e1:	5f                   	pop    %edi
 4e2:	5d                   	pop    %ebp
 4e3:	c3                   	ret    
 4e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4e8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 4ef:	eb 87                	jmp    478 <printint+0x28>
 4f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ff:	90                   	nop

00000500 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
 504:	56                   	push   %esi
 505:	53                   	push   %ebx
 506:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 509:	8b 75 0c             	mov    0xc(%ebp),%esi
 50c:	0f b6 1e             	movzbl (%esi),%ebx
 50f:	84 db                	test   %bl,%bl
 511:	0f 84 b8 00 00 00    	je     5cf <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 517:	8d 45 10             	lea    0x10(%ebp),%eax
 51a:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 51d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 520:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 522:	89 45 d0             	mov    %eax,-0x30(%ebp)
 525:	eb 37                	jmp    55e <printf+0x5e>
 527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52e:	66 90                	xchg   %ax,%ax
 530:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 533:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 538:	83 f8 25             	cmp    $0x25,%eax
 53b:	74 17                	je     554 <printf+0x54>
  write(fd, &c, 1);
 53d:	83 ec 04             	sub    $0x4,%esp
 540:	88 5d e7             	mov    %bl,-0x19(%ebp)
 543:	6a 01                	push   $0x1
 545:	57                   	push   %edi
 546:	ff 75 08             	pushl  0x8(%ebp)
 549:	e8 55 fe ff ff       	call   3a3 <write>
 54e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 551:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 554:	0f b6 1e             	movzbl (%esi),%ebx
 557:	83 c6 01             	add    $0x1,%esi
 55a:	84 db                	test   %bl,%bl
 55c:	74 71                	je     5cf <printf+0xcf>
    c = fmt[i] & 0xff;
 55e:	0f be cb             	movsbl %bl,%ecx
 561:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 564:	85 d2                	test   %edx,%edx
 566:	74 c8                	je     530 <printf+0x30>
      }
    } else if(state == '%'){
 568:	83 fa 25             	cmp    $0x25,%edx
 56b:	75 e7                	jne    554 <printf+0x54>
      if(c == 'd'){
 56d:	83 f8 64             	cmp    $0x64,%eax
 570:	0f 84 9a 00 00 00    	je     610 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 576:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 57c:	83 f9 70             	cmp    $0x70,%ecx
 57f:	74 5f                	je     5e0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 581:	83 f8 73             	cmp    $0x73,%eax
 584:	0f 84 d6 00 00 00    	je     660 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 58a:	83 f8 63             	cmp    $0x63,%eax
 58d:	0f 84 8d 00 00 00    	je     620 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 593:	83 f8 25             	cmp    $0x25,%eax
 596:	0f 84 b4 00 00 00    	je     650 <printf+0x150>
  write(fd, &c, 1);
 59c:	83 ec 04             	sub    $0x4,%esp
 59f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5a3:	6a 01                	push   $0x1
 5a5:	57                   	push   %edi
 5a6:	ff 75 08             	pushl  0x8(%ebp)
 5a9:	e8 f5 fd ff ff       	call   3a3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 5ae:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5b1:	83 c4 0c             	add    $0xc,%esp
 5b4:	6a 01                	push   $0x1
  for(i = 0; fmt[i]; i++){
 5b6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 5b9:	57                   	push   %edi
 5ba:	ff 75 08             	pushl  0x8(%ebp)
 5bd:	e8 e1 fd ff ff       	call   3a3 <write>
  for(i = 0; fmt[i]; i++){
 5c2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 5c6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5c9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 5cb:	84 db                	test   %bl,%bl
 5cd:	75 8f                	jne    55e <printf+0x5e>
    }
  }
}
 5cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5d2:	5b                   	pop    %ebx
 5d3:	5e                   	pop    %esi
 5d4:	5f                   	pop    %edi
 5d5:	5d                   	pop    %ebp
 5d6:	c3                   	ret    
 5d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5de:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 5e0:	83 ec 0c             	sub    $0xc,%esp
 5e3:	b9 10 00 00 00       	mov    $0x10,%ecx
 5e8:	6a 00                	push   $0x0
 5ea:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5ed:	8b 45 08             	mov    0x8(%ebp),%eax
 5f0:	8b 13                	mov    (%ebx),%edx
 5f2:	e8 59 fe ff ff       	call   450 <printint>
        ap++;
 5f7:	89 d8                	mov    %ebx,%eax
 5f9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5fc:	31 d2                	xor    %edx,%edx
        ap++;
 5fe:	83 c0 04             	add    $0x4,%eax
 601:	89 45 d0             	mov    %eax,-0x30(%ebp)
 604:	e9 4b ff ff ff       	jmp    554 <printf+0x54>
 609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 610:	83 ec 0c             	sub    $0xc,%esp
 613:	b9 0a 00 00 00       	mov    $0xa,%ecx
 618:	6a 01                	push   $0x1
 61a:	eb ce                	jmp    5ea <printf+0xea>
 61c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 620:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 623:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 626:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 628:	6a 01                	push   $0x1
        ap++;
 62a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 62d:	57                   	push   %edi
 62e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 631:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 634:	e8 6a fd ff ff       	call   3a3 <write>
        ap++;
 639:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 63c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 63f:	31 d2                	xor    %edx,%edx
 641:	e9 0e ff ff ff       	jmp    554 <printf+0x54>
 646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 64d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 650:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 653:	83 ec 04             	sub    $0x4,%esp
 656:	e9 59 ff ff ff       	jmp    5b4 <printf+0xb4>
 65b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 65f:	90                   	nop
        s = (char*)*ap;
 660:	8b 45 d0             	mov    -0x30(%ebp),%eax
 663:	8b 18                	mov    (%eax),%ebx
        ap++;
 665:	83 c0 04             	add    $0x4,%eax
 668:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 66b:	85 db                	test   %ebx,%ebx
 66d:	74 17                	je     686 <printf+0x186>
        while(*s != 0){
 66f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 672:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 674:	84 c0                	test   %al,%al
 676:	0f 84 d8 fe ff ff    	je     554 <printf+0x54>
 67c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 67f:	89 de                	mov    %ebx,%esi
 681:	8b 5d 08             	mov    0x8(%ebp),%ebx
 684:	eb 1a                	jmp    6a0 <printf+0x1a0>
          s = "(null)";
 686:	bb 08 09 00 00       	mov    $0x908,%ebx
        while(*s != 0){
 68b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 68e:	b8 28 00 00 00       	mov    $0x28,%eax
 693:	89 de                	mov    %ebx,%esi
 695:	8b 5d 08             	mov    0x8(%ebp),%ebx
 698:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 69f:	90                   	nop
  write(fd, &c, 1);
 6a0:	83 ec 04             	sub    $0x4,%esp
          s++;
 6a3:	83 c6 01             	add    $0x1,%esi
 6a6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6a9:	6a 01                	push   $0x1
 6ab:	57                   	push   %edi
 6ac:	53                   	push   %ebx
 6ad:	e8 f1 fc ff ff       	call   3a3 <write>
        while(*s != 0){
 6b2:	0f b6 06             	movzbl (%esi),%eax
 6b5:	83 c4 10             	add    $0x10,%esp
 6b8:	84 c0                	test   %al,%al
 6ba:	75 e4                	jne    6a0 <printf+0x1a0>
      state = 0;
 6bc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 6bf:	31 d2                	xor    %edx,%edx
 6c1:	e9 8e fe ff ff       	jmp    554 <printf+0x54>
 6c6:	66 90                	xchg   %ax,%ax
 6c8:	66 90                	xchg   %ax,%ax
 6ca:	66 90                	xchg   %ax,%ax
 6cc:	66 90                	xchg   %ax,%ax
 6ce:	66 90                	xchg   %ax,%ax

000006d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d1:	a1 c0 0b 00 00       	mov    0xbc0,%eax
{
 6d6:	89 e5                	mov    %esp,%ebp
 6d8:	57                   	push   %edi
 6d9:	56                   	push   %esi
 6da:	53                   	push   %ebx
 6db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 6de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6e8:	89 c2                	mov    %eax,%edx
 6ea:	8b 00                	mov    (%eax),%eax
 6ec:	39 ca                	cmp    %ecx,%edx
 6ee:	73 30                	jae    720 <free+0x50>
 6f0:	39 c1                	cmp    %eax,%ecx
 6f2:	72 04                	jb     6f8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f4:	39 c2                	cmp    %eax,%edx
 6f6:	72 f0                	jb     6e8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6f8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6fb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6fe:	39 f8                	cmp    %edi,%eax
 700:	74 30                	je     732 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 702:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 705:	8b 42 04             	mov    0x4(%edx),%eax
 708:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 70b:	39 f1                	cmp    %esi,%ecx
 70d:	74 3a                	je     749 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 70f:	89 0a                	mov    %ecx,(%edx)
  freep = p;
}
 711:	5b                   	pop    %ebx
  freep = p;
 712:	89 15 c0 0b 00 00    	mov    %edx,0xbc0
}
 718:	5e                   	pop    %esi
 719:	5f                   	pop    %edi
 71a:	5d                   	pop    %ebp
 71b:	c3                   	ret    
 71c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 720:	39 c2                	cmp    %eax,%edx
 722:	72 c4                	jb     6e8 <free+0x18>
 724:	39 c1                	cmp    %eax,%ecx
 726:	73 c0                	jae    6e8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 728:	8b 73 fc             	mov    -0x4(%ebx),%esi
 72b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 72e:	39 f8                	cmp    %edi,%eax
 730:	75 d0                	jne    702 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 732:	03 70 04             	add    0x4(%eax),%esi
 735:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 738:	8b 02                	mov    (%edx),%eax
 73a:	8b 00                	mov    (%eax),%eax
 73c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 73f:	8b 42 04             	mov    0x4(%edx),%eax
 742:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 745:	39 f1                	cmp    %esi,%ecx
 747:	75 c6                	jne    70f <free+0x3f>
    p->s.size += bp->s.size;
 749:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 74c:	89 15 c0 0b 00 00    	mov    %edx,0xbc0
    p->s.size += bp->s.size;
 752:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 755:	8b 43 f8             	mov    -0x8(%ebx),%eax
 758:	89 02                	mov    %eax,(%edx)
}
 75a:	5b                   	pop    %ebx
 75b:	5e                   	pop    %esi
 75c:	5f                   	pop    %edi
 75d:	5d                   	pop    %ebp
 75e:	c3                   	ret    
 75f:	90                   	nop

00000760 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	57                   	push   %edi
 764:	56                   	push   %esi
 765:	53                   	push   %ebx
 766:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 769:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 76c:	8b 3d c0 0b 00 00    	mov    0xbc0,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 772:	8d 70 07             	lea    0x7(%eax),%esi
 775:	c1 ee 03             	shr    $0x3,%esi
 778:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 77b:	85 ff                	test   %edi,%edi
 77d:	0f 84 ad 00 00 00    	je     830 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 783:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 785:	8b 48 04             	mov    0x4(%eax),%ecx
 788:	39 f1                	cmp    %esi,%ecx
 78a:	73 71                	jae    7fd <malloc+0x9d>
 78c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 792:	bb 00 10 00 00       	mov    $0x1000,%ebx
 797:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 79a:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 7a1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 7a4:	eb 1b                	jmp    7c1 <malloc+0x61>
 7a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 7b2:	8b 4a 04             	mov    0x4(%edx),%ecx
 7b5:	39 f1                	cmp    %esi,%ecx
 7b7:	73 4f                	jae    808 <malloc+0xa8>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b9:	8b 3d c0 0b 00 00    	mov    0xbc0,%edi
 7bf:	89 d0                	mov    %edx,%eax
 7c1:	39 c7                	cmp    %eax,%edi
 7c3:	75 eb                	jne    7b0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 7c5:	83 ec 0c             	sub    $0xc,%esp
 7c8:	ff 75 e4             	pushl  -0x1c(%ebp)
 7cb:	e8 3b fc ff ff       	call   40b <sbrk>
  if(p == (char*)-1)
 7d0:	83 c4 10             	add    $0x10,%esp
 7d3:	83 f8 ff             	cmp    $0xffffffff,%eax
 7d6:	74 1b                	je     7f3 <malloc+0x93>
  hp->s.size = nu;
 7d8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7db:	83 ec 0c             	sub    $0xc,%esp
 7de:	83 c0 08             	add    $0x8,%eax
 7e1:	50                   	push   %eax
 7e2:	e8 e9 fe ff ff       	call   6d0 <free>
  return freep;
 7e7:	a1 c0 0b 00 00       	mov    0xbc0,%eax
      if((p = morecore(nunits)) == 0)
 7ec:	83 c4 10             	add    $0x10,%esp
 7ef:	85 c0                	test   %eax,%eax
 7f1:	75 bd                	jne    7b0 <malloc+0x50>
        return 0;
  }
}
 7f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7f6:	31 c0                	xor    %eax,%eax
}
 7f8:	5b                   	pop    %ebx
 7f9:	5e                   	pop    %esi
 7fa:	5f                   	pop    %edi
 7fb:	5d                   	pop    %ebp
 7fc:	c3                   	ret    
    if(p->s.size >= nunits){
 7fd:	89 c2                	mov    %eax,%edx
 7ff:	89 f8                	mov    %edi,%eax
 801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 808:	39 ce                	cmp    %ecx,%esi
 80a:	74 54                	je     860 <malloc+0x100>
        p->s.size -= nunits;
 80c:	29 f1                	sub    %esi,%ecx
 80e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 811:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 814:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 817:	a3 c0 0b 00 00       	mov    %eax,0xbc0
}
 81c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 81f:	8d 42 08             	lea    0x8(%edx),%eax
}
 822:	5b                   	pop    %ebx
 823:	5e                   	pop    %esi
 824:	5f                   	pop    %edi
 825:	5d                   	pop    %ebp
 826:	c3                   	ret    
 827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 82e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 830:	c7 05 c0 0b 00 00 c4 	movl   $0xbc4,0xbc0
 837:	0b 00 00 
    base.s.size = 0;
 83a:	bf c4 0b 00 00       	mov    $0xbc4,%edi
    base.s.ptr = freep = prevp = &base;
 83f:	c7 05 c4 0b 00 00 c4 	movl   $0xbc4,0xbc4
 846:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 849:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 84b:	c7 05 c8 0b 00 00 00 	movl   $0x0,0xbc8
 852:	00 00 00 
    if(p->s.size >= nunits){
 855:	e9 32 ff ff ff       	jmp    78c <malloc+0x2c>
 85a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 860:	8b 0a                	mov    (%edx),%ecx
 862:	89 08                	mov    %ecx,(%eax)
 864:	eb b1                	jmp    817 <malloc+0xb7>
