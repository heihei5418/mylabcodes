
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba c8 89 11 00       	mov    $0x1189c8,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 60 5d 00 00       	call   105db6 <memset>

    cons_init();                // init the console
  100056:	e8 c7 14 00 00       	call   101522 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 40 5f 10 00 	movl   $0x105f40,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 5c 5f 10 00 	movl   $0x105f5c,(%esp)
  100070:	e8 d7 02 00 00       	call   10034c <cprintf>

    print_kerninfo();
  100075:	e8 06 08 00 00       	call   100880 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 8b 00 00 00       	call   10010a <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 42 42 00 00       	call   1042c6 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 02 16 00 00       	call   10168b <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 54 17 00 00       	call   1017e2 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 45 0c 00 00       	call   100cd8 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 61 15 00 00       	call   1015f9 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100098:	e8 6d 01 00 00       	call   10020a <lab1_switch_test>

    /* do nothing */
    while (1);
  10009d:	eb fe                	jmp    10009d <kern_init+0x73>

0010009f <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009f:	55                   	push   %ebp
  1000a0:	89 e5                	mov    %esp,%ebp
  1000a2:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000ac:	00 
  1000ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000b4:	00 
  1000b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000bc:	e8 49 0b 00 00       	call   100c0a <mon_backtrace>
}
  1000c1:	c9                   	leave  
  1000c2:	c3                   	ret    

001000c3 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000c3:	55                   	push   %ebp
  1000c4:	89 e5                	mov    %esp,%ebp
  1000c6:	53                   	push   %ebx
  1000c7:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000ca:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000d0:	8d 55 08             	lea    0x8(%ebp),%edx
  1000d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000da:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000de:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000e2:	89 04 24             	mov    %eax,(%esp)
  1000e5:	e8 b5 ff ff ff       	call   10009f <grade_backtrace2>
}
  1000ea:	83 c4 14             	add    $0x14,%esp
  1000ed:	5b                   	pop    %ebx
  1000ee:	5d                   	pop    %ebp
  1000ef:	c3                   	ret    

001000f0 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000f0:	55                   	push   %ebp
  1000f1:	89 e5                	mov    %esp,%ebp
  1000f3:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f6:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000fd:	8b 45 08             	mov    0x8(%ebp),%eax
  100100:	89 04 24             	mov    %eax,(%esp)
  100103:	e8 bb ff ff ff       	call   1000c3 <grade_backtrace1>
}
  100108:	c9                   	leave  
  100109:	c3                   	ret    

0010010a <grade_backtrace>:

void
grade_backtrace(void) {
  10010a:	55                   	push   %ebp
  10010b:	89 e5                	mov    %esp,%ebp
  10010d:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  100110:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100115:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  10011c:	ff 
  10011d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100121:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100128:	e8 c3 ff ff ff       	call   1000f0 <grade_backtrace0>
}
  10012d:	c9                   	leave  
  10012e:	c3                   	ret    

0010012f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012f:	55                   	push   %ebp
  100130:	89 e5                	mov    %esp,%ebp
  100132:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100135:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100138:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10013b:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10013e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100141:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100145:	0f b7 c0             	movzwl %ax,%eax
  100148:	83 e0 03             	and    $0x3,%eax
  10014b:	89 c2                	mov    %eax,%edx
  10014d:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100152:	89 54 24 08          	mov    %edx,0x8(%esp)
  100156:	89 44 24 04          	mov    %eax,0x4(%esp)
  10015a:	c7 04 24 61 5f 10 00 	movl   $0x105f61,(%esp)
  100161:	e8 e6 01 00 00       	call   10034c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100166:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10016a:	0f b7 d0             	movzwl %ax,%edx
  10016d:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100172:	89 54 24 08          	mov    %edx,0x8(%esp)
  100176:	89 44 24 04          	mov    %eax,0x4(%esp)
  10017a:	c7 04 24 6f 5f 10 00 	movl   $0x105f6f,(%esp)
  100181:	e8 c6 01 00 00       	call   10034c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100186:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10018a:	0f b7 d0             	movzwl %ax,%edx
  10018d:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100192:	89 54 24 08          	mov    %edx,0x8(%esp)
  100196:	89 44 24 04          	mov    %eax,0x4(%esp)
  10019a:	c7 04 24 7d 5f 10 00 	movl   $0x105f7d,(%esp)
  1001a1:	e8 a6 01 00 00       	call   10034c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001aa:	0f b7 d0             	movzwl %ax,%edx
  1001ad:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001b2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ba:	c7 04 24 8b 5f 10 00 	movl   $0x105f8b,(%esp)
  1001c1:	e8 86 01 00 00       	call   10034c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c6:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001ca:	0f b7 d0             	movzwl %ax,%edx
  1001cd:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001d2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001da:	c7 04 24 99 5f 10 00 	movl   $0x105f99,(%esp)
  1001e1:	e8 66 01 00 00       	call   10034c <cprintf>
    round ++;
  1001e6:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001eb:	83 c0 01             	add    $0x1,%eax
  1001ee:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001f3:	c9                   	leave  
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
  1001f8:	83 ec 08             	sub    $0x8,%esp
  1001fb:	cd 78                	int    $0x78
  1001fd:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001ff:	5d                   	pop    %ebp
  100200:	c3                   	ret    

00100201 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100201:	55                   	push   %ebp
  100202:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
  100204:	cd 79                	int    $0x79
  100206:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  100208:	5d                   	pop    %ebp
  100209:	c3                   	ret    

0010020a <lab1_switch_test>:

static void
lab1_switch_test(void) {
  10020a:	55                   	push   %ebp
  10020b:	89 e5                	mov    %esp,%ebp
  10020d:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100210:	e8 1a ff ff ff       	call   10012f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100215:	c7 04 24 a8 5f 10 00 	movl   $0x105fa8,(%esp)
  10021c:	e8 2b 01 00 00       	call   10034c <cprintf>
    lab1_switch_to_user();
  100221:	e8 cf ff ff ff       	call   1001f5 <lab1_switch_to_user>
    lab1_print_cur_status();
  100226:	e8 04 ff ff ff       	call   10012f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10022b:	c7 04 24 c8 5f 10 00 	movl   $0x105fc8,(%esp)
  100232:	e8 15 01 00 00       	call   10034c <cprintf>
    lab1_switch_to_kernel();
  100237:	e8 c5 ff ff ff       	call   100201 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10023c:	e8 ee fe ff ff       	call   10012f <lab1_print_cur_status>
}
  100241:	c9                   	leave  
  100242:	c3                   	ret    

00100243 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100243:	55                   	push   %ebp
  100244:	89 e5                	mov    %esp,%ebp
  100246:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100249:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10024d:	74 13                	je     100262 <readline+0x1f>
        cprintf("%s", prompt);
  10024f:	8b 45 08             	mov    0x8(%ebp),%eax
  100252:	89 44 24 04          	mov    %eax,0x4(%esp)
  100256:	c7 04 24 e7 5f 10 00 	movl   $0x105fe7,(%esp)
  10025d:	e8 ea 00 00 00       	call   10034c <cprintf>
    }
    int i = 0, c;
  100262:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100269:	e8 66 01 00 00       	call   1003d4 <getchar>
  10026e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100271:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100275:	79 07                	jns    10027e <readline+0x3b>
            return NULL;
  100277:	b8 00 00 00 00       	mov    $0x0,%eax
  10027c:	eb 79                	jmp    1002f7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10027e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100282:	7e 28                	jle    1002ac <readline+0x69>
  100284:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10028b:	7f 1f                	jg     1002ac <readline+0x69>
            cputchar(c);
  10028d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100290:	89 04 24             	mov    %eax,(%esp)
  100293:	e8 da 00 00 00       	call   100372 <cputchar>
            buf[i ++] = c;
  100298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10029b:	8d 50 01             	lea    0x1(%eax),%edx
  10029e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1002a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1002a4:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  1002aa:	eb 46                	jmp    1002f2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  1002ac:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002b0:	75 17                	jne    1002c9 <readline+0x86>
  1002b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002b6:	7e 11                	jle    1002c9 <readline+0x86>
            cputchar(c);
  1002b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002bb:	89 04 24             	mov    %eax,(%esp)
  1002be:	e8 af 00 00 00       	call   100372 <cputchar>
            i --;
  1002c3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002c7:	eb 29                	jmp    1002f2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002c9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002cd:	74 06                	je     1002d5 <readline+0x92>
  1002cf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002d3:	75 1d                	jne    1002f2 <readline+0xaf>
            cputchar(c);
  1002d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002d8:	89 04 24             	mov    %eax,(%esp)
  1002db:	e8 92 00 00 00       	call   100372 <cputchar>
            buf[i] = '\0';
  1002e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002e3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002e8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002eb:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002f0:	eb 05                	jmp    1002f7 <readline+0xb4>
        }
    }
  1002f2:	e9 72 ff ff ff       	jmp    100269 <readline+0x26>
}
  1002f7:	c9                   	leave  
  1002f8:	c3                   	ret    

001002f9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002f9:	55                   	push   %ebp
  1002fa:	89 e5                	mov    %esp,%ebp
  1002fc:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ff:	8b 45 08             	mov    0x8(%ebp),%eax
  100302:	89 04 24             	mov    %eax,(%esp)
  100305:	e8 44 12 00 00       	call   10154e <cons_putc>
    (*cnt) ++;
  10030a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10030d:	8b 00                	mov    (%eax),%eax
  10030f:	8d 50 01             	lea    0x1(%eax),%edx
  100312:	8b 45 0c             	mov    0xc(%ebp),%eax
  100315:	89 10                	mov    %edx,(%eax)
}
  100317:	c9                   	leave  
  100318:	c3                   	ret    

00100319 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100319:	55                   	push   %ebp
  10031a:	89 e5                	mov    %esp,%ebp
  10031c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10031f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100326:	8b 45 0c             	mov    0xc(%ebp),%eax
  100329:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10032d:	8b 45 08             	mov    0x8(%ebp),%eax
  100330:	89 44 24 08          	mov    %eax,0x8(%esp)
  100334:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100337:	89 44 24 04          	mov    %eax,0x4(%esp)
  10033b:	c7 04 24 f9 02 10 00 	movl   $0x1002f9,(%esp)
  100342:	e8 88 52 00 00       	call   1055cf <vprintfmt>
    return cnt;
  100347:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10034a:	c9                   	leave  
  10034b:	c3                   	ret    

0010034c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10034c:	55                   	push   %ebp
  10034d:	89 e5                	mov    %esp,%ebp
  10034f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100352:	8d 45 0c             	lea    0xc(%ebp),%eax
  100355:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10035b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035f:	8b 45 08             	mov    0x8(%ebp),%eax
  100362:	89 04 24             	mov    %eax,(%esp)
  100365:	e8 af ff ff ff       	call   100319 <vcprintf>
  10036a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10036d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100370:	c9                   	leave  
  100371:	c3                   	ret    

00100372 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100372:	55                   	push   %ebp
  100373:	89 e5                	mov    %esp,%ebp
  100375:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100378:	8b 45 08             	mov    0x8(%ebp),%eax
  10037b:	89 04 24             	mov    %eax,(%esp)
  10037e:	e8 cb 11 00 00       	call   10154e <cons_putc>
}
  100383:	c9                   	leave  
  100384:	c3                   	ret    

00100385 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100385:	55                   	push   %ebp
  100386:	89 e5                	mov    %esp,%ebp
  100388:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10038b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100392:	eb 13                	jmp    1003a7 <cputs+0x22>
        cputch(c, &cnt);
  100394:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100398:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10039b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10039f:	89 04 24             	mov    %eax,(%esp)
  1003a2:	e8 52 ff ff ff       	call   1002f9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1003a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1003aa:	8d 50 01             	lea    0x1(%eax),%edx
  1003ad:	89 55 08             	mov    %edx,0x8(%ebp)
  1003b0:	0f b6 00             	movzbl (%eax),%eax
  1003b3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003b6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003ba:	75 d8                	jne    100394 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003c3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ca:	e8 2a ff ff ff       	call   1002f9 <cputch>
    return cnt;
  1003cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003d2:	c9                   	leave  
  1003d3:	c3                   	ret    

001003d4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003d4:	55                   	push   %ebp
  1003d5:	89 e5                	mov    %esp,%ebp
  1003d7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003da:	e8 ab 11 00 00       	call   10158a <cons_getc>
  1003df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003e6:	74 f2                	je     1003da <getchar+0x6>
        /* do nothing */;
    return c;
  1003e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003eb:	c9                   	leave  
  1003ec:	c3                   	ret    

001003ed <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003ed:	55                   	push   %ebp
  1003ee:	89 e5                	mov    %esp,%ebp
  1003f0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003f6:	8b 00                	mov    (%eax),%eax
  1003f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003fb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003fe:	8b 00                	mov    (%eax),%eax
  100400:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100403:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10040a:	e9 d2 00 00 00       	jmp    1004e1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  10040f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100412:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100415:	01 d0                	add    %edx,%eax
  100417:	89 c2                	mov    %eax,%edx
  100419:	c1 ea 1f             	shr    $0x1f,%edx
  10041c:	01 d0                	add    %edx,%eax
  10041e:	d1 f8                	sar    %eax
  100420:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100423:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100426:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100429:	eb 04                	jmp    10042f <stab_binsearch+0x42>
            m --;
  10042b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10042f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100432:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100435:	7c 1f                	jl     100456 <stab_binsearch+0x69>
  100437:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10043a:	89 d0                	mov    %edx,%eax
  10043c:	01 c0                	add    %eax,%eax
  10043e:	01 d0                	add    %edx,%eax
  100440:	c1 e0 02             	shl    $0x2,%eax
  100443:	89 c2                	mov    %eax,%edx
  100445:	8b 45 08             	mov    0x8(%ebp),%eax
  100448:	01 d0                	add    %edx,%eax
  10044a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10044e:	0f b6 c0             	movzbl %al,%eax
  100451:	3b 45 14             	cmp    0x14(%ebp),%eax
  100454:	75 d5                	jne    10042b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100456:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100459:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10045c:	7d 0b                	jge    100469 <stab_binsearch+0x7c>
            l = true_m + 1;
  10045e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100461:	83 c0 01             	add    $0x1,%eax
  100464:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100467:	eb 78                	jmp    1004e1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100469:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100470:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100473:	89 d0                	mov    %edx,%eax
  100475:	01 c0                	add    %eax,%eax
  100477:	01 d0                	add    %edx,%eax
  100479:	c1 e0 02             	shl    $0x2,%eax
  10047c:	89 c2                	mov    %eax,%edx
  10047e:	8b 45 08             	mov    0x8(%ebp),%eax
  100481:	01 d0                	add    %edx,%eax
  100483:	8b 40 08             	mov    0x8(%eax),%eax
  100486:	3b 45 18             	cmp    0x18(%ebp),%eax
  100489:	73 13                	jae    10049e <stab_binsearch+0xb1>
            *region_left = m;
  10048b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100493:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100496:	83 c0 01             	add    $0x1,%eax
  100499:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10049c:	eb 43                	jmp    1004e1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10049e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004a1:	89 d0                	mov    %edx,%eax
  1004a3:	01 c0                	add    %eax,%eax
  1004a5:	01 d0                	add    %edx,%eax
  1004a7:	c1 e0 02             	shl    $0x2,%eax
  1004aa:	89 c2                	mov    %eax,%edx
  1004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1004af:	01 d0                	add    %edx,%eax
  1004b1:	8b 40 08             	mov    0x8(%eax),%eax
  1004b4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004b7:	76 16                	jbe    1004cf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004bf:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c7:	83 e8 01             	sub    $0x1,%eax
  1004ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004cd:	eb 12                	jmp    1004e1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004d5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004da:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004dd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004e7:	0f 8e 22 ff ff ff    	jle    10040f <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004f1:	75 0f                	jne    100502 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f6:	8b 00                	mov    (%eax),%eax
  1004f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004fb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004fe:	89 10                	mov    %edx,(%eax)
  100500:	eb 3f                	jmp    100541 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  100502:	8b 45 10             	mov    0x10(%ebp),%eax
  100505:	8b 00                	mov    (%eax),%eax
  100507:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  10050a:	eb 04                	jmp    100510 <stab_binsearch+0x123>
  10050c:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100510:	8b 45 0c             	mov    0xc(%ebp),%eax
  100513:	8b 00                	mov    (%eax),%eax
  100515:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100518:	7d 1f                	jge    100539 <stab_binsearch+0x14c>
  10051a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10051d:	89 d0                	mov    %edx,%eax
  10051f:	01 c0                	add    %eax,%eax
  100521:	01 d0                	add    %edx,%eax
  100523:	c1 e0 02             	shl    $0x2,%eax
  100526:	89 c2                	mov    %eax,%edx
  100528:	8b 45 08             	mov    0x8(%ebp),%eax
  10052b:	01 d0                	add    %edx,%eax
  10052d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100531:	0f b6 c0             	movzbl %al,%eax
  100534:	3b 45 14             	cmp    0x14(%ebp),%eax
  100537:	75 d3                	jne    10050c <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10053f:	89 10                	mov    %edx,(%eax)
    }
}
  100541:	c9                   	leave  
  100542:	c3                   	ret    

00100543 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100543:	55                   	push   %ebp
  100544:	89 e5                	mov    %esp,%ebp
  100546:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100549:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054c:	c7 00 ec 5f 10 00    	movl   $0x105fec,(%eax)
    info->eip_line = 0;
  100552:	8b 45 0c             	mov    0xc(%ebp),%eax
  100555:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10055c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055f:	c7 40 08 ec 5f 10 00 	movl   $0x105fec,0x8(%eax)
    info->eip_fn_namelen = 9;
  100566:	8b 45 0c             	mov    0xc(%ebp),%eax
  100569:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100570:	8b 45 0c             	mov    0xc(%ebp),%eax
  100573:	8b 55 08             	mov    0x8(%ebp),%edx
  100576:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100579:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100583:	c7 45 f4 d8 71 10 00 	movl   $0x1071d8,-0xc(%ebp)
    stab_end = __STAB_END__;
  10058a:	c7 45 f0 2c 1d 11 00 	movl   $0x111d2c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100591:	c7 45 ec 2d 1d 11 00 	movl   $0x111d2d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100598:	c7 45 e8 6b 47 11 00 	movl   $0x11476b,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10059f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1005a5:	76 0d                	jbe    1005b4 <debuginfo_eip+0x71>
  1005a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005aa:	83 e8 01             	sub    $0x1,%eax
  1005ad:	0f b6 00             	movzbl (%eax),%eax
  1005b0:	84 c0                	test   %al,%al
  1005b2:	74 0a                	je     1005be <debuginfo_eip+0x7b>
        return -1;
  1005b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005b9:	e9 c0 02 00 00       	jmp    10087e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005cb:	29 c2                	sub    %eax,%edx
  1005cd:	89 d0                	mov    %edx,%eax
  1005cf:	c1 f8 02             	sar    $0x2,%eax
  1005d2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005d8:	83 e8 01             	sub    $0x1,%eax
  1005db:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005de:	8b 45 08             	mov    0x8(%ebp),%eax
  1005e1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005e5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005ec:	00 
  1005ed:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005f4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005fe:	89 04 24             	mov    %eax,(%esp)
  100601:	e8 e7 fd ff ff       	call   1003ed <stab_binsearch>
    if (lfile == 0)
  100606:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100609:	85 c0                	test   %eax,%eax
  10060b:	75 0a                	jne    100617 <debuginfo_eip+0xd4>
        return -1;
  10060d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100612:	e9 67 02 00 00       	jmp    10087e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10061a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10061d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100620:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100623:	8b 45 08             	mov    0x8(%ebp),%eax
  100626:	89 44 24 10          	mov    %eax,0x10(%esp)
  10062a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100631:	00 
  100632:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100635:	89 44 24 08          	mov    %eax,0x8(%esp)
  100639:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10063c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100643:	89 04 24             	mov    %eax,(%esp)
  100646:	e8 a2 fd ff ff       	call   1003ed <stab_binsearch>

    if (lfun <= rfun) {
  10064b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10064e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100651:	39 c2                	cmp    %eax,%edx
  100653:	7f 7c                	jg     1006d1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100655:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100658:	89 c2                	mov    %eax,%edx
  10065a:	89 d0                	mov    %edx,%eax
  10065c:	01 c0                	add    %eax,%eax
  10065e:	01 d0                	add    %edx,%eax
  100660:	c1 e0 02             	shl    $0x2,%eax
  100663:	89 c2                	mov    %eax,%edx
  100665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100668:	01 d0                	add    %edx,%eax
  10066a:	8b 10                	mov    (%eax),%edx
  10066c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10066f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100672:	29 c1                	sub    %eax,%ecx
  100674:	89 c8                	mov    %ecx,%eax
  100676:	39 c2                	cmp    %eax,%edx
  100678:	73 22                	jae    10069c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10067a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10067d:	89 c2                	mov    %eax,%edx
  10067f:	89 d0                	mov    %edx,%eax
  100681:	01 c0                	add    %eax,%eax
  100683:	01 d0                	add    %edx,%eax
  100685:	c1 e0 02             	shl    $0x2,%eax
  100688:	89 c2                	mov    %eax,%edx
  10068a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10068d:	01 d0                	add    %edx,%eax
  10068f:	8b 10                	mov    (%eax),%edx
  100691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100694:	01 c2                	add    %eax,%edx
  100696:	8b 45 0c             	mov    0xc(%ebp),%eax
  100699:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10069c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10069f:	89 c2                	mov    %eax,%edx
  1006a1:	89 d0                	mov    %edx,%eax
  1006a3:	01 c0                	add    %eax,%eax
  1006a5:	01 d0                	add    %edx,%eax
  1006a7:	c1 e0 02             	shl    $0x2,%eax
  1006aa:	89 c2                	mov    %eax,%edx
  1006ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006af:	01 d0                	add    %edx,%eax
  1006b1:	8b 50 08             	mov    0x8(%eax),%edx
  1006b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006bd:	8b 40 10             	mov    0x10(%eax),%eax
  1006c0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006cf:	eb 15                	jmp    1006e6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006d7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e9:	8b 40 08             	mov    0x8(%eax),%eax
  1006ec:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006f3:	00 
  1006f4:	89 04 24             	mov    %eax,(%esp)
  1006f7:	e8 2e 55 00 00       	call   105c2a <strfind>
  1006fc:	89 c2                	mov    %eax,%edx
  1006fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  100701:	8b 40 08             	mov    0x8(%eax),%eax
  100704:	29 c2                	sub    %eax,%edx
  100706:	8b 45 0c             	mov    0xc(%ebp),%eax
  100709:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10070c:	8b 45 08             	mov    0x8(%ebp),%eax
  10070f:	89 44 24 10          	mov    %eax,0x10(%esp)
  100713:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10071a:	00 
  10071b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10071e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100722:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100725:	89 44 24 04          	mov    %eax,0x4(%esp)
  100729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10072c:	89 04 24             	mov    %eax,(%esp)
  10072f:	e8 b9 fc ff ff       	call   1003ed <stab_binsearch>
    if (lline <= rline) {
  100734:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100737:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10073a:	39 c2                	cmp    %eax,%edx
  10073c:	7f 24                	jg     100762 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10073e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100741:	89 c2                	mov    %eax,%edx
  100743:	89 d0                	mov    %edx,%eax
  100745:	01 c0                	add    %eax,%eax
  100747:	01 d0                	add    %edx,%eax
  100749:	c1 e0 02             	shl    $0x2,%eax
  10074c:	89 c2                	mov    %eax,%edx
  10074e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100751:	01 d0                	add    %edx,%eax
  100753:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100757:	0f b7 d0             	movzwl %ax,%edx
  10075a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100760:	eb 13                	jmp    100775 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100762:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100767:	e9 12 01 00 00       	jmp    10087e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10076c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10076f:	83 e8 01             	sub    $0x1,%eax
  100772:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100775:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10077b:	39 c2                	cmp    %eax,%edx
  10077d:	7c 56                	jl     1007d5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	89 d0                	mov    %edx,%eax
  100786:	01 c0                	add    %eax,%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	c1 e0 02             	shl    $0x2,%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100798:	3c 84                	cmp    $0x84,%al
  10079a:	74 39                	je     1007d5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10079c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10079f:	89 c2                	mov    %eax,%edx
  1007a1:	89 d0                	mov    %edx,%eax
  1007a3:	01 c0                	add    %eax,%eax
  1007a5:	01 d0                	add    %edx,%eax
  1007a7:	c1 e0 02             	shl    $0x2,%eax
  1007aa:	89 c2                	mov    %eax,%edx
  1007ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007af:	01 d0                	add    %edx,%eax
  1007b1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007b5:	3c 64                	cmp    $0x64,%al
  1007b7:	75 b3                	jne    10076c <debuginfo_eip+0x229>
  1007b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007bc:	89 c2                	mov    %eax,%edx
  1007be:	89 d0                	mov    %edx,%eax
  1007c0:	01 c0                	add    %eax,%eax
  1007c2:	01 d0                	add    %edx,%eax
  1007c4:	c1 e0 02             	shl    $0x2,%eax
  1007c7:	89 c2                	mov    %eax,%edx
  1007c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007cc:	01 d0                	add    %edx,%eax
  1007ce:	8b 40 08             	mov    0x8(%eax),%eax
  1007d1:	85 c0                	test   %eax,%eax
  1007d3:	74 97                	je     10076c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007db:	39 c2                	cmp    %eax,%edx
  1007dd:	7c 46                	jl     100825 <debuginfo_eip+0x2e2>
  1007df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e2:	89 c2                	mov    %eax,%edx
  1007e4:	89 d0                	mov    %edx,%eax
  1007e6:	01 c0                	add    %eax,%eax
  1007e8:	01 d0                	add    %edx,%eax
  1007ea:	c1 e0 02             	shl    $0x2,%eax
  1007ed:	89 c2                	mov    %eax,%edx
  1007ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007f2:	01 d0                	add    %edx,%eax
  1007f4:	8b 10                	mov    (%eax),%edx
  1007f6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007fc:	29 c1                	sub    %eax,%ecx
  1007fe:	89 c8                	mov    %ecx,%eax
  100800:	39 c2                	cmp    %eax,%edx
  100802:	73 21                	jae    100825 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100804:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100807:	89 c2                	mov    %eax,%edx
  100809:	89 d0                	mov    %edx,%eax
  10080b:	01 c0                	add    %eax,%eax
  10080d:	01 d0                	add    %edx,%eax
  10080f:	c1 e0 02             	shl    $0x2,%eax
  100812:	89 c2                	mov    %eax,%edx
  100814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100817:	01 d0                	add    %edx,%eax
  100819:	8b 10                	mov    (%eax),%edx
  10081b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10081e:	01 c2                	add    %eax,%edx
  100820:	8b 45 0c             	mov    0xc(%ebp),%eax
  100823:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100825:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100828:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10082b:	39 c2                	cmp    %eax,%edx
  10082d:	7d 4a                	jge    100879 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10082f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100832:	83 c0 01             	add    $0x1,%eax
  100835:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100838:	eb 18                	jmp    100852 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10083a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10083d:	8b 40 14             	mov    0x14(%eax),%eax
  100840:	8d 50 01             	lea    0x1(%eax),%edx
  100843:	8b 45 0c             	mov    0xc(%ebp),%eax
  100846:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100849:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084c:	83 c0 01             	add    $0x1,%eax
  10084f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100852:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100855:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100858:	39 c2                	cmp    %eax,%edx
  10085a:	7d 1d                	jge    100879 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10085c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085f:	89 c2                	mov    %eax,%edx
  100861:	89 d0                	mov    %edx,%eax
  100863:	01 c0                	add    %eax,%eax
  100865:	01 d0                	add    %edx,%eax
  100867:	c1 e0 02             	shl    $0x2,%eax
  10086a:	89 c2                	mov    %eax,%edx
  10086c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086f:	01 d0                	add    %edx,%eax
  100871:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100875:	3c a0                	cmp    $0xa0,%al
  100877:	74 c1                	je     10083a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100879:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10087e:	c9                   	leave  
  10087f:	c3                   	ret    

00100880 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100880:	55                   	push   %ebp
  100881:	89 e5                	mov    %esp,%ebp
  100883:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100886:	c7 04 24 f6 5f 10 00 	movl   $0x105ff6,(%esp)
  10088d:	e8 ba fa ff ff       	call   10034c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100892:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100899:	00 
  10089a:	c7 04 24 0f 60 10 00 	movl   $0x10600f,(%esp)
  1008a1:	e8 a6 fa ff ff       	call   10034c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008a6:	c7 44 24 04 3f 5f 10 	movl   $0x105f3f,0x4(%esp)
  1008ad:	00 
  1008ae:	c7 04 24 27 60 10 00 	movl   $0x106027,(%esp)
  1008b5:	e8 92 fa ff ff       	call   10034c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008ba:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008c1:	00 
  1008c2:	c7 04 24 3f 60 10 00 	movl   $0x10603f,(%esp)
  1008c9:	e8 7e fa ff ff       	call   10034c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008ce:	c7 44 24 04 c8 89 11 	movl   $0x1189c8,0x4(%esp)
  1008d5:	00 
  1008d6:	c7 04 24 57 60 10 00 	movl   $0x106057,(%esp)
  1008dd:	e8 6a fa ff ff       	call   10034c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008e2:	b8 c8 89 11 00       	mov    $0x1189c8,%eax
  1008e7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ed:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008f2:	29 c2                	sub    %eax,%edx
  1008f4:	89 d0                	mov    %edx,%eax
  1008f6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008fc:	85 c0                	test   %eax,%eax
  1008fe:	0f 48 c2             	cmovs  %edx,%eax
  100901:	c1 f8 0a             	sar    $0xa,%eax
  100904:	89 44 24 04          	mov    %eax,0x4(%esp)
  100908:	c7 04 24 70 60 10 00 	movl   $0x106070,(%esp)
  10090f:	e8 38 fa ff ff       	call   10034c <cprintf>
}
  100914:	c9                   	leave  
  100915:	c3                   	ret    

00100916 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100916:	55                   	push   %ebp
  100917:	89 e5                	mov    %esp,%ebp
  100919:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10091f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100922:	89 44 24 04          	mov    %eax,0x4(%esp)
  100926:	8b 45 08             	mov    0x8(%ebp),%eax
  100929:	89 04 24             	mov    %eax,(%esp)
  10092c:	e8 12 fc ff ff       	call   100543 <debuginfo_eip>
  100931:	85 c0                	test   %eax,%eax
  100933:	74 15                	je     10094a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100935:	8b 45 08             	mov    0x8(%ebp),%eax
  100938:	89 44 24 04          	mov    %eax,0x4(%esp)
  10093c:	c7 04 24 9a 60 10 00 	movl   $0x10609a,(%esp)
  100943:	e8 04 fa ff ff       	call   10034c <cprintf>
  100948:	eb 6d                	jmp    1009b7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10094a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100951:	eb 1c                	jmp    10096f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100953:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100959:	01 d0                	add    %edx,%eax
  10095b:	0f b6 00             	movzbl (%eax),%eax
  10095e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100964:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100967:	01 ca                	add    %ecx,%edx
  100969:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10096b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10096f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100972:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100975:	7f dc                	jg     100953 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100977:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10097d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100980:	01 d0                	add    %edx,%eax
  100982:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100985:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100988:	8b 55 08             	mov    0x8(%ebp),%edx
  10098b:	89 d1                	mov    %edx,%ecx
  10098d:	29 c1                	sub    %eax,%ecx
  10098f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100992:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100995:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100999:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10099f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1009a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1009a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ab:	c7 04 24 b6 60 10 00 	movl   $0x1060b6,(%esp)
  1009b2:	e8 95 f9 ff ff       	call   10034c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009b7:	c9                   	leave  
  1009b8:	c3                   	ret    

001009b9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009b9:	55                   	push   %ebp
  1009ba:	89 e5                	mov    %esp,%ebp
  1009bc:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009bf:	8b 45 04             	mov    0x4(%ebp),%eax
  1009c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009c8:	c9                   	leave  
  1009c9:	c3                   	ret    

001009ca <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ca:	55                   	push   %ebp
  1009cb:	89 e5                	mov    %esp,%ebp
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  1009cd:	5d                   	pop    %ebp
  1009ce:	c3                   	ret    

001009cf <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  1009cf:	55                   	push   %ebp
  1009d0:	89 e5                	mov    %esp,%ebp
  1009d2:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  1009d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  1009dc:	eb 0c                	jmp    1009ea <parse+0x1b>
            *buf ++ = '\0';
  1009de:	8b 45 08             	mov    0x8(%ebp),%eax
  1009e1:	8d 50 01             	lea    0x1(%eax),%edx
  1009e4:	89 55 08             	mov    %edx,0x8(%ebp)
  1009e7:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  1009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1009ed:	0f b6 00             	movzbl (%eax),%eax
  1009f0:	84 c0                	test   %al,%al
  1009f2:	74 1d                	je     100a11 <parse+0x42>
  1009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1009f7:	0f b6 00             	movzbl (%eax),%eax
  1009fa:	0f be c0             	movsbl %al,%eax
  1009fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a01:	c7 04 24 48 61 10 00 	movl   $0x106148,(%esp)
  100a08:	e8 ea 51 00 00       	call   105bf7 <strchr>
  100a0d:	85 c0                	test   %eax,%eax
  100a0f:	75 cd                	jne    1009de <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a11:	8b 45 08             	mov    0x8(%ebp),%eax
  100a14:	0f b6 00             	movzbl (%eax),%eax
  100a17:	84 c0                	test   %al,%al
  100a19:	75 02                	jne    100a1d <parse+0x4e>
            break;
  100a1b:	eb 67                	jmp    100a84 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a1d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a21:	75 14                	jne    100a37 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a23:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100a2a:	00 
  100a2b:	c7 04 24 4d 61 10 00 	movl   $0x10614d,(%esp)
  100a32:	e8 15 f9 ff ff       	call   10034c <cprintf>
        }
        argv[argc ++] = buf;
  100a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a3a:	8d 50 01             	lea    0x1(%eax),%edx
  100a3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100a40:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a4a:	01 c2                	add    %eax,%edx
  100a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  100a4f:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a51:	eb 04                	jmp    100a57 <parse+0x88>
            buf ++;
  100a53:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a57:	8b 45 08             	mov    0x8(%ebp),%eax
  100a5a:	0f b6 00             	movzbl (%eax),%eax
  100a5d:	84 c0                	test   %al,%al
  100a5f:	74 1d                	je     100a7e <parse+0xaf>
  100a61:	8b 45 08             	mov    0x8(%ebp),%eax
  100a64:	0f b6 00             	movzbl (%eax),%eax
  100a67:	0f be c0             	movsbl %al,%eax
  100a6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a6e:	c7 04 24 48 61 10 00 	movl   $0x106148,(%esp)
  100a75:	e8 7d 51 00 00       	call   105bf7 <strchr>
  100a7a:	85 c0                	test   %eax,%eax
  100a7c:	74 d5                	je     100a53 <parse+0x84>
            buf ++;
        }
    }
  100a7e:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a7f:	e9 66 ff ff ff       	jmp    1009ea <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100a87:	c9                   	leave  
  100a88:	c3                   	ret    

00100a89 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100a89:	55                   	push   %ebp
  100a8a:	89 e5                	mov    %esp,%ebp
  100a8c:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100a8f:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100a92:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a96:	8b 45 08             	mov    0x8(%ebp),%eax
  100a99:	89 04 24             	mov    %eax,(%esp)
  100a9c:	e8 2e ff ff ff       	call   1009cf <parse>
  100aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100aa4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100aa8:	75 0a                	jne    100ab4 <runcmd+0x2b>
        return 0;
  100aaa:	b8 00 00 00 00       	mov    $0x0,%eax
  100aaf:	e9 85 00 00 00       	jmp    100b39 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ab4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100abb:	eb 5c                	jmp    100b19 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100abd:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100ac0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ac3:	89 d0                	mov    %edx,%eax
  100ac5:	01 c0                	add    %eax,%eax
  100ac7:	01 d0                	add    %edx,%eax
  100ac9:	c1 e0 02             	shl    $0x2,%eax
  100acc:	05 20 70 11 00       	add    $0x117020,%eax
  100ad1:	8b 00                	mov    (%eax),%eax
  100ad3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100ad7:	89 04 24             	mov    %eax,(%esp)
  100ada:	e8 79 50 00 00       	call   105b58 <strcmp>
  100adf:	85 c0                	test   %eax,%eax
  100ae1:	75 32                	jne    100b15 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100ae3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ae6:	89 d0                	mov    %edx,%eax
  100ae8:	01 c0                	add    %eax,%eax
  100aea:	01 d0                	add    %edx,%eax
  100aec:	c1 e0 02             	shl    $0x2,%eax
  100aef:	05 20 70 11 00       	add    $0x117020,%eax
  100af4:	8b 40 08             	mov    0x8(%eax),%eax
  100af7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100afa:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b00:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b04:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b07:	83 c2 04             	add    $0x4,%edx
  100b0a:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b0e:	89 0c 24             	mov    %ecx,(%esp)
  100b11:	ff d0                	call   *%eax
  100b13:	eb 24                	jmp    100b39 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b15:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b1c:	83 f8 02             	cmp    $0x2,%eax
  100b1f:	76 9c                	jbe    100abd <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b21:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100b24:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b28:	c7 04 24 6b 61 10 00 	movl   $0x10616b,(%esp)
  100b2f:	e8 18 f8 ff ff       	call   10034c <cprintf>
    return 0;
  100b34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100b39:	c9                   	leave  
  100b3a:	c3                   	ret    

00100b3b <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100b3b:	55                   	push   %ebp
  100b3c:	89 e5                	mov    %esp,%ebp
  100b3e:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100b41:	c7 04 24 84 61 10 00 	movl   $0x106184,(%esp)
  100b48:	e8 ff f7 ff ff       	call   10034c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100b4d:	c7 04 24 ac 61 10 00 	movl   $0x1061ac,(%esp)
  100b54:	e8 f3 f7 ff ff       	call   10034c <cprintf>

    if (tf != NULL) {
  100b59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100b5d:	74 0b                	je     100b6a <kmonitor+0x2f>
        print_trapframe(tf);
  100b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b62:	89 04 24             	mov    %eax,(%esp)
  100b65:	e8 30 0e 00 00       	call   10199a <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100b6a:	c7 04 24 d1 61 10 00 	movl   $0x1061d1,(%esp)
  100b71:	e8 cd f6 ff ff       	call   100243 <readline>
  100b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100b79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b7d:	74 18                	je     100b97 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b82:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b89:	89 04 24             	mov    %eax,(%esp)
  100b8c:	e8 f8 fe ff ff       	call   100a89 <runcmd>
  100b91:	85 c0                	test   %eax,%eax
  100b93:	79 02                	jns    100b97 <kmonitor+0x5c>
                break;
  100b95:	eb 02                	jmp    100b99 <kmonitor+0x5e>
            }
        }
    }
  100b97:	eb d1                	jmp    100b6a <kmonitor+0x2f>
}
  100b99:	c9                   	leave  
  100b9a:	c3                   	ret    

00100b9b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100b9b:	55                   	push   %ebp
  100b9c:	89 e5                	mov    %esp,%ebp
  100b9e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ba1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100ba8:	eb 3f                	jmp    100be9 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100baa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bad:	89 d0                	mov    %edx,%eax
  100baf:	01 c0                	add    %eax,%eax
  100bb1:	01 d0                	add    %edx,%eax
  100bb3:	c1 e0 02             	shl    $0x2,%eax
  100bb6:	05 20 70 11 00       	add    $0x117020,%eax
  100bbb:	8b 48 04             	mov    0x4(%eax),%ecx
  100bbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bc1:	89 d0                	mov    %edx,%eax
  100bc3:	01 c0                	add    %eax,%eax
  100bc5:	01 d0                	add    %edx,%eax
  100bc7:	c1 e0 02             	shl    $0x2,%eax
  100bca:	05 20 70 11 00       	add    $0x117020,%eax
  100bcf:	8b 00                	mov    (%eax),%eax
  100bd1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd9:	c7 04 24 d5 61 10 00 	movl   $0x1061d5,(%esp)
  100be0:	e8 67 f7 ff ff       	call   10034c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100be5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bec:	83 f8 02             	cmp    $0x2,%eax
  100bef:	76 b9                	jbe    100baa <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100bf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bf6:	c9                   	leave  
  100bf7:	c3                   	ret    

00100bf8 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100bf8:	55                   	push   %ebp
  100bf9:	89 e5                	mov    %esp,%ebp
  100bfb:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100bfe:	e8 7d fc ff ff       	call   100880 <print_kerninfo>
    return 0;
  100c03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c08:	c9                   	leave  
  100c09:	c3                   	ret    

00100c0a <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c0a:	55                   	push   %ebp
  100c0b:	89 e5                	mov    %esp,%ebp
  100c0d:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c10:	e8 b5 fd ff ff       	call   1009ca <print_stackframe>
    return 0;
  100c15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c1a:	c9                   	leave  
  100c1b:	c3                   	ret    

00100c1c <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c1c:	55                   	push   %ebp
  100c1d:	89 e5                	mov    %esp,%ebp
  100c1f:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100c22:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100c27:	85 c0                	test   %eax,%eax
  100c29:	74 02                	je     100c2d <__panic+0x11>
        goto panic_dead;
  100c2b:	eb 48                	jmp    100c75 <__panic+0x59>
    }
    is_panic = 1;
  100c2d:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100c34:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100c37:	8d 45 14             	lea    0x14(%ebp),%eax
  100c3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c40:	89 44 24 08          	mov    %eax,0x8(%esp)
  100c44:	8b 45 08             	mov    0x8(%ebp),%eax
  100c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c4b:	c7 04 24 de 61 10 00 	movl   $0x1061de,(%esp)
  100c52:	e8 f5 f6 ff ff       	call   10034c <cprintf>
    vcprintf(fmt, ap);
  100c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c5e:	8b 45 10             	mov    0x10(%ebp),%eax
  100c61:	89 04 24             	mov    %eax,(%esp)
  100c64:	e8 b0 f6 ff ff       	call   100319 <vcprintf>
    cprintf("\n");
  100c69:	c7 04 24 fa 61 10 00 	movl   $0x1061fa,(%esp)
  100c70:	e8 d7 f6 ff ff       	call   10034c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100c75:	e8 85 09 00 00       	call   1015ff <intr_disable>
    while (1) {
        kmonitor(NULL);
  100c7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100c81:	e8 b5 fe ff ff       	call   100b3b <kmonitor>
    }
  100c86:	eb f2                	jmp    100c7a <__panic+0x5e>

00100c88 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100c88:	55                   	push   %ebp
  100c89:	89 e5                	mov    %esp,%ebp
  100c8b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100c8e:	8d 45 14             	lea    0x14(%ebp),%eax
  100c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c97:	89 44 24 08          	mov    %eax,0x8(%esp)
  100c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  100c9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ca2:	c7 04 24 fc 61 10 00 	movl   $0x1061fc,(%esp)
  100ca9:	e8 9e f6 ff ff       	call   10034c <cprintf>
    vcprintf(fmt, ap);
  100cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cb5:	8b 45 10             	mov    0x10(%ebp),%eax
  100cb8:	89 04 24             	mov    %eax,(%esp)
  100cbb:	e8 59 f6 ff ff       	call   100319 <vcprintf>
    cprintf("\n");
  100cc0:	c7 04 24 fa 61 10 00 	movl   $0x1061fa,(%esp)
  100cc7:	e8 80 f6 ff ff       	call   10034c <cprintf>
    va_end(ap);
}
  100ccc:	c9                   	leave  
  100ccd:	c3                   	ret    

00100cce <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100cce:	55                   	push   %ebp
  100ccf:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100cd1:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100cd6:	5d                   	pop    %ebp
  100cd7:	c3                   	ret    

00100cd8 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100cd8:	55                   	push   %ebp
  100cd9:	89 e5                	mov    %esp,%ebp
  100cdb:	83 ec 28             	sub    $0x28,%esp
  100cde:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100ce4:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ce8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100cec:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100cf0:	ee                   	out    %al,(%dx)
  100cf1:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100cf7:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100cfb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100cff:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d03:	ee                   	out    %al,(%dx)
  100d04:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d0a:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d0e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d12:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d16:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d17:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100d1e:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d21:	c7 04 24 1a 62 10 00 	movl   $0x10621a,(%esp)
  100d28:	e8 1f f6 ff ff       	call   10034c <cprintf>
    pic_enable(IRQ_TIMER);
  100d2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d34:	e8 24 09 00 00       	call   10165d <pic_enable>
}
  100d39:	c9                   	leave  
  100d3a:	c3                   	ret    

00100d3b <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100d3b:	55                   	push   %ebp
  100d3c:	89 e5                	mov    %esp,%ebp
  100d3e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100d41:	9c                   	pushf  
  100d42:	58                   	pop    %eax
  100d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100d49:	25 00 02 00 00       	and    $0x200,%eax
  100d4e:	85 c0                	test   %eax,%eax
  100d50:	74 0c                	je     100d5e <__intr_save+0x23>
        intr_disable();
  100d52:	e8 a8 08 00 00       	call   1015ff <intr_disable>
        return 1;
  100d57:	b8 01 00 00 00       	mov    $0x1,%eax
  100d5c:	eb 05                	jmp    100d63 <__intr_save+0x28>
    }
    return 0;
  100d5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d63:	c9                   	leave  
  100d64:	c3                   	ret    

00100d65 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100d65:	55                   	push   %ebp
  100d66:	89 e5                	mov    %esp,%ebp
  100d68:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100d6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d6f:	74 05                	je     100d76 <__intr_restore+0x11>
        intr_enable();
  100d71:	e8 83 08 00 00       	call   1015f9 <intr_enable>
    }
}
  100d76:	c9                   	leave  
  100d77:	c3                   	ret    

00100d78 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100d78:	55                   	push   %ebp
  100d79:	89 e5                	mov    %esp,%ebp
  100d7b:	83 ec 10             	sub    $0x10,%esp
  100d7e:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100d84:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100d88:	89 c2                	mov    %eax,%edx
  100d8a:	ec                   	in     (%dx),%al
  100d8b:	88 45 fd             	mov    %al,-0x3(%ebp)
  100d8e:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100d94:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100d98:	89 c2                	mov    %eax,%edx
  100d9a:	ec                   	in     (%dx),%al
  100d9b:	88 45 f9             	mov    %al,-0x7(%ebp)
  100d9e:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100da4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100da8:	89 c2                	mov    %eax,%edx
  100daa:	ec                   	in     (%dx),%al
  100dab:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dae:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100db4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100db8:	89 c2                	mov    %eax,%edx
  100dba:	ec                   	in     (%dx),%al
  100dbb:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100dbe:	c9                   	leave  
  100dbf:	c3                   	ret    

00100dc0 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100dc0:	55                   	push   %ebp
  100dc1:	89 e5                	mov    %esp,%ebp
  100dc3:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100dc6:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100dcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dd0:	0f b7 00             	movzwl (%eax),%eax
  100dd3:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dda:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100de2:	0f b7 00             	movzwl (%eax),%eax
  100de5:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100de9:	74 12                	je     100dfd <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100deb:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100df2:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100df9:	b4 03 
  100dfb:	eb 13                	jmp    100e10 <cga_init+0x50>
    } else {
        *cp = was;
  100dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e00:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e04:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e07:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100e0e:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e10:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100e17:	0f b7 c0             	movzwl %ax,%eax
  100e1a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e1e:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e22:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e26:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e2a:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e2b:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100e32:	83 c0 01             	add    $0x1,%eax
  100e35:	0f b7 c0             	movzwl %ax,%eax
  100e38:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e3c:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e40:	89 c2                	mov    %eax,%edx
  100e42:	ec                   	in     (%dx),%al
  100e43:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e46:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e4a:	0f b6 c0             	movzbl %al,%eax
  100e4d:	c1 e0 08             	shl    $0x8,%eax
  100e50:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e53:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100e5a:	0f b7 c0             	movzwl %ax,%eax
  100e5d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100e61:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e65:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e69:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e6d:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100e6e:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100e75:	83 c0 01             	add    $0x1,%eax
  100e78:	0f b7 c0             	movzwl %ax,%eax
  100e7b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e7f:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100e83:	89 c2                	mov    %eax,%edx
  100e85:	ec                   	in     (%dx),%al
  100e86:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100e89:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e8d:	0f b6 c0             	movzbl %al,%eax
  100e90:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e96:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100e9e:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100ea4:	c9                   	leave  
  100ea5:	c3                   	ret    

00100ea6 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ea6:	55                   	push   %ebp
  100ea7:	89 e5                	mov    %esp,%ebp
  100ea9:	83 ec 48             	sub    $0x48,%esp
  100eac:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100eb2:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100eb6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100eba:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ebe:	ee                   	out    %al,(%dx)
  100ebf:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100ec5:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100ec9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ecd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ed1:	ee                   	out    %al,(%dx)
  100ed2:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100ed8:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100edc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ee0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ee4:	ee                   	out    %al,(%dx)
  100ee5:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100eeb:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100eef:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ef3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ef7:	ee                   	out    %al,(%dx)
  100ef8:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100efe:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f02:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f06:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f0a:	ee                   	out    %al,(%dx)
  100f0b:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f11:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f15:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f19:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f1d:	ee                   	out    %al,(%dx)
  100f1e:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f24:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f28:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f2c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f30:	ee                   	out    %al,(%dx)
  100f31:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f37:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f3b:	89 c2                	mov    %eax,%edx
  100f3d:	ec                   	in     (%dx),%al
  100f3e:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f41:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f45:	3c ff                	cmp    $0xff,%al
  100f47:	0f 95 c0             	setne  %al
  100f4a:	0f b6 c0             	movzbl %al,%eax
  100f4d:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100f52:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f58:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100f5c:	89 c2                	mov    %eax,%edx
  100f5e:	ec                   	in     (%dx),%al
  100f5f:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100f62:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100f68:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100f6c:	89 c2                	mov    %eax,%edx
  100f6e:	ec                   	in     (%dx),%al
  100f6f:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100f72:	a1 88 7e 11 00       	mov    0x117e88,%eax
  100f77:	85 c0                	test   %eax,%eax
  100f79:	74 0c                	je     100f87 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100f7b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100f82:	e8 d6 06 00 00       	call   10165d <pic_enable>
    }
}
  100f87:	c9                   	leave  
  100f88:	c3                   	ret    

00100f89 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100f89:	55                   	push   %ebp
  100f8a:	89 e5                	mov    %esp,%ebp
  100f8c:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100f96:	eb 09                	jmp    100fa1 <lpt_putc_sub+0x18>
        delay();
  100f98:	e8 db fd ff ff       	call   100d78 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f9d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fa1:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fa7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fab:	89 c2                	mov    %eax,%edx
  100fad:	ec                   	in     (%dx),%al
  100fae:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fb1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100fb5:	84 c0                	test   %al,%al
  100fb7:	78 09                	js     100fc2 <lpt_putc_sub+0x39>
  100fb9:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fc0:	7e d6                	jle    100f98 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  100fc5:	0f b6 c0             	movzbl %al,%eax
  100fc8:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  100fce:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fd1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100fd5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100fd9:	ee                   	out    %al,(%dx)
  100fda:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  100fe0:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  100fe4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fe8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100fec:	ee                   	out    %al,(%dx)
  100fed:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  100ff3:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  100ff7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ffb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fff:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101000:	c9                   	leave  
  101001:	c3                   	ret    

00101002 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101002:	55                   	push   %ebp
  101003:	89 e5                	mov    %esp,%ebp
  101005:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101008:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10100c:	74 0d                	je     10101b <lpt_putc+0x19>
        lpt_putc_sub(c);
  10100e:	8b 45 08             	mov    0x8(%ebp),%eax
  101011:	89 04 24             	mov    %eax,(%esp)
  101014:	e8 70 ff ff ff       	call   100f89 <lpt_putc_sub>
  101019:	eb 24                	jmp    10103f <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  10101b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101022:	e8 62 ff ff ff       	call   100f89 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101027:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10102e:	e8 56 ff ff ff       	call   100f89 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101033:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10103a:	e8 4a ff ff ff       	call   100f89 <lpt_putc_sub>
    }
}
  10103f:	c9                   	leave  
  101040:	c3                   	ret    

00101041 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101041:	55                   	push   %ebp
  101042:	89 e5                	mov    %esp,%ebp
  101044:	53                   	push   %ebx
  101045:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101048:	8b 45 08             	mov    0x8(%ebp),%eax
  10104b:	b0 00                	mov    $0x0,%al
  10104d:	85 c0                	test   %eax,%eax
  10104f:	75 07                	jne    101058 <cga_putc+0x17>
        c |= 0x0700;
  101051:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101058:	8b 45 08             	mov    0x8(%ebp),%eax
  10105b:	0f b6 c0             	movzbl %al,%eax
  10105e:	83 f8 0a             	cmp    $0xa,%eax
  101061:	74 4c                	je     1010af <cga_putc+0x6e>
  101063:	83 f8 0d             	cmp    $0xd,%eax
  101066:	74 57                	je     1010bf <cga_putc+0x7e>
  101068:	83 f8 08             	cmp    $0x8,%eax
  10106b:	0f 85 88 00 00 00    	jne    1010f9 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101071:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101078:	66 85 c0             	test   %ax,%ax
  10107b:	74 30                	je     1010ad <cga_putc+0x6c>
            crt_pos --;
  10107d:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101084:	83 e8 01             	sub    $0x1,%eax
  101087:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10108d:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101092:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101099:	0f b7 d2             	movzwl %dx,%edx
  10109c:	01 d2                	add    %edx,%edx
  10109e:	01 c2                	add    %eax,%edx
  1010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a3:	b0 00                	mov    $0x0,%al
  1010a5:	83 c8 20             	or     $0x20,%eax
  1010a8:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010ab:	eb 72                	jmp    10111f <cga_putc+0xde>
  1010ad:	eb 70                	jmp    10111f <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  1010af:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1010b6:	83 c0 50             	add    $0x50,%eax
  1010b9:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010bf:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  1010c6:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  1010cd:	0f b7 c1             	movzwl %cx,%eax
  1010d0:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1010d6:	c1 e8 10             	shr    $0x10,%eax
  1010d9:	89 c2                	mov    %eax,%edx
  1010db:	66 c1 ea 06          	shr    $0x6,%dx
  1010df:	89 d0                	mov    %edx,%eax
  1010e1:	c1 e0 02             	shl    $0x2,%eax
  1010e4:	01 d0                	add    %edx,%eax
  1010e6:	c1 e0 04             	shl    $0x4,%eax
  1010e9:	29 c1                	sub    %eax,%ecx
  1010eb:	89 ca                	mov    %ecx,%edx
  1010ed:	89 d8                	mov    %ebx,%eax
  1010ef:	29 d0                	sub    %edx,%eax
  1010f1:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1010f7:	eb 26                	jmp    10111f <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1010f9:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1010ff:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101106:	8d 50 01             	lea    0x1(%eax),%edx
  101109:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  101110:	0f b7 c0             	movzwl %ax,%eax
  101113:	01 c0                	add    %eax,%eax
  101115:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101118:	8b 45 08             	mov    0x8(%ebp),%eax
  10111b:	66 89 02             	mov    %ax,(%edx)
        break;
  10111e:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10111f:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101126:	66 3d cf 07          	cmp    $0x7cf,%ax
  10112a:	76 5b                	jbe    101187 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10112c:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101131:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101137:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10113c:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101143:	00 
  101144:	89 54 24 04          	mov    %edx,0x4(%esp)
  101148:	89 04 24             	mov    %eax,(%esp)
  10114b:	e8 a5 4c 00 00       	call   105df5 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101150:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101157:	eb 15                	jmp    10116e <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101159:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10115e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101161:	01 d2                	add    %edx,%edx
  101163:	01 d0                	add    %edx,%eax
  101165:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10116a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10116e:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101175:	7e e2                	jle    101159 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101177:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10117e:	83 e8 50             	sub    $0x50,%eax
  101181:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101187:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10118e:	0f b7 c0             	movzwl %ax,%eax
  101191:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101195:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101199:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10119d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011a1:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011a2:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011a9:	66 c1 e8 08          	shr    $0x8,%ax
  1011ad:	0f b6 c0             	movzbl %al,%eax
  1011b0:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1011b7:	83 c2 01             	add    $0x1,%edx
  1011ba:	0f b7 d2             	movzwl %dx,%edx
  1011bd:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  1011c1:	88 45 ed             	mov    %al,-0x13(%ebp)
  1011c4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1011c8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1011cc:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011cd:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  1011d4:	0f b7 c0             	movzwl %ax,%eax
  1011d7:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1011db:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  1011df:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1011e3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1011e7:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1011e8:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011ef:	0f b6 c0             	movzbl %al,%eax
  1011f2:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1011f9:	83 c2 01             	add    $0x1,%edx
  1011fc:	0f b7 d2             	movzwl %dx,%edx
  1011ff:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101203:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101206:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10120a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10120e:	ee                   	out    %al,(%dx)
}
  10120f:	83 c4 34             	add    $0x34,%esp
  101212:	5b                   	pop    %ebx
  101213:	5d                   	pop    %ebp
  101214:	c3                   	ret    

00101215 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101215:	55                   	push   %ebp
  101216:	89 e5                	mov    %esp,%ebp
  101218:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10121b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101222:	eb 09                	jmp    10122d <serial_putc_sub+0x18>
        delay();
  101224:	e8 4f fb ff ff       	call   100d78 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101229:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10122d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101233:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101237:	89 c2                	mov    %eax,%edx
  101239:	ec                   	in     (%dx),%al
  10123a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10123d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101241:	0f b6 c0             	movzbl %al,%eax
  101244:	83 e0 20             	and    $0x20,%eax
  101247:	85 c0                	test   %eax,%eax
  101249:	75 09                	jne    101254 <serial_putc_sub+0x3f>
  10124b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101252:	7e d0                	jle    101224 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101254:	8b 45 08             	mov    0x8(%ebp),%eax
  101257:	0f b6 c0             	movzbl %al,%eax
  10125a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101260:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101263:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101267:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10126b:	ee                   	out    %al,(%dx)
}
  10126c:	c9                   	leave  
  10126d:	c3                   	ret    

0010126e <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10126e:	55                   	push   %ebp
  10126f:	89 e5                	mov    %esp,%ebp
  101271:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101274:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101278:	74 0d                	je     101287 <serial_putc+0x19>
        serial_putc_sub(c);
  10127a:	8b 45 08             	mov    0x8(%ebp),%eax
  10127d:	89 04 24             	mov    %eax,(%esp)
  101280:	e8 90 ff ff ff       	call   101215 <serial_putc_sub>
  101285:	eb 24                	jmp    1012ab <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101287:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10128e:	e8 82 ff ff ff       	call   101215 <serial_putc_sub>
        serial_putc_sub(' ');
  101293:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10129a:	e8 76 ff ff ff       	call   101215 <serial_putc_sub>
        serial_putc_sub('\b');
  10129f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012a6:	e8 6a ff ff ff       	call   101215 <serial_putc_sub>
    }
}
  1012ab:	c9                   	leave  
  1012ac:	c3                   	ret    

001012ad <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012ad:	55                   	push   %ebp
  1012ae:	89 e5                	mov    %esp,%ebp
  1012b0:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012b3:	eb 33                	jmp    1012e8 <cons_intr+0x3b>
        if (c != 0) {
  1012b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012b9:	74 2d                	je     1012e8 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012bb:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  1012c0:	8d 50 01             	lea    0x1(%eax),%edx
  1012c3:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  1012c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012cc:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012d2:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  1012d7:	3d 00 02 00 00       	cmp    $0x200,%eax
  1012dc:	75 0a                	jne    1012e8 <cons_intr+0x3b>
                cons.wpos = 0;
  1012de:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  1012e5:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  1012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1012eb:	ff d0                	call   *%eax
  1012ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1012f0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1012f4:	75 bf                	jne    1012b5 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1012f6:	c9                   	leave  
  1012f7:	c3                   	ret    

001012f8 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1012f8:	55                   	push   %ebp
  1012f9:	89 e5                	mov    %esp,%ebp
  1012fb:	83 ec 10             	sub    $0x10,%esp
  1012fe:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101304:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101308:	89 c2                	mov    %eax,%edx
  10130a:	ec                   	in     (%dx),%al
  10130b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10130e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101312:	0f b6 c0             	movzbl %al,%eax
  101315:	83 e0 01             	and    $0x1,%eax
  101318:	85 c0                	test   %eax,%eax
  10131a:	75 07                	jne    101323 <serial_proc_data+0x2b>
        return -1;
  10131c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101321:	eb 2a                	jmp    10134d <serial_proc_data+0x55>
  101323:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101329:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10132d:	89 c2                	mov    %eax,%edx
  10132f:	ec                   	in     (%dx),%al
  101330:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101333:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101337:	0f b6 c0             	movzbl %al,%eax
  10133a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10133d:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101341:	75 07                	jne    10134a <serial_proc_data+0x52>
        c = '\b';
  101343:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10134a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10134d:	c9                   	leave  
  10134e:	c3                   	ret    

0010134f <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10134f:	55                   	push   %ebp
  101350:	89 e5                	mov    %esp,%ebp
  101352:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101355:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10135a:	85 c0                	test   %eax,%eax
  10135c:	74 0c                	je     10136a <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10135e:	c7 04 24 f8 12 10 00 	movl   $0x1012f8,(%esp)
  101365:	e8 43 ff ff ff       	call   1012ad <cons_intr>
    }
}
  10136a:	c9                   	leave  
  10136b:	c3                   	ret    

0010136c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10136c:	55                   	push   %ebp
  10136d:	89 e5                	mov    %esp,%ebp
  10136f:	83 ec 38             	sub    $0x38,%esp
  101372:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101378:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10137c:	89 c2                	mov    %eax,%edx
  10137e:	ec                   	in     (%dx),%al
  10137f:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101382:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101386:	0f b6 c0             	movzbl %al,%eax
  101389:	83 e0 01             	and    $0x1,%eax
  10138c:	85 c0                	test   %eax,%eax
  10138e:	75 0a                	jne    10139a <kbd_proc_data+0x2e>
        return -1;
  101390:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101395:	e9 59 01 00 00       	jmp    1014f3 <kbd_proc_data+0x187>
  10139a:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013a0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013a4:	89 c2                	mov    %eax,%edx
  1013a6:	ec                   	in     (%dx),%al
  1013a7:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013aa:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013ae:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013b1:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013b5:	75 17                	jne    1013ce <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013b7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1013bc:	83 c8 40             	or     $0x40,%eax
  1013bf:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1013c4:	b8 00 00 00 00       	mov    $0x0,%eax
  1013c9:	e9 25 01 00 00       	jmp    1014f3 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1013ce:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013d2:	84 c0                	test   %al,%al
  1013d4:	79 47                	jns    10141d <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1013d6:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1013db:	83 e0 40             	and    $0x40,%eax
  1013de:	85 c0                	test   %eax,%eax
  1013e0:	75 09                	jne    1013eb <kbd_proc_data+0x7f>
  1013e2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013e6:	83 e0 7f             	and    $0x7f,%eax
  1013e9:	eb 04                	jmp    1013ef <kbd_proc_data+0x83>
  1013eb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013ef:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1013f2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013f6:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1013fd:	83 c8 40             	or     $0x40,%eax
  101400:	0f b6 c0             	movzbl %al,%eax
  101403:	f7 d0                	not    %eax
  101405:	89 c2                	mov    %eax,%edx
  101407:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10140c:	21 d0                	and    %edx,%eax
  10140e:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101413:	b8 00 00 00 00       	mov    $0x0,%eax
  101418:	e9 d6 00 00 00       	jmp    1014f3 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  10141d:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101422:	83 e0 40             	and    $0x40,%eax
  101425:	85 c0                	test   %eax,%eax
  101427:	74 11                	je     10143a <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101429:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10142d:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101432:	83 e0 bf             	and    $0xffffffbf,%eax
  101435:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  10143a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10143e:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  101445:	0f b6 d0             	movzbl %al,%edx
  101448:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10144d:	09 d0                	or     %edx,%eax
  10144f:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  101454:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101458:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  10145f:	0f b6 d0             	movzbl %al,%edx
  101462:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101467:	31 d0                	xor    %edx,%eax
  101469:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  10146e:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101473:	83 e0 03             	and    $0x3,%eax
  101476:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  10147d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101481:	01 d0                	add    %edx,%eax
  101483:	0f b6 00             	movzbl (%eax),%eax
  101486:	0f b6 c0             	movzbl %al,%eax
  101489:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10148c:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101491:	83 e0 08             	and    $0x8,%eax
  101494:	85 c0                	test   %eax,%eax
  101496:	74 22                	je     1014ba <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101498:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10149c:	7e 0c                	jle    1014aa <kbd_proc_data+0x13e>
  10149e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014a2:	7f 06                	jg     1014aa <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014a4:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014a8:	eb 10                	jmp    1014ba <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014aa:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014ae:	7e 0a                	jle    1014ba <kbd_proc_data+0x14e>
  1014b0:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014b4:	7f 04                	jg     1014ba <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014b6:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014ba:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014bf:	f7 d0                	not    %eax
  1014c1:	83 e0 06             	and    $0x6,%eax
  1014c4:	85 c0                	test   %eax,%eax
  1014c6:	75 28                	jne    1014f0 <kbd_proc_data+0x184>
  1014c8:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1014cf:	75 1f                	jne    1014f0 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1014d1:	c7 04 24 35 62 10 00 	movl   $0x106235,(%esp)
  1014d8:	e8 6f ee ff ff       	call   10034c <cprintf>
  1014dd:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1014e3:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1014e7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1014eb:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1014ef:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1014f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1014f3:	c9                   	leave  
  1014f4:	c3                   	ret    

001014f5 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1014f5:	55                   	push   %ebp
  1014f6:	89 e5                	mov    %esp,%ebp
  1014f8:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1014fb:	c7 04 24 6c 13 10 00 	movl   $0x10136c,(%esp)
  101502:	e8 a6 fd ff ff       	call   1012ad <cons_intr>
}
  101507:	c9                   	leave  
  101508:	c3                   	ret    

00101509 <kbd_init>:

static void
kbd_init(void) {
  101509:	55                   	push   %ebp
  10150a:	89 e5                	mov    %esp,%ebp
  10150c:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10150f:	e8 e1 ff ff ff       	call   1014f5 <kbd_intr>
    pic_enable(IRQ_KBD);
  101514:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10151b:	e8 3d 01 00 00       	call   10165d <pic_enable>
}
  101520:	c9                   	leave  
  101521:	c3                   	ret    

00101522 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101522:	55                   	push   %ebp
  101523:	89 e5                	mov    %esp,%ebp
  101525:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101528:	e8 93 f8 ff ff       	call   100dc0 <cga_init>
    serial_init();
  10152d:	e8 74 f9 ff ff       	call   100ea6 <serial_init>
    kbd_init();
  101532:	e8 d2 ff ff ff       	call   101509 <kbd_init>
    if (!serial_exists) {
  101537:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10153c:	85 c0                	test   %eax,%eax
  10153e:	75 0c                	jne    10154c <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101540:	c7 04 24 41 62 10 00 	movl   $0x106241,(%esp)
  101547:	e8 00 ee ff ff       	call   10034c <cprintf>
    }
}
  10154c:	c9                   	leave  
  10154d:	c3                   	ret    

0010154e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10154e:	55                   	push   %ebp
  10154f:	89 e5                	mov    %esp,%ebp
  101551:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101554:	e8 e2 f7 ff ff       	call   100d3b <__intr_save>
  101559:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10155c:	8b 45 08             	mov    0x8(%ebp),%eax
  10155f:	89 04 24             	mov    %eax,(%esp)
  101562:	e8 9b fa ff ff       	call   101002 <lpt_putc>
        cga_putc(c);
  101567:	8b 45 08             	mov    0x8(%ebp),%eax
  10156a:	89 04 24             	mov    %eax,(%esp)
  10156d:	e8 cf fa ff ff       	call   101041 <cga_putc>
        serial_putc(c);
  101572:	8b 45 08             	mov    0x8(%ebp),%eax
  101575:	89 04 24             	mov    %eax,(%esp)
  101578:	e8 f1 fc ff ff       	call   10126e <serial_putc>
    }
    local_intr_restore(intr_flag);
  10157d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101580:	89 04 24             	mov    %eax,(%esp)
  101583:	e8 dd f7 ff ff       	call   100d65 <__intr_restore>
}
  101588:	c9                   	leave  
  101589:	c3                   	ret    

0010158a <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10158a:	55                   	push   %ebp
  10158b:	89 e5                	mov    %esp,%ebp
  10158d:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101590:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101597:	e8 9f f7 ff ff       	call   100d3b <__intr_save>
  10159c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10159f:	e8 ab fd ff ff       	call   10134f <serial_intr>
        kbd_intr();
  1015a4:	e8 4c ff ff ff       	call   1014f5 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  1015a9:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  1015af:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  1015b4:	39 c2                	cmp    %eax,%edx
  1015b6:	74 31                	je     1015e9 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  1015b8:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  1015bd:	8d 50 01             	lea    0x1(%eax),%edx
  1015c0:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  1015c6:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  1015cd:	0f b6 c0             	movzbl %al,%eax
  1015d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  1015d3:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  1015d8:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015dd:	75 0a                	jne    1015e9 <cons_getc+0x5f>
                cons.rpos = 0;
  1015df:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  1015e6:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1015e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1015ec:	89 04 24             	mov    %eax,(%esp)
  1015ef:	e8 71 f7 ff ff       	call   100d65 <__intr_restore>
    return c;
  1015f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015f7:	c9                   	leave  
  1015f8:	c3                   	ret    

001015f9 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1015f9:	55                   	push   %ebp
  1015fa:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1015fc:	fb                   	sti    
    sti();
}
  1015fd:	5d                   	pop    %ebp
  1015fe:	c3                   	ret    

001015ff <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1015ff:	55                   	push   %ebp
  101600:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  101602:	fa                   	cli    
    cli();
}
  101603:	5d                   	pop    %ebp
  101604:	c3                   	ret    

00101605 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101605:	55                   	push   %ebp
  101606:	89 e5                	mov    %esp,%ebp
  101608:	83 ec 14             	sub    $0x14,%esp
  10160b:	8b 45 08             	mov    0x8(%ebp),%eax
  10160e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101612:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101616:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  10161c:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  101621:	85 c0                	test   %eax,%eax
  101623:	74 36                	je     10165b <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101625:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101629:	0f b6 c0             	movzbl %al,%eax
  10162c:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101632:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101635:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101639:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10163d:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10163e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101642:	66 c1 e8 08          	shr    $0x8,%ax
  101646:	0f b6 c0             	movzbl %al,%eax
  101649:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10164f:	88 45 f9             	mov    %al,-0x7(%ebp)
  101652:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101656:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10165a:	ee                   	out    %al,(%dx)
    }
}
  10165b:	c9                   	leave  
  10165c:	c3                   	ret    

0010165d <pic_enable>:

void
pic_enable(unsigned int irq) {
  10165d:	55                   	push   %ebp
  10165e:	89 e5                	mov    %esp,%ebp
  101660:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101663:	8b 45 08             	mov    0x8(%ebp),%eax
  101666:	ba 01 00 00 00       	mov    $0x1,%edx
  10166b:	89 c1                	mov    %eax,%ecx
  10166d:	d3 e2                	shl    %cl,%edx
  10166f:	89 d0                	mov    %edx,%eax
  101671:	f7 d0                	not    %eax
  101673:	89 c2                	mov    %eax,%edx
  101675:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10167c:	21 d0                	and    %edx,%eax
  10167e:	0f b7 c0             	movzwl %ax,%eax
  101681:	89 04 24             	mov    %eax,(%esp)
  101684:	e8 7c ff ff ff       	call   101605 <pic_setmask>
}
  101689:	c9                   	leave  
  10168a:	c3                   	ret    

0010168b <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10168b:	55                   	push   %ebp
  10168c:	89 e5                	mov    %esp,%ebp
  10168e:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101691:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101698:	00 00 00 
  10169b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016a1:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016a5:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016a9:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016ad:	ee                   	out    %al,(%dx)
  1016ae:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016b4:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016bc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016c0:	ee                   	out    %al,(%dx)
  1016c1:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016c7:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016cb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016cf:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016d3:	ee                   	out    %al,(%dx)
  1016d4:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1016da:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1016de:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1016e2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1016e6:	ee                   	out    %al,(%dx)
  1016e7:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1016ed:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1016f1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1016f5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1016f9:	ee                   	out    %al,(%dx)
  1016fa:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101700:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101704:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101708:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10170c:	ee                   	out    %al,(%dx)
  10170d:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101713:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101717:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10171b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10171f:	ee                   	out    %al,(%dx)
  101720:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101726:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  10172a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10172e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101732:	ee                   	out    %al,(%dx)
  101733:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101739:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10173d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101741:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101745:	ee                   	out    %al,(%dx)
  101746:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10174c:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101750:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101754:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101758:	ee                   	out    %al,(%dx)
  101759:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10175f:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101763:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101767:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10176b:	ee                   	out    %al,(%dx)
  10176c:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101772:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101776:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10177a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10177e:	ee                   	out    %al,(%dx)
  10177f:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101785:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101789:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10178d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101791:	ee                   	out    %al,(%dx)
  101792:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101798:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  10179c:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017a0:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017a4:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017a5:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  1017ac:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017b0:	74 12                	je     1017c4 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017b2:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  1017b9:	0f b7 c0             	movzwl %ax,%eax
  1017bc:	89 04 24             	mov    %eax,(%esp)
  1017bf:	e8 41 fe ff ff       	call   101605 <pic_setmask>
    }
}
  1017c4:	c9                   	leave  
  1017c5:	c3                   	ret    

001017c6 <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  1017c6:	55                   	push   %ebp
  1017c7:	89 e5                	mov    %esp,%ebp
  1017c9:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017cc:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017d3:	00 
  1017d4:	c7 04 24 60 62 10 00 	movl   $0x106260,(%esp)
  1017db:	e8 6c eb ff ff       	call   10034c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1017e0:	c9                   	leave  
  1017e1:	c3                   	ret    

001017e2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1017e2:	55                   	push   %ebp
  1017e3:	89 e5                	mov    %esp,%ebp
  1017e5:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
     extern uintptr_t __vectors[];
     int i;
     for (i = 0; i < sizeof(idt)/sizeof(struct gatedesc); i++)
  1017e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1017ef:	e9 c3 00 00 00       	jmp    1018b7 <idt_init+0xd5>
     	SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1017f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017f7:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1017fe:	89 c2                	mov    %eax,%edx
  101800:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101803:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  10180a:	00 
  10180b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10180e:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  101815:	00 08 00 
  101818:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10181b:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  101822:	00 
  101823:	83 e2 e0             	and    $0xffffffe0,%edx
  101826:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  10182d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101830:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  101837:	00 
  101838:	83 e2 1f             	and    $0x1f,%edx
  10183b:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101842:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101845:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10184c:	00 
  10184d:	83 e2 f0             	and    $0xfffffff0,%edx
  101850:	83 ca 0e             	or     $0xe,%edx
  101853:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10185a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10185d:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101864:	00 
  101865:	83 e2 ef             	and    $0xffffffef,%edx
  101868:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10186f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101872:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101879:	00 
  10187a:	83 e2 9f             	and    $0xffffff9f,%edx
  10187d:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101884:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101887:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10188e:	00 
  10188f:	83 ca 80             	or     $0xffffff80,%edx
  101892:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101899:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10189c:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018a3:	c1 e8 10             	shr    $0x10,%eax
  1018a6:	89 c2                	mov    %eax,%edx
  1018a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ab:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  1018b2:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
     extern uintptr_t __vectors[];
     int i;
     for (i = 0; i < sizeof(idt)/sizeof(struct gatedesc); i++)
  1018b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ba:	3d ff 00 00 00       	cmp    $0xff,%eax
  1018bf:	0f 86 2f ff ff ff    	jbe    1017f4 <idt_init+0x12>
     	SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
     SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_KERNEL);
  1018c5:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  1018ca:	66 a3 88 84 11 00    	mov    %ax,0x118488
  1018d0:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  1018d7:	08 00 
  1018d9:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1018e0:	83 e0 e0             	and    $0xffffffe0,%eax
  1018e3:	a2 8c 84 11 00       	mov    %al,0x11848c
  1018e8:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1018ef:	83 e0 1f             	and    $0x1f,%eax
  1018f2:	a2 8c 84 11 00       	mov    %al,0x11848c
  1018f7:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1018fe:	83 e0 f0             	and    $0xfffffff0,%eax
  101901:	83 c8 0e             	or     $0xe,%eax
  101904:	a2 8d 84 11 00       	mov    %al,0x11848d
  101909:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  101910:	83 e0 ef             	and    $0xffffffef,%eax
  101913:	a2 8d 84 11 00       	mov    %al,0x11848d
  101918:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  10191f:	83 e0 9f             	and    $0xffffff9f,%eax
  101922:	a2 8d 84 11 00       	mov    %al,0x11848d
  101927:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  10192e:	83 c8 80             	or     $0xffffff80,%eax
  101931:	a2 8d 84 11 00       	mov    %al,0x11848d
  101936:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  10193b:	c1 e8 10             	shr    $0x10,%eax
  10193e:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  101944:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  10194b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10194e:	0f 01 18             	lidtl  (%eax)
     lidt(&idt_pd);
}
  101951:	c9                   	leave  
  101952:	c3                   	ret    

00101953 <trapname>:

static const char *
trapname(int trapno) {
  101953:	55                   	push   %ebp
  101954:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101956:	8b 45 08             	mov    0x8(%ebp),%eax
  101959:	83 f8 13             	cmp    $0x13,%eax
  10195c:	77 0c                	ja     10196a <trapname+0x17>
        return excnames[trapno];
  10195e:	8b 45 08             	mov    0x8(%ebp),%eax
  101961:	8b 04 85 c0 65 10 00 	mov    0x1065c0(,%eax,4),%eax
  101968:	eb 18                	jmp    101982 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  10196a:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  10196e:	7e 0d                	jle    10197d <trapname+0x2a>
  101970:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101974:	7f 07                	jg     10197d <trapname+0x2a>
        return "Hardware Interrupt";
  101976:	b8 6a 62 10 00       	mov    $0x10626a,%eax
  10197b:	eb 05                	jmp    101982 <trapname+0x2f>
    }
    return "(unknown trap)";
  10197d:	b8 7d 62 10 00       	mov    $0x10627d,%eax
}
  101982:	5d                   	pop    %ebp
  101983:	c3                   	ret    

00101984 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101984:	55                   	push   %ebp
  101985:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101987:	8b 45 08             	mov    0x8(%ebp),%eax
  10198a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10198e:	66 83 f8 08          	cmp    $0x8,%ax
  101992:	0f 94 c0             	sete   %al
  101995:	0f b6 c0             	movzbl %al,%eax
}
  101998:	5d                   	pop    %ebp
  101999:	c3                   	ret    

0010199a <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  10199a:	55                   	push   %ebp
  10199b:	89 e5                	mov    %esp,%ebp
  10199d:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019a7:	c7 04 24 be 62 10 00 	movl   $0x1062be,(%esp)
  1019ae:	e8 99 e9 ff ff       	call   10034c <cprintf>
    print_regs(&tf->tf_regs);
  1019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b6:	89 04 24             	mov    %eax,(%esp)
  1019b9:	e8 a1 01 00 00       	call   101b5f <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1019be:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c1:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1019c5:	0f b7 c0             	movzwl %ax,%eax
  1019c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019cc:	c7 04 24 cf 62 10 00 	movl   $0x1062cf,(%esp)
  1019d3:	e8 74 e9 ff ff       	call   10034c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019db:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1019df:	0f b7 c0             	movzwl %ax,%eax
  1019e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019e6:	c7 04 24 e2 62 10 00 	movl   $0x1062e2,(%esp)
  1019ed:	e8 5a e9 ff ff       	call   10034c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f5:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  1019f9:	0f b7 c0             	movzwl %ax,%eax
  1019fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a00:	c7 04 24 f5 62 10 00 	movl   $0x1062f5,(%esp)
  101a07:	e8 40 e9 ff ff       	call   10034c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a13:	0f b7 c0             	movzwl %ax,%eax
  101a16:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a1a:	c7 04 24 08 63 10 00 	movl   $0x106308,(%esp)
  101a21:	e8 26 e9 ff ff       	call   10034c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a26:	8b 45 08             	mov    0x8(%ebp),%eax
  101a29:	8b 40 30             	mov    0x30(%eax),%eax
  101a2c:	89 04 24             	mov    %eax,(%esp)
  101a2f:	e8 1f ff ff ff       	call   101953 <trapname>
  101a34:	8b 55 08             	mov    0x8(%ebp),%edx
  101a37:	8b 52 30             	mov    0x30(%edx),%edx
  101a3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a3e:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a42:	c7 04 24 1b 63 10 00 	movl   $0x10631b,(%esp)
  101a49:	e8 fe e8 ff ff       	call   10034c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a51:	8b 40 34             	mov    0x34(%eax),%eax
  101a54:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a58:	c7 04 24 2d 63 10 00 	movl   $0x10632d,(%esp)
  101a5f:	e8 e8 e8 ff ff       	call   10034c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a64:	8b 45 08             	mov    0x8(%ebp),%eax
  101a67:	8b 40 38             	mov    0x38(%eax),%eax
  101a6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a6e:	c7 04 24 3c 63 10 00 	movl   $0x10633c,(%esp)
  101a75:	e8 d2 e8 ff ff       	call   10034c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a81:	0f b7 c0             	movzwl %ax,%eax
  101a84:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a88:	c7 04 24 4b 63 10 00 	movl   $0x10634b,(%esp)
  101a8f:	e8 b8 e8 ff ff       	call   10034c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101a94:	8b 45 08             	mov    0x8(%ebp),%eax
  101a97:	8b 40 40             	mov    0x40(%eax),%eax
  101a9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9e:	c7 04 24 5e 63 10 00 	movl   $0x10635e,(%esp)
  101aa5:	e8 a2 e8 ff ff       	call   10034c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101aaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101ab1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ab8:	eb 3e                	jmp    101af8 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101aba:	8b 45 08             	mov    0x8(%ebp),%eax
  101abd:	8b 50 40             	mov    0x40(%eax),%edx
  101ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ac3:	21 d0                	and    %edx,%eax
  101ac5:	85 c0                	test   %eax,%eax
  101ac7:	74 28                	je     101af1 <print_trapframe+0x157>
  101ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101acc:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101ad3:	85 c0                	test   %eax,%eax
  101ad5:	74 1a                	je     101af1 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ada:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae5:	c7 04 24 6d 63 10 00 	movl   $0x10636d,(%esp)
  101aec:	e8 5b e8 ff ff       	call   10034c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101af1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101af5:	d1 65 f0             	shll   -0x10(%ebp)
  101af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101afb:	83 f8 17             	cmp    $0x17,%eax
  101afe:	76 ba                	jbe    101aba <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b00:	8b 45 08             	mov    0x8(%ebp),%eax
  101b03:	8b 40 40             	mov    0x40(%eax),%eax
  101b06:	25 00 30 00 00       	and    $0x3000,%eax
  101b0b:	c1 e8 0c             	shr    $0xc,%eax
  101b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b12:	c7 04 24 71 63 10 00 	movl   $0x106371,(%esp)
  101b19:	e8 2e e8 ff ff       	call   10034c <cprintf>

    if (!trap_in_kernel(tf)) {
  101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b21:	89 04 24             	mov    %eax,(%esp)
  101b24:	e8 5b fe ff ff       	call   101984 <trap_in_kernel>
  101b29:	85 c0                	test   %eax,%eax
  101b2b:	75 30                	jne    101b5d <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b30:	8b 40 44             	mov    0x44(%eax),%eax
  101b33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b37:	c7 04 24 7a 63 10 00 	movl   $0x10637a,(%esp)
  101b3e:	e8 09 e8 ff ff       	call   10034c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b43:	8b 45 08             	mov    0x8(%ebp),%eax
  101b46:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b4a:	0f b7 c0             	movzwl %ax,%eax
  101b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b51:	c7 04 24 89 63 10 00 	movl   $0x106389,(%esp)
  101b58:	e8 ef e7 ff ff       	call   10034c <cprintf>
    }
}
  101b5d:	c9                   	leave  
  101b5e:	c3                   	ret    

00101b5f <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b5f:	55                   	push   %ebp
  101b60:	89 e5                	mov    %esp,%ebp
  101b62:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b65:	8b 45 08             	mov    0x8(%ebp),%eax
  101b68:	8b 00                	mov    (%eax),%eax
  101b6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6e:	c7 04 24 9c 63 10 00 	movl   $0x10639c,(%esp)
  101b75:	e8 d2 e7 ff ff       	call   10034c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7d:	8b 40 04             	mov    0x4(%eax),%eax
  101b80:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b84:	c7 04 24 ab 63 10 00 	movl   $0x1063ab,(%esp)
  101b8b:	e8 bc e7 ff ff       	call   10034c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101b90:	8b 45 08             	mov    0x8(%ebp),%eax
  101b93:	8b 40 08             	mov    0x8(%eax),%eax
  101b96:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b9a:	c7 04 24 ba 63 10 00 	movl   $0x1063ba,(%esp)
  101ba1:	e8 a6 e7 ff ff       	call   10034c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba9:	8b 40 0c             	mov    0xc(%eax),%eax
  101bac:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb0:	c7 04 24 c9 63 10 00 	movl   $0x1063c9,(%esp)
  101bb7:	e8 90 e7 ff ff       	call   10034c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbf:	8b 40 10             	mov    0x10(%eax),%eax
  101bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc6:	c7 04 24 d8 63 10 00 	movl   $0x1063d8,(%esp)
  101bcd:	e8 7a e7 ff ff       	call   10034c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd5:	8b 40 14             	mov    0x14(%eax),%eax
  101bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdc:	c7 04 24 e7 63 10 00 	movl   $0x1063e7,(%esp)
  101be3:	e8 64 e7 ff ff       	call   10034c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101be8:	8b 45 08             	mov    0x8(%ebp),%eax
  101beb:	8b 40 18             	mov    0x18(%eax),%eax
  101bee:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf2:	c7 04 24 f6 63 10 00 	movl   $0x1063f6,(%esp)
  101bf9:	e8 4e e7 ff ff       	call   10034c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  101c01:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c04:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c08:	c7 04 24 05 64 10 00 	movl   $0x106405,(%esp)
  101c0f:	e8 38 e7 ff ff       	call   10034c <cprintf>
}
  101c14:	c9                   	leave  
  101c15:	c3                   	ret    

00101c16 <trap_dispatch>:

struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c16:	55                   	push   %ebp
  101c17:	89 e5                	mov    %esp,%ebp
  101c19:	57                   	push   %edi
  101c1a:	56                   	push   %esi
  101c1b:	53                   	push   %ebx
  101c1c:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c22:	8b 40 30             	mov    0x30(%eax),%eax
  101c25:	83 f8 2f             	cmp    $0x2f,%eax
  101c28:	77 21                	ja     101c4b <trap_dispatch+0x35>
  101c2a:	83 f8 2e             	cmp    $0x2e,%eax
  101c2d:	0f 83 ec 01 00 00    	jae    101e1f <trap_dispatch+0x209>
  101c33:	83 f8 21             	cmp    $0x21,%eax
  101c36:	0f 84 8a 00 00 00    	je     101cc6 <trap_dispatch+0xb0>
  101c3c:	83 f8 24             	cmp    $0x24,%eax
  101c3f:	74 5c                	je     101c9d <trap_dispatch+0x87>
  101c41:	83 f8 20             	cmp    $0x20,%eax
  101c44:	74 1c                	je     101c62 <trap_dispatch+0x4c>
  101c46:	e9 9c 01 00 00       	jmp    101de7 <trap_dispatch+0x1d1>
  101c4b:	83 f8 78             	cmp    $0x78,%eax
  101c4e:	0f 84 9b 00 00 00    	je     101cef <trap_dispatch+0xd9>
  101c54:	83 f8 79             	cmp    $0x79,%eax
  101c57:	0f 84 11 01 00 00    	je     101d6e <trap_dispatch+0x158>
  101c5d:	e9 85 01 00 00       	jmp    101de7 <trap_dispatch+0x1d1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101c62:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101c67:	83 c0 01             	add    $0x1,%eax
  101c6a:	a3 4c 89 11 00       	mov    %eax,0x11894c
        if (ticks %  TICK_NUM == 0)
  101c6f:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101c75:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101c7a:	89 c8                	mov    %ecx,%eax
  101c7c:	f7 e2                	mul    %edx
  101c7e:	89 d0                	mov    %edx,%eax
  101c80:	c1 e8 05             	shr    $0x5,%eax
  101c83:	6b c0 64             	imul   $0x64,%eax,%eax
  101c86:	29 c1                	sub    %eax,%ecx
  101c88:	89 c8                	mov    %ecx,%eax
  101c8a:	85 c0                	test   %eax,%eax
  101c8c:	75 0a                	jne    101c98 <trap_dispatch+0x82>
        	print_ticks();
  101c8e:	e8 33 fb ff ff       	call   1017c6 <print_ticks>
        break;
  101c93:	e9 88 01 00 00       	jmp    101e20 <trap_dispatch+0x20a>
  101c98:	e9 83 01 00 00       	jmp    101e20 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101c9d:	e8 e8 f8 ff ff       	call   10158a <cons_getc>
  101ca2:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ca5:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101ca9:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101cad:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb5:	c7 04 24 14 64 10 00 	movl   $0x106414,(%esp)
  101cbc:	e8 8b e6 ff ff       	call   10034c <cprintf>
        break;
  101cc1:	e9 5a 01 00 00       	jmp    101e20 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101cc6:	e8 bf f8 ff ff       	call   10158a <cons_getc>
  101ccb:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101cce:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101cd2:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101cd6:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cda:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cde:	c7 04 24 26 64 10 00 	movl   $0x106426,(%esp)
  101ce5:	e8 62 e6 ff ff       	call   10034c <cprintf>
        break;
  101cea:	e9 31 01 00 00       	jmp    101e20 <trap_dispatch+0x20a>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    	if (tf->tf_cs != USER_CS) {
  101cef:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101cf6:	66 83 f8 1b          	cmp    $0x1b,%ax
  101cfa:	74 6d                	je     101d69 <trap_dispatch+0x153>
            switchk2u = *tf;
  101cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  101cff:	ba 60 89 11 00       	mov    $0x118960,%edx
  101d04:	89 c3                	mov    %eax,%ebx
  101d06:	b8 13 00 00 00       	mov    $0x13,%eax
  101d0b:	89 d7                	mov    %edx,%edi
  101d0d:	89 de                	mov    %ebx,%esi
  101d0f:	89 c1                	mov    %eax,%ecx
  101d11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101d13:	66 c7 05 9c 89 11 00 	movw   $0x1b,0x11899c
  101d1a:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101d1c:	66 c7 05 a8 89 11 00 	movw   $0x23,0x1189a8
  101d23:	23 00 
  101d25:	0f b7 05 a8 89 11 00 	movzwl 0x1189a8,%eax
  101d2c:	66 a3 88 89 11 00    	mov    %ax,0x118988
  101d32:	0f b7 05 88 89 11 00 	movzwl 0x118988,%eax
  101d39:	66 a3 8c 89 11 00    	mov    %ax,0x11898c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d42:	83 c0 44             	add    $0x44,%eax
  101d45:	a3 a4 89 11 00       	mov    %eax,0x1189a4

            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101d4a:	a1 a0 89 11 00       	mov    0x1189a0,%eax
  101d4f:	80 cc 30             	or     $0x30,%ah
  101d52:	a3 a0 89 11 00       	mov    %eax,0x1189a0

            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101d57:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5a:	8d 50 fc             	lea    -0x4(%eax),%edx
  101d5d:	b8 60 89 11 00       	mov    $0x118960,%eax
  101d62:	89 02                	mov    %eax,(%edx)
        }
        break;
  101d64:	e9 b7 00 00 00       	jmp    101e20 <trap_dispatch+0x20a>
  101d69:	e9 b2 00 00 00       	jmp    101e20 <trap_dispatch+0x20a>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d71:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d75:	66 83 f8 08          	cmp    $0x8,%ax
  101d79:	74 6a                	je     101de5 <trap_dispatch+0x1cf>
            tf->tf_cs = KERNEL_CS;
  101d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d7e:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101d84:	8b 45 08             	mov    0x8(%ebp),%eax
  101d87:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d90:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101d94:	8b 45 08             	mov    0x8(%ebp),%eax
  101d97:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d9e:	8b 40 40             	mov    0x40(%eax),%eax
  101da1:	80 e4 cf             	and    $0xcf,%ah
  101da4:	89 c2                	mov    %eax,%edx
  101da6:	8b 45 08             	mov    0x8(%ebp),%eax
  101da9:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101dac:	8b 45 08             	mov    0x8(%ebp),%eax
  101daf:	8b 40 44             	mov    0x44(%eax),%eax
  101db2:	83 e8 44             	sub    $0x44,%eax
  101db5:	a3 ac 89 11 00       	mov    %eax,0x1189ac
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101dba:	a1 ac 89 11 00       	mov    0x1189ac,%eax
  101dbf:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101dc6:	00 
  101dc7:	8b 55 08             	mov    0x8(%ebp),%edx
  101dca:	89 54 24 04          	mov    %edx,0x4(%esp)
  101dce:	89 04 24             	mov    %eax,(%esp)
  101dd1:	e8 1f 40 00 00       	call   105df5 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd9:	8d 50 fc             	lea    -0x4(%eax),%edx
  101ddc:	a1 ac 89 11 00       	mov    0x1189ac,%eax
  101de1:	89 02                	mov    %eax,(%edx)
        }
        break;
  101de3:	eb 3b                	jmp    101e20 <trap_dispatch+0x20a>
  101de5:	eb 39                	jmp    101e20 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101de7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dea:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dee:	0f b7 c0             	movzwl %ax,%eax
  101df1:	83 e0 03             	and    $0x3,%eax
  101df4:	85 c0                	test   %eax,%eax
  101df6:	75 28                	jne    101e20 <trap_dispatch+0x20a>
            print_trapframe(tf);
  101df8:	8b 45 08             	mov    0x8(%ebp),%eax
  101dfb:	89 04 24             	mov    %eax,(%esp)
  101dfe:	e8 97 fb ff ff       	call   10199a <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e03:	c7 44 24 08 35 64 10 	movl   $0x106435,0x8(%esp)
  101e0a:	00 
  101e0b:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  101e12:	00 
  101e13:	c7 04 24 51 64 10 00 	movl   $0x106451,(%esp)
  101e1a:	e8 fd ed ff ff       	call   100c1c <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e1f:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e20:	83 c4 2c             	add    $0x2c,%esp
  101e23:	5b                   	pop    %ebx
  101e24:	5e                   	pop    %esi
  101e25:	5f                   	pop    %edi
  101e26:	5d                   	pop    %ebp
  101e27:	c3                   	ret    

00101e28 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e28:	55                   	push   %ebp
  101e29:	89 e5                	mov    %esp,%ebp
  101e2b:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e31:	89 04 24             	mov    %eax,(%esp)
  101e34:	e8 dd fd ff ff       	call   101c16 <trap_dispatch>
}
  101e39:	c9                   	leave  
  101e3a:	c3                   	ret    

00101e3b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e3b:	1e                   	push   %ds
    pushl %es
  101e3c:	06                   	push   %es
    pushl %fs
  101e3d:	0f a0                	push   %fs
    pushl %gs
  101e3f:	0f a8                	push   %gs
    pushal
  101e41:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e42:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e47:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e49:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e4b:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e4c:	e8 d7 ff ff ff       	call   101e28 <trap>

    # pop the pushed stack pointer
    popl %esp
  101e51:	5c                   	pop    %esp

00101e52 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e52:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e53:	0f a9                	pop    %gs
    popl %fs
  101e55:	0f a1                	pop    %fs
    popl %es
  101e57:	07                   	pop    %es
    popl %ds
  101e58:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e59:	83 c4 08             	add    $0x8,%esp
    iret
  101e5c:	cf                   	iret   

00101e5d <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e5d:	6a 00                	push   $0x0
  pushl $0
  101e5f:	6a 00                	push   $0x0
  jmp __alltraps
  101e61:	e9 d5 ff ff ff       	jmp    101e3b <__alltraps>

00101e66 <vector1>:
.globl vector1
vector1:
  pushl $0
  101e66:	6a 00                	push   $0x0
  pushl $1
  101e68:	6a 01                	push   $0x1
  jmp __alltraps
  101e6a:	e9 cc ff ff ff       	jmp    101e3b <__alltraps>

00101e6f <vector2>:
.globl vector2
vector2:
  pushl $0
  101e6f:	6a 00                	push   $0x0
  pushl $2
  101e71:	6a 02                	push   $0x2
  jmp __alltraps
  101e73:	e9 c3 ff ff ff       	jmp    101e3b <__alltraps>

00101e78 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e78:	6a 00                	push   $0x0
  pushl $3
  101e7a:	6a 03                	push   $0x3
  jmp __alltraps
  101e7c:	e9 ba ff ff ff       	jmp    101e3b <__alltraps>

00101e81 <vector4>:
.globl vector4
vector4:
  pushl $0
  101e81:	6a 00                	push   $0x0
  pushl $4
  101e83:	6a 04                	push   $0x4
  jmp __alltraps
  101e85:	e9 b1 ff ff ff       	jmp    101e3b <__alltraps>

00101e8a <vector5>:
.globl vector5
vector5:
  pushl $0
  101e8a:	6a 00                	push   $0x0
  pushl $5
  101e8c:	6a 05                	push   $0x5
  jmp __alltraps
  101e8e:	e9 a8 ff ff ff       	jmp    101e3b <__alltraps>

00101e93 <vector6>:
.globl vector6
vector6:
  pushl $0
  101e93:	6a 00                	push   $0x0
  pushl $6
  101e95:	6a 06                	push   $0x6
  jmp __alltraps
  101e97:	e9 9f ff ff ff       	jmp    101e3b <__alltraps>

00101e9c <vector7>:
.globl vector7
vector7:
  pushl $0
  101e9c:	6a 00                	push   $0x0
  pushl $7
  101e9e:	6a 07                	push   $0x7
  jmp __alltraps
  101ea0:	e9 96 ff ff ff       	jmp    101e3b <__alltraps>

00101ea5 <vector8>:
.globl vector8
vector8:
  pushl $8
  101ea5:	6a 08                	push   $0x8
  jmp __alltraps
  101ea7:	e9 8f ff ff ff       	jmp    101e3b <__alltraps>

00101eac <vector9>:
.globl vector9
vector9:
  pushl $9
  101eac:	6a 09                	push   $0x9
  jmp __alltraps
  101eae:	e9 88 ff ff ff       	jmp    101e3b <__alltraps>

00101eb3 <vector10>:
.globl vector10
vector10:
  pushl $10
  101eb3:	6a 0a                	push   $0xa
  jmp __alltraps
  101eb5:	e9 81 ff ff ff       	jmp    101e3b <__alltraps>

00101eba <vector11>:
.globl vector11
vector11:
  pushl $11
  101eba:	6a 0b                	push   $0xb
  jmp __alltraps
  101ebc:	e9 7a ff ff ff       	jmp    101e3b <__alltraps>

00101ec1 <vector12>:
.globl vector12
vector12:
  pushl $12
  101ec1:	6a 0c                	push   $0xc
  jmp __alltraps
  101ec3:	e9 73 ff ff ff       	jmp    101e3b <__alltraps>

00101ec8 <vector13>:
.globl vector13
vector13:
  pushl $13
  101ec8:	6a 0d                	push   $0xd
  jmp __alltraps
  101eca:	e9 6c ff ff ff       	jmp    101e3b <__alltraps>

00101ecf <vector14>:
.globl vector14
vector14:
  pushl $14
  101ecf:	6a 0e                	push   $0xe
  jmp __alltraps
  101ed1:	e9 65 ff ff ff       	jmp    101e3b <__alltraps>

00101ed6 <vector15>:
.globl vector15
vector15:
  pushl $0
  101ed6:	6a 00                	push   $0x0
  pushl $15
  101ed8:	6a 0f                	push   $0xf
  jmp __alltraps
  101eda:	e9 5c ff ff ff       	jmp    101e3b <__alltraps>

00101edf <vector16>:
.globl vector16
vector16:
  pushl $0
  101edf:	6a 00                	push   $0x0
  pushl $16
  101ee1:	6a 10                	push   $0x10
  jmp __alltraps
  101ee3:	e9 53 ff ff ff       	jmp    101e3b <__alltraps>

00101ee8 <vector17>:
.globl vector17
vector17:
  pushl $17
  101ee8:	6a 11                	push   $0x11
  jmp __alltraps
  101eea:	e9 4c ff ff ff       	jmp    101e3b <__alltraps>

00101eef <vector18>:
.globl vector18
vector18:
  pushl $0
  101eef:	6a 00                	push   $0x0
  pushl $18
  101ef1:	6a 12                	push   $0x12
  jmp __alltraps
  101ef3:	e9 43 ff ff ff       	jmp    101e3b <__alltraps>

00101ef8 <vector19>:
.globl vector19
vector19:
  pushl $0
  101ef8:	6a 00                	push   $0x0
  pushl $19
  101efa:	6a 13                	push   $0x13
  jmp __alltraps
  101efc:	e9 3a ff ff ff       	jmp    101e3b <__alltraps>

00101f01 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f01:	6a 00                	push   $0x0
  pushl $20
  101f03:	6a 14                	push   $0x14
  jmp __alltraps
  101f05:	e9 31 ff ff ff       	jmp    101e3b <__alltraps>

00101f0a <vector21>:
.globl vector21
vector21:
  pushl $0
  101f0a:	6a 00                	push   $0x0
  pushl $21
  101f0c:	6a 15                	push   $0x15
  jmp __alltraps
  101f0e:	e9 28 ff ff ff       	jmp    101e3b <__alltraps>

00101f13 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f13:	6a 00                	push   $0x0
  pushl $22
  101f15:	6a 16                	push   $0x16
  jmp __alltraps
  101f17:	e9 1f ff ff ff       	jmp    101e3b <__alltraps>

00101f1c <vector23>:
.globl vector23
vector23:
  pushl $0
  101f1c:	6a 00                	push   $0x0
  pushl $23
  101f1e:	6a 17                	push   $0x17
  jmp __alltraps
  101f20:	e9 16 ff ff ff       	jmp    101e3b <__alltraps>

00101f25 <vector24>:
.globl vector24
vector24:
  pushl $0
  101f25:	6a 00                	push   $0x0
  pushl $24
  101f27:	6a 18                	push   $0x18
  jmp __alltraps
  101f29:	e9 0d ff ff ff       	jmp    101e3b <__alltraps>

00101f2e <vector25>:
.globl vector25
vector25:
  pushl $0
  101f2e:	6a 00                	push   $0x0
  pushl $25
  101f30:	6a 19                	push   $0x19
  jmp __alltraps
  101f32:	e9 04 ff ff ff       	jmp    101e3b <__alltraps>

00101f37 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f37:	6a 00                	push   $0x0
  pushl $26
  101f39:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f3b:	e9 fb fe ff ff       	jmp    101e3b <__alltraps>

00101f40 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f40:	6a 00                	push   $0x0
  pushl $27
  101f42:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f44:	e9 f2 fe ff ff       	jmp    101e3b <__alltraps>

00101f49 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f49:	6a 00                	push   $0x0
  pushl $28
  101f4b:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f4d:	e9 e9 fe ff ff       	jmp    101e3b <__alltraps>

00101f52 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f52:	6a 00                	push   $0x0
  pushl $29
  101f54:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f56:	e9 e0 fe ff ff       	jmp    101e3b <__alltraps>

00101f5b <vector30>:
.globl vector30
vector30:
  pushl $0
  101f5b:	6a 00                	push   $0x0
  pushl $30
  101f5d:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f5f:	e9 d7 fe ff ff       	jmp    101e3b <__alltraps>

00101f64 <vector31>:
.globl vector31
vector31:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $31
  101f66:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f68:	e9 ce fe ff ff       	jmp    101e3b <__alltraps>

00101f6d <vector32>:
.globl vector32
vector32:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $32
  101f6f:	6a 20                	push   $0x20
  jmp __alltraps
  101f71:	e9 c5 fe ff ff       	jmp    101e3b <__alltraps>

00101f76 <vector33>:
.globl vector33
vector33:
  pushl $0
  101f76:	6a 00                	push   $0x0
  pushl $33
  101f78:	6a 21                	push   $0x21
  jmp __alltraps
  101f7a:	e9 bc fe ff ff       	jmp    101e3b <__alltraps>

00101f7f <vector34>:
.globl vector34
vector34:
  pushl $0
  101f7f:	6a 00                	push   $0x0
  pushl $34
  101f81:	6a 22                	push   $0x22
  jmp __alltraps
  101f83:	e9 b3 fe ff ff       	jmp    101e3b <__alltraps>

00101f88 <vector35>:
.globl vector35
vector35:
  pushl $0
  101f88:	6a 00                	push   $0x0
  pushl $35
  101f8a:	6a 23                	push   $0x23
  jmp __alltraps
  101f8c:	e9 aa fe ff ff       	jmp    101e3b <__alltraps>

00101f91 <vector36>:
.globl vector36
vector36:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $36
  101f93:	6a 24                	push   $0x24
  jmp __alltraps
  101f95:	e9 a1 fe ff ff       	jmp    101e3b <__alltraps>

00101f9a <vector37>:
.globl vector37
vector37:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $37
  101f9c:	6a 25                	push   $0x25
  jmp __alltraps
  101f9e:	e9 98 fe ff ff       	jmp    101e3b <__alltraps>

00101fa3 <vector38>:
.globl vector38
vector38:
  pushl $0
  101fa3:	6a 00                	push   $0x0
  pushl $38
  101fa5:	6a 26                	push   $0x26
  jmp __alltraps
  101fa7:	e9 8f fe ff ff       	jmp    101e3b <__alltraps>

00101fac <vector39>:
.globl vector39
vector39:
  pushl $0
  101fac:	6a 00                	push   $0x0
  pushl $39
  101fae:	6a 27                	push   $0x27
  jmp __alltraps
  101fb0:	e9 86 fe ff ff       	jmp    101e3b <__alltraps>

00101fb5 <vector40>:
.globl vector40
vector40:
  pushl $0
  101fb5:	6a 00                	push   $0x0
  pushl $40
  101fb7:	6a 28                	push   $0x28
  jmp __alltraps
  101fb9:	e9 7d fe ff ff       	jmp    101e3b <__alltraps>

00101fbe <vector41>:
.globl vector41
vector41:
  pushl $0
  101fbe:	6a 00                	push   $0x0
  pushl $41
  101fc0:	6a 29                	push   $0x29
  jmp __alltraps
  101fc2:	e9 74 fe ff ff       	jmp    101e3b <__alltraps>

00101fc7 <vector42>:
.globl vector42
vector42:
  pushl $0
  101fc7:	6a 00                	push   $0x0
  pushl $42
  101fc9:	6a 2a                	push   $0x2a
  jmp __alltraps
  101fcb:	e9 6b fe ff ff       	jmp    101e3b <__alltraps>

00101fd0 <vector43>:
.globl vector43
vector43:
  pushl $0
  101fd0:	6a 00                	push   $0x0
  pushl $43
  101fd2:	6a 2b                	push   $0x2b
  jmp __alltraps
  101fd4:	e9 62 fe ff ff       	jmp    101e3b <__alltraps>

00101fd9 <vector44>:
.globl vector44
vector44:
  pushl $0
  101fd9:	6a 00                	push   $0x0
  pushl $44
  101fdb:	6a 2c                	push   $0x2c
  jmp __alltraps
  101fdd:	e9 59 fe ff ff       	jmp    101e3b <__alltraps>

00101fe2 <vector45>:
.globl vector45
vector45:
  pushl $0
  101fe2:	6a 00                	push   $0x0
  pushl $45
  101fe4:	6a 2d                	push   $0x2d
  jmp __alltraps
  101fe6:	e9 50 fe ff ff       	jmp    101e3b <__alltraps>

00101feb <vector46>:
.globl vector46
vector46:
  pushl $0
  101feb:	6a 00                	push   $0x0
  pushl $46
  101fed:	6a 2e                	push   $0x2e
  jmp __alltraps
  101fef:	e9 47 fe ff ff       	jmp    101e3b <__alltraps>

00101ff4 <vector47>:
.globl vector47
vector47:
  pushl $0
  101ff4:	6a 00                	push   $0x0
  pushl $47
  101ff6:	6a 2f                	push   $0x2f
  jmp __alltraps
  101ff8:	e9 3e fe ff ff       	jmp    101e3b <__alltraps>

00101ffd <vector48>:
.globl vector48
vector48:
  pushl $0
  101ffd:	6a 00                	push   $0x0
  pushl $48
  101fff:	6a 30                	push   $0x30
  jmp __alltraps
  102001:	e9 35 fe ff ff       	jmp    101e3b <__alltraps>

00102006 <vector49>:
.globl vector49
vector49:
  pushl $0
  102006:	6a 00                	push   $0x0
  pushl $49
  102008:	6a 31                	push   $0x31
  jmp __alltraps
  10200a:	e9 2c fe ff ff       	jmp    101e3b <__alltraps>

0010200f <vector50>:
.globl vector50
vector50:
  pushl $0
  10200f:	6a 00                	push   $0x0
  pushl $50
  102011:	6a 32                	push   $0x32
  jmp __alltraps
  102013:	e9 23 fe ff ff       	jmp    101e3b <__alltraps>

00102018 <vector51>:
.globl vector51
vector51:
  pushl $0
  102018:	6a 00                	push   $0x0
  pushl $51
  10201a:	6a 33                	push   $0x33
  jmp __alltraps
  10201c:	e9 1a fe ff ff       	jmp    101e3b <__alltraps>

00102021 <vector52>:
.globl vector52
vector52:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $52
  102023:	6a 34                	push   $0x34
  jmp __alltraps
  102025:	e9 11 fe ff ff       	jmp    101e3b <__alltraps>

0010202a <vector53>:
.globl vector53
vector53:
  pushl $0
  10202a:	6a 00                	push   $0x0
  pushl $53
  10202c:	6a 35                	push   $0x35
  jmp __alltraps
  10202e:	e9 08 fe ff ff       	jmp    101e3b <__alltraps>

00102033 <vector54>:
.globl vector54
vector54:
  pushl $0
  102033:	6a 00                	push   $0x0
  pushl $54
  102035:	6a 36                	push   $0x36
  jmp __alltraps
  102037:	e9 ff fd ff ff       	jmp    101e3b <__alltraps>

0010203c <vector55>:
.globl vector55
vector55:
  pushl $0
  10203c:	6a 00                	push   $0x0
  pushl $55
  10203e:	6a 37                	push   $0x37
  jmp __alltraps
  102040:	e9 f6 fd ff ff       	jmp    101e3b <__alltraps>

00102045 <vector56>:
.globl vector56
vector56:
  pushl $0
  102045:	6a 00                	push   $0x0
  pushl $56
  102047:	6a 38                	push   $0x38
  jmp __alltraps
  102049:	e9 ed fd ff ff       	jmp    101e3b <__alltraps>

0010204e <vector57>:
.globl vector57
vector57:
  pushl $0
  10204e:	6a 00                	push   $0x0
  pushl $57
  102050:	6a 39                	push   $0x39
  jmp __alltraps
  102052:	e9 e4 fd ff ff       	jmp    101e3b <__alltraps>

00102057 <vector58>:
.globl vector58
vector58:
  pushl $0
  102057:	6a 00                	push   $0x0
  pushl $58
  102059:	6a 3a                	push   $0x3a
  jmp __alltraps
  10205b:	e9 db fd ff ff       	jmp    101e3b <__alltraps>

00102060 <vector59>:
.globl vector59
vector59:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $59
  102062:	6a 3b                	push   $0x3b
  jmp __alltraps
  102064:	e9 d2 fd ff ff       	jmp    101e3b <__alltraps>

00102069 <vector60>:
.globl vector60
vector60:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $60
  10206b:	6a 3c                	push   $0x3c
  jmp __alltraps
  10206d:	e9 c9 fd ff ff       	jmp    101e3b <__alltraps>

00102072 <vector61>:
.globl vector61
vector61:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $61
  102074:	6a 3d                	push   $0x3d
  jmp __alltraps
  102076:	e9 c0 fd ff ff       	jmp    101e3b <__alltraps>

0010207b <vector62>:
.globl vector62
vector62:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $62
  10207d:	6a 3e                	push   $0x3e
  jmp __alltraps
  10207f:	e9 b7 fd ff ff       	jmp    101e3b <__alltraps>

00102084 <vector63>:
.globl vector63
vector63:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $63
  102086:	6a 3f                	push   $0x3f
  jmp __alltraps
  102088:	e9 ae fd ff ff       	jmp    101e3b <__alltraps>

0010208d <vector64>:
.globl vector64
vector64:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $64
  10208f:	6a 40                	push   $0x40
  jmp __alltraps
  102091:	e9 a5 fd ff ff       	jmp    101e3b <__alltraps>

00102096 <vector65>:
.globl vector65
vector65:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $65
  102098:	6a 41                	push   $0x41
  jmp __alltraps
  10209a:	e9 9c fd ff ff       	jmp    101e3b <__alltraps>

0010209f <vector66>:
.globl vector66
vector66:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $66
  1020a1:	6a 42                	push   $0x42
  jmp __alltraps
  1020a3:	e9 93 fd ff ff       	jmp    101e3b <__alltraps>

001020a8 <vector67>:
.globl vector67
vector67:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $67
  1020aa:	6a 43                	push   $0x43
  jmp __alltraps
  1020ac:	e9 8a fd ff ff       	jmp    101e3b <__alltraps>

001020b1 <vector68>:
.globl vector68
vector68:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $68
  1020b3:	6a 44                	push   $0x44
  jmp __alltraps
  1020b5:	e9 81 fd ff ff       	jmp    101e3b <__alltraps>

001020ba <vector69>:
.globl vector69
vector69:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $69
  1020bc:	6a 45                	push   $0x45
  jmp __alltraps
  1020be:	e9 78 fd ff ff       	jmp    101e3b <__alltraps>

001020c3 <vector70>:
.globl vector70
vector70:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $70
  1020c5:	6a 46                	push   $0x46
  jmp __alltraps
  1020c7:	e9 6f fd ff ff       	jmp    101e3b <__alltraps>

001020cc <vector71>:
.globl vector71
vector71:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $71
  1020ce:	6a 47                	push   $0x47
  jmp __alltraps
  1020d0:	e9 66 fd ff ff       	jmp    101e3b <__alltraps>

001020d5 <vector72>:
.globl vector72
vector72:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $72
  1020d7:	6a 48                	push   $0x48
  jmp __alltraps
  1020d9:	e9 5d fd ff ff       	jmp    101e3b <__alltraps>

001020de <vector73>:
.globl vector73
vector73:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $73
  1020e0:	6a 49                	push   $0x49
  jmp __alltraps
  1020e2:	e9 54 fd ff ff       	jmp    101e3b <__alltraps>

001020e7 <vector74>:
.globl vector74
vector74:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $74
  1020e9:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020eb:	e9 4b fd ff ff       	jmp    101e3b <__alltraps>

001020f0 <vector75>:
.globl vector75
vector75:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $75
  1020f2:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020f4:	e9 42 fd ff ff       	jmp    101e3b <__alltraps>

001020f9 <vector76>:
.globl vector76
vector76:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $76
  1020fb:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020fd:	e9 39 fd ff ff       	jmp    101e3b <__alltraps>

00102102 <vector77>:
.globl vector77
vector77:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $77
  102104:	6a 4d                	push   $0x4d
  jmp __alltraps
  102106:	e9 30 fd ff ff       	jmp    101e3b <__alltraps>

0010210b <vector78>:
.globl vector78
vector78:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $78
  10210d:	6a 4e                	push   $0x4e
  jmp __alltraps
  10210f:	e9 27 fd ff ff       	jmp    101e3b <__alltraps>

00102114 <vector79>:
.globl vector79
vector79:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $79
  102116:	6a 4f                	push   $0x4f
  jmp __alltraps
  102118:	e9 1e fd ff ff       	jmp    101e3b <__alltraps>

0010211d <vector80>:
.globl vector80
vector80:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $80
  10211f:	6a 50                	push   $0x50
  jmp __alltraps
  102121:	e9 15 fd ff ff       	jmp    101e3b <__alltraps>

00102126 <vector81>:
.globl vector81
vector81:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $81
  102128:	6a 51                	push   $0x51
  jmp __alltraps
  10212a:	e9 0c fd ff ff       	jmp    101e3b <__alltraps>

0010212f <vector82>:
.globl vector82
vector82:
  pushl $0
  10212f:	6a 00                	push   $0x0
  pushl $82
  102131:	6a 52                	push   $0x52
  jmp __alltraps
  102133:	e9 03 fd ff ff       	jmp    101e3b <__alltraps>

00102138 <vector83>:
.globl vector83
vector83:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $83
  10213a:	6a 53                	push   $0x53
  jmp __alltraps
  10213c:	e9 fa fc ff ff       	jmp    101e3b <__alltraps>

00102141 <vector84>:
.globl vector84
vector84:
  pushl $0
  102141:	6a 00                	push   $0x0
  pushl $84
  102143:	6a 54                	push   $0x54
  jmp __alltraps
  102145:	e9 f1 fc ff ff       	jmp    101e3b <__alltraps>

0010214a <vector85>:
.globl vector85
vector85:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $85
  10214c:	6a 55                	push   $0x55
  jmp __alltraps
  10214e:	e9 e8 fc ff ff       	jmp    101e3b <__alltraps>

00102153 <vector86>:
.globl vector86
vector86:
  pushl $0
  102153:	6a 00                	push   $0x0
  pushl $86
  102155:	6a 56                	push   $0x56
  jmp __alltraps
  102157:	e9 df fc ff ff       	jmp    101e3b <__alltraps>

0010215c <vector87>:
.globl vector87
vector87:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $87
  10215e:	6a 57                	push   $0x57
  jmp __alltraps
  102160:	e9 d6 fc ff ff       	jmp    101e3b <__alltraps>

00102165 <vector88>:
.globl vector88
vector88:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $88
  102167:	6a 58                	push   $0x58
  jmp __alltraps
  102169:	e9 cd fc ff ff       	jmp    101e3b <__alltraps>

0010216e <vector89>:
.globl vector89
vector89:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $89
  102170:	6a 59                	push   $0x59
  jmp __alltraps
  102172:	e9 c4 fc ff ff       	jmp    101e3b <__alltraps>

00102177 <vector90>:
.globl vector90
vector90:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $90
  102179:	6a 5a                	push   $0x5a
  jmp __alltraps
  10217b:	e9 bb fc ff ff       	jmp    101e3b <__alltraps>

00102180 <vector91>:
.globl vector91
vector91:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $91
  102182:	6a 5b                	push   $0x5b
  jmp __alltraps
  102184:	e9 b2 fc ff ff       	jmp    101e3b <__alltraps>

00102189 <vector92>:
.globl vector92
vector92:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $92
  10218b:	6a 5c                	push   $0x5c
  jmp __alltraps
  10218d:	e9 a9 fc ff ff       	jmp    101e3b <__alltraps>

00102192 <vector93>:
.globl vector93
vector93:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $93
  102194:	6a 5d                	push   $0x5d
  jmp __alltraps
  102196:	e9 a0 fc ff ff       	jmp    101e3b <__alltraps>

0010219b <vector94>:
.globl vector94
vector94:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $94
  10219d:	6a 5e                	push   $0x5e
  jmp __alltraps
  10219f:	e9 97 fc ff ff       	jmp    101e3b <__alltraps>

001021a4 <vector95>:
.globl vector95
vector95:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $95
  1021a6:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021a8:	e9 8e fc ff ff       	jmp    101e3b <__alltraps>

001021ad <vector96>:
.globl vector96
vector96:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $96
  1021af:	6a 60                	push   $0x60
  jmp __alltraps
  1021b1:	e9 85 fc ff ff       	jmp    101e3b <__alltraps>

001021b6 <vector97>:
.globl vector97
vector97:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $97
  1021b8:	6a 61                	push   $0x61
  jmp __alltraps
  1021ba:	e9 7c fc ff ff       	jmp    101e3b <__alltraps>

001021bf <vector98>:
.globl vector98
vector98:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $98
  1021c1:	6a 62                	push   $0x62
  jmp __alltraps
  1021c3:	e9 73 fc ff ff       	jmp    101e3b <__alltraps>

001021c8 <vector99>:
.globl vector99
vector99:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $99
  1021ca:	6a 63                	push   $0x63
  jmp __alltraps
  1021cc:	e9 6a fc ff ff       	jmp    101e3b <__alltraps>

001021d1 <vector100>:
.globl vector100
vector100:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $100
  1021d3:	6a 64                	push   $0x64
  jmp __alltraps
  1021d5:	e9 61 fc ff ff       	jmp    101e3b <__alltraps>

001021da <vector101>:
.globl vector101
vector101:
  pushl $0
  1021da:	6a 00                	push   $0x0
  pushl $101
  1021dc:	6a 65                	push   $0x65
  jmp __alltraps
  1021de:	e9 58 fc ff ff       	jmp    101e3b <__alltraps>

001021e3 <vector102>:
.globl vector102
vector102:
  pushl $0
  1021e3:	6a 00                	push   $0x0
  pushl $102
  1021e5:	6a 66                	push   $0x66
  jmp __alltraps
  1021e7:	e9 4f fc ff ff       	jmp    101e3b <__alltraps>

001021ec <vector103>:
.globl vector103
vector103:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $103
  1021ee:	6a 67                	push   $0x67
  jmp __alltraps
  1021f0:	e9 46 fc ff ff       	jmp    101e3b <__alltraps>

001021f5 <vector104>:
.globl vector104
vector104:
  pushl $0
  1021f5:	6a 00                	push   $0x0
  pushl $104
  1021f7:	6a 68                	push   $0x68
  jmp __alltraps
  1021f9:	e9 3d fc ff ff       	jmp    101e3b <__alltraps>

001021fe <vector105>:
.globl vector105
vector105:
  pushl $0
  1021fe:	6a 00                	push   $0x0
  pushl $105
  102200:	6a 69                	push   $0x69
  jmp __alltraps
  102202:	e9 34 fc ff ff       	jmp    101e3b <__alltraps>

00102207 <vector106>:
.globl vector106
vector106:
  pushl $0
  102207:	6a 00                	push   $0x0
  pushl $106
  102209:	6a 6a                	push   $0x6a
  jmp __alltraps
  10220b:	e9 2b fc ff ff       	jmp    101e3b <__alltraps>

00102210 <vector107>:
.globl vector107
vector107:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $107
  102212:	6a 6b                	push   $0x6b
  jmp __alltraps
  102214:	e9 22 fc ff ff       	jmp    101e3b <__alltraps>

00102219 <vector108>:
.globl vector108
vector108:
  pushl $0
  102219:	6a 00                	push   $0x0
  pushl $108
  10221b:	6a 6c                	push   $0x6c
  jmp __alltraps
  10221d:	e9 19 fc ff ff       	jmp    101e3b <__alltraps>

00102222 <vector109>:
.globl vector109
vector109:
  pushl $0
  102222:	6a 00                	push   $0x0
  pushl $109
  102224:	6a 6d                	push   $0x6d
  jmp __alltraps
  102226:	e9 10 fc ff ff       	jmp    101e3b <__alltraps>

0010222b <vector110>:
.globl vector110
vector110:
  pushl $0
  10222b:	6a 00                	push   $0x0
  pushl $110
  10222d:	6a 6e                	push   $0x6e
  jmp __alltraps
  10222f:	e9 07 fc ff ff       	jmp    101e3b <__alltraps>

00102234 <vector111>:
.globl vector111
vector111:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $111
  102236:	6a 6f                	push   $0x6f
  jmp __alltraps
  102238:	e9 fe fb ff ff       	jmp    101e3b <__alltraps>

0010223d <vector112>:
.globl vector112
vector112:
  pushl $0
  10223d:	6a 00                	push   $0x0
  pushl $112
  10223f:	6a 70                	push   $0x70
  jmp __alltraps
  102241:	e9 f5 fb ff ff       	jmp    101e3b <__alltraps>

00102246 <vector113>:
.globl vector113
vector113:
  pushl $0
  102246:	6a 00                	push   $0x0
  pushl $113
  102248:	6a 71                	push   $0x71
  jmp __alltraps
  10224a:	e9 ec fb ff ff       	jmp    101e3b <__alltraps>

0010224f <vector114>:
.globl vector114
vector114:
  pushl $0
  10224f:	6a 00                	push   $0x0
  pushl $114
  102251:	6a 72                	push   $0x72
  jmp __alltraps
  102253:	e9 e3 fb ff ff       	jmp    101e3b <__alltraps>

00102258 <vector115>:
.globl vector115
vector115:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $115
  10225a:	6a 73                	push   $0x73
  jmp __alltraps
  10225c:	e9 da fb ff ff       	jmp    101e3b <__alltraps>

00102261 <vector116>:
.globl vector116
vector116:
  pushl $0
  102261:	6a 00                	push   $0x0
  pushl $116
  102263:	6a 74                	push   $0x74
  jmp __alltraps
  102265:	e9 d1 fb ff ff       	jmp    101e3b <__alltraps>

0010226a <vector117>:
.globl vector117
vector117:
  pushl $0
  10226a:	6a 00                	push   $0x0
  pushl $117
  10226c:	6a 75                	push   $0x75
  jmp __alltraps
  10226e:	e9 c8 fb ff ff       	jmp    101e3b <__alltraps>

00102273 <vector118>:
.globl vector118
vector118:
  pushl $0
  102273:	6a 00                	push   $0x0
  pushl $118
  102275:	6a 76                	push   $0x76
  jmp __alltraps
  102277:	e9 bf fb ff ff       	jmp    101e3b <__alltraps>

0010227c <vector119>:
.globl vector119
vector119:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $119
  10227e:	6a 77                	push   $0x77
  jmp __alltraps
  102280:	e9 b6 fb ff ff       	jmp    101e3b <__alltraps>

00102285 <vector120>:
.globl vector120
vector120:
  pushl $0
  102285:	6a 00                	push   $0x0
  pushl $120
  102287:	6a 78                	push   $0x78
  jmp __alltraps
  102289:	e9 ad fb ff ff       	jmp    101e3b <__alltraps>

0010228e <vector121>:
.globl vector121
vector121:
  pushl $0
  10228e:	6a 00                	push   $0x0
  pushl $121
  102290:	6a 79                	push   $0x79
  jmp __alltraps
  102292:	e9 a4 fb ff ff       	jmp    101e3b <__alltraps>

00102297 <vector122>:
.globl vector122
vector122:
  pushl $0
  102297:	6a 00                	push   $0x0
  pushl $122
  102299:	6a 7a                	push   $0x7a
  jmp __alltraps
  10229b:	e9 9b fb ff ff       	jmp    101e3b <__alltraps>

001022a0 <vector123>:
.globl vector123
vector123:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $123
  1022a2:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022a4:	e9 92 fb ff ff       	jmp    101e3b <__alltraps>

001022a9 <vector124>:
.globl vector124
vector124:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $124
  1022ab:	6a 7c                	push   $0x7c
  jmp __alltraps
  1022ad:	e9 89 fb ff ff       	jmp    101e3b <__alltraps>

001022b2 <vector125>:
.globl vector125
vector125:
  pushl $0
  1022b2:	6a 00                	push   $0x0
  pushl $125
  1022b4:	6a 7d                	push   $0x7d
  jmp __alltraps
  1022b6:	e9 80 fb ff ff       	jmp    101e3b <__alltraps>

001022bb <vector126>:
.globl vector126
vector126:
  pushl $0
  1022bb:	6a 00                	push   $0x0
  pushl $126
  1022bd:	6a 7e                	push   $0x7e
  jmp __alltraps
  1022bf:	e9 77 fb ff ff       	jmp    101e3b <__alltraps>

001022c4 <vector127>:
.globl vector127
vector127:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $127
  1022c6:	6a 7f                	push   $0x7f
  jmp __alltraps
  1022c8:	e9 6e fb ff ff       	jmp    101e3b <__alltraps>

001022cd <vector128>:
.globl vector128
vector128:
  pushl $0
  1022cd:	6a 00                	push   $0x0
  pushl $128
  1022cf:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022d4:	e9 62 fb ff ff       	jmp    101e3b <__alltraps>

001022d9 <vector129>:
.globl vector129
vector129:
  pushl $0
  1022d9:	6a 00                	push   $0x0
  pushl $129
  1022db:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022e0:	e9 56 fb ff ff       	jmp    101e3b <__alltraps>

001022e5 <vector130>:
.globl vector130
vector130:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $130
  1022e7:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022ec:	e9 4a fb ff ff       	jmp    101e3b <__alltraps>

001022f1 <vector131>:
.globl vector131
vector131:
  pushl $0
  1022f1:	6a 00                	push   $0x0
  pushl $131
  1022f3:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022f8:	e9 3e fb ff ff       	jmp    101e3b <__alltraps>

001022fd <vector132>:
.globl vector132
vector132:
  pushl $0
  1022fd:	6a 00                	push   $0x0
  pushl $132
  1022ff:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102304:	e9 32 fb ff ff       	jmp    101e3b <__alltraps>

00102309 <vector133>:
.globl vector133
vector133:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $133
  10230b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102310:	e9 26 fb ff ff       	jmp    101e3b <__alltraps>

00102315 <vector134>:
.globl vector134
vector134:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $134
  102317:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10231c:	e9 1a fb ff ff       	jmp    101e3b <__alltraps>

00102321 <vector135>:
.globl vector135
vector135:
  pushl $0
  102321:	6a 00                	push   $0x0
  pushl $135
  102323:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102328:	e9 0e fb ff ff       	jmp    101e3b <__alltraps>

0010232d <vector136>:
.globl vector136
vector136:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $136
  10232f:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102334:	e9 02 fb ff ff       	jmp    101e3b <__alltraps>

00102339 <vector137>:
.globl vector137
vector137:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $137
  10233b:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102340:	e9 f6 fa ff ff       	jmp    101e3b <__alltraps>

00102345 <vector138>:
.globl vector138
vector138:
  pushl $0
  102345:	6a 00                	push   $0x0
  pushl $138
  102347:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10234c:	e9 ea fa ff ff       	jmp    101e3b <__alltraps>

00102351 <vector139>:
.globl vector139
vector139:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $139
  102353:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102358:	e9 de fa ff ff       	jmp    101e3b <__alltraps>

0010235d <vector140>:
.globl vector140
vector140:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $140
  10235f:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102364:	e9 d2 fa ff ff       	jmp    101e3b <__alltraps>

00102369 <vector141>:
.globl vector141
vector141:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $141
  10236b:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102370:	e9 c6 fa ff ff       	jmp    101e3b <__alltraps>

00102375 <vector142>:
.globl vector142
vector142:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $142
  102377:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10237c:	e9 ba fa ff ff       	jmp    101e3b <__alltraps>

00102381 <vector143>:
.globl vector143
vector143:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $143
  102383:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102388:	e9 ae fa ff ff       	jmp    101e3b <__alltraps>

0010238d <vector144>:
.globl vector144
vector144:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $144
  10238f:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102394:	e9 a2 fa ff ff       	jmp    101e3b <__alltraps>

00102399 <vector145>:
.globl vector145
vector145:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $145
  10239b:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1023a0:	e9 96 fa ff ff       	jmp    101e3b <__alltraps>

001023a5 <vector146>:
.globl vector146
vector146:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $146
  1023a7:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1023ac:	e9 8a fa ff ff       	jmp    101e3b <__alltraps>

001023b1 <vector147>:
.globl vector147
vector147:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $147
  1023b3:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1023b8:	e9 7e fa ff ff       	jmp    101e3b <__alltraps>

001023bd <vector148>:
.globl vector148
vector148:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $148
  1023bf:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1023c4:	e9 72 fa ff ff       	jmp    101e3b <__alltraps>

001023c9 <vector149>:
.globl vector149
vector149:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $149
  1023cb:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023d0:	e9 66 fa ff ff       	jmp    101e3b <__alltraps>

001023d5 <vector150>:
.globl vector150
vector150:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $150
  1023d7:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023dc:	e9 5a fa ff ff       	jmp    101e3b <__alltraps>

001023e1 <vector151>:
.globl vector151
vector151:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $151
  1023e3:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023e8:	e9 4e fa ff ff       	jmp    101e3b <__alltraps>

001023ed <vector152>:
.globl vector152
vector152:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $152
  1023ef:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023f4:	e9 42 fa ff ff       	jmp    101e3b <__alltraps>

001023f9 <vector153>:
.globl vector153
vector153:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $153
  1023fb:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102400:	e9 36 fa ff ff       	jmp    101e3b <__alltraps>

00102405 <vector154>:
.globl vector154
vector154:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $154
  102407:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10240c:	e9 2a fa ff ff       	jmp    101e3b <__alltraps>

00102411 <vector155>:
.globl vector155
vector155:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $155
  102413:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102418:	e9 1e fa ff ff       	jmp    101e3b <__alltraps>

0010241d <vector156>:
.globl vector156
vector156:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $156
  10241f:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102424:	e9 12 fa ff ff       	jmp    101e3b <__alltraps>

00102429 <vector157>:
.globl vector157
vector157:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $157
  10242b:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102430:	e9 06 fa ff ff       	jmp    101e3b <__alltraps>

00102435 <vector158>:
.globl vector158
vector158:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $158
  102437:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10243c:	e9 fa f9 ff ff       	jmp    101e3b <__alltraps>

00102441 <vector159>:
.globl vector159
vector159:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $159
  102443:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102448:	e9 ee f9 ff ff       	jmp    101e3b <__alltraps>

0010244d <vector160>:
.globl vector160
vector160:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $160
  10244f:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102454:	e9 e2 f9 ff ff       	jmp    101e3b <__alltraps>

00102459 <vector161>:
.globl vector161
vector161:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $161
  10245b:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102460:	e9 d6 f9 ff ff       	jmp    101e3b <__alltraps>

00102465 <vector162>:
.globl vector162
vector162:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $162
  102467:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10246c:	e9 ca f9 ff ff       	jmp    101e3b <__alltraps>

00102471 <vector163>:
.globl vector163
vector163:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $163
  102473:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102478:	e9 be f9 ff ff       	jmp    101e3b <__alltraps>

0010247d <vector164>:
.globl vector164
vector164:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $164
  10247f:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102484:	e9 b2 f9 ff ff       	jmp    101e3b <__alltraps>

00102489 <vector165>:
.globl vector165
vector165:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $165
  10248b:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102490:	e9 a6 f9 ff ff       	jmp    101e3b <__alltraps>

00102495 <vector166>:
.globl vector166
vector166:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $166
  102497:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10249c:	e9 9a f9 ff ff       	jmp    101e3b <__alltraps>

001024a1 <vector167>:
.globl vector167
vector167:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $167
  1024a3:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024a8:	e9 8e f9 ff ff       	jmp    101e3b <__alltraps>

001024ad <vector168>:
.globl vector168
vector168:
  pushl $0
  1024ad:	6a 00                	push   $0x0
  pushl $168
  1024af:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1024b4:	e9 82 f9 ff ff       	jmp    101e3b <__alltraps>

001024b9 <vector169>:
.globl vector169
vector169:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $169
  1024bb:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1024c0:	e9 76 f9 ff ff       	jmp    101e3b <__alltraps>

001024c5 <vector170>:
.globl vector170
vector170:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $170
  1024c7:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1024cc:	e9 6a f9 ff ff       	jmp    101e3b <__alltraps>

001024d1 <vector171>:
.globl vector171
vector171:
  pushl $0
  1024d1:	6a 00                	push   $0x0
  pushl $171
  1024d3:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024d8:	e9 5e f9 ff ff       	jmp    101e3b <__alltraps>

001024dd <vector172>:
.globl vector172
vector172:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $172
  1024df:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024e4:	e9 52 f9 ff ff       	jmp    101e3b <__alltraps>

001024e9 <vector173>:
.globl vector173
vector173:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $173
  1024eb:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024f0:	e9 46 f9 ff ff       	jmp    101e3b <__alltraps>

001024f5 <vector174>:
.globl vector174
vector174:
  pushl $0
  1024f5:	6a 00                	push   $0x0
  pushl $174
  1024f7:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024fc:	e9 3a f9 ff ff       	jmp    101e3b <__alltraps>

00102501 <vector175>:
.globl vector175
vector175:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $175
  102503:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102508:	e9 2e f9 ff ff       	jmp    101e3b <__alltraps>

0010250d <vector176>:
.globl vector176
vector176:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $176
  10250f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102514:	e9 22 f9 ff ff       	jmp    101e3b <__alltraps>

00102519 <vector177>:
.globl vector177
vector177:
  pushl $0
  102519:	6a 00                	push   $0x0
  pushl $177
  10251b:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102520:	e9 16 f9 ff ff       	jmp    101e3b <__alltraps>

00102525 <vector178>:
.globl vector178
vector178:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $178
  102527:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10252c:	e9 0a f9 ff ff       	jmp    101e3b <__alltraps>

00102531 <vector179>:
.globl vector179
vector179:
  pushl $0
  102531:	6a 00                	push   $0x0
  pushl $179
  102533:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102538:	e9 fe f8 ff ff       	jmp    101e3b <__alltraps>

0010253d <vector180>:
.globl vector180
vector180:
  pushl $0
  10253d:	6a 00                	push   $0x0
  pushl $180
  10253f:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102544:	e9 f2 f8 ff ff       	jmp    101e3b <__alltraps>

00102549 <vector181>:
.globl vector181
vector181:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $181
  10254b:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102550:	e9 e6 f8 ff ff       	jmp    101e3b <__alltraps>

00102555 <vector182>:
.globl vector182
vector182:
  pushl $0
  102555:	6a 00                	push   $0x0
  pushl $182
  102557:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10255c:	e9 da f8 ff ff       	jmp    101e3b <__alltraps>

00102561 <vector183>:
.globl vector183
vector183:
  pushl $0
  102561:	6a 00                	push   $0x0
  pushl $183
  102563:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102568:	e9 ce f8 ff ff       	jmp    101e3b <__alltraps>

0010256d <vector184>:
.globl vector184
vector184:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $184
  10256f:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102574:	e9 c2 f8 ff ff       	jmp    101e3b <__alltraps>

00102579 <vector185>:
.globl vector185
vector185:
  pushl $0
  102579:	6a 00                	push   $0x0
  pushl $185
  10257b:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102580:	e9 b6 f8 ff ff       	jmp    101e3b <__alltraps>

00102585 <vector186>:
.globl vector186
vector186:
  pushl $0
  102585:	6a 00                	push   $0x0
  pushl $186
  102587:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10258c:	e9 aa f8 ff ff       	jmp    101e3b <__alltraps>

00102591 <vector187>:
.globl vector187
vector187:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $187
  102593:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102598:	e9 9e f8 ff ff       	jmp    101e3b <__alltraps>

0010259d <vector188>:
.globl vector188
vector188:
  pushl $0
  10259d:	6a 00                	push   $0x0
  pushl $188
  10259f:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025a4:	e9 92 f8 ff ff       	jmp    101e3b <__alltraps>

001025a9 <vector189>:
.globl vector189
vector189:
  pushl $0
  1025a9:	6a 00                	push   $0x0
  pushl $189
  1025ab:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1025b0:	e9 86 f8 ff ff       	jmp    101e3b <__alltraps>

001025b5 <vector190>:
.globl vector190
vector190:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $190
  1025b7:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1025bc:	e9 7a f8 ff ff       	jmp    101e3b <__alltraps>

001025c1 <vector191>:
.globl vector191
vector191:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $191
  1025c3:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1025c8:	e9 6e f8 ff ff       	jmp    101e3b <__alltraps>

001025cd <vector192>:
.globl vector192
vector192:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $192
  1025cf:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025d4:	e9 62 f8 ff ff       	jmp    101e3b <__alltraps>

001025d9 <vector193>:
.globl vector193
vector193:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $193
  1025db:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025e0:	e9 56 f8 ff ff       	jmp    101e3b <__alltraps>

001025e5 <vector194>:
.globl vector194
vector194:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $194
  1025e7:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025ec:	e9 4a f8 ff ff       	jmp    101e3b <__alltraps>

001025f1 <vector195>:
.globl vector195
vector195:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $195
  1025f3:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025f8:	e9 3e f8 ff ff       	jmp    101e3b <__alltraps>

001025fd <vector196>:
.globl vector196
vector196:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $196
  1025ff:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102604:	e9 32 f8 ff ff       	jmp    101e3b <__alltraps>

00102609 <vector197>:
.globl vector197
vector197:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $197
  10260b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102610:	e9 26 f8 ff ff       	jmp    101e3b <__alltraps>

00102615 <vector198>:
.globl vector198
vector198:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $198
  102617:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10261c:	e9 1a f8 ff ff       	jmp    101e3b <__alltraps>

00102621 <vector199>:
.globl vector199
vector199:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $199
  102623:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102628:	e9 0e f8 ff ff       	jmp    101e3b <__alltraps>

0010262d <vector200>:
.globl vector200
vector200:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $200
  10262f:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102634:	e9 02 f8 ff ff       	jmp    101e3b <__alltraps>

00102639 <vector201>:
.globl vector201
vector201:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $201
  10263b:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102640:	e9 f6 f7 ff ff       	jmp    101e3b <__alltraps>

00102645 <vector202>:
.globl vector202
vector202:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $202
  102647:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10264c:	e9 ea f7 ff ff       	jmp    101e3b <__alltraps>

00102651 <vector203>:
.globl vector203
vector203:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $203
  102653:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102658:	e9 de f7 ff ff       	jmp    101e3b <__alltraps>

0010265d <vector204>:
.globl vector204
vector204:
  pushl $0
  10265d:	6a 00                	push   $0x0
  pushl $204
  10265f:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102664:	e9 d2 f7 ff ff       	jmp    101e3b <__alltraps>

00102669 <vector205>:
.globl vector205
vector205:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $205
  10266b:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102670:	e9 c6 f7 ff ff       	jmp    101e3b <__alltraps>

00102675 <vector206>:
.globl vector206
vector206:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $206
  102677:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10267c:	e9 ba f7 ff ff       	jmp    101e3b <__alltraps>

00102681 <vector207>:
.globl vector207
vector207:
  pushl $0
  102681:	6a 00                	push   $0x0
  pushl $207
  102683:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102688:	e9 ae f7 ff ff       	jmp    101e3b <__alltraps>

0010268d <vector208>:
.globl vector208
vector208:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $208
  10268f:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102694:	e9 a2 f7 ff ff       	jmp    101e3b <__alltraps>

00102699 <vector209>:
.globl vector209
vector209:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $209
  10269b:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1026a0:	e9 96 f7 ff ff       	jmp    101e3b <__alltraps>

001026a5 <vector210>:
.globl vector210
vector210:
  pushl $0
  1026a5:	6a 00                	push   $0x0
  pushl $210
  1026a7:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1026ac:	e9 8a f7 ff ff       	jmp    101e3b <__alltraps>

001026b1 <vector211>:
.globl vector211
vector211:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $211
  1026b3:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1026b8:	e9 7e f7 ff ff       	jmp    101e3b <__alltraps>

001026bd <vector212>:
.globl vector212
vector212:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $212
  1026bf:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1026c4:	e9 72 f7 ff ff       	jmp    101e3b <__alltraps>

001026c9 <vector213>:
.globl vector213
vector213:
  pushl $0
  1026c9:	6a 00                	push   $0x0
  pushl $213
  1026cb:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026d0:	e9 66 f7 ff ff       	jmp    101e3b <__alltraps>

001026d5 <vector214>:
.globl vector214
vector214:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $214
  1026d7:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026dc:	e9 5a f7 ff ff       	jmp    101e3b <__alltraps>

001026e1 <vector215>:
.globl vector215
vector215:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $215
  1026e3:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026e8:	e9 4e f7 ff ff       	jmp    101e3b <__alltraps>

001026ed <vector216>:
.globl vector216
vector216:
  pushl $0
  1026ed:	6a 00                	push   $0x0
  pushl $216
  1026ef:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026f4:	e9 42 f7 ff ff       	jmp    101e3b <__alltraps>

001026f9 <vector217>:
.globl vector217
vector217:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $217
  1026fb:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102700:	e9 36 f7 ff ff       	jmp    101e3b <__alltraps>

00102705 <vector218>:
.globl vector218
vector218:
  pushl $0
  102705:	6a 00                	push   $0x0
  pushl $218
  102707:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10270c:	e9 2a f7 ff ff       	jmp    101e3b <__alltraps>

00102711 <vector219>:
.globl vector219
vector219:
  pushl $0
  102711:	6a 00                	push   $0x0
  pushl $219
  102713:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102718:	e9 1e f7 ff ff       	jmp    101e3b <__alltraps>

0010271d <vector220>:
.globl vector220
vector220:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $220
  10271f:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102724:	e9 12 f7 ff ff       	jmp    101e3b <__alltraps>

00102729 <vector221>:
.globl vector221
vector221:
  pushl $0
  102729:	6a 00                	push   $0x0
  pushl $221
  10272b:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102730:	e9 06 f7 ff ff       	jmp    101e3b <__alltraps>

00102735 <vector222>:
.globl vector222
vector222:
  pushl $0
  102735:	6a 00                	push   $0x0
  pushl $222
  102737:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10273c:	e9 fa f6 ff ff       	jmp    101e3b <__alltraps>

00102741 <vector223>:
.globl vector223
vector223:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $223
  102743:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102748:	e9 ee f6 ff ff       	jmp    101e3b <__alltraps>

0010274d <vector224>:
.globl vector224
vector224:
  pushl $0
  10274d:	6a 00                	push   $0x0
  pushl $224
  10274f:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102754:	e9 e2 f6 ff ff       	jmp    101e3b <__alltraps>

00102759 <vector225>:
.globl vector225
vector225:
  pushl $0
  102759:	6a 00                	push   $0x0
  pushl $225
  10275b:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102760:	e9 d6 f6 ff ff       	jmp    101e3b <__alltraps>

00102765 <vector226>:
.globl vector226
vector226:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $226
  102767:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10276c:	e9 ca f6 ff ff       	jmp    101e3b <__alltraps>

00102771 <vector227>:
.globl vector227
vector227:
  pushl $0
  102771:	6a 00                	push   $0x0
  pushl $227
  102773:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102778:	e9 be f6 ff ff       	jmp    101e3b <__alltraps>

0010277d <vector228>:
.globl vector228
vector228:
  pushl $0
  10277d:	6a 00                	push   $0x0
  pushl $228
  10277f:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102784:	e9 b2 f6 ff ff       	jmp    101e3b <__alltraps>

00102789 <vector229>:
.globl vector229
vector229:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $229
  10278b:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102790:	e9 a6 f6 ff ff       	jmp    101e3b <__alltraps>

00102795 <vector230>:
.globl vector230
vector230:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $230
  102797:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10279c:	e9 9a f6 ff ff       	jmp    101e3b <__alltraps>

001027a1 <vector231>:
.globl vector231
vector231:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $231
  1027a3:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027a8:	e9 8e f6 ff ff       	jmp    101e3b <__alltraps>

001027ad <vector232>:
.globl vector232
vector232:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $232
  1027af:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1027b4:	e9 82 f6 ff ff       	jmp    101e3b <__alltraps>

001027b9 <vector233>:
.globl vector233
vector233:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $233
  1027bb:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1027c0:	e9 76 f6 ff ff       	jmp    101e3b <__alltraps>

001027c5 <vector234>:
.globl vector234
vector234:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $234
  1027c7:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1027cc:	e9 6a f6 ff ff       	jmp    101e3b <__alltraps>

001027d1 <vector235>:
.globl vector235
vector235:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $235
  1027d3:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027d8:	e9 5e f6 ff ff       	jmp    101e3b <__alltraps>

001027dd <vector236>:
.globl vector236
vector236:
  pushl $0
  1027dd:	6a 00                	push   $0x0
  pushl $236
  1027df:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027e4:	e9 52 f6 ff ff       	jmp    101e3b <__alltraps>

001027e9 <vector237>:
.globl vector237
vector237:
  pushl $0
  1027e9:	6a 00                	push   $0x0
  pushl $237
  1027eb:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027f0:	e9 46 f6 ff ff       	jmp    101e3b <__alltraps>

001027f5 <vector238>:
.globl vector238
vector238:
  pushl $0
  1027f5:	6a 00                	push   $0x0
  pushl $238
  1027f7:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027fc:	e9 3a f6 ff ff       	jmp    101e3b <__alltraps>

00102801 <vector239>:
.globl vector239
vector239:
  pushl $0
  102801:	6a 00                	push   $0x0
  pushl $239
  102803:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102808:	e9 2e f6 ff ff       	jmp    101e3b <__alltraps>

0010280d <vector240>:
.globl vector240
vector240:
  pushl $0
  10280d:	6a 00                	push   $0x0
  pushl $240
  10280f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102814:	e9 22 f6 ff ff       	jmp    101e3b <__alltraps>

00102819 <vector241>:
.globl vector241
vector241:
  pushl $0
  102819:	6a 00                	push   $0x0
  pushl $241
  10281b:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102820:	e9 16 f6 ff ff       	jmp    101e3b <__alltraps>

00102825 <vector242>:
.globl vector242
vector242:
  pushl $0
  102825:	6a 00                	push   $0x0
  pushl $242
  102827:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10282c:	e9 0a f6 ff ff       	jmp    101e3b <__alltraps>

00102831 <vector243>:
.globl vector243
vector243:
  pushl $0
  102831:	6a 00                	push   $0x0
  pushl $243
  102833:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102838:	e9 fe f5 ff ff       	jmp    101e3b <__alltraps>

0010283d <vector244>:
.globl vector244
vector244:
  pushl $0
  10283d:	6a 00                	push   $0x0
  pushl $244
  10283f:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102844:	e9 f2 f5 ff ff       	jmp    101e3b <__alltraps>

00102849 <vector245>:
.globl vector245
vector245:
  pushl $0
  102849:	6a 00                	push   $0x0
  pushl $245
  10284b:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102850:	e9 e6 f5 ff ff       	jmp    101e3b <__alltraps>

00102855 <vector246>:
.globl vector246
vector246:
  pushl $0
  102855:	6a 00                	push   $0x0
  pushl $246
  102857:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10285c:	e9 da f5 ff ff       	jmp    101e3b <__alltraps>

00102861 <vector247>:
.globl vector247
vector247:
  pushl $0
  102861:	6a 00                	push   $0x0
  pushl $247
  102863:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102868:	e9 ce f5 ff ff       	jmp    101e3b <__alltraps>

0010286d <vector248>:
.globl vector248
vector248:
  pushl $0
  10286d:	6a 00                	push   $0x0
  pushl $248
  10286f:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102874:	e9 c2 f5 ff ff       	jmp    101e3b <__alltraps>

00102879 <vector249>:
.globl vector249
vector249:
  pushl $0
  102879:	6a 00                	push   $0x0
  pushl $249
  10287b:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102880:	e9 b6 f5 ff ff       	jmp    101e3b <__alltraps>

00102885 <vector250>:
.globl vector250
vector250:
  pushl $0
  102885:	6a 00                	push   $0x0
  pushl $250
  102887:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10288c:	e9 aa f5 ff ff       	jmp    101e3b <__alltraps>

00102891 <vector251>:
.globl vector251
vector251:
  pushl $0
  102891:	6a 00                	push   $0x0
  pushl $251
  102893:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102898:	e9 9e f5 ff ff       	jmp    101e3b <__alltraps>

0010289d <vector252>:
.globl vector252
vector252:
  pushl $0
  10289d:	6a 00                	push   $0x0
  pushl $252
  10289f:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028a4:	e9 92 f5 ff ff       	jmp    101e3b <__alltraps>

001028a9 <vector253>:
.globl vector253
vector253:
  pushl $0
  1028a9:	6a 00                	push   $0x0
  pushl $253
  1028ab:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1028b0:	e9 86 f5 ff ff       	jmp    101e3b <__alltraps>

001028b5 <vector254>:
.globl vector254
vector254:
  pushl $0
  1028b5:	6a 00                	push   $0x0
  pushl $254
  1028b7:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1028bc:	e9 7a f5 ff ff       	jmp    101e3b <__alltraps>

001028c1 <vector255>:
.globl vector255
vector255:
  pushl $0
  1028c1:	6a 00                	push   $0x0
  pushl $255
  1028c3:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1028c8:	e9 6e f5 ff ff       	jmp    101e3b <__alltraps>

001028cd <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1028cd:	55                   	push   %ebp
  1028ce:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1028d0:	8b 55 08             	mov    0x8(%ebp),%edx
  1028d3:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  1028d8:	29 c2                	sub    %eax,%edx
  1028da:	89 d0                	mov    %edx,%eax
  1028dc:	c1 f8 02             	sar    $0x2,%eax
  1028df:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028e5:	5d                   	pop    %ebp
  1028e6:	c3                   	ret    

001028e7 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028e7:	55                   	push   %ebp
  1028e8:	89 e5                	mov    %esp,%ebp
  1028ea:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1028ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1028f0:	89 04 24             	mov    %eax,(%esp)
  1028f3:	e8 d5 ff ff ff       	call   1028cd <page2ppn>
  1028f8:	c1 e0 0c             	shl    $0xc,%eax
}
  1028fb:	c9                   	leave  
  1028fc:	c3                   	ret    

001028fd <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1028fd:	55                   	push   %ebp
  1028fe:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102900:	8b 45 08             	mov    0x8(%ebp),%eax
  102903:	8b 00                	mov    (%eax),%eax
}
  102905:	5d                   	pop    %ebp
  102906:	c3                   	ret    

00102907 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102907:	55                   	push   %ebp
  102908:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10290a:	8b 45 08             	mov    0x8(%ebp),%eax
  10290d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102910:	89 10                	mov    %edx,(%eax)
}
  102912:	5d                   	pop    %ebp
  102913:	c3                   	ret    

00102914 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  102914:	55                   	push   %ebp
  102915:	89 e5                	mov    %esp,%ebp
  102917:	83 ec 10             	sub    $0x10,%esp
  10291a:	c7 45 fc b0 89 11 00 	movl   $0x1189b0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102921:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102924:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102927:	89 50 04             	mov    %edx,0x4(%eax)
  10292a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10292d:	8b 50 04             	mov    0x4(%eax),%edx
  102930:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102933:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  102935:	c7 05 b8 89 11 00 00 	movl   $0x0,0x1189b8
  10293c:	00 00 00 
}
  10293f:	c9                   	leave  
  102940:	c3                   	ret    

00102941 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  102941:	55                   	push   %ebp
  102942:	89 e5                	mov    %esp,%ebp
  102944:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  102947:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10294b:	75 24                	jne    102971 <default_init_memmap+0x30>
  10294d:	c7 44 24 0c 10 66 10 	movl   $0x106610,0xc(%esp)
  102954:	00 
  102955:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  10295c:	00 
  10295d:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  102964:	00 
  102965:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  10296c:	e8 ab e2 ff ff       	call   100c1c <__panic>
    struct Page *p = base;
  102971:	8b 45 08             	mov    0x8(%ebp),%eax
  102974:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102977:	e9 dc 00 00 00       	jmp    102a58 <default_init_memmap+0x117>
        assert(PageReserved(p));
  10297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10297f:	83 c0 04             	add    $0x4,%eax
  102982:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102989:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10298c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10298f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102992:	0f a3 10             	bt     %edx,(%eax)
  102995:	19 c0                	sbb    %eax,%eax
  102997:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  10299a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10299e:	0f 95 c0             	setne  %al
  1029a1:	0f b6 c0             	movzbl %al,%eax
  1029a4:	85 c0                	test   %eax,%eax
  1029a6:	75 24                	jne    1029cc <default_init_memmap+0x8b>
  1029a8:	c7 44 24 0c 41 66 10 	movl   $0x106641,0xc(%esp)
  1029af:	00 
  1029b0:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  1029b7:	00 
  1029b8:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  1029bf:	00 
  1029c0:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  1029c7:	e8 50 e2 ff ff       	call   100c1c <__panic>
        p->flags = 0;
  1029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
  1029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029d9:	83 c0 04             	add    $0x4,%eax
  1029dc:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  1029e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1029e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1029ec:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
  1029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
  1029f9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102a00:	00 
  102a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a04:	89 04 24             	mov    %eax,(%esp)
  102a07:	e8 fb fe ff ff       	call   102907 <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
  102a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a0f:	83 c0 0c             	add    $0xc,%eax
  102a12:	c7 45 dc b0 89 11 00 	movl   $0x1189b0,-0x24(%ebp)
  102a19:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102a1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a1f:	8b 00                	mov    (%eax),%eax
  102a21:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102a24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102a27:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102a2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a2d:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102a30:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a33:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a36:	89 10                	mov    %edx,(%eax)
  102a38:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a3b:	8b 10                	mov    (%eax),%edx
  102a3d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102a40:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102a43:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a46:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102a49:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102a4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a4f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102a52:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102a54:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a5b:	89 d0                	mov    %edx,%eax
  102a5d:	c1 e0 02             	shl    $0x2,%eax
  102a60:	01 d0                	add    %edx,%eax
  102a62:	c1 e0 02             	shl    $0x2,%eax
  102a65:	89 c2                	mov    %eax,%edx
  102a67:	8b 45 08             	mov    0x8(%ebp),%eax
  102a6a:	01 d0                	add    %edx,%eax
  102a6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a6f:	0f 85 07 ff ff ff    	jne    10297c <default_init_memmap+0x3b>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
  102a75:	8b 45 08             	mov    0x8(%ebp),%eax
  102a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a7b:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  102a7e:	8b 15 b8 89 11 00    	mov    0x1189b8,%edx
  102a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a87:	01 d0                	add    %edx,%eax
  102a89:	a3 b8 89 11 00       	mov    %eax,0x1189b8
}
  102a8e:	c9                   	leave  
  102a8f:	c3                   	ret    

00102a90 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102a90:	55                   	push   %ebp
  102a91:	89 e5                	mov    %esp,%ebp
  102a93:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102a96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102a9a:	75 24                	jne    102ac0 <default_alloc_pages+0x30>
  102a9c:	c7 44 24 0c 10 66 10 	movl   $0x106610,0xc(%esp)
  102aa3:	00 
  102aa4:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  102aab:	00 
  102aac:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  102ab3:	00 
  102ab4:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  102abb:	e8 5c e1 ff ff       	call   100c1c <__panic>
    if (n > nr_free) {
  102ac0:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  102ac5:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ac8:	73 0a                	jae    102ad4 <default_alloc_pages+0x44>
        return NULL;
  102aca:	b8 00 00 00 00       	mov    $0x0,%eax
  102acf:	e9 37 01 00 00       	jmp    102c0b <default_alloc_pages+0x17b>
    }

    list_entry_t *le, *len;
    le = &free_list;
  102ad4:	c7 45 f4 b0 89 11 00 	movl   $0x1189b0,-0xc(%ebp)

    while ((le = list_next(le)) != &free_list) {
  102adb:	e9 0a 01 00 00       	jmp    102bea <default_alloc_pages+0x15a>
        struct Page *p = le2page(le, page_link);
  102ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ae3:	83 e8 0c             	sub    $0xc,%eax
  102ae6:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  102ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102aec:	8b 40 08             	mov    0x8(%eax),%eax
  102aef:	3b 45 08             	cmp    0x8(%ebp),%eax
  102af2:	0f 82 f2 00 00 00    	jb     102bea <default_alloc_pages+0x15a>
            int i;
            //alloc the following n size block
            for (i = 0; i < n; i++) {
  102af8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102aff:	eb 7c                	jmp    102b7d <default_alloc_pages+0xed>
  102b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b04:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102b07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b0a:	8b 40 04             	mov    0x4(%eax),%eax
            	len = list_next(le);
  102b0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
            	struct Page *page = le2page(len, page_link);
  102b10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b13:	83 e8 0c             	sub    $0xc,%eax
  102b16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            	SetPageReserved(page);
  102b19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b1c:	83 c0 04             	add    $0x4,%eax
  102b1f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102b26:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102b2f:	0f ab 10             	bts    %edx,(%eax)
            	ClearPageProperty(page);
  102b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b35:	83 c0 04             	add    $0x4,%eax
  102b38:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102b3f:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b42:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b45:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b48:	0f b3 10             	btr    %edx,(%eax)
  102b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b4e:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102b51:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b54:	8b 40 04             	mov    0x4(%eax),%eax
  102b57:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102b5a:	8b 12                	mov    (%edx),%edx
  102b5c:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102b5f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102b62:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b65:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102b68:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102b6b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102b6e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102b71:	89 10                	mov    %edx,(%eax)
            	list_del(le);
            	le = len;
  102b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
            int i;
            //alloc the following n size block
            for (i = 0; i < n; i++) {
  102b79:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b80:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b83:	0f 82 78 ff ff ff    	jb     102b01 <default_alloc_pages+0x71>
            	ClearPageProperty(page);
            	list_del(le);
            	le = len;
            }
            //add the splitted block to free list
            if (p->property > n)
  102b89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b8c:	8b 40 08             	mov    0x8(%eax),%eax
  102b8f:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b92:	76 12                	jbe    102ba6 <default_alloc_pages+0x116>
            	(le2page(le, page_link))->property = p->property - n;
  102b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b97:	8d 50 f4             	lea    -0xc(%eax),%edx
  102b9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b9d:	8b 40 08             	mov    0x8(%eax),%eax
  102ba0:	2b 45 08             	sub    0x8(%ebp),%eax
  102ba3:	89 42 08             	mov    %eax,0x8(%edx)

            SetPageReserved(p);
  102ba6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ba9:	83 c0 04             	add    $0x4,%eax
  102bac:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  102bb3:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102bb6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102bb9:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102bbc:	0f ab 10             	bts    %edx,(%eax)
            ClearPageProperty(p);
  102bbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102bc2:	83 c0 04             	add    $0x4,%eax
  102bc5:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102bcc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102bcf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102bd2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102bd5:	0f b3 10             	btr    %edx,(%eax)
            nr_free -= n;
  102bd8:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  102bdd:	2b 45 08             	sub    0x8(%ebp),%eax
  102be0:	a3 b8 89 11 00       	mov    %eax,0x1189b8
            return p;
  102be5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102be8:	eb 21                	jmp    102c0b <default_alloc_pages+0x17b>
  102bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bed:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102bf0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102bf3:	8b 40 04             	mov    0x4(%eax),%eax
    }

    list_entry_t *le, *len;
    le = &free_list;

    while ((le = list_next(le)) != &free_list) {
  102bf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bf9:	81 7d f4 b0 89 11 00 	cmpl   $0x1189b0,-0xc(%ebp)
  102c00:	0f 85 da fe ff ff    	jne    102ae0 <default_alloc_pages+0x50>
            ClearPageProperty(p);
            nr_free -= n;
            return p;
        }
    }
    return NULL;
  102c06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c0b:	c9                   	leave  
  102c0c:	c3                   	ret    

00102c0d <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102c0d:	55                   	push   %ebp
  102c0e:	89 e5                	mov    %esp,%ebp
  102c10:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  102c13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c17:	75 24                	jne    102c3d <default_free_pages+0x30>
  102c19:	c7 44 24 0c 10 66 10 	movl   $0x106610,0xc(%esp)
  102c20:	00 
  102c21:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  102c28:	00 
  102c29:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  102c30:	00 
  102c31:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  102c38:	e8 df df ff ff       	call   100c1c <__panic>

    struct Page *p;
    list_entry_t *le = &free_list;
  102c3d:	c7 45 f0 b0 89 11 00 	movl   $0x1189b0,-0x10(%ebp)
    //search the free list, find the correct position
    while ((le = list_next(le)) != &free_list) {
  102c44:	eb 13                	jmp    102c59 <default_free_pages+0x4c>
    	p = le2page(le, page_link);
  102c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c49:	83 e8 0c             	sub    $0xc,%eax
  102c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	if (p > base)
  102c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c52:	3b 45 08             	cmp    0x8(%ebp),%eax
  102c55:	76 02                	jbe    102c59 <default_free_pages+0x4c>
    		break;
  102c57:	eb 18                	jmp    102c71 <default_free_pages+0x64>
  102c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102c5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c62:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);

    struct Page *p;
    list_entry_t *le = &free_list;
    //search the free list, find the correct position
    while ((le = list_next(le)) != &free_list) {
  102c65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c68:	81 7d f0 b0 89 11 00 	cmpl   $0x1189b0,-0x10(%ebp)
  102c6f:	75 d5                	jne    102c46 <default_free_pages+0x39>
    	p = le2page(le, page_link);
    	if (p > base)
    		break;
    }
	//insert the page
	for (p = base; p < base + n; p++)
  102c71:	8b 45 08             	mov    0x8(%ebp),%eax
  102c74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c77:	eb 4b                	jmp    102cc4 <default_free_pages+0xb7>
		list_add_before(le, &(p->page_link));
  102c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c7c:	8d 50 0c             	lea    0xc(%eax),%edx
  102c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c82:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c85:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102c88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c8b:	8b 00                	mov    (%eax),%eax
  102c8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102c90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  102c93:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102c96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c99:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102c9c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102c9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102ca2:	89 10                	mov    %edx,(%eax)
  102ca4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102ca7:	8b 10                	mov    (%eax),%edx
  102ca9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cac:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102caf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cb2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102cb5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102cb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cbb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102cbe:	89 10                	mov    %edx,(%eax)
    	p = le2page(le, page_link);
    	if (p > base)
    		break;
    }
	//insert the page
	for (p = base; p < base + n; p++)
  102cc0:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cc7:	89 d0                	mov    %edx,%eax
  102cc9:	c1 e0 02             	shl    $0x2,%eax
  102ccc:	01 d0                	add    %edx,%eax
  102cce:	c1 e0 02             	shl    $0x2,%eax
  102cd1:	89 c2                	mov    %eax,%edx
  102cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd6:	01 d0                	add    %edx,%eax
  102cd8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102cdb:	77 9c                	ja     102c79 <default_free_pages+0x6c>
		list_add_before(le, &(p->page_link));
	base->flags = 0;
  102cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	set_page_ref(base, 0);
  102ce7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102cee:	00 
  102cef:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf2:	89 04 24             	mov    %eax,(%esp)
  102cf5:	e8 0d fc ff ff       	call   102907 <set_page_ref>
	ClearPageProperty(base);
  102cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  102cfd:	83 c0 04             	add    $0x4,%eax
  102d00:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102d07:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102d0a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102d0d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102d10:	0f b3 10             	btr    %edx,(%eax)
	SetPageProperty(base);
  102d13:	8b 45 08             	mov    0x8(%ebp),%eax
  102d16:	83 c0 04             	add    $0x4,%eax
  102d19:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  102d20:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d23:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102d26:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102d29:	0f ab 10             	bts    %edx,(%eax)
	base->property = n;
  102d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d32:	89 50 08             	mov    %edx,0x8(%eax)
	
	//merge higher addr block
	p = le2page(le, page_link);
  102d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d38:	83 e8 0c             	sub    $0xc,%eax
  102d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if ((base + n) == p) {
  102d3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d41:	89 d0                	mov    %edx,%eax
  102d43:	c1 e0 02             	shl    $0x2,%eax
  102d46:	01 d0                	add    %edx,%eax
  102d48:	c1 e0 02             	shl    $0x2,%eax
  102d4b:	89 c2                	mov    %eax,%edx
  102d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d50:	01 d0                	add    %edx,%eax
  102d52:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102d55:	75 1e                	jne    102d75 <default_free_pages+0x168>
		base->property += p->property;
  102d57:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5a:	8b 50 08             	mov    0x8(%eax),%edx
  102d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d60:	8b 40 08             	mov    0x8(%eax),%eax
  102d63:	01 c2                	add    %eax,%edx
  102d65:	8b 45 08             	mov    0x8(%ebp),%eax
  102d68:	89 50 08             	mov    %edx,0x8(%eax)
		p->property = 0;
  102d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d6e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	}
	//merge lower addr block
	le = list_prev(&(base->page_link));
  102d75:	8b 45 08             	mov    0x8(%ebp),%eax
  102d78:	83 c0 0c             	add    $0xc,%eax
  102d7b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102d7e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d81:	8b 00                	mov    (%eax),%eax
  102d83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p = le2page(le, page_link);
  102d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d89:	83 e8 0c             	sub    $0xc,%eax
  102d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (le != &free_list && p + 1 == base) {
  102d8f:	81 7d f0 b0 89 11 00 	cmpl   $0x1189b0,-0x10(%ebp)
  102d96:	74 57                	je     102def <default_free_pages+0x1e2>
  102d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d9b:	83 c0 14             	add    $0x14,%eax
  102d9e:	3b 45 08             	cmp    0x8(%ebp),%eax
  102da1:	75 4c                	jne    102def <default_free_pages+0x1e2>
		while (le != &free_list) {
  102da3:	eb 41                	jmp    102de6 <default_free_pages+0x1d9>
			if (p->property != 0) {
  102da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102da8:	8b 40 08             	mov    0x8(%eax),%eax
  102dab:	85 c0                	test   %eax,%eax
  102dad:	74 20                	je     102dcf <default_free_pages+0x1c2>
				p->property += base->property;
  102daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102db2:	8b 50 08             	mov    0x8(%eax),%edx
  102db5:	8b 45 08             	mov    0x8(%ebp),%eax
  102db8:	8b 40 08             	mov    0x8(%eax),%eax
  102dbb:	01 c2                	add    %eax,%edx
  102dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dc0:	89 50 08             	mov    %edx,0x8(%eax)
				base->property = 0;
  102dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				break;
  102dcd:	eb 20                	jmp    102def <default_free_pages+0x1e2>
  102dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dd2:	89 45 c0             	mov    %eax,-0x40(%ebp)
  102dd5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102dd8:	8b 00                	mov    (%eax),%eax
			}
			le = list_prev(le);
  102dda:	89 45 f0             	mov    %eax,-0x10(%ebp)
			p = le2page(le, page_link);
  102ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102de0:	83 e8 0c             	sub    $0xc,%eax
  102de3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	//merge lower addr block
	le = list_prev(&(base->page_link));
	p = le2page(le, page_link);
	if (le != &free_list && p + 1 == base) {
		while (le != &free_list) {
  102de6:	81 7d f0 b0 89 11 00 	cmpl   $0x1189b0,-0x10(%ebp)
  102ded:	75 b6                	jne    102da5 <default_free_pages+0x198>
			le = list_prev(le);
			p = le2page(le, page_link);
		}
	}
	
	nr_free += n;
  102def:	8b 15 b8 89 11 00    	mov    0x1189b8,%edx
  102df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102df8:	01 d0                	add    %edx,%eax
  102dfa:	a3 b8 89 11 00       	mov    %eax,0x1189b8
	return;
  102dff:	90                   	nop
}
  102e00:	c9                   	leave  
  102e01:	c3                   	ret    

00102e02 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102e02:	55                   	push   %ebp
  102e03:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102e05:	a1 b8 89 11 00       	mov    0x1189b8,%eax
}
  102e0a:	5d                   	pop    %ebp
  102e0b:	c3                   	ret    

00102e0c <basic_check>:

static void
basic_check(void) {
  102e0c:	55                   	push   %ebp
  102e0d:	89 e5                	mov    %esp,%ebp
  102e0f:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102e12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e22:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102e25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e2c:	e8 85 0e 00 00       	call   103cb6 <alloc_pages>
  102e31:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e34:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102e38:	75 24                	jne    102e5e <basic_check+0x52>
  102e3a:	c7 44 24 0c 51 66 10 	movl   $0x106651,0xc(%esp)
  102e41:	00 
  102e42:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  102e49:	00 
  102e4a:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  102e51:	00 
  102e52:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  102e59:	e8 be dd ff ff       	call   100c1c <__panic>
    assert((p1 = alloc_page()) != NULL);
  102e5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e65:	e8 4c 0e 00 00       	call   103cb6 <alloc_pages>
  102e6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102e71:	75 24                	jne    102e97 <basic_check+0x8b>
  102e73:	c7 44 24 0c 6d 66 10 	movl   $0x10666d,0xc(%esp)
  102e7a:	00 
  102e7b:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  102e82:	00 
  102e83:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  102e8a:	00 
  102e8b:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  102e92:	e8 85 dd ff ff       	call   100c1c <__panic>
    assert((p2 = alloc_page()) != NULL);
  102e97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e9e:	e8 13 0e 00 00       	call   103cb6 <alloc_pages>
  102ea3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ea6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102eaa:	75 24                	jne    102ed0 <basic_check+0xc4>
  102eac:	c7 44 24 0c 89 66 10 	movl   $0x106689,0xc(%esp)
  102eb3:	00 
  102eb4:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  102ebb:	00 
  102ebc:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  102ec3:	00 
  102ec4:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  102ecb:	e8 4c dd ff ff       	call   100c1c <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102ed0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ed3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102ed6:	74 10                	je     102ee8 <basic_check+0xdc>
  102ed8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102edb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ede:	74 08                	je     102ee8 <basic_check+0xdc>
  102ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ee3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ee6:	75 24                	jne    102f0c <basic_check+0x100>
  102ee8:	c7 44 24 0c a8 66 10 	movl   $0x1066a8,0xc(%esp)
  102eef:	00 
  102ef0:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  102ef7:	00 
  102ef8:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
  102eff:	00 
  102f00:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  102f07:	e8 10 dd ff ff       	call   100c1c <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102f0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f0f:	89 04 24             	mov    %eax,(%esp)
  102f12:	e8 e6 f9 ff ff       	call   1028fd <page_ref>
  102f17:	85 c0                	test   %eax,%eax
  102f19:	75 1e                	jne    102f39 <basic_check+0x12d>
  102f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f1e:	89 04 24             	mov    %eax,(%esp)
  102f21:	e8 d7 f9 ff ff       	call   1028fd <page_ref>
  102f26:	85 c0                	test   %eax,%eax
  102f28:	75 0f                	jne    102f39 <basic_check+0x12d>
  102f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f2d:	89 04 24             	mov    %eax,(%esp)
  102f30:	e8 c8 f9 ff ff       	call   1028fd <page_ref>
  102f35:	85 c0                	test   %eax,%eax
  102f37:	74 24                	je     102f5d <basic_check+0x151>
  102f39:	c7 44 24 0c cc 66 10 	movl   $0x1066cc,0xc(%esp)
  102f40:	00 
  102f41:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  102f48:	00 
  102f49:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  102f50:	00 
  102f51:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  102f58:	e8 bf dc ff ff       	call   100c1c <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f60:	89 04 24             	mov    %eax,(%esp)
  102f63:	e8 7f f9 ff ff       	call   1028e7 <page2pa>
  102f68:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102f6e:	c1 e2 0c             	shl    $0xc,%edx
  102f71:	39 d0                	cmp    %edx,%eax
  102f73:	72 24                	jb     102f99 <basic_check+0x18d>
  102f75:	c7 44 24 0c 08 67 10 	movl   $0x106708,0xc(%esp)
  102f7c:	00 
  102f7d:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  102f84:	00 
  102f85:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  102f8c:	00 
  102f8d:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  102f94:	e8 83 dc ff ff       	call   100c1c <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f9c:	89 04 24             	mov    %eax,(%esp)
  102f9f:	e8 43 f9 ff ff       	call   1028e7 <page2pa>
  102fa4:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102faa:	c1 e2 0c             	shl    $0xc,%edx
  102fad:	39 d0                	cmp    %edx,%eax
  102faf:	72 24                	jb     102fd5 <basic_check+0x1c9>
  102fb1:	c7 44 24 0c 25 67 10 	movl   $0x106725,0xc(%esp)
  102fb8:	00 
  102fb9:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  102fc0:	00 
  102fc1:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  102fc8:	00 
  102fc9:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  102fd0:	e8 47 dc ff ff       	call   100c1c <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  102fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fd8:	89 04 24             	mov    %eax,(%esp)
  102fdb:	e8 07 f9 ff ff       	call   1028e7 <page2pa>
  102fe0:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102fe6:	c1 e2 0c             	shl    $0xc,%edx
  102fe9:	39 d0                	cmp    %edx,%eax
  102feb:	72 24                	jb     103011 <basic_check+0x205>
  102fed:	c7 44 24 0c 42 67 10 	movl   $0x106742,0xc(%esp)
  102ff4:	00 
  102ff5:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  102ffc:	00 
  102ffd:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  103004:	00 
  103005:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  10300c:	e8 0b dc ff ff       	call   100c1c <__panic>

    list_entry_t free_list_store = free_list;
  103011:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  103016:	8b 15 b4 89 11 00    	mov    0x1189b4,%edx
  10301c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10301f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103022:	c7 45 e0 b0 89 11 00 	movl   $0x1189b0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103029:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10302c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10302f:	89 50 04             	mov    %edx,0x4(%eax)
  103032:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103035:	8b 50 04             	mov    0x4(%eax),%edx
  103038:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10303b:	89 10                	mov    %edx,(%eax)
  10303d:	c7 45 dc b0 89 11 00 	movl   $0x1189b0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103044:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103047:	8b 40 04             	mov    0x4(%eax),%eax
  10304a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10304d:	0f 94 c0             	sete   %al
  103050:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103053:	85 c0                	test   %eax,%eax
  103055:	75 24                	jne    10307b <basic_check+0x26f>
  103057:	c7 44 24 0c 5f 67 10 	movl   $0x10675f,0xc(%esp)
  10305e:	00 
  10305f:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  103066:	00 
  103067:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
  10306e:	00 
  10306f:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  103076:	e8 a1 db ff ff       	call   100c1c <__panic>

    unsigned int nr_free_store = nr_free;
  10307b:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  103080:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  103083:	c7 05 b8 89 11 00 00 	movl   $0x0,0x1189b8
  10308a:	00 00 00 

    assert(alloc_page() == NULL);
  10308d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103094:	e8 1d 0c 00 00       	call   103cb6 <alloc_pages>
  103099:	85 c0                	test   %eax,%eax
  10309b:	74 24                	je     1030c1 <basic_check+0x2b5>
  10309d:	c7 44 24 0c 76 67 10 	movl   $0x106776,0xc(%esp)
  1030a4:	00 
  1030a5:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  1030ac:	00 
  1030ad:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
  1030b4:	00 
  1030b5:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  1030bc:	e8 5b db ff ff       	call   100c1c <__panic>

    free_page(p0);
  1030c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030c8:	00 
  1030c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030cc:	89 04 24             	mov    %eax,(%esp)
  1030cf:	e8 1a 0c 00 00       	call   103cee <free_pages>
    free_page(p1);
  1030d4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030db:	00 
  1030dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030df:	89 04 24             	mov    %eax,(%esp)
  1030e2:	e8 07 0c 00 00       	call   103cee <free_pages>
    free_page(p2);
  1030e7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030ee:	00 
  1030ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030f2:	89 04 24             	mov    %eax,(%esp)
  1030f5:	e8 f4 0b 00 00       	call   103cee <free_pages>
    assert(nr_free == 3);
  1030fa:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  1030ff:	83 f8 03             	cmp    $0x3,%eax
  103102:	74 24                	je     103128 <basic_check+0x31c>
  103104:	c7 44 24 0c 8b 67 10 	movl   $0x10678b,0xc(%esp)
  10310b:	00 
  10310c:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  103113:	00 
  103114:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
  10311b:	00 
  10311c:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  103123:	e8 f4 da ff ff       	call   100c1c <__panic>

    assert((p0 = alloc_page()) != NULL);
  103128:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10312f:	e8 82 0b 00 00       	call   103cb6 <alloc_pages>
  103134:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103137:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10313b:	75 24                	jne    103161 <basic_check+0x355>
  10313d:	c7 44 24 0c 51 66 10 	movl   $0x106651,0xc(%esp)
  103144:	00 
  103145:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  10314c:	00 
  10314d:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  103154:	00 
  103155:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  10315c:	e8 bb da ff ff       	call   100c1c <__panic>
    assert((p1 = alloc_page()) != NULL);
  103161:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103168:	e8 49 0b 00 00       	call   103cb6 <alloc_pages>
  10316d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103170:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103174:	75 24                	jne    10319a <basic_check+0x38e>
  103176:	c7 44 24 0c 6d 66 10 	movl   $0x10666d,0xc(%esp)
  10317d:	00 
  10317e:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  103185:	00 
  103186:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  10318d:	00 
  10318e:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  103195:	e8 82 da ff ff       	call   100c1c <__panic>
    assert((p2 = alloc_page()) != NULL);
  10319a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031a1:	e8 10 0b 00 00       	call   103cb6 <alloc_pages>
  1031a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1031ad:	75 24                	jne    1031d3 <basic_check+0x3c7>
  1031af:	c7 44 24 0c 89 66 10 	movl   $0x106689,0xc(%esp)
  1031b6:	00 
  1031b7:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  1031be:	00 
  1031bf:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  1031c6:	00 
  1031c7:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  1031ce:	e8 49 da ff ff       	call   100c1c <__panic>

    assert(alloc_page() == NULL);
  1031d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031da:	e8 d7 0a 00 00       	call   103cb6 <alloc_pages>
  1031df:	85 c0                	test   %eax,%eax
  1031e1:	74 24                	je     103207 <basic_check+0x3fb>
  1031e3:	c7 44 24 0c 76 67 10 	movl   $0x106776,0xc(%esp)
  1031ea:	00 
  1031eb:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  1031f2:	00 
  1031f3:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  1031fa:	00 
  1031fb:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  103202:	e8 15 da ff ff       	call   100c1c <__panic>

    free_page(p0);
  103207:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10320e:	00 
  10320f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103212:	89 04 24             	mov    %eax,(%esp)
  103215:	e8 d4 0a 00 00       	call   103cee <free_pages>
  10321a:	c7 45 d8 b0 89 11 00 	movl   $0x1189b0,-0x28(%ebp)
  103221:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103224:	8b 40 04             	mov    0x4(%eax),%eax
  103227:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10322a:	0f 94 c0             	sete   %al
  10322d:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  103230:	85 c0                	test   %eax,%eax
  103232:	74 24                	je     103258 <basic_check+0x44c>
  103234:	c7 44 24 0c 98 67 10 	movl   $0x106798,0xc(%esp)
  10323b:	00 
  10323c:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  103243:	00 
  103244:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  10324b:	00 
  10324c:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  103253:	e8 c4 d9 ff ff       	call   100c1c <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  103258:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10325f:	e8 52 0a 00 00       	call   103cb6 <alloc_pages>
  103264:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103267:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10326a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10326d:	74 24                	je     103293 <basic_check+0x487>
  10326f:	c7 44 24 0c b0 67 10 	movl   $0x1067b0,0xc(%esp)
  103276:	00 
  103277:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  10327e:	00 
  10327f:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  103286:	00 
  103287:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  10328e:	e8 89 d9 ff ff       	call   100c1c <__panic>
    assert(alloc_page() == NULL);
  103293:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10329a:	e8 17 0a 00 00       	call   103cb6 <alloc_pages>
  10329f:	85 c0                	test   %eax,%eax
  1032a1:	74 24                	je     1032c7 <basic_check+0x4bb>
  1032a3:	c7 44 24 0c 76 67 10 	movl   $0x106776,0xc(%esp)
  1032aa:	00 
  1032ab:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  1032b2:	00 
  1032b3:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
  1032ba:	00 
  1032bb:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  1032c2:	e8 55 d9 ff ff       	call   100c1c <__panic>

    assert(nr_free == 0);
  1032c7:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  1032cc:	85 c0                	test   %eax,%eax
  1032ce:	74 24                	je     1032f4 <basic_check+0x4e8>
  1032d0:	c7 44 24 0c c9 67 10 	movl   $0x1067c9,0xc(%esp)
  1032d7:	00 
  1032d8:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  1032df:	00 
  1032e0:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  1032e7:	00 
  1032e8:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  1032ef:	e8 28 d9 ff ff       	call   100c1c <__panic>
    free_list = free_list_store;
  1032f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1032f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1032fa:	a3 b0 89 11 00       	mov    %eax,0x1189b0
  1032ff:	89 15 b4 89 11 00    	mov    %edx,0x1189b4
    nr_free = nr_free_store;
  103305:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103308:	a3 b8 89 11 00       	mov    %eax,0x1189b8

    free_page(p);
  10330d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103314:	00 
  103315:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103318:	89 04 24             	mov    %eax,(%esp)
  10331b:	e8 ce 09 00 00       	call   103cee <free_pages>
    free_page(p1);
  103320:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103327:	00 
  103328:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10332b:	89 04 24             	mov    %eax,(%esp)
  10332e:	e8 bb 09 00 00       	call   103cee <free_pages>
    free_page(p2);
  103333:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10333a:	00 
  10333b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10333e:	89 04 24             	mov    %eax,(%esp)
  103341:	e8 a8 09 00 00       	call   103cee <free_pages>
}
  103346:	c9                   	leave  
  103347:	c3                   	ret    

00103348 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  103348:	55                   	push   %ebp
  103349:	89 e5                	mov    %esp,%ebp
  10334b:	53                   	push   %ebx
  10334c:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  103352:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103359:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  103360:	c7 45 ec b0 89 11 00 	movl   $0x1189b0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103367:	eb 6b                	jmp    1033d4 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  103369:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10336c:	83 e8 0c             	sub    $0xc,%eax
  10336f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  103372:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103375:	83 c0 04             	add    $0x4,%eax
  103378:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  10337f:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103382:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103385:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103388:	0f a3 10             	bt     %edx,(%eax)
  10338b:	19 c0                	sbb    %eax,%eax
  10338d:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  103390:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  103394:	0f 95 c0             	setne  %al
  103397:	0f b6 c0             	movzbl %al,%eax
  10339a:	85 c0                	test   %eax,%eax
  10339c:	75 24                	jne    1033c2 <default_check+0x7a>
  10339e:	c7 44 24 0c d6 67 10 	movl   $0x1067d6,0xc(%esp)
  1033a5:	00 
  1033a6:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  1033ad:	00 
  1033ae:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  1033b5:	00 
  1033b6:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  1033bd:	e8 5a d8 ff ff       	call   100c1c <__panic>
        count ++, total += p->property;
  1033c2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1033c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033c9:	8b 50 08             	mov    0x8(%eax),%edx
  1033cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033cf:	01 d0                	add    %edx,%eax
  1033d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033d7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1033da:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1033dd:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1033e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1033e3:	81 7d ec b0 89 11 00 	cmpl   $0x1189b0,-0x14(%ebp)
  1033ea:	0f 85 79 ff ff ff    	jne    103369 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  1033f0:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  1033f3:	e8 28 09 00 00       	call   103d20 <nr_free_pages>
  1033f8:	39 c3                	cmp    %eax,%ebx
  1033fa:	74 24                	je     103420 <default_check+0xd8>
  1033fc:	c7 44 24 0c e6 67 10 	movl   $0x1067e6,0xc(%esp)
  103403:	00 
  103404:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  10340b:	00 
  10340c:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  103413:	00 
  103414:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  10341b:	e8 fc d7 ff ff       	call   100c1c <__panic>

    basic_check();
  103420:	e8 e7 f9 ff ff       	call   102e0c <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103425:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10342c:	e8 85 08 00 00       	call   103cb6 <alloc_pages>
  103431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  103434:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103438:	75 24                	jne    10345e <default_check+0x116>
  10343a:	c7 44 24 0c ff 67 10 	movl   $0x1067ff,0xc(%esp)
  103441:	00 
  103442:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  103449:	00 
  10344a:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  103451:	00 
  103452:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  103459:	e8 be d7 ff ff       	call   100c1c <__panic>
    assert(!PageProperty(p0));
  10345e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103461:	83 c0 04             	add    $0x4,%eax
  103464:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  10346b:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10346e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103471:	8b 55 c0             	mov    -0x40(%ebp),%edx
  103474:	0f a3 10             	bt     %edx,(%eax)
  103477:	19 c0                	sbb    %eax,%eax
  103479:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  10347c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  103480:	0f 95 c0             	setne  %al
  103483:	0f b6 c0             	movzbl %al,%eax
  103486:	85 c0                	test   %eax,%eax
  103488:	74 24                	je     1034ae <default_check+0x166>
  10348a:	c7 44 24 0c 0a 68 10 	movl   $0x10680a,0xc(%esp)
  103491:	00 
  103492:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  103499:	00 
  10349a:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  1034a1:	00 
  1034a2:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  1034a9:	e8 6e d7 ff ff       	call   100c1c <__panic>

    list_entry_t free_list_store = free_list;
  1034ae:	a1 b0 89 11 00       	mov    0x1189b0,%eax
  1034b3:	8b 15 b4 89 11 00    	mov    0x1189b4,%edx
  1034b9:	89 45 80             	mov    %eax,-0x80(%ebp)
  1034bc:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1034bf:	c7 45 b4 b0 89 11 00 	movl   $0x1189b0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1034c6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034c9:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1034cc:	89 50 04             	mov    %edx,0x4(%eax)
  1034cf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034d2:	8b 50 04             	mov    0x4(%eax),%edx
  1034d5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034d8:	89 10                	mov    %edx,(%eax)
  1034da:	c7 45 b0 b0 89 11 00 	movl   $0x1189b0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1034e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1034e4:	8b 40 04             	mov    0x4(%eax),%eax
  1034e7:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  1034ea:	0f 94 c0             	sete   %al
  1034ed:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1034f0:	85 c0                	test   %eax,%eax
  1034f2:	75 24                	jne    103518 <default_check+0x1d0>
  1034f4:	c7 44 24 0c 5f 67 10 	movl   $0x10675f,0xc(%esp)
  1034fb:	00 
  1034fc:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  103503:	00 
  103504:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  10350b:	00 
  10350c:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  103513:	e8 04 d7 ff ff       	call   100c1c <__panic>
    assert(alloc_page() == NULL);
  103518:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10351f:	e8 92 07 00 00       	call   103cb6 <alloc_pages>
  103524:	85 c0                	test   %eax,%eax
  103526:	74 24                	je     10354c <default_check+0x204>
  103528:	c7 44 24 0c 76 67 10 	movl   $0x106776,0xc(%esp)
  10352f:	00 
  103530:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  103537:	00 
  103538:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  10353f:	00 
  103540:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  103547:	e8 d0 d6 ff ff       	call   100c1c <__panic>

    unsigned int nr_free_store = nr_free;
  10354c:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  103551:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  103554:	c7 05 b8 89 11 00 00 	movl   $0x0,0x1189b8
  10355b:	00 00 00 

    free_pages(p0 + 2, 3);
  10355e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103561:	83 c0 28             	add    $0x28,%eax
  103564:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10356b:	00 
  10356c:	89 04 24             	mov    %eax,(%esp)
  10356f:	e8 7a 07 00 00       	call   103cee <free_pages>
    assert(alloc_pages(4) == NULL);
  103574:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10357b:	e8 36 07 00 00       	call   103cb6 <alloc_pages>
  103580:	85 c0                	test   %eax,%eax
  103582:	74 24                	je     1035a8 <default_check+0x260>
  103584:	c7 44 24 0c 1c 68 10 	movl   $0x10681c,0xc(%esp)
  10358b:	00 
  10358c:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  103593:	00 
  103594:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  10359b:	00 
  10359c:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  1035a3:	e8 74 d6 ff ff       	call   100c1c <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1035a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035ab:	83 c0 28             	add    $0x28,%eax
  1035ae:	83 c0 04             	add    $0x4,%eax
  1035b1:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1035b8:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035bb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1035be:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1035c1:	0f a3 10             	bt     %edx,(%eax)
  1035c4:	19 c0                	sbb    %eax,%eax
  1035c6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1035c9:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1035cd:	0f 95 c0             	setne  %al
  1035d0:	0f b6 c0             	movzbl %al,%eax
  1035d3:	85 c0                	test   %eax,%eax
  1035d5:	74 0e                	je     1035e5 <default_check+0x29d>
  1035d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035da:	83 c0 28             	add    $0x28,%eax
  1035dd:	8b 40 08             	mov    0x8(%eax),%eax
  1035e0:	83 f8 03             	cmp    $0x3,%eax
  1035e3:	74 24                	je     103609 <default_check+0x2c1>
  1035e5:	c7 44 24 0c 34 68 10 	movl   $0x106834,0xc(%esp)
  1035ec:	00 
  1035ed:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  1035f4:	00 
  1035f5:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  1035fc:	00 
  1035fd:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  103604:	e8 13 d6 ff ff       	call   100c1c <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103609:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  103610:	e8 a1 06 00 00       	call   103cb6 <alloc_pages>
  103615:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103618:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10361c:	75 24                	jne    103642 <default_check+0x2fa>
  10361e:	c7 44 24 0c 60 68 10 	movl   $0x106860,0xc(%esp)
  103625:	00 
  103626:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  10362d:	00 
  10362e:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  103635:	00 
  103636:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  10363d:	e8 da d5 ff ff       	call   100c1c <__panic>
    assert(alloc_page() == NULL);
  103642:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103649:	e8 68 06 00 00       	call   103cb6 <alloc_pages>
  10364e:	85 c0                	test   %eax,%eax
  103650:	74 24                	je     103676 <default_check+0x32e>
  103652:	c7 44 24 0c 76 67 10 	movl   $0x106776,0xc(%esp)
  103659:	00 
  10365a:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  103661:	00 
  103662:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  103669:	00 
  10366a:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  103671:	e8 a6 d5 ff ff       	call   100c1c <__panic>
    assert(p0 + 2 == p1);
  103676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103679:	83 c0 28             	add    $0x28,%eax
  10367c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10367f:	74 24                	je     1036a5 <default_check+0x35d>
  103681:	c7 44 24 0c 7e 68 10 	movl   $0x10687e,0xc(%esp)
  103688:	00 
  103689:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  103690:	00 
  103691:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  103698:	00 
  103699:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  1036a0:	e8 77 d5 ff ff       	call   100c1c <__panic>

    p2 = p0 + 1;
  1036a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036a8:	83 c0 14             	add    $0x14,%eax
  1036ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1036ae:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1036b5:	00 
  1036b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036b9:	89 04 24             	mov    %eax,(%esp)
  1036bc:	e8 2d 06 00 00       	call   103cee <free_pages>
    free_pages(p1, 3);
  1036c1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1036c8:	00 
  1036c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1036cc:	89 04 24             	mov    %eax,(%esp)
  1036cf:	e8 1a 06 00 00       	call   103cee <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1036d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036d7:	83 c0 04             	add    $0x4,%eax
  1036da:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1036e1:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036e4:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1036e7:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1036ea:	0f a3 10             	bt     %edx,(%eax)
  1036ed:	19 c0                	sbb    %eax,%eax
  1036ef:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1036f2:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1036f6:	0f 95 c0             	setne  %al
  1036f9:	0f b6 c0             	movzbl %al,%eax
  1036fc:	85 c0                	test   %eax,%eax
  1036fe:	74 0b                	je     10370b <default_check+0x3c3>
  103700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103703:	8b 40 08             	mov    0x8(%eax),%eax
  103706:	83 f8 01             	cmp    $0x1,%eax
  103709:	74 24                	je     10372f <default_check+0x3e7>
  10370b:	c7 44 24 0c 8c 68 10 	movl   $0x10688c,0xc(%esp)
  103712:	00 
  103713:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  10371a:	00 
  10371b:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  103722:	00 
  103723:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  10372a:	e8 ed d4 ff ff       	call   100c1c <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10372f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103732:	83 c0 04             	add    $0x4,%eax
  103735:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10373c:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10373f:	8b 45 90             	mov    -0x70(%ebp),%eax
  103742:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103745:	0f a3 10             	bt     %edx,(%eax)
  103748:	19 c0                	sbb    %eax,%eax
  10374a:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  10374d:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103751:	0f 95 c0             	setne  %al
  103754:	0f b6 c0             	movzbl %al,%eax
  103757:	85 c0                	test   %eax,%eax
  103759:	74 0b                	je     103766 <default_check+0x41e>
  10375b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10375e:	8b 40 08             	mov    0x8(%eax),%eax
  103761:	83 f8 03             	cmp    $0x3,%eax
  103764:	74 24                	je     10378a <default_check+0x442>
  103766:	c7 44 24 0c b4 68 10 	movl   $0x1068b4,0xc(%esp)
  10376d:	00 
  10376e:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  103775:	00 
  103776:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  10377d:	00 
  10377e:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  103785:	e8 92 d4 ff ff       	call   100c1c <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  10378a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103791:	e8 20 05 00 00       	call   103cb6 <alloc_pages>
  103796:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103799:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10379c:	83 e8 14             	sub    $0x14,%eax
  10379f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1037a2:	74 24                	je     1037c8 <default_check+0x480>
  1037a4:	c7 44 24 0c da 68 10 	movl   $0x1068da,0xc(%esp)
  1037ab:	00 
  1037ac:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  1037b3:	00 
  1037b4:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  1037bb:	00 
  1037bc:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  1037c3:	e8 54 d4 ff ff       	call   100c1c <__panic>
    free_page(p0);
  1037c8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1037cf:	00 
  1037d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037d3:	89 04 24             	mov    %eax,(%esp)
  1037d6:	e8 13 05 00 00       	call   103cee <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1037db:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1037e2:	e8 cf 04 00 00       	call   103cb6 <alloc_pages>
  1037e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037ed:	83 c0 14             	add    $0x14,%eax
  1037f0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1037f3:	74 24                	je     103819 <default_check+0x4d1>
  1037f5:	c7 44 24 0c f8 68 10 	movl   $0x1068f8,0xc(%esp)
  1037fc:	00 
  1037fd:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  103804:	00 
  103805:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  10380c:	00 
  10380d:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  103814:	e8 03 d4 ff ff       	call   100c1c <__panic>

    free_pages(p0, 2);
  103819:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103820:	00 
  103821:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103824:	89 04 24             	mov    %eax,(%esp)
  103827:	e8 c2 04 00 00       	call   103cee <free_pages>
    free_page(p2);
  10382c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103833:	00 
  103834:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103837:	89 04 24             	mov    %eax,(%esp)
  10383a:	e8 af 04 00 00       	call   103cee <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  10383f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103846:	e8 6b 04 00 00       	call   103cb6 <alloc_pages>
  10384b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10384e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103852:	75 24                	jne    103878 <default_check+0x530>
  103854:	c7 44 24 0c 18 69 10 	movl   $0x106918,0xc(%esp)
  10385b:	00 
  10385c:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  103863:	00 
  103864:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  10386b:	00 
  10386c:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  103873:	e8 a4 d3 ff ff       	call   100c1c <__panic>
    assert(alloc_page() == NULL);
  103878:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10387f:	e8 32 04 00 00       	call   103cb6 <alloc_pages>
  103884:	85 c0                	test   %eax,%eax
  103886:	74 24                	je     1038ac <default_check+0x564>
  103888:	c7 44 24 0c 76 67 10 	movl   $0x106776,0xc(%esp)
  10388f:	00 
  103890:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  103897:	00 
  103898:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  10389f:	00 
  1038a0:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  1038a7:	e8 70 d3 ff ff       	call   100c1c <__panic>

    assert(nr_free == 0);
  1038ac:	a1 b8 89 11 00       	mov    0x1189b8,%eax
  1038b1:	85 c0                	test   %eax,%eax
  1038b3:	74 24                	je     1038d9 <default_check+0x591>
  1038b5:	c7 44 24 0c c9 67 10 	movl   $0x1067c9,0xc(%esp)
  1038bc:	00 
  1038bd:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  1038c4:	00 
  1038c5:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  1038cc:	00 
  1038cd:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  1038d4:	e8 43 d3 ff ff       	call   100c1c <__panic>
    nr_free = nr_free_store;
  1038d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038dc:	a3 b8 89 11 00       	mov    %eax,0x1189b8

    free_list = free_list_store;
  1038e1:	8b 45 80             	mov    -0x80(%ebp),%eax
  1038e4:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1038e7:	a3 b0 89 11 00       	mov    %eax,0x1189b0
  1038ec:	89 15 b4 89 11 00    	mov    %edx,0x1189b4
    free_pages(p0, 5);
  1038f2:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  1038f9:	00 
  1038fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038fd:	89 04 24             	mov    %eax,(%esp)
  103900:	e8 e9 03 00 00       	call   103cee <free_pages>

    le = &free_list;
  103905:	c7 45 ec b0 89 11 00 	movl   $0x1189b0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10390c:	eb 1d                	jmp    10392b <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  10390e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103911:	83 e8 0c             	sub    $0xc,%eax
  103914:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103917:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10391b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10391e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103921:	8b 40 08             	mov    0x8(%eax),%eax
  103924:	29 c2                	sub    %eax,%edx
  103926:	89 d0                	mov    %edx,%eax
  103928:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10392b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10392e:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103931:	8b 45 88             	mov    -0x78(%ebp),%eax
  103934:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103937:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10393a:	81 7d ec b0 89 11 00 	cmpl   $0x1189b0,-0x14(%ebp)
  103941:	75 cb                	jne    10390e <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103943:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103947:	74 24                	je     10396d <default_check+0x625>
  103949:	c7 44 24 0c 36 69 10 	movl   $0x106936,0xc(%esp)
  103950:	00 
  103951:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  103958:	00 
  103959:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  103960:	00 
  103961:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  103968:	e8 af d2 ff ff       	call   100c1c <__panic>
    assert(total == 0);
  10396d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103971:	74 24                	je     103997 <default_check+0x64f>
  103973:	c7 44 24 0c 41 69 10 	movl   $0x106941,0xc(%esp)
  10397a:	00 
  10397b:	c7 44 24 08 16 66 10 	movl   $0x106616,0x8(%esp)
  103982:	00 
  103983:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  10398a:	00 
  10398b:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  103992:	e8 85 d2 ff ff       	call   100c1c <__panic>
}
  103997:	81 c4 94 00 00 00    	add    $0x94,%esp
  10399d:	5b                   	pop    %ebx
  10399e:	5d                   	pop    %ebp
  10399f:	c3                   	ret    

001039a0 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1039a0:	55                   	push   %ebp
  1039a1:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1039a3:	8b 55 08             	mov    0x8(%ebp),%edx
  1039a6:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  1039ab:	29 c2                	sub    %eax,%edx
  1039ad:	89 d0                	mov    %edx,%eax
  1039af:	c1 f8 02             	sar    $0x2,%eax
  1039b2:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1039b8:	5d                   	pop    %ebp
  1039b9:	c3                   	ret    

001039ba <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1039ba:	55                   	push   %ebp
  1039bb:	89 e5                	mov    %esp,%ebp
  1039bd:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1039c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1039c3:	89 04 24             	mov    %eax,(%esp)
  1039c6:	e8 d5 ff ff ff       	call   1039a0 <page2ppn>
  1039cb:	c1 e0 0c             	shl    $0xc,%eax
}
  1039ce:	c9                   	leave  
  1039cf:	c3                   	ret    

001039d0 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  1039d0:	55                   	push   %ebp
  1039d1:	89 e5                	mov    %esp,%ebp
  1039d3:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  1039d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1039d9:	c1 e8 0c             	shr    $0xc,%eax
  1039dc:	89 c2                	mov    %eax,%edx
  1039de:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1039e3:	39 c2                	cmp    %eax,%edx
  1039e5:	72 1c                	jb     103a03 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  1039e7:	c7 44 24 08 7c 69 10 	movl   $0x10697c,0x8(%esp)
  1039ee:	00 
  1039ef:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  1039f6:	00 
  1039f7:	c7 04 24 9b 69 10 00 	movl   $0x10699b,(%esp)
  1039fe:	e8 19 d2 ff ff       	call   100c1c <__panic>
    }
    return &pages[PPN(pa)];
  103a03:	8b 0d c4 89 11 00    	mov    0x1189c4,%ecx
  103a09:	8b 45 08             	mov    0x8(%ebp),%eax
  103a0c:	c1 e8 0c             	shr    $0xc,%eax
  103a0f:	89 c2                	mov    %eax,%edx
  103a11:	89 d0                	mov    %edx,%eax
  103a13:	c1 e0 02             	shl    $0x2,%eax
  103a16:	01 d0                	add    %edx,%eax
  103a18:	c1 e0 02             	shl    $0x2,%eax
  103a1b:	01 c8                	add    %ecx,%eax
}
  103a1d:	c9                   	leave  
  103a1e:	c3                   	ret    

00103a1f <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103a1f:	55                   	push   %ebp
  103a20:	89 e5                	mov    %esp,%ebp
  103a22:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103a25:	8b 45 08             	mov    0x8(%ebp),%eax
  103a28:	89 04 24             	mov    %eax,(%esp)
  103a2b:	e8 8a ff ff ff       	call   1039ba <page2pa>
  103a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a36:	c1 e8 0c             	shr    $0xc,%eax
  103a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a3c:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103a41:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103a44:	72 23                	jb     103a69 <page2kva+0x4a>
  103a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a49:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103a4d:	c7 44 24 08 ac 69 10 	movl   $0x1069ac,0x8(%esp)
  103a54:	00 
  103a55:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103a5c:	00 
  103a5d:	c7 04 24 9b 69 10 00 	movl   $0x10699b,(%esp)
  103a64:	e8 b3 d1 ff ff       	call   100c1c <__panic>
  103a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a6c:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103a71:	c9                   	leave  
  103a72:	c3                   	ret    

00103a73 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103a73:	55                   	push   %ebp
  103a74:	89 e5                	mov    %esp,%ebp
  103a76:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103a79:	8b 45 08             	mov    0x8(%ebp),%eax
  103a7c:	83 e0 01             	and    $0x1,%eax
  103a7f:	85 c0                	test   %eax,%eax
  103a81:	75 1c                	jne    103a9f <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103a83:	c7 44 24 08 d0 69 10 	movl   $0x1069d0,0x8(%esp)
  103a8a:	00 
  103a8b:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103a92:	00 
  103a93:	c7 04 24 9b 69 10 00 	movl   $0x10699b,(%esp)
  103a9a:	e8 7d d1 ff ff       	call   100c1c <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  103aa2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103aa7:	89 04 24             	mov    %eax,(%esp)
  103aaa:	e8 21 ff ff ff       	call   1039d0 <pa2page>
}
  103aaf:	c9                   	leave  
  103ab0:	c3                   	ret    

00103ab1 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103ab1:	55                   	push   %ebp
  103ab2:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  103ab7:	8b 00                	mov    (%eax),%eax
}
  103ab9:	5d                   	pop    %ebp
  103aba:	c3                   	ret    

00103abb <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103abb:	55                   	push   %ebp
  103abc:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103abe:	8b 45 08             	mov    0x8(%ebp),%eax
  103ac1:	8b 55 0c             	mov    0xc(%ebp),%edx
  103ac4:	89 10                	mov    %edx,(%eax)
}
  103ac6:	5d                   	pop    %ebp
  103ac7:	c3                   	ret    

00103ac8 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103ac8:	55                   	push   %ebp
  103ac9:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103acb:	8b 45 08             	mov    0x8(%ebp),%eax
  103ace:	8b 00                	mov    (%eax),%eax
  103ad0:	8d 50 01             	lea    0x1(%eax),%edx
  103ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  103ad6:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  103adb:	8b 00                	mov    (%eax),%eax
}
  103add:	5d                   	pop    %ebp
  103ade:	c3                   	ret    

00103adf <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103adf:	55                   	push   %ebp
  103ae0:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  103ae5:	8b 00                	mov    (%eax),%eax
  103ae7:	8d 50 ff             	lea    -0x1(%eax),%edx
  103aea:	8b 45 08             	mov    0x8(%ebp),%eax
  103aed:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103aef:	8b 45 08             	mov    0x8(%ebp),%eax
  103af2:	8b 00                	mov    (%eax),%eax
}
  103af4:	5d                   	pop    %ebp
  103af5:	c3                   	ret    

00103af6 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103af6:	55                   	push   %ebp
  103af7:	89 e5                	mov    %esp,%ebp
  103af9:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103afc:	9c                   	pushf  
  103afd:	58                   	pop    %eax
  103afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103b04:	25 00 02 00 00       	and    $0x200,%eax
  103b09:	85 c0                	test   %eax,%eax
  103b0b:	74 0c                	je     103b19 <__intr_save+0x23>
        intr_disable();
  103b0d:	e8 ed da ff ff       	call   1015ff <intr_disable>
        return 1;
  103b12:	b8 01 00 00 00       	mov    $0x1,%eax
  103b17:	eb 05                	jmp    103b1e <__intr_save+0x28>
    }
    return 0;
  103b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103b1e:	c9                   	leave  
  103b1f:	c3                   	ret    

00103b20 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103b20:	55                   	push   %ebp
  103b21:	89 e5                	mov    %esp,%ebp
  103b23:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103b26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103b2a:	74 05                	je     103b31 <__intr_restore+0x11>
        intr_enable();
  103b2c:	e8 c8 da ff ff       	call   1015f9 <intr_enable>
    }
}
  103b31:	c9                   	leave  
  103b32:	c3                   	ret    

00103b33 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103b33:	55                   	push   %ebp
  103b34:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103b36:	8b 45 08             	mov    0x8(%ebp),%eax
  103b39:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103b3c:	b8 23 00 00 00       	mov    $0x23,%eax
  103b41:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103b43:	b8 23 00 00 00       	mov    $0x23,%eax
  103b48:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103b4a:	b8 10 00 00 00       	mov    $0x10,%eax
  103b4f:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103b51:	b8 10 00 00 00       	mov    $0x10,%eax
  103b56:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103b58:	b8 10 00 00 00       	mov    $0x10,%eax
  103b5d:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103b5f:	ea 66 3b 10 00 08 00 	ljmp   $0x8,$0x103b66
}
  103b66:	5d                   	pop    %ebp
  103b67:	c3                   	ret    

00103b68 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103b68:	55                   	push   %ebp
  103b69:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  103b6e:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103b73:	5d                   	pop    %ebp
  103b74:	c3                   	ret    

00103b75 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103b75:	55                   	push   %ebp
  103b76:	89 e5                	mov    %esp,%ebp
  103b78:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103b7b:	b8 00 70 11 00       	mov    $0x117000,%eax
  103b80:	89 04 24             	mov    %eax,(%esp)
  103b83:	e8 e0 ff ff ff       	call   103b68 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103b88:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103b8f:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103b91:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103b98:	68 00 
  103b9a:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103b9f:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103ba5:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103baa:	c1 e8 10             	shr    $0x10,%eax
  103bad:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103bb2:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bb9:	83 e0 f0             	and    $0xfffffff0,%eax
  103bbc:	83 c8 09             	or     $0x9,%eax
  103bbf:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bc4:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bcb:	83 e0 ef             	and    $0xffffffef,%eax
  103bce:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bd3:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bda:	83 e0 9f             	and    $0xffffff9f,%eax
  103bdd:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103be2:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103be9:	83 c8 80             	or     $0xffffff80,%eax
  103bec:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bf1:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103bf8:	83 e0 f0             	and    $0xfffffff0,%eax
  103bfb:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c00:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c07:	83 e0 ef             	and    $0xffffffef,%eax
  103c0a:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c0f:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c16:	83 e0 df             	and    $0xffffffdf,%eax
  103c19:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c1e:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c25:	83 c8 40             	or     $0x40,%eax
  103c28:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c2d:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c34:	83 e0 7f             	and    $0x7f,%eax
  103c37:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c3c:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c41:	c1 e8 18             	shr    $0x18,%eax
  103c44:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103c49:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103c50:	e8 de fe ff ff       	call   103b33 <lgdt>
  103c55:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103c5b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103c5f:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103c62:	c9                   	leave  
  103c63:	c3                   	ret    

00103c64 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103c64:	55                   	push   %ebp
  103c65:	89 e5                	mov    %esp,%ebp
  103c67:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103c6a:	c7 05 bc 89 11 00 60 	movl   $0x106960,0x1189bc
  103c71:	69 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103c74:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103c79:	8b 00                	mov    (%eax),%eax
  103c7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  103c7f:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  103c86:	e8 c1 c6 ff ff       	call   10034c <cprintf>
    pmm_manager->init();
  103c8b:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103c90:	8b 40 04             	mov    0x4(%eax),%eax
  103c93:	ff d0                	call   *%eax
}
  103c95:	c9                   	leave  
  103c96:	c3                   	ret    

00103c97 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103c97:	55                   	push   %ebp
  103c98:	89 e5                	mov    %esp,%ebp
  103c9a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103c9d:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103ca2:	8b 40 08             	mov    0x8(%eax),%eax
  103ca5:	8b 55 0c             	mov    0xc(%ebp),%edx
  103ca8:	89 54 24 04          	mov    %edx,0x4(%esp)
  103cac:	8b 55 08             	mov    0x8(%ebp),%edx
  103caf:	89 14 24             	mov    %edx,(%esp)
  103cb2:	ff d0                	call   *%eax
}
  103cb4:	c9                   	leave  
  103cb5:	c3                   	ret    

00103cb6 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103cb6:	55                   	push   %ebp
  103cb7:	89 e5                	mov    %esp,%ebp
  103cb9:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103cbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103cc3:	e8 2e fe ff ff       	call   103af6 <__intr_save>
  103cc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103ccb:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103cd0:	8b 40 0c             	mov    0xc(%eax),%eax
  103cd3:	8b 55 08             	mov    0x8(%ebp),%edx
  103cd6:	89 14 24             	mov    %edx,(%esp)
  103cd9:	ff d0                	call   *%eax
  103cdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ce1:	89 04 24             	mov    %eax,(%esp)
  103ce4:	e8 37 fe ff ff       	call   103b20 <__intr_restore>
    return page;
  103ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103cec:	c9                   	leave  
  103ced:	c3                   	ret    

00103cee <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103cee:	55                   	push   %ebp
  103cef:	89 e5                	mov    %esp,%ebp
  103cf1:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103cf4:	e8 fd fd ff ff       	call   103af6 <__intr_save>
  103cf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103cfc:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103d01:	8b 40 10             	mov    0x10(%eax),%eax
  103d04:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d07:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  103d0e:	89 14 24             	mov    %edx,(%esp)
  103d11:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d16:	89 04 24             	mov    %eax,(%esp)
  103d19:	e8 02 fe ff ff       	call   103b20 <__intr_restore>
}
  103d1e:	c9                   	leave  
  103d1f:	c3                   	ret    

00103d20 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103d20:	55                   	push   %ebp
  103d21:	89 e5                	mov    %esp,%ebp
  103d23:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103d26:	e8 cb fd ff ff       	call   103af6 <__intr_save>
  103d2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103d2e:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  103d33:	8b 40 14             	mov    0x14(%eax),%eax
  103d36:	ff d0                	call   *%eax
  103d38:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d3e:	89 04 24             	mov    %eax,(%esp)
  103d41:	e8 da fd ff ff       	call   103b20 <__intr_restore>
    return ret;
  103d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103d49:	c9                   	leave  
  103d4a:	c3                   	ret    

00103d4b <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103d4b:	55                   	push   %ebp
  103d4c:	89 e5                	mov    %esp,%ebp
  103d4e:	57                   	push   %edi
  103d4f:	56                   	push   %esi
  103d50:	53                   	push   %ebx
  103d51:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103d57:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103d5e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103d65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103d6c:	c7 04 24 13 6a 10 00 	movl   $0x106a13,(%esp)
  103d73:	e8 d4 c5 ff ff       	call   10034c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103d78:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103d7f:	e9 15 01 00 00       	jmp    103e99 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103d84:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d87:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d8a:	89 d0                	mov    %edx,%eax
  103d8c:	c1 e0 02             	shl    $0x2,%eax
  103d8f:	01 d0                	add    %edx,%eax
  103d91:	c1 e0 02             	shl    $0x2,%eax
  103d94:	01 c8                	add    %ecx,%eax
  103d96:	8b 50 08             	mov    0x8(%eax),%edx
  103d99:	8b 40 04             	mov    0x4(%eax),%eax
  103d9c:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103d9f:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103da2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103da5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103da8:	89 d0                	mov    %edx,%eax
  103daa:	c1 e0 02             	shl    $0x2,%eax
  103dad:	01 d0                	add    %edx,%eax
  103daf:	c1 e0 02             	shl    $0x2,%eax
  103db2:	01 c8                	add    %ecx,%eax
  103db4:	8b 48 0c             	mov    0xc(%eax),%ecx
  103db7:	8b 58 10             	mov    0x10(%eax),%ebx
  103dba:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103dbd:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103dc0:	01 c8                	add    %ecx,%eax
  103dc2:	11 da                	adc    %ebx,%edx
  103dc4:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103dc7:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103dca:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dcd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dd0:	89 d0                	mov    %edx,%eax
  103dd2:	c1 e0 02             	shl    $0x2,%eax
  103dd5:	01 d0                	add    %edx,%eax
  103dd7:	c1 e0 02             	shl    $0x2,%eax
  103dda:	01 c8                	add    %ecx,%eax
  103ddc:	83 c0 14             	add    $0x14,%eax
  103ddf:	8b 00                	mov    (%eax),%eax
  103de1:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103de7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103dea:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103ded:	83 c0 ff             	add    $0xffffffff,%eax
  103df0:	83 d2 ff             	adc    $0xffffffff,%edx
  103df3:	89 c6                	mov    %eax,%esi
  103df5:	89 d7                	mov    %edx,%edi
  103df7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dfa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dfd:	89 d0                	mov    %edx,%eax
  103dff:	c1 e0 02             	shl    $0x2,%eax
  103e02:	01 d0                	add    %edx,%eax
  103e04:	c1 e0 02             	shl    $0x2,%eax
  103e07:	01 c8                	add    %ecx,%eax
  103e09:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e0c:	8b 58 10             	mov    0x10(%eax),%ebx
  103e0f:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103e15:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103e19:	89 74 24 14          	mov    %esi,0x14(%esp)
  103e1d:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103e21:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e24:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e2b:	89 54 24 10          	mov    %edx,0x10(%esp)
  103e2f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103e33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103e37:	c7 04 24 20 6a 10 00 	movl   $0x106a20,(%esp)
  103e3e:	e8 09 c5 ff ff       	call   10034c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103e43:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e46:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e49:	89 d0                	mov    %edx,%eax
  103e4b:	c1 e0 02             	shl    $0x2,%eax
  103e4e:	01 d0                	add    %edx,%eax
  103e50:	c1 e0 02             	shl    $0x2,%eax
  103e53:	01 c8                	add    %ecx,%eax
  103e55:	83 c0 14             	add    $0x14,%eax
  103e58:	8b 00                	mov    (%eax),%eax
  103e5a:	83 f8 01             	cmp    $0x1,%eax
  103e5d:	75 36                	jne    103e95 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103e5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103e62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103e65:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103e68:	77 2b                	ja     103e95 <page_init+0x14a>
  103e6a:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103e6d:	72 05                	jb     103e74 <page_init+0x129>
  103e6f:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103e72:	73 21                	jae    103e95 <page_init+0x14a>
  103e74:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103e78:	77 1b                	ja     103e95 <page_init+0x14a>
  103e7a:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103e7e:	72 09                	jb     103e89 <page_init+0x13e>
  103e80:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103e87:	77 0c                	ja     103e95 <page_init+0x14a>
                maxpa = end;
  103e89:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103e8c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103e8f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103e92:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103e95:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103e99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103e9c:	8b 00                	mov    (%eax),%eax
  103e9e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103ea1:	0f 8f dd fe ff ff    	jg     103d84 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103ea7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103eab:	72 1d                	jb     103eca <page_init+0x17f>
  103ead:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103eb1:	77 09                	ja     103ebc <page_init+0x171>
  103eb3:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103eba:	76 0e                	jbe    103eca <page_init+0x17f>
        maxpa = KMEMSIZE;
  103ebc:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103ec3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103eca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103ecd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103ed0:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103ed4:	c1 ea 0c             	shr    $0xc,%edx
  103ed7:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103edc:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103ee3:	b8 c8 89 11 00       	mov    $0x1189c8,%eax
  103ee8:	8d 50 ff             	lea    -0x1(%eax),%edx
  103eeb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103eee:	01 d0                	add    %edx,%eax
  103ef0:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103ef3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103ef6:	ba 00 00 00 00       	mov    $0x0,%edx
  103efb:	f7 75 ac             	divl   -0x54(%ebp)
  103efe:	89 d0                	mov    %edx,%eax
  103f00:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103f03:	29 c2                	sub    %eax,%edx
  103f05:	89 d0                	mov    %edx,%eax
  103f07:	a3 c4 89 11 00       	mov    %eax,0x1189c4

    for (i = 0; i < npage; i ++) {
  103f0c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f13:	eb 2f                	jmp    103f44 <page_init+0x1f9>
        SetPageReserved(pages + i);
  103f15:	8b 0d c4 89 11 00    	mov    0x1189c4,%ecx
  103f1b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f1e:	89 d0                	mov    %edx,%eax
  103f20:	c1 e0 02             	shl    $0x2,%eax
  103f23:	01 d0                	add    %edx,%eax
  103f25:	c1 e0 02             	shl    $0x2,%eax
  103f28:	01 c8                	add    %ecx,%eax
  103f2a:	83 c0 04             	add    $0x4,%eax
  103f2d:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103f34:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103f37:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103f3a:	8b 55 90             	mov    -0x70(%ebp),%edx
  103f3d:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103f40:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103f44:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f47:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103f4c:	39 c2                	cmp    %eax,%edx
  103f4e:	72 c5                	jb     103f15 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103f50:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103f56:	89 d0                	mov    %edx,%eax
  103f58:	c1 e0 02             	shl    $0x2,%eax
  103f5b:	01 d0                	add    %edx,%eax
  103f5d:	c1 e0 02             	shl    $0x2,%eax
  103f60:	89 c2                	mov    %eax,%edx
  103f62:	a1 c4 89 11 00       	mov    0x1189c4,%eax
  103f67:	01 d0                	add    %edx,%eax
  103f69:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103f6c:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103f73:	77 23                	ja     103f98 <page_init+0x24d>
  103f75:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103f78:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103f7c:	c7 44 24 08 50 6a 10 	movl   $0x106a50,0x8(%esp)
  103f83:	00 
  103f84:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103f8b:	00 
  103f8c:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  103f93:	e8 84 cc ff ff       	call   100c1c <__panic>
  103f98:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103f9b:	05 00 00 00 40       	add    $0x40000000,%eax
  103fa0:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103fa3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103faa:	e9 74 01 00 00       	jmp    104123 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103faf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fb2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fb5:	89 d0                	mov    %edx,%eax
  103fb7:	c1 e0 02             	shl    $0x2,%eax
  103fba:	01 d0                	add    %edx,%eax
  103fbc:	c1 e0 02             	shl    $0x2,%eax
  103fbf:	01 c8                	add    %ecx,%eax
  103fc1:	8b 50 08             	mov    0x8(%eax),%edx
  103fc4:	8b 40 04             	mov    0x4(%eax),%eax
  103fc7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103fca:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103fcd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fd0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fd3:	89 d0                	mov    %edx,%eax
  103fd5:	c1 e0 02             	shl    $0x2,%eax
  103fd8:	01 d0                	add    %edx,%eax
  103fda:	c1 e0 02             	shl    $0x2,%eax
  103fdd:	01 c8                	add    %ecx,%eax
  103fdf:	8b 48 0c             	mov    0xc(%eax),%ecx
  103fe2:	8b 58 10             	mov    0x10(%eax),%ebx
  103fe5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103fe8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103feb:	01 c8                	add    %ecx,%eax
  103fed:	11 da                	adc    %ebx,%edx
  103fef:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103ff2:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  103ff5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103ff8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ffb:	89 d0                	mov    %edx,%eax
  103ffd:	c1 e0 02             	shl    $0x2,%eax
  104000:	01 d0                	add    %edx,%eax
  104002:	c1 e0 02             	shl    $0x2,%eax
  104005:	01 c8                	add    %ecx,%eax
  104007:	83 c0 14             	add    $0x14,%eax
  10400a:	8b 00                	mov    (%eax),%eax
  10400c:	83 f8 01             	cmp    $0x1,%eax
  10400f:	0f 85 0a 01 00 00    	jne    10411f <page_init+0x3d4>
            if (begin < freemem) {
  104015:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104018:	ba 00 00 00 00       	mov    $0x0,%edx
  10401d:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104020:	72 17                	jb     104039 <page_init+0x2ee>
  104022:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104025:	77 05                	ja     10402c <page_init+0x2e1>
  104027:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10402a:	76 0d                	jbe    104039 <page_init+0x2ee>
                begin = freemem;
  10402c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10402f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104032:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  104039:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10403d:	72 1d                	jb     10405c <page_init+0x311>
  10403f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104043:	77 09                	ja     10404e <page_init+0x303>
  104045:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  10404c:	76 0e                	jbe    10405c <page_init+0x311>
                end = KMEMSIZE;
  10404e:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  104055:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  10405c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10405f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104062:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104065:	0f 87 b4 00 00 00    	ja     10411f <page_init+0x3d4>
  10406b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10406e:	72 09                	jb     104079 <page_init+0x32e>
  104070:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104073:	0f 83 a6 00 00 00    	jae    10411f <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  104079:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  104080:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104083:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104086:	01 d0                	add    %edx,%eax
  104088:	83 e8 01             	sub    $0x1,%eax
  10408b:	89 45 98             	mov    %eax,-0x68(%ebp)
  10408e:	8b 45 98             	mov    -0x68(%ebp),%eax
  104091:	ba 00 00 00 00       	mov    $0x0,%edx
  104096:	f7 75 9c             	divl   -0x64(%ebp)
  104099:	89 d0                	mov    %edx,%eax
  10409b:	8b 55 98             	mov    -0x68(%ebp),%edx
  10409e:	29 c2                	sub    %eax,%edx
  1040a0:	89 d0                	mov    %edx,%eax
  1040a2:	ba 00 00 00 00       	mov    $0x0,%edx
  1040a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1040aa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1040ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1040b0:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1040b3:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1040b6:	ba 00 00 00 00       	mov    $0x0,%edx
  1040bb:	89 c7                	mov    %eax,%edi
  1040bd:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  1040c3:	89 7d 80             	mov    %edi,-0x80(%ebp)
  1040c6:	89 d0                	mov    %edx,%eax
  1040c8:	83 e0 00             	and    $0x0,%eax
  1040cb:	89 45 84             	mov    %eax,-0x7c(%ebp)
  1040ce:	8b 45 80             	mov    -0x80(%ebp),%eax
  1040d1:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1040d4:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1040d7:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  1040da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040dd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040e0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040e3:	77 3a                	ja     10411f <page_init+0x3d4>
  1040e5:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040e8:	72 05                	jb     1040ef <page_init+0x3a4>
  1040ea:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1040ed:	73 30                	jae    10411f <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1040ef:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1040f2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  1040f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1040f8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1040fb:	29 c8                	sub    %ecx,%eax
  1040fd:	19 da                	sbb    %ebx,%edx
  1040ff:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104103:	c1 ea 0c             	shr    $0xc,%edx
  104106:	89 c3                	mov    %eax,%ebx
  104108:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10410b:	89 04 24             	mov    %eax,(%esp)
  10410e:	e8 bd f8 ff ff       	call   1039d0 <pa2page>
  104113:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104117:	89 04 24             	mov    %eax,(%esp)
  10411a:	e8 78 fb ff ff       	call   103c97 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  10411f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104123:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104126:	8b 00                	mov    (%eax),%eax
  104128:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10412b:	0f 8f 7e fe ff ff    	jg     103faf <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  104131:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104137:	5b                   	pop    %ebx
  104138:	5e                   	pop    %esi
  104139:	5f                   	pop    %edi
  10413a:	5d                   	pop    %ebp
  10413b:	c3                   	ret    

0010413c <enable_paging>:

static void
enable_paging(void) {
  10413c:	55                   	push   %ebp
  10413d:	89 e5                	mov    %esp,%ebp
  10413f:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  104142:	a1 c0 89 11 00       	mov    0x1189c0,%eax
  104147:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  10414a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10414d:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  104150:	0f 20 c0             	mov    %cr0,%eax
  104153:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  104156:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  104159:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  10415c:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  104163:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  104167:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10416a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  10416d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104170:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  104173:	c9                   	leave  
  104174:	c3                   	ret    

00104175 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  104175:	55                   	push   %ebp
  104176:	89 e5                	mov    %esp,%ebp
  104178:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10417b:	8b 45 14             	mov    0x14(%ebp),%eax
  10417e:	8b 55 0c             	mov    0xc(%ebp),%edx
  104181:	31 d0                	xor    %edx,%eax
  104183:	25 ff 0f 00 00       	and    $0xfff,%eax
  104188:	85 c0                	test   %eax,%eax
  10418a:	74 24                	je     1041b0 <boot_map_segment+0x3b>
  10418c:	c7 44 24 0c 82 6a 10 	movl   $0x106a82,0xc(%esp)
  104193:	00 
  104194:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  10419b:	00 
  10419c:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  1041a3:	00 
  1041a4:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  1041ab:	e8 6c ca ff ff       	call   100c1c <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1041b0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1041b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041ba:	25 ff 0f 00 00       	and    $0xfff,%eax
  1041bf:	89 c2                	mov    %eax,%edx
  1041c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1041c4:	01 c2                	add    %eax,%edx
  1041c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041c9:	01 d0                	add    %edx,%eax
  1041cb:	83 e8 01             	sub    $0x1,%eax
  1041ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1041d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1041d4:	ba 00 00 00 00       	mov    $0x0,%edx
  1041d9:	f7 75 f0             	divl   -0x10(%ebp)
  1041dc:	89 d0                	mov    %edx,%eax
  1041de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1041e1:	29 c2                	sub    %eax,%edx
  1041e3:	89 d0                	mov    %edx,%eax
  1041e5:	c1 e8 0c             	shr    $0xc,%eax
  1041e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1041eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1041f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1041f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1041f9:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1041fc:	8b 45 14             	mov    0x14(%ebp),%eax
  1041ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104202:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104205:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10420a:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10420d:	eb 6b                	jmp    10427a <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10420f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104216:	00 
  104217:	8b 45 0c             	mov    0xc(%ebp),%eax
  10421a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10421e:	8b 45 08             	mov    0x8(%ebp),%eax
  104221:	89 04 24             	mov    %eax,(%esp)
  104224:	e8 cc 01 00 00       	call   1043f5 <get_pte>
  104229:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10422c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104230:	75 24                	jne    104256 <boot_map_segment+0xe1>
  104232:	c7 44 24 0c ae 6a 10 	movl   $0x106aae,0xc(%esp)
  104239:	00 
  10423a:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104241:	00 
  104242:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  104249:	00 
  10424a:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104251:	e8 c6 c9 ff ff       	call   100c1c <__panic>
        *ptep = pa | PTE_P | perm;
  104256:	8b 45 18             	mov    0x18(%ebp),%eax
  104259:	8b 55 14             	mov    0x14(%ebp),%edx
  10425c:	09 d0                	or     %edx,%eax
  10425e:	83 c8 01             	or     $0x1,%eax
  104261:	89 c2                	mov    %eax,%edx
  104263:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104266:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104268:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10426c:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  104273:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  10427a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10427e:	75 8f                	jne    10420f <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  104280:	c9                   	leave  
  104281:	c3                   	ret    

00104282 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  104282:	55                   	push   %ebp
  104283:	89 e5                	mov    %esp,%ebp
  104285:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  104288:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10428f:	e8 22 fa ff ff       	call   103cb6 <alloc_pages>
  104294:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  104297:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10429b:	75 1c                	jne    1042b9 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  10429d:	c7 44 24 08 bb 6a 10 	movl   $0x106abb,0x8(%esp)
  1042a4:	00 
  1042a5:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1042ac:	00 
  1042ad:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  1042b4:	e8 63 c9 ff ff       	call   100c1c <__panic>
    }
    return page2kva(p);
  1042b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042bc:	89 04 24             	mov    %eax,(%esp)
  1042bf:	e8 5b f7 ff ff       	call   103a1f <page2kva>
}
  1042c4:	c9                   	leave  
  1042c5:	c3                   	ret    

001042c6 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1042c6:	55                   	push   %ebp
  1042c7:	89 e5                	mov    %esp,%ebp
  1042c9:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1042cc:	e8 93 f9 ff ff       	call   103c64 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1042d1:	e8 75 fa ff ff       	call   103d4b <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1042d6:	e8 72 04 00 00       	call   10474d <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1042db:	e8 a2 ff ff ff       	call   104282 <boot_alloc_page>
  1042e0:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  1042e5:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1042ea:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1042f1:	00 
  1042f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1042f9:	00 
  1042fa:	89 04 24             	mov    %eax,(%esp)
  1042fd:	e8 b4 1a 00 00       	call   105db6 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  104302:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104307:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10430a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104311:	77 23                	ja     104336 <pmm_init+0x70>
  104313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104316:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10431a:	c7 44 24 08 50 6a 10 	movl   $0x106a50,0x8(%esp)
  104321:	00 
  104322:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  104329:	00 
  10432a:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104331:	e8 e6 c8 ff ff       	call   100c1c <__panic>
  104336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104339:	05 00 00 00 40       	add    $0x40000000,%eax
  10433e:	a3 c0 89 11 00       	mov    %eax,0x1189c0

    check_pgdir();
  104343:	e8 23 04 00 00       	call   10476b <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104348:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10434d:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  104353:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104358:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10435b:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104362:	77 23                	ja     104387 <pmm_init+0xc1>
  104364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104367:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10436b:	c7 44 24 08 50 6a 10 	movl   $0x106a50,0x8(%esp)
  104372:	00 
  104373:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  10437a:	00 
  10437b:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104382:	e8 95 c8 ff ff       	call   100c1c <__panic>
  104387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10438a:	05 00 00 00 40       	add    $0x40000000,%eax
  10438f:	83 c8 03             	or     $0x3,%eax
  104392:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  104394:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104399:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1043a0:	00 
  1043a1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1043a8:	00 
  1043a9:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1043b0:	38 
  1043b1:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1043b8:	c0 
  1043b9:	89 04 24             	mov    %eax,(%esp)
  1043bc:	e8 b4 fd ff ff       	call   104175 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  1043c1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043c6:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  1043cc:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  1043d2:	89 10                	mov    %edx,(%eax)

    enable_paging();
  1043d4:	e8 63 fd ff ff       	call   10413c <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1043d9:	e8 97 f7 ff ff       	call   103b75 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  1043de:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1043e9:	e8 18 0a 00 00       	call   104e06 <check_boot_pgdir>

    print_pgdir();
  1043ee:	e8 a5 0e 00 00       	call   105298 <print_pgdir>

}
  1043f3:	c9                   	leave  
  1043f4:	c3                   	ret    

001043f5 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1043f5:	55                   	push   %ebp
  1043f6:	89 e5                	mov    %esp,%ebp
  1043f8:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
  1043fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043fe:	c1 e8 16             	shr    $0x16,%eax
  104401:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104408:	8b 45 08             	mov    0x8(%ebp),%eax
  10440b:	01 d0                	add    %edx,%eax
  10440d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
  104410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104413:	8b 00                	mov    (%eax),%eax
  104415:	83 e0 01             	and    $0x1,%eax
  104418:	85 c0                	test   %eax,%eax
  10441a:	0f 85 b9 00 00 00    	jne    1044d9 <get_pte+0xe4>
        if (!create)    return NULL;
  104420:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104424:	75 0a                	jne    104430 <get_pte+0x3b>
  104426:	b8 00 00 00 00       	mov    $0x0,%eax
  10442b:	e9 05 01 00 00       	jmp    104535 <get_pte+0x140>
        struct Page* page = alloc_page();
  104430:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104437:	e8 7a f8 ff ff       	call   103cb6 <alloc_pages>
  10443c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (page == NULL)    return NULL;
  10443f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104443:	75 0a                	jne    10444f <get_pte+0x5a>
  104445:	b8 00 00 00 00       	mov    $0x0,%eax
  10444a:	e9 e6 00 00 00       	jmp    104535 <get_pte+0x140>
        set_page_ref(page, 1);
  10444f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104456:	00 
  104457:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10445a:	89 04 24             	mov    %eax,(%esp)
  10445d:	e8 59 f6 ff ff       	call   103abb <set_page_ref>
        uintptr_t pa = page2pa(page);
  104462:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104465:	89 04 24             	mov    %eax,(%esp)
  104468:	e8 4d f5 ff ff       	call   1039ba <page2pa>
  10446d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
  104470:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104473:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104476:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104479:	c1 e8 0c             	shr    $0xc,%eax
  10447c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10447f:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104484:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  104487:	72 23                	jb     1044ac <get_pte+0xb7>
  104489:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10448c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104490:	c7 44 24 08 ac 69 10 	movl   $0x1069ac,0x8(%esp)
  104497:	00 
  104498:	c7 44 24 04 86 01 00 	movl   $0x186,0x4(%esp)
  10449f:	00 
  1044a0:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  1044a7:	e8 70 c7 ff ff       	call   100c1c <__panic>
  1044ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044af:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1044b4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1044bb:	00 
  1044bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1044c3:	00 
  1044c4:	89 04 24             	mov    %eax,(%esp)
  1044c7:	e8 ea 18 00 00       	call   105db6 <memset>
        *pdep = pa | PTE_P | PTE_W | PTE_U;
  1044cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1044cf:	83 c8 07             	or     $0x7,%eax
  1044d2:	89 c2                	mov    %eax,%edx
  1044d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044d7:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t*)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  1044d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044dc:	8b 00                	mov    (%eax),%eax
  1044de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1044e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1044e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044e9:	c1 e8 0c             	shr    $0xc,%eax
  1044ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1044ef:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1044f4:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1044f7:	72 23                	jb     10451c <get_pte+0x127>
  1044f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044fc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104500:	c7 44 24 08 ac 69 10 	movl   $0x1069ac,0x8(%esp)
  104507:	00 
  104508:	c7 44 24 04 89 01 00 	movl   $0x189,0x4(%esp)
  10450f:	00 
  104510:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104517:	e8 00 c7 ff ff       	call   100c1c <__panic>
  10451c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10451f:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104524:	8b 55 0c             	mov    0xc(%ebp),%edx
  104527:	c1 ea 0c             	shr    $0xc,%edx
  10452a:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  104530:	c1 e2 02             	shl    $0x2,%edx
  104533:	01 d0                	add    %edx,%eax
}
  104535:	c9                   	leave  
  104536:	c3                   	ret    

00104537 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104537:	55                   	push   %ebp
  104538:	89 e5                	mov    %esp,%ebp
  10453a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10453d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104544:	00 
  104545:	8b 45 0c             	mov    0xc(%ebp),%eax
  104548:	89 44 24 04          	mov    %eax,0x4(%esp)
  10454c:	8b 45 08             	mov    0x8(%ebp),%eax
  10454f:	89 04 24             	mov    %eax,(%esp)
  104552:	e8 9e fe ff ff       	call   1043f5 <get_pte>
  104557:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10455a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10455e:	74 08                	je     104568 <get_page+0x31>
        *ptep_store = ptep;
  104560:	8b 45 10             	mov    0x10(%ebp),%eax
  104563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104566:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104568:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10456c:	74 1b                	je     104589 <get_page+0x52>
  10456e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104571:	8b 00                	mov    (%eax),%eax
  104573:	83 e0 01             	and    $0x1,%eax
  104576:	85 c0                	test   %eax,%eax
  104578:	74 0f                	je     104589 <get_page+0x52>
        return pa2page(*ptep);
  10457a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10457d:	8b 00                	mov    (%eax),%eax
  10457f:	89 04 24             	mov    %eax,(%esp)
  104582:	e8 49 f4 ff ff       	call   1039d0 <pa2page>
  104587:	eb 05                	jmp    10458e <get_page+0x57>
    }
    return NULL;
  104589:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10458e:	c9                   	leave  
  10458f:	c3                   	ret    

00104590 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  104590:	55                   	push   %ebp
  104591:	89 e5                	mov    %esp,%ebp
  104593:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (!(*ptep & PTE_P))   return;
  104596:	8b 45 10             	mov    0x10(%ebp),%eax
  104599:	8b 00                	mov    (%eax),%eax
  10459b:	83 e0 01             	and    $0x1,%eax
  10459e:	85 c0                	test   %eax,%eax
  1045a0:	75 02                	jne    1045a4 <page_remove_pte+0x14>
  1045a2:	eb 4d                	jmp    1045f1 <page_remove_pte+0x61>
    struct Page* page = pte2page(*ptep);
  1045a4:	8b 45 10             	mov    0x10(%ebp),%eax
  1045a7:	8b 00                	mov    (%eax),%eax
  1045a9:	89 04 24             	mov    %eax,(%esp)
  1045ac:	e8 c2 f4 ff ff       	call   103a73 <pte2page>
  1045b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page_ref_dec(page) == 0)
  1045b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045b7:	89 04 24             	mov    %eax,(%esp)
  1045ba:	e8 20 f5 ff ff       	call   103adf <page_ref_dec>
  1045bf:	85 c0                	test   %eax,%eax
  1045c1:	75 13                	jne    1045d6 <page_remove_pte+0x46>
        free_page(page);
  1045c3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1045ca:	00 
  1045cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045ce:	89 04 24             	mov    %eax,(%esp)
  1045d1:	e8 18 f7 ff ff       	call   103cee <free_pages>
    *ptep = 0;
  1045d6:	8b 45 10             	mov    0x10(%ebp),%eax
  1045d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    tlb_invalidate(pgdir, la);
  1045df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1045e9:	89 04 24             	mov    %eax,(%esp)
  1045ec:	e8 ff 00 00 00       	call   1046f0 <tlb_invalidate>
}
  1045f1:	c9                   	leave  
  1045f2:	c3                   	ret    

001045f3 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1045f3:	55                   	push   %ebp
  1045f4:	89 e5                	mov    %esp,%ebp
  1045f6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1045f9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104600:	00 
  104601:	8b 45 0c             	mov    0xc(%ebp),%eax
  104604:	89 44 24 04          	mov    %eax,0x4(%esp)
  104608:	8b 45 08             	mov    0x8(%ebp),%eax
  10460b:	89 04 24             	mov    %eax,(%esp)
  10460e:	e8 e2 fd ff ff       	call   1043f5 <get_pte>
  104613:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  104616:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10461a:	74 19                	je     104635 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10461c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10461f:	89 44 24 08          	mov    %eax,0x8(%esp)
  104623:	8b 45 0c             	mov    0xc(%ebp),%eax
  104626:	89 44 24 04          	mov    %eax,0x4(%esp)
  10462a:	8b 45 08             	mov    0x8(%ebp),%eax
  10462d:	89 04 24             	mov    %eax,(%esp)
  104630:	e8 5b ff ff ff       	call   104590 <page_remove_pte>
    }
}
  104635:	c9                   	leave  
  104636:	c3                   	ret    

00104637 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  104637:	55                   	push   %ebp
  104638:	89 e5                	mov    %esp,%ebp
  10463a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  10463d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104644:	00 
  104645:	8b 45 10             	mov    0x10(%ebp),%eax
  104648:	89 44 24 04          	mov    %eax,0x4(%esp)
  10464c:	8b 45 08             	mov    0x8(%ebp),%eax
  10464f:	89 04 24             	mov    %eax,(%esp)
  104652:	e8 9e fd ff ff       	call   1043f5 <get_pte>
  104657:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10465a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10465e:	75 0a                	jne    10466a <page_insert+0x33>
        return -E_NO_MEM;
  104660:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  104665:	e9 84 00 00 00       	jmp    1046ee <page_insert+0xb7>
    }
    page_ref_inc(page);
  10466a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10466d:	89 04 24             	mov    %eax,(%esp)
  104670:	e8 53 f4 ff ff       	call   103ac8 <page_ref_inc>
    if (*ptep & PTE_P) {
  104675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104678:	8b 00                	mov    (%eax),%eax
  10467a:	83 e0 01             	and    $0x1,%eax
  10467d:	85 c0                	test   %eax,%eax
  10467f:	74 3e                	je     1046bf <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  104681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104684:	8b 00                	mov    (%eax),%eax
  104686:	89 04 24             	mov    %eax,(%esp)
  104689:	e8 e5 f3 ff ff       	call   103a73 <pte2page>
  10468e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  104691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104694:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104697:	75 0d                	jne    1046a6 <page_insert+0x6f>
            page_ref_dec(page);
  104699:	8b 45 0c             	mov    0xc(%ebp),%eax
  10469c:	89 04 24             	mov    %eax,(%esp)
  10469f:	e8 3b f4 ff ff       	call   103adf <page_ref_dec>
  1046a4:	eb 19                	jmp    1046bf <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1046a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046a9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1046ad:	8b 45 10             	mov    0x10(%ebp),%eax
  1046b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1046b7:	89 04 24             	mov    %eax,(%esp)
  1046ba:	e8 d1 fe ff ff       	call   104590 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1046bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046c2:	89 04 24             	mov    %eax,(%esp)
  1046c5:	e8 f0 f2 ff ff       	call   1039ba <page2pa>
  1046ca:	0b 45 14             	or     0x14(%ebp),%eax
  1046cd:	83 c8 01             	or     $0x1,%eax
  1046d0:	89 c2                	mov    %eax,%edx
  1046d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046d5:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1046d7:	8b 45 10             	mov    0x10(%ebp),%eax
  1046da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046de:	8b 45 08             	mov    0x8(%ebp),%eax
  1046e1:	89 04 24             	mov    %eax,(%esp)
  1046e4:	e8 07 00 00 00       	call   1046f0 <tlb_invalidate>
    return 0;
  1046e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1046ee:	c9                   	leave  
  1046ef:	c3                   	ret    

001046f0 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1046f0:	55                   	push   %ebp
  1046f1:	89 e5                	mov    %esp,%ebp
  1046f3:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1046f6:	0f 20 d8             	mov    %cr3,%eax
  1046f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1046fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  1046ff:	89 c2                	mov    %eax,%edx
  104701:	8b 45 08             	mov    0x8(%ebp),%eax
  104704:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104707:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10470e:	77 23                	ja     104733 <tlb_invalidate+0x43>
  104710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104713:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104717:	c7 44 24 08 50 6a 10 	movl   $0x106a50,0x8(%esp)
  10471e:	00 
  10471f:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  104726:	00 
  104727:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  10472e:	e8 e9 c4 ff ff       	call   100c1c <__panic>
  104733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104736:	05 00 00 00 40       	add    $0x40000000,%eax
  10473b:	39 c2                	cmp    %eax,%edx
  10473d:	75 0c                	jne    10474b <tlb_invalidate+0x5b>
        invlpg((void *)la);
  10473f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104742:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  104745:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104748:	0f 01 38             	invlpg (%eax)
    }
}
  10474b:	c9                   	leave  
  10474c:	c3                   	ret    

0010474d <check_alloc_page>:

static void
check_alloc_page(void) {
  10474d:	55                   	push   %ebp
  10474e:	89 e5                	mov    %esp,%ebp
  104750:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  104753:	a1 bc 89 11 00       	mov    0x1189bc,%eax
  104758:	8b 40 18             	mov    0x18(%eax),%eax
  10475b:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  10475d:	c7 04 24 d4 6a 10 00 	movl   $0x106ad4,(%esp)
  104764:	e8 e3 bb ff ff       	call   10034c <cprintf>
}
  104769:	c9                   	leave  
  10476a:	c3                   	ret    

0010476b <check_pgdir>:

static void
check_pgdir(void) {
  10476b:	55                   	push   %ebp
  10476c:	89 e5                	mov    %esp,%ebp
  10476e:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  104771:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104776:	3d 00 80 03 00       	cmp    $0x38000,%eax
  10477b:	76 24                	jbe    1047a1 <check_pgdir+0x36>
  10477d:	c7 44 24 0c f3 6a 10 	movl   $0x106af3,0xc(%esp)
  104784:	00 
  104785:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  10478c:	00 
  10478d:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  104794:	00 
  104795:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  10479c:	e8 7b c4 ff ff       	call   100c1c <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1047a1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047a6:	85 c0                	test   %eax,%eax
  1047a8:	74 0e                	je     1047b8 <check_pgdir+0x4d>
  1047aa:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047af:	25 ff 0f 00 00       	and    $0xfff,%eax
  1047b4:	85 c0                	test   %eax,%eax
  1047b6:	74 24                	je     1047dc <check_pgdir+0x71>
  1047b8:	c7 44 24 0c 10 6b 10 	movl   $0x106b10,0xc(%esp)
  1047bf:	00 
  1047c0:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  1047c7:	00 
  1047c8:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  1047cf:	00 
  1047d0:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  1047d7:	e8 40 c4 ff ff       	call   100c1c <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1047dc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047e1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1047e8:	00 
  1047e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1047f0:	00 
  1047f1:	89 04 24             	mov    %eax,(%esp)
  1047f4:	e8 3e fd ff ff       	call   104537 <get_page>
  1047f9:	85 c0                	test   %eax,%eax
  1047fb:	74 24                	je     104821 <check_pgdir+0xb6>
  1047fd:	c7 44 24 0c 48 6b 10 	movl   $0x106b48,0xc(%esp)
  104804:	00 
  104805:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  10480c:	00 
  10480d:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  104814:	00 
  104815:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  10481c:	e8 fb c3 ff ff       	call   100c1c <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104821:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104828:	e8 89 f4 ff ff       	call   103cb6 <alloc_pages>
  10482d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104830:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104835:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10483c:	00 
  10483d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104844:	00 
  104845:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104848:	89 54 24 04          	mov    %edx,0x4(%esp)
  10484c:	89 04 24             	mov    %eax,(%esp)
  10484f:	e8 e3 fd ff ff       	call   104637 <page_insert>
  104854:	85 c0                	test   %eax,%eax
  104856:	74 24                	je     10487c <check_pgdir+0x111>
  104858:	c7 44 24 0c 70 6b 10 	movl   $0x106b70,0xc(%esp)
  10485f:	00 
  104860:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104867:	00 
  104868:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  10486f:	00 
  104870:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104877:	e8 a0 c3 ff ff       	call   100c1c <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  10487c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104881:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104888:	00 
  104889:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104890:	00 
  104891:	89 04 24             	mov    %eax,(%esp)
  104894:	e8 5c fb ff ff       	call   1043f5 <get_pte>
  104899:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10489c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1048a0:	75 24                	jne    1048c6 <check_pgdir+0x15b>
  1048a2:	c7 44 24 0c 9c 6b 10 	movl   $0x106b9c,0xc(%esp)
  1048a9:	00 
  1048aa:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  1048b1:	00 
  1048b2:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  1048b9:	00 
  1048ba:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  1048c1:	e8 56 c3 ff ff       	call   100c1c <__panic>
    assert(pa2page(*ptep) == p1);
  1048c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048c9:	8b 00                	mov    (%eax),%eax
  1048cb:	89 04 24             	mov    %eax,(%esp)
  1048ce:	e8 fd f0 ff ff       	call   1039d0 <pa2page>
  1048d3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1048d6:	74 24                	je     1048fc <check_pgdir+0x191>
  1048d8:	c7 44 24 0c c9 6b 10 	movl   $0x106bc9,0xc(%esp)
  1048df:	00 
  1048e0:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  1048e7:	00 
  1048e8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  1048ef:	00 
  1048f0:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  1048f7:	e8 20 c3 ff ff       	call   100c1c <__panic>
    assert(page_ref(p1) == 1);
  1048fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048ff:	89 04 24             	mov    %eax,(%esp)
  104902:	e8 aa f1 ff ff       	call   103ab1 <page_ref>
  104907:	83 f8 01             	cmp    $0x1,%eax
  10490a:	74 24                	je     104930 <check_pgdir+0x1c5>
  10490c:	c7 44 24 0c de 6b 10 	movl   $0x106bde,0xc(%esp)
  104913:	00 
  104914:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  10491b:	00 
  10491c:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  104923:	00 
  104924:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  10492b:	e8 ec c2 ff ff       	call   100c1c <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104930:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104935:	8b 00                	mov    (%eax),%eax
  104937:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10493c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10493f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104942:	c1 e8 0c             	shr    $0xc,%eax
  104945:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104948:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10494d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104950:	72 23                	jb     104975 <check_pgdir+0x20a>
  104952:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104955:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104959:	c7 44 24 08 ac 69 10 	movl   $0x1069ac,0x8(%esp)
  104960:	00 
  104961:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104968:	00 
  104969:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104970:	e8 a7 c2 ff ff       	call   100c1c <__panic>
  104975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104978:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10497d:	83 c0 04             	add    $0x4,%eax
  104980:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104983:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104988:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10498f:	00 
  104990:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104997:	00 
  104998:	89 04 24             	mov    %eax,(%esp)
  10499b:	e8 55 fa ff ff       	call   1043f5 <get_pte>
  1049a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1049a3:	74 24                	je     1049c9 <check_pgdir+0x25e>
  1049a5:	c7 44 24 0c f0 6b 10 	movl   $0x106bf0,0xc(%esp)
  1049ac:	00 
  1049ad:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  1049b4:	00 
  1049b5:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  1049bc:	00 
  1049bd:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  1049c4:	e8 53 c2 ff ff       	call   100c1c <__panic>

    p2 = alloc_page();
  1049c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1049d0:	e8 e1 f2 ff ff       	call   103cb6 <alloc_pages>
  1049d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  1049d8:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1049dd:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  1049e4:	00 
  1049e5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1049ec:	00 
  1049ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1049f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1049f4:	89 04 24             	mov    %eax,(%esp)
  1049f7:	e8 3b fc ff ff       	call   104637 <page_insert>
  1049fc:	85 c0                	test   %eax,%eax
  1049fe:	74 24                	je     104a24 <check_pgdir+0x2b9>
  104a00:	c7 44 24 0c 18 6c 10 	movl   $0x106c18,0xc(%esp)
  104a07:	00 
  104a08:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104a0f:	00 
  104a10:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104a17:	00 
  104a18:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104a1f:	e8 f8 c1 ff ff       	call   100c1c <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104a24:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a29:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a30:	00 
  104a31:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a38:	00 
  104a39:	89 04 24             	mov    %eax,(%esp)
  104a3c:	e8 b4 f9 ff ff       	call   1043f5 <get_pte>
  104a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a48:	75 24                	jne    104a6e <check_pgdir+0x303>
  104a4a:	c7 44 24 0c 50 6c 10 	movl   $0x106c50,0xc(%esp)
  104a51:	00 
  104a52:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104a59:	00 
  104a5a:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  104a61:	00 
  104a62:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104a69:	e8 ae c1 ff ff       	call   100c1c <__panic>
    assert(*ptep & PTE_U);
  104a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a71:	8b 00                	mov    (%eax),%eax
  104a73:	83 e0 04             	and    $0x4,%eax
  104a76:	85 c0                	test   %eax,%eax
  104a78:	75 24                	jne    104a9e <check_pgdir+0x333>
  104a7a:	c7 44 24 0c 80 6c 10 	movl   $0x106c80,0xc(%esp)
  104a81:	00 
  104a82:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104a89:	00 
  104a8a:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104a91:	00 
  104a92:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104a99:	e8 7e c1 ff ff       	call   100c1c <__panic>
    assert(*ptep & PTE_W);
  104a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104aa1:	8b 00                	mov    (%eax),%eax
  104aa3:	83 e0 02             	and    $0x2,%eax
  104aa6:	85 c0                	test   %eax,%eax
  104aa8:	75 24                	jne    104ace <check_pgdir+0x363>
  104aaa:	c7 44 24 0c 8e 6c 10 	movl   $0x106c8e,0xc(%esp)
  104ab1:	00 
  104ab2:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104ab9:	00 
  104aba:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104ac1:	00 
  104ac2:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104ac9:	e8 4e c1 ff ff       	call   100c1c <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104ace:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ad3:	8b 00                	mov    (%eax),%eax
  104ad5:	83 e0 04             	and    $0x4,%eax
  104ad8:	85 c0                	test   %eax,%eax
  104ada:	75 24                	jne    104b00 <check_pgdir+0x395>
  104adc:	c7 44 24 0c 9c 6c 10 	movl   $0x106c9c,0xc(%esp)
  104ae3:	00 
  104ae4:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104aeb:	00 
  104aec:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104af3:	00 
  104af4:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104afb:	e8 1c c1 ff ff       	call   100c1c <__panic>
    assert(page_ref(p2) == 1);
  104b00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b03:	89 04 24             	mov    %eax,(%esp)
  104b06:	e8 a6 ef ff ff       	call   103ab1 <page_ref>
  104b0b:	83 f8 01             	cmp    $0x1,%eax
  104b0e:	74 24                	je     104b34 <check_pgdir+0x3c9>
  104b10:	c7 44 24 0c b2 6c 10 	movl   $0x106cb2,0xc(%esp)
  104b17:	00 
  104b18:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104b1f:	00 
  104b20:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104b27:	00 
  104b28:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104b2f:	e8 e8 c0 ff ff       	call   100c1c <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104b34:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b39:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104b40:	00 
  104b41:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104b48:	00 
  104b49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104b4c:	89 54 24 04          	mov    %edx,0x4(%esp)
  104b50:	89 04 24             	mov    %eax,(%esp)
  104b53:	e8 df fa ff ff       	call   104637 <page_insert>
  104b58:	85 c0                	test   %eax,%eax
  104b5a:	74 24                	je     104b80 <check_pgdir+0x415>
  104b5c:	c7 44 24 0c c4 6c 10 	movl   $0x106cc4,0xc(%esp)
  104b63:	00 
  104b64:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104b6b:	00 
  104b6c:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104b73:	00 
  104b74:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104b7b:	e8 9c c0 ff ff       	call   100c1c <__panic>
    assert(page_ref(p1) == 2);
  104b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b83:	89 04 24             	mov    %eax,(%esp)
  104b86:	e8 26 ef ff ff       	call   103ab1 <page_ref>
  104b8b:	83 f8 02             	cmp    $0x2,%eax
  104b8e:	74 24                	je     104bb4 <check_pgdir+0x449>
  104b90:	c7 44 24 0c f0 6c 10 	movl   $0x106cf0,0xc(%esp)
  104b97:	00 
  104b98:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104b9f:	00 
  104ba0:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104ba7:	00 
  104ba8:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104baf:	e8 68 c0 ff ff       	call   100c1c <__panic>
    assert(page_ref(p2) == 0);
  104bb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bb7:	89 04 24             	mov    %eax,(%esp)
  104bba:	e8 f2 ee ff ff       	call   103ab1 <page_ref>
  104bbf:	85 c0                	test   %eax,%eax
  104bc1:	74 24                	je     104be7 <check_pgdir+0x47c>
  104bc3:	c7 44 24 0c 02 6d 10 	movl   $0x106d02,0xc(%esp)
  104bca:	00 
  104bcb:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104bd2:	00 
  104bd3:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104bda:	00 
  104bdb:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104be2:	e8 35 c0 ff ff       	call   100c1c <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104be7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104bec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104bf3:	00 
  104bf4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104bfb:	00 
  104bfc:	89 04 24             	mov    %eax,(%esp)
  104bff:	e8 f1 f7 ff ff       	call   1043f5 <get_pte>
  104c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c0b:	75 24                	jne    104c31 <check_pgdir+0x4c6>
  104c0d:	c7 44 24 0c 50 6c 10 	movl   $0x106c50,0xc(%esp)
  104c14:	00 
  104c15:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104c1c:	00 
  104c1d:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104c24:	00 
  104c25:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104c2c:	e8 eb bf ff ff       	call   100c1c <__panic>
    assert(pa2page(*ptep) == p1);
  104c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c34:	8b 00                	mov    (%eax),%eax
  104c36:	89 04 24             	mov    %eax,(%esp)
  104c39:	e8 92 ed ff ff       	call   1039d0 <pa2page>
  104c3e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104c41:	74 24                	je     104c67 <check_pgdir+0x4fc>
  104c43:	c7 44 24 0c c9 6b 10 	movl   $0x106bc9,0xc(%esp)
  104c4a:	00 
  104c4b:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104c52:	00 
  104c53:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104c5a:	00 
  104c5b:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104c62:	e8 b5 bf ff ff       	call   100c1c <__panic>
    assert((*ptep & PTE_U) == 0);
  104c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c6a:	8b 00                	mov    (%eax),%eax
  104c6c:	83 e0 04             	and    $0x4,%eax
  104c6f:	85 c0                	test   %eax,%eax
  104c71:	74 24                	je     104c97 <check_pgdir+0x52c>
  104c73:	c7 44 24 0c 14 6d 10 	movl   $0x106d14,0xc(%esp)
  104c7a:	00 
  104c7b:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104c82:	00 
  104c83:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104c8a:	00 
  104c8b:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104c92:	e8 85 bf ff ff       	call   100c1c <__panic>

    page_remove(boot_pgdir, 0x0);
  104c97:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c9c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104ca3:	00 
  104ca4:	89 04 24             	mov    %eax,(%esp)
  104ca7:	e8 47 f9 ff ff       	call   1045f3 <page_remove>
    assert(page_ref(p1) == 1);
  104cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104caf:	89 04 24             	mov    %eax,(%esp)
  104cb2:	e8 fa ed ff ff       	call   103ab1 <page_ref>
  104cb7:	83 f8 01             	cmp    $0x1,%eax
  104cba:	74 24                	je     104ce0 <check_pgdir+0x575>
  104cbc:	c7 44 24 0c de 6b 10 	movl   $0x106bde,0xc(%esp)
  104cc3:	00 
  104cc4:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104ccb:	00 
  104ccc:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  104cd3:	00 
  104cd4:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104cdb:	e8 3c bf ff ff       	call   100c1c <__panic>
    assert(page_ref(p2) == 0);
  104ce0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ce3:	89 04 24             	mov    %eax,(%esp)
  104ce6:	e8 c6 ed ff ff       	call   103ab1 <page_ref>
  104ceb:	85 c0                	test   %eax,%eax
  104ced:	74 24                	je     104d13 <check_pgdir+0x5a8>
  104cef:	c7 44 24 0c 02 6d 10 	movl   $0x106d02,0xc(%esp)
  104cf6:	00 
  104cf7:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104cfe:	00 
  104cff:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104d06:	00 
  104d07:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104d0e:	e8 09 bf ff ff       	call   100c1c <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104d13:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d18:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104d1f:	00 
  104d20:	89 04 24             	mov    %eax,(%esp)
  104d23:	e8 cb f8 ff ff       	call   1045f3 <page_remove>
    assert(page_ref(p1) == 0);
  104d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d2b:	89 04 24             	mov    %eax,(%esp)
  104d2e:	e8 7e ed ff ff       	call   103ab1 <page_ref>
  104d33:	85 c0                	test   %eax,%eax
  104d35:	74 24                	je     104d5b <check_pgdir+0x5f0>
  104d37:	c7 44 24 0c 29 6d 10 	movl   $0x106d29,0xc(%esp)
  104d3e:	00 
  104d3f:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104d46:	00 
  104d47:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  104d4e:	00 
  104d4f:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104d56:	e8 c1 be ff ff       	call   100c1c <__panic>
    assert(page_ref(p2) == 0);
  104d5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d5e:	89 04 24             	mov    %eax,(%esp)
  104d61:	e8 4b ed ff ff       	call   103ab1 <page_ref>
  104d66:	85 c0                	test   %eax,%eax
  104d68:	74 24                	je     104d8e <check_pgdir+0x623>
  104d6a:	c7 44 24 0c 02 6d 10 	movl   $0x106d02,0xc(%esp)
  104d71:	00 
  104d72:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104d79:	00 
  104d7a:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  104d81:	00 
  104d82:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104d89:	e8 8e be ff ff       	call   100c1c <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104d8e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d93:	8b 00                	mov    (%eax),%eax
  104d95:	89 04 24             	mov    %eax,(%esp)
  104d98:	e8 33 ec ff ff       	call   1039d0 <pa2page>
  104d9d:	89 04 24             	mov    %eax,(%esp)
  104da0:	e8 0c ed ff ff       	call   103ab1 <page_ref>
  104da5:	83 f8 01             	cmp    $0x1,%eax
  104da8:	74 24                	je     104dce <check_pgdir+0x663>
  104daa:	c7 44 24 0c 3c 6d 10 	movl   $0x106d3c,0xc(%esp)
  104db1:	00 
  104db2:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104db9:	00 
  104dba:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  104dc1:	00 
  104dc2:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104dc9:	e8 4e be ff ff       	call   100c1c <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104dce:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104dd3:	8b 00                	mov    (%eax),%eax
  104dd5:	89 04 24             	mov    %eax,(%esp)
  104dd8:	e8 f3 eb ff ff       	call   1039d0 <pa2page>
  104ddd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104de4:	00 
  104de5:	89 04 24             	mov    %eax,(%esp)
  104de8:	e8 01 ef ff ff       	call   103cee <free_pages>
    boot_pgdir[0] = 0;
  104ded:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104df2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104df8:	c7 04 24 62 6d 10 00 	movl   $0x106d62,(%esp)
  104dff:	e8 48 b5 ff ff       	call   10034c <cprintf>
}
  104e04:	c9                   	leave  
  104e05:	c3                   	ret    

00104e06 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104e06:	55                   	push   %ebp
  104e07:	89 e5                	mov    %esp,%ebp
  104e09:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104e0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104e13:	e9 ca 00 00 00       	jmp    104ee2 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e21:	c1 e8 0c             	shr    $0xc,%eax
  104e24:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104e27:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104e2c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104e2f:	72 23                	jb     104e54 <check_boot_pgdir+0x4e>
  104e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e34:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104e38:	c7 44 24 08 ac 69 10 	movl   $0x1069ac,0x8(%esp)
  104e3f:	00 
  104e40:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  104e47:	00 
  104e48:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104e4f:	e8 c8 bd ff ff       	call   100c1c <__panic>
  104e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e57:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104e5c:	89 c2                	mov    %eax,%edx
  104e5e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e63:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104e6a:	00 
  104e6b:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e6f:	89 04 24             	mov    %eax,(%esp)
  104e72:	e8 7e f5 ff ff       	call   1043f5 <get_pte>
  104e77:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104e7a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104e7e:	75 24                	jne    104ea4 <check_boot_pgdir+0x9e>
  104e80:	c7 44 24 0c 7c 6d 10 	movl   $0x106d7c,0xc(%esp)
  104e87:	00 
  104e88:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104e8f:	00 
  104e90:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  104e97:	00 
  104e98:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104e9f:	e8 78 bd ff ff       	call   100c1c <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104ea4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104ea7:	8b 00                	mov    (%eax),%eax
  104ea9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104eae:	89 c2                	mov    %eax,%edx
  104eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104eb3:	39 c2                	cmp    %eax,%edx
  104eb5:	74 24                	je     104edb <check_boot_pgdir+0xd5>
  104eb7:	c7 44 24 0c b9 6d 10 	movl   $0x106db9,0xc(%esp)
  104ebe:	00 
  104ebf:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104ec6:	00 
  104ec7:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  104ece:	00 
  104ecf:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104ed6:	e8 41 bd ff ff       	call   100c1c <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104edb:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104ee2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104ee5:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104eea:	39 c2                	cmp    %eax,%edx
  104eec:	0f 82 26 ff ff ff    	jb     104e18 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104ef2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ef7:	05 ac 0f 00 00       	add    $0xfac,%eax
  104efc:	8b 00                	mov    (%eax),%eax
  104efe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f03:	89 c2                	mov    %eax,%edx
  104f05:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104f0d:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104f14:	77 23                	ja     104f39 <check_boot_pgdir+0x133>
  104f16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f19:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104f1d:	c7 44 24 08 50 6a 10 	movl   $0x106a50,0x8(%esp)
  104f24:	00 
  104f25:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  104f2c:	00 
  104f2d:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104f34:	e8 e3 bc ff ff       	call   100c1c <__panic>
  104f39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f3c:	05 00 00 00 40       	add    $0x40000000,%eax
  104f41:	39 c2                	cmp    %eax,%edx
  104f43:	74 24                	je     104f69 <check_boot_pgdir+0x163>
  104f45:	c7 44 24 0c d0 6d 10 	movl   $0x106dd0,0xc(%esp)
  104f4c:	00 
  104f4d:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104f54:	00 
  104f55:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  104f5c:	00 
  104f5d:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104f64:	e8 b3 bc ff ff       	call   100c1c <__panic>

    assert(boot_pgdir[0] == 0);
  104f69:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f6e:	8b 00                	mov    (%eax),%eax
  104f70:	85 c0                	test   %eax,%eax
  104f72:	74 24                	je     104f98 <check_boot_pgdir+0x192>
  104f74:	c7 44 24 0c 04 6e 10 	movl   $0x106e04,0xc(%esp)
  104f7b:	00 
  104f7c:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104f83:	00 
  104f84:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  104f8b:	00 
  104f8c:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104f93:	e8 84 bc ff ff       	call   100c1c <__panic>

    struct Page *p;
    p = alloc_page();
  104f98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f9f:	e8 12 ed ff ff       	call   103cb6 <alloc_pages>
  104fa4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104fa7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104fac:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104fb3:	00 
  104fb4:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104fbb:	00 
  104fbc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104fbf:	89 54 24 04          	mov    %edx,0x4(%esp)
  104fc3:	89 04 24             	mov    %eax,(%esp)
  104fc6:	e8 6c f6 ff ff       	call   104637 <page_insert>
  104fcb:	85 c0                	test   %eax,%eax
  104fcd:	74 24                	je     104ff3 <check_boot_pgdir+0x1ed>
  104fcf:	c7 44 24 0c 18 6e 10 	movl   $0x106e18,0xc(%esp)
  104fd6:	00 
  104fd7:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  104fde:	00 
  104fdf:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
  104fe6:	00 
  104fe7:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  104fee:	e8 29 bc ff ff       	call   100c1c <__panic>
    assert(page_ref(p) == 1);
  104ff3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ff6:	89 04 24             	mov    %eax,(%esp)
  104ff9:	e8 b3 ea ff ff       	call   103ab1 <page_ref>
  104ffe:	83 f8 01             	cmp    $0x1,%eax
  105001:	74 24                	je     105027 <check_boot_pgdir+0x221>
  105003:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  10500a:	00 
  10500b:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  105012:	00 
  105013:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
  10501a:	00 
  10501b:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  105022:	e8 f5 bb ff ff       	call   100c1c <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  105027:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10502c:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105033:	00 
  105034:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  10503b:	00 
  10503c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10503f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105043:	89 04 24             	mov    %eax,(%esp)
  105046:	e8 ec f5 ff ff       	call   104637 <page_insert>
  10504b:	85 c0                	test   %eax,%eax
  10504d:	74 24                	je     105073 <check_boot_pgdir+0x26d>
  10504f:	c7 44 24 0c 58 6e 10 	movl   $0x106e58,0xc(%esp)
  105056:	00 
  105057:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  10505e:	00 
  10505f:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  105066:	00 
  105067:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  10506e:	e8 a9 bb ff ff       	call   100c1c <__panic>
    assert(page_ref(p) == 2);
  105073:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105076:	89 04 24             	mov    %eax,(%esp)
  105079:	e8 33 ea ff ff       	call   103ab1 <page_ref>
  10507e:	83 f8 02             	cmp    $0x2,%eax
  105081:	74 24                	je     1050a7 <check_boot_pgdir+0x2a1>
  105083:	c7 44 24 0c 8f 6e 10 	movl   $0x106e8f,0xc(%esp)
  10508a:	00 
  10508b:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  105092:	00 
  105093:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  10509a:	00 
  10509b:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  1050a2:	e8 75 bb ff ff       	call   100c1c <__panic>

    const char *str = "ucore: Hello world!!";
  1050a7:	c7 45 dc a0 6e 10 00 	movl   $0x106ea0,-0x24(%ebp)
    strcpy((void *)0x100, str);
  1050ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050b5:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1050bc:	e8 1e 0a 00 00       	call   105adf <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1050c1:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1050c8:	00 
  1050c9:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1050d0:	e8 83 0a 00 00       	call   105b58 <strcmp>
  1050d5:	85 c0                	test   %eax,%eax
  1050d7:	74 24                	je     1050fd <check_boot_pgdir+0x2f7>
  1050d9:	c7 44 24 0c b8 6e 10 	movl   $0x106eb8,0xc(%esp)
  1050e0:	00 
  1050e1:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  1050e8:	00 
  1050e9:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
  1050f0:	00 
  1050f1:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  1050f8:	e8 1f bb ff ff       	call   100c1c <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1050fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105100:	89 04 24             	mov    %eax,(%esp)
  105103:	e8 17 e9 ff ff       	call   103a1f <page2kva>
  105108:	05 00 01 00 00       	add    $0x100,%eax
  10510d:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  105110:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105117:	e8 6b 09 00 00       	call   105a87 <strlen>
  10511c:	85 c0                	test   %eax,%eax
  10511e:	74 24                	je     105144 <check_boot_pgdir+0x33e>
  105120:	c7 44 24 0c f0 6e 10 	movl   $0x106ef0,0xc(%esp)
  105127:	00 
  105128:	c7 44 24 08 99 6a 10 	movl   $0x106a99,0x8(%esp)
  10512f:	00 
  105130:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  105137:	00 
  105138:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  10513f:	e8 d8 ba ff ff       	call   100c1c <__panic>

    free_page(p);
  105144:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10514b:	00 
  10514c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10514f:	89 04 24             	mov    %eax,(%esp)
  105152:	e8 97 eb ff ff       	call   103cee <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  105157:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10515c:	8b 00                	mov    (%eax),%eax
  10515e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105163:	89 04 24             	mov    %eax,(%esp)
  105166:	e8 65 e8 ff ff       	call   1039d0 <pa2page>
  10516b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105172:	00 
  105173:	89 04 24             	mov    %eax,(%esp)
  105176:	e8 73 eb ff ff       	call   103cee <free_pages>
    boot_pgdir[0] = 0;
  10517b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105180:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  105186:	c7 04 24 14 6f 10 00 	movl   $0x106f14,(%esp)
  10518d:	e8 ba b1 ff ff       	call   10034c <cprintf>
}
  105192:	c9                   	leave  
  105193:	c3                   	ret    

00105194 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  105194:	55                   	push   %ebp
  105195:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105197:	8b 45 08             	mov    0x8(%ebp),%eax
  10519a:	83 e0 04             	and    $0x4,%eax
  10519d:	85 c0                	test   %eax,%eax
  10519f:	74 07                	je     1051a8 <perm2str+0x14>
  1051a1:	b8 75 00 00 00       	mov    $0x75,%eax
  1051a6:	eb 05                	jmp    1051ad <perm2str+0x19>
  1051a8:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1051ad:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  1051b2:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1051b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1051bc:	83 e0 02             	and    $0x2,%eax
  1051bf:	85 c0                	test   %eax,%eax
  1051c1:	74 07                	je     1051ca <perm2str+0x36>
  1051c3:	b8 77 00 00 00       	mov    $0x77,%eax
  1051c8:	eb 05                	jmp    1051cf <perm2str+0x3b>
  1051ca:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1051cf:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  1051d4:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  1051db:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  1051e0:	5d                   	pop    %ebp
  1051e1:	c3                   	ret    

001051e2 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1051e2:	55                   	push   %ebp
  1051e3:	89 e5                	mov    %esp,%ebp
  1051e5:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1051e8:	8b 45 10             	mov    0x10(%ebp),%eax
  1051eb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1051ee:	72 0a                	jb     1051fa <get_pgtable_items+0x18>
        return 0;
  1051f0:	b8 00 00 00 00       	mov    $0x0,%eax
  1051f5:	e9 9c 00 00 00       	jmp    105296 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  1051fa:	eb 04                	jmp    105200 <get_pgtable_items+0x1e>
        start ++;
  1051fc:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  105200:	8b 45 10             	mov    0x10(%ebp),%eax
  105203:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105206:	73 18                	jae    105220 <get_pgtable_items+0x3e>
  105208:	8b 45 10             	mov    0x10(%ebp),%eax
  10520b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105212:	8b 45 14             	mov    0x14(%ebp),%eax
  105215:	01 d0                	add    %edx,%eax
  105217:	8b 00                	mov    (%eax),%eax
  105219:	83 e0 01             	and    $0x1,%eax
  10521c:	85 c0                	test   %eax,%eax
  10521e:	74 dc                	je     1051fc <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  105220:	8b 45 10             	mov    0x10(%ebp),%eax
  105223:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105226:	73 69                	jae    105291 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  105228:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  10522c:	74 08                	je     105236 <get_pgtable_items+0x54>
            *left_store = start;
  10522e:	8b 45 18             	mov    0x18(%ebp),%eax
  105231:	8b 55 10             	mov    0x10(%ebp),%edx
  105234:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  105236:	8b 45 10             	mov    0x10(%ebp),%eax
  105239:	8d 50 01             	lea    0x1(%eax),%edx
  10523c:	89 55 10             	mov    %edx,0x10(%ebp)
  10523f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105246:	8b 45 14             	mov    0x14(%ebp),%eax
  105249:	01 d0                	add    %edx,%eax
  10524b:	8b 00                	mov    (%eax),%eax
  10524d:	83 e0 07             	and    $0x7,%eax
  105250:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105253:	eb 04                	jmp    105259 <get_pgtable_items+0x77>
            start ++;
  105255:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  105259:	8b 45 10             	mov    0x10(%ebp),%eax
  10525c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10525f:	73 1d                	jae    10527e <get_pgtable_items+0x9c>
  105261:	8b 45 10             	mov    0x10(%ebp),%eax
  105264:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10526b:	8b 45 14             	mov    0x14(%ebp),%eax
  10526e:	01 d0                	add    %edx,%eax
  105270:	8b 00                	mov    (%eax),%eax
  105272:	83 e0 07             	and    $0x7,%eax
  105275:	89 c2                	mov    %eax,%edx
  105277:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10527a:	39 c2                	cmp    %eax,%edx
  10527c:	74 d7                	je     105255 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  10527e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105282:	74 08                	je     10528c <get_pgtable_items+0xaa>
            *right_store = start;
  105284:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105287:	8b 55 10             	mov    0x10(%ebp),%edx
  10528a:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  10528c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10528f:	eb 05                	jmp    105296 <get_pgtable_items+0xb4>
    }
    return 0;
  105291:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105296:	c9                   	leave  
  105297:	c3                   	ret    

00105298 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  105298:	55                   	push   %ebp
  105299:	89 e5                	mov    %esp,%ebp
  10529b:	57                   	push   %edi
  10529c:	56                   	push   %esi
  10529d:	53                   	push   %ebx
  10529e:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1052a1:	c7 04 24 34 6f 10 00 	movl   $0x106f34,(%esp)
  1052a8:	e8 9f b0 ff ff       	call   10034c <cprintf>
    size_t left, right = 0, perm;
  1052ad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1052b4:	e9 fa 00 00 00       	jmp    1053b3 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1052b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052bc:	89 04 24             	mov    %eax,(%esp)
  1052bf:	e8 d0 fe ff ff       	call   105194 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1052c4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1052c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1052ca:	29 d1                	sub    %edx,%ecx
  1052cc:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1052ce:	89 d6                	mov    %edx,%esi
  1052d0:	c1 e6 16             	shl    $0x16,%esi
  1052d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1052d6:	89 d3                	mov    %edx,%ebx
  1052d8:	c1 e3 16             	shl    $0x16,%ebx
  1052db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1052de:	89 d1                	mov    %edx,%ecx
  1052e0:	c1 e1 16             	shl    $0x16,%ecx
  1052e3:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1052e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1052e9:	29 d7                	sub    %edx,%edi
  1052eb:	89 fa                	mov    %edi,%edx
  1052ed:	89 44 24 14          	mov    %eax,0x14(%esp)
  1052f1:	89 74 24 10          	mov    %esi,0x10(%esp)
  1052f5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1052f9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1052fd:	89 54 24 04          	mov    %edx,0x4(%esp)
  105301:	c7 04 24 65 6f 10 00 	movl   $0x106f65,(%esp)
  105308:	e8 3f b0 ff ff       	call   10034c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  10530d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105310:	c1 e0 0a             	shl    $0xa,%eax
  105313:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105316:	eb 54                	jmp    10536c <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105318:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10531b:	89 04 24             	mov    %eax,(%esp)
  10531e:	e8 71 fe ff ff       	call   105194 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  105323:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105326:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105329:	29 d1                	sub    %edx,%ecx
  10532b:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10532d:	89 d6                	mov    %edx,%esi
  10532f:	c1 e6 0c             	shl    $0xc,%esi
  105332:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105335:	89 d3                	mov    %edx,%ebx
  105337:	c1 e3 0c             	shl    $0xc,%ebx
  10533a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10533d:	c1 e2 0c             	shl    $0xc,%edx
  105340:	89 d1                	mov    %edx,%ecx
  105342:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  105345:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105348:	29 d7                	sub    %edx,%edi
  10534a:	89 fa                	mov    %edi,%edx
  10534c:	89 44 24 14          	mov    %eax,0x14(%esp)
  105350:	89 74 24 10          	mov    %esi,0x10(%esp)
  105354:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105358:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10535c:	89 54 24 04          	mov    %edx,0x4(%esp)
  105360:	c7 04 24 84 6f 10 00 	movl   $0x106f84,(%esp)
  105367:	e8 e0 af ff ff       	call   10034c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10536c:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  105371:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105374:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105377:	89 ce                	mov    %ecx,%esi
  105379:	c1 e6 0a             	shl    $0xa,%esi
  10537c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  10537f:	89 cb                	mov    %ecx,%ebx
  105381:	c1 e3 0a             	shl    $0xa,%ebx
  105384:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  105387:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  10538b:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  10538e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105392:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105396:	89 44 24 08          	mov    %eax,0x8(%esp)
  10539a:	89 74 24 04          	mov    %esi,0x4(%esp)
  10539e:	89 1c 24             	mov    %ebx,(%esp)
  1053a1:	e8 3c fe ff ff       	call   1051e2 <get_pgtable_items>
  1053a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1053a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1053ad:	0f 85 65 ff ff ff    	jne    105318 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1053b3:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  1053b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1053bb:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  1053be:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1053c2:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  1053c5:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1053c9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1053cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053d1:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1053d8:	00 
  1053d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1053e0:	e8 fd fd ff ff       	call   1051e2 <get_pgtable_items>
  1053e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1053e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1053ec:	0f 85 c7 fe ff ff    	jne    1052b9 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1053f2:	c7 04 24 a8 6f 10 00 	movl   $0x106fa8,(%esp)
  1053f9:	e8 4e af ff ff       	call   10034c <cprintf>
}
  1053fe:	83 c4 4c             	add    $0x4c,%esp
  105401:	5b                   	pop    %ebx
  105402:	5e                   	pop    %esi
  105403:	5f                   	pop    %edi
  105404:	5d                   	pop    %ebp
  105405:	c3                   	ret    

00105406 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105406:	55                   	push   %ebp
  105407:	89 e5                	mov    %esp,%ebp
  105409:	83 ec 58             	sub    $0x58,%esp
  10540c:	8b 45 10             	mov    0x10(%ebp),%eax
  10540f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105412:	8b 45 14             	mov    0x14(%ebp),%eax
  105415:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105418:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10541b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10541e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105421:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105424:	8b 45 18             	mov    0x18(%ebp),%eax
  105427:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10542a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10542d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105430:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105433:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105439:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10543c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105440:	74 1c                	je     10545e <printnum+0x58>
  105442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105445:	ba 00 00 00 00       	mov    $0x0,%edx
  10544a:	f7 75 e4             	divl   -0x1c(%ebp)
  10544d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105453:	ba 00 00 00 00       	mov    $0x0,%edx
  105458:	f7 75 e4             	divl   -0x1c(%ebp)
  10545b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10545e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105464:	f7 75 e4             	divl   -0x1c(%ebp)
  105467:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10546a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10546d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105470:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105473:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105476:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105479:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10547c:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10547f:	8b 45 18             	mov    0x18(%ebp),%eax
  105482:	ba 00 00 00 00       	mov    $0x0,%edx
  105487:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10548a:	77 56                	ja     1054e2 <printnum+0xdc>
  10548c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10548f:	72 05                	jb     105496 <printnum+0x90>
  105491:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105494:	77 4c                	ja     1054e2 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  105496:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105499:	8d 50 ff             	lea    -0x1(%eax),%edx
  10549c:	8b 45 20             	mov    0x20(%ebp),%eax
  10549f:	89 44 24 18          	mov    %eax,0x18(%esp)
  1054a3:	89 54 24 14          	mov    %edx,0x14(%esp)
  1054a7:	8b 45 18             	mov    0x18(%ebp),%eax
  1054aa:	89 44 24 10          	mov    %eax,0x10(%esp)
  1054ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1054b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054b8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1054bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1054c6:	89 04 24             	mov    %eax,(%esp)
  1054c9:	e8 38 ff ff ff       	call   105406 <printnum>
  1054ce:	eb 1c                	jmp    1054ec <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1054d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054d7:	8b 45 20             	mov    0x20(%ebp),%eax
  1054da:	89 04 24             	mov    %eax,(%esp)
  1054dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1054e0:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1054e2:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1054e6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1054ea:	7f e4                	jg     1054d0 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1054ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1054ef:	05 5c 70 10 00       	add    $0x10705c,%eax
  1054f4:	0f b6 00             	movzbl (%eax),%eax
  1054f7:	0f be c0             	movsbl %al,%eax
  1054fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  1054fd:	89 54 24 04          	mov    %edx,0x4(%esp)
  105501:	89 04 24             	mov    %eax,(%esp)
  105504:	8b 45 08             	mov    0x8(%ebp),%eax
  105507:	ff d0                	call   *%eax
}
  105509:	c9                   	leave  
  10550a:	c3                   	ret    

0010550b <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10550b:	55                   	push   %ebp
  10550c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10550e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105512:	7e 14                	jle    105528 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105514:	8b 45 08             	mov    0x8(%ebp),%eax
  105517:	8b 00                	mov    (%eax),%eax
  105519:	8d 48 08             	lea    0x8(%eax),%ecx
  10551c:	8b 55 08             	mov    0x8(%ebp),%edx
  10551f:	89 0a                	mov    %ecx,(%edx)
  105521:	8b 50 04             	mov    0x4(%eax),%edx
  105524:	8b 00                	mov    (%eax),%eax
  105526:	eb 30                	jmp    105558 <getuint+0x4d>
    }
    else if (lflag) {
  105528:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10552c:	74 16                	je     105544 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10552e:	8b 45 08             	mov    0x8(%ebp),%eax
  105531:	8b 00                	mov    (%eax),%eax
  105533:	8d 48 04             	lea    0x4(%eax),%ecx
  105536:	8b 55 08             	mov    0x8(%ebp),%edx
  105539:	89 0a                	mov    %ecx,(%edx)
  10553b:	8b 00                	mov    (%eax),%eax
  10553d:	ba 00 00 00 00       	mov    $0x0,%edx
  105542:	eb 14                	jmp    105558 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105544:	8b 45 08             	mov    0x8(%ebp),%eax
  105547:	8b 00                	mov    (%eax),%eax
  105549:	8d 48 04             	lea    0x4(%eax),%ecx
  10554c:	8b 55 08             	mov    0x8(%ebp),%edx
  10554f:	89 0a                	mov    %ecx,(%edx)
  105551:	8b 00                	mov    (%eax),%eax
  105553:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105558:	5d                   	pop    %ebp
  105559:	c3                   	ret    

0010555a <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10555a:	55                   	push   %ebp
  10555b:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10555d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105561:	7e 14                	jle    105577 <getint+0x1d>
        return va_arg(*ap, long long);
  105563:	8b 45 08             	mov    0x8(%ebp),%eax
  105566:	8b 00                	mov    (%eax),%eax
  105568:	8d 48 08             	lea    0x8(%eax),%ecx
  10556b:	8b 55 08             	mov    0x8(%ebp),%edx
  10556e:	89 0a                	mov    %ecx,(%edx)
  105570:	8b 50 04             	mov    0x4(%eax),%edx
  105573:	8b 00                	mov    (%eax),%eax
  105575:	eb 28                	jmp    10559f <getint+0x45>
    }
    else if (lflag) {
  105577:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10557b:	74 12                	je     10558f <getint+0x35>
        return va_arg(*ap, long);
  10557d:	8b 45 08             	mov    0x8(%ebp),%eax
  105580:	8b 00                	mov    (%eax),%eax
  105582:	8d 48 04             	lea    0x4(%eax),%ecx
  105585:	8b 55 08             	mov    0x8(%ebp),%edx
  105588:	89 0a                	mov    %ecx,(%edx)
  10558a:	8b 00                	mov    (%eax),%eax
  10558c:	99                   	cltd   
  10558d:	eb 10                	jmp    10559f <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  10558f:	8b 45 08             	mov    0x8(%ebp),%eax
  105592:	8b 00                	mov    (%eax),%eax
  105594:	8d 48 04             	lea    0x4(%eax),%ecx
  105597:	8b 55 08             	mov    0x8(%ebp),%edx
  10559a:	89 0a                	mov    %ecx,(%edx)
  10559c:	8b 00                	mov    (%eax),%eax
  10559e:	99                   	cltd   
    }
}
  10559f:	5d                   	pop    %ebp
  1055a0:	c3                   	ret    

001055a1 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1055a1:	55                   	push   %ebp
  1055a2:	89 e5                	mov    %esp,%ebp
  1055a4:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1055a7:	8d 45 14             	lea    0x14(%ebp),%eax
  1055aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1055ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1055b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1055b4:	8b 45 10             	mov    0x10(%ebp),%eax
  1055b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1055c5:	89 04 24             	mov    %eax,(%esp)
  1055c8:	e8 02 00 00 00       	call   1055cf <vprintfmt>
    va_end(ap);
}
  1055cd:	c9                   	leave  
  1055ce:	c3                   	ret    

001055cf <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1055cf:	55                   	push   %ebp
  1055d0:	89 e5                	mov    %esp,%ebp
  1055d2:	56                   	push   %esi
  1055d3:	53                   	push   %ebx
  1055d4:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1055d7:	eb 18                	jmp    1055f1 <vprintfmt+0x22>
            if (ch == '\0') {
  1055d9:	85 db                	test   %ebx,%ebx
  1055db:	75 05                	jne    1055e2 <vprintfmt+0x13>
                return;
  1055dd:	e9 d1 03 00 00       	jmp    1059b3 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  1055e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055e9:	89 1c 24             	mov    %ebx,(%esp)
  1055ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1055ef:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1055f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1055f4:	8d 50 01             	lea    0x1(%eax),%edx
  1055f7:	89 55 10             	mov    %edx,0x10(%ebp)
  1055fa:	0f b6 00             	movzbl (%eax),%eax
  1055fd:	0f b6 d8             	movzbl %al,%ebx
  105600:	83 fb 25             	cmp    $0x25,%ebx
  105603:	75 d4                	jne    1055d9 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105605:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105609:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105613:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105616:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10561d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105620:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105623:	8b 45 10             	mov    0x10(%ebp),%eax
  105626:	8d 50 01             	lea    0x1(%eax),%edx
  105629:	89 55 10             	mov    %edx,0x10(%ebp)
  10562c:	0f b6 00             	movzbl (%eax),%eax
  10562f:	0f b6 d8             	movzbl %al,%ebx
  105632:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105635:	83 f8 55             	cmp    $0x55,%eax
  105638:	0f 87 44 03 00 00    	ja     105982 <vprintfmt+0x3b3>
  10563e:	8b 04 85 80 70 10 00 	mov    0x107080(,%eax,4),%eax
  105645:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105647:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10564b:	eb d6                	jmp    105623 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10564d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105651:	eb d0                	jmp    105623 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105653:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10565a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10565d:	89 d0                	mov    %edx,%eax
  10565f:	c1 e0 02             	shl    $0x2,%eax
  105662:	01 d0                	add    %edx,%eax
  105664:	01 c0                	add    %eax,%eax
  105666:	01 d8                	add    %ebx,%eax
  105668:	83 e8 30             	sub    $0x30,%eax
  10566b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10566e:	8b 45 10             	mov    0x10(%ebp),%eax
  105671:	0f b6 00             	movzbl (%eax),%eax
  105674:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105677:	83 fb 2f             	cmp    $0x2f,%ebx
  10567a:	7e 0b                	jle    105687 <vprintfmt+0xb8>
  10567c:	83 fb 39             	cmp    $0x39,%ebx
  10567f:	7f 06                	jg     105687 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105681:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  105685:	eb d3                	jmp    10565a <vprintfmt+0x8b>
            goto process_precision;
  105687:	eb 33                	jmp    1056bc <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  105689:	8b 45 14             	mov    0x14(%ebp),%eax
  10568c:	8d 50 04             	lea    0x4(%eax),%edx
  10568f:	89 55 14             	mov    %edx,0x14(%ebp)
  105692:	8b 00                	mov    (%eax),%eax
  105694:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105697:	eb 23                	jmp    1056bc <vprintfmt+0xed>

        case '.':
            if (width < 0)
  105699:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10569d:	79 0c                	jns    1056ab <vprintfmt+0xdc>
                width = 0;
  10569f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1056a6:	e9 78 ff ff ff       	jmp    105623 <vprintfmt+0x54>
  1056ab:	e9 73 ff ff ff       	jmp    105623 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1056b0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1056b7:	e9 67 ff ff ff       	jmp    105623 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  1056bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056c0:	79 12                	jns    1056d4 <vprintfmt+0x105>
                width = precision, precision = -1;
  1056c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1056c8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1056cf:	e9 4f ff ff ff       	jmp    105623 <vprintfmt+0x54>
  1056d4:	e9 4a ff ff ff       	jmp    105623 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1056d9:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1056dd:	e9 41 ff ff ff       	jmp    105623 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1056e2:	8b 45 14             	mov    0x14(%ebp),%eax
  1056e5:	8d 50 04             	lea    0x4(%eax),%edx
  1056e8:	89 55 14             	mov    %edx,0x14(%ebp)
  1056eb:	8b 00                	mov    (%eax),%eax
  1056ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  1056f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1056f4:	89 04 24             	mov    %eax,(%esp)
  1056f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1056fa:	ff d0                	call   *%eax
            break;
  1056fc:	e9 ac 02 00 00       	jmp    1059ad <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105701:	8b 45 14             	mov    0x14(%ebp),%eax
  105704:	8d 50 04             	lea    0x4(%eax),%edx
  105707:	89 55 14             	mov    %edx,0x14(%ebp)
  10570a:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10570c:	85 db                	test   %ebx,%ebx
  10570e:	79 02                	jns    105712 <vprintfmt+0x143>
                err = -err;
  105710:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105712:	83 fb 06             	cmp    $0x6,%ebx
  105715:	7f 0b                	jg     105722 <vprintfmt+0x153>
  105717:	8b 34 9d 40 70 10 00 	mov    0x107040(,%ebx,4),%esi
  10571e:	85 f6                	test   %esi,%esi
  105720:	75 23                	jne    105745 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  105722:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105726:	c7 44 24 08 6d 70 10 	movl   $0x10706d,0x8(%esp)
  10572d:	00 
  10572e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105731:	89 44 24 04          	mov    %eax,0x4(%esp)
  105735:	8b 45 08             	mov    0x8(%ebp),%eax
  105738:	89 04 24             	mov    %eax,(%esp)
  10573b:	e8 61 fe ff ff       	call   1055a1 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105740:	e9 68 02 00 00       	jmp    1059ad <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105745:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105749:	c7 44 24 08 76 70 10 	movl   $0x107076,0x8(%esp)
  105750:	00 
  105751:	8b 45 0c             	mov    0xc(%ebp),%eax
  105754:	89 44 24 04          	mov    %eax,0x4(%esp)
  105758:	8b 45 08             	mov    0x8(%ebp),%eax
  10575b:	89 04 24             	mov    %eax,(%esp)
  10575e:	e8 3e fe ff ff       	call   1055a1 <printfmt>
            }
            break;
  105763:	e9 45 02 00 00       	jmp    1059ad <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105768:	8b 45 14             	mov    0x14(%ebp),%eax
  10576b:	8d 50 04             	lea    0x4(%eax),%edx
  10576e:	89 55 14             	mov    %edx,0x14(%ebp)
  105771:	8b 30                	mov    (%eax),%esi
  105773:	85 f6                	test   %esi,%esi
  105775:	75 05                	jne    10577c <vprintfmt+0x1ad>
                p = "(null)";
  105777:	be 79 70 10 00       	mov    $0x107079,%esi
            }
            if (width > 0 && padc != '-') {
  10577c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105780:	7e 3e                	jle    1057c0 <vprintfmt+0x1f1>
  105782:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105786:	74 38                	je     1057c0 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105788:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  10578b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10578e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105792:	89 34 24             	mov    %esi,(%esp)
  105795:	e8 15 03 00 00       	call   105aaf <strnlen>
  10579a:	29 c3                	sub    %eax,%ebx
  10579c:	89 d8                	mov    %ebx,%eax
  10579e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1057a1:	eb 17                	jmp    1057ba <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1057a3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1057a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1057aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1057ae:	89 04 24             	mov    %eax,(%esp)
  1057b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1057b4:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1057b6:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1057ba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057be:	7f e3                	jg     1057a3 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1057c0:	eb 38                	jmp    1057fa <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  1057c2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1057c6:	74 1f                	je     1057e7 <vprintfmt+0x218>
  1057c8:	83 fb 1f             	cmp    $0x1f,%ebx
  1057cb:	7e 05                	jle    1057d2 <vprintfmt+0x203>
  1057cd:	83 fb 7e             	cmp    $0x7e,%ebx
  1057d0:	7e 15                	jle    1057e7 <vprintfmt+0x218>
                    putch('?', putdat);
  1057d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057d9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1057e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1057e3:	ff d0                	call   *%eax
  1057e5:	eb 0f                	jmp    1057f6 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  1057e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ee:	89 1c 24             	mov    %ebx,(%esp)
  1057f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f4:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1057f6:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1057fa:	89 f0                	mov    %esi,%eax
  1057fc:	8d 70 01             	lea    0x1(%eax),%esi
  1057ff:	0f b6 00             	movzbl (%eax),%eax
  105802:	0f be d8             	movsbl %al,%ebx
  105805:	85 db                	test   %ebx,%ebx
  105807:	74 10                	je     105819 <vprintfmt+0x24a>
  105809:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10580d:	78 b3                	js     1057c2 <vprintfmt+0x1f3>
  10580f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105813:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105817:	79 a9                	jns    1057c2 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105819:	eb 17                	jmp    105832 <vprintfmt+0x263>
                putch(' ', putdat);
  10581b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10581e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105822:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105829:	8b 45 08             	mov    0x8(%ebp),%eax
  10582c:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10582e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105832:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105836:	7f e3                	jg     10581b <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  105838:	e9 70 01 00 00       	jmp    1059ad <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10583d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105840:	89 44 24 04          	mov    %eax,0x4(%esp)
  105844:	8d 45 14             	lea    0x14(%ebp),%eax
  105847:	89 04 24             	mov    %eax,(%esp)
  10584a:	e8 0b fd ff ff       	call   10555a <getint>
  10584f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105852:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105858:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10585b:	85 d2                	test   %edx,%edx
  10585d:	79 26                	jns    105885 <vprintfmt+0x2b6>
                putch('-', putdat);
  10585f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105862:	89 44 24 04          	mov    %eax,0x4(%esp)
  105866:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  10586d:	8b 45 08             	mov    0x8(%ebp),%eax
  105870:	ff d0                	call   *%eax
                num = -(long long)num;
  105872:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105875:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105878:	f7 d8                	neg    %eax
  10587a:	83 d2 00             	adc    $0x0,%edx
  10587d:	f7 da                	neg    %edx
  10587f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105882:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105885:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10588c:	e9 a8 00 00 00       	jmp    105939 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105891:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105894:	89 44 24 04          	mov    %eax,0x4(%esp)
  105898:	8d 45 14             	lea    0x14(%ebp),%eax
  10589b:	89 04 24             	mov    %eax,(%esp)
  10589e:	e8 68 fc ff ff       	call   10550b <getuint>
  1058a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1058a9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058b0:	e9 84 00 00 00       	jmp    105939 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1058b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058bc:	8d 45 14             	lea    0x14(%ebp),%eax
  1058bf:	89 04 24             	mov    %eax,(%esp)
  1058c2:	e8 44 fc ff ff       	call   10550b <getuint>
  1058c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1058cd:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1058d4:	eb 63                	jmp    105939 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  1058d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058dd:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1058e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1058e7:	ff d0                	call   *%eax
            putch('x', putdat);
  1058e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058f0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  1058f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1058fa:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1058fc:	8b 45 14             	mov    0x14(%ebp),%eax
  1058ff:	8d 50 04             	lea    0x4(%eax),%edx
  105902:	89 55 14             	mov    %edx,0x14(%ebp)
  105905:	8b 00                	mov    (%eax),%eax
  105907:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10590a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105911:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105918:	eb 1f                	jmp    105939 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10591a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10591d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105921:	8d 45 14             	lea    0x14(%ebp),%eax
  105924:	89 04 24             	mov    %eax,(%esp)
  105927:	e8 df fb ff ff       	call   10550b <getuint>
  10592c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10592f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105932:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105939:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10593d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105940:	89 54 24 18          	mov    %edx,0x18(%esp)
  105944:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105947:	89 54 24 14          	mov    %edx,0x14(%esp)
  10594b:	89 44 24 10          	mov    %eax,0x10(%esp)
  10594f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105952:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105955:	89 44 24 08          	mov    %eax,0x8(%esp)
  105959:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10595d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105960:	89 44 24 04          	mov    %eax,0x4(%esp)
  105964:	8b 45 08             	mov    0x8(%ebp),%eax
  105967:	89 04 24             	mov    %eax,(%esp)
  10596a:	e8 97 fa ff ff       	call   105406 <printnum>
            break;
  10596f:	eb 3c                	jmp    1059ad <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105971:	8b 45 0c             	mov    0xc(%ebp),%eax
  105974:	89 44 24 04          	mov    %eax,0x4(%esp)
  105978:	89 1c 24             	mov    %ebx,(%esp)
  10597b:	8b 45 08             	mov    0x8(%ebp),%eax
  10597e:	ff d0                	call   *%eax
            break;
  105980:	eb 2b                	jmp    1059ad <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105982:	8b 45 0c             	mov    0xc(%ebp),%eax
  105985:	89 44 24 04          	mov    %eax,0x4(%esp)
  105989:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105990:	8b 45 08             	mov    0x8(%ebp),%eax
  105993:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105995:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105999:	eb 04                	jmp    10599f <vprintfmt+0x3d0>
  10599b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10599f:	8b 45 10             	mov    0x10(%ebp),%eax
  1059a2:	83 e8 01             	sub    $0x1,%eax
  1059a5:	0f b6 00             	movzbl (%eax),%eax
  1059a8:	3c 25                	cmp    $0x25,%al
  1059aa:	75 ef                	jne    10599b <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  1059ac:	90                   	nop
        }
    }
  1059ad:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1059ae:	e9 3e fc ff ff       	jmp    1055f1 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1059b3:	83 c4 40             	add    $0x40,%esp
  1059b6:	5b                   	pop    %ebx
  1059b7:	5e                   	pop    %esi
  1059b8:	5d                   	pop    %ebp
  1059b9:	c3                   	ret    

001059ba <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1059ba:	55                   	push   %ebp
  1059bb:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1059bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059c0:	8b 40 08             	mov    0x8(%eax),%eax
  1059c3:	8d 50 01             	lea    0x1(%eax),%edx
  1059c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059c9:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1059cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059cf:	8b 10                	mov    (%eax),%edx
  1059d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059d4:	8b 40 04             	mov    0x4(%eax),%eax
  1059d7:	39 c2                	cmp    %eax,%edx
  1059d9:	73 12                	jae    1059ed <sprintputch+0x33>
        *b->buf ++ = ch;
  1059db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059de:	8b 00                	mov    (%eax),%eax
  1059e0:	8d 48 01             	lea    0x1(%eax),%ecx
  1059e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1059e6:	89 0a                	mov    %ecx,(%edx)
  1059e8:	8b 55 08             	mov    0x8(%ebp),%edx
  1059eb:	88 10                	mov    %dl,(%eax)
    }
}
  1059ed:	5d                   	pop    %ebp
  1059ee:	c3                   	ret    

001059ef <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1059ef:	55                   	push   %ebp
  1059f0:	89 e5                	mov    %esp,%ebp
  1059f2:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1059f5:	8d 45 14             	lea    0x14(%ebp),%eax
  1059f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1059fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a02:	8b 45 10             	mov    0x10(%ebp),%eax
  105a05:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a09:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a10:	8b 45 08             	mov    0x8(%ebp),%eax
  105a13:	89 04 24             	mov    %eax,(%esp)
  105a16:	e8 08 00 00 00       	call   105a23 <vsnprintf>
  105a1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a21:	c9                   	leave  
  105a22:	c3                   	ret    

00105a23 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105a23:	55                   	push   %ebp
  105a24:	89 e5                	mov    %esp,%ebp
  105a26:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105a29:	8b 45 08             	mov    0x8(%ebp),%eax
  105a2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a32:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a35:	8b 45 08             	mov    0x8(%ebp),%eax
  105a38:	01 d0                	add    %edx,%eax
  105a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105a44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105a48:	74 0a                	je     105a54 <vsnprintf+0x31>
  105a4a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a50:	39 c2                	cmp    %eax,%edx
  105a52:	76 07                	jbe    105a5b <vsnprintf+0x38>
        return -E_INVAL;
  105a54:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105a59:	eb 2a                	jmp    105a85 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105a5b:	8b 45 14             	mov    0x14(%ebp),%eax
  105a5e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a62:	8b 45 10             	mov    0x10(%ebp),%eax
  105a65:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a69:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a70:	c7 04 24 ba 59 10 00 	movl   $0x1059ba,(%esp)
  105a77:	e8 53 fb ff ff       	call   1055cf <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105a7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a7f:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a85:	c9                   	leave  
  105a86:	c3                   	ret    

00105a87 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105a87:	55                   	push   %ebp
  105a88:	89 e5                	mov    %esp,%ebp
  105a8a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105a8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105a94:	eb 04                	jmp    105a9a <strlen+0x13>
        cnt ++;
  105a96:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  105a9d:	8d 50 01             	lea    0x1(%eax),%edx
  105aa0:	89 55 08             	mov    %edx,0x8(%ebp)
  105aa3:	0f b6 00             	movzbl (%eax),%eax
  105aa6:	84 c0                	test   %al,%al
  105aa8:	75 ec                	jne    105a96 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105aaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105aad:	c9                   	leave  
  105aae:	c3                   	ret    

00105aaf <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105aaf:	55                   	push   %ebp
  105ab0:	89 e5                	mov    %esp,%ebp
  105ab2:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105ab5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105abc:	eb 04                	jmp    105ac2 <strnlen+0x13>
        cnt ++;
  105abe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105ac2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105ac5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105ac8:	73 10                	jae    105ada <strnlen+0x2b>
  105aca:	8b 45 08             	mov    0x8(%ebp),%eax
  105acd:	8d 50 01             	lea    0x1(%eax),%edx
  105ad0:	89 55 08             	mov    %edx,0x8(%ebp)
  105ad3:	0f b6 00             	movzbl (%eax),%eax
  105ad6:	84 c0                	test   %al,%al
  105ad8:	75 e4                	jne    105abe <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105ada:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105add:	c9                   	leave  
  105ade:	c3                   	ret    

00105adf <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105adf:	55                   	push   %ebp
  105ae0:	89 e5                	mov    %esp,%ebp
  105ae2:	57                   	push   %edi
  105ae3:	56                   	push   %esi
  105ae4:	83 ec 20             	sub    $0x20,%esp
  105ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  105aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  105af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105af3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105af9:	89 d1                	mov    %edx,%ecx
  105afb:	89 c2                	mov    %eax,%edx
  105afd:	89 ce                	mov    %ecx,%esi
  105aff:	89 d7                	mov    %edx,%edi
  105b01:	ac                   	lods   %ds:(%esi),%al
  105b02:	aa                   	stos   %al,%es:(%edi)
  105b03:	84 c0                	test   %al,%al
  105b05:	75 fa                	jne    105b01 <strcpy+0x22>
  105b07:	89 fa                	mov    %edi,%edx
  105b09:	89 f1                	mov    %esi,%ecx
  105b0b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105b0e:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105b11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105b17:	83 c4 20             	add    $0x20,%esp
  105b1a:	5e                   	pop    %esi
  105b1b:	5f                   	pop    %edi
  105b1c:	5d                   	pop    %ebp
  105b1d:	c3                   	ret    

00105b1e <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105b1e:	55                   	push   %ebp
  105b1f:	89 e5                	mov    %esp,%ebp
  105b21:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105b24:	8b 45 08             	mov    0x8(%ebp),%eax
  105b27:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105b2a:	eb 21                	jmp    105b4d <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b2f:	0f b6 10             	movzbl (%eax),%edx
  105b32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b35:	88 10                	mov    %dl,(%eax)
  105b37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b3a:	0f b6 00             	movzbl (%eax),%eax
  105b3d:	84 c0                	test   %al,%al
  105b3f:	74 04                	je     105b45 <strncpy+0x27>
            src ++;
  105b41:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105b45:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105b49:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105b4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b51:	75 d9                	jne    105b2c <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105b53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105b56:	c9                   	leave  
  105b57:	c3                   	ret    

00105b58 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105b58:	55                   	push   %ebp
  105b59:	89 e5                	mov    %esp,%ebp
  105b5b:	57                   	push   %edi
  105b5c:	56                   	push   %esi
  105b5d:	83 ec 20             	sub    $0x20,%esp
  105b60:	8b 45 08             	mov    0x8(%ebp),%eax
  105b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b69:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105b6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b72:	89 d1                	mov    %edx,%ecx
  105b74:	89 c2                	mov    %eax,%edx
  105b76:	89 ce                	mov    %ecx,%esi
  105b78:	89 d7                	mov    %edx,%edi
  105b7a:	ac                   	lods   %ds:(%esi),%al
  105b7b:	ae                   	scas   %es:(%edi),%al
  105b7c:	75 08                	jne    105b86 <strcmp+0x2e>
  105b7e:	84 c0                	test   %al,%al
  105b80:	75 f8                	jne    105b7a <strcmp+0x22>
  105b82:	31 c0                	xor    %eax,%eax
  105b84:	eb 04                	jmp    105b8a <strcmp+0x32>
  105b86:	19 c0                	sbb    %eax,%eax
  105b88:	0c 01                	or     $0x1,%al
  105b8a:	89 fa                	mov    %edi,%edx
  105b8c:	89 f1                	mov    %esi,%ecx
  105b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105b91:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105b94:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105b9a:	83 c4 20             	add    $0x20,%esp
  105b9d:	5e                   	pop    %esi
  105b9e:	5f                   	pop    %edi
  105b9f:	5d                   	pop    %ebp
  105ba0:	c3                   	ret    

00105ba1 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105ba1:	55                   	push   %ebp
  105ba2:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105ba4:	eb 0c                	jmp    105bb2 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105ba6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105baa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105bae:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105bb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105bb6:	74 1a                	je     105bd2 <strncmp+0x31>
  105bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  105bbb:	0f b6 00             	movzbl (%eax),%eax
  105bbe:	84 c0                	test   %al,%al
  105bc0:	74 10                	je     105bd2 <strncmp+0x31>
  105bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  105bc5:	0f b6 10             	movzbl (%eax),%edx
  105bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bcb:	0f b6 00             	movzbl (%eax),%eax
  105bce:	38 c2                	cmp    %al,%dl
  105bd0:	74 d4                	je     105ba6 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105bd2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105bd6:	74 18                	je     105bf0 <strncmp+0x4f>
  105bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  105bdb:	0f b6 00             	movzbl (%eax),%eax
  105bde:	0f b6 d0             	movzbl %al,%edx
  105be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105be4:	0f b6 00             	movzbl (%eax),%eax
  105be7:	0f b6 c0             	movzbl %al,%eax
  105bea:	29 c2                	sub    %eax,%edx
  105bec:	89 d0                	mov    %edx,%eax
  105bee:	eb 05                	jmp    105bf5 <strncmp+0x54>
  105bf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105bf5:	5d                   	pop    %ebp
  105bf6:	c3                   	ret    

00105bf7 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105bf7:	55                   	push   %ebp
  105bf8:	89 e5                	mov    %esp,%ebp
  105bfa:	83 ec 04             	sub    $0x4,%esp
  105bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c00:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c03:	eb 14                	jmp    105c19 <strchr+0x22>
        if (*s == c) {
  105c05:	8b 45 08             	mov    0x8(%ebp),%eax
  105c08:	0f b6 00             	movzbl (%eax),%eax
  105c0b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105c0e:	75 05                	jne    105c15 <strchr+0x1e>
            return (char *)s;
  105c10:	8b 45 08             	mov    0x8(%ebp),%eax
  105c13:	eb 13                	jmp    105c28 <strchr+0x31>
        }
        s ++;
  105c15:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105c19:	8b 45 08             	mov    0x8(%ebp),%eax
  105c1c:	0f b6 00             	movzbl (%eax),%eax
  105c1f:	84 c0                	test   %al,%al
  105c21:	75 e2                	jne    105c05 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105c23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c28:	c9                   	leave  
  105c29:	c3                   	ret    

00105c2a <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105c2a:	55                   	push   %ebp
  105c2b:	89 e5                	mov    %esp,%ebp
  105c2d:	83 ec 04             	sub    $0x4,%esp
  105c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c33:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c36:	eb 11                	jmp    105c49 <strfind+0x1f>
        if (*s == c) {
  105c38:	8b 45 08             	mov    0x8(%ebp),%eax
  105c3b:	0f b6 00             	movzbl (%eax),%eax
  105c3e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105c41:	75 02                	jne    105c45 <strfind+0x1b>
            break;
  105c43:	eb 0e                	jmp    105c53 <strfind+0x29>
        }
        s ++;
  105c45:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105c49:	8b 45 08             	mov    0x8(%ebp),%eax
  105c4c:	0f b6 00             	movzbl (%eax),%eax
  105c4f:	84 c0                	test   %al,%al
  105c51:	75 e5                	jne    105c38 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105c53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105c56:	c9                   	leave  
  105c57:	c3                   	ret    

00105c58 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105c58:	55                   	push   %ebp
  105c59:	89 e5                	mov    %esp,%ebp
  105c5b:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105c5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105c65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105c6c:	eb 04                	jmp    105c72 <strtol+0x1a>
        s ++;
  105c6e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105c72:	8b 45 08             	mov    0x8(%ebp),%eax
  105c75:	0f b6 00             	movzbl (%eax),%eax
  105c78:	3c 20                	cmp    $0x20,%al
  105c7a:	74 f2                	je     105c6e <strtol+0x16>
  105c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c7f:	0f b6 00             	movzbl (%eax),%eax
  105c82:	3c 09                	cmp    $0x9,%al
  105c84:	74 e8                	je     105c6e <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105c86:	8b 45 08             	mov    0x8(%ebp),%eax
  105c89:	0f b6 00             	movzbl (%eax),%eax
  105c8c:	3c 2b                	cmp    $0x2b,%al
  105c8e:	75 06                	jne    105c96 <strtol+0x3e>
        s ++;
  105c90:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c94:	eb 15                	jmp    105cab <strtol+0x53>
    }
    else if (*s == '-') {
  105c96:	8b 45 08             	mov    0x8(%ebp),%eax
  105c99:	0f b6 00             	movzbl (%eax),%eax
  105c9c:	3c 2d                	cmp    $0x2d,%al
  105c9e:	75 0b                	jne    105cab <strtol+0x53>
        s ++, neg = 1;
  105ca0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105ca4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105cab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105caf:	74 06                	je     105cb7 <strtol+0x5f>
  105cb1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105cb5:	75 24                	jne    105cdb <strtol+0x83>
  105cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  105cba:	0f b6 00             	movzbl (%eax),%eax
  105cbd:	3c 30                	cmp    $0x30,%al
  105cbf:	75 1a                	jne    105cdb <strtol+0x83>
  105cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  105cc4:	83 c0 01             	add    $0x1,%eax
  105cc7:	0f b6 00             	movzbl (%eax),%eax
  105cca:	3c 78                	cmp    $0x78,%al
  105ccc:	75 0d                	jne    105cdb <strtol+0x83>
        s += 2, base = 16;
  105cce:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105cd2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105cd9:	eb 2a                	jmp    105d05 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105cdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105cdf:	75 17                	jne    105cf8 <strtol+0xa0>
  105ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce4:	0f b6 00             	movzbl (%eax),%eax
  105ce7:	3c 30                	cmp    $0x30,%al
  105ce9:	75 0d                	jne    105cf8 <strtol+0xa0>
        s ++, base = 8;
  105ceb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105cef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105cf6:	eb 0d                	jmp    105d05 <strtol+0xad>
    }
    else if (base == 0) {
  105cf8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105cfc:	75 07                	jne    105d05 <strtol+0xad>
        base = 10;
  105cfe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105d05:	8b 45 08             	mov    0x8(%ebp),%eax
  105d08:	0f b6 00             	movzbl (%eax),%eax
  105d0b:	3c 2f                	cmp    $0x2f,%al
  105d0d:	7e 1b                	jle    105d2a <strtol+0xd2>
  105d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  105d12:	0f b6 00             	movzbl (%eax),%eax
  105d15:	3c 39                	cmp    $0x39,%al
  105d17:	7f 11                	jg     105d2a <strtol+0xd2>
            dig = *s - '0';
  105d19:	8b 45 08             	mov    0x8(%ebp),%eax
  105d1c:	0f b6 00             	movzbl (%eax),%eax
  105d1f:	0f be c0             	movsbl %al,%eax
  105d22:	83 e8 30             	sub    $0x30,%eax
  105d25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d28:	eb 48                	jmp    105d72 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  105d2d:	0f b6 00             	movzbl (%eax),%eax
  105d30:	3c 60                	cmp    $0x60,%al
  105d32:	7e 1b                	jle    105d4f <strtol+0xf7>
  105d34:	8b 45 08             	mov    0x8(%ebp),%eax
  105d37:	0f b6 00             	movzbl (%eax),%eax
  105d3a:	3c 7a                	cmp    $0x7a,%al
  105d3c:	7f 11                	jg     105d4f <strtol+0xf7>
            dig = *s - 'a' + 10;
  105d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d41:	0f b6 00             	movzbl (%eax),%eax
  105d44:	0f be c0             	movsbl %al,%eax
  105d47:	83 e8 57             	sub    $0x57,%eax
  105d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d4d:	eb 23                	jmp    105d72 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  105d52:	0f b6 00             	movzbl (%eax),%eax
  105d55:	3c 40                	cmp    $0x40,%al
  105d57:	7e 3d                	jle    105d96 <strtol+0x13e>
  105d59:	8b 45 08             	mov    0x8(%ebp),%eax
  105d5c:	0f b6 00             	movzbl (%eax),%eax
  105d5f:	3c 5a                	cmp    $0x5a,%al
  105d61:	7f 33                	jg     105d96 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105d63:	8b 45 08             	mov    0x8(%ebp),%eax
  105d66:	0f b6 00             	movzbl (%eax),%eax
  105d69:	0f be c0             	movsbl %al,%eax
  105d6c:	83 e8 37             	sub    $0x37,%eax
  105d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d75:	3b 45 10             	cmp    0x10(%ebp),%eax
  105d78:	7c 02                	jl     105d7c <strtol+0x124>
            break;
  105d7a:	eb 1a                	jmp    105d96 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105d7c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d83:	0f af 45 10          	imul   0x10(%ebp),%eax
  105d87:	89 c2                	mov    %eax,%edx
  105d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d8c:	01 d0                	add    %edx,%eax
  105d8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105d91:	e9 6f ff ff ff       	jmp    105d05 <strtol+0xad>

    if (endptr) {
  105d96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105d9a:	74 08                	je     105da4 <strtol+0x14c>
        *endptr = (char *) s;
  105d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  105da2:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105da4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105da8:	74 07                	je     105db1 <strtol+0x159>
  105daa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105dad:	f7 d8                	neg    %eax
  105daf:	eb 03                	jmp    105db4 <strtol+0x15c>
  105db1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105db4:	c9                   	leave  
  105db5:	c3                   	ret    

00105db6 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105db6:	55                   	push   %ebp
  105db7:	89 e5                	mov    %esp,%ebp
  105db9:	57                   	push   %edi
  105dba:	83 ec 24             	sub    $0x24,%esp
  105dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dc0:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105dc3:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105dc7:	8b 55 08             	mov    0x8(%ebp),%edx
  105dca:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105dcd:	88 45 f7             	mov    %al,-0x9(%ebp)
  105dd0:	8b 45 10             	mov    0x10(%ebp),%eax
  105dd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105dd6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105dd9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105ddd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105de0:	89 d7                	mov    %edx,%edi
  105de2:	f3 aa                	rep stos %al,%es:(%edi)
  105de4:	89 fa                	mov    %edi,%edx
  105de6:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105de9:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105dec:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105def:	83 c4 24             	add    $0x24,%esp
  105df2:	5f                   	pop    %edi
  105df3:	5d                   	pop    %ebp
  105df4:	c3                   	ret    

00105df5 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105df5:	55                   	push   %ebp
  105df6:	89 e5                	mov    %esp,%ebp
  105df8:	57                   	push   %edi
  105df9:	56                   	push   %esi
  105dfa:	53                   	push   %ebx
  105dfb:	83 ec 30             	sub    $0x30,%esp
  105dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  105e01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e07:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105e0a:	8b 45 10             	mov    0x10(%ebp),%eax
  105e0d:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e13:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105e16:	73 42                	jae    105e5a <memmove+0x65>
  105e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105e1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e21:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105e24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e27:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105e2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105e2d:	c1 e8 02             	shr    $0x2,%eax
  105e30:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105e32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105e35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105e38:	89 d7                	mov    %edx,%edi
  105e3a:	89 c6                	mov    %eax,%esi
  105e3c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105e3e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105e41:	83 e1 03             	and    $0x3,%ecx
  105e44:	74 02                	je     105e48 <memmove+0x53>
  105e46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e48:	89 f0                	mov    %esi,%eax
  105e4a:	89 fa                	mov    %edi,%edx
  105e4c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105e4f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105e52:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105e55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105e58:	eb 36                	jmp    105e90 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105e5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e5d:	8d 50 ff             	lea    -0x1(%eax),%edx
  105e60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e63:	01 c2                	add    %eax,%edx
  105e65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e68:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e6e:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105e71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e74:	89 c1                	mov    %eax,%ecx
  105e76:	89 d8                	mov    %ebx,%eax
  105e78:	89 d6                	mov    %edx,%esi
  105e7a:	89 c7                	mov    %eax,%edi
  105e7c:	fd                   	std    
  105e7d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e7f:	fc                   	cld    
  105e80:	89 f8                	mov    %edi,%eax
  105e82:	89 f2                	mov    %esi,%edx
  105e84:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105e87:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105e8a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105e90:	83 c4 30             	add    $0x30,%esp
  105e93:	5b                   	pop    %ebx
  105e94:	5e                   	pop    %esi
  105e95:	5f                   	pop    %edi
  105e96:	5d                   	pop    %ebp
  105e97:	c3                   	ret    

00105e98 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105e98:	55                   	push   %ebp
  105e99:	89 e5                	mov    %esp,%ebp
  105e9b:	57                   	push   %edi
  105e9c:	56                   	push   %esi
  105e9d:	83 ec 20             	sub    $0x20,%esp
  105ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  105ea3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ea9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105eac:	8b 45 10             	mov    0x10(%ebp),%eax
  105eaf:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105eb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105eb5:	c1 e8 02             	shr    $0x2,%eax
  105eb8:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ec0:	89 d7                	mov    %edx,%edi
  105ec2:	89 c6                	mov    %eax,%esi
  105ec4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105ec6:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105ec9:	83 e1 03             	and    $0x3,%ecx
  105ecc:	74 02                	je     105ed0 <memcpy+0x38>
  105ece:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105ed0:	89 f0                	mov    %esi,%eax
  105ed2:	89 fa                	mov    %edi,%edx
  105ed4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105ed7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105eda:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105ee0:	83 c4 20             	add    $0x20,%esp
  105ee3:	5e                   	pop    %esi
  105ee4:	5f                   	pop    %edi
  105ee5:	5d                   	pop    %ebp
  105ee6:	c3                   	ret    

00105ee7 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105ee7:	55                   	push   %ebp
  105ee8:	89 e5                	mov    %esp,%ebp
  105eea:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105eed:	8b 45 08             	mov    0x8(%ebp),%eax
  105ef0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ef6:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105ef9:	eb 30                	jmp    105f2b <memcmp+0x44>
        if (*s1 != *s2) {
  105efb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105efe:	0f b6 10             	movzbl (%eax),%edx
  105f01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f04:	0f b6 00             	movzbl (%eax),%eax
  105f07:	38 c2                	cmp    %al,%dl
  105f09:	74 18                	je     105f23 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105f0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f0e:	0f b6 00             	movzbl (%eax),%eax
  105f11:	0f b6 d0             	movzbl %al,%edx
  105f14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f17:	0f b6 00             	movzbl (%eax),%eax
  105f1a:	0f b6 c0             	movzbl %al,%eax
  105f1d:	29 c2                	sub    %eax,%edx
  105f1f:	89 d0                	mov    %edx,%eax
  105f21:	eb 1a                	jmp    105f3d <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105f23:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105f27:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  105f2e:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f31:	89 55 10             	mov    %edx,0x10(%ebp)
  105f34:	85 c0                	test   %eax,%eax
  105f36:	75 c3                	jne    105efb <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105f38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f3d:	c9                   	leave  
  105f3e:	c3                   	ret    
