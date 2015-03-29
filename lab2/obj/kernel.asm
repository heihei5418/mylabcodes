
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba c8 89 11 c0       	mov    $0xc01189c8,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 60 5d 00 00       	call   c0105db6 <memset>

    cons_init();                // init the console
c0100056:	e8 c7 14 00 00       	call   c0101522 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 40 5f 10 c0 	movl   $0xc0105f40,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 5c 5f 10 c0 	movl   $0xc0105f5c,(%esp)
c0100070:	e8 d7 02 00 00       	call   c010034c <cprintf>

    print_kerninfo();
c0100075:	e8 06 08 00 00       	call   c0100880 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 8b 00 00 00       	call   c010010a <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 42 42 00 00       	call   c01042c6 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 02 16 00 00       	call   c010168b <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 54 17 00 00       	call   c01017e2 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 45 0c 00 00       	call   c0100cd8 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 61 15 00 00       	call   c01015f9 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
c0100098:	e8 6d 01 00 00       	call   c010020a <lab1_switch_test>

    /* do nothing */
    while (1);
c010009d:	eb fe                	jmp    c010009d <kern_init+0x73>

c010009f <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009f:	55                   	push   %ebp
c01000a0:	89 e5                	mov    %esp,%ebp
c01000a2:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000ac:	00 
c01000ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000b4:	00 
c01000b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000bc:	e8 49 0b 00 00       	call   c0100c0a <mon_backtrace>
}
c01000c1:	c9                   	leave  
c01000c2:	c3                   	ret    

c01000c3 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000c3:	55                   	push   %ebp
c01000c4:	89 e5                	mov    %esp,%ebp
c01000c6:	53                   	push   %ebx
c01000c7:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000ca:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000d0:	8d 55 08             	lea    0x8(%ebp),%edx
c01000d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000da:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000de:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000e2:	89 04 24             	mov    %eax,(%esp)
c01000e5:	e8 b5 ff ff ff       	call   c010009f <grade_backtrace2>
}
c01000ea:	83 c4 14             	add    $0x14,%esp
c01000ed:	5b                   	pop    %ebx
c01000ee:	5d                   	pop    %ebp
c01000ef:	c3                   	ret    

c01000f0 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000f0:	55                   	push   %ebp
c01000f1:	89 e5                	mov    %esp,%ebp
c01000f3:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f6:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100100:	89 04 24             	mov    %eax,(%esp)
c0100103:	e8 bb ff ff ff       	call   c01000c3 <grade_backtrace1>
}
c0100108:	c9                   	leave  
c0100109:	c3                   	ret    

c010010a <grade_backtrace>:

void
grade_backtrace(void) {
c010010a:	55                   	push   %ebp
c010010b:	89 e5                	mov    %esp,%ebp
c010010d:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100110:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100115:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010011c:	ff 
c010011d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100121:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100128:	e8 c3 ff ff ff       	call   c01000f0 <grade_backtrace0>
}
c010012d:	c9                   	leave  
c010012e:	c3                   	ret    

c010012f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012f:	55                   	push   %ebp
c0100130:	89 e5                	mov    %esp,%ebp
c0100132:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100135:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100138:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010013b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010013e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100141:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100145:	0f b7 c0             	movzwl %ax,%eax
c0100148:	83 e0 03             	and    $0x3,%eax
c010014b:	89 c2                	mov    %eax,%edx
c010014d:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100152:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100156:	89 44 24 04          	mov    %eax,0x4(%esp)
c010015a:	c7 04 24 61 5f 10 c0 	movl   $0xc0105f61,(%esp)
c0100161:	e8 e6 01 00 00       	call   c010034c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100166:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010016a:	0f b7 d0             	movzwl %ax,%edx
c010016d:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100172:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100176:	89 44 24 04          	mov    %eax,0x4(%esp)
c010017a:	c7 04 24 6f 5f 10 c0 	movl   $0xc0105f6f,(%esp)
c0100181:	e8 c6 01 00 00       	call   c010034c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100186:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010018a:	0f b7 d0             	movzwl %ax,%edx
c010018d:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100192:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100196:	89 44 24 04          	mov    %eax,0x4(%esp)
c010019a:	c7 04 24 7d 5f 10 c0 	movl   $0xc0105f7d,(%esp)
c01001a1:	e8 a6 01 00 00       	call   c010034c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001aa:	0f b7 d0             	movzwl %ax,%edx
c01001ad:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001b2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ba:	c7 04 24 8b 5f 10 c0 	movl   $0xc0105f8b,(%esp)
c01001c1:	e8 86 01 00 00       	call   c010034c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c6:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001ca:	0f b7 d0             	movzwl %ax,%edx
c01001cd:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001d2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001da:	c7 04 24 99 5f 10 c0 	movl   $0xc0105f99,(%esp)
c01001e1:	e8 66 01 00 00       	call   c010034c <cprintf>
    round ++;
c01001e6:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001eb:	83 c0 01             	add    $0x1,%eax
c01001ee:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001f3:	c9                   	leave  
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
c01001f8:	83 ec 08             	sub    $0x8,%esp
c01001fb:	cd 78                	int    $0x78
c01001fd:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
c01001ff:	5d                   	pop    %ebp
c0100200:	c3                   	ret    

c0100201 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100201:	55                   	push   %ebp
c0100202:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
c0100204:	cd 79                	int    $0x79
c0100206:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
c0100208:	5d                   	pop    %ebp
c0100209:	c3                   	ret    

c010020a <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010020a:	55                   	push   %ebp
c010020b:	89 e5                	mov    %esp,%ebp
c010020d:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100210:	e8 1a ff ff ff       	call   c010012f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100215:	c7 04 24 a8 5f 10 c0 	movl   $0xc0105fa8,(%esp)
c010021c:	e8 2b 01 00 00       	call   c010034c <cprintf>
    lab1_switch_to_user();
c0100221:	e8 cf ff ff ff       	call   c01001f5 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100226:	e8 04 ff ff ff       	call   c010012f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022b:	c7 04 24 c8 5f 10 c0 	movl   $0xc0105fc8,(%esp)
c0100232:	e8 15 01 00 00       	call   c010034c <cprintf>
    lab1_switch_to_kernel();
c0100237:	e8 c5 ff ff ff       	call   c0100201 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023c:	e8 ee fe ff ff       	call   c010012f <lab1_print_cur_status>
}
c0100241:	c9                   	leave  
c0100242:	c3                   	ret    

c0100243 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100243:	55                   	push   %ebp
c0100244:	89 e5                	mov    %esp,%ebp
c0100246:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100249:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010024d:	74 13                	je     c0100262 <readline+0x1f>
        cprintf("%s", prompt);
c010024f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100252:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100256:	c7 04 24 e7 5f 10 c0 	movl   $0xc0105fe7,(%esp)
c010025d:	e8 ea 00 00 00       	call   c010034c <cprintf>
    }
    int i = 0, c;
c0100262:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100269:	e8 66 01 00 00       	call   c01003d4 <getchar>
c010026e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100271:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100275:	79 07                	jns    c010027e <readline+0x3b>
            return NULL;
c0100277:	b8 00 00 00 00       	mov    $0x0,%eax
c010027c:	eb 79                	jmp    c01002f7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010027e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100282:	7e 28                	jle    c01002ac <readline+0x69>
c0100284:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010028b:	7f 1f                	jg     c01002ac <readline+0x69>
            cputchar(c);
c010028d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100290:	89 04 24             	mov    %eax,(%esp)
c0100293:	e8 da 00 00 00       	call   c0100372 <cputchar>
            buf[i ++] = c;
c0100298:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010029b:	8d 50 01             	lea    0x1(%eax),%edx
c010029e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a4:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c01002aa:	eb 46                	jmp    c01002f2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002ac:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002b0:	75 17                	jne    c01002c9 <readline+0x86>
c01002b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002b6:	7e 11                	jle    c01002c9 <readline+0x86>
            cputchar(c);
c01002b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002bb:	89 04 24             	mov    %eax,(%esp)
c01002be:	e8 af 00 00 00       	call   c0100372 <cputchar>
            i --;
c01002c3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002c7:	eb 29                	jmp    c01002f2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002cd:	74 06                	je     c01002d5 <readline+0x92>
c01002cf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002d3:	75 1d                	jne    c01002f2 <readline+0xaf>
            cputchar(c);
c01002d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d8:	89 04 24             	mov    %eax,(%esp)
c01002db:	e8 92 00 00 00       	call   c0100372 <cputchar>
            buf[i] = '\0';
c01002e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002e3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002e8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002eb:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002f0:	eb 05                	jmp    c01002f7 <readline+0xb4>
        }
    }
c01002f2:	e9 72 ff ff ff       	jmp    c0100269 <readline+0x26>
}
c01002f7:	c9                   	leave  
c01002f8:	c3                   	ret    

c01002f9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f9:	55                   	push   %ebp
c01002fa:	89 e5                	mov    %esp,%ebp
c01002fc:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0100302:	89 04 24             	mov    %eax,(%esp)
c0100305:	e8 44 12 00 00       	call   c010154e <cons_putc>
    (*cnt) ++;
c010030a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010030d:	8b 00                	mov    (%eax),%eax
c010030f:	8d 50 01             	lea    0x1(%eax),%edx
c0100312:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100315:	89 10                	mov    %edx,(%eax)
}
c0100317:	c9                   	leave  
c0100318:	c3                   	ret    

c0100319 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100319:	55                   	push   %ebp
c010031a:	89 e5                	mov    %esp,%ebp
c010031c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100326:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100329:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010032d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100330:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100334:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100337:	89 44 24 04          	mov    %eax,0x4(%esp)
c010033b:	c7 04 24 f9 02 10 c0 	movl   $0xc01002f9,(%esp)
c0100342:	e8 88 52 00 00       	call   c01055cf <vprintfmt>
    return cnt;
c0100347:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010034a:	c9                   	leave  
c010034b:	c3                   	ret    

c010034c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010034c:	55                   	push   %ebp
c010034d:	89 e5                	mov    %esp,%ebp
c010034f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100352:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100355:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100358:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010035b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100362:	89 04 24             	mov    %eax,(%esp)
c0100365:	e8 af ff ff ff       	call   c0100319 <vcprintf>
c010036a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010036d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100370:	c9                   	leave  
c0100371:	c3                   	ret    

c0100372 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100372:	55                   	push   %ebp
c0100373:	89 e5                	mov    %esp,%ebp
c0100375:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100378:	8b 45 08             	mov    0x8(%ebp),%eax
c010037b:	89 04 24             	mov    %eax,(%esp)
c010037e:	e8 cb 11 00 00       	call   c010154e <cons_putc>
}
c0100383:	c9                   	leave  
c0100384:	c3                   	ret    

c0100385 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100385:	55                   	push   %ebp
c0100386:	89 e5                	mov    %esp,%ebp
c0100388:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010038b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100392:	eb 13                	jmp    c01003a7 <cputs+0x22>
        cputch(c, &cnt);
c0100394:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100398:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010039b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039f:	89 04 24             	mov    %eax,(%esp)
c01003a2:	e8 52 ff ff ff       	call   c01002f9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01003aa:	8d 50 01             	lea    0x1(%eax),%edx
c01003ad:	89 55 08             	mov    %edx,0x8(%ebp)
c01003b0:	0f b6 00             	movzbl (%eax),%eax
c01003b3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003ba:	75 d8                	jne    c0100394 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003c3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ca:	e8 2a ff ff ff       	call   c01002f9 <cputch>
    return cnt;
c01003cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d2:	c9                   	leave  
c01003d3:	c3                   	ret    

c01003d4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d4:	55                   	push   %ebp
c01003d5:	89 e5                	mov    %esp,%ebp
c01003d7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003da:	e8 ab 11 00 00       	call   c010158a <cons_getc>
c01003df:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e6:	74 f2                	je     c01003da <getchar+0x6>
        /* do nothing */;
    return c;
c01003e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003eb:	c9                   	leave  
c01003ec:	c3                   	ret    

c01003ed <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003ed:	55                   	push   %ebp
c01003ee:	89 e5                	mov    %esp,%ebp
c01003f0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f6:	8b 00                	mov    (%eax),%eax
c01003f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003fb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003fe:	8b 00                	mov    (%eax),%eax
c0100400:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100403:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c010040a:	e9 d2 00 00 00       	jmp    c01004e1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100412:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100415:	01 d0                	add    %edx,%eax
c0100417:	89 c2                	mov    %eax,%edx
c0100419:	c1 ea 1f             	shr    $0x1f,%edx
c010041c:	01 d0                	add    %edx,%eax
c010041e:	d1 f8                	sar    %eax
c0100420:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100423:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100426:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100429:	eb 04                	jmp    c010042f <stab_binsearch+0x42>
            m --;
c010042b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100432:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100435:	7c 1f                	jl     c0100456 <stab_binsearch+0x69>
c0100437:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010043a:	89 d0                	mov    %edx,%eax
c010043c:	01 c0                	add    %eax,%eax
c010043e:	01 d0                	add    %edx,%eax
c0100440:	c1 e0 02             	shl    $0x2,%eax
c0100443:	89 c2                	mov    %eax,%edx
c0100445:	8b 45 08             	mov    0x8(%ebp),%eax
c0100448:	01 d0                	add    %edx,%eax
c010044a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044e:	0f b6 c0             	movzbl %al,%eax
c0100451:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100454:	75 d5                	jne    c010042b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100456:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100459:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010045c:	7d 0b                	jge    c0100469 <stab_binsearch+0x7c>
            l = true_m + 1;
c010045e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100461:	83 c0 01             	add    $0x1,%eax
c0100464:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100467:	eb 78                	jmp    c01004e1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100469:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100470:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100473:	89 d0                	mov    %edx,%eax
c0100475:	01 c0                	add    %eax,%eax
c0100477:	01 d0                	add    %edx,%eax
c0100479:	c1 e0 02             	shl    $0x2,%eax
c010047c:	89 c2                	mov    %eax,%edx
c010047e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100481:	01 d0                	add    %edx,%eax
c0100483:	8b 40 08             	mov    0x8(%eax),%eax
c0100486:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100489:	73 13                	jae    c010049e <stab_binsearch+0xb1>
            *region_left = m;
c010048b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100493:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100496:	83 c0 01             	add    $0x1,%eax
c0100499:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010049c:	eb 43                	jmp    c01004e1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010049e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a1:	89 d0                	mov    %edx,%eax
c01004a3:	01 c0                	add    %eax,%eax
c01004a5:	01 d0                	add    %edx,%eax
c01004a7:	c1 e0 02             	shl    $0x2,%eax
c01004aa:	89 c2                	mov    %eax,%edx
c01004ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01004af:	01 d0                	add    %edx,%eax
c01004b1:	8b 40 08             	mov    0x8(%eax),%eax
c01004b4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b7:	76 16                	jbe    c01004cf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004bc:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004bf:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c7:	83 e8 01             	sub    $0x1,%eax
c01004ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004cd:	eb 12                	jmp    c01004e1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004da:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004dd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e7:	0f 8e 22 ff ff ff    	jle    c010040f <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f1:	75 0f                	jne    c0100502 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f6:	8b 00                	mov    (%eax),%eax
c01004f8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004fb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fe:	89 10                	mov    %edx,(%eax)
c0100500:	eb 3f                	jmp    c0100541 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100502:	8b 45 10             	mov    0x10(%ebp),%eax
c0100505:	8b 00                	mov    (%eax),%eax
c0100507:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c010050a:	eb 04                	jmp    c0100510 <stab_binsearch+0x123>
c010050c:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100510:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100513:	8b 00                	mov    (%eax),%eax
c0100515:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100518:	7d 1f                	jge    c0100539 <stab_binsearch+0x14c>
c010051a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010051d:	89 d0                	mov    %edx,%eax
c010051f:	01 c0                	add    %eax,%eax
c0100521:	01 d0                	add    %edx,%eax
c0100523:	c1 e0 02             	shl    $0x2,%eax
c0100526:	89 c2                	mov    %eax,%edx
c0100528:	8b 45 08             	mov    0x8(%ebp),%eax
c010052b:	01 d0                	add    %edx,%eax
c010052d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100531:	0f b6 c0             	movzbl %al,%eax
c0100534:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100537:	75 d3                	jne    c010050c <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053f:	89 10                	mov    %edx,(%eax)
    }
}
c0100541:	c9                   	leave  
c0100542:	c3                   	ret    

c0100543 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100543:	55                   	push   %ebp
c0100544:	89 e5                	mov    %esp,%ebp
c0100546:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100549:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054c:	c7 00 ec 5f 10 c0    	movl   $0xc0105fec,(%eax)
    info->eip_line = 0;
c0100552:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100555:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010055c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055f:	c7 40 08 ec 5f 10 c0 	movl   $0xc0105fec,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100566:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100569:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100570:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100573:	8b 55 08             	mov    0x8(%ebp),%edx
c0100576:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100579:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100583:	c7 45 f4 d8 71 10 c0 	movl   $0xc01071d8,-0xc(%ebp)
    stab_end = __STAB_END__;
c010058a:	c7 45 f0 2c 1d 11 c0 	movl   $0xc0111d2c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100591:	c7 45 ec 2d 1d 11 c0 	movl   $0xc0111d2d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100598:	c7 45 e8 6b 47 11 c0 	movl   $0xc011476b,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a5:	76 0d                	jbe    c01005b4 <debuginfo_eip+0x71>
c01005a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005aa:	83 e8 01             	sub    $0x1,%eax
c01005ad:	0f b6 00             	movzbl (%eax),%eax
c01005b0:	84 c0                	test   %al,%al
c01005b2:	74 0a                	je     c01005be <debuginfo_eip+0x7b>
        return -1;
c01005b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b9:	e9 c0 02 00 00       	jmp    c010087e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005cb:	29 c2                	sub    %eax,%edx
c01005cd:	89 d0                	mov    %edx,%eax
c01005cf:	c1 f8 02             	sar    $0x2,%eax
c01005d2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d8:	83 e8 01             	sub    $0x1,%eax
c01005db:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005de:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005ec:	00 
c01005ed:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005f0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005f4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005fe:	89 04 24             	mov    %eax,(%esp)
c0100601:	e8 e7 fd ff ff       	call   c01003ed <stab_binsearch>
    if (lfile == 0)
c0100606:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100609:	85 c0                	test   %eax,%eax
c010060b:	75 0a                	jne    c0100617 <debuginfo_eip+0xd4>
        return -1;
c010060d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100612:	e9 67 02 00 00       	jmp    c010087e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010061a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010061d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100620:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100623:	8b 45 08             	mov    0x8(%ebp),%eax
c0100626:	89 44 24 10          	mov    %eax,0x10(%esp)
c010062a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100631:	00 
c0100632:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100635:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100639:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010063c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100640:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100643:	89 04 24             	mov    %eax,(%esp)
c0100646:	e8 a2 fd ff ff       	call   c01003ed <stab_binsearch>

    if (lfun <= rfun) {
c010064b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010064e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100651:	39 c2                	cmp    %eax,%edx
c0100653:	7f 7c                	jg     c01006d1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100655:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100658:	89 c2                	mov    %eax,%edx
c010065a:	89 d0                	mov    %edx,%eax
c010065c:	01 c0                	add    %eax,%eax
c010065e:	01 d0                	add    %edx,%eax
c0100660:	c1 e0 02             	shl    $0x2,%eax
c0100663:	89 c2                	mov    %eax,%edx
c0100665:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100668:	01 d0                	add    %edx,%eax
c010066a:	8b 10                	mov    (%eax),%edx
c010066c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100672:	29 c1                	sub    %eax,%ecx
c0100674:	89 c8                	mov    %ecx,%eax
c0100676:	39 c2                	cmp    %eax,%edx
c0100678:	73 22                	jae    c010069c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010067a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010067d:	89 c2                	mov    %eax,%edx
c010067f:	89 d0                	mov    %edx,%eax
c0100681:	01 c0                	add    %eax,%eax
c0100683:	01 d0                	add    %edx,%eax
c0100685:	c1 e0 02             	shl    $0x2,%eax
c0100688:	89 c2                	mov    %eax,%edx
c010068a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068d:	01 d0                	add    %edx,%eax
c010068f:	8b 10                	mov    (%eax),%edx
c0100691:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100694:	01 c2                	add    %eax,%edx
c0100696:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100699:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010069c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069f:	89 c2                	mov    %eax,%edx
c01006a1:	89 d0                	mov    %edx,%eax
c01006a3:	01 c0                	add    %eax,%eax
c01006a5:	01 d0                	add    %edx,%eax
c01006a7:	c1 e0 02             	shl    $0x2,%eax
c01006aa:	89 c2                	mov    %eax,%edx
c01006ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006af:	01 d0                	add    %edx,%eax
c01006b1:	8b 50 08             	mov    0x8(%eax),%edx
c01006b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006bd:	8b 40 10             	mov    0x10(%eax),%eax
c01006c0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006cf:	eb 15                	jmp    c01006e6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e9:	8b 40 08             	mov    0x8(%eax),%eax
c01006ec:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006f3:	00 
c01006f4:	89 04 24             	mov    %eax,(%esp)
c01006f7:	e8 2e 55 00 00       	call   c0105c2a <strfind>
c01006fc:	89 c2                	mov    %eax,%edx
c01006fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100701:	8b 40 08             	mov    0x8(%eax),%eax
c0100704:	29 c2                	sub    %eax,%edx
c0100706:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100709:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010070c:	8b 45 08             	mov    0x8(%ebp),%eax
c010070f:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100713:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010071a:	00 
c010071b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010071e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100722:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100725:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100729:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072c:	89 04 24             	mov    %eax,(%esp)
c010072f:	e8 b9 fc ff ff       	call   c01003ed <stab_binsearch>
    if (lline <= rline) {
c0100734:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100737:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010073a:	39 c2                	cmp    %eax,%edx
c010073c:	7f 24                	jg     c0100762 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010073e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100741:	89 c2                	mov    %eax,%edx
c0100743:	89 d0                	mov    %edx,%eax
c0100745:	01 c0                	add    %eax,%eax
c0100747:	01 d0                	add    %edx,%eax
c0100749:	c1 e0 02             	shl    $0x2,%eax
c010074c:	89 c2                	mov    %eax,%edx
c010074e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100751:	01 d0                	add    %edx,%eax
c0100753:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100757:	0f b7 d0             	movzwl %ax,%edx
c010075a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100760:	eb 13                	jmp    c0100775 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100762:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100767:	e9 12 01 00 00       	jmp    c010087e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010076c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076f:	83 e8 01             	sub    $0x1,%eax
c0100772:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100775:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010077b:	39 c2                	cmp    %eax,%edx
c010077d:	7c 56                	jl     c01007d5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100782:	89 c2                	mov    %eax,%edx
c0100784:	89 d0                	mov    %edx,%eax
c0100786:	01 c0                	add    %eax,%eax
c0100788:	01 d0                	add    %edx,%eax
c010078a:	c1 e0 02             	shl    $0x2,%eax
c010078d:	89 c2                	mov    %eax,%edx
c010078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100792:	01 d0                	add    %edx,%eax
c0100794:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100798:	3c 84                	cmp    $0x84,%al
c010079a:	74 39                	je     c01007d5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010079c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079f:	89 c2                	mov    %eax,%edx
c01007a1:	89 d0                	mov    %edx,%eax
c01007a3:	01 c0                	add    %eax,%eax
c01007a5:	01 d0                	add    %edx,%eax
c01007a7:	c1 e0 02             	shl    $0x2,%eax
c01007aa:	89 c2                	mov    %eax,%edx
c01007ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007af:	01 d0                	add    %edx,%eax
c01007b1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b5:	3c 64                	cmp    $0x64,%al
c01007b7:	75 b3                	jne    c010076c <debuginfo_eip+0x229>
c01007b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007bc:	89 c2                	mov    %eax,%edx
c01007be:	89 d0                	mov    %edx,%eax
c01007c0:	01 c0                	add    %eax,%eax
c01007c2:	01 d0                	add    %edx,%eax
c01007c4:	c1 e0 02             	shl    $0x2,%eax
c01007c7:	89 c2                	mov    %eax,%edx
c01007c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007cc:	01 d0                	add    %edx,%eax
c01007ce:	8b 40 08             	mov    0x8(%eax),%eax
c01007d1:	85 c0                	test   %eax,%eax
c01007d3:	74 97                	je     c010076c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007db:	39 c2                	cmp    %eax,%edx
c01007dd:	7c 46                	jl     c0100825 <debuginfo_eip+0x2e2>
c01007df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e2:	89 c2                	mov    %eax,%edx
c01007e4:	89 d0                	mov    %edx,%eax
c01007e6:	01 c0                	add    %eax,%eax
c01007e8:	01 d0                	add    %edx,%eax
c01007ea:	c1 e0 02             	shl    $0x2,%eax
c01007ed:	89 c2                	mov    %eax,%edx
c01007ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f2:	01 d0                	add    %edx,%eax
c01007f4:	8b 10                	mov    (%eax),%edx
c01007f6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007fc:	29 c1                	sub    %eax,%ecx
c01007fe:	89 c8                	mov    %ecx,%eax
c0100800:	39 c2                	cmp    %eax,%edx
c0100802:	73 21                	jae    c0100825 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100804:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100807:	89 c2                	mov    %eax,%edx
c0100809:	89 d0                	mov    %edx,%eax
c010080b:	01 c0                	add    %eax,%eax
c010080d:	01 d0                	add    %edx,%eax
c010080f:	c1 e0 02             	shl    $0x2,%eax
c0100812:	89 c2                	mov    %eax,%edx
c0100814:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100817:	01 d0                	add    %edx,%eax
c0100819:	8b 10                	mov    (%eax),%edx
c010081b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010081e:	01 c2                	add    %eax,%edx
c0100820:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100823:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100825:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100828:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010082b:	39 c2                	cmp    %eax,%edx
c010082d:	7d 4a                	jge    c0100879 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100832:	83 c0 01             	add    $0x1,%eax
c0100835:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100838:	eb 18                	jmp    c0100852 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010083a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010083d:	8b 40 14             	mov    0x14(%eax),%eax
c0100840:	8d 50 01             	lea    0x1(%eax),%edx
c0100843:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100846:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100849:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084c:	83 c0 01             	add    $0x1,%eax
c010084f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100852:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100855:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100858:	39 c2                	cmp    %eax,%edx
c010085a:	7d 1d                	jge    c0100879 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010085c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085f:	89 c2                	mov    %eax,%edx
c0100861:	89 d0                	mov    %edx,%eax
c0100863:	01 c0                	add    %eax,%eax
c0100865:	01 d0                	add    %edx,%eax
c0100867:	c1 e0 02             	shl    $0x2,%eax
c010086a:	89 c2                	mov    %eax,%edx
c010086c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086f:	01 d0                	add    %edx,%eax
c0100871:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100875:	3c a0                	cmp    $0xa0,%al
c0100877:	74 c1                	je     c010083a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100879:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010087e:	c9                   	leave  
c010087f:	c3                   	ret    

c0100880 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100880:	55                   	push   %ebp
c0100881:	89 e5                	mov    %esp,%ebp
c0100883:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100886:	c7 04 24 f6 5f 10 c0 	movl   $0xc0105ff6,(%esp)
c010088d:	e8 ba fa ff ff       	call   c010034c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100892:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100899:	c0 
c010089a:	c7 04 24 0f 60 10 c0 	movl   $0xc010600f,(%esp)
c01008a1:	e8 a6 fa ff ff       	call   c010034c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a6:	c7 44 24 04 3f 5f 10 	movl   $0xc0105f3f,0x4(%esp)
c01008ad:	c0 
c01008ae:	c7 04 24 27 60 10 c0 	movl   $0xc0106027,(%esp)
c01008b5:	e8 92 fa ff ff       	call   c010034c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008ba:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008c1:	c0 
c01008c2:	c7 04 24 3f 60 10 c0 	movl   $0xc010603f,(%esp)
c01008c9:	e8 7e fa ff ff       	call   c010034c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008ce:	c7 44 24 04 c8 89 11 	movl   $0xc01189c8,0x4(%esp)
c01008d5:	c0 
c01008d6:	c7 04 24 57 60 10 c0 	movl   $0xc0106057,(%esp)
c01008dd:	e8 6a fa ff ff       	call   c010034c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e2:	b8 c8 89 11 c0       	mov    $0xc01189c8,%eax
c01008e7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ed:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008f2:	29 c2                	sub    %eax,%edx
c01008f4:	89 d0                	mov    %edx,%eax
c01008f6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008fc:	85 c0                	test   %eax,%eax
c01008fe:	0f 48 c2             	cmovs  %edx,%eax
c0100901:	c1 f8 0a             	sar    $0xa,%eax
c0100904:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100908:	c7 04 24 70 60 10 c0 	movl   $0xc0106070,(%esp)
c010090f:	e8 38 fa ff ff       	call   c010034c <cprintf>
}
c0100914:	c9                   	leave  
c0100915:	c3                   	ret    

c0100916 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100916:	55                   	push   %ebp
c0100917:	89 e5                	mov    %esp,%ebp
c0100919:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100922:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100926:	8b 45 08             	mov    0x8(%ebp),%eax
c0100929:	89 04 24             	mov    %eax,(%esp)
c010092c:	e8 12 fc ff ff       	call   c0100543 <debuginfo_eip>
c0100931:	85 c0                	test   %eax,%eax
c0100933:	74 15                	je     c010094a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100935:	8b 45 08             	mov    0x8(%ebp),%eax
c0100938:	89 44 24 04          	mov    %eax,0x4(%esp)
c010093c:	c7 04 24 9a 60 10 c0 	movl   $0xc010609a,(%esp)
c0100943:	e8 04 fa ff ff       	call   c010034c <cprintf>
c0100948:	eb 6d                	jmp    c01009b7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010094a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100951:	eb 1c                	jmp    c010096f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100953:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100956:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100959:	01 d0                	add    %edx,%eax
c010095b:	0f b6 00             	movzbl (%eax),%eax
c010095e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100964:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100967:	01 ca                	add    %ecx,%edx
c0100969:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010096b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100972:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100975:	7f dc                	jg     c0100953 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100977:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010097d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100980:	01 d0                	add    %edx,%eax
c0100982:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100985:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100988:	8b 55 08             	mov    0x8(%ebp),%edx
c010098b:	89 d1                	mov    %edx,%ecx
c010098d:	29 c1                	sub    %eax,%ecx
c010098f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100992:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100995:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100999:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009a3:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ab:	c7 04 24 b6 60 10 c0 	movl   $0xc01060b6,(%esp)
c01009b2:	e8 95 f9 ff ff       	call   c010034c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b7:	c9                   	leave  
c01009b8:	c3                   	ret    

c01009b9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b9:	55                   	push   %ebp
c01009ba:	89 e5                	mov    %esp,%ebp
c01009bc:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009bf:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c8:	c9                   	leave  
c01009c9:	c3                   	ret    

c01009ca <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ca:	55                   	push   %ebp
c01009cb:	89 e5                	mov    %esp,%ebp
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
c01009cd:	5d                   	pop    %ebp
c01009ce:	c3                   	ret    

c01009cf <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c01009cf:	55                   	push   %ebp
c01009d0:	89 e5                	mov    %esp,%ebp
c01009d2:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c01009d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c01009dc:	eb 0c                	jmp    c01009ea <parse+0x1b>
            *buf ++ = '\0';
c01009de:	8b 45 08             	mov    0x8(%ebp),%eax
c01009e1:	8d 50 01             	lea    0x1(%eax),%edx
c01009e4:	89 55 08             	mov    %edx,0x8(%ebp)
c01009e7:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c01009ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01009ed:	0f b6 00             	movzbl (%eax),%eax
c01009f0:	84 c0                	test   %al,%al
c01009f2:	74 1d                	je     c0100a11 <parse+0x42>
c01009f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01009f7:	0f b6 00             	movzbl (%eax),%eax
c01009fa:	0f be c0             	movsbl %al,%eax
c01009fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a01:	c7 04 24 48 61 10 c0 	movl   $0xc0106148,(%esp)
c0100a08:	e8 ea 51 00 00       	call   c0105bf7 <strchr>
c0100a0d:	85 c0                	test   %eax,%eax
c0100a0f:	75 cd                	jne    c01009de <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100a11:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a14:	0f b6 00             	movzbl (%eax),%eax
c0100a17:	84 c0                	test   %al,%al
c0100a19:	75 02                	jne    c0100a1d <parse+0x4e>
            break;
c0100a1b:	eb 67                	jmp    c0100a84 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100a1d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100a21:	75 14                	jne    c0100a37 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100a23:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100a2a:	00 
c0100a2b:	c7 04 24 4d 61 10 c0 	movl   $0xc010614d,(%esp)
c0100a32:	e8 15 f9 ff ff       	call   c010034c <cprintf>
        }
        argv[argc ++] = buf;
c0100a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a3a:	8d 50 01             	lea    0x1(%eax),%edx
c0100a3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100a40:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100a4a:	01 c2                	add    %eax,%edx
c0100a4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a4f:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100a51:	eb 04                	jmp    c0100a57 <parse+0x88>
            buf ++;
c0100a53:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100a57:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a5a:	0f b6 00             	movzbl (%eax),%eax
c0100a5d:	84 c0                	test   %al,%al
c0100a5f:	74 1d                	je     c0100a7e <parse+0xaf>
c0100a61:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a64:	0f b6 00             	movzbl (%eax),%eax
c0100a67:	0f be c0             	movsbl %al,%eax
c0100a6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a6e:	c7 04 24 48 61 10 c0 	movl   $0xc0106148,(%esp)
c0100a75:	e8 7d 51 00 00       	call   c0105bf7 <strchr>
c0100a7a:	85 c0                	test   %eax,%eax
c0100a7c:	74 d5                	je     c0100a53 <parse+0x84>
            buf ++;
        }
    }
c0100a7e:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a7f:	e9 66 ff ff ff       	jmp    c01009ea <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100a87:	c9                   	leave  
c0100a88:	c3                   	ret    

c0100a89 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100a89:	55                   	push   %ebp
c0100a8a:	89 e5                	mov    %esp,%ebp
c0100a8c:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100a8f:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100a92:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a96:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a99:	89 04 24             	mov    %eax,(%esp)
c0100a9c:	e8 2e ff ff ff       	call   c01009cf <parse>
c0100aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100aa4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100aa8:	75 0a                	jne    c0100ab4 <runcmd+0x2b>
        return 0;
c0100aaa:	b8 00 00 00 00       	mov    $0x0,%eax
c0100aaf:	e9 85 00 00 00       	jmp    c0100b39 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ab4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100abb:	eb 5c                	jmp    c0100b19 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100abd:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100ac0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ac3:	89 d0                	mov    %edx,%eax
c0100ac5:	01 c0                	add    %eax,%eax
c0100ac7:	01 d0                	add    %edx,%eax
c0100ac9:	c1 e0 02             	shl    $0x2,%eax
c0100acc:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100ad1:	8b 00                	mov    (%eax),%eax
c0100ad3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100ad7:	89 04 24             	mov    %eax,(%esp)
c0100ada:	e8 79 50 00 00       	call   c0105b58 <strcmp>
c0100adf:	85 c0                	test   %eax,%eax
c0100ae1:	75 32                	jne    c0100b15 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ae3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ae6:	89 d0                	mov    %edx,%eax
c0100ae8:	01 c0                	add    %eax,%eax
c0100aea:	01 d0                	add    %edx,%eax
c0100aec:	c1 e0 02             	shl    $0x2,%eax
c0100aef:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100af4:	8b 40 08             	mov    0x8(%eax),%eax
c0100af7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100afa:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100afd:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100b00:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100b04:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100b07:	83 c2 04             	add    $0x4,%edx
c0100b0a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100b0e:	89 0c 24             	mov    %ecx,(%esp)
c0100b11:	ff d0                	call   *%eax
c0100b13:	eb 24                	jmp    c0100b39 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b15:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b1c:	83 f8 02             	cmp    $0x2,%eax
c0100b1f:	76 9c                	jbe    c0100abd <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100b21:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100b24:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b28:	c7 04 24 6b 61 10 c0 	movl   $0xc010616b,(%esp)
c0100b2f:	e8 18 f8 ff ff       	call   c010034c <cprintf>
    return 0;
c0100b34:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100b39:	c9                   	leave  
c0100b3a:	c3                   	ret    

c0100b3b <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100b3b:	55                   	push   %ebp
c0100b3c:	89 e5                	mov    %esp,%ebp
c0100b3e:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100b41:	c7 04 24 84 61 10 c0 	movl   $0xc0106184,(%esp)
c0100b48:	e8 ff f7 ff ff       	call   c010034c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100b4d:	c7 04 24 ac 61 10 c0 	movl   $0xc01061ac,(%esp)
c0100b54:	e8 f3 f7 ff ff       	call   c010034c <cprintf>

    if (tf != NULL) {
c0100b59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100b5d:	74 0b                	je     c0100b6a <kmonitor+0x2f>
        print_trapframe(tf);
c0100b5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b62:	89 04 24             	mov    %eax,(%esp)
c0100b65:	e8 30 0e 00 00       	call   c010199a <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100b6a:	c7 04 24 d1 61 10 c0 	movl   $0xc01061d1,(%esp)
c0100b71:	e8 cd f6 ff ff       	call   c0100243 <readline>
c0100b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100b79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b7d:	74 18                	je     c0100b97 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100b7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b82:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b89:	89 04 24             	mov    %eax,(%esp)
c0100b8c:	e8 f8 fe ff ff       	call   c0100a89 <runcmd>
c0100b91:	85 c0                	test   %eax,%eax
c0100b93:	79 02                	jns    c0100b97 <kmonitor+0x5c>
                break;
c0100b95:	eb 02                	jmp    c0100b99 <kmonitor+0x5e>
            }
        }
    }
c0100b97:	eb d1                	jmp    c0100b6a <kmonitor+0x2f>
}
c0100b99:	c9                   	leave  
c0100b9a:	c3                   	ret    

c0100b9b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100b9b:	55                   	push   %ebp
c0100b9c:	89 e5                	mov    %esp,%ebp
c0100b9e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ba1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100ba8:	eb 3f                	jmp    c0100be9 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100baa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bad:	89 d0                	mov    %edx,%eax
c0100baf:	01 c0                	add    %eax,%eax
c0100bb1:	01 d0                	add    %edx,%eax
c0100bb3:	c1 e0 02             	shl    $0x2,%eax
c0100bb6:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100bbb:	8b 48 04             	mov    0x4(%eax),%ecx
c0100bbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bc1:	89 d0                	mov    %edx,%eax
c0100bc3:	01 c0                	add    %eax,%eax
c0100bc5:	01 d0                	add    %edx,%eax
c0100bc7:	c1 e0 02             	shl    $0x2,%eax
c0100bca:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100bcf:	8b 00                	mov    (%eax),%eax
c0100bd1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd9:	c7 04 24 d5 61 10 c0 	movl   $0xc01061d5,(%esp)
c0100be0:	e8 67 f7 ff ff       	call   c010034c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100be5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bec:	83 f8 02             	cmp    $0x2,%eax
c0100bef:	76 b9                	jbe    c0100baa <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100bf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bf6:	c9                   	leave  
c0100bf7:	c3                   	ret    

c0100bf8 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100bf8:	55                   	push   %ebp
c0100bf9:	89 e5                	mov    %esp,%ebp
c0100bfb:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100bfe:	e8 7d fc ff ff       	call   c0100880 <print_kerninfo>
    return 0;
c0100c03:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c08:	c9                   	leave  
c0100c09:	c3                   	ret    

c0100c0a <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100c0a:	55                   	push   %ebp
c0100c0b:	89 e5                	mov    %esp,%ebp
c0100c0d:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100c10:	e8 b5 fd ff ff       	call   c01009ca <print_stackframe>
    return 0;
c0100c15:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c1a:	c9                   	leave  
c0100c1b:	c3                   	ret    

c0100c1c <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100c1c:	55                   	push   %ebp
c0100c1d:	89 e5                	mov    %esp,%ebp
c0100c1f:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100c22:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100c27:	85 c0                	test   %eax,%eax
c0100c29:	74 02                	je     c0100c2d <__panic+0x11>
        goto panic_dead;
c0100c2b:	eb 48                	jmp    c0100c75 <__panic+0x59>
    }
    is_panic = 1;
c0100c2d:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100c34:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100c37:	8d 45 14             	lea    0x14(%ebp),%eax
c0100c3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c40:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100c44:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c4b:	c7 04 24 de 61 10 c0 	movl   $0xc01061de,(%esp)
c0100c52:	e8 f5 f6 ff ff       	call   c010034c <cprintf>
    vcprintf(fmt, ap);
c0100c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c5e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100c61:	89 04 24             	mov    %eax,(%esp)
c0100c64:	e8 b0 f6 ff ff       	call   c0100319 <vcprintf>
    cprintf("\n");
c0100c69:	c7 04 24 fa 61 10 c0 	movl   $0xc01061fa,(%esp)
c0100c70:	e8 d7 f6 ff ff       	call   c010034c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100c75:	e8 85 09 00 00       	call   c01015ff <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100c7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100c81:	e8 b5 fe ff ff       	call   c0100b3b <kmonitor>
    }
c0100c86:	eb f2                	jmp    c0100c7a <__panic+0x5e>

c0100c88 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100c88:	55                   	push   %ebp
c0100c89:	89 e5                	mov    %esp,%ebp
c0100c8b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100c8e:	8d 45 14             	lea    0x14(%ebp),%eax
c0100c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100c94:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c97:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100c9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c9e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ca2:	c7 04 24 fc 61 10 c0 	movl   $0xc01061fc,(%esp)
c0100ca9:	e8 9e f6 ff ff       	call   c010034c <cprintf>
    vcprintf(fmt, ap);
c0100cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cb1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cb5:	8b 45 10             	mov    0x10(%ebp),%eax
c0100cb8:	89 04 24             	mov    %eax,(%esp)
c0100cbb:	e8 59 f6 ff ff       	call   c0100319 <vcprintf>
    cprintf("\n");
c0100cc0:	c7 04 24 fa 61 10 c0 	movl   $0xc01061fa,(%esp)
c0100cc7:	e8 80 f6 ff ff       	call   c010034c <cprintf>
    va_end(ap);
}
c0100ccc:	c9                   	leave  
c0100ccd:	c3                   	ret    

c0100cce <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100cce:	55                   	push   %ebp
c0100ccf:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100cd1:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100cd6:	5d                   	pop    %ebp
c0100cd7:	c3                   	ret    

c0100cd8 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100cd8:	55                   	push   %ebp
c0100cd9:	89 e5                	mov    %esp,%ebp
c0100cdb:	83 ec 28             	sub    $0x28,%esp
c0100cde:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100ce4:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ce8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100cec:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100cf0:	ee                   	out    %al,(%dx)
c0100cf1:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100cf7:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100cfb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100cff:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d03:	ee                   	out    %al,(%dx)
c0100d04:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100d0a:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100d0e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100d12:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100d16:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100d17:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100d1e:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100d21:	c7 04 24 1a 62 10 c0 	movl   $0xc010621a,(%esp)
c0100d28:	e8 1f f6 ff ff       	call   c010034c <cprintf>
    pic_enable(IRQ_TIMER);
c0100d2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d34:	e8 24 09 00 00       	call   c010165d <pic_enable>
}
c0100d39:	c9                   	leave  
c0100d3a:	c3                   	ret    

c0100d3b <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100d3b:	55                   	push   %ebp
c0100d3c:	89 e5                	mov    %esp,%ebp
c0100d3e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100d41:	9c                   	pushf  
c0100d42:	58                   	pop    %eax
c0100d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100d49:	25 00 02 00 00       	and    $0x200,%eax
c0100d4e:	85 c0                	test   %eax,%eax
c0100d50:	74 0c                	je     c0100d5e <__intr_save+0x23>
        intr_disable();
c0100d52:	e8 a8 08 00 00       	call   c01015ff <intr_disable>
        return 1;
c0100d57:	b8 01 00 00 00       	mov    $0x1,%eax
c0100d5c:	eb 05                	jmp    c0100d63 <__intr_save+0x28>
    }
    return 0;
c0100d5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d63:	c9                   	leave  
c0100d64:	c3                   	ret    

c0100d65 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100d65:	55                   	push   %ebp
c0100d66:	89 e5                	mov    %esp,%ebp
c0100d68:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100d6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d6f:	74 05                	je     c0100d76 <__intr_restore+0x11>
        intr_enable();
c0100d71:	e8 83 08 00 00       	call   c01015f9 <intr_enable>
    }
}
c0100d76:	c9                   	leave  
c0100d77:	c3                   	ret    

c0100d78 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100d78:	55                   	push   %ebp
c0100d79:	89 e5                	mov    %esp,%ebp
c0100d7b:	83 ec 10             	sub    $0x10,%esp
c0100d7e:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100d84:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100d88:	89 c2                	mov    %eax,%edx
c0100d8a:	ec                   	in     (%dx),%al
c0100d8b:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100d8e:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100d94:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100d98:	89 c2                	mov    %eax,%edx
c0100d9a:	ec                   	in     (%dx),%al
c0100d9b:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100d9e:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100da4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100da8:	89 c2                	mov    %eax,%edx
c0100daa:	ec                   	in     (%dx),%al
c0100dab:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100dae:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100db4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100db8:	89 c2                	mov    %eax,%edx
c0100dba:	ec                   	in     (%dx),%al
c0100dbb:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100dbe:	c9                   	leave  
c0100dbf:	c3                   	ret    

c0100dc0 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100dc0:	55                   	push   %ebp
c0100dc1:	89 e5                	mov    %esp,%ebp
c0100dc3:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100dc6:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100dcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dd0:	0f b7 00             	movzwl (%eax),%eax
c0100dd3:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dda:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100de2:	0f b7 00             	movzwl (%eax),%eax
c0100de5:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100de9:	74 12                	je     c0100dfd <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100deb:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100df2:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100df9:	b4 03 
c0100dfb:	eb 13                	jmp    c0100e10 <cga_init+0x50>
    } else {
        *cp = was;
c0100dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e00:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e04:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100e07:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100e0e:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100e10:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100e17:	0f b7 c0             	movzwl %ax,%eax
c0100e1a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100e1e:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e22:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100e26:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e2a:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100e2b:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100e32:	83 c0 01             	add    $0x1,%eax
c0100e35:	0f b7 c0             	movzwl %ax,%eax
c0100e38:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e3c:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100e40:	89 c2                	mov    %eax,%edx
c0100e42:	ec                   	in     (%dx),%al
c0100e43:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100e46:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100e4a:	0f b6 c0             	movzbl %al,%eax
c0100e4d:	c1 e0 08             	shl    $0x8,%eax
c0100e50:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100e53:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100e5a:	0f b7 c0             	movzwl %ax,%eax
c0100e5d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100e61:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e65:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100e69:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e6d:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100e6e:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100e75:	83 c0 01             	add    $0x1,%eax
c0100e78:	0f b7 c0             	movzwl %ax,%eax
c0100e7b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e7f:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100e83:	89 c2                	mov    %eax,%edx
c0100e85:	ec                   	in     (%dx),%al
c0100e86:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100e89:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100e8d:	0f b6 c0             	movzbl %al,%eax
c0100e90:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e96:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e9e:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100ea4:	c9                   	leave  
c0100ea5:	c3                   	ret    

c0100ea6 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100ea6:	55                   	push   %ebp
c0100ea7:	89 e5                	mov    %esp,%ebp
c0100ea9:	83 ec 48             	sub    $0x48,%esp
c0100eac:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100eb2:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100eb6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100eba:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100ebe:	ee                   	out    %al,(%dx)
c0100ebf:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100ec5:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100ec9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ecd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ed1:	ee                   	out    %al,(%dx)
c0100ed2:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100ed8:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100edc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ee0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100ee4:	ee                   	out    %al,(%dx)
c0100ee5:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100eeb:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100eef:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100ef3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100ef7:	ee                   	out    %al,(%dx)
c0100ef8:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100efe:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100f02:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f06:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f0a:	ee                   	out    %al,(%dx)
c0100f0b:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100f11:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100f15:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100f19:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100f1d:	ee                   	out    %al,(%dx)
c0100f1e:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100f24:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100f28:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f2c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100f30:	ee                   	out    %al,(%dx)
c0100f31:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f37:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100f3b:	89 c2                	mov    %eax,%edx
c0100f3d:	ec                   	in     (%dx),%al
c0100f3e:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100f41:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100f45:	3c ff                	cmp    $0xff,%al
c0100f47:	0f 95 c0             	setne  %al
c0100f4a:	0f b6 c0             	movzbl %al,%eax
c0100f4d:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100f52:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f58:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0100f5c:	89 c2                	mov    %eax,%edx
c0100f5e:	ec                   	in     (%dx),%al
c0100f5f:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0100f62:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0100f68:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0100f6c:	89 c2                	mov    %eax,%edx
c0100f6e:	ec                   	in     (%dx),%al
c0100f6f:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0100f72:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0100f77:	85 c0                	test   %eax,%eax
c0100f79:	74 0c                	je     c0100f87 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0100f7b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0100f82:	e8 d6 06 00 00       	call   c010165d <pic_enable>
    }
}
c0100f87:	c9                   	leave  
c0100f88:	c3                   	ret    

c0100f89 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0100f89:	55                   	push   %ebp
c0100f8a:	89 e5                	mov    %esp,%ebp
c0100f8c:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0100f8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0100f96:	eb 09                	jmp    c0100fa1 <lpt_putc_sub+0x18>
        delay();
c0100f98:	e8 db fd ff ff       	call   c0100d78 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0100f9d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0100fa1:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0100fa7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100fab:	89 c2                	mov    %eax,%edx
c0100fad:	ec                   	in     (%dx),%al
c0100fae:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0100fb1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0100fb5:	84 c0                	test   %al,%al
c0100fb7:	78 09                	js     c0100fc2 <lpt_putc_sub+0x39>
c0100fb9:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0100fc0:	7e d6                	jle    c0100f98 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0100fc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fc5:	0f b6 c0             	movzbl %al,%eax
c0100fc8:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0100fce:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fd1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100fd5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100fd9:	ee                   	out    %al,(%dx)
c0100fda:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0100fe0:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0100fe4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fe8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fec:	ee                   	out    %al,(%dx)
c0100fed:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c0100ff3:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c0100ff7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ffb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fff:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101000:	c9                   	leave  
c0101001:	c3                   	ret    

c0101002 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101002:	55                   	push   %ebp
c0101003:	89 e5                	mov    %esp,%ebp
c0101005:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101008:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010100c:	74 0d                	je     c010101b <lpt_putc+0x19>
        lpt_putc_sub(c);
c010100e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101011:	89 04 24             	mov    %eax,(%esp)
c0101014:	e8 70 ff ff ff       	call   c0100f89 <lpt_putc_sub>
c0101019:	eb 24                	jmp    c010103f <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c010101b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101022:	e8 62 ff ff ff       	call   c0100f89 <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101027:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010102e:	e8 56 ff ff ff       	call   c0100f89 <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101033:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010103a:	e8 4a ff ff ff       	call   c0100f89 <lpt_putc_sub>
    }
}
c010103f:	c9                   	leave  
c0101040:	c3                   	ret    

c0101041 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101041:	55                   	push   %ebp
c0101042:	89 e5                	mov    %esp,%ebp
c0101044:	53                   	push   %ebx
c0101045:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101048:	8b 45 08             	mov    0x8(%ebp),%eax
c010104b:	b0 00                	mov    $0x0,%al
c010104d:	85 c0                	test   %eax,%eax
c010104f:	75 07                	jne    c0101058 <cga_putc+0x17>
        c |= 0x0700;
c0101051:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101058:	8b 45 08             	mov    0x8(%ebp),%eax
c010105b:	0f b6 c0             	movzbl %al,%eax
c010105e:	83 f8 0a             	cmp    $0xa,%eax
c0101061:	74 4c                	je     c01010af <cga_putc+0x6e>
c0101063:	83 f8 0d             	cmp    $0xd,%eax
c0101066:	74 57                	je     c01010bf <cga_putc+0x7e>
c0101068:	83 f8 08             	cmp    $0x8,%eax
c010106b:	0f 85 88 00 00 00    	jne    c01010f9 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101071:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101078:	66 85 c0             	test   %ax,%ax
c010107b:	74 30                	je     c01010ad <cga_putc+0x6c>
            crt_pos --;
c010107d:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101084:	83 e8 01             	sub    $0x1,%eax
c0101087:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010108d:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101092:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101099:	0f b7 d2             	movzwl %dx,%edx
c010109c:	01 d2                	add    %edx,%edx
c010109e:	01 c2                	add    %eax,%edx
c01010a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01010a3:	b0 00                	mov    $0x0,%al
c01010a5:	83 c8 20             	or     $0x20,%eax
c01010a8:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01010ab:	eb 72                	jmp    c010111f <cga_putc+0xde>
c01010ad:	eb 70                	jmp    c010111f <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c01010af:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01010b6:	83 c0 50             	add    $0x50,%eax
c01010b9:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01010bf:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c01010c6:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c01010cd:	0f b7 c1             	movzwl %cx,%eax
c01010d0:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01010d6:	c1 e8 10             	shr    $0x10,%eax
c01010d9:	89 c2                	mov    %eax,%edx
c01010db:	66 c1 ea 06          	shr    $0x6,%dx
c01010df:	89 d0                	mov    %edx,%eax
c01010e1:	c1 e0 02             	shl    $0x2,%eax
c01010e4:	01 d0                	add    %edx,%eax
c01010e6:	c1 e0 04             	shl    $0x4,%eax
c01010e9:	29 c1                	sub    %eax,%ecx
c01010eb:	89 ca                	mov    %ecx,%edx
c01010ed:	89 d8                	mov    %ebx,%eax
c01010ef:	29 d0                	sub    %edx,%eax
c01010f1:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01010f7:	eb 26                	jmp    c010111f <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01010f9:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01010ff:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101106:	8d 50 01             	lea    0x1(%eax),%edx
c0101109:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c0101110:	0f b7 c0             	movzwl %ax,%eax
c0101113:	01 c0                	add    %eax,%eax
c0101115:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101118:	8b 45 08             	mov    0x8(%ebp),%eax
c010111b:	66 89 02             	mov    %ax,(%edx)
        break;
c010111e:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c010111f:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101126:	66 3d cf 07          	cmp    $0x7cf,%ax
c010112a:	76 5b                	jbe    c0101187 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c010112c:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101131:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101137:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010113c:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101143:	00 
c0101144:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101148:	89 04 24             	mov    %eax,(%esp)
c010114b:	e8 a5 4c 00 00       	call   c0105df5 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101150:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101157:	eb 15                	jmp    c010116e <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101159:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010115e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101161:	01 d2                	add    %edx,%edx
c0101163:	01 d0                	add    %edx,%eax
c0101165:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010116a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010116e:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101175:	7e e2                	jle    c0101159 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101177:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010117e:	83 e8 50             	sub    $0x50,%eax
c0101181:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101187:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010118e:	0f b7 c0             	movzwl %ax,%eax
c0101191:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101195:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101199:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010119d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01011a1:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c01011a2:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011a9:	66 c1 e8 08          	shr    $0x8,%ax
c01011ad:	0f b6 c0             	movzbl %al,%eax
c01011b0:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01011b7:	83 c2 01             	add    $0x1,%edx
c01011ba:	0f b7 d2             	movzwl %dx,%edx
c01011bd:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c01011c1:	88 45 ed             	mov    %al,-0x13(%ebp)
c01011c4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01011c8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01011cc:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01011cd:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c01011d4:	0f b7 c0             	movzwl %ax,%eax
c01011d7:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01011db:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01011df:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01011e3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01011e7:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01011e8:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011ef:	0f b6 c0             	movzbl %al,%eax
c01011f2:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01011f9:	83 c2 01             	add    $0x1,%edx
c01011fc:	0f b7 d2             	movzwl %dx,%edx
c01011ff:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101203:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101206:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010120a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010120e:	ee                   	out    %al,(%dx)
}
c010120f:	83 c4 34             	add    $0x34,%esp
c0101212:	5b                   	pop    %ebx
c0101213:	5d                   	pop    %ebp
c0101214:	c3                   	ret    

c0101215 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101215:	55                   	push   %ebp
c0101216:	89 e5                	mov    %esp,%ebp
c0101218:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010121b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101222:	eb 09                	jmp    c010122d <serial_putc_sub+0x18>
        delay();
c0101224:	e8 4f fb ff ff       	call   c0100d78 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101229:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010122d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101233:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101237:	89 c2                	mov    %eax,%edx
c0101239:	ec                   	in     (%dx),%al
c010123a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010123d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101241:	0f b6 c0             	movzbl %al,%eax
c0101244:	83 e0 20             	and    $0x20,%eax
c0101247:	85 c0                	test   %eax,%eax
c0101249:	75 09                	jne    c0101254 <serial_putc_sub+0x3f>
c010124b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101252:	7e d0                	jle    c0101224 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101254:	8b 45 08             	mov    0x8(%ebp),%eax
c0101257:	0f b6 c0             	movzbl %al,%eax
c010125a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101260:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101263:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101267:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010126b:	ee                   	out    %al,(%dx)
}
c010126c:	c9                   	leave  
c010126d:	c3                   	ret    

c010126e <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010126e:	55                   	push   %ebp
c010126f:	89 e5                	mov    %esp,%ebp
c0101271:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101274:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101278:	74 0d                	je     c0101287 <serial_putc+0x19>
        serial_putc_sub(c);
c010127a:	8b 45 08             	mov    0x8(%ebp),%eax
c010127d:	89 04 24             	mov    %eax,(%esp)
c0101280:	e8 90 ff ff ff       	call   c0101215 <serial_putc_sub>
c0101285:	eb 24                	jmp    c01012ab <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101287:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010128e:	e8 82 ff ff ff       	call   c0101215 <serial_putc_sub>
        serial_putc_sub(' ');
c0101293:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010129a:	e8 76 ff ff ff       	call   c0101215 <serial_putc_sub>
        serial_putc_sub('\b');
c010129f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01012a6:	e8 6a ff ff ff       	call   c0101215 <serial_putc_sub>
    }
}
c01012ab:	c9                   	leave  
c01012ac:	c3                   	ret    

c01012ad <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01012ad:	55                   	push   %ebp
c01012ae:	89 e5                	mov    %esp,%ebp
c01012b0:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01012b3:	eb 33                	jmp    c01012e8 <cons_intr+0x3b>
        if (c != 0) {
c01012b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01012b9:	74 2d                	je     c01012e8 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c01012bb:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c01012c0:	8d 50 01             	lea    0x1(%eax),%edx
c01012c3:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c01012c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01012cc:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01012d2:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c01012d7:	3d 00 02 00 00       	cmp    $0x200,%eax
c01012dc:	75 0a                	jne    c01012e8 <cons_intr+0x3b>
                cons.wpos = 0;
c01012de:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c01012e5:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01012e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01012eb:	ff d0                	call   *%eax
c01012ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01012f0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01012f4:	75 bf                	jne    c01012b5 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01012f6:	c9                   	leave  
c01012f7:	c3                   	ret    

c01012f8 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01012f8:	55                   	push   %ebp
c01012f9:	89 e5                	mov    %esp,%ebp
c01012fb:	83 ec 10             	sub    $0x10,%esp
c01012fe:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101304:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101308:	89 c2                	mov    %eax,%edx
c010130a:	ec                   	in     (%dx),%al
c010130b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010130e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101312:	0f b6 c0             	movzbl %al,%eax
c0101315:	83 e0 01             	and    $0x1,%eax
c0101318:	85 c0                	test   %eax,%eax
c010131a:	75 07                	jne    c0101323 <serial_proc_data+0x2b>
        return -1;
c010131c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101321:	eb 2a                	jmp    c010134d <serial_proc_data+0x55>
c0101323:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101329:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010132d:	89 c2                	mov    %eax,%edx
c010132f:	ec                   	in     (%dx),%al
c0101330:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101333:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101337:	0f b6 c0             	movzbl %al,%eax
c010133a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c010133d:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101341:	75 07                	jne    c010134a <serial_proc_data+0x52>
        c = '\b';
c0101343:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010134a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010134d:	c9                   	leave  
c010134e:	c3                   	ret    

c010134f <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010134f:	55                   	push   %ebp
c0101350:	89 e5                	mov    %esp,%ebp
c0101352:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101355:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010135a:	85 c0                	test   %eax,%eax
c010135c:	74 0c                	je     c010136a <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010135e:	c7 04 24 f8 12 10 c0 	movl   $0xc01012f8,(%esp)
c0101365:	e8 43 ff ff ff       	call   c01012ad <cons_intr>
    }
}
c010136a:	c9                   	leave  
c010136b:	c3                   	ret    

c010136c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010136c:	55                   	push   %ebp
c010136d:	89 e5                	mov    %esp,%ebp
c010136f:	83 ec 38             	sub    $0x38,%esp
c0101372:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101378:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010137c:	89 c2                	mov    %eax,%edx
c010137e:	ec                   	in     (%dx),%al
c010137f:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101382:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101386:	0f b6 c0             	movzbl %al,%eax
c0101389:	83 e0 01             	and    $0x1,%eax
c010138c:	85 c0                	test   %eax,%eax
c010138e:	75 0a                	jne    c010139a <kbd_proc_data+0x2e>
        return -1;
c0101390:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101395:	e9 59 01 00 00       	jmp    c01014f3 <kbd_proc_data+0x187>
c010139a:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013a0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01013a4:	89 c2                	mov    %eax,%edx
c01013a6:	ec                   	in     (%dx),%al
c01013a7:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c01013aa:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c01013ae:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01013b1:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c01013b5:	75 17                	jne    c01013ce <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c01013b7:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01013bc:	83 c8 40             	or     $0x40,%eax
c01013bf:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01013c4:	b8 00 00 00 00       	mov    $0x0,%eax
c01013c9:	e9 25 01 00 00       	jmp    c01014f3 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c01013ce:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013d2:	84 c0                	test   %al,%al
c01013d4:	79 47                	jns    c010141d <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01013d6:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01013db:	83 e0 40             	and    $0x40,%eax
c01013de:	85 c0                	test   %eax,%eax
c01013e0:	75 09                	jne    c01013eb <kbd_proc_data+0x7f>
c01013e2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013e6:	83 e0 7f             	and    $0x7f,%eax
c01013e9:	eb 04                	jmp    c01013ef <kbd_proc_data+0x83>
c01013eb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013ef:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01013f2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013f6:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01013fd:	83 c8 40             	or     $0x40,%eax
c0101400:	0f b6 c0             	movzbl %al,%eax
c0101403:	f7 d0                	not    %eax
c0101405:	89 c2                	mov    %eax,%edx
c0101407:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010140c:	21 d0                	and    %edx,%eax
c010140e:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101413:	b8 00 00 00 00       	mov    $0x0,%eax
c0101418:	e9 d6 00 00 00       	jmp    c01014f3 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c010141d:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101422:	83 e0 40             	and    $0x40,%eax
c0101425:	85 c0                	test   %eax,%eax
c0101427:	74 11                	je     c010143a <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101429:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c010142d:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101432:	83 e0 bf             	and    $0xffffffbf,%eax
c0101435:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c010143a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010143e:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c0101445:	0f b6 d0             	movzbl %al,%edx
c0101448:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010144d:	09 d0                	or     %edx,%eax
c010144f:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c0101454:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101458:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c010145f:	0f b6 d0             	movzbl %al,%edx
c0101462:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101467:	31 d0                	xor    %edx,%eax
c0101469:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c010146e:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101473:	83 e0 03             	and    $0x3,%eax
c0101476:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c010147d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101481:	01 d0                	add    %edx,%eax
c0101483:	0f b6 00             	movzbl (%eax),%eax
c0101486:	0f b6 c0             	movzbl %al,%eax
c0101489:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010148c:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101491:	83 e0 08             	and    $0x8,%eax
c0101494:	85 c0                	test   %eax,%eax
c0101496:	74 22                	je     c01014ba <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101498:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010149c:	7e 0c                	jle    c01014aa <kbd_proc_data+0x13e>
c010149e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c01014a2:	7f 06                	jg     c01014aa <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c01014a4:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c01014a8:	eb 10                	jmp    c01014ba <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c01014aa:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c01014ae:	7e 0a                	jle    c01014ba <kbd_proc_data+0x14e>
c01014b0:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c01014b4:	7f 04                	jg     c01014ba <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c01014b6:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c01014ba:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014bf:	f7 d0                	not    %eax
c01014c1:	83 e0 06             	and    $0x6,%eax
c01014c4:	85 c0                	test   %eax,%eax
c01014c6:	75 28                	jne    c01014f0 <kbd_proc_data+0x184>
c01014c8:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01014cf:	75 1f                	jne    c01014f0 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c01014d1:	c7 04 24 35 62 10 c0 	movl   $0xc0106235,(%esp)
c01014d8:	e8 6f ee ff ff       	call   c010034c <cprintf>
c01014dd:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01014e3:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01014e7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01014eb:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01014ef:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01014f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01014f3:	c9                   	leave  
c01014f4:	c3                   	ret    

c01014f5 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01014f5:	55                   	push   %ebp
c01014f6:	89 e5                	mov    %esp,%ebp
c01014f8:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01014fb:	c7 04 24 6c 13 10 c0 	movl   $0xc010136c,(%esp)
c0101502:	e8 a6 fd ff ff       	call   c01012ad <cons_intr>
}
c0101507:	c9                   	leave  
c0101508:	c3                   	ret    

c0101509 <kbd_init>:

static void
kbd_init(void) {
c0101509:	55                   	push   %ebp
c010150a:	89 e5                	mov    %esp,%ebp
c010150c:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c010150f:	e8 e1 ff ff ff       	call   c01014f5 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101514:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010151b:	e8 3d 01 00 00       	call   c010165d <pic_enable>
}
c0101520:	c9                   	leave  
c0101521:	c3                   	ret    

c0101522 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101522:	55                   	push   %ebp
c0101523:	89 e5                	mov    %esp,%ebp
c0101525:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101528:	e8 93 f8 ff ff       	call   c0100dc0 <cga_init>
    serial_init();
c010152d:	e8 74 f9 ff ff       	call   c0100ea6 <serial_init>
    kbd_init();
c0101532:	e8 d2 ff ff ff       	call   c0101509 <kbd_init>
    if (!serial_exists) {
c0101537:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010153c:	85 c0                	test   %eax,%eax
c010153e:	75 0c                	jne    c010154c <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101540:	c7 04 24 41 62 10 c0 	movl   $0xc0106241,(%esp)
c0101547:	e8 00 ee ff ff       	call   c010034c <cprintf>
    }
}
c010154c:	c9                   	leave  
c010154d:	c3                   	ret    

c010154e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010154e:	55                   	push   %ebp
c010154f:	89 e5                	mov    %esp,%ebp
c0101551:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101554:	e8 e2 f7 ff ff       	call   c0100d3b <__intr_save>
c0101559:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010155c:	8b 45 08             	mov    0x8(%ebp),%eax
c010155f:	89 04 24             	mov    %eax,(%esp)
c0101562:	e8 9b fa ff ff       	call   c0101002 <lpt_putc>
        cga_putc(c);
c0101567:	8b 45 08             	mov    0x8(%ebp),%eax
c010156a:	89 04 24             	mov    %eax,(%esp)
c010156d:	e8 cf fa ff ff       	call   c0101041 <cga_putc>
        serial_putc(c);
c0101572:	8b 45 08             	mov    0x8(%ebp),%eax
c0101575:	89 04 24             	mov    %eax,(%esp)
c0101578:	e8 f1 fc ff ff       	call   c010126e <serial_putc>
    }
    local_intr_restore(intr_flag);
c010157d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101580:	89 04 24             	mov    %eax,(%esp)
c0101583:	e8 dd f7 ff ff       	call   c0100d65 <__intr_restore>
}
c0101588:	c9                   	leave  
c0101589:	c3                   	ret    

c010158a <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010158a:	55                   	push   %ebp
c010158b:	89 e5                	mov    %esp,%ebp
c010158d:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101590:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101597:	e8 9f f7 ff ff       	call   c0100d3b <__intr_save>
c010159c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010159f:	e8 ab fd ff ff       	call   c010134f <serial_intr>
        kbd_intr();
c01015a4:	e8 4c ff ff ff       	call   c01014f5 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c01015a9:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c01015af:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c01015b4:	39 c2                	cmp    %eax,%edx
c01015b6:	74 31                	je     c01015e9 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c01015b8:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c01015bd:	8d 50 01             	lea    0x1(%eax),%edx
c01015c0:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c01015c6:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c01015cd:	0f b6 c0             	movzbl %al,%eax
c01015d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01015d3:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c01015d8:	3d 00 02 00 00       	cmp    $0x200,%eax
c01015dd:	75 0a                	jne    c01015e9 <cons_getc+0x5f>
                cons.rpos = 0;
c01015df:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c01015e6:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01015e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01015ec:	89 04 24             	mov    %eax,(%esp)
c01015ef:	e8 71 f7 ff ff       	call   c0100d65 <__intr_restore>
    return c;
c01015f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015f7:	c9                   	leave  
c01015f8:	c3                   	ret    

c01015f9 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01015f9:	55                   	push   %ebp
c01015fa:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01015fc:	fb                   	sti    
    sti();
}
c01015fd:	5d                   	pop    %ebp
c01015fe:	c3                   	ret    

c01015ff <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01015ff:	55                   	push   %ebp
c0101600:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101602:	fa                   	cli    
    cli();
}
c0101603:	5d                   	pop    %ebp
c0101604:	c3                   	ret    

c0101605 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101605:	55                   	push   %ebp
c0101606:	89 e5                	mov    %esp,%ebp
c0101608:	83 ec 14             	sub    $0x14,%esp
c010160b:	8b 45 08             	mov    0x8(%ebp),%eax
c010160e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101612:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101616:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c010161c:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c0101621:	85 c0                	test   %eax,%eax
c0101623:	74 36                	je     c010165b <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101625:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101629:	0f b6 c0             	movzbl %al,%eax
c010162c:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101632:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101635:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101639:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010163d:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c010163e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101642:	66 c1 e8 08          	shr    $0x8,%ax
c0101646:	0f b6 c0             	movzbl %al,%eax
c0101649:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010164f:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101652:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101656:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010165a:	ee                   	out    %al,(%dx)
    }
}
c010165b:	c9                   	leave  
c010165c:	c3                   	ret    

c010165d <pic_enable>:

void
pic_enable(unsigned int irq) {
c010165d:	55                   	push   %ebp
c010165e:	89 e5                	mov    %esp,%ebp
c0101660:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101663:	8b 45 08             	mov    0x8(%ebp),%eax
c0101666:	ba 01 00 00 00       	mov    $0x1,%edx
c010166b:	89 c1                	mov    %eax,%ecx
c010166d:	d3 e2                	shl    %cl,%edx
c010166f:	89 d0                	mov    %edx,%eax
c0101671:	f7 d0                	not    %eax
c0101673:	89 c2                	mov    %eax,%edx
c0101675:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010167c:	21 d0                	and    %edx,%eax
c010167e:	0f b7 c0             	movzwl %ax,%eax
c0101681:	89 04 24             	mov    %eax,(%esp)
c0101684:	e8 7c ff ff ff       	call   c0101605 <pic_setmask>
}
c0101689:	c9                   	leave  
c010168a:	c3                   	ret    

c010168b <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010168b:	55                   	push   %ebp
c010168c:	89 e5                	mov    %esp,%ebp
c010168e:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101691:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101698:	00 00 00 
c010169b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016a1:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c01016a5:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016a9:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016ad:	ee                   	out    %al,(%dx)
c01016ae:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016b4:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c01016b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016bc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016c0:	ee                   	out    %al,(%dx)
c01016c1:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01016c7:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c01016cb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01016cf:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01016d3:	ee                   	out    %al,(%dx)
c01016d4:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c01016da:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c01016de:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01016e2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01016e6:	ee                   	out    %al,(%dx)
c01016e7:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01016ed:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01016f1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01016f5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01016f9:	ee                   	out    %al,(%dx)
c01016fa:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c0101700:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0101704:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101708:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010170c:	ee                   	out    %al,(%dx)
c010170d:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0101713:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0101717:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010171b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010171f:	ee                   	out    %al,(%dx)
c0101720:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0101726:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c010172a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010172e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101732:	ee                   	out    %al,(%dx)
c0101733:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0101739:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c010173d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101741:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101745:	ee                   	out    %al,(%dx)
c0101746:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010174c:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101750:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101754:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101758:	ee                   	out    %al,(%dx)
c0101759:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010175f:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101763:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101767:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010176b:	ee                   	out    %al,(%dx)
c010176c:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101772:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101776:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010177a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010177e:	ee                   	out    %al,(%dx)
c010177f:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101785:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101789:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010178d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101791:	ee                   	out    %al,(%dx)
c0101792:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101798:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c010179c:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017a0:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01017a4:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01017a5:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c01017ac:	66 83 f8 ff          	cmp    $0xffff,%ax
c01017b0:	74 12                	je     c01017c4 <pic_init+0x139>
        pic_setmask(irq_mask);
c01017b2:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c01017b9:	0f b7 c0             	movzwl %ax,%eax
c01017bc:	89 04 24             	mov    %eax,(%esp)
c01017bf:	e8 41 fe ff ff       	call   c0101605 <pic_setmask>
    }
}
c01017c4:	c9                   	leave  
c01017c5:	c3                   	ret    

c01017c6 <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
c01017c6:	55                   	push   %ebp
c01017c7:	89 e5                	mov    %esp,%ebp
c01017c9:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01017cc:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01017d3:	00 
c01017d4:	c7 04 24 60 62 10 c0 	movl   $0xc0106260,(%esp)
c01017db:	e8 6c eb ff ff       	call   c010034c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c01017e0:	c9                   	leave  
c01017e1:	c3                   	ret    

c01017e2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01017e2:	55                   	push   %ebp
c01017e3:	89 e5                	mov    %esp,%ebp
c01017e5:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
     extern uintptr_t __vectors[];
     int i;
     for (i = 0; i < sizeof(idt)/sizeof(struct gatedesc); i++)
c01017e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01017ef:	e9 c3 00 00 00       	jmp    c01018b7 <idt_init+0xd5>
     	SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01017f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017f7:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01017fe:	89 c2                	mov    %eax,%edx
c0101800:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101803:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c010180a:	c0 
c010180b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010180e:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c0101815:	c0 08 00 
c0101818:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010181b:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c0101822:	c0 
c0101823:	83 e2 e0             	and    $0xffffffe0,%edx
c0101826:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c010182d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101830:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c0101837:	c0 
c0101838:	83 e2 1f             	and    $0x1f,%edx
c010183b:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101842:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101845:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010184c:	c0 
c010184d:	83 e2 f0             	and    $0xfffffff0,%edx
c0101850:	83 ca 0e             	or     $0xe,%edx
c0101853:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010185a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010185d:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101864:	c0 
c0101865:	83 e2 ef             	and    $0xffffffef,%edx
c0101868:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010186f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101872:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101879:	c0 
c010187a:	83 e2 9f             	and    $0xffffff9f,%edx
c010187d:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101884:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101887:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010188e:	c0 
c010188f:	83 ca 80             	or     $0xffffff80,%edx
c0101892:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101899:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010189c:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018a3:	c1 e8 10             	shr    $0x10,%eax
c01018a6:	89 c2                	mov    %eax,%edx
c01018a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ab:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c01018b2:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
     extern uintptr_t __vectors[];
     int i;
     for (i = 0; i < sizeof(idt)/sizeof(struct gatedesc); i++)
c01018b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01018b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ba:	3d ff 00 00 00       	cmp    $0xff,%eax
c01018bf:	0f 86 2f ff ff ff    	jbe    c01017f4 <idt_init+0x12>
     	SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
     SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_KERNEL);
c01018c5:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c01018ca:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c01018d0:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c01018d7:	08 00 
c01018d9:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c01018e0:	83 e0 e0             	and    $0xffffffe0,%eax
c01018e3:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01018e8:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c01018ef:	83 e0 1f             	and    $0x1f,%eax
c01018f2:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01018f7:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01018fe:	83 e0 f0             	and    $0xfffffff0,%eax
c0101901:	83 c8 0e             	or     $0xe,%eax
c0101904:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101909:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c0101910:	83 e0 ef             	and    $0xffffffef,%eax
c0101913:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101918:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c010191f:	83 e0 9f             	and    $0xffffff9f,%eax
c0101922:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101927:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c010192e:	83 c8 80             	or     $0xffffff80,%eax
c0101931:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101936:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c010193b:	c1 e8 10             	shr    $0x10,%eax
c010193e:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c0101944:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c010194b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010194e:	0f 01 18             	lidtl  (%eax)
     lidt(&idt_pd);
}
c0101951:	c9                   	leave  
c0101952:	c3                   	ret    

c0101953 <trapname>:

static const char *
trapname(int trapno) {
c0101953:	55                   	push   %ebp
c0101954:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101956:	8b 45 08             	mov    0x8(%ebp),%eax
c0101959:	83 f8 13             	cmp    $0x13,%eax
c010195c:	77 0c                	ja     c010196a <trapname+0x17>
        return excnames[trapno];
c010195e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101961:	8b 04 85 c0 65 10 c0 	mov    -0x3fef9a40(,%eax,4),%eax
c0101968:	eb 18                	jmp    c0101982 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c010196a:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c010196e:	7e 0d                	jle    c010197d <trapname+0x2a>
c0101970:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101974:	7f 07                	jg     c010197d <trapname+0x2a>
        return "Hardware Interrupt";
c0101976:	b8 6a 62 10 c0       	mov    $0xc010626a,%eax
c010197b:	eb 05                	jmp    c0101982 <trapname+0x2f>
    }
    return "(unknown trap)";
c010197d:	b8 7d 62 10 c0       	mov    $0xc010627d,%eax
}
c0101982:	5d                   	pop    %ebp
c0101983:	c3                   	ret    

c0101984 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101984:	55                   	push   %ebp
c0101985:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101987:	8b 45 08             	mov    0x8(%ebp),%eax
c010198a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010198e:	66 83 f8 08          	cmp    $0x8,%ax
c0101992:	0f 94 c0             	sete   %al
c0101995:	0f b6 c0             	movzbl %al,%eax
}
c0101998:	5d                   	pop    %ebp
c0101999:	c3                   	ret    

c010199a <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c010199a:	55                   	push   %ebp
c010199b:	89 e5                	mov    %esp,%ebp
c010199d:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01019a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01019a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019a7:	c7 04 24 be 62 10 c0 	movl   $0xc01062be,(%esp)
c01019ae:	e8 99 e9 ff ff       	call   c010034c <cprintf>
    print_regs(&tf->tf_regs);
c01019b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01019b6:	89 04 24             	mov    %eax,(%esp)
c01019b9:	e8 a1 01 00 00       	call   c0101b5f <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01019be:	8b 45 08             	mov    0x8(%ebp),%eax
c01019c1:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01019c5:	0f b7 c0             	movzwl %ax,%eax
c01019c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019cc:	c7 04 24 cf 62 10 c0 	movl   $0xc01062cf,(%esp)
c01019d3:	e8 74 e9 ff ff       	call   c010034c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01019d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01019db:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01019df:	0f b7 c0             	movzwl %ax,%eax
c01019e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019e6:	c7 04 24 e2 62 10 c0 	movl   $0xc01062e2,(%esp)
c01019ed:	e8 5a e9 ff ff       	call   c010034c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c01019f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01019f5:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c01019f9:	0f b7 c0             	movzwl %ax,%eax
c01019fc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a00:	c7 04 24 f5 62 10 c0 	movl   $0xc01062f5,(%esp)
c0101a07:	e8 40 e9 ff ff       	call   c010034c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101a0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a0f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101a13:	0f b7 c0             	movzwl %ax,%eax
c0101a16:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a1a:	c7 04 24 08 63 10 c0 	movl   $0xc0106308,(%esp)
c0101a21:	e8 26 e9 ff ff       	call   c010034c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101a26:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a29:	8b 40 30             	mov    0x30(%eax),%eax
c0101a2c:	89 04 24             	mov    %eax,(%esp)
c0101a2f:	e8 1f ff ff ff       	call   c0101953 <trapname>
c0101a34:	8b 55 08             	mov    0x8(%ebp),%edx
c0101a37:	8b 52 30             	mov    0x30(%edx),%edx
c0101a3a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101a3e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101a42:	c7 04 24 1b 63 10 c0 	movl   $0xc010631b,(%esp)
c0101a49:	e8 fe e8 ff ff       	call   c010034c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101a4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a51:	8b 40 34             	mov    0x34(%eax),%eax
c0101a54:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a58:	c7 04 24 2d 63 10 c0 	movl   $0xc010632d,(%esp)
c0101a5f:	e8 e8 e8 ff ff       	call   c010034c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101a64:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a67:	8b 40 38             	mov    0x38(%eax),%eax
c0101a6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a6e:	c7 04 24 3c 63 10 c0 	movl   $0xc010633c,(%esp)
c0101a75:	e8 d2 e8 ff ff       	call   c010034c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101a7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a7d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a81:	0f b7 c0             	movzwl %ax,%eax
c0101a84:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a88:	c7 04 24 4b 63 10 c0 	movl   $0xc010634b,(%esp)
c0101a8f:	e8 b8 e8 ff ff       	call   c010034c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a97:	8b 40 40             	mov    0x40(%eax),%eax
c0101a9a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a9e:	c7 04 24 5e 63 10 c0 	movl   $0xc010635e,(%esp)
c0101aa5:	e8 a2 e8 ff ff       	call   c010034c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101aaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101ab1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101ab8:	eb 3e                	jmp    c0101af8 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101aba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abd:	8b 50 40             	mov    0x40(%eax),%edx
c0101ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101ac3:	21 d0                	and    %edx,%eax
c0101ac5:	85 c0                	test   %eax,%eax
c0101ac7:	74 28                	je     c0101af1 <print_trapframe+0x157>
c0101ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101acc:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101ad3:	85 c0                	test   %eax,%eax
c0101ad5:	74 1a                	je     c0101af1 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ada:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae5:	c7 04 24 6d 63 10 c0 	movl   $0xc010636d,(%esp)
c0101aec:	e8 5b e8 ff ff       	call   c010034c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101af1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101af5:	d1 65 f0             	shll   -0x10(%ebp)
c0101af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101afb:	83 f8 17             	cmp    $0x17,%eax
c0101afe:	76 ba                	jbe    c0101aba <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101b00:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b03:	8b 40 40             	mov    0x40(%eax),%eax
c0101b06:	25 00 30 00 00       	and    $0x3000,%eax
c0101b0b:	c1 e8 0c             	shr    $0xc,%eax
c0101b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b12:	c7 04 24 71 63 10 c0 	movl   $0xc0106371,(%esp)
c0101b19:	e8 2e e8 ff ff       	call   c010034c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b21:	89 04 24             	mov    %eax,(%esp)
c0101b24:	e8 5b fe ff ff       	call   c0101984 <trap_in_kernel>
c0101b29:	85 c0                	test   %eax,%eax
c0101b2b:	75 30                	jne    c0101b5d <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101b2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b30:	8b 40 44             	mov    0x44(%eax),%eax
c0101b33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b37:	c7 04 24 7a 63 10 c0 	movl   $0xc010637a,(%esp)
c0101b3e:	e8 09 e8 ff ff       	call   c010034c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101b43:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b46:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101b4a:	0f b7 c0             	movzwl %ax,%eax
c0101b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b51:	c7 04 24 89 63 10 c0 	movl   $0xc0106389,(%esp)
c0101b58:	e8 ef e7 ff ff       	call   c010034c <cprintf>
    }
}
c0101b5d:	c9                   	leave  
c0101b5e:	c3                   	ret    

c0101b5f <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101b5f:	55                   	push   %ebp
c0101b60:	89 e5                	mov    %esp,%ebp
c0101b62:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101b65:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b68:	8b 00                	mov    (%eax),%eax
c0101b6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b6e:	c7 04 24 9c 63 10 c0 	movl   $0xc010639c,(%esp)
c0101b75:	e8 d2 e7 ff ff       	call   c010034c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101b7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b7d:	8b 40 04             	mov    0x4(%eax),%eax
c0101b80:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b84:	c7 04 24 ab 63 10 c0 	movl   $0xc01063ab,(%esp)
c0101b8b:	e8 bc e7 ff ff       	call   c010034c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101b90:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b93:	8b 40 08             	mov    0x8(%eax),%eax
c0101b96:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b9a:	c7 04 24 ba 63 10 c0 	movl   $0xc01063ba,(%esp)
c0101ba1:	e8 a6 e7 ff ff       	call   c010034c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101ba6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba9:	8b 40 0c             	mov    0xc(%eax),%eax
c0101bac:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bb0:	c7 04 24 c9 63 10 c0 	movl   $0xc01063c9,(%esp)
c0101bb7:	e8 90 e7 ff ff       	call   c010034c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101bbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbf:	8b 40 10             	mov    0x10(%eax),%eax
c0101bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bc6:	c7 04 24 d8 63 10 c0 	movl   $0xc01063d8,(%esp)
c0101bcd:	e8 7a e7 ff ff       	call   c010034c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101bd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd5:	8b 40 14             	mov    0x14(%eax),%eax
c0101bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bdc:	c7 04 24 e7 63 10 c0 	movl   $0xc01063e7,(%esp)
c0101be3:	e8 64 e7 ff ff       	call   c010034c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101be8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101beb:	8b 40 18             	mov    0x18(%eax),%eax
c0101bee:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf2:	c7 04 24 f6 63 10 c0 	movl   $0xc01063f6,(%esp)
c0101bf9:	e8 4e e7 ff ff       	call   c010034c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101bfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c01:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101c04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c08:	c7 04 24 05 64 10 c0 	movl   $0xc0106405,(%esp)
c0101c0f:	e8 38 e7 ff ff       	call   c010034c <cprintf>
}
c0101c14:	c9                   	leave  
c0101c15:	c3                   	ret    

c0101c16 <trap_dispatch>:

struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101c16:	55                   	push   %ebp
c0101c17:	89 e5                	mov    %esp,%ebp
c0101c19:	57                   	push   %edi
c0101c1a:	56                   	push   %esi
c0101c1b:	53                   	push   %ebx
c0101c1c:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
c0101c1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c22:	8b 40 30             	mov    0x30(%eax),%eax
c0101c25:	83 f8 2f             	cmp    $0x2f,%eax
c0101c28:	77 21                	ja     c0101c4b <trap_dispatch+0x35>
c0101c2a:	83 f8 2e             	cmp    $0x2e,%eax
c0101c2d:	0f 83 ec 01 00 00    	jae    c0101e1f <trap_dispatch+0x209>
c0101c33:	83 f8 21             	cmp    $0x21,%eax
c0101c36:	0f 84 8a 00 00 00    	je     c0101cc6 <trap_dispatch+0xb0>
c0101c3c:	83 f8 24             	cmp    $0x24,%eax
c0101c3f:	74 5c                	je     c0101c9d <trap_dispatch+0x87>
c0101c41:	83 f8 20             	cmp    $0x20,%eax
c0101c44:	74 1c                	je     c0101c62 <trap_dispatch+0x4c>
c0101c46:	e9 9c 01 00 00       	jmp    c0101de7 <trap_dispatch+0x1d1>
c0101c4b:	83 f8 78             	cmp    $0x78,%eax
c0101c4e:	0f 84 9b 00 00 00    	je     c0101cef <trap_dispatch+0xd9>
c0101c54:	83 f8 79             	cmp    $0x79,%eax
c0101c57:	0f 84 11 01 00 00    	je     c0101d6e <trap_dispatch+0x158>
c0101c5d:	e9 85 01 00 00       	jmp    c0101de7 <trap_dispatch+0x1d1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
c0101c62:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101c67:	83 c0 01             	add    $0x1,%eax
c0101c6a:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
        if (ticks %  TICK_NUM == 0)
c0101c6f:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101c75:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101c7a:	89 c8                	mov    %ecx,%eax
c0101c7c:	f7 e2                	mul    %edx
c0101c7e:	89 d0                	mov    %edx,%eax
c0101c80:	c1 e8 05             	shr    $0x5,%eax
c0101c83:	6b c0 64             	imul   $0x64,%eax,%eax
c0101c86:	29 c1                	sub    %eax,%ecx
c0101c88:	89 c8                	mov    %ecx,%eax
c0101c8a:	85 c0                	test   %eax,%eax
c0101c8c:	75 0a                	jne    c0101c98 <trap_dispatch+0x82>
        	print_ticks();
c0101c8e:	e8 33 fb ff ff       	call   c01017c6 <print_ticks>
        break;
c0101c93:	e9 88 01 00 00       	jmp    c0101e20 <trap_dispatch+0x20a>
c0101c98:	e9 83 01 00 00       	jmp    c0101e20 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101c9d:	e8 e8 f8 ff ff       	call   c010158a <cons_getc>
c0101ca2:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101ca5:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101ca9:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101cad:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101cb1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb5:	c7 04 24 14 64 10 c0 	movl   $0xc0106414,(%esp)
c0101cbc:	e8 8b e6 ff ff       	call   c010034c <cprintf>
        break;
c0101cc1:	e9 5a 01 00 00       	jmp    c0101e20 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101cc6:	e8 bf f8 ff ff       	call   c010158a <cons_getc>
c0101ccb:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101cce:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101cd2:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101cd6:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101cda:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cde:	c7 04 24 26 64 10 c0 	movl   $0xc0106426,(%esp)
c0101ce5:	e8 62 e6 ff ff       	call   c010034c <cprintf>
        break;
c0101cea:	e9 31 01 00 00       	jmp    c0101e20 <trap_dispatch+0x20a>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    	if (tf->tf_cs != USER_CS) {
c0101cef:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101cf6:	66 83 f8 1b          	cmp    $0x1b,%ax
c0101cfa:	74 6d                	je     c0101d69 <trap_dispatch+0x153>
            switchk2u = *tf;
c0101cfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cff:	ba 60 89 11 c0       	mov    $0xc0118960,%edx
c0101d04:	89 c3                	mov    %eax,%ebx
c0101d06:	b8 13 00 00 00       	mov    $0x13,%eax
c0101d0b:	89 d7                	mov    %edx,%edi
c0101d0d:	89 de                	mov    %ebx,%esi
c0101d0f:	89 c1                	mov    %eax,%ecx
c0101d11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
c0101d13:	66 c7 05 9c 89 11 c0 	movw   $0x1b,0xc011899c
c0101d1a:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
c0101d1c:	66 c7 05 a8 89 11 c0 	movw   $0x23,0xc01189a8
c0101d23:	23 00 
c0101d25:	0f b7 05 a8 89 11 c0 	movzwl 0xc01189a8,%eax
c0101d2c:	66 a3 88 89 11 c0    	mov    %ax,0xc0118988
c0101d32:	0f b7 05 88 89 11 c0 	movzwl 0xc0118988,%eax
c0101d39:	66 a3 8c 89 11 c0    	mov    %ax,0xc011898c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
c0101d3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d42:	83 c0 44             	add    $0x44,%eax
c0101d45:	a3 a4 89 11 c0       	mov    %eax,0xc01189a4

            switchk2u.tf_eflags |= FL_IOPL_MASK;
c0101d4a:	a1 a0 89 11 c0       	mov    0xc01189a0,%eax
c0101d4f:	80 cc 30             	or     $0x30,%ah
c0101d52:	a3 a0 89 11 c0       	mov    %eax,0xc01189a0

            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
c0101d57:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d5a:	8d 50 fc             	lea    -0x4(%eax),%edx
c0101d5d:	b8 60 89 11 c0       	mov    $0xc0118960,%eax
c0101d62:	89 02                	mov    %eax,(%edx)
        }
        break;
c0101d64:	e9 b7 00 00 00       	jmp    c0101e20 <trap_dispatch+0x20a>
c0101d69:	e9 b2 00 00 00       	jmp    c0101e20 <trap_dispatch+0x20a>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
c0101d6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d71:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d75:	66 83 f8 08          	cmp    $0x8,%ax
c0101d79:	74 6a                	je     c0101de5 <trap_dispatch+0x1cf>
            tf->tf_cs = KERNEL_CS;
c0101d7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d7e:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
c0101d84:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d87:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
c0101d8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d90:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101d94:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d97:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
c0101d9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d9e:	8b 40 40             	mov    0x40(%eax),%eax
c0101da1:	80 e4 cf             	and    $0xcf,%ah
c0101da4:	89 c2                	mov    %eax,%edx
c0101da6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101da9:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
c0101dac:	8b 45 08             	mov    0x8(%ebp),%eax
c0101daf:	8b 40 44             	mov    0x44(%eax),%eax
c0101db2:	83 e8 44             	sub    $0x44,%eax
c0101db5:	a3 ac 89 11 c0       	mov    %eax,0xc01189ac
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
c0101dba:	a1 ac 89 11 c0       	mov    0xc01189ac,%eax
c0101dbf:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
c0101dc6:	00 
c0101dc7:	8b 55 08             	mov    0x8(%ebp),%edx
c0101dca:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101dce:	89 04 24             	mov    %eax,(%esp)
c0101dd1:	e8 1f 40 00 00       	call   c0105df5 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
c0101dd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dd9:	8d 50 fc             	lea    -0x4(%eax),%edx
c0101ddc:	a1 ac 89 11 c0       	mov    0xc01189ac,%eax
c0101de1:	89 02                	mov    %eax,(%edx)
        }
        break;
c0101de3:	eb 3b                	jmp    c0101e20 <trap_dispatch+0x20a>
c0101de5:	eb 39                	jmp    c0101e20 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101de7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dea:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101dee:	0f b7 c0             	movzwl %ax,%eax
c0101df1:	83 e0 03             	and    $0x3,%eax
c0101df4:	85 c0                	test   %eax,%eax
c0101df6:	75 28                	jne    c0101e20 <trap_dispatch+0x20a>
            print_trapframe(tf);
c0101df8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dfb:	89 04 24             	mov    %eax,(%esp)
c0101dfe:	e8 97 fb ff ff       	call   c010199a <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101e03:	c7 44 24 08 35 64 10 	movl   $0xc0106435,0x8(%esp)
c0101e0a:	c0 
c0101e0b:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0101e12:	00 
c0101e13:	c7 04 24 51 64 10 c0 	movl   $0xc0106451,(%esp)
c0101e1a:	e8 fd ed ff ff       	call   c0100c1c <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101e1f:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101e20:	83 c4 2c             	add    $0x2c,%esp
c0101e23:	5b                   	pop    %ebx
c0101e24:	5e                   	pop    %esi
c0101e25:	5f                   	pop    %edi
c0101e26:	5d                   	pop    %ebp
c0101e27:	c3                   	ret    

c0101e28 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101e28:	55                   	push   %ebp
c0101e29:	89 e5                	mov    %esp,%ebp
c0101e2b:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101e2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e31:	89 04 24             	mov    %eax,(%esp)
c0101e34:	e8 dd fd ff ff       	call   c0101c16 <trap_dispatch>
}
c0101e39:	c9                   	leave  
c0101e3a:	c3                   	ret    

c0101e3b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101e3b:	1e                   	push   %ds
    pushl %es
c0101e3c:	06                   	push   %es
    pushl %fs
c0101e3d:	0f a0                	push   %fs
    pushl %gs
c0101e3f:	0f a8                	push   %gs
    pushal
c0101e41:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e42:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e47:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e49:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e4b:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e4c:	e8 d7 ff ff ff       	call   c0101e28 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e51:	5c                   	pop    %esp

c0101e52 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e52:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e53:	0f a9                	pop    %gs
    popl %fs
c0101e55:	0f a1                	pop    %fs
    popl %es
c0101e57:	07                   	pop    %es
    popl %ds
c0101e58:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e59:	83 c4 08             	add    $0x8,%esp
    iret
c0101e5c:	cf                   	iret   

c0101e5d <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e5d:	6a 00                	push   $0x0
  pushl $0
c0101e5f:	6a 00                	push   $0x0
  jmp __alltraps
c0101e61:	e9 d5 ff ff ff       	jmp    c0101e3b <__alltraps>

c0101e66 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e66:	6a 00                	push   $0x0
  pushl $1
c0101e68:	6a 01                	push   $0x1
  jmp __alltraps
c0101e6a:	e9 cc ff ff ff       	jmp    c0101e3b <__alltraps>

c0101e6f <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e6f:	6a 00                	push   $0x0
  pushl $2
c0101e71:	6a 02                	push   $0x2
  jmp __alltraps
c0101e73:	e9 c3 ff ff ff       	jmp    c0101e3b <__alltraps>

c0101e78 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e78:	6a 00                	push   $0x0
  pushl $3
c0101e7a:	6a 03                	push   $0x3
  jmp __alltraps
c0101e7c:	e9 ba ff ff ff       	jmp    c0101e3b <__alltraps>

c0101e81 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e81:	6a 00                	push   $0x0
  pushl $4
c0101e83:	6a 04                	push   $0x4
  jmp __alltraps
c0101e85:	e9 b1 ff ff ff       	jmp    c0101e3b <__alltraps>

c0101e8a <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e8a:	6a 00                	push   $0x0
  pushl $5
c0101e8c:	6a 05                	push   $0x5
  jmp __alltraps
c0101e8e:	e9 a8 ff ff ff       	jmp    c0101e3b <__alltraps>

c0101e93 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e93:	6a 00                	push   $0x0
  pushl $6
c0101e95:	6a 06                	push   $0x6
  jmp __alltraps
c0101e97:	e9 9f ff ff ff       	jmp    c0101e3b <__alltraps>

c0101e9c <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e9c:	6a 00                	push   $0x0
  pushl $7
c0101e9e:	6a 07                	push   $0x7
  jmp __alltraps
c0101ea0:	e9 96 ff ff ff       	jmp    c0101e3b <__alltraps>

c0101ea5 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101ea5:	6a 08                	push   $0x8
  jmp __alltraps
c0101ea7:	e9 8f ff ff ff       	jmp    c0101e3b <__alltraps>

c0101eac <vector9>:
.globl vector9
vector9:
  pushl $9
c0101eac:	6a 09                	push   $0x9
  jmp __alltraps
c0101eae:	e9 88 ff ff ff       	jmp    c0101e3b <__alltraps>

c0101eb3 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101eb3:	6a 0a                	push   $0xa
  jmp __alltraps
c0101eb5:	e9 81 ff ff ff       	jmp    c0101e3b <__alltraps>

c0101eba <vector11>:
.globl vector11
vector11:
  pushl $11
c0101eba:	6a 0b                	push   $0xb
  jmp __alltraps
c0101ebc:	e9 7a ff ff ff       	jmp    c0101e3b <__alltraps>

c0101ec1 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101ec1:	6a 0c                	push   $0xc
  jmp __alltraps
c0101ec3:	e9 73 ff ff ff       	jmp    c0101e3b <__alltraps>

c0101ec8 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101ec8:	6a 0d                	push   $0xd
  jmp __alltraps
c0101eca:	e9 6c ff ff ff       	jmp    c0101e3b <__alltraps>

c0101ecf <vector14>:
.globl vector14
vector14:
  pushl $14
c0101ecf:	6a 0e                	push   $0xe
  jmp __alltraps
c0101ed1:	e9 65 ff ff ff       	jmp    c0101e3b <__alltraps>

c0101ed6 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101ed6:	6a 00                	push   $0x0
  pushl $15
c0101ed8:	6a 0f                	push   $0xf
  jmp __alltraps
c0101eda:	e9 5c ff ff ff       	jmp    c0101e3b <__alltraps>

c0101edf <vector16>:
.globl vector16
vector16:
  pushl $0
c0101edf:	6a 00                	push   $0x0
  pushl $16
c0101ee1:	6a 10                	push   $0x10
  jmp __alltraps
c0101ee3:	e9 53 ff ff ff       	jmp    c0101e3b <__alltraps>

c0101ee8 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101ee8:	6a 11                	push   $0x11
  jmp __alltraps
c0101eea:	e9 4c ff ff ff       	jmp    c0101e3b <__alltraps>

c0101eef <vector18>:
.globl vector18
vector18:
  pushl $0
c0101eef:	6a 00                	push   $0x0
  pushl $18
c0101ef1:	6a 12                	push   $0x12
  jmp __alltraps
c0101ef3:	e9 43 ff ff ff       	jmp    c0101e3b <__alltraps>

c0101ef8 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101ef8:	6a 00                	push   $0x0
  pushl $19
c0101efa:	6a 13                	push   $0x13
  jmp __alltraps
c0101efc:	e9 3a ff ff ff       	jmp    c0101e3b <__alltraps>

c0101f01 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f01:	6a 00                	push   $0x0
  pushl $20
c0101f03:	6a 14                	push   $0x14
  jmp __alltraps
c0101f05:	e9 31 ff ff ff       	jmp    c0101e3b <__alltraps>

c0101f0a <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f0a:	6a 00                	push   $0x0
  pushl $21
c0101f0c:	6a 15                	push   $0x15
  jmp __alltraps
c0101f0e:	e9 28 ff ff ff       	jmp    c0101e3b <__alltraps>

c0101f13 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f13:	6a 00                	push   $0x0
  pushl $22
c0101f15:	6a 16                	push   $0x16
  jmp __alltraps
c0101f17:	e9 1f ff ff ff       	jmp    c0101e3b <__alltraps>

c0101f1c <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f1c:	6a 00                	push   $0x0
  pushl $23
c0101f1e:	6a 17                	push   $0x17
  jmp __alltraps
c0101f20:	e9 16 ff ff ff       	jmp    c0101e3b <__alltraps>

c0101f25 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f25:	6a 00                	push   $0x0
  pushl $24
c0101f27:	6a 18                	push   $0x18
  jmp __alltraps
c0101f29:	e9 0d ff ff ff       	jmp    c0101e3b <__alltraps>

c0101f2e <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f2e:	6a 00                	push   $0x0
  pushl $25
c0101f30:	6a 19                	push   $0x19
  jmp __alltraps
c0101f32:	e9 04 ff ff ff       	jmp    c0101e3b <__alltraps>

c0101f37 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f37:	6a 00                	push   $0x0
  pushl $26
c0101f39:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f3b:	e9 fb fe ff ff       	jmp    c0101e3b <__alltraps>

c0101f40 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f40:	6a 00                	push   $0x0
  pushl $27
c0101f42:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f44:	e9 f2 fe ff ff       	jmp    c0101e3b <__alltraps>

c0101f49 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f49:	6a 00                	push   $0x0
  pushl $28
c0101f4b:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f4d:	e9 e9 fe ff ff       	jmp    c0101e3b <__alltraps>

c0101f52 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f52:	6a 00                	push   $0x0
  pushl $29
c0101f54:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f56:	e9 e0 fe ff ff       	jmp    c0101e3b <__alltraps>

c0101f5b <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f5b:	6a 00                	push   $0x0
  pushl $30
c0101f5d:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f5f:	e9 d7 fe ff ff       	jmp    c0101e3b <__alltraps>

c0101f64 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f64:	6a 00                	push   $0x0
  pushl $31
c0101f66:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f68:	e9 ce fe ff ff       	jmp    c0101e3b <__alltraps>

c0101f6d <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f6d:	6a 00                	push   $0x0
  pushl $32
c0101f6f:	6a 20                	push   $0x20
  jmp __alltraps
c0101f71:	e9 c5 fe ff ff       	jmp    c0101e3b <__alltraps>

c0101f76 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f76:	6a 00                	push   $0x0
  pushl $33
c0101f78:	6a 21                	push   $0x21
  jmp __alltraps
c0101f7a:	e9 bc fe ff ff       	jmp    c0101e3b <__alltraps>

c0101f7f <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f7f:	6a 00                	push   $0x0
  pushl $34
c0101f81:	6a 22                	push   $0x22
  jmp __alltraps
c0101f83:	e9 b3 fe ff ff       	jmp    c0101e3b <__alltraps>

c0101f88 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f88:	6a 00                	push   $0x0
  pushl $35
c0101f8a:	6a 23                	push   $0x23
  jmp __alltraps
c0101f8c:	e9 aa fe ff ff       	jmp    c0101e3b <__alltraps>

c0101f91 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f91:	6a 00                	push   $0x0
  pushl $36
c0101f93:	6a 24                	push   $0x24
  jmp __alltraps
c0101f95:	e9 a1 fe ff ff       	jmp    c0101e3b <__alltraps>

c0101f9a <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f9a:	6a 00                	push   $0x0
  pushl $37
c0101f9c:	6a 25                	push   $0x25
  jmp __alltraps
c0101f9e:	e9 98 fe ff ff       	jmp    c0101e3b <__alltraps>

c0101fa3 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101fa3:	6a 00                	push   $0x0
  pushl $38
c0101fa5:	6a 26                	push   $0x26
  jmp __alltraps
c0101fa7:	e9 8f fe ff ff       	jmp    c0101e3b <__alltraps>

c0101fac <vector39>:
.globl vector39
vector39:
  pushl $0
c0101fac:	6a 00                	push   $0x0
  pushl $39
c0101fae:	6a 27                	push   $0x27
  jmp __alltraps
c0101fb0:	e9 86 fe ff ff       	jmp    c0101e3b <__alltraps>

c0101fb5 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101fb5:	6a 00                	push   $0x0
  pushl $40
c0101fb7:	6a 28                	push   $0x28
  jmp __alltraps
c0101fb9:	e9 7d fe ff ff       	jmp    c0101e3b <__alltraps>

c0101fbe <vector41>:
.globl vector41
vector41:
  pushl $0
c0101fbe:	6a 00                	push   $0x0
  pushl $41
c0101fc0:	6a 29                	push   $0x29
  jmp __alltraps
c0101fc2:	e9 74 fe ff ff       	jmp    c0101e3b <__alltraps>

c0101fc7 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101fc7:	6a 00                	push   $0x0
  pushl $42
c0101fc9:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101fcb:	e9 6b fe ff ff       	jmp    c0101e3b <__alltraps>

c0101fd0 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101fd0:	6a 00                	push   $0x0
  pushl $43
c0101fd2:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101fd4:	e9 62 fe ff ff       	jmp    c0101e3b <__alltraps>

c0101fd9 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101fd9:	6a 00                	push   $0x0
  pushl $44
c0101fdb:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101fdd:	e9 59 fe ff ff       	jmp    c0101e3b <__alltraps>

c0101fe2 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101fe2:	6a 00                	push   $0x0
  pushl $45
c0101fe4:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101fe6:	e9 50 fe ff ff       	jmp    c0101e3b <__alltraps>

c0101feb <vector46>:
.globl vector46
vector46:
  pushl $0
c0101feb:	6a 00                	push   $0x0
  pushl $46
c0101fed:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101fef:	e9 47 fe ff ff       	jmp    c0101e3b <__alltraps>

c0101ff4 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101ff4:	6a 00                	push   $0x0
  pushl $47
c0101ff6:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101ff8:	e9 3e fe ff ff       	jmp    c0101e3b <__alltraps>

c0101ffd <vector48>:
.globl vector48
vector48:
  pushl $0
c0101ffd:	6a 00                	push   $0x0
  pushl $48
c0101fff:	6a 30                	push   $0x30
  jmp __alltraps
c0102001:	e9 35 fe ff ff       	jmp    c0101e3b <__alltraps>

c0102006 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102006:	6a 00                	push   $0x0
  pushl $49
c0102008:	6a 31                	push   $0x31
  jmp __alltraps
c010200a:	e9 2c fe ff ff       	jmp    c0101e3b <__alltraps>

c010200f <vector50>:
.globl vector50
vector50:
  pushl $0
c010200f:	6a 00                	push   $0x0
  pushl $50
c0102011:	6a 32                	push   $0x32
  jmp __alltraps
c0102013:	e9 23 fe ff ff       	jmp    c0101e3b <__alltraps>

c0102018 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102018:	6a 00                	push   $0x0
  pushl $51
c010201a:	6a 33                	push   $0x33
  jmp __alltraps
c010201c:	e9 1a fe ff ff       	jmp    c0101e3b <__alltraps>

c0102021 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102021:	6a 00                	push   $0x0
  pushl $52
c0102023:	6a 34                	push   $0x34
  jmp __alltraps
c0102025:	e9 11 fe ff ff       	jmp    c0101e3b <__alltraps>

c010202a <vector53>:
.globl vector53
vector53:
  pushl $0
c010202a:	6a 00                	push   $0x0
  pushl $53
c010202c:	6a 35                	push   $0x35
  jmp __alltraps
c010202e:	e9 08 fe ff ff       	jmp    c0101e3b <__alltraps>

c0102033 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102033:	6a 00                	push   $0x0
  pushl $54
c0102035:	6a 36                	push   $0x36
  jmp __alltraps
c0102037:	e9 ff fd ff ff       	jmp    c0101e3b <__alltraps>

c010203c <vector55>:
.globl vector55
vector55:
  pushl $0
c010203c:	6a 00                	push   $0x0
  pushl $55
c010203e:	6a 37                	push   $0x37
  jmp __alltraps
c0102040:	e9 f6 fd ff ff       	jmp    c0101e3b <__alltraps>

c0102045 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102045:	6a 00                	push   $0x0
  pushl $56
c0102047:	6a 38                	push   $0x38
  jmp __alltraps
c0102049:	e9 ed fd ff ff       	jmp    c0101e3b <__alltraps>

c010204e <vector57>:
.globl vector57
vector57:
  pushl $0
c010204e:	6a 00                	push   $0x0
  pushl $57
c0102050:	6a 39                	push   $0x39
  jmp __alltraps
c0102052:	e9 e4 fd ff ff       	jmp    c0101e3b <__alltraps>

c0102057 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102057:	6a 00                	push   $0x0
  pushl $58
c0102059:	6a 3a                	push   $0x3a
  jmp __alltraps
c010205b:	e9 db fd ff ff       	jmp    c0101e3b <__alltraps>

c0102060 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102060:	6a 00                	push   $0x0
  pushl $59
c0102062:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102064:	e9 d2 fd ff ff       	jmp    c0101e3b <__alltraps>

c0102069 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102069:	6a 00                	push   $0x0
  pushl $60
c010206b:	6a 3c                	push   $0x3c
  jmp __alltraps
c010206d:	e9 c9 fd ff ff       	jmp    c0101e3b <__alltraps>

c0102072 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102072:	6a 00                	push   $0x0
  pushl $61
c0102074:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102076:	e9 c0 fd ff ff       	jmp    c0101e3b <__alltraps>

c010207b <vector62>:
.globl vector62
vector62:
  pushl $0
c010207b:	6a 00                	push   $0x0
  pushl $62
c010207d:	6a 3e                	push   $0x3e
  jmp __alltraps
c010207f:	e9 b7 fd ff ff       	jmp    c0101e3b <__alltraps>

c0102084 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102084:	6a 00                	push   $0x0
  pushl $63
c0102086:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102088:	e9 ae fd ff ff       	jmp    c0101e3b <__alltraps>

c010208d <vector64>:
.globl vector64
vector64:
  pushl $0
c010208d:	6a 00                	push   $0x0
  pushl $64
c010208f:	6a 40                	push   $0x40
  jmp __alltraps
c0102091:	e9 a5 fd ff ff       	jmp    c0101e3b <__alltraps>

c0102096 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102096:	6a 00                	push   $0x0
  pushl $65
c0102098:	6a 41                	push   $0x41
  jmp __alltraps
c010209a:	e9 9c fd ff ff       	jmp    c0101e3b <__alltraps>

c010209f <vector66>:
.globl vector66
vector66:
  pushl $0
c010209f:	6a 00                	push   $0x0
  pushl $66
c01020a1:	6a 42                	push   $0x42
  jmp __alltraps
c01020a3:	e9 93 fd ff ff       	jmp    c0101e3b <__alltraps>

c01020a8 <vector67>:
.globl vector67
vector67:
  pushl $0
c01020a8:	6a 00                	push   $0x0
  pushl $67
c01020aa:	6a 43                	push   $0x43
  jmp __alltraps
c01020ac:	e9 8a fd ff ff       	jmp    c0101e3b <__alltraps>

c01020b1 <vector68>:
.globl vector68
vector68:
  pushl $0
c01020b1:	6a 00                	push   $0x0
  pushl $68
c01020b3:	6a 44                	push   $0x44
  jmp __alltraps
c01020b5:	e9 81 fd ff ff       	jmp    c0101e3b <__alltraps>

c01020ba <vector69>:
.globl vector69
vector69:
  pushl $0
c01020ba:	6a 00                	push   $0x0
  pushl $69
c01020bc:	6a 45                	push   $0x45
  jmp __alltraps
c01020be:	e9 78 fd ff ff       	jmp    c0101e3b <__alltraps>

c01020c3 <vector70>:
.globl vector70
vector70:
  pushl $0
c01020c3:	6a 00                	push   $0x0
  pushl $70
c01020c5:	6a 46                	push   $0x46
  jmp __alltraps
c01020c7:	e9 6f fd ff ff       	jmp    c0101e3b <__alltraps>

c01020cc <vector71>:
.globl vector71
vector71:
  pushl $0
c01020cc:	6a 00                	push   $0x0
  pushl $71
c01020ce:	6a 47                	push   $0x47
  jmp __alltraps
c01020d0:	e9 66 fd ff ff       	jmp    c0101e3b <__alltraps>

c01020d5 <vector72>:
.globl vector72
vector72:
  pushl $0
c01020d5:	6a 00                	push   $0x0
  pushl $72
c01020d7:	6a 48                	push   $0x48
  jmp __alltraps
c01020d9:	e9 5d fd ff ff       	jmp    c0101e3b <__alltraps>

c01020de <vector73>:
.globl vector73
vector73:
  pushl $0
c01020de:	6a 00                	push   $0x0
  pushl $73
c01020e0:	6a 49                	push   $0x49
  jmp __alltraps
c01020e2:	e9 54 fd ff ff       	jmp    c0101e3b <__alltraps>

c01020e7 <vector74>:
.globl vector74
vector74:
  pushl $0
c01020e7:	6a 00                	push   $0x0
  pushl $74
c01020e9:	6a 4a                	push   $0x4a
  jmp __alltraps
c01020eb:	e9 4b fd ff ff       	jmp    c0101e3b <__alltraps>

c01020f0 <vector75>:
.globl vector75
vector75:
  pushl $0
c01020f0:	6a 00                	push   $0x0
  pushl $75
c01020f2:	6a 4b                	push   $0x4b
  jmp __alltraps
c01020f4:	e9 42 fd ff ff       	jmp    c0101e3b <__alltraps>

c01020f9 <vector76>:
.globl vector76
vector76:
  pushl $0
c01020f9:	6a 00                	push   $0x0
  pushl $76
c01020fb:	6a 4c                	push   $0x4c
  jmp __alltraps
c01020fd:	e9 39 fd ff ff       	jmp    c0101e3b <__alltraps>

c0102102 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102102:	6a 00                	push   $0x0
  pushl $77
c0102104:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102106:	e9 30 fd ff ff       	jmp    c0101e3b <__alltraps>

c010210b <vector78>:
.globl vector78
vector78:
  pushl $0
c010210b:	6a 00                	push   $0x0
  pushl $78
c010210d:	6a 4e                	push   $0x4e
  jmp __alltraps
c010210f:	e9 27 fd ff ff       	jmp    c0101e3b <__alltraps>

c0102114 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102114:	6a 00                	push   $0x0
  pushl $79
c0102116:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102118:	e9 1e fd ff ff       	jmp    c0101e3b <__alltraps>

c010211d <vector80>:
.globl vector80
vector80:
  pushl $0
c010211d:	6a 00                	push   $0x0
  pushl $80
c010211f:	6a 50                	push   $0x50
  jmp __alltraps
c0102121:	e9 15 fd ff ff       	jmp    c0101e3b <__alltraps>

c0102126 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102126:	6a 00                	push   $0x0
  pushl $81
c0102128:	6a 51                	push   $0x51
  jmp __alltraps
c010212a:	e9 0c fd ff ff       	jmp    c0101e3b <__alltraps>

c010212f <vector82>:
.globl vector82
vector82:
  pushl $0
c010212f:	6a 00                	push   $0x0
  pushl $82
c0102131:	6a 52                	push   $0x52
  jmp __alltraps
c0102133:	e9 03 fd ff ff       	jmp    c0101e3b <__alltraps>

c0102138 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102138:	6a 00                	push   $0x0
  pushl $83
c010213a:	6a 53                	push   $0x53
  jmp __alltraps
c010213c:	e9 fa fc ff ff       	jmp    c0101e3b <__alltraps>

c0102141 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102141:	6a 00                	push   $0x0
  pushl $84
c0102143:	6a 54                	push   $0x54
  jmp __alltraps
c0102145:	e9 f1 fc ff ff       	jmp    c0101e3b <__alltraps>

c010214a <vector85>:
.globl vector85
vector85:
  pushl $0
c010214a:	6a 00                	push   $0x0
  pushl $85
c010214c:	6a 55                	push   $0x55
  jmp __alltraps
c010214e:	e9 e8 fc ff ff       	jmp    c0101e3b <__alltraps>

c0102153 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102153:	6a 00                	push   $0x0
  pushl $86
c0102155:	6a 56                	push   $0x56
  jmp __alltraps
c0102157:	e9 df fc ff ff       	jmp    c0101e3b <__alltraps>

c010215c <vector87>:
.globl vector87
vector87:
  pushl $0
c010215c:	6a 00                	push   $0x0
  pushl $87
c010215e:	6a 57                	push   $0x57
  jmp __alltraps
c0102160:	e9 d6 fc ff ff       	jmp    c0101e3b <__alltraps>

c0102165 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102165:	6a 00                	push   $0x0
  pushl $88
c0102167:	6a 58                	push   $0x58
  jmp __alltraps
c0102169:	e9 cd fc ff ff       	jmp    c0101e3b <__alltraps>

c010216e <vector89>:
.globl vector89
vector89:
  pushl $0
c010216e:	6a 00                	push   $0x0
  pushl $89
c0102170:	6a 59                	push   $0x59
  jmp __alltraps
c0102172:	e9 c4 fc ff ff       	jmp    c0101e3b <__alltraps>

c0102177 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102177:	6a 00                	push   $0x0
  pushl $90
c0102179:	6a 5a                	push   $0x5a
  jmp __alltraps
c010217b:	e9 bb fc ff ff       	jmp    c0101e3b <__alltraps>

c0102180 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102180:	6a 00                	push   $0x0
  pushl $91
c0102182:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102184:	e9 b2 fc ff ff       	jmp    c0101e3b <__alltraps>

c0102189 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102189:	6a 00                	push   $0x0
  pushl $92
c010218b:	6a 5c                	push   $0x5c
  jmp __alltraps
c010218d:	e9 a9 fc ff ff       	jmp    c0101e3b <__alltraps>

c0102192 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102192:	6a 00                	push   $0x0
  pushl $93
c0102194:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102196:	e9 a0 fc ff ff       	jmp    c0101e3b <__alltraps>

c010219b <vector94>:
.globl vector94
vector94:
  pushl $0
c010219b:	6a 00                	push   $0x0
  pushl $94
c010219d:	6a 5e                	push   $0x5e
  jmp __alltraps
c010219f:	e9 97 fc ff ff       	jmp    c0101e3b <__alltraps>

c01021a4 <vector95>:
.globl vector95
vector95:
  pushl $0
c01021a4:	6a 00                	push   $0x0
  pushl $95
c01021a6:	6a 5f                	push   $0x5f
  jmp __alltraps
c01021a8:	e9 8e fc ff ff       	jmp    c0101e3b <__alltraps>

c01021ad <vector96>:
.globl vector96
vector96:
  pushl $0
c01021ad:	6a 00                	push   $0x0
  pushl $96
c01021af:	6a 60                	push   $0x60
  jmp __alltraps
c01021b1:	e9 85 fc ff ff       	jmp    c0101e3b <__alltraps>

c01021b6 <vector97>:
.globl vector97
vector97:
  pushl $0
c01021b6:	6a 00                	push   $0x0
  pushl $97
c01021b8:	6a 61                	push   $0x61
  jmp __alltraps
c01021ba:	e9 7c fc ff ff       	jmp    c0101e3b <__alltraps>

c01021bf <vector98>:
.globl vector98
vector98:
  pushl $0
c01021bf:	6a 00                	push   $0x0
  pushl $98
c01021c1:	6a 62                	push   $0x62
  jmp __alltraps
c01021c3:	e9 73 fc ff ff       	jmp    c0101e3b <__alltraps>

c01021c8 <vector99>:
.globl vector99
vector99:
  pushl $0
c01021c8:	6a 00                	push   $0x0
  pushl $99
c01021ca:	6a 63                	push   $0x63
  jmp __alltraps
c01021cc:	e9 6a fc ff ff       	jmp    c0101e3b <__alltraps>

c01021d1 <vector100>:
.globl vector100
vector100:
  pushl $0
c01021d1:	6a 00                	push   $0x0
  pushl $100
c01021d3:	6a 64                	push   $0x64
  jmp __alltraps
c01021d5:	e9 61 fc ff ff       	jmp    c0101e3b <__alltraps>

c01021da <vector101>:
.globl vector101
vector101:
  pushl $0
c01021da:	6a 00                	push   $0x0
  pushl $101
c01021dc:	6a 65                	push   $0x65
  jmp __alltraps
c01021de:	e9 58 fc ff ff       	jmp    c0101e3b <__alltraps>

c01021e3 <vector102>:
.globl vector102
vector102:
  pushl $0
c01021e3:	6a 00                	push   $0x0
  pushl $102
c01021e5:	6a 66                	push   $0x66
  jmp __alltraps
c01021e7:	e9 4f fc ff ff       	jmp    c0101e3b <__alltraps>

c01021ec <vector103>:
.globl vector103
vector103:
  pushl $0
c01021ec:	6a 00                	push   $0x0
  pushl $103
c01021ee:	6a 67                	push   $0x67
  jmp __alltraps
c01021f0:	e9 46 fc ff ff       	jmp    c0101e3b <__alltraps>

c01021f5 <vector104>:
.globl vector104
vector104:
  pushl $0
c01021f5:	6a 00                	push   $0x0
  pushl $104
c01021f7:	6a 68                	push   $0x68
  jmp __alltraps
c01021f9:	e9 3d fc ff ff       	jmp    c0101e3b <__alltraps>

c01021fe <vector105>:
.globl vector105
vector105:
  pushl $0
c01021fe:	6a 00                	push   $0x0
  pushl $105
c0102200:	6a 69                	push   $0x69
  jmp __alltraps
c0102202:	e9 34 fc ff ff       	jmp    c0101e3b <__alltraps>

c0102207 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102207:	6a 00                	push   $0x0
  pushl $106
c0102209:	6a 6a                	push   $0x6a
  jmp __alltraps
c010220b:	e9 2b fc ff ff       	jmp    c0101e3b <__alltraps>

c0102210 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102210:	6a 00                	push   $0x0
  pushl $107
c0102212:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102214:	e9 22 fc ff ff       	jmp    c0101e3b <__alltraps>

c0102219 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102219:	6a 00                	push   $0x0
  pushl $108
c010221b:	6a 6c                	push   $0x6c
  jmp __alltraps
c010221d:	e9 19 fc ff ff       	jmp    c0101e3b <__alltraps>

c0102222 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102222:	6a 00                	push   $0x0
  pushl $109
c0102224:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102226:	e9 10 fc ff ff       	jmp    c0101e3b <__alltraps>

c010222b <vector110>:
.globl vector110
vector110:
  pushl $0
c010222b:	6a 00                	push   $0x0
  pushl $110
c010222d:	6a 6e                	push   $0x6e
  jmp __alltraps
c010222f:	e9 07 fc ff ff       	jmp    c0101e3b <__alltraps>

c0102234 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102234:	6a 00                	push   $0x0
  pushl $111
c0102236:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102238:	e9 fe fb ff ff       	jmp    c0101e3b <__alltraps>

c010223d <vector112>:
.globl vector112
vector112:
  pushl $0
c010223d:	6a 00                	push   $0x0
  pushl $112
c010223f:	6a 70                	push   $0x70
  jmp __alltraps
c0102241:	e9 f5 fb ff ff       	jmp    c0101e3b <__alltraps>

c0102246 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102246:	6a 00                	push   $0x0
  pushl $113
c0102248:	6a 71                	push   $0x71
  jmp __alltraps
c010224a:	e9 ec fb ff ff       	jmp    c0101e3b <__alltraps>

c010224f <vector114>:
.globl vector114
vector114:
  pushl $0
c010224f:	6a 00                	push   $0x0
  pushl $114
c0102251:	6a 72                	push   $0x72
  jmp __alltraps
c0102253:	e9 e3 fb ff ff       	jmp    c0101e3b <__alltraps>

c0102258 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102258:	6a 00                	push   $0x0
  pushl $115
c010225a:	6a 73                	push   $0x73
  jmp __alltraps
c010225c:	e9 da fb ff ff       	jmp    c0101e3b <__alltraps>

c0102261 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102261:	6a 00                	push   $0x0
  pushl $116
c0102263:	6a 74                	push   $0x74
  jmp __alltraps
c0102265:	e9 d1 fb ff ff       	jmp    c0101e3b <__alltraps>

c010226a <vector117>:
.globl vector117
vector117:
  pushl $0
c010226a:	6a 00                	push   $0x0
  pushl $117
c010226c:	6a 75                	push   $0x75
  jmp __alltraps
c010226e:	e9 c8 fb ff ff       	jmp    c0101e3b <__alltraps>

c0102273 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102273:	6a 00                	push   $0x0
  pushl $118
c0102275:	6a 76                	push   $0x76
  jmp __alltraps
c0102277:	e9 bf fb ff ff       	jmp    c0101e3b <__alltraps>

c010227c <vector119>:
.globl vector119
vector119:
  pushl $0
c010227c:	6a 00                	push   $0x0
  pushl $119
c010227e:	6a 77                	push   $0x77
  jmp __alltraps
c0102280:	e9 b6 fb ff ff       	jmp    c0101e3b <__alltraps>

c0102285 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102285:	6a 00                	push   $0x0
  pushl $120
c0102287:	6a 78                	push   $0x78
  jmp __alltraps
c0102289:	e9 ad fb ff ff       	jmp    c0101e3b <__alltraps>

c010228e <vector121>:
.globl vector121
vector121:
  pushl $0
c010228e:	6a 00                	push   $0x0
  pushl $121
c0102290:	6a 79                	push   $0x79
  jmp __alltraps
c0102292:	e9 a4 fb ff ff       	jmp    c0101e3b <__alltraps>

c0102297 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102297:	6a 00                	push   $0x0
  pushl $122
c0102299:	6a 7a                	push   $0x7a
  jmp __alltraps
c010229b:	e9 9b fb ff ff       	jmp    c0101e3b <__alltraps>

c01022a0 <vector123>:
.globl vector123
vector123:
  pushl $0
c01022a0:	6a 00                	push   $0x0
  pushl $123
c01022a2:	6a 7b                	push   $0x7b
  jmp __alltraps
c01022a4:	e9 92 fb ff ff       	jmp    c0101e3b <__alltraps>

c01022a9 <vector124>:
.globl vector124
vector124:
  pushl $0
c01022a9:	6a 00                	push   $0x0
  pushl $124
c01022ab:	6a 7c                	push   $0x7c
  jmp __alltraps
c01022ad:	e9 89 fb ff ff       	jmp    c0101e3b <__alltraps>

c01022b2 <vector125>:
.globl vector125
vector125:
  pushl $0
c01022b2:	6a 00                	push   $0x0
  pushl $125
c01022b4:	6a 7d                	push   $0x7d
  jmp __alltraps
c01022b6:	e9 80 fb ff ff       	jmp    c0101e3b <__alltraps>

c01022bb <vector126>:
.globl vector126
vector126:
  pushl $0
c01022bb:	6a 00                	push   $0x0
  pushl $126
c01022bd:	6a 7e                	push   $0x7e
  jmp __alltraps
c01022bf:	e9 77 fb ff ff       	jmp    c0101e3b <__alltraps>

c01022c4 <vector127>:
.globl vector127
vector127:
  pushl $0
c01022c4:	6a 00                	push   $0x0
  pushl $127
c01022c6:	6a 7f                	push   $0x7f
  jmp __alltraps
c01022c8:	e9 6e fb ff ff       	jmp    c0101e3b <__alltraps>

c01022cd <vector128>:
.globl vector128
vector128:
  pushl $0
c01022cd:	6a 00                	push   $0x0
  pushl $128
c01022cf:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01022d4:	e9 62 fb ff ff       	jmp    c0101e3b <__alltraps>

c01022d9 <vector129>:
.globl vector129
vector129:
  pushl $0
c01022d9:	6a 00                	push   $0x0
  pushl $129
c01022db:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01022e0:	e9 56 fb ff ff       	jmp    c0101e3b <__alltraps>

c01022e5 <vector130>:
.globl vector130
vector130:
  pushl $0
c01022e5:	6a 00                	push   $0x0
  pushl $130
c01022e7:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01022ec:	e9 4a fb ff ff       	jmp    c0101e3b <__alltraps>

c01022f1 <vector131>:
.globl vector131
vector131:
  pushl $0
c01022f1:	6a 00                	push   $0x0
  pushl $131
c01022f3:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01022f8:	e9 3e fb ff ff       	jmp    c0101e3b <__alltraps>

c01022fd <vector132>:
.globl vector132
vector132:
  pushl $0
c01022fd:	6a 00                	push   $0x0
  pushl $132
c01022ff:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102304:	e9 32 fb ff ff       	jmp    c0101e3b <__alltraps>

c0102309 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102309:	6a 00                	push   $0x0
  pushl $133
c010230b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102310:	e9 26 fb ff ff       	jmp    c0101e3b <__alltraps>

c0102315 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102315:	6a 00                	push   $0x0
  pushl $134
c0102317:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010231c:	e9 1a fb ff ff       	jmp    c0101e3b <__alltraps>

c0102321 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102321:	6a 00                	push   $0x0
  pushl $135
c0102323:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102328:	e9 0e fb ff ff       	jmp    c0101e3b <__alltraps>

c010232d <vector136>:
.globl vector136
vector136:
  pushl $0
c010232d:	6a 00                	push   $0x0
  pushl $136
c010232f:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102334:	e9 02 fb ff ff       	jmp    c0101e3b <__alltraps>

c0102339 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102339:	6a 00                	push   $0x0
  pushl $137
c010233b:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102340:	e9 f6 fa ff ff       	jmp    c0101e3b <__alltraps>

c0102345 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102345:	6a 00                	push   $0x0
  pushl $138
c0102347:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010234c:	e9 ea fa ff ff       	jmp    c0101e3b <__alltraps>

c0102351 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102351:	6a 00                	push   $0x0
  pushl $139
c0102353:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102358:	e9 de fa ff ff       	jmp    c0101e3b <__alltraps>

c010235d <vector140>:
.globl vector140
vector140:
  pushl $0
c010235d:	6a 00                	push   $0x0
  pushl $140
c010235f:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102364:	e9 d2 fa ff ff       	jmp    c0101e3b <__alltraps>

c0102369 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102369:	6a 00                	push   $0x0
  pushl $141
c010236b:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102370:	e9 c6 fa ff ff       	jmp    c0101e3b <__alltraps>

c0102375 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102375:	6a 00                	push   $0x0
  pushl $142
c0102377:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010237c:	e9 ba fa ff ff       	jmp    c0101e3b <__alltraps>

c0102381 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102381:	6a 00                	push   $0x0
  pushl $143
c0102383:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102388:	e9 ae fa ff ff       	jmp    c0101e3b <__alltraps>

c010238d <vector144>:
.globl vector144
vector144:
  pushl $0
c010238d:	6a 00                	push   $0x0
  pushl $144
c010238f:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102394:	e9 a2 fa ff ff       	jmp    c0101e3b <__alltraps>

c0102399 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102399:	6a 00                	push   $0x0
  pushl $145
c010239b:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01023a0:	e9 96 fa ff ff       	jmp    c0101e3b <__alltraps>

c01023a5 <vector146>:
.globl vector146
vector146:
  pushl $0
c01023a5:	6a 00                	push   $0x0
  pushl $146
c01023a7:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01023ac:	e9 8a fa ff ff       	jmp    c0101e3b <__alltraps>

c01023b1 <vector147>:
.globl vector147
vector147:
  pushl $0
c01023b1:	6a 00                	push   $0x0
  pushl $147
c01023b3:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01023b8:	e9 7e fa ff ff       	jmp    c0101e3b <__alltraps>

c01023bd <vector148>:
.globl vector148
vector148:
  pushl $0
c01023bd:	6a 00                	push   $0x0
  pushl $148
c01023bf:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01023c4:	e9 72 fa ff ff       	jmp    c0101e3b <__alltraps>

c01023c9 <vector149>:
.globl vector149
vector149:
  pushl $0
c01023c9:	6a 00                	push   $0x0
  pushl $149
c01023cb:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01023d0:	e9 66 fa ff ff       	jmp    c0101e3b <__alltraps>

c01023d5 <vector150>:
.globl vector150
vector150:
  pushl $0
c01023d5:	6a 00                	push   $0x0
  pushl $150
c01023d7:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01023dc:	e9 5a fa ff ff       	jmp    c0101e3b <__alltraps>

c01023e1 <vector151>:
.globl vector151
vector151:
  pushl $0
c01023e1:	6a 00                	push   $0x0
  pushl $151
c01023e3:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01023e8:	e9 4e fa ff ff       	jmp    c0101e3b <__alltraps>

c01023ed <vector152>:
.globl vector152
vector152:
  pushl $0
c01023ed:	6a 00                	push   $0x0
  pushl $152
c01023ef:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01023f4:	e9 42 fa ff ff       	jmp    c0101e3b <__alltraps>

c01023f9 <vector153>:
.globl vector153
vector153:
  pushl $0
c01023f9:	6a 00                	push   $0x0
  pushl $153
c01023fb:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102400:	e9 36 fa ff ff       	jmp    c0101e3b <__alltraps>

c0102405 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102405:	6a 00                	push   $0x0
  pushl $154
c0102407:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010240c:	e9 2a fa ff ff       	jmp    c0101e3b <__alltraps>

c0102411 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102411:	6a 00                	push   $0x0
  pushl $155
c0102413:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102418:	e9 1e fa ff ff       	jmp    c0101e3b <__alltraps>

c010241d <vector156>:
.globl vector156
vector156:
  pushl $0
c010241d:	6a 00                	push   $0x0
  pushl $156
c010241f:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102424:	e9 12 fa ff ff       	jmp    c0101e3b <__alltraps>

c0102429 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102429:	6a 00                	push   $0x0
  pushl $157
c010242b:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102430:	e9 06 fa ff ff       	jmp    c0101e3b <__alltraps>

c0102435 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102435:	6a 00                	push   $0x0
  pushl $158
c0102437:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010243c:	e9 fa f9 ff ff       	jmp    c0101e3b <__alltraps>

c0102441 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102441:	6a 00                	push   $0x0
  pushl $159
c0102443:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102448:	e9 ee f9 ff ff       	jmp    c0101e3b <__alltraps>

c010244d <vector160>:
.globl vector160
vector160:
  pushl $0
c010244d:	6a 00                	push   $0x0
  pushl $160
c010244f:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102454:	e9 e2 f9 ff ff       	jmp    c0101e3b <__alltraps>

c0102459 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102459:	6a 00                	push   $0x0
  pushl $161
c010245b:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102460:	e9 d6 f9 ff ff       	jmp    c0101e3b <__alltraps>

c0102465 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102465:	6a 00                	push   $0x0
  pushl $162
c0102467:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010246c:	e9 ca f9 ff ff       	jmp    c0101e3b <__alltraps>

c0102471 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102471:	6a 00                	push   $0x0
  pushl $163
c0102473:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102478:	e9 be f9 ff ff       	jmp    c0101e3b <__alltraps>

c010247d <vector164>:
.globl vector164
vector164:
  pushl $0
c010247d:	6a 00                	push   $0x0
  pushl $164
c010247f:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102484:	e9 b2 f9 ff ff       	jmp    c0101e3b <__alltraps>

c0102489 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102489:	6a 00                	push   $0x0
  pushl $165
c010248b:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102490:	e9 a6 f9 ff ff       	jmp    c0101e3b <__alltraps>

c0102495 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102495:	6a 00                	push   $0x0
  pushl $166
c0102497:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010249c:	e9 9a f9 ff ff       	jmp    c0101e3b <__alltraps>

c01024a1 <vector167>:
.globl vector167
vector167:
  pushl $0
c01024a1:	6a 00                	push   $0x0
  pushl $167
c01024a3:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01024a8:	e9 8e f9 ff ff       	jmp    c0101e3b <__alltraps>

c01024ad <vector168>:
.globl vector168
vector168:
  pushl $0
c01024ad:	6a 00                	push   $0x0
  pushl $168
c01024af:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01024b4:	e9 82 f9 ff ff       	jmp    c0101e3b <__alltraps>

c01024b9 <vector169>:
.globl vector169
vector169:
  pushl $0
c01024b9:	6a 00                	push   $0x0
  pushl $169
c01024bb:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01024c0:	e9 76 f9 ff ff       	jmp    c0101e3b <__alltraps>

c01024c5 <vector170>:
.globl vector170
vector170:
  pushl $0
c01024c5:	6a 00                	push   $0x0
  pushl $170
c01024c7:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01024cc:	e9 6a f9 ff ff       	jmp    c0101e3b <__alltraps>

c01024d1 <vector171>:
.globl vector171
vector171:
  pushl $0
c01024d1:	6a 00                	push   $0x0
  pushl $171
c01024d3:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01024d8:	e9 5e f9 ff ff       	jmp    c0101e3b <__alltraps>

c01024dd <vector172>:
.globl vector172
vector172:
  pushl $0
c01024dd:	6a 00                	push   $0x0
  pushl $172
c01024df:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01024e4:	e9 52 f9 ff ff       	jmp    c0101e3b <__alltraps>

c01024e9 <vector173>:
.globl vector173
vector173:
  pushl $0
c01024e9:	6a 00                	push   $0x0
  pushl $173
c01024eb:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01024f0:	e9 46 f9 ff ff       	jmp    c0101e3b <__alltraps>

c01024f5 <vector174>:
.globl vector174
vector174:
  pushl $0
c01024f5:	6a 00                	push   $0x0
  pushl $174
c01024f7:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01024fc:	e9 3a f9 ff ff       	jmp    c0101e3b <__alltraps>

c0102501 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102501:	6a 00                	push   $0x0
  pushl $175
c0102503:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102508:	e9 2e f9 ff ff       	jmp    c0101e3b <__alltraps>

c010250d <vector176>:
.globl vector176
vector176:
  pushl $0
c010250d:	6a 00                	push   $0x0
  pushl $176
c010250f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102514:	e9 22 f9 ff ff       	jmp    c0101e3b <__alltraps>

c0102519 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102519:	6a 00                	push   $0x0
  pushl $177
c010251b:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102520:	e9 16 f9 ff ff       	jmp    c0101e3b <__alltraps>

c0102525 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102525:	6a 00                	push   $0x0
  pushl $178
c0102527:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010252c:	e9 0a f9 ff ff       	jmp    c0101e3b <__alltraps>

c0102531 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102531:	6a 00                	push   $0x0
  pushl $179
c0102533:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102538:	e9 fe f8 ff ff       	jmp    c0101e3b <__alltraps>

c010253d <vector180>:
.globl vector180
vector180:
  pushl $0
c010253d:	6a 00                	push   $0x0
  pushl $180
c010253f:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102544:	e9 f2 f8 ff ff       	jmp    c0101e3b <__alltraps>

c0102549 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102549:	6a 00                	push   $0x0
  pushl $181
c010254b:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102550:	e9 e6 f8 ff ff       	jmp    c0101e3b <__alltraps>

c0102555 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102555:	6a 00                	push   $0x0
  pushl $182
c0102557:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010255c:	e9 da f8 ff ff       	jmp    c0101e3b <__alltraps>

c0102561 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102561:	6a 00                	push   $0x0
  pushl $183
c0102563:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102568:	e9 ce f8 ff ff       	jmp    c0101e3b <__alltraps>

c010256d <vector184>:
.globl vector184
vector184:
  pushl $0
c010256d:	6a 00                	push   $0x0
  pushl $184
c010256f:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102574:	e9 c2 f8 ff ff       	jmp    c0101e3b <__alltraps>

c0102579 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102579:	6a 00                	push   $0x0
  pushl $185
c010257b:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102580:	e9 b6 f8 ff ff       	jmp    c0101e3b <__alltraps>

c0102585 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102585:	6a 00                	push   $0x0
  pushl $186
c0102587:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010258c:	e9 aa f8 ff ff       	jmp    c0101e3b <__alltraps>

c0102591 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102591:	6a 00                	push   $0x0
  pushl $187
c0102593:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102598:	e9 9e f8 ff ff       	jmp    c0101e3b <__alltraps>

c010259d <vector188>:
.globl vector188
vector188:
  pushl $0
c010259d:	6a 00                	push   $0x0
  pushl $188
c010259f:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01025a4:	e9 92 f8 ff ff       	jmp    c0101e3b <__alltraps>

c01025a9 <vector189>:
.globl vector189
vector189:
  pushl $0
c01025a9:	6a 00                	push   $0x0
  pushl $189
c01025ab:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01025b0:	e9 86 f8 ff ff       	jmp    c0101e3b <__alltraps>

c01025b5 <vector190>:
.globl vector190
vector190:
  pushl $0
c01025b5:	6a 00                	push   $0x0
  pushl $190
c01025b7:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01025bc:	e9 7a f8 ff ff       	jmp    c0101e3b <__alltraps>

c01025c1 <vector191>:
.globl vector191
vector191:
  pushl $0
c01025c1:	6a 00                	push   $0x0
  pushl $191
c01025c3:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01025c8:	e9 6e f8 ff ff       	jmp    c0101e3b <__alltraps>

c01025cd <vector192>:
.globl vector192
vector192:
  pushl $0
c01025cd:	6a 00                	push   $0x0
  pushl $192
c01025cf:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01025d4:	e9 62 f8 ff ff       	jmp    c0101e3b <__alltraps>

c01025d9 <vector193>:
.globl vector193
vector193:
  pushl $0
c01025d9:	6a 00                	push   $0x0
  pushl $193
c01025db:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01025e0:	e9 56 f8 ff ff       	jmp    c0101e3b <__alltraps>

c01025e5 <vector194>:
.globl vector194
vector194:
  pushl $0
c01025e5:	6a 00                	push   $0x0
  pushl $194
c01025e7:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01025ec:	e9 4a f8 ff ff       	jmp    c0101e3b <__alltraps>

c01025f1 <vector195>:
.globl vector195
vector195:
  pushl $0
c01025f1:	6a 00                	push   $0x0
  pushl $195
c01025f3:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01025f8:	e9 3e f8 ff ff       	jmp    c0101e3b <__alltraps>

c01025fd <vector196>:
.globl vector196
vector196:
  pushl $0
c01025fd:	6a 00                	push   $0x0
  pushl $196
c01025ff:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102604:	e9 32 f8 ff ff       	jmp    c0101e3b <__alltraps>

c0102609 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102609:	6a 00                	push   $0x0
  pushl $197
c010260b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102610:	e9 26 f8 ff ff       	jmp    c0101e3b <__alltraps>

c0102615 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102615:	6a 00                	push   $0x0
  pushl $198
c0102617:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010261c:	e9 1a f8 ff ff       	jmp    c0101e3b <__alltraps>

c0102621 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102621:	6a 00                	push   $0x0
  pushl $199
c0102623:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102628:	e9 0e f8 ff ff       	jmp    c0101e3b <__alltraps>

c010262d <vector200>:
.globl vector200
vector200:
  pushl $0
c010262d:	6a 00                	push   $0x0
  pushl $200
c010262f:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102634:	e9 02 f8 ff ff       	jmp    c0101e3b <__alltraps>

c0102639 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102639:	6a 00                	push   $0x0
  pushl $201
c010263b:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102640:	e9 f6 f7 ff ff       	jmp    c0101e3b <__alltraps>

c0102645 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102645:	6a 00                	push   $0x0
  pushl $202
c0102647:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010264c:	e9 ea f7 ff ff       	jmp    c0101e3b <__alltraps>

c0102651 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102651:	6a 00                	push   $0x0
  pushl $203
c0102653:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102658:	e9 de f7 ff ff       	jmp    c0101e3b <__alltraps>

c010265d <vector204>:
.globl vector204
vector204:
  pushl $0
c010265d:	6a 00                	push   $0x0
  pushl $204
c010265f:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102664:	e9 d2 f7 ff ff       	jmp    c0101e3b <__alltraps>

c0102669 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102669:	6a 00                	push   $0x0
  pushl $205
c010266b:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102670:	e9 c6 f7 ff ff       	jmp    c0101e3b <__alltraps>

c0102675 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102675:	6a 00                	push   $0x0
  pushl $206
c0102677:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010267c:	e9 ba f7 ff ff       	jmp    c0101e3b <__alltraps>

c0102681 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102681:	6a 00                	push   $0x0
  pushl $207
c0102683:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102688:	e9 ae f7 ff ff       	jmp    c0101e3b <__alltraps>

c010268d <vector208>:
.globl vector208
vector208:
  pushl $0
c010268d:	6a 00                	push   $0x0
  pushl $208
c010268f:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102694:	e9 a2 f7 ff ff       	jmp    c0101e3b <__alltraps>

c0102699 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102699:	6a 00                	push   $0x0
  pushl $209
c010269b:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01026a0:	e9 96 f7 ff ff       	jmp    c0101e3b <__alltraps>

c01026a5 <vector210>:
.globl vector210
vector210:
  pushl $0
c01026a5:	6a 00                	push   $0x0
  pushl $210
c01026a7:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01026ac:	e9 8a f7 ff ff       	jmp    c0101e3b <__alltraps>

c01026b1 <vector211>:
.globl vector211
vector211:
  pushl $0
c01026b1:	6a 00                	push   $0x0
  pushl $211
c01026b3:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01026b8:	e9 7e f7 ff ff       	jmp    c0101e3b <__alltraps>

c01026bd <vector212>:
.globl vector212
vector212:
  pushl $0
c01026bd:	6a 00                	push   $0x0
  pushl $212
c01026bf:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01026c4:	e9 72 f7 ff ff       	jmp    c0101e3b <__alltraps>

c01026c9 <vector213>:
.globl vector213
vector213:
  pushl $0
c01026c9:	6a 00                	push   $0x0
  pushl $213
c01026cb:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01026d0:	e9 66 f7 ff ff       	jmp    c0101e3b <__alltraps>

c01026d5 <vector214>:
.globl vector214
vector214:
  pushl $0
c01026d5:	6a 00                	push   $0x0
  pushl $214
c01026d7:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01026dc:	e9 5a f7 ff ff       	jmp    c0101e3b <__alltraps>

c01026e1 <vector215>:
.globl vector215
vector215:
  pushl $0
c01026e1:	6a 00                	push   $0x0
  pushl $215
c01026e3:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01026e8:	e9 4e f7 ff ff       	jmp    c0101e3b <__alltraps>

c01026ed <vector216>:
.globl vector216
vector216:
  pushl $0
c01026ed:	6a 00                	push   $0x0
  pushl $216
c01026ef:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01026f4:	e9 42 f7 ff ff       	jmp    c0101e3b <__alltraps>

c01026f9 <vector217>:
.globl vector217
vector217:
  pushl $0
c01026f9:	6a 00                	push   $0x0
  pushl $217
c01026fb:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102700:	e9 36 f7 ff ff       	jmp    c0101e3b <__alltraps>

c0102705 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102705:	6a 00                	push   $0x0
  pushl $218
c0102707:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010270c:	e9 2a f7 ff ff       	jmp    c0101e3b <__alltraps>

c0102711 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102711:	6a 00                	push   $0x0
  pushl $219
c0102713:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102718:	e9 1e f7 ff ff       	jmp    c0101e3b <__alltraps>

c010271d <vector220>:
.globl vector220
vector220:
  pushl $0
c010271d:	6a 00                	push   $0x0
  pushl $220
c010271f:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102724:	e9 12 f7 ff ff       	jmp    c0101e3b <__alltraps>

c0102729 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102729:	6a 00                	push   $0x0
  pushl $221
c010272b:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102730:	e9 06 f7 ff ff       	jmp    c0101e3b <__alltraps>

c0102735 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102735:	6a 00                	push   $0x0
  pushl $222
c0102737:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010273c:	e9 fa f6 ff ff       	jmp    c0101e3b <__alltraps>

c0102741 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102741:	6a 00                	push   $0x0
  pushl $223
c0102743:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102748:	e9 ee f6 ff ff       	jmp    c0101e3b <__alltraps>

c010274d <vector224>:
.globl vector224
vector224:
  pushl $0
c010274d:	6a 00                	push   $0x0
  pushl $224
c010274f:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102754:	e9 e2 f6 ff ff       	jmp    c0101e3b <__alltraps>

c0102759 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102759:	6a 00                	push   $0x0
  pushl $225
c010275b:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102760:	e9 d6 f6 ff ff       	jmp    c0101e3b <__alltraps>

c0102765 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102765:	6a 00                	push   $0x0
  pushl $226
c0102767:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010276c:	e9 ca f6 ff ff       	jmp    c0101e3b <__alltraps>

c0102771 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102771:	6a 00                	push   $0x0
  pushl $227
c0102773:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102778:	e9 be f6 ff ff       	jmp    c0101e3b <__alltraps>

c010277d <vector228>:
.globl vector228
vector228:
  pushl $0
c010277d:	6a 00                	push   $0x0
  pushl $228
c010277f:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102784:	e9 b2 f6 ff ff       	jmp    c0101e3b <__alltraps>

c0102789 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102789:	6a 00                	push   $0x0
  pushl $229
c010278b:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102790:	e9 a6 f6 ff ff       	jmp    c0101e3b <__alltraps>

c0102795 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102795:	6a 00                	push   $0x0
  pushl $230
c0102797:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010279c:	e9 9a f6 ff ff       	jmp    c0101e3b <__alltraps>

c01027a1 <vector231>:
.globl vector231
vector231:
  pushl $0
c01027a1:	6a 00                	push   $0x0
  pushl $231
c01027a3:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01027a8:	e9 8e f6 ff ff       	jmp    c0101e3b <__alltraps>

c01027ad <vector232>:
.globl vector232
vector232:
  pushl $0
c01027ad:	6a 00                	push   $0x0
  pushl $232
c01027af:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01027b4:	e9 82 f6 ff ff       	jmp    c0101e3b <__alltraps>

c01027b9 <vector233>:
.globl vector233
vector233:
  pushl $0
c01027b9:	6a 00                	push   $0x0
  pushl $233
c01027bb:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01027c0:	e9 76 f6 ff ff       	jmp    c0101e3b <__alltraps>

c01027c5 <vector234>:
.globl vector234
vector234:
  pushl $0
c01027c5:	6a 00                	push   $0x0
  pushl $234
c01027c7:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01027cc:	e9 6a f6 ff ff       	jmp    c0101e3b <__alltraps>

c01027d1 <vector235>:
.globl vector235
vector235:
  pushl $0
c01027d1:	6a 00                	push   $0x0
  pushl $235
c01027d3:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01027d8:	e9 5e f6 ff ff       	jmp    c0101e3b <__alltraps>

c01027dd <vector236>:
.globl vector236
vector236:
  pushl $0
c01027dd:	6a 00                	push   $0x0
  pushl $236
c01027df:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01027e4:	e9 52 f6 ff ff       	jmp    c0101e3b <__alltraps>

c01027e9 <vector237>:
.globl vector237
vector237:
  pushl $0
c01027e9:	6a 00                	push   $0x0
  pushl $237
c01027eb:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01027f0:	e9 46 f6 ff ff       	jmp    c0101e3b <__alltraps>

c01027f5 <vector238>:
.globl vector238
vector238:
  pushl $0
c01027f5:	6a 00                	push   $0x0
  pushl $238
c01027f7:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01027fc:	e9 3a f6 ff ff       	jmp    c0101e3b <__alltraps>

c0102801 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102801:	6a 00                	push   $0x0
  pushl $239
c0102803:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102808:	e9 2e f6 ff ff       	jmp    c0101e3b <__alltraps>

c010280d <vector240>:
.globl vector240
vector240:
  pushl $0
c010280d:	6a 00                	push   $0x0
  pushl $240
c010280f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102814:	e9 22 f6 ff ff       	jmp    c0101e3b <__alltraps>

c0102819 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102819:	6a 00                	push   $0x0
  pushl $241
c010281b:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102820:	e9 16 f6 ff ff       	jmp    c0101e3b <__alltraps>

c0102825 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102825:	6a 00                	push   $0x0
  pushl $242
c0102827:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010282c:	e9 0a f6 ff ff       	jmp    c0101e3b <__alltraps>

c0102831 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102831:	6a 00                	push   $0x0
  pushl $243
c0102833:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102838:	e9 fe f5 ff ff       	jmp    c0101e3b <__alltraps>

c010283d <vector244>:
.globl vector244
vector244:
  pushl $0
c010283d:	6a 00                	push   $0x0
  pushl $244
c010283f:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102844:	e9 f2 f5 ff ff       	jmp    c0101e3b <__alltraps>

c0102849 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102849:	6a 00                	push   $0x0
  pushl $245
c010284b:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102850:	e9 e6 f5 ff ff       	jmp    c0101e3b <__alltraps>

c0102855 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102855:	6a 00                	push   $0x0
  pushl $246
c0102857:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010285c:	e9 da f5 ff ff       	jmp    c0101e3b <__alltraps>

c0102861 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102861:	6a 00                	push   $0x0
  pushl $247
c0102863:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102868:	e9 ce f5 ff ff       	jmp    c0101e3b <__alltraps>

c010286d <vector248>:
.globl vector248
vector248:
  pushl $0
c010286d:	6a 00                	push   $0x0
  pushl $248
c010286f:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102874:	e9 c2 f5 ff ff       	jmp    c0101e3b <__alltraps>

c0102879 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102879:	6a 00                	push   $0x0
  pushl $249
c010287b:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102880:	e9 b6 f5 ff ff       	jmp    c0101e3b <__alltraps>

c0102885 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102885:	6a 00                	push   $0x0
  pushl $250
c0102887:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010288c:	e9 aa f5 ff ff       	jmp    c0101e3b <__alltraps>

c0102891 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102891:	6a 00                	push   $0x0
  pushl $251
c0102893:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102898:	e9 9e f5 ff ff       	jmp    c0101e3b <__alltraps>

c010289d <vector252>:
.globl vector252
vector252:
  pushl $0
c010289d:	6a 00                	push   $0x0
  pushl $252
c010289f:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01028a4:	e9 92 f5 ff ff       	jmp    c0101e3b <__alltraps>

c01028a9 <vector253>:
.globl vector253
vector253:
  pushl $0
c01028a9:	6a 00                	push   $0x0
  pushl $253
c01028ab:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01028b0:	e9 86 f5 ff ff       	jmp    c0101e3b <__alltraps>

c01028b5 <vector254>:
.globl vector254
vector254:
  pushl $0
c01028b5:	6a 00                	push   $0x0
  pushl $254
c01028b7:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01028bc:	e9 7a f5 ff ff       	jmp    c0101e3b <__alltraps>

c01028c1 <vector255>:
.globl vector255
vector255:
  pushl $0
c01028c1:	6a 00                	push   $0x0
  pushl $255
c01028c3:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01028c8:	e9 6e f5 ff ff       	jmp    c0101e3b <__alltraps>

c01028cd <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01028cd:	55                   	push   %ebp
c01028ce:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01028d0:	8b 55 08             	mov    0x8(%ebp),%edx
c01028d3:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c01028d8:	29 c2                	sub    %eax,%edx
c01028da:	89 d0                	mov    %edx,%eax
c01028dc:	c1 f8 02             	sar    $0x2,%eax
c01028df:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028e5:	5d                   	pop    %ebp
c01028e6:	c3                   	ret    

c01028e7 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028e7:	55                   	push   %ebp
c01028e8:	89 e5                	mov    %esp,%ebp
c01028ea:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01028ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01028f0:	89 04 24             	mov    %eax,(%esp)
c01028f3:	e8 d5 ff ff ff       	call   c01028cd <page2ppn>
c01028f8:	c1 e0 0c             	shl    $0xc,%eax
}
c01028fb:	c9                   	leave  
c01028fc:	c3                   	ret    

c01028fd <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01028fd:	55                   	push   %ebp
c01028fe:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102900:	8b 45 08             	mov    0x8(%ebp),%eax
c0102903:	8b 00                	mov    (%eax),%eax
}
c0102905:	5d                   	pop    %ebp
c0102906:	c3                   	ret    

c0102907 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102907:	55                   	push   %ebp
c0102908:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010290a:	8b 45 08             	mov    0x8(%ebp),%eax
c010290d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102910:	89 10                	mov    %edx,(%eax)
}
c0102912:	5d                   	pop    %ebp
c0102913:	c3                   	ret    

c0102914 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0102914:	55                   	push   %ebp
c0102915:	89 e5                	mov    %esp,%ebp
c0102917:	83 ec 10             	sub    $0x10,%esp
c010291a:	c7 45 fc b0 89 11 c0 	movl   $0xc01189b0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102921:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102924:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102927:	89 50 04             	mov    %edx,0x4(%eax)
c010292a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010292d:	8b 50 04             	mov    0x4(%eax),%edx
c0102930:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102933:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0102935:	c7 05 b8 89 11 c0 00 	movl   $0x0,0xc01189b8
c010293c:	00 00 00 
}
c010293f:	c9                   	leave  
c0102940:	c3                   	ret    

c0102941 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0102941:	55                   	push   %ebp
c0102942:	89 e5                	mov    %esp,%ebp
c0102944:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0102947:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010294b:	75 24                	jne    c0102971 <default_init_memmap+0x30>
c010294d:	c7 44 24 0c 10 66 10 	movl   $0xc0106610,0xc(%esp)
c0102954:	c0 
c0102955:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c010295c:	c0 
c010295d:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0102964:	00 
c0102965:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c010296c:	e8 ab e2 ff ff       	call   c0100c1c <__panic>
    struct Page *p = base;
c0102971:	8b 45 08             	mov    0x8(%ebp),%eax
c0102974:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102977:	e9 dc 00 00 00       	jmp    c0102a58 <default_init_memmap+0x117>
        assert(PageReserved(p));
c010297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010297f:	83 c0 04             	add    $0x4,%eax
c0102982:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102989:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010298c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010298f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102992:	0f a3 10             	bt     %edx,(%eax)
c0102995:	19 c0                	sbb    %eax,%eax
c0102997:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010299a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010299e:	0f 95 c0             	setne  %al
c01029a1:	0f b6 c0             	movzbl %al,%eax
c01029a4:	85 c0                	test   %eax,%eax
c01029a6:	75 24                	jne    c01029cc <default_init_memmap+0x8b>
c01029a8:	c7 44 24 0c 41 66 10 	movl   $0xc0106641,0xc(%esp)
c01029af:	c0 
c01029b0:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01029b7:	c0 
c01029b8:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01029bf:	00 
c01029c0:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01029c7:	e8 50 e2 ff ff       	call   c0100c1c <__panic>
        p->flags = 0;
c01029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
c01029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029d9:	83 c0 04             	add    $0x4,%eax
c01029dc:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01029e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01029e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01029e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01029ec:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c01029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
c01029f9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102a00:	00 
c0102a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a04:	89 04 24             	mov    %eax,(%esp)
c0102a07:	e8 fb fe ff ff       	call   c0102907 <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
c0102a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a0f:	83 c0 0c             	add    $0xc,%eax
c0102a12:	c7 45 dc b0 89 11 c0 	movl   $0xc01189b0,-0x24(%ebp)
c0102a19:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102a1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a1f:	8b 00                	mov    (%eax),%eax
c0102a21:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102a24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102a27:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102a2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a2d:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102a30:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a33:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a36:	89 10                	mov    %edx,(%eax)
c0102a38:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a3b:	8b 10                	mov    (%eax),%edx
c0102a3d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102a40:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102a43:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a46:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102a49:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a4f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102a52:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102a54:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102a58:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a5b:	89 d0                	mov    %edx,%eax
c0102a5d:	c1 e0 02             	shl    $0x2,%eax
c0102a60:	01 d0                	add    %edx,%eax
c0102a62:	c1 e0 02             	shl    $0x2,%eax
c0102a65:	89 c2                	mov    %eax,%edx
c0102a67:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a6a:	01 d0                	add    %edx,%eax
c0102a6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a6f:	0f 85 07 ff ff ff    	jne    c010297c <default_init_memmap+0x3b>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
c0102a75:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a78:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a7b:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c0102a7e:	8b 15 b8 89 11 c0    	mov    0xc01189b8,%edx
c0102a84:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a87:	01 d0                	add    %edx,%eax
c0102a89:	a3 b8 89 11 c0       	mov    %eax,0xc01189b8
}
c0102a8e:	c9                   	leave  
c0102a8f:	c3                   	ret    

c0102a90 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102a90:	55                   	push   %ebp
c0102a91:	89 e5                	mov    %esp,%ebp
c0102a93:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102a96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a9a:	75 24                	jne    c0102ac0 <default_alloc_pages+0x30>
c0102a9c:	c7 44 24 0c 10 66 10 	movl   $0xc0106610,0xc(%esp)
c0102aa3:	c0 
c0102aa4:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0102aab:	c0 
c0102aac:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
c0102ab3:	00 
c0102ab4:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0102abb:	e8 5c e1 ff ff       	call   c0100c1c <__panic>
    if (n > nr_free) {
c0102ac0:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c0102ac5:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ac8:	73 0a                	jae    c0102ad4 <default_alloc_pages+0x44>
        return NULL;
c0102aca:	b8 00 00 00 00       	mov    $0x0,%eax
c0102acf:	e9 37 01 00 00       	jmp    c0102c0b <default_alloc_pages+0x17b>
    }

    list_entry_t *le, *len;
    le = &free_list;
c0102ad4:	c7 45 f4 b0 89 11 c0 	movl   $0xc01189b0,-0xc(%ebp)

    while ((le = list_next(le)) != &free_list) {
c0102adb:	e9 0a 01 00 00       	jmp    c0102bea <default_alloc_pages+0x15a>
        struct Page *p = le2page(le, page_link);
c0102ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ae3:	83 e8 0c             	sub    $0xc,%eax
c0102ae6:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0102ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102aec:	8b 40 08             	mov    0x8(%eax),%eax
c0102aef:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102af2:	0f 82 f2 00 00 00    	jb     c0102bea <default_alloc_pages+0x15a>
            int i;
            //alloc the following n size block
            for (i = 0; i < n; i++) {
c0102af8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102aff:	eb 7c                	jmp    c0102b7d <default_alloc_pages+0xed>
c0102b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b04:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102b07:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b0a:	8b 40 04             	mov    0x4(%eax),%eax
            	len = list_next(le);
c0102b0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
            	struct Page *page = le2page(len, page_link);
c0102b10:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b13:	83 e8 0c             	sub    $0xc,%eax
c0102b16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            	SetPageReserved(page);
c0102b19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b1c:	83 c0 04             	add    $0x4,%eax
c0102b1f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102b26:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b2f:	0f ab 10             	bts    %edx,(%eax)
            	ClearPageProperty(page);
c0102b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b35:	83 c0 04             	add    $0x4,%eax
c0102b38:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102b3f:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b42:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b45:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102b48:	0f b3 10             	btr    %edx,(%eax)
c0102b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b4e:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102b51:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b54:	8b 40 04             	mov    0x4(%eax),%eax
c0102b57:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102b5a:	8b 12                	mov    (%edx),%edx
c0102b5c:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102b5f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b62:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b65:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b68:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b6b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b6e:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102b71:	89 10                	mov    %edx,(%eax)
            	list_del(le);
            	le = len;
c0102b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
            int i;
            //alloc the following n size block
            for (i = 0; i < n; i++) {
c0102b79:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0102b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b80:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b83:	0f 82 78 ff ff ff    	jb     c0102b01 <default_alloc_pages+0x71>
            	ClearPageProperty(page);
            	list_del(le);
            	le = len;
            }
            //add the splitted block to free list
            if (p->property > n)
c0102b89:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b8c:	8b 40 08             	mov    0x8(%eax),%eax
c0102b8f:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b92:	76 12                	jbe    c0102ba6 <default_alloc_pages+0x116>
            	(le2page(le, page_link))->property = p->property - n;
c0102b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b97:	8d 50 f4             	lea    -0xc(%eax),%edx
c0102b9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b9d:	8b 40 08             	mov    0x8(%eax),%eax
c0102ba0:	2b 45 08             	sub    0x8(%ebp),%eax
c0102ba3:	89 42 08             	mov    %eax,0x8(%edx)

            SetPageReserved(p);
c0102ba6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ba9:	83 c0 04             	add    $0x4,%eax
c0102bac:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
c0102bb3:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102bb6:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102bb9:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102bbc:	0f ab 10             	bts    %edx,(%eax)
            ClearPageProperty(p);
c0102bbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102bc2:	83 c0 04             	add    $0x4,%eax
c0102bc5:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102bcc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102bcf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102bd2:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102bd5:	0f b3 10             	btr    %edx,(%eax)
            nr_free -= n;
c0102bd8:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c0102bdd:	2b 45 08             	sub    0x8(%ebp),%eax
c0102be0:	a3 b8 89 11 c0       	mov    %eax,0xc01189b8
            return p;
c0102be5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102be8:	eb 21                	jmp    c0102c0b <default_alloc_pages+0x17b>
c0102bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bed:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102bf0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102bf3:	8b 40 04             	mov    0x4(%eax),%eax
    }

    list_entry_t *le, *len;
    le = &free_list;

    while ((le = list_next(le)) != &free_list) {
c0102bf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102bf9:	81 7d f4 b0 89 11 c0 	cmpl   $0xc01189b0,-0xc(%ebp)
c0102c00:	0f 85 da fe ff ff    	jne    c0102ae0 <default_alloc_pages+0x50>
            ClearPageProperty(p);
            nr_free -= n;
            return p;
        }
    }
    return NULL;
c0102c06:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102c0b:	c9                   	leave  
c0102c0c:	c3                   	ret    

c0102c0d <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102c0d:	55                   	push   %ebp
c0102c0e:	89 e5                	mov    %esp,%ebp
c0102c10:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102c13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102c17:	75 24                	jne    c0102c3d <default_free_pages+0x30>
c0102c19:	c7 44 24 0c 10 66 10 	movl   $0xc0106610,0xc(%esp)
c0102c20:	c0 
c0102c21:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0102c28:	c0 
c0102c29:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
c0102c30:	00 
c0102c31:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0102c38:	e8 df df ff ff       	call   c0100c1c <__panic>

    struct Page *p;
    list_entry_t *le = &free_list;
c0102c3d:	c7 45 f0 b0 89 11 c0 	movl   $0xc01189b0,-0x10(%ebp)
    //search the free list, find the correct position
    while ((le = list_next(le)) != &free_list) {
c0102c44:	eb 13                	jmp    c0102c59 <default_free_pages+0x4c>
    	p = le2page(le, page_link);
c0102c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c49:	83 e8 0c             	sub    $0xc,%eax
c0102c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	if (p > base)
c0102c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c52:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102c55:	76 02                	jbe    c0102c59 <default_free_pages+0x4c>
    		break;
c0102c57:	eb 18                	jmp    c0102c71 <default_free_pages+0x64>
c0102c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102c5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102c62:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);

    struct Page *p;
    list_entry_t *le = &free_list;
    //search the free list, find the correct position
    while ((le = list_next(le)) != &free_list) {
c0102c65:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102c68:	81 7d f0 b0 89 11 c0 	cmpl   $0xc01189b0,-0x10(%ebp)
c0102c6f:	75 d5                	jne    c0102c46 <default_free_pages+0x39>
    	p = le2page(le, page_link);
    	if (p > base)
    		break;
    }
	//insert the page
	for (p = base; p < base + n; p++)
c0102c71:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c74:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102c77:	eb 4b                	jmp    c0102cc4 <default_free_pages+0xb7>
		list_add_before(le, &(p->page_link));
c0102c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c7c:	8d 50 0c             	lea    0xc(%eax),%edx
c0102c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c82:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0102c85:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102c88:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c8b:	8b 00                	mov    (%eax),%eax
c0102c8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102c90:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0102c93:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102c96:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c99:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102c9c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102c9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102ca2:	89 10                	mov    %edx,(%eax)
c0102ca4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102ca7:	8b 10                	mov    (%eax),%edx
c0102ca9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102cac:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102caf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102cb2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102cb5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102cb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102cbb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102cbe:	89 10                	mov    %edx,(%eax)
    	p = le2page(le, page_link);
    	if (p > base)
    		break;
    }
	//insert the page
	for (p = base; p < base + n; p++)
c0102cc0:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cc7:	89 d0                	mov    %edx,%eax
c0102cc9:	c1 e0 02             	shl    $0x2,%eax
c0102ccc:	01 d0                	add    %edx,%eax
c0102cce:	c1 e0 02             	shl    $0x2,%eax
c0102cd1:	89 c2                	mov    %eax,%edx
c0102cd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cd6:	01 d0                	add    %edx,%eax
c0102cd8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102cdb:	77 9c                	ja     c0102c79 <default_free_pages+0x6c>
		list_add_before(le, &(p->page_link));
	base->flags = 0;
c0102cdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ce0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	set_page_ref(base, 0);
c0102ce7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102cee:	00 
c0102cef:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cf2:	89 04 24             	mov    %eax,(%esp)
c0102cf5:	e8 0d fc ff ff       	call   c0102907 <set_page_ref>
	ClearPageProperty(base);
c0102cfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cfd:	83 c0 04             	add    $0x4,%eax
c0102d00:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102d07:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102d0a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102d0d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102d10:	0f b3 10             	btr    %edx,(%eax)
	SetPageProperty(base);
c0102d13:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d16:	83 c0 04             	add    $0x4,%eax
c0102d19:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0102d20:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d23:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102d26:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102d29:	0f ab 10             	bts    %edx,(%eax)
	base->property = n;
c0102d2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d2f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d32:	89 50 08             	mov    %edx,0x8(%eax)
	
	//merge higher addr block
	p = le2page(le, page_link);
c0102d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d38:	83 e8 0c             	sub    $0xc,%eax
c0102d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if ((base + n) == p) {
c0102d3e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d41:	89 d0                	mov    %edx,%eax
c0102d43:	c1 e0 02             	shl    $0x2,%eax
c0102d46:	01 d0                	add    %edx,%eax
c0102d48:	c1 e0 02             	shl    $0x2,%eax
c0102d4b:	89 c2                	mov    %eax,%edx
c0102d4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d50:	01 d0                	add    %edx,%eax
c0102d52:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102d55:	75 1e                	jne    c0102d75 <default_free_pages+0x168>
		base->property += p->property;
c0102d57:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d5a:	8b 50 08             	mov    0x8(%eax),%edx
c0102d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d60:	8b 40 08             	mov    0x8(%eax),%eax
c0102d63:	01 c2                	add    %eax,%edx
c0102d65:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d68:	89 50 08             	mov    %edx,0x8(%eax)
		p->property = 0;
c0102d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d6e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	}
	//merge lower addr block
	le = list_prev(&(base->page_link));
c0102d75:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d78:	83 c0 0c             	add    $0xc,%eax
c0102d7b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102d7e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d81:	8b 00                	mov    (%eax),%eax
c0102d83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p = le2page(le, page_link);
c0102d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d89:	83 e8 0c             	sub    $0xc,%eax
c0102d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (le != &free_list && p + 1 == base) {
c0102d8f:	81 7d f0 b0 89 11 c0 	cmpl   $0xc01189b0,-0x10(%ebp)
c0102d96:	74 57                	je     c0102def <default_free_pages+0x1e2>
c0102d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d9b:	83 c0 14             	add    $0x14,%eax
c0102d9e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102da1:	75 4c                	jne    c0102def <default_free_pages+0x1e2>
		while (le != &free_list) {
c0102da3:	eb 41                	jmp    c0102de6 <default_free_pages+0x1d9>
			if (p->property != 0) {
c0102da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102da8:	8b 40 08             	mov    0x8(%eax),%eax
c0102dab:	85 c0                	test   %eax,%eax
c0102dad:	74 20                	je     c0102dcf <default_free_pages+0x1c2>
				p->property += base->property;
c0102daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102db2:	8b 50 08             	mov    0x8(%eax),%edx
c0102db5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102db8:	8b 40 08             	mov    0x8(%eax),%eax
c0102dbb:	01 c2                	add    %eax,%edx
c0102dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dc0:	89 50 08             	mov    %edx,0x8(%eax)
				base->property = 0;
c0102dc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dc6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				break;
c0102dcd:	eb 20                	jmp    c0102def <default_free_pages+0x1e2>
c0102dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dd2:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0102dd5:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102dd8:	8b 00                	mov    (%eax),%eax
			}
			le = list_prev(le);
c0102dda:	89 45 f0             	mov    %eax,-0x10(%ebp)
			p = le2page(le, page_link);
c0102ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102de0:	83 e8 0c             	sub    $0xc,%eax
c0102de3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	//merge lower addr block
	le = list_prev(&(base->page_link));
	p = le2page(le, page_link);
	if (le != &free_list && p + 1 == base) {
		while (le != &free_list) {
c0102de6:	81 7d f0 b0 89 11 c0 	cmpl   $0xc01189b0,-0x10(%ebp)
c0102ded:	75 b6                	jne    c0102da5 <default_free_pages+0x198>
			le = list_prev(le);
			p = le2page(le, page_link);
		}
	}
	
	nr_free += n;
c0102def:	8b 15 b8 89 11 c0    	mov    0xc01189b8,%edx
c0102df5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102df8:	01 d0                	add    %edx,%eax
c0102dfa:	a3 b8 89 11 c0       	mov    %eax,0xc01189b8
	return;
c0102dff:	90                   	nop
}
c0102e00:	c9                   	leave  
c0102e01:	c3                   	ret    

c0102e02 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102e02:	55                   	push   %ebp
c0102e03:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102e05:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
}
c0102e0a:	5d                   	pop    %ebp
c0102e0b:	c3                   	ret    

c0102e0c <basic_check>:

static void
basic_check(void) {
c0102e0c:	55                   	push   %ebp
c0102e0d:	89 e5                	mov    %esp,%ebp
c0102e0f:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102e12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e22:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102e25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e2c:	e8 85 0e 00 00       	call   c0103cb6 <alloc_pages>
c0102e31:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102e34:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102e38:	75 24                	jne    c0102e5e <basic_check+0x52>
c0102e3a:	c7 44 24 0c 51 66 10 	movl   $0xc0106651,0xc(%esp)
c0102e41:	c0 
c0102e42:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0102e49:	c0 
c0102e4a:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0102e51:	00 
c0102e52:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0102e59:	e8 be dd ff ff       	call   c0100c1c <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102e5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e65:	e8 4c 0e 00 00       	call   c0103cb6 <alloc_pages>
c0102e6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102e71:	75 24                	jne    c0102e97 <basic_check+0x8b>
c0102e73:	c7 44 24 0c 6d 66 10 	movl   $0xc010666d,0xc(%esp)
c0102e7a:	c0 
c0102e7b:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0102e82:	c0 
c0102e83:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c0102e8a:	00 
c0102e8b:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0102e92:	e8 85 dd ff ff       	call   c0100c1c <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102e97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e9e:	e8 13 0e 00 00       	call   c0103cb6 <alloc_pages>
c0102ea3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102ea6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102eaa:	75 24                	jne    c0102ed0 <basic_check+0xc4>
c0102eac:	c7 44 24 0c 89 66 10 	movl   $0xc0106689,0xc(%esp)
c0102eb3:	c0 
c0102eb4:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0102ebb:	c0 
c0102ebc:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0102ec3:	00 
c0102ec4:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0102ecb:	e8 4c dd ff ff       	call   c0100c1c <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102ed0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ed3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102ed6:	74 10                	je     c0102ee8 <basic_check+0xdc>
c0102ed8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102edb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ede:	74 08                	je     c0102ee8 <basic_check+0xdc>
c0102ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ee3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ee6:	75 24                	jne    c0102f0c <basic_check+0x100>
c0102ee8:	c7 44 24 0c a8 66 10 	movl   $0xc01066a8,0xc(%esp)
c0102eef:	c0 
c0102ef0:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0102ef7:	c0 
c0102ef8:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0102eff:	00 
c0102f00:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0102f07:	e8 10 dd ff ff       	call   c0100c1c <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102f0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f0f:	89 04 24             	mov    %eax,(%esp)
c0102f12:	e8 e6 f9 ff ff       	call   c01028fd <page_ref>
c0102f17:	85 c0                	test   %eax,%eax
c0102f19:	75 1e                	jne    c0102f39 <basic_check+0x12d>
c0102f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f1e:	89 04 24             	mov    %eax,(%esp)
c0102f21:	e8 d7 f9 ff ff       	call   c01028fd <page_ref>
c0102f26:	85 c0                	test   %eax,%eax
c0102f28:	75 0f                	jne    c0102f39 <basic_check+0x12d>
c0102f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f2d:	89 04 24             	mov    %eax,(%esp)
c0102f30:	e8 c8 f9 ff ff       	call   c01028fd <page_ref>
c0102f35:	85 c0                	test   %eax,%eax
c0102f37:	74 24                	je     c0102f5d <basic_check+0x151>
c0102f39:	c7 44 24 0c cc 66 10 	movl   $0xc01066cc,0xc(%esp)
c0102f40:	c0 
c0102f41:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0102f48:	c0 
c0102f49:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c0102f50:	00 
c0102f51:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0102f58:	e8 bf dc ff ff       	call   c0100c1c <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f60:	89 04 24             	mov    %eax,(%esp)
c0102f63:	e8 7f f9 ff ff       	call   c01028e7 <page2pa>
c0102f68:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102f6e:	c1 e2 0c             	shl    $0xc,%edx
c0102f71:	39 d0                	cmp    %edx,%eax
c0102f73:	72 24                	jb     c0102f99 <basic_check+0x18d>
c0102f75:	c7 44 24 0c 08 67 10 	movl   $0xc0106708,0xc(%esp)
c0102f7c:	c0 
c0102f7d:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0102f84:	c0 
c0102f85:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0102f8c:	00 
c0102f8d:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0102f94:	e8 83 dc ff ff       	call   c0100c1c <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f9c:	89 04 24             	mov    %eax,(%esp)
c0102f9f:	e8 43 f9 ff ff       	call   c01028e7 <page2pa>
c0102fa4:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102faa:	c1 e2 0c             	shl    $0xc,%edx
c0102fad:	39 d0                	cmp    %edx,%eax
c0102faf:	72 24                	jb     c0102fd5 <basic_check+0x1c9>
c0102fb1:	c7 44 24 0c 25 67 10 	movl   $0xc0106725,0xc(%esp)
c0102fb8:	c0 
c0102fb9:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0102fc0:	c0 
c0102fc1:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0102fc8:	00 
c0102fc9:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0102fd0:	e8 47 dc ff ff       	call   c0100c1c <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0102fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fd8:	89 04 24             	mov    %eax,(%esp)
c0102fdb:	e8 07 f9 ff ff       	call   c01028e7 <page2pa>
c0102fe0:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102fe6:	c1 e2 0c             	shl    $0xc,%edx
c0102fe9:	39 d0                	cmp    %edx,%eax
c0102feb:	72 24                	jb     c0103011 <basic_check+0x205>
c0102fed:	c7 44 24 0c 42 67 10 	movl   $0xc0106742,0xc(%esp)
c0102ff4:	c0 
c0102ff5:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0102ffc:	c0 
c0102ffd:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0103004:	00 
c0103005:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c010300c:	e8 0b dc ff ff       	call   c0100c1c <__panic>

    list_entry_t free_list_store = free_list;
c0103011:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c0103016:	8b 15 b4 89 11 c0    	mov    0xc01189b4,%edx
c010301c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010301f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103022:	c7 45 e0 b0 89 11 c0 	movl   $0xc01189b0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103029:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010302c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010302f:	89 50 04             	mov    %edx,0x4(%eax)
c0103032:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103035:	8b 50 04             	mov    0x4(%eax),%edx
c0103038:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010303b:	89 10                	mov    %edx,(%eax)
c010303d:	c7 45 dc b0 89 11 c0 	movl   $0xc01189b0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103044:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103047:	8b 40 04             	mov    0x4(%eax),%eax
c010304a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010304d:	0f 94 c0             	sete   %al
c0103050:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103053:	85 c0                	test   %eax,%eax
c0103055:	75 24                	jne    c010307b <basic_check+0x26f>
c0103057:	c7 44 24 0c 5f 67 10 	movl   $0xc010675f,0xc(%esp)
c010305e:	c0 
c010305f:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103066:	c0 
c0103067:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c010306e:	00 
c010306f:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103076:	e8 a1 db ff ff       	call   c0100c1c <__panic>

    unsigned int nr_free_store = nr_free;
c010307b:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c0103080:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103083:	c7 05 b8 89 11 c0 00 	movl   $0x0,0xc01189b8
c010308a:	00 00 00 

    assert(alloc_page() == NULL);
c010308d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103094:	e8 1d 0c 00 00       	call   c0103cb6 <alloc_pages>
c0103099:	85 c0                	test   %eax,%eax
c010309b:	74 24                	je     c01030c1 <basic_check+0x2b5>
c010309d:	c7 44 24 0c 76 67 10 	movl   $0xc0106776,0xc(%esp)
c01030a4:	c0 
c01030a5:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01030ac:	c0 
c01030ad:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c01030b4:	00 
c01030b5:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01030bc:	e8 5b db ff ff       	call   c0100c1c <__panic>

    free_page(p0);
c01030c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030c8:	00 
c01030c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030cc:	89 04 24             	mov    %eax,(%esp)
c01030cf:	e8 1a 0c 00 00       	call   c0103cee <free_pages>
    free_page(p1);
c01030d4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030db:	00 
c01030dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030df:	89 04 24             	mov    %eax,(%esp)
c01030e2:	e8 07 0c 00 00       	call   c0103cee <free_pages>
    free_page(p2);
c01030e7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030ee:	00 
c01030ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030f2:	89 04 24             	mov    %eax,(%esp)
c01030f5:	e8 f4 0b 00 00       	call   c0103cee <free_pages>
    assert(nr_free == 3);
c01030fa:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c01030ff:	83 f8 03             	cmp    $0x3,%eax
c0103102:	74 24                	je     c0103128 <basic_check+0x31c>
c0103104:	c7 44 24 0c 8b 67 10 	movl   $0xc010678b,0xc(%esp)
c010310b:	c0 
c010310c:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103113:	c0 
c0103114:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c010311b:	00 
c010311c:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103123:	e8 f4 da ff ff       	call   c0100c1c <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103128:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010312f:	e8 82 0b 00 00       	call   c0103cb6 <alloc_pages>
c0103134:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103137:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010313b:	75 24                	jne    c0103161 <basic_check+0x355>
c010313d:	c7 44 24 0c 51 66 10 	movl   $0xc0106651,0xc(%esp)
c0103144:	c0 
c0103145:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c010314c:	c0 
c010314d:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0103154:	00 
c0103155:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c010315c:	e8 bb da ff ff       	call   c0100c1c <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103161:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103168:	e8 49 0b 00 00       	call   c0103cb6 <alloc_pages>
c010316d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103170:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103174:	75 24                	jne    c010319a <basic_check+0x38e>
c0103176:	c7 44 24 0c 6d 66 10 	movl   $0xc010666d,0xc(%esp)
c010317d:	c0 
c010317e:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103185:	c0 
c0103186:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c010318d:	00 
c010318e:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103195:	e8 82 da ff ff       	call   c0100c1c <__panic>
    assert((p2 = alloc_page()) != NULL);
c010319a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031a1:	e8 10 0b 00 00       	call   c0103cb6 <alloc_pages>
c01031a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01031a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031ad:	75 24                	jne    c01031d3 <basic_check+0x3c7>
c01031af:	c7 44 24 0c 89 66 10 	movl   $0xc0106689,0xc(%esp)
c01031b6:	c0 
c01031b7:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01031be:	c0 
c01031bf:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c01031c6:	00 
c01031c7:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01031ce:	e8 49 da ff ff       	call   c0100c1c <__panic>

    assert(alloc_page() == NULL);
c01031d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031da:	e8 d7 0a 00 00       	call   c0103cb6 <alloc_pages>
c01031df:	85 c0                	test   %eax,%eax
c01031e1:	74 24                	je     c0103207 <basic_check+0x3fb>
c01031e3:	c7 44 24 0c 76 67 10 	movl   $0xc0106776,0xc(%esp)
c01031ea:	c0 
c01031eb:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01031f2:	c0 
c01031f3:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c01031fa:	00 
c01031fb:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103202:	e8 15 da ff ff       	call   c0100c1c <__panic>

    free_page(p0);
c0103207:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010320e:	00 
c010320f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103212:	89 04 24             	mov    %eax,(%esp)
c0103215:	e8 d4 0a 00 00       	call   c0103cee <free_pages>
c010321a:	c7 45 d8 b0 89 11 c0 	movl   $0xc01189b0,-0x28(%ebp)
c0103221:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103224:	8b 40 04             	mov    0x4(%eax),%eax
c0103227:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010322a:	0f 94 c0             	sete   %al
c010322d:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103230:	85 c0                	test   %eax,%eax
c0103232:	74 24                	je     c0103258 <basic_check+0x44c>
c0103234:	c7 44 24 0c 98 67 10 	movl   $0xc0106798,0xc(%esp)
c010323b:	c0 
c010323c:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103243:	c0 
c0103244:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c010324b:	00 
c010324c:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103253:	e8 c4 d9 ff ff       	call   c0100c1c <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103258:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010325f:	e8 52 0a 00 00       	call   c0103cb6 <alloc_pages>
c0103264:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103267:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010326a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010326d:	74 24                	je     c0103293 <basic_check+0x487>
c010326f:	c7 44 24 0c b0 67 10 	movl   $0xc01067b0,0xc(%esp)
c0103276:	c0 
c0103277:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c010327e:	c0 
c010327f:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0103286:	00 
c0103287:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c010328e:	e8 89 d9 ff ff       	call   c0100c1c <__panic>
    assert(alloc_page() == NULL);
c0103293:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010329a:	e8 17 0a 00 00       	call   c0103cb6 <alloc_pages>
c010329f:	85 c0                	test   %eax,%eax
c01032a1:	74 24                	je     c01032c7 <basic_check+0x4bb>
c01032a3:	c7 44 24 0c 76 67 10 	movl   $0xc0106776,0xc(%esp)
c01032aa:	c0 
c01032ab:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01032b2:	c0 
c01032b3:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c01032ba:	00 
c01032bb:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01032c2:	e8 55 d9 ff ff       	call   c0100c1c <__panic>

    assert(nr_free == 0);
c01032c7:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c01032cc:	85 c0                	test   %eax,%eax
c01032ce:	74 24                	je     c01032f4 <basic_check+0x4e8>
c01032d0:	c7 44 24 0c c9 67 10 	movl   $0xc01067c9,0xc(%esp)
c01032d7:	c0 
c01032d8:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01032df:	c0 
c01032e0:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c01032e7:	00 
c01032e8:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01032ef:	e8 28 d9 ff ff       	call   c0100c1c <__panic>
    free_list = free_list_store;
c01032f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01032f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01032fa:	a3 b0 89 11 c0       	mov    %eax,0xc01189b0
c01032ff:	89 15 b4 89 11 c0    	mov    %edx,0xc01189b4
    nr_free = nr_free_store;
c0103305:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103308:	a3 b8 89 11 c0       	mov    %eax,0xc01189b8

    free_page(p);
c010330d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103314:	00 
c0103315:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103318:	89 04 24             	mov    %eax,(%esp)
c010331b:	e8 ce 09 00 00       	call   c0103cee <free_pages>
    free_page(p1);
c0103320:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103327:	00 
c0103328:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010332b:	89 04 24             	mov    %eax,(%esp)
c010332e:	e8 bb 09 00 00       	call   c0103cee <free_pages>
    free_page(p2);
c0103333:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010333a:	00 
c010333b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010333e:	89 04 24             	mov    %eax,(%esp)
c0103341:	e8 a8 09 00 00       	call   c0103cee <free_pages>
}
c0103346:	c9                   	leave  
c0103347:	c3                   	ret    

c0103348 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103348:	55                   	push   %ebp
c0103349:	89 e5                	mov    %esp,%ebp
c010334b:	53                   	push   %ebx
c010334c:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103352:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103359:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103360:	c7 45 ec b0 89 11 c0 	movl   $0xc01189b0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103367:	eb 6b                	jmp    c01033d4 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103369:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010336c:	83 e8 0c             	sub    $0xc,%eax
c010336f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103372:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103375:	83 c0 04             	add    $0x4,%eax
c0103378:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010337f:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103382:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103385:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103388:	0f a3 10             	bt     %edx,(%eax)
c010338b:	19 c0                	sbb    %eax,%eax
c010338d:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103390:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103394:	0f 95 c0             	setne  %al
c0103397:	0f b6 c0             	movzbl %al,%eax
c010339a:	85 c0                	test   %eax,%eax
c010339c:	75 24                	jne    c01033c2 <default_check+0x7a>
c010339e:	c7 44 24 0c d6 67 10 	movl   $0xc01067d6,0xc(%esp)
c01033a5:	c0 
c01033a6:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01033ad:	c0 
c01033ae:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c01033b5:	00 
c01033b6:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01033bd:	e8 5a d8 ff ff       	call   c0100c1c <__panic>
        count ++, total += p->property;
c01033c2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01033c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033c9:	8b 50 08             	mov    0x8(%eax),%edx
c01033cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033cf:	01 d0                	add    %edx,%eax
c01033d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033d7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01033da:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01033dd:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01033e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01033e3:	81 7d ec b0 89 11 c0 	cmpl   $0xc01189b0,-0x14(%ebp)
c01033ea:	0f 85 79 ff ff ff    	jne    c0103369 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01033f0:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01033f3:	e8 28 09 00 00       	call   c0103d20 <nr_free_pages>
c01033f8:	39 c3                	cmp    %eax,%ebx
c01033fa:	74 24                	je     c0103420 <default_check+0xd8>
c01033fc:	c7 44 24 0c e6 67 10 	movl   $0xc01067e6,0xc(%esp)
c0103403:	c0 
c0103404:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c010340b:	c0 
c010340c:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0103413:	00 
c0103414:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c010341b:	e8 fc d7 ff ff       	call   c0100c1c <__panic>

    basic_check();
c0103420:	e8 e7 f9 ff ff       	call   c0102e0c <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103425:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010342c:	e8 85 08 00 00       	call   c0103cb6 <alloc_pages>
c0103431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103434:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103438:	75 24                	jne    c010345e <default_check+0x116>
c010343a:	c7 44 24 0c ff 67 10 	movl   $0xc01067ff,0xc(%esp)
c0103441:	c0 
c0103442:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103449:	c0 
c010344a:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103451:	00 
c0103452:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103459:	e8 be d7 ff ff       	call   c0100c1c <__panic>
    assert(!PageProperty(p0));
c010345e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103461:	83 c0 04             	add    $0x4,%eax
c0103464:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010346b:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010346e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103471:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103474:	0f a3 10             	bt     %edx,(%eax)
c0103477:	19 c0                	sbb    %eax,%eax
c0103479:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010347c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103480:	0f 95 c0             	setne  %al
c0103483:	0f b6 c0             	movzbl %al,%eax
c0103486:	85 c0                	test   %eax,%eax
c0103488:	74 24                	je     c01034ae <default_check+0x166>
c010348a:	c7 44 24 0c 0a 68 10 	movl   $0xc010680a,0xc(%esp)
c0103491:	c0 
c0103492:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103499:	c0 
c010349a:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c01034a1:	00 
c01034a2:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01034a9:	e8 6e d7 ff ff       	call   c0100c1c <__panic>

    list_entry_t free_list_store = free_list;
c01034ae:	a1 b0 89 11 c0       	mov    0xc01189b0,%eax
c01034b3:	8b 15 b4 89 11 c0    	mov    0xc01189b4,%edx
c01034b9:	89 45 80             	mov    %eax,-0x80(%ebp)
c01034bc:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01034bf:	c7 45 b4 b0 89 11 c0 	movl   $0xc01189b0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01034c6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034c9:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01034cc:	89 50 04             	mov    %edx,0x4(%eax)
c01034cf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034d2:	8b 50 04             	mov    0x4(%eax),%edx
c01034d5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034d8:	89 10                	mov    %edx,(%eax)
c01034da:	c7 45 b0 b0 89 11 c0 	movl   $0xc01189b0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01034e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01034e4:	8b 40 04             	mov    0x4(%eax),%eax
c01034e7:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c01034ea:	0f 94 c0             	sete   %al
c01034ed:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01034f0:	85 c0                	test   %eax,%eax
c01034f2:	75 24                	jne    c0103518 <default_check+0x1d0>
c01034f4:	c7 44 24 0c 5f 67 10 	movl   $0xc010675f,0xc(%esp)
c01034fb:	c0 
c01034fc:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103503:	c0 
c0103504:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c010350b:	00 
c010350c:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103513:	e8 04 d7 ff ff       	call   c0100c1c <__panic>
    assert(alloc_page() == NULL);
c0103518:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010351f:	e8 92 07 00 00       	call   c0103cb6 <alloc_pages>
c0103524:	85 c0                	test   %eax,%eax
c0103526:	74 24                	je     c010354c <default_check+0x204>
c0103528:	c7 44 24 0c 76 67 10 	movl   $0xc0106776,0xc(%esp)
c010352f:	c0 
c0103530:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103537:	c0 
c0103538:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c010353f:	00 
c0103540:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103547:	e8 d0 d6 ff ff       	call   c0100c1c <__panic>

    unsigned int nr_free_store = nr_free;
c010354c:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c0103551:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103554:	c7 05 b8 89 11 c0 00 	movl   $0x0,0xc01189b8
c010355b:	00 00 00 

    free_pages(p0 + 2, 3);
c010355e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103561:	83 c0 28             	add    $0x28,%eax
c0103564:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010356b:	00 
c010356c:	89 04 24             	mov    %eax,(%esp)
c010356f:	e8 7a 07 00 00       	call   c0103cee <free_pages>
    assert(alloc_pages(4) == NULL);
c0103574:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010357b:	e8 36 07 00 00       	call   c0103cb6 <alloc_pages>
c0103580:	85 c0                	test   %eax,%eax
c0103582:	74 24                	je     c01035a8 <default_check+0x260>
c0103584:	c7 44 24 0c 1c 68 10 	movl   $0xc010681c,0xc(%esp)
c010358b:	c0 
c010358c:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103593:	c0 
c0103594:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c010359b:	00 
c010359c:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01035a3:	e8 74 d6 ff ff       	call   c0100c1c <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01035a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035ab:	83 c0 28             	add    $0x28,%eax
c01035ae:	83 c0 04             	add    $0x4,%eax
c01035b1:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01035b8:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035bb:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01035be:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01035c1:	0f a3 10             	bt     %edx,(%eax)
c01035c4:	19 c0                	sbb    %eax,%eax
c01035c6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01035c9:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01035cd:	0f 95 c0             	setne  %al
c01035d0:	0f b6 c0             	movzbl %al,%eax
c01035d3:	85 c0                	test   %eax,%eax
c01035d5:	74 0e                	je     c01035e5 <default_check+0x29d>
c01035d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035da:	83 c0 28             	add    $0x28,%eax
c01035dd:	8b 40 08             	mov    0x8(%eax),%eax
c01035e0:	83 f8 03             	cmp    $0x3,%eax
c01035e3:	74 24                	je     c0103609 <default_check+0x2c1>
c01035e5:	c7 44 24 0c 34 68 10 	movl   $0xc0106834,0xc(%esp)
c01035ec:	c0 
c01035ed:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01035f4:	c0 
c01035f5:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01035fc:	00 
c01035fd:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103604:	e8 13 d6 ff ff       	call   c0100c1c <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103609:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103610:	e8 a1 06 00 00       	call   c0103cb6 <alloc_pages>
c0103615:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103618:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010361c:	75 24                	jne    c0103642 <default_check+0x2fa>
c010361e:	c7 44 24 0c 60 68 10 	movl   $0xc0106860,0xc(%esp)
c0103625:	c0 
c0103626:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c010362d:	c0 
c010362e:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103635:	00 
c0103636:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c010363d:	e8 da d5 ff ff       	call   c0100c1c <__panic>
    assert(alloc_page() == NULL);
c0103642:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103649:	e8 68 06 00 00       	call   c0103cb6 <alloc_pages>
c010364e:	85 c0                	test   %eax,%eax
c0103650:	74 24                	je     c0103676 <default_check+0x32e>
c0103652:	c7 44 24 0c 76 67 10 	movl   $0xc0106776,0xc(%esp)
c0103659:	c0 
c010365a:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103661:	c0 
c0103662:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0103669:	00 
c010366a:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103671:	e8 a6 d5 ff ff       	call   c0100c1c <__panic>
    assert(p0 + 2 == p1);
c0103676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103679:	83 c0 28             	add    $0x28,%eax
c010367c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010367f:	74 24                	je     c01036a5 <default_check+0x35d>
c0103681:	c7 44 24 0c 7e 68 10 	movl   $0xc010687e,0xc(%esp)
c0103688:	c0 
c0103689:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103690:	c0 
c0103691:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0103698:	00 
c0103699:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01036a0:	e8 77 d5 ff ff       	call   c0100c1c <__panic>

    p2 = p0 + 1;
c01036a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036a8:	83 c0 14             	add    $0x14,%eax
c01036ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01036ae:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01036b5:	00 
c01036b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036b9:	89 04 24             	mov    %eax,(%esp)
c01036bc:	e8 2d 06 00 00       	call   c0103cee <free_pages>
    free_pages(p1, 3);
c01036c1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01036c8:	00 
c01036c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01036cc:	89 04 24             	mov    %eax,(%esp)
c01036cf:	e8 1a 06 00 00       	call   c0103cee <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01036d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036d7:	83 c0 04             	add    $0x4,%eax
c01036da:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01036e1:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036e4:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01036e7:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01036ea:	0f a3 10             	bt     %edx,(%eax)
c01036ed:	19 c0                	sbb    %eax,%eax
c01036ef:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01036f2:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01036f6:	0f 95 c0             	setne  %al
c01036f9:	0f b6 c0             	movzbl %al,%eax
c01036fc:	85 c0                	test   %eax,%eax
c01036fe:	74 0b                	je     c010370b <default_check+0x3c3>
c0103700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103703:	8b 40 08             	mov    0x8(%eax),%eax
c0103706:	83 f8 01             	cmp    $0x1,%eax
c0103709:	74 24                	je     c010372f <default_check+0x3e7>
c010370b:	c7 44 24 0c 8c 68 10 	movl   $0xc010688c,0xc(%esp)
c0103712:	c0 
c0103713:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c010371a:	c0 
c010371b:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0103722:	00 
c0103723:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c010372a:	e8 ed d4 ff ff       	call   c0100c1c <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010372f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103732:	83 c0 04             	add    $0x4,%eax
c0103735:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010373c:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010373f:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103742:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103745:	0f a3 10             	bt     %edx,(%eax)
c0103748:	19 c0                	sbb    %eax,%eax
c010374a:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010374d:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103751:	0f 95 c0             	setne  %al
c0103754:	0f b6 c0             	movzbl %al,%eax
c0103757:	85 c0                	test   %eax,%eax
c0103759:	74 0b                	je     c0103766 <default_check+0x41e>
c010375b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010375e:	8b 40 08             	mov    0x8(%eax),%eax
c0103761:	83 f8 03             	cmp    $0x3,%eax
c0103764:	74 24                	je     c010378a <default_check+0x442>
c0103766:	c7 44 24 0c b4 68 10 	movl   $0xc01068b4,0xc(%esp)
c010376d:	c0 
c010376e:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103775:	c0 
c0103776:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010377d:	00 
c010377e:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103785:	e8 92 d4 ff ff       	call   c0100c1c <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010378a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103791:	e8 20 05 00 00       	call   c0103cb6 <alloc_pages>
c0103796:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103799:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010379c:	83 e8 14             	sub    $0x14,%eax
c010379f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01037a2:	74 24                	je     c01037c8 <default_check+0x480>
c01037a4:	c7 44 24 0c da 68 10 	movl   $0xc01068da,0xc(%esp)
c01037ab:	c0 
c01037ac:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01037b3:	c0 
c01037b4:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c01037bb:	00 
c01037bc:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01037c3:	e8 54 d4 ff ff       	call   c0100c1c <__panic>
    free_page(p0);
c01037c8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01037cf:	00 
c01037d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037d3:	89 04 24             	mov    %eax,(%esp)
c01037d6:	e8 13 05 00 00       	call   c0103cee <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01037db:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01037e2:	e8 cf 04 00 00       	call   c0103cb6 <alloc_pages>
c01037e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037ed:	83 c0 14             	add    $0x14,%eax
c01037f0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01037f3:	74 24                	je     c0103819 <default_check+0x4d1>
c01037f5:	c7 44 24 0c f8 68 10 	movl   $0xc01068f8,0xc(%esp)
c01037fc:	c0 
c01037fd:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103804:	c0 
c0103805:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c010380c:	00 
c010380d:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103814:	e8 03 d4 ff ff       	call   c0100c1c <__panic>

    free_pages(p0, 2);
c0103819:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103820:	00 
c0103821:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103824:	89 04 24             	mov    %eax,(%esp)
c0103827:	e8 c2 04 00 00       	call   c0103cee <free_pages>
    free_page(p2);
c010382c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103833:	00 
c0103834:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103837:	89 04 24             	mov    %eax,(%esp)
c010383a:	e8 af 04 00 00       	call   c0103cee <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c010383f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103846:	e8 6b 04 00 00       	call   c0103cb6 <alloc_pages>
c010384b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010384e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103852:	75 24                	jne    c0103878 <default_check+0x530>
c0103854:	c7 44 24 0c 18 69 10 	movl   $0xc0106918,0xc(%esp)
c010385b:	c0 
c010385c:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103863:	c0 
c0103864:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c010386b:	00 
c010386c:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103873:	e8 a4 d3 ff ff       	call   c0100c1c <__panic>
    assert(alloc_page() == NULL);
c0103878:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010387f:	e8 32 04 00 00       	call   c0103cb6 <alloc_pages>
c0103884:	85 c0                	test   %eax,%eax
c0103886:	74 24                	je     c01038ac <default_check+0x564>
c0103888:	c7 44 24 0c 76 67 10 	movl   $0xc0106776,0xc(%esp)
c010388f:	c0 
c0103890:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103897:	c0 
c0103898:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c010389f:	00 
c01038a0:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01038a7:	e8 70 d3 ff ff       	call   c0100c1c <__panic>

    assert(nr_free == 0);
c01038ac:	a1 b8 89 11 c0       	mov    0xc01189b8,%eax
c01038b1:	85 c0                	test   %eax,%eax
c01038b3:	74 24                	je     c01038d9 <default_check+0x591>
c01038b5:	c7 44 24 0c c9 67 10 	movl   $0xc01067c9,0xc(%esp)
c01038bc:	c0 
c01038bd:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c01038c4:	c0 
c01038c5:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c01038cc:	00 
c01038cd:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c01038d4:	e8 43 d3 ff ff       	call   c0100c1c <__panic>
    nr_free = nr_free_store;
c01038d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01038dc:	a3 b8 89 11 c0       	mov    %eax,0xc01189b8

    free_list = free_list_store;
c01038e1:	8b 45 80             	mov    -0x80(%ebp),%eax
c01038e4:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01038e7:	a3 b0 89 11 c0       	mov    %eax,0xc01189b0
c01038ec:	89 15 b4 89 11 c0    	mov    %edx,0xc01189b4
    free_pages(p0, 5);
c01038f2:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01038f9:	00 
c01038fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038fd:	89 04 24             	mov    %eax,(%esp)
c0103900:	e8 e9 03 00 00       	call   c0103cee <free_pages>

    le = &free_list;
c0103905:	c7 45 ec b0 89 11 c0 	movl   $0xc01189b0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010390c:	eb 1d                	jmp    c010392b <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c010390e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103911:	83 e8 0c             	sub    $0xc,%eax
c0103914:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103917:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010391b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010391e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103921:	8b 40 08             	mov    0x8(%eax),%eax
c0103924:	29 c2                	sub    %eax,%edx
c0103926:	89 d0                	mov    %edx,%eax
c0103928:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010392b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010392e:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103931:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103934:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103937:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010393a:	81 7d ec b0 89 11 c0 	cmpl   $0xc01189b0,-0x14(%ebp)
c0103941:	75 cb                	jne    c010390e <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103943:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103947:	74 24                	je     c010396d <default_check+0x625>
c0103949:	c7 44 24 0c 36 69 10 	movl   $0xc0106936,0xc(%esp)
c0103950:	c0 
c0103951:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103958:	c0 
c0103959:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c0103960:	00 
c0103961:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103968:	e8 af d2 ff ff       	call   c0100c1c <__panic>
    assert(total == 0);
c010396d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103971:	74 24                	je     c0103997 <default_check+0x64f>
c0103973:	c7 44 24 0c 41 69 10 	movl   $0xc0106941,0xc(%esp)
c010397a:	c0 
c010397b:	c7 44 24 08 16 66 10 	movl   $0xc0106616,0x8(%esp)
c0103982:	c0 
c0103983:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c010398a:	00 
c010398b:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0103992:	e8 85 d2 ff ff       	call   c0100c1c <__panic>
}
c0103997:	81 c4 94 00 00 00    	add    $0x94,%esp
c010399d:	5b                   	pop    %ebx
c010399e:	5d                   	pop    %ebp
c010399f:	c3                   	ret    

c01039a0 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01039a0:	55                   	push   %ebp
c01039a1:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01039a3:	8b 55 08             	mov    0x8(%ebp),%edx
c01039a6:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c01039ab:	29 c2                	sub    %eax,%edx
c01039ad:	89 d0                	mov    %edx,%eax
c01039af:	c1 f8 02             	sar    $0x2,%eax
c01039b2:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01039b8:	5d                   	pop    %ebp
c01039b9:	c3                   	ret    

c01039ba <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01039ba:	55                   	push   %ebp
c01039bb:	89 e5                	mov    %esp,%ebp
c01039bd:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01039c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01039c3:	89 04 24             	mov    %eax,(%esp)
c01039c6:	e8 d5 ff ff ff       	call   c01039a0 <page2ppn>
c01039cb:	c1 e0 0c             	shl    $0xc,%eax
}
c01039ce:	c9                   	leave  
c01039cf:	c3                   	ret    

c01039d0 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01039d0:	55                   	push   %ebp
c01039d1:	89 e5                	mov    %esp,%ebp
c01039d3:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01039d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01039d9:	c1 e8 0c             	shr    $0xc,%eax
c01039dc:	89 c2                	mov    %eax,%edx
c01039de:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01039e3:	39 c2                	cmp    %eax,%edx
c01039e5:	72 1c                	jb     c0103a03 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01039e7:	c7 44 24 08 7c 69 10 	movl   $0xc010697c,0x8(%esp)
c01039ee:	c0 
c01039ef:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c01039f6:	00 
c01039f7:	c7 04 24 9b 69 10 c0 	movl   $0xc010699b,(%esp)
c01039fe:	e8 19 d2 ff ff       	call   c0100c1c <__panic>
    }
    return &pages[PPN(pa)];
c0103a03:	8b 0d c4 89 11 c0    	mov    0xc01189c4,%ecx
c0103a09:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a0c:	c1 e8 0c             	shr    $0xc,%eax
c0103a0f:	89 c2                	mov    %eax,%edx
c0103a11:	89 d0                	mov    %edx,%eax
c0103a13:	c1 e0 02             	shl    $0x2,%eax
c0103a16:	01 d0                	add    %edx,%eax
c0103a18:	c1 e0 02             	shl    $0x2,%eax
c0103a1b:	01 c8                	add    %ecx,%eax
}
c0103a1d:	c9                   	leave  
c0103a1e:	c3                   	ret    

c0103a1f <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103a1f:	55                   	push   %ebp
c0103a20:	89 e5                	mov    %esp,%ebp
c0103a22:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103a25:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a28:	89 04 24             	mov    %eax,(%esp)
c0103a2b:	e8 8a ff ff ff       	call   c01039ba <page2pa>
c0103a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a36:	c1 e8 0c             	shr    $0xc,%eax
c0103a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a3c:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103a41:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103a44:	72 23                	jb     c0103a69 <page2kva+0x4a>
c0103a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a49:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103a4d:	c7 44 24 08 ac 69 10 	movl   $0xc01069ac,0x8(%esp)
c0103a54:	c0 
c0103a55:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103a5c:	00 
c0103a5d:	c7 04 24 9b 69 10 c0 	movl   $0xc010699b,(%esp)
c0103a64:	e8 b3 d1 ff ff       	call   c0100c1c <__panic>
c0103a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a6c:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103a71:	c9                   	leave  
c0103a72:	c3                   	ret    

c0103a73 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103a73:	55                   	push   %ebp
c0103a74:	89 e5                	mov    %esp,%ebp
c0103a76:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103a79:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a7c:	83 e0 01             	and    $0x1,%eax
c0103a7f:	85 c0                	test   %eax,%eax
c0103a81:	75 1c                	jne    c0103a9f <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103a83:	c7 44 24 08 d0 69 10 	movl   $0xc01069d0,0x8(%esp)
c0103a8a:	c0 
c0103a8b:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103a92:	00 
c0103a93:	c7 04 24 9b 69 10 c0 	movl   $0xc010699b,(%esp)
c0103a9a:	e8 7d d1 ff ff       	call   c0100c1c <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aa2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103aa7:	89 04 24             	mov    %eax,(%esp)
c0103aaa:	e8 21 ff ff ff       	call   c01039d0 <pa2page>
}
c0103aaf:	c9                   	leave  
c0103ab0:	c3                   	ret    

c0103ab1 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103ab1:	55                   	push   %ebp
c0103ab2:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103ab4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ab7:	8b 00                	mov    (%eax),%eax
}
c0103ab9:	5d                   	pop    %ebp
c0103aba:	c3                   	ret    

c0103abb <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103abb:	55                   	push   %ebp
c0103abc:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103abe:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ac1:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103ac4:	89 10                	mov    %edx,(%eax)
}
c0103ac6:	5d                   	pop    %ebp
c0103ac7:	c3                   	ret    

c0103ac8 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103ac8:	55                   	push   %ebp
c0103ac9:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103acb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ace:	8b 00                	mov    (%eax),%eax
c0103ad0:	8d 50 01             	lea    0x1(%eax),%edx
c0103ad3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ad6:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103ad8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103adb:	8b 00                	mov    (%eax),%eax
}
c0103add:	5d                   	pop    %ebp
c0103ade:	c3                   	ret    

c0103adf <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103adf:	55                   	push   %ebp
c0103ae0:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103ae2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ae5:	8b 00                	mov    (%eax),%eax
c0103ae7:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103aea:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aed:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103aef:	8b 45 08             	mov    0x8(%ebp),%eax
c0103af2:	8b 00                	mov    (%eax),%eax
}
c0103af4:	5d                   	pop    %ebp
c0103af5:	c3                   	ret    

c0103af6 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103af6:	55                   	push   %ebp
c0103af7:	89 e5                	mov    %esp,%ebp
c0103af9:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103afc:	9c                   	pushf  
c0103afd:	58                   	pop    %eax
c0103afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103b04:	25 00 02 00 00       	and    $0x200,%eax
c0103b09:	85 c0                	test   %eax,%eax
c0103b0b:	74 0c                	je     c0103b19 <__intr_save+0x23>
        intr_disable();
c0103b0d:	e8 ed da ff ff       	call   c01015ff <intr_disable>
        return 1;
c0103b12:	b8 01 00 00 00       	mov    $0x1,%eax
c0103b17:	eb 05                	jmp    c0103b1e <__intr_save+0x28>
    }
    return 0;
c0103b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103b1e:	c9                   	leave  
c0103b1f:	c3                   	ret    

c0103b20 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103b20:	55                   	push   %ebp
c0103b21:	89 e5                	mov    %esp,%ebp
c0103b23:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103b26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103b2a:	74 05                	je     c0103b31 <__intr_restore+0x11>
        intr_enable();
c0103b2c:	e8 c8 da ff ff       	call   c01015f9 <intr_enable>
    }
}
c0103b31:	c9                   	leave  
c0103b32:	c3                   	ret    

c0103b33 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103b33:	55                   	push   %ebp
c0103b34:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103b36:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b39:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103b3c:	b8 23 00 00 00       	mov    $0x23,%eax
c0103b41:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103b43:	b8 23 00 00 00       	mov    $0x23,%eax
c0103b48:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103b4a:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b4f:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103b51:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b56:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103b58:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b5d:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103b5f:	ea 66 3b 10 c0 08 00 	ljmp   $0x8,$0xc0103b66
}
c0103b66:	5d                   	pop    %ebp
c0103b67:	c3                   	ret    

c0103b68 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103b68:	55                   	push   %ebp
c0103b69:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103b6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b6e:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103b73:	5d                   	pop    %ebp
c0103b74:	c3                   	ret    

c0103b75 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103b75:	55                   	push   %ebp
c0103b76:	89 e5                	mov    %esp,%ebp
c0103b78:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103b7b:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103b80:	89 04 24             	mov    %eax,(%esp)
c0103b83:	e8 e0 ff ff ff       	call   c0103b68 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103b88:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103b8f:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103b91:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103b98:	68 00 
c0103b9a:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103b9f:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103ba5:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103baa:	c1 e8 10             	shr    $0x10,%eax
c0103bad:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103bb2:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bb9:	83 e0 f0             	and    $0xfffffff0,%eax
c0103bbc:	83 c8 09             	or     $0x9,%eax
c0103bbf:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bc4:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bcb:	83 e0 ef             	and    $0xffffffef,%eax
c0103bce:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bd3:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bda:	83 e0 9f             	and    $0xffffff9f,%eax
c0103bdd:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103be2:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103be9:	83 c8 80             	or     $0xffffff80,%eax
c0103bec:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bf1:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103bf8:	83 e0 f0             	and    $0xfffffff0,%eax
c0103bfb:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c00:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c07:	83 e0 ef             	and    $0xffffffef,%eax
c0103c0a:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c0f:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c16:	83 e0 df             	and    $0xffffffdf,%eax
c0103c19:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c1e:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c25:	83 c8 40             	or     $0x40,%eax
c0103c28:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c2d:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c34:	83 e0 7f             	and    $0x7f,%eax
c0103c37:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c3c:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c41:	c1 e8 18             	shr    $0x18,%eax
c0103c44:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103c49:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103c50:	e8 de fe ff ff       	call   c0103b33 <lgdt>
c0103c55:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103c5b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103c5f:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103c62:	c9                   	leave  
c0103c63:	c3                   	ret    

c0103c64 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103c64:	55                   	push   %ebp
c0103c65:	89 e5                	mov    %esp,%ebp
c0103c67:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103c6a:	c7 05 bc 89 11 c0 60 	movl   $0xc0106960,0xc01189bc
c0103c71:	69 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103c74:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0103c79:	8b 00                	mov    (%eax),%eax
c0103c7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103c7f:	c7 04 24 fc 69 10 c0 	movl   $0xc01069fc,(%esp)
c0103c86:	e8 c1 c6 ff ff       	call   c010034c <cprintf>
    pmm_manager->init();
c0103c8b:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0103c90:	8b 40 04             	mov    0x4(%eax),%eax
c0103c93:	ff d0                	call   *%eax
}
c0103c95:	c9                   	leave  
c0103c96:	c3                   	ret    

c0103c97 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103c97:	55                   	push   %ebp
c0103c98:	89 e5                	mov    %esp,%ebp
c0103c9a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103c9d:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0103ca2:	8b 40 08             	mov    0x8(%eax),%eax
c0103ca5:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103ca8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103cac:	8b 55 08             	mov    0x8(%ebp),%edx
c0103caf:	89 14 24             	mov    %edx,(%esp)
c0103cb2:	ff d0                	call   *%eax
}
c0103cb4:	c9                   	leave  
c0103cb5:	c3                   	ret    

c0103cb6 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103cb6:	55                   	push   %ebp
c0103cb7:	89 e5                	mov    %esp,%ebp
c0103cb9:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103cbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103cc3:	e8 2e fe ff ff       	call   c0103af6 <__intr_save>
c0103cc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103ccb:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0103cd0:	8b 40 0c             	mov    0xc(%eax),%eax
c0103cd3:	8b 55 08             	mov    0x8(%ebp),%edx
c0103cd6:	89 14 24             	mov    %edx,(%esp)
c0103cd9:	ff d0                	call   *%eax
c0103cdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ce1:	89 04 24             	mov    %eax,(%esp)
c0103ce4:	e8 37 fe ff ff       	call   c0103b20 <__intr_restore>
    return page;
c0103ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103cec:	c9                   	leave  
c0103ced:	c3                   	ret    

c0103cee <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103cee:	55                   	push   %ebp
c0103cef:	89 e5                	mov    %esp,%ebp
c0103cf1:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103cf4:	e8 fd fd ff ff       	call   c0103af6 <__intr_save>
c0103cf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103cfc:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0103d01:	8b 40 10             	mov    0x10(%eax),%eax
c0103d04:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d07:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d0b:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d0e:	89 14 24             	mov    %edx,(%esp)
c0103d11:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d16:	89 04 24             	mov    %eax,(%esp)
c0103d19:	e8 02 fe ff ff       	call   c0103b20 <__intr_restore>
}
c0103d1e:	c9                   	leave  
c0103d1f:	c3                   	ret    

c0103d20 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103d20:	55                   	push   %ebp
c0103d21:	89 e5                	mov    %esp,%ebp
c0103d23:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d26:	e8 cb fd ff ff       	call   c0103af6 <__intr_save>
c0103d2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103d2e:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0103d33:	8b 40 14             	mov    0x14(%eax),%eax
c0103d36:	ff d0                	call   *%eax
c0103d38:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d3e:	89 04 24             	mov    %eax,(%esp)
c0103d41:	e8 da fd ff ff       	call   c0103b20 <__intr_restore>
    return ret;
c0103d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103d49:	c9                   	leave  
c0103d4a:	c3                   	ret    

c0103d4b <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103d4b:	55                   	push   %ebp
c0103d4c:	89 e5                	mov    %esp,%ebp
c0103d4e:	57                   	push   %edi
c0103d4f:	56                   	push   %esi
c0103d50:	53                   	push   %ebx
c0103d51:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103d57:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103d5e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103d65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103d6c:	c7 04 24 13 6a 10 c0 	movl   $0xc0106a13,(%esp)
c0103d73:	e8 d4 c5 ff ff       	call   c010034c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103d78:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103d7f:	e9 15 01 00 00       	jmp    c0103e99 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103d84:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d87:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d8a:	89 d0                	mov    %edx,%eax
c0103d8c:	c1 e0 02             	shl    $0x2,%eax
c0103d8f:	01 d0                	add    %edx,%eax
c0103d91:	c1 e0 02             	shl    $0x2,%eax
c0103d94:	01 c8                	add    %ecx,%eax
c0103d96:	8b 50 08             	mov    0x8(%eax),%edx
c0103d99:	8b 40 04             	mov    0x4(%eax),%eax
c0103d9c:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103d9f:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103da2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103da5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103da8:	89 d0                	mov    %edx,%eax
c0103daa:	c1 e0 02             	shl    $0x2,%eax
c0103dad:	01 d0                	add    %edx,%eax
c0103daf:	c1 e0 02             	shl    $0x2,%eax
c0103db2:	01 c8                	add    %ecx,%eax
c0103db4:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103db7:	8b 58 10             	mov    0x10(%eax),%ebx
c0103dba:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103dbd:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103dc0:	01 c8                	add    %ecx,%eax
c0103dc2:	11 da                	adc    %ebx,%edx
c0103dc4:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103dc7:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103dca:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dcd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dd0:	89 d0                	mov    %edx,%eax
c0103dd2:	c1 e0 02             	shl    $0x2,%eax
c0103dd5:	01 d0                	add    %edx,%eax
c0103dd7:	c1 e0 02             	shl    $0x2,%eax
c0103dda:	01 c8                	add    %ecx,%eax
c0103ddc:	83 c0 14             	add    $0x14,%eax
c0103ddf:	8b 00                	mov    (%eax),%eax
c0103de1:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103de7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103dea:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103ded:	83 c0 ff             	add    $0xffffffff,%eax
c0103df0:	83 d2 ff             	adc    $0xffffffff,%edx
c0103df3:	89 c6                	mov    %eax,%esi
c0103df5:	89 d7                	mov    %edx,%edi
c0103df7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dfa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dfd:	89 d0                	mov    %edx,%eax
c0103dff:	c1 e0 02             	shl    $0x2,%eax
c0103e02:	01 d0                	add    %edx,%eax
c0103e04:	c1 e0 02             	shl    $0x2,%eax
c0103e07:	01 c8                	add    %ecx,%eax
c0103e09:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e0c:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e0f:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103e15:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103e19:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103e1d:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103e21:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e24:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e27:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e2b:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103e2f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103e33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103e37:	c7 04 24 20 6a 10 c0 	movl   $0xc0106a20,(%esp)
c0103e3e:	e8 09 c5 ff ff       	call   c010034c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103e43:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e46:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e49:	89 d0                	mov    %edx,%eax
c0103e4b:	c1 e0 02             	shl    $0x2,%eax
c0103e4e:	01 d0                	add    %edx,%eax
c0103e50:	c1 e0 02             	shl    $0x2,%eax
c0103e53:	01 c8                	add    %ecx,%eax
c0103e55:	83 c0 14             	add    $0x14,%eax
c0103e58:	8b 00                	mov    (%eax),%eax
c0103e5a:	83 f8 01             	cmp    $0x1,%eax
c0103e5d:	75 36                	jne    c0103e95 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103e5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103e65:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103e68:	77 2b                	ja     c0103e95 <page_init+0x14a>
c0103e6a:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103e6d:	72 05                	jb     c0103e74 <page_init+0x129>
c0103e6f:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103e72:	73 21                	jae    c0103e95 <page_init+0x14a>
c0103e74:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103e78:	77 1b                	ja     c0103e95 <page_init+0x14a>
c0103e7a:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103e7e:	72 09                	jb     c0103e89 <page_init+0x13e>
c0103e80:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103e87:	77 0c                	ja     c0103e95 <page_init+0x14a>
                maxpa = end;
c0103e89:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e8c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e8f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103e92:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103e95:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103e99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103e9c:	8b 00                	mov    (%eax),%eax
c0103e9e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103ea1:	0f 8f dd fe ff ff    	jg     c0103d84 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103ea7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103eab:	72 1d                	jb     c0103eca <page_init+0x17f>
c0103ead:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103eb1:	77 09                	ja     c0103ebc <page_init+0x171>
c0103eb3:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103eba:	76 0e                	jbe    c0103eca <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103ebc:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103ec3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103eca:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ecd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103ed0:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103ed4:	c1 ea 0c             	shr    $0xc,%edx
c0103ed7:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103edc:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103ee3:	b8 c8 89 11 c0       	mov    $0xc01189c8,%eax
c0103ee8:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103eeb:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103eee:	01 d0                	add    %edx,%eax
c0103ef0:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103ef3:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103ef6:	ba 00 00 00 00       	mov    $0x0,%edx
c0103efb:	f7 75 ac             	divl   -0x54(%ebp)
c0103efe:	89 d0                	mov    %edx,%eax
c0103f00:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103f03:	29 c2                	sub    %eax,%edx
c0103f05:	89 d0                	mov    %edx,%eax
c0103f07:	a3 c4 89 11 c0       	mov    %eax,0xc01189c4

    for (i = 0; i < npage; i ++) {
c0103f0c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f13:	eb 2f                	jmp    c0103f44 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103f15:	8b 0d c4 89 11 c0    	mov    0xc01189c4,%ecx
c0103f1b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f1e:	89 d0                	mov    %edx,%eax
c0103f20:	c1 e0 02             	shl    $0x2,%eax
c0103f23:	01 d0                	add    %edx,%eax
c0103f25:	c1 e0 02             	shl    $0x2,%eax
c0103f28:	01 c8                	add    %ecx,%eax
c0103f2a:	83 c0 04             	add    $0x4,%eax
c0103f2d:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103f34:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103f37:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103f3a:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103f3d:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103f40:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f44:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f47:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103f4c:	39 c2                	cmp    %eax,%edx
c0103f4e:	72 c5                	jb     c0103f15 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103f50:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103f56:	89 d0                	mov    %edx,%eax
c0103f58:	c1 e0 02             	shl    $0x2,%eax
c0103f5b:	01 d0                	add    %edx,%eax
c0103f5d:	c1 e0 02             	shl    $0x2,%eax
c0103f60:	89 c2                	mov    %eax,%edx
c0103f62:	a1 c4 89 11 c0       	mov    0xc01189c4,%eax
c0103f67:	01 d0                	add    %edx,%eax
c0103f69:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103f6c:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103f73:	77 23                	ja     c0103f98 <page_init+0x24d>
c0103f75:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103f78:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103f7c:	c7 44 24 08 50 6a 10 	movl   $0xc0106a50,0x8(%esp)
c0103f83:	c0 
c0103f84:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103f8b:	00 
c0103f8c:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0103f93:	e8 84 cc ff ff       	call   c0100c1c <__panic>
c0103f98:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103f9b:	05 00 00 00 40       	add    $0x40000000,%eax
c0103fa0:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103fa3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103faa:	e9 74 01 00 00       	jmp    c0104123 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103faf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fb2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fb5:	89 d0                	mov    %edx,%eax
c0103fb7:	c1 e0 02             	shl    $0x2,%eax
c0103fba:	01 d0                	add    %edx,%eax
c0103fbc:	c1 e0 02             	shl    $0x2,%eax
c0103fbf:	01 c8                	add    %ecx,%eax
c0103fc1:	8b 50 08             	mov    0x8(%eax),%edx
c0103fc4:	8b 40 04             	mov    0x4(%eax),%eax
c0103fc7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103fca:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103fcd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fd0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fd3:	89 d0                	mov    %edx,%eax
c0103fd5:	c1 e0 02             	shl    $0x2,%eax
c0103fd8:	01 d0                	add    %edx,%eax
c0103fda:	c1 e0 02             	shl    $0x2,%eax
c0103fdd:	01 c8                	add    %ecx,%eax
c0103fdf:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103fe2:	8b 58 10             	mov    0x10(%eax),%ebx
c0103fe5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103fe8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103feb:	01 c8                	add    %ecx,%eax
c0103fed:	11 da                	adc    %ebx,%edx
c0103fef:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103ff2:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103ff5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ff8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ffb:	89 d0                	mov    %edx,%eax
c0103ffd:	c1 e0 02             	shl    $0x2,%eax
c0104000:	01 d0                	add    %edx,%eax
c0104002:	c1 e0 02             	shl    $0x2,%eax
c0104005:	01 c8                	add    %ecx,%eax
c0104007:	83 c0 14             	add    $0x14,%eax
c010400a:	8b 00                	mov    (%eax),%eax
c010400c:	83 f8 01             	cmp    $0x1,%eax
c010400f:	0f 85 0a 01 00 00    	jne    c010411f <page_init+0x3d4>
            if (begin < freemem) {
c0104015:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104018:	ba 00 00 00 00       	mov    $0x0,%edx
c010401d:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104020:	72 17                	jb     c0104039 <page_init+0x2ee>
c0104022:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104025:	77 05                	ja     c010402c <page_init+0x2e1>
c0104027:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010402a:	76 0d                	jbe    c0104039 <page_init+0x2ee>
                begin = freemem;
c010402c:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010402f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104032:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104039:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010403d:	72 1d                	jb     c010405c <page_init+0x311>
c010403f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104043:	77 09                	ja     c010404e <page_init+0x303>
c0104045:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010404c:	76 0e                	jbe    c010405c <page_init+0x311>
                end = KMEMSIZE;
c010404e:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104055:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010405c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010405f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104062:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104065:	0f 87 b4 00 00 00    	ja     c010411f <page_init+0x3d4>
c010406b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010406e:	72 09                	jb     c0104079 <page_init+0x32e>
c0104070:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104073:	0f 83 a6 00 00 00    	jae    c010411f <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0104079:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104080:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104083:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104086:	01 d0                	add    %edx,%eax
c0104088:	83 e8 01             	sub    $0x1,%eax
c010408b:	89 45 98             	mov    %eax,-0x68(%ebp)
c010408e:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104091:	ba 00 00 00 00       	mov    $0x0,%edx
c0104096:	f7 75 9c             	divl   -0x64(%ebp)
c0104099:	89 d0                	mov    %edx,%eax
c010409b:	8b 55 98             	mov    -0x68(%ebp),%edx
c010409e:	29 c2                	sub    %eax,%edx
c01040a0:	89 d0                	mov    %edx,%eax
c01040a2:	ba 00 00 00 00       	mov    $0x0,%edx
c01040a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01040aa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01040ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01040b0:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01040b3:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01040b6:	ba 00 00 00 00       	mov    $0x0,%edx
c01040bb:	89 c7                	mov    %eax,%edi
c01040bd:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01040c3:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01040c6:	89 d0                	mov    %edx,%eax
c01040c8:	83 e0 00             	and    $0x0,%eax
c01040cb:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01040ce:	8b 45 80             	mov    -0x80(%ebp),%eax
c01040d1:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01040d4:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01040d7:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01040da:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040dd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040e0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040e3:	77 3a                	ja     c010411f <page_init+0x3d4>
c01040e5:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040e8:	72 05                	jb     c01040ef <page_init+0x3a4>
c01040ea:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01040ed:	73 30                	jae    c010411f <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01040ef:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01040f2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01040f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01040f8:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01040fb:	29 c8                	sub    %ecx,%eax
c01040fd:	19 da                	sbb    %ebx,%edx
c01040ff:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104103:	c1 ea 0c             	shr    $0xc,%edx
c0104106:	89 c3                	mov    %eax,%ebx
c0104108:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010410b:	89 04 24             	mov    %eax,(%esp)
c010410e:	e8 bd f8 ff ff       	call   c01039d0 <pa2page>
c0104113:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104117:	89 04 24             	mov    %eax,(%esp)
c010411a:	e8 78 fb ff ff       	call   c0103c97 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c010411f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104123:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104126:	8b 00                	mov    (%eax),%eax
c0104128:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010412b:	0f 8f 7e fe ff ff    	jg     c0103faf <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104131:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104137:	5b                   	pop    %ebx
c0104138:	5e                   	pop    %esi
c0104139:	5f                   	pop    %edi
c010413a:	5d                   	pop    %ebp
c010413b:	c3                   	ret    

c010413c <enable_paging>:

static void
enable_paging(void) {
c010413c:	55                   	push   %ebp
c010413d:	89 e5                	mov    %esp,%ebp
c010413f:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0104142:	a1 c0 89 11 c0       	mov    0xc01189c0,%eax
c0104147:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c010414a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010414d:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0104150:	0f 20 c0             	mov    %cr0,%eax
c0104153:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0104156:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104159:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c010415c:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0104163:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0104167:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010416a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010416d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104170:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0104173:	c9                   	leave  
c0104174:	c3                   	ret    

c0104175 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104175:	55                   	push   %ebp
c0104176:	89 e5                	mov    %esp,%ebp
c0104178:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010417b:	8b 45 14             	mov    0x14(%ebp),%eax
c010417e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104181:	31 d0                	xor    %edx,%eax
c0104183:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104188:	85 c0                	test   %eax,%eax
c010418a:	74 24                	je     c01041b0 <boot_map_segment+0x3b>
c010418c:	c7 44 24 0c 82 6a 10 	movl   $0xc0106a82,0xc(%esp)
c0104193:	c0 
c0104194:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c010419b:	c0 
c010419c:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01041a3:	00 
c01041a4:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c01041ab:	e8 6c ca ff ff       	call   c0100c1c <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01041b0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01041b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041ba:	25 ff 0f 00 00       	and    $0xfff,%eax
c01041bf:	89 c2                	mov    %eax,%edx
c01041c1:	8b 45 10             	mov    0x10(%ebp),%eax
c01041c4:	01 c2                	add    %eax,%edx
c01041c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041c9:	01 d0                	add    %edx,%eax
c01041cb:	83 e8 01             	sub    $0x1,%eax
c01041ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01041d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041d4:	ba 00 00 00 00       	mov    $0x0,%edx
c01041d9:	f7 75 f0             	divl   -0x10(%ebp)
c01041dc:	89 d0                	mov    %edx,%eax
c01041de:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01041e1:	29 c2                	sub    %eax,%edx
c01041e3:	89 d0                	mov    %edx,%eax
c01041e5:	c1 e8 0c             	shr    $0xc,%eax
c01041e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01041eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01041f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01041f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01041f9:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01041fc:	8b 45 14             	mov    0x14(%ebp),%eax
c01041ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104202:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104205:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010420a:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010420d:	eb 6b                	jmp    c010427a <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010420f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104216:	00 
c0104217:	8b 45 0c             	mov    0xc(%ebp),%eax
c010421a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010421e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104221:	89 04 24             	mov    %eax,(%esp)
c0104224:	e8 cc 01 00 00       	call   c01043f5 <get_pte>
c0104229:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010422c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104230:	75 24                	jne    c0104256 <boot_map_segment+0xe1>
c0104232:	c7 44 24 0c ae 6a 10 	movl   $0xc0106aae,0xc(%esp)
c0104239:	c0 
c010423a:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104241:	c0 
c0104242:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0104249:	00 
c010424a:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104251:	e8 c6 c9 ff ff       	call   c0100c1c <__panic>
        *ptep = pa | PTE_P | perm;
c0104256:	8b 45 18             	mov    0x18(%ebp),%eax
c0104259:	8b 55 14             	mov    0x14(%ebp),%edx
c010425c:	09 d0                	or     %edx,%eax
c010425e:	83 c8 01             	or     $0x1,%eax
c0104261:	89 c2                	mov    %eax,%edx
c0104263:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104266:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104268:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010426c:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104273:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c010427a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010427e:	75 8f                	jne    c010420f <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104280:	c9                   	leave  
c0104281:	c3                   	ret    

c0104282 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104282:	55                   	push   %ebp
c0104283:	89 e5                	mov    %esp,%ebp
c0104285:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104288:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010428f:	e8 22 fa ff ff       	call   c0103cb6 <alloc_pages>
c0104294:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104297:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010429b:	75 1c                	jne    c01042b9 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010429d:	c7 44 24 08 bb 6a 10 	movl   $0xc0106abb,0x8(%esp)
c01042a4:	c0 
c01042a5:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01042ac:	00 
c01042ad:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c01042b4:	e8 63 c9 ff ff       	call   c0100c1c <__panic>
    }
    return page2kva(p);
c01042b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042bc:	89 04 24             	mov    %eax,(%esp)
c01042bf:	e8 5b f7 ff ff       	call   c0103a1f <page2kva>
}
c01042c4:	c9                   	leave  
c01042c5:	c3                   	ret    

c01042c6 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01042c6:	55                   	push   %ebp
c01042c7:	89 e5                	mov    %esp,%ebp
c01042c9:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01042cc:	e8 93 f9 ff ff       	call   c0103c64 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01042d1:	e8 75 fa ff ff       	call   c0103d4b <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01042d6:	e8 72 04 00 00       	call   c010474d <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01042db:	e8 a2 ff ff ff       	call   c0104282 <boot_alloc_page>
c01042e0:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c01042e5:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01042ea:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01042f1:	00 
c01042f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01042f9:	00 
c01042fa:	89 04 24             	mov    %eax,(%esp)
c01042fd:	e8 b4 1a 00 00       	call   c0105db6 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104302:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104307:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010430a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104311:	77 23                	ja     c0104336 <pmm_init+0x70>
c0104313:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104316:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010431a:	c7 44 24 08 50 6a 10 	movl   $0xc0106a50,0x8(%esp)
c0104321:	c0 
c0104322:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0104329:	00 
c010432a:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104331:	e8 e6 c8 ff ff       	call   c0100c1c <__panic>
c0104336:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104339:	05 00 00 00 40       	add    $0x40000000,%eax
c010433e:	a3 c0 89 11 c0       	mov    %eax,0xc01189c0

    check_pgdir();
c0104343:	e8 23 04 00 00       	call   c010476b <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104348:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010434d:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104353:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104358:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010435b:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104362:	77 23                	ja     c0104387 <pmm_init+0xc1>
c0104364:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104367:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010436b:	c7 44 24 08 50 6a 10 	movl   $0xc0106a50,0x8(%esp)
c0104372:	c0 
c0104373:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c010437a:	00 
c010437b:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104382:	e8 95 c8 ff ff       	call   c0100c1c <__panic>
c0104387:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010438a:	05 00 00 00 40       	add    $0x40000000,%eax
c010438f:	83 c8 03             	or     $0x3,%eax
c0104392:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104394:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104399:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01043a0:	00 
c01043a1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01043a8:	00 
c01043a9:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01043b0:	38 
c01043b1:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01043b8:	c0 
c01043b9:	89 04 24             	mov    %eax,(%esp)
c01043bc:	e8 b4 fd ff ff       	call   c0104175 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01043c1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043c6:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c01043cc:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01043d2:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01043d4:	e8 63 fd ff ff       	call   c010413c <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01043d9:	e8 97 f7 ff ff       	call   c0103b75 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01043de:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01043e9:	e8 18 0a 00 00       	call   c0104e06 <check_boot_pgdir>

    print_pgdir();
c01043ee:	e8 a5 0e 00 00       	call   c0105298 <print_pgdir>

}
c01043f3:	c9                   	leave  
c01043f4:	c3                   	ret    

c01043f5 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01043f5:	55                   	push   %ebp
c01043f6:	89 e5                	mov    %esp,%ebp
c01043f8:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01043fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043fe:	c1 e8 16             	shr    $0x16,%eax
c0104401:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104408:	8b 45 08             	mov    0x8(%ebp),%eax
c010440b:	01 d0                	add    %edx,%eax
c010440d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c0104410:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104413:	8b 00                	mov    (%eax),%eax
c0104415:	83 e0 01             	and    $0x1,%eax
c0104418:	85 c0                	test   %eax,%eax
c010441a:	0f 85 b9 00 00 00    	jne    c01044d9 <get_pte+0xe4>
        if (!create)    return NULL;
c0104420:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104424:	75 0a                	jne    c0104430 <get_pte+0x3b>
c0104426:	b8 00 00 00 00       	mov    $0x0,%eax
c010442b:	e9 05 01 00 00       	jmp    c0104535 <get_pte+0x140>
        struct Page* page = alloc_page();
c0104430:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104437:	e8 7a f8 ff ff       	call   c0103cb6 <alloc_pages>
c010443c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (page == NULL)    return NULL;
c010443f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104443:	75 0a                	jne    c010444f <get_pte+0x5a>
c0104445:	b8 00 00 00 00       	mov    $0x0,%eax
c010444a:	e9 e6 00 00 00       	jmp    c0104535 <get_pte+0x140>
        set_page_ref(page, 1);
c010444f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104456:	00 
c0104457:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010445a:	89 04 24             	mov    %eax,(%esp)
c010445d:	e8 59 f6 ff ff       	call   c0103abb <set_page_ref>
        uintptr_t pa = page2pa(page);
c0104462:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104465:	89 04 24             	mov    %eax,(%esp)
c0104468:	e8 4d f5 ff ff       	call   c01039ba <page2pa>
c010446d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0104470:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104473:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104476:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104479:	c1 e8 0c             	shr    $0xc,%eax
c010447c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010447f:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104484:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104487:	72 23                	jb     c01044ac <get_pte+0xb7>
c0104489:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010448c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104490:	c7 44 24 08 ac 69 10 	movl   $0xc01069ac,0x8(%esp)
c0104497:	c0 
c0104498:	c7 44 24 04 86 01 00 	movl   $0x186,0x4(%esp)
c010449f:	00 
c01044a0:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c01044a7:	e8 70 c7 ff ff       	call   c0100c1c <__panic>
c01044ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044af:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01044b4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01044bb:	00 
c01044bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01044c3:	00 
c01044c4:	89 04 24             	mov    %eax,(%esp)
c01044c7:	e8 ea 18 00 00       	call   c0105db6 <memset>
        *pdep = pa | PTE_P | PTE_W | PTE_U;
c01044cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044cf:	83 c8 07             	or     $0x7,%eax
c01044d2:	89 c2                	mov    %eax,%edx
c01044d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044d7:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t*)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c01044d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044dc:	8b 00                	mov    (%eax),%eax
c01044de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01044e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01044e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044e9:	c1 e8 0c             	shr    $0xc,%eax
c01044ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01044ef:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01044f4:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01044f7:	72 23                	jb     c010451c <get_pte+0x127>
c01044f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044fc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104500:	c7 44 24 08 ac 69 10 	movl   $0xc01069ac,0x8(%esp)
c0104507:	c0 
c0104508:	c7 44 24 04 89 01 00 	movl   $0x189,0x4(%esp)
c010450f:	00 
c0104510:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104517:	e8 00 c7 ff ff       	call   c0100c1c <__panic>
c010451c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010451f:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104524:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104527:	c1 ea 0c             	shr    $0xc,%edx
c010452a:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104530:	c1 e2 02             	shl    $0x2,%edx
c0104533:	01 d0                	add    %edx,%eax
}
c0104535:	c9                   	leave  
c0104536:	c3                   	ret    

c0104537 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104537:	55                   	push   %ebp
c0104538:	89 e5                	mov    %esp,%ebp
c010453a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010453d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104544:	00 
c0104545:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104548:	89 44 24 04          	mov    %eax,0x4(%esp)
c010454c:	8b 45 08             	mov    0x8(%ebp),%eax
c010454f:	89 04 24             	mov    %eax,(%esp)
c0104552:	e8 9e fe ff ff       	call   c01043f5 <get_pte>
c0104557:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010455a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010455e:	74 08                	je     c0104568 <get_page+0x31>
        *ptep_store = ptep;
c0104560:	8b 45 10             	mov    0x10(%ebp),%eax
c0104563:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104566:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104568:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010456c:	74 1b                	je     c0104589 <get_page+0x52>
c010456e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104571:	8b 00                	mov    (%eax),%eax
c0104573:	83 e0 01             	and    $0x1,%eax
c0104576:	85 c0                	test   %eax,%eax
c0104578:	74 0f                	je     c0104589 <get_page+0x52>
        return pa2page(*ptep);
c010457a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010457d:	8b 00                	mov    (%eax),%eax
c010457f:	89 04 24             	mov    %eax,(%esp)
c0104582:	e8 49 f4 ff ff       	call   c01039d0 <pa2page>
c0104587:	eb 05                	jmp    c010458e <get_page+0x57>
    }
    return NULL;
c0104589:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010458e:	c9                   	leave  
c010458f:	c3                   	ret    

c0104590 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104590:	55                   	push   %ebp
c0104591:	89 e5                	mov    %esp,%ebp
c0104593:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (!(*ptep & PTE_P))   return;
c0104596:	8b 45 10             	mov    0x10(%ebp),%eax
c0104599:	8b 00                	mov    (%eax),%eax
c010459b:	83 e0 01             	and    $0x1,%eax
c010459e:	85 c0                	test   %eax,%eax
c01045a0:	75 02                	jne    c01045a4 <page_remove_pte+0x14>
c01045a2:	eb 4d                	jmp    c01045f1 <page_remove_pte+0x61>
    struct Page* page = pte2page(*ptep);
c01045a4:	8b 45 10             	mov    0x10(%ebp),%eax
c01045a7:	8b 00                	mov    (%eax),%eax
c01045a9:	89 04 24             	mov    %eax,(%esp)
c01045ac:	e8 c2 f4 ff ff       	call   c0103a73 <pte2page>
c01045b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page_ref_dec(page) == 0)
c01045b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045b7:	89 04 24             	mov    %eax,(%esp)
c01045ba:	e8 20 f5 ff ff       	call   c0103adf <page_ref_dec>
c01045bf:	85 c0                	test   %eax,%eax
c01045c1:	75 13                	jne    c01045d6 <page_remove_pte+0x46>
        free_page(page);
c01045c3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01045ca:	00 
c01045cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045ce:	89 04 24             	mov    %eax,(%esp)
c01045d1:	e8 18 f7 ff ff       	call   c0103cee <free_pages>
    *ptep = 0;
c01045d6:	8b 45 10             	mov    0x10(%ebp),%eax
c01045d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    tlb_invalidate(pgdir, la);
c01045df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01045e9:	89 04 24             	mov    %eax,(%esp)
c01045ec:	e8 ff 00 00 00       	call   c01046f0 <tlb_invalidate>
}
c01045f1:	c9                   	leave  
c01045f2:	c3                   	ret    

c01045f3 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01045f3:	55                   	push   %ebp
c01045f4:	89 e5                	mov    %esp,%ebp
c01045f6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01045f9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104600:	00 
c0104601:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104604:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104608:	8b 45 08             	mov    0x8(%ebp),%eax
c010460b:	89 04 24             	mov    %eax,(%esp)
c010460e:	e8 e2 fd ff ff       	call   c01043f5 <get_pte>
c0104613:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104616:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010461a:	74 19                	je     c0104635 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010461c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010461f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104623:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104626:	89 44 24 04          	mov    %eax,0x4(%esp)
c010462a:	8b 45 08             	mov    0x8(%ebp),%eax
c010462d:	89 04 24             	mov    %eax,(%esp)
c0104630:	e8 5b ff ff ff       	call   c0104590 <page_remove_pte>
    }
}
c0104635:	c9                   	leave  
c0104636:	c3                   	ret    

c0104637 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104637:	55                   	push   %ebp
c0104638:	89 e5                	mov    %esp,%ebp
c010463a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010463d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104644:	00 
c0104645:	8b 45 10             	mov    0x10(%ebp),%eax
c0104648:	89 44 24 04          	mov    %eax,0x4(%esp)
c010464c:	8b 45 08             	mov    0x8(%ebp),%eax
c010464f:	89 04 24             	mov    %eax,(%esp)
c0104652:	e8 9e fd ff ff       	call   c01043f5 <get_pte>
c0104657:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010465a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010465e:	75 0a                	jne    c010466a <page_insert+0x33>
        return -E_NO_MEM;
c0104660:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104665:	e9 84 00 00 00       	jmp    c01046ee <page_insert+0xb7>
    }
    page_ref_inc(page);
c010466a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010466d:	89 04 24             	mov    %eax,(%esp)
c0104670:	e8 53 f4 ff ff       	call   c0103ac8 <page_ref_inc>
    if (*ptep & PTE_P) {
c0104675:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104678:	8b 00                	mov    (%eax),%eax
c010467a:	83 e0 01             	and    $0x1,%eax
c010467d:	85 c0                	test   %eax,%eax
c010467f:	74 3e                	je     c01046bf <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0104681:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104684:	8b 00                	mov    (%eax),%eax
c0104686:	89 04 24             	mov    %eax,(%esp)
c0104689:	e8 e5 f3 ff ff       	call   c0103a73 <pte2page>
c010468e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104691:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104694:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104697:	75 0d                	jne    c01046a6 <page_insert+0x6f>
            page_ref_dec(page);
c0104699:	8b 45 0c             	mov    0xc(%ebp),%eax
c010469c:	89 04 24             	mov    %eax,(%esp)
c010469f:	e8 3b f4 ff ff       	call   c0103adf <page_ref_dec>
c01046a4:	eb 19                	jmp    c01046bf <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01046a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01046ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01046b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01046b7:	89 04 24             	mov    %eax,(%esp)
c01046ba:	e8 d1 fe ff ff       	call   c0104590 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01046bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046c2:	89 04 24             	mov    %eax,(%esp)
c01046c5:	e8 f0 f2 ff ff       	call   c01039ba <page2pa>
c01046ca:	0b 45 14             	or     0x14(%ebp),%eax
c01046cd:	83 c8 01             	or     $0x1,%eax
c01046d0:	89 c2                	mov    %eax,%edx
c01046d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046d5:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01046d7:	8b 45 10             	mov    0x10(%ebp),%eax
c01046da:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046de:	8b 45 08             	mov    0x8(%ebp),%eax
c01046e1:	89 04 24             	mov    %eax,(%esp)
c01046e4:	e8 07 00 00 00       	call   c01046f0 <tlb_invalidate>
    return 0;
c01046e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01046ee:	c9                   	leave  
c01046ef:	c3                   	ret    

c01046f0 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01046f0:	55                   	push   %ebp
c01046f1:	89 e5                	mov    %esp,%ebp
c01046f3:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01046f6:	0f 20 d8             	mov    %cr3,%eax
c01046f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01046fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01046ff:	89 c2                	mov    %eax,%edx
c0104701:	8b 45 08             	mov    0x8(%ebp),%eax
c0104704:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104707:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010470e:	77 23                	ja     c0104733 <tlb_invalidate+0x43>
c0104710:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104713:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104717:	c7 44 24 08 50 6a 10 	movl   $0xc0106a50,0x8(%esp)
c010471e:	c0 
c010471f:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c0104726:	00 
c0104727:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c010472e:	e8 e9 c4 ff ff       	call   c0100c1c <__panic>
c0104733:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104736:	05 00 00 00 40       	add    $0x40000000,%eax
c010473b:	39 c2                	cmp    %eax,%edx
c010473d:	75 0c                	jne    c010474b <tlb_invalidate+0x5b>
        invlpg((void *)la);
c010473f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104742:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104745:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104748:	0f 01 38             	invlpg (%eax)
    }
}
c010474b:	c9                   	leave  
c010474c:	c3                   	ret    

c010474d <check_alloc_page>:

static void
check_alloc_page(void) {
c010474d:	55                   	push   %ebp
c010474e:	89 e5                	mov    %esp,%ebp
c0104750:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104753:	a1 bc 89 11 c0       	mov    0xc01189bc,%eax
c0104758:	8b 40 18             	mov    0x18(%eax),%eax
c010475b:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010475d:	c7 04 24 d4 6a 10 c0 	movl   $0xc0106ad4,(%esp)
c0104764:	e8 e3 bb ff ff       	call   c010034c <cprintf>
}
c0104769:	c9                   	leave  
c010476a:	c3                   	ret    

c010476b <check_pgdir>:

static void
check_pgdir(void) {
c010476b:	55                   	push   %ebp
c010476c:	89 e5                	mov    %esp,%ebp
c010476e:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104771:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104776:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010477b:	76 24                	jbe    c01047a1 <check_pgdir+0x36>
c010477d:	c7 44 24 0c f3 6a 10 	movl   $0xc0106af3,0xc(%esp)
c0104784:	c0 
c0104785:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c010478c:	c0 
c010478d:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0104794:	00 
c0104795:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c010479c:	e8 7b c4 ff ff       	call   c0100c1c <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01047a1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047a6:	85 c0                	test   %eax,%eax
c01047a8:	74 0e                	je     c01047b8 <check_pgdir+0x4d>
c01047aa:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047af:	25 ff 0f 00 00       	and    $0xfff,%eax
c01047b4:	85 c0                	test   %eax,%eax
c01047b6:	74 24                	je     c01047dc <check_pgdir+0x71>
c01047b8:	c7 44 24 0c 10 6b 10 	movl   $0xc0106b10,0xc(%esp)
c01047bf:	c0 
c01047c0:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c01047c7:	c0 
c01047c8:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c01047cf:	00 
c01047d0:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c01047d7:	e8 40 c4 ff ff       	call   c0100c1c <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01047dc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047e1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047e8:	00 
c01047e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01047f0:	00 
c01047f1:	89 04 24             	mov    %eax,(%esp)
c01047f4:	e8 3e fd ff ff       	call   c0104537 <get_page>
c01047f9:	85 c0                	test   %eax,%eax
c01047fb:	74 24                	je     c0104821 <check_pgdir+0xb6>
c01047fd:	c7 44 24 0c 48 6b 10 	movl   $0xc0106b48,0xc(%esp)
c0104804:	c0 
c0104805:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c010480c:	c0 
c010480d:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0104814:	00 
c0104815:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c010481c:	e8 fb c3 ff ff       	call   c0100c1c <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104821:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104828:	e8 89 f4 ff ff       	call   c0103cb6 <alloc_pages>
c010482d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104830:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104835:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010483c:	00 
c010483d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104844:	00 
c0104845:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104848:	89 54 24 04          	mov    %edx,0x4(%esp)
c010484c:	89 04 24             	mov    %eax,(%esp)
c010484f:	e8 e3 fd ff ff       	call   c0104637 <page_insert>
c0104854:	85 c0                	test   %eax,%eax
c0104856:	74 24                	je     c010487c <check_pgdir+0x111>
c0104858:	c7 44 24 0c 70 6b 10 	movl   $0xc0106b70,0xc(%esp)
c010485f:	c0 
c0104860:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104867:	c0 
c0104868:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c010486f:	00 
c0104870:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104877:	e8 a0 c3 ff ff       	call   c0100c1c <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010487c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104881:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104888:	00 
c0104889:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104890:	00 
c0104891:	89 04 24             	mov    %eax,(%esp)
c0104894:	e8 5c fb ff ff       	call   c01043f5 <get_pte>
c0104899:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010489c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048a0:	75 24                	jne    c01048c6 <check_pgdir+0x15b>
c01048a2:	c7 44 24 0c 9c 6b 10 	movl   $0xc0106b9c,0xc(%esp)
c01048a9:	c0 
c01048aa:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c01048b1:	c0 
c01048b2:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c01048b9:	00 
c01048ba:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c01048c1:	e8 56 c3 ff ff       	call   c0100c1c <__panic>
    assert(pa2page(*ptep) == p1);
c01048c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048c9:	8b 00                	mov    (%eax),%eax
c01048cb:	89 04 24             	mov    %eax,(%esp)
c01048ce:	e8 fd f0 ff ff       	call   c01039d0 <pa2page>
c01048d3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01048d6:	74 24                	je     c01048fc <check_pgdir+0x191>
c01048d8:	c7 44 24 0c c9 6b 10 	movl   $0xc0106bc9,0xc(%esp)
c01048df:	c0 
c01048e0:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c01048e7:	c0 
c01048e8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c01048ef:	00 
c01048f0:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c01048f7:	e8 20 c3 ff ff       	call   c0100c1c <__panic>
    assert(page_ref(p1) == 1);
c01048fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048ff:	89 04 24             	mov    %eax,(%esp)
c0104902:	e8 aa f1 ff ff       	call   c0103ab1 <page_ref>
c0104907:	83 f8 01             	cmp    $0x1,%eax
c010490a:	74 24                	je     c0104930 <check_pgdir+0x1c5>
c010490c:	c7 44 24 0c de 6b 10 	movl   $0xc0106bde,0xc(%esp)
c0104913:	c0 
c0104914:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c010491b:	c0 
c010491c:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0104923:	00 
c0104924:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c010492b:	e8 ec c2 ff ff       	call   c0100c1c <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104930:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104935:	8b 00                	mov    (%eax),%eax
c0104937:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010493c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010493f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104942:	c1 e8 0c             	shr    $0xc,%eax
c0104945:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104948:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010494d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104950:	72 23                	jb     c0104975 <check_pgdir+0x20a>
c0104952:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104955:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104959:	c7 44 24 08 ac 69 10 	movl   $0xc01069ac,0x8(%esp)
c0104960:	c0 
c0104961:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104968:	00 
c0104969:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104970:	e8 a7 c2 ff ff       	call   c0100c1c <__panic>
c0104975:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104978:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010497d:	83 c0 04             	add    $0x4,%eax
c0104980:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104983:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104988:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010498f:	00 
c0104990:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104997:	00 
c0104998:	89 04 24             	mov    %eax,(%esp)
c010499b:	e8 55 fa ff ff       	call   c01043f5 <get_pte>
c01049a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01049a3:	74 24                	je     c01049c9 <check_pgdir+0x25e>
c01049a5:	c7 44 24 0c f0 6b 10 	movl   $0xc0106bf0,0xc(%esp)
c01049ac:	c0 
c01049ad:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c01049b4:	c0 
c01049b5:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c01049bc:	00 
c01049bd:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c01049c4:	e8 53 c2 ff ff       	call   c0100c1c <__panic>

    p2 = alloc_page();
c01049c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01049d0:	e8 e1 f2 ff ff       	call   c0103cb6 <alloc_pages>
c01049d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01049d8:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01049dd:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c01049e4:	00 
c01049e5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01049ec:	00 
c01049ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01049f0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01049f4:	89 04 24             	mov    %eax,(%esp)
c01049f7:	e8 3b fc ff ff       	call   c0104637 <page_insert>
c01049fc:	85 c0                	test   %eax,%eax
c01049fe:	74 24                	je     c0104a24 <check_pgdir+0x2b9>
c0104a00:	c7 44 24 0c 18 6c 10 	movl   $0xc0106c18,0xc(%esp)
c0104a07:	c0 
c0104a08:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104a0f:	c0 
c0104a10:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104a17:	00 
c0104a18:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104a1f:	e8 f8 c1 ff ff       	call   c0100c1c <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104a24:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a29:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a30:	00 
c0104a31:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a38:	00 
c0104a39:	89 04 24             	mov    %eax,(%esp)
c0104a3c:	e8 b4 f9 ff ff       	call   c01043f5 <get_pte>
c0104a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a48:	75 24                	jne    c0104a6e <check_pgdir+0x303>
c0104a4a:	c7 44 24 0c 50 6c 10 	movl   $0xc0106c50,0xc(%esp)
c0104a51:	c0 
c0104a52:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104a59:	c0 
c0104a5a:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0104a61:	00 
c0104a62:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104a69:	e8 ae c1 ff ff       	call   c0100c1c <__panic>
    assert(*ptep & PTE_U);
c0104a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a71:	8b 00                	mov    (%eax),%eax
c0104a73:	83 e0 04             	and    $0x4,%eax
c0104a76:	85 c0                	test   %eax,%eax
c0104a78:	75 24                	jne    c0104a9e <check_pgdir+0x333>
c0104a7a:	c7 44 24 0c 80 6c 10 	movl   $0xc0106c80,0xc(%esp)
c0104a81:	c0 
c0104a82:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104a89:	c0 
c0104a8a:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104a91:	00 
c0104a92:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104a99:	e8 7e c1 ff ff       	call   c0100c1c <__panic>
    assert(*ptep & PTE_W);
c0104a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104aa1:	8b 00                	mov    (%eax),%eax
c0104aa3:	83 e0 02             	and    $0x2,%eax
c0104aa6:	85 c0                	test   %eax,%eax
c0104aa8:	75 24                	jne    c0104ace <check_pgdir+0x363>
c0104aaa:	c7 44 24 0c 8e 6c 10 	movl   $0xc0106c8e,0xc(%esp)
c0104ab1:	c0 
c0104ab2:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104ab9:	c0 
c0104aba:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104ac1:	00 
c0104ac2:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104ac9:	e8 4e c1 ff ff       	call   c0100c1c <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104ace:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ad3:	8b 00                	mov    (%eax),%eax
c0104ad5:	83 e0 04             	and    $0x4,%eax
c0104ad8:	85 c0                	test   %eax,%eax
c0104ada:	75 24                	jne    c0104b00 <check_pgdir+0x395>
c0104adc:	c7 44 24 0c 9c 6c 10 	movl   $0xc0106c9c,0xc(%esp)
c0104ae3:	c0 
c0104ae4:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104aeb:	c0 
c0104aec:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104af3:	00 
c0104af4:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104afb:	e8 1c c1 ff ff       	call   c0100c1c <__panic>
    assert(page_ref(p2) == 1);
c0104b00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b03:	89 04 24             	mov    %eax,(%esp)
c0104b06:	e8 a6 ef ff ff       	call   c0103ab1 <page_ref>
c0104b0b:	83 f8 01             	cmp    $0x1,%eax
c0104b0e:	74 24                	je     c0104b34 <check_pgdir+0x3c9>
c0104b10:	c7 44 24 0c b2 6c 10 	movl   $0xc0106cb2,0xc(%esp)
c0104b17:	c0 
c0104b18:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104b1f:	c0 
c0104b20:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104b27:	00 
c0104b28:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104b2f:	e8 e8 c0 ff ff       	call   c0100c1c <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104b34:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b39:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104b40:	00 
c0104b41:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104b48:	00 
c0104b49:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104b4c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104b50:	89 04 24             	mov    %eax,(%esp)
c0104b53:	e8 df fa ff ff       	call   c0104637 <page_insert>
c0104b58:	85 c0                	test   %eax,%eax
c0104b5a:	74 24                	je     c0104b80 <check_pgdir+0x415>
c0104b5c:	c7 44 24 0c c4 6c 10 	movl   $0xc0106cc4,0xc(%esp)
c0104b63:	c0 
c0104b64:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104b6b:	c0 
c0104b6c:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104b73:	00 
c0104b74:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104b7b:	e8 9c c0 ff ff       	call   c0100c1c <__panic>
    assert(page_ref(p1) == 2);
c0104b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b83:	89 04 24             	mov    %eax,(%esp)
c0104b86:	e8 26 ef ff ff       	call   c0103ab1 <page_ref>
c0104b8b:	83 f8 02             	cmp    $0x2,%eax
c0104b8e:	74 24                	je     c0104bb4 <check_pgdir+0x449>
c0104b90:	c7 44 24 0c f0 6c 10 	movl   $0xc0106cf0,0xc(%esp)
c0104b97:	c0 
c0104b98:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104b9f:	c0 
c0104ba0:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104ba7:	00 
c0104ba8:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104baf:	e8 68 c0 ff ff       	call   c0100c1c <__panic>
    assert(page_ref(p2) == 0);
c0104bb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bb7:	89 04 24             	mov    %eax,(%esp)
c0104bba:	e8 f2 ee ff ff       	call   c0103ab1 <page_ref>
c0104bbf:	85 c0                	test   %eax,%eax
c0104bc1:	74 24                	je     c0104be7 <check_pgdir+0x47c>
c0104bc3:	c7 44 24 0c 02 6d 10 	movl   $0xc0106d02,0xc(%esp)
c0104bca:	c0 
c0104bcb:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104bd2:	c0 
c0104bd3:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104bda:	00 
c0104bdb:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104be2:	e8 35 c0 ff ff       	call   c0100c1c <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104be7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104bec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104bf3:	00 
c0104bf4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104bfb:	00 
c0104bfc:	89 04 24             	mov    %eax,(%esp)
c0104bff:	e8 f1 f7 ff ff       	call   c01043f5 <get_pte>
c0104c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c0b:	75 24                	jne    c0104c31 <check_pgdir+0x4c6>
c0104c0d:	c7 44 24 0c 50 6c 10 	movl   $0xc0106c50,0xc(%esp)
c0104c14:	c0 
c0104c15:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104c1c:	c0 
c0104c1d:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104c24:	00 
c0104c25:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104c2c:	e8 eb bf ff ff       	call   c0100c1c <__panic>
    assert(pa2page(*ptep) == p1);
c0104c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c34:	8b 00                	mov    (%eax),%eax
c0104c36:	89 04 24             	mov    %eax,(%esp)
c0104c39:	e8 92 ed ff ff       	call   c01039d0 <pa2page>
c0104c3e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104c41:	74 24                	je     c0104c67 <check_pgdir+0x4fc>
c0104c43:	c7 44 24 0c c9 6b 10 	movl   $0xc0106bc9,0xc(%esp)
c0104c4a:	c0 
c0104c4b:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104c52:	c0 
c0104c53:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104c5a:	00 
c0104c5b:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104c62:	e8 b5 bf ff ff       	call   c0100c1c <__panic>
    assert((*ptep & PTE_U) == 0);
c0104c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c6a:	8b 00                	mov    (%eax),%eax
c0104c6c:	83 e0 04             	and    $0x4,%eax
c0104c6f:	85 c0                	test   %eax,%eax
c0104c71:	74 24                	je     c0104c97 <check_pgdir+0x52c>
c0104c73:	c7 44 24 0c 14 6d 10 	movl   $0xc0106d14,0xc(%esp)
c0104c7a:	c0 
c0104c7b:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104c82:	c0 
c0104c83:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104c8a:	00 
c0104c8b:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104c92:	e8 85 bf ff ff       	call   c0100c1c <__panic>

    page_remove(boot_pgdir, 0x0);
c0104c97:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c9c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ca3:	00 
c0104ca4:	89 04 24             	mov    %eax,(%esp)
c0104ca7:	e8 47 f9 ff ff       	call   c01045f3 <page_remove>
    assert(page_ref(p1) == 1);
c0104cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104caf:	89 04 24             	mov    %eax,(%esp)
c0104cb2:	e8 fa ed ff ff       	call   c0103ab1 <page_ref>
c0104cb7:	83 f8 01             	cmp    $0x1,%eax
c0104cba:	74 24                	je     c0104ce0 <check_pgdir+0x575>
c0104cbc:	c7 44 24 0c de 6b 10 	movl   $0xc0106bde,0xc(%esp)
c0104cc3:	c0 
c0104cc4:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104ccb:	c0 
c0104ccc:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0104cd3:	00 
c0104cd4:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104cdb:	e8 3c bf ff ff       	call   c0100c1c <__panic>
    assert(page_ref(p2) == 0);
c0104ce0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ce3:	89 04 24             	mov    %eax,(%esp)
c0104ce6:	e8 c6 ed ff ff       	call   c0103ab1 <page_ref>
c0104ceb:	85 c0                	test   %eax,%eax
c0104ced:	74 24                	je     c0104d13 <check_pgdir+0x5a8>
c0104cef:	c7 44 24 0c 02 6d 10 	movl   $0xc0106d02,0xc(%esp)
c0104cf6:	c0 
c0104cf7:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104cfe:	c0 
c0104cff:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104d06:	00 
c0104d07:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104d0e:	e8 09 bf ff ff       	call   c0100c1c <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104d13:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d18:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104d1f:	00 
c0104d20:	89 04 24             	mov    %eax,(%esp)
c0104d23:	e8 cb f8 ff ff       	call   c01045f3 <page_remove>
    assert(page_ref(p1) == 0);
c0104d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d2b:	89 04 24             	mov    %eax,(%esp)
c0104d2e:	e8 7e ed ff ff       	call   c0103ab1 <page_ref>
c0104d33:	85 c0                	test   %eax,%eax
c0104d35:	74 24                	je     c0104d5b <check_pgdir+0x5f0>
c0104d37:	c7 44 24 0c 29 6d 10 	movl   $0xc0106d29,0xc(%esp)
c0104d3e:	c0 
c0104d3f:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104d46:	c0 
c0104d47:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0104d4e:	00 
c0104d4f:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104d56:	e8 c1 be ff ff       	call   c0100c1c <__panic>
    assert(page_ref(p2) == 0);
c0104d5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d5e:	89 04 24             	mov    %eax,(%esp)
c0104d61:	e8 4b ed ff ff       	call   c0103ab1 <page_ref>
c0104d66:	85 c0                	test   %eax,%eax
c0104d68:	74 24                	je     c0104d8e <check_pgdir+0x623>
c0104d6a:	c7 44 24 0c 02 6d 10 	movl   $0xc0106d02,0xc(%esp)
c0104d71:	c0 
c0104d72:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104d79:	c0 
c0104d7a:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104d81:	00 
c0104d82:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104d89:	e8 8e be ff ff       	call   c0100c1c <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104d8e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d93:	8b 00                	mov    (%eax),%eax
c0104d95:	89 04 24             	mov    %eax,(%esp)
c0104d98:	e8 33 ec ff ff       	call   c01039d0 <pa2page>
c0104d9d:	89 04 24             	mov    %eax,(%esp)
c0104da0:	e8 0c ed ff ff       	call   c0103ab1 <page_ref>
c0104da5:	83 f8 01             	cmp    $0x1,%eax
c0104da8:	74 24                	je     c0104dce <check_pgdir+0x663>
c0104daa:	c7 44 24 0c 3c 6d 10 	movl   $0xc0106d3c,0xc(%esp)
c0104db1:	c0 
c0104db2:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104db9:	c0 
c0104dba:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104dc1:	00 
c0104dc2:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104dc9:	e8 4e be ff ff       	call   c0100c1c <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0104dce:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104dd3:	8b 00                	mov    (%eax),%eax
c0104dd5:	89 04 24             	mov    %eax,(%esp)
c0104dd8:	e8 f3 eb ff ff       	call   c01039d0 <pa2page>
c0104ddd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104de4:	00 
c0104de5:	89 04 24             	mov    %eax,(%esp)
c0104de8:	e8 01 ef ff ff       	call   c0103cee <free_pages>
    boot_pgdir[0] = 0;
c0104ded:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104df2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104df8:	c7 04 24 62 6d 10 c0 	movl   $0xc0106d62,(%esp)
c0104dff:	e8 48 b5 ff ff       	call   c010034c <cprintf>
}
c0104e04:	c9                   	leave  
c0104e05:	c3                   	ret    

c0104e06 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104e06:	55                   	push   %ebp
c0104e07:	89 e5                	mov    %esp,%ebp
c0104e09:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104e0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e13:	e9 ca 00 00 00       	jmp    c0104ee2 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e21:	c1 e8 0c             	shr    $0xc,%eax
c0104e24:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e27:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104e2c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104e2f:	72 23                	jb     c0104e54 <check_boot_pgdir+0x4e>
c0104e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e34:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e38:	c7 44 24 08 ac 69 10 	movl   $0xc01069ac,0x8(%esp)
c0104e3f:	c0 
c0104e40:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0104e47:	00 
c0104e48:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104e4f:	e8 c8 bd ff ff       	call   c0100c1c <__panic>
c0104e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e57:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104e5c:	89 c2                	mov    %eax,%edx
c0104e5e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e63:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104e6a:	00 
c0104e6b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e6f:	89 04 24             	mov    %eax,(%esp)
c0104e72:	e8 7e f5 ff ff       	call   c01043f5 <get_pte>
c0104e77:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104e7a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104e7e:	75 24                	jne    c0104ea4 <check_boot_pgdir+0x9e>
c0104e80:	c7 44 24 0c 7c 6d 10 	movl   $0xc0106d7c,0xc(%esp)
c0104e87:	c0 
c0104e88:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104e8f:	c0 
c0104e90:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0104e97:	00 
c0104e98:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104e9f:	e8 78 bd ff ff       	call   c0100c1c <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104ea4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ea7:	8b 00                	mov    (%eax),%eax
c0104ea9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104eae:	89 c2                	mov    %eax,%edx
c0104eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eb3:	39 c2                	cmp    %eax,%edx
c0104eb5:	74 24                	je     c0104edb <check_boot_pgdir+0xd5>
c0104eb7:	c7 44 24 0c b9 6d 10 	movl   $0xc0106db9,0xc(%esp)
c0104ebe:	c0 
c0104ebf:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104ec6:	c0 
c0104ec7:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0104ece:	00 
c0104ecf:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104ed6:	e8 41 bd ff ff       	call   c0100c1c <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104edb:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104ee2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104ee5:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104eea:	39 c2                	cmp    %eax,%edx
c0104eec:	0f 82 26 ff ff ff    	jb     c0104e18 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104ef2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ef7:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104efc:	8b 00                	mov    (%eax),%eax
c0104efe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f03:	89 c2                	mov    %eax,%edx
c0104f05:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f0d:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104f14:	77 23                	ja     c0104f39 <check_boot_pgdir+0x133>
c0104f16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f19:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f1d:	c7 44 24 08 50 6a 10 	movl   $0xc0106a50,0x8(%esp)
c0104f24:	c0 
c0104f25:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0104f2c:	00 
c0104f2d:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104f34:	e8 e3 bc ff ff       	call   c0100c1c <__panic>
c0104f39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f3c:	05 00 00 00 40       	add    $0x40000000,%eax
c0104f41:	39 c2                	cmp    %eax,%edx
c0104f43:	74 24                	je     c0104f69 <check_boot_pgdir+0x163>
c0104f45:	c7 44 24 0c d0 6d 10 	movl   $0xc0106dd0,0xc(%esp)
c0104f4c:	c0 
c0104f4d:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104f54:	c0 
c0104f55:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0104f5c:	00 
c0104f5d:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104f64:	e8 b3 bc ff ff       	call   c0100c1c <__panic>

    assert(boot_pgdir[0] == 0);
c0104f69:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f6e:	8b 00                	mov    (%eax),%eax
c0104f70:	85 c0                	test   %eax,%eax
c0104f72:	74 24                	je     c0104f98 <check_boot_pgdir+0x192>
c0104f74:	c7 44 24 0c 04 6e 10 	movl   $0xc0106e04,0xc(%esp)
c0104f7b:	c0 
c0104f7c:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104f83:	c0 
c0104f84:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0104f8b:	00 
c0104f8c:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104f93:	e8 84 bc ff ff       	call   c0100c1c <__panic>

    struct Page *p;
    p = alloc_page();
c0104f98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f9f:	e8 12 ed ff ff       	call   c0103cb6 <alloc_pages>
c0104fa4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104fa7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104fac:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104fb3:	00 
c0104fb4:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104fbb:	00 
c0104fbc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104fbf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104fc3:	89 04 24             	mov    %eax,(%esp)
c0104fc6:	e8 6c f6 ff ff       	call   c0104637 <page_insert>
c0104fcb:	85 c0                	test   %eax,%eax
c0104fcd:	74 24                	je     c0104ff3 <check_boot_pgdir+0x1ed>
c0104fcf:	c7 44 24 0c 18 6e 10 	movl   $0xc0106e18,0xc(%esp)
c0104fd6:	c0 
c0104fd7:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0104fde:	c0 
c0104fdf:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0104fe6:	00 
c0104fe7:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0104fee:	e8 29 bc ff ff       	call   c0100c1c <__panic>
    assert(page_ref(p) == 1);
c0104ff3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ff6:	89 04 24             	mov    %eax,(%esp)
c0104ff9:	e8 b3 ea ff ff       	call   c0103ab1 <page_ref>
c0104ffe:	83 f8 01             	cmp    $0x1,%eax
c0105001:	74 24                	je     c0105027 <check_boot_pgdir+0x221>
c0105003:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c010500a:	c0 
c010500b:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0105012:	c0 
c0105013:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c010501a:	00 
c010501b:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c0105022:	e8 f5 bb ff ff       	call   c0100c1c <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105027:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010502c:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105033:	00 
c0105034:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010503b:	00 
c010503c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010503f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105043:	89 04 24             	mov    %eax,(%esp)
c0105046:	e8 ec f5 ff ff       	call   c0104637 <page_insert>
c010504b:	85 c0                	test   %eax,%eax
c010504d:	74 24                	je     c0105073 <check_boot_pgdir+0x26d>
c010504f:	c7 44 24 0c 58 6e 10 	movl   $0xc0106e58,0xc(%esp)
c0105056:	c0 
c0105057:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c010505e:	c0 
c010505f:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c0105066:	00 
c0105067:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c010506e:	e8 a9 bb ff ff       	call   c0100c1c <__panic>
    assert(page_ref(p) == 2);
c0105073:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105076:	89 04 24             	mov    %eax,(%esp)
c0105079:	e8 33 ea ff ff       	call   c0103ab1 <page_ref>
c010507e:	83 f8 02             	cmp    $0x2,%eax
c0105081:	74 24                	je     c01050a7 <check_boot_pgdir+0x2a1>
c0105083:	c7 44 24 0c 8f 6e 10 	movl   $0xc0106e8f,0xc(%esp)
c010508a:	c0 
c010508b:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c0105092:	c0 
c0105093:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c010509a:	00 
c010509b:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c01050a2:	e8 75 bb ff ff       	call   c0100c1c <__panic>

    const char *str = "ucore: Hello world!!";
c01050a7:	c7 45 dc a0 6e 10 c0 	movl   $0xc0106ea0,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01050ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050b5:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01050bc:	e8 1e 0a 00 00       	call   c0105adf <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01050c1:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01050c8:	00 
c01050c9:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01050d0:	e8 83 0a 00 00       	call   c0105b58 <strcmp>
c01050d5:	85 c0                	test   %eax,%eax
c01050d7:	74 24                	je     c01050fd <check_boot_pgdir+0x2f7>
c01050d9:	c7 44 24 0c b8 6e 10 	movl   $0xc0106eb8,0xc(%esp)
c01050e0:	c0 
c01050e1:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c01050e8:	c0 
c01050e9:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c01050f0:	00 
c01050f1:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c01050f8:	e8 1f bb ff ff       	call   c0100c1c <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01050fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105100:	89 04 24             	mov    %eax,(%esp)
c0105103:	e8 17 e9 ff ff       	call   c0103a1f <page2kva>
c0105108:	05 00 01 00 00       	add    $0x100,%eax
c010510d:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105110:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105117:	e8 6b 09 00 00       	call   c0105a87 <strlen>
c010511c:	85 c0                	test   %eax,%eax
c010511e:	74 24                	je     c0105144 <check_boot_pgdir+0x33e>
c0105120:	c7 44 24 0c f0 6e 10 	movl   $0xc0106ef0,0xc(%esp)
c0105127:	c0 
c0105128:	c7 44 24 08 99 6a 10 	movl   $0xc0106a99,0x8(%esp)
c010512f:	c0 
c0105130:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c0105137:	00 
c0105138:	c7 04 24 74 6a 10 c0 	movl   $0xc0106a74,(%esp)
c010513f:	e8 d8 ba ff ff       	call   c0100c1c <__panic>

    free_page(p);
c0105144:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010514b:	00 
c010514c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010514f:	89 04 24             	mov    %eax,(%esp)
c0105152:	e8 97 eb ff ff       	call   c0103cee <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0105157:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010515c:	8b 00                	mov    (%eax),%eax
c010515e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105163:	89 04 24             	mov    %eax,(%esp)
c0105166:	e8 65 e8 ff ff       	call   c01039d0 <pa2page>
c010516b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105172:	00 
c0105173:	89 04 24             	mov    %eax,(%esp)
c0105176:	e8 73 eb ff ff       	call   c0103cee <free_pages>
    boot_pgdir[0] = 0;
c010517b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105180:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105186:	c7 04 24 14 6f 10 c0 	movl   $0xc0106f14,(%esp)
c010518d:	e8 ba b1 ff ff       	call   c010034c <cprintf>
}
c0105192:	c9                   	leave  
c0105193:	c3                   	ret    

c0105194 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105194:	55                   	push   %ebp
c0105195:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105197:	8b 45 08             	mov    0x8(%ebp),%eax
c010519a:	83 e0 04             	and    $0x4,%eax
c010519d:	85 c0                	test   %eax,%eax
c010519f:	74 07                	je     c01051a8 <perm2str+0x14>
c01051a1:	b8 75 00 00 00       	mov    $0x75,%eax
c01051a6:	eb 05                	jmp    c01051ad <perm2str+0x19>
c01051a8:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01051ad:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c01051b2:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01051b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01051bc:	83 e0 02             	and    $0x2,%eax
c01051bf:	85 c0                	test   %eax,%eax
c01051c1:	74 07                	je     c01051ca <perm2str+0x36>
c01051c3:	b8 77 00 00 00       	mov    $0x77,%eax
c01051c8:	eb 05                	jmp    c01051cf <perm2str+0x3b>
c01051ca:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01051cf:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c01051d4:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c01051db:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c01051e0:	5d                   	pop    %ebp
c01051e1:	c3                   	ret    

c01051e2 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01051e2:	55                   	push   %ebp
c01051e3:	89 e5                	mov    %esp,%ebp
c01051e5:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01051e8:	8b 45 10             	mov    0x10(%ebp),%eax
c01051eb:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01051ee:	72 0a                	jb     c01051fa <get_pgtable_items+0x18>
        return 0;
c01051f0:	b8 00 00 00 00       	mov    $0x0,%eax
c01051f5:	e9 9c 00 00 00       	jmp    c0105296 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c01051fa:	eb 04                	jmp    c0105200 <get_pgtable_items+0x1e>
        start ++;
c01051fc:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105200:	8b 45 10             	mov    0x10(%ebp),%eax
c0105203:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105206:	73 18                	jae    c0105220 <get_pgtable_items+0x3e>
c0105208:	8b 45 10             	mov    0x10(%ebp),%eax
c010520b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105212:	8b 45 14             	mov    0x14(%ebp),%eax
c0105215:	01 d0                	add    %edx,%eax
c0105217:	8b 00                	mov    (%eax),%eax
c0105219:	83 e0 01             	and    $0x1,%eax
c010521c:	85 c0                	test   %eax,%eax
c010521e:	74 dc                	je     c01051fc <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105220:	8b 45 10             	mov    0x10(%ebp),%eax
c0105223:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105226:	73 69                	jae    c0105291 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105228:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010522c:	74 08                	je     c0105236 <get_pgtable_items+0x54>
            *left_store = start;
c010522e:	8b 45 18             	mov    0x18(%ebp),%eax
c0105231:	8b 55 10             	mov    0x10(%ebp),%edx
c0105234:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105236:	8b 45 10             	mov    0x10(%ebp),%eax
c0105239:	8d 50 01             	lea    0x1(%eax),%edx
c010523c:	89 55 10             	mov    %edx,0x10(%ebp)
c010523f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105246:	8b 45 14             	mov    0x14(%ebp),%eax
c0105249:	01 d0                	add    %edx,%eax
c010524b:	8b 00                	mov    (%eax),%eax
c010524d:	83 e0 07             	and    $0x7,%eax
c0105250:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105253:	eb 04                	jmp    c0105259 <get_pgtable_items+0x77>
            start ++;
c0105255:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105259:	8b 45 10             	mov    0x10(%ebp),%eax
c010525c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010525f:	73 1d                	jae    c010527e <get_pgtable_items+0x9c>
c0105261:	8b 45 10             	mov    0x10(%ebp),%eax
c0105264:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010526b:	8b 45 14             	mov    0x14(%ebp),%eax
c010526e:	01 d0                	add    %edx,%eax
c0105270:	8b 00                	mov    (%eax),%eax
c0105272:	83 e0 07             	and    $0x7,%eax
c0105275:	89 c2                	mov    %eax,%edx
c0105277:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010527a:	39 c2                	cmp    %eax,%edx
c010527c:	74 d7                	je     c0105255 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c010527e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105282:	74 08                	je     c010528c <get_pgtable_items+0xaa>
            *right_store = start;
c0105284:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105287:	8b 55 10             	mov    0x10(%ebp),%edx
c010528a:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c010528c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010528f:	eb 05                	jmp    c0105296 <get_pgtable_items+0xb4>
    }
    return 0;
c0105291:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105296:	c9                   	leave  
c0105297:	c3                   	ret    

c0105298 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105298:	55                   	push   %ebp
c0105299:	89 e5                	mov    %esp,%ebp
c010529b:	57                   	push   %edi
c010529c:	56                   	push   %esi
c010529d:	53                   	push   %ebx
c010529e:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01052a1:	c7 04 24 34 6f 10 c0 	movl   $0xc0106f34,(%esp)
c01052a8:	e8 9f b0 ff ff       	call   c010034c <cprintf>
    size_t left, right = 0, perm;
c01052ad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01052b4:	e9 fa 00 00 00       	jmp    c01053b3 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01052b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052bc:	89 04 24             	mov    %eax,(%esp)
c01052bf:	e8 d0 fe ff ff       	call   c0105194 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01052c4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01052c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01052ca:	29 d1                	sub    %edx,%ecx
c01052cc:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01052ce:	89 d6                	mov    %edx,%esi
c01052d0:	c1 e6 16             	shl    $0x16,%esi
c01052d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052d6:	89 d3                	mov    %edx,%ebx
c01052d8:	c1 e3 16             	shl    $0x16,%ebx
c01052db:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01052de:	89 d1                	mov    %edx,%ecx
c01052e0:	c1 e1 16             	shl    $0x16,%ecx
c01052e3:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01052e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01052e9:	29 d7                	sub    %edx,%edi
c01052eb:	89 fa                	mov    %edi,%edx
c01052ed:	89 44 24 14          	mov    %eax,0x14(%esp)
c01052f1:	89 74 24 10          	mov    %esi,0x10(%esp)
c01052f5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01052f9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01052fd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105301:	c7 04 24 65 6f 10 c0 	movl   $0xc0106f65,(%esp)
c0105308:	e8 3f b0 ff ff       	call   c010034c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c010530d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105310:	c1 e0 0a             	shl    $0xa,%eax
c0105313:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105316:	eb 54                	jmp    c010536c <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105318:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010531b:	89 04 24             	mov    %eax,(%esp)
c010531e:	e8 71 fe ff ff       	call   c0105194 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105323:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105326:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105329:	29 d1                	sub    %edx,%ecx
c010532b:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010532d:	89 d6                	mov    %edx,%esi
c010532f:	c1 e6 0c             	shl    $0xc,%esi
c0105332:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105335:	89 d3                	mov    %edx,%ebx
c0105337:	c1 e3 0c             	shl    $0xc,%ebx
c010533a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010533d:	c1 e2 0c             	shl    $0xc,%edx
c0105340:	89 d1                	mov    %edx,%ecx
c0105342:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105345:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105348:	29 d7                	sub    %edx,%edi
c010534a:	89 fa                	mov    %edi,%edx
c010534c:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105350:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105354:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105358:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010535c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105360:	c7 04 24 84 6f 10 c0 	movl   $0xc0106f84,(%esp)
c0105367:	e8 e0 af ff ff       	call   c010034c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010536c:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105371:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105374:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105377:	89 ce                	mov    %ecx,%esi
c0105379:	c1 e6 0a             	shl    $0xa,%esi
c010537c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010537f:	89 cb                	mov    %ecx,%ebx
c0105381:	c1 e3 0a             	shl    $0xa,%ebx
c0105384:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105387:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010538b:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c010538e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105392:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105396:	89 44 24 08          	mov    %eax,0x8(%esp)
c010539a:	89 74 24 04          	mov    %esi,0x4(%esp)
c010539e:	89 1c 24             	mov    %ebx,(%esp)
c01053a1:	e8 3c fe ff ff       	call   c01051e2 <get_pgtable_items>
c01053a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01053ad:	0f 85 65 ff ff ff    	jne    c0105318 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01053b3:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01053b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01053bb:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01053be:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01053c2:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c01053c5:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01053c9:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01053cd:	89 44 24 08          	mov    %eax,0x8(%esp)
c01053d1:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01053d8:	00 
c01053d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01053e0:	e8 fd fd ff ff       	call   c01051e2 <get_pgtable_items>
c01053e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01053ec:	0f 85 c7 fe ff ff    	jne    c01052b9 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01053f2:	c7 04 24 a8 6f 10 c0 	movl   $0xc0106fa8,(%esp)
c01053f9:	e8 4e af ff ff       	call   c010034c <cprintf>
}
c01053fe:	83 c4 4c             	add    $0x4c,%esp
c0105401:	5b                   	pop    %ebx
c0105402:	5e                   	pop    %esi
c0105403:	5f                   	pop    %edi
c0105404:	5d                   	pop    %ebp
c0105405:	c3                   	ret    

c0105406 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105406:	55                   	push   %ebp
c0105407:	89 e5                	mov    %esp,%ebp
c0105409:	83 ec 58             	sub    $0x58,%esp
c010540c:	8b 45 10             	mov    0x10(%ebp),%eax
c010540f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105412:	8b 45 14             	mov    0x14(%ebp),%eax
c0105415:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105418:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010541b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010541e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105421:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105424:	8b 45 18             	mov    0x18(%ebp),%eax
c0105427:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010542a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010542d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105430:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105433:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105436:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105439:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010543c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105440:	74 1c                	je     c010545e <printnum+0x58>
c0105442:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105445:	ba 00 00 00 00       	mov    $0x0,%edx
c010544a:	f7 75 e4             	divl   -0x1c(%ebp)
c010544d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105450:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105453:	ba 00 00 00 00       	mov    $0x0,%edx
c0105458:	f7 75 e4             	divl   -0x1c(%ebp)
c010545b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010545e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105461:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105464:	f7 75 e4             	divl   -0x1c(%ebp)
c0105467:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010546a:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010546d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105470:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105473:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105476:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105479:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010547c:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010547f:	8b 45 18             	mov    0x18(%ebp),%eax
c0105482:	ba 00 00 00 00       	mov    $0x0,%edx
c0105487:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010548a:	77 56                	ja     c01054e2 <printnum+0xdc>
c010548c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010548f:	72 05                	jb     c0105496 <printnum+0x90>
c0105491:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105494:	77 4c                	ja     c01054e2 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105496:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105499:	8d 50 ff             	lea    -0x1(%eax),%edx
c010549c:	8b 45 20             	mov    0x20(%ebp),%eax
c010549f:	89 44 24 18          	mov    %eax,0x18(%esp)
c01054a3:	89 54 24 14          	mov    %edx,0x14(%esp)
c01054a7:	8b 45 18             	mov    0x18(%ebp),%eax
c01054aa:	89 44 24 10          	mov    %eax,0x10(%esp)
c01054ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01054b4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01054b8:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01054bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01054c6:	89 04 24             	mov    %eax,(%esp)
c01054c9:	e8 38 ff ff ff       	call   c0105406 <printnum>
c01054ce:	eb 1c                	jmp    c01054ec <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01054d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054d7:	8b 45 20             	mov    0x20(%ebp),%eax
c01054da:	89 04 24             	mov    %eax,(%esp)
c01054dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01054e0:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01054e2:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01054e6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01054ea:	7f e4                	jg     c01054d0 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01054ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01054ef:	05 5c 70 10 c0       	add    $0xc010705c,%eax
c01054f4:	0f b6 00             	movzbl (%eax),%eax
c01054f7:	0f be c0             	movsbl %al,%eax
c01054fa:	8b 55 0c             	mov    0xc(%ebp),%edx
c01054fd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105501:	89 04 24             	mov    %eax,(%esp)
c0105504:	8b 45 08             	mov    0x8(%ebp),%eax
c0105507:	ff d0                	call   *%eax
}
c0105509:	c9                   	leave  
c010550a:	c3                   	ret    

c010550b <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010550b:	55                   	push   %ebp
c010550c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010550e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105512:	7e 14                	jle    c0105528 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105514:	8b 45 08             	mov    0x8(%ebp),%eax
c0105517:	8b 00                	mov    (%eax),%eax
c0105519:	8d 48 08             	lea    0x8(%eax),%ecx
c010551c:	8b 55 08             	mov    0x8(%ebp),%edx
c010551f:	89 0a                	mov    %ecx,(%edx)
c0105521:	8b 50 04             	mov    0x4(%eax),%edx
c0105524:	8b 00                	mov    (%eax),%eax
c0105526:	eb 30                	jmp    c0105558 <getuint+0x4d>
    }
    else if (lflag) {
c0105528:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010552c:	74 16                	je     c0105544 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010552e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105531:	8b 00                	mov    (%eax),%eax
c0105533:	8d 48 04             	lea    0x4(%eax),%ecx
c0105536:	8b 55 08             	mov    0x8(%ebp),%edx
c0105539:	89 0a                	mov    %ecx,(%edx)
c010553b:	8b 00                	mov    (%eax),%eax
c010553d:	ba 00 00 00 00       	mov    $0x0,%edx
c0105542:	eb 14                	jmp    c0105558 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105544:	8b 45 08             	mov    0x8(%ebp),%eax
c0105547:	8b 00                	mov    (%eax),%eax
c0105549:	8d 48 04             	lea    0x4(%eax),%ecx
c010554c:	8b 55 08             	mov    0x8(%ebp),%edx
c010554f:	89 0a                	mov    %ecx,(%edx)
c0105551:	8b 00                	mov    (%eax),%eax
c0105553:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105558:	5d                   	pop    %ebp
c0105559:	c3                   	ret    

c010555a <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010555a:	55                   	push   %ebp
c010555b:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010555d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105561:	7e 14                	jle    c0105577 <getint+0x1d>
        return va_arg(*ap, long long);
c0105563:	8b 45 08             	mov    0x8(%ebp),%eax
c0105566:	8b 00                	mov    (%eax),%eax
c0105568:	8d 48 08             	lea    0x8(%eax),%ecx
c010556b:	8b 55 08             	mov    0x8(%ebp),%edx
c010556e:	89 0a                	mov    %ecx,(%edx)
c0105570:	8b 50 04             	mov    0x4(%eax),%edx
c0105573:	8b 00                	mov    (%eax),%eax
c0105575:	eb 28                	jmp    c010559f <getint+0x45>
    }
    else if (lflag) {
c0105577:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010557b:	74 12                	je     c010558f <getint+0x35>
        return va_arg(*ap, long);
c010557d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105580:	8b 00                	mov    (%eax),%eax
c0105582:	8d 48 04             	lea    0x4(%eax),%ecx
c0105585:	8b 55 08             	mov    0x8(%ebp),%edx
c0105588:	89 0a                	mov    %ecx,(%edx)
c010558a:	8b 00                	mov    (%eax),%eax
c010558c:	99                   	cltd   
c010558d:	eb 10                	jmp    c010559f <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010558f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105592:	8b 00                	mov    (%eax),%eax
c0105594:	8d 48 04             	lea    0x4(%eax),%ecx
c0105597:	8b 55 08             	mov    0x8(%ebp),%edx
c010559a:	89 0a                	mov    %ecx,(%edx)
c010559c:	8b 00                	mov    (%eax),%eax
c010559e:	99                   	cltd   
    }
}
c010559f:	5d                   	pop    %ebp
c01055a0:	c3                   	ret    

c01055a1 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01055a1:	55                   	push   %ebp
c01055a2:	89 e5                	mov    %esp,%ebp
c01055a4:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01055a7:	8d 45 14             	lea    0x14(%ebp),%eax
c01055aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01055ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01055b4:	8b 45 10             	mov    0x10(%ebp),%eax
c01055b7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01055bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c5:	89 04 24             	mov    %eax,(%esp)
c01055c8:	e8 02 00 00 00       	call   c01055cf <vprintfmt>
    va_end(ap);
}
c01055cd:	c9                   	leave  
c01055ce:	c3                   	ret    

c01055cf <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01055cf:	55                   	push   %ebp
c01055d0:	89 e5                	mov    %esp,%ebp
c01055d2:	56                   	push   %esi
c01055d3:	53                   	push   %ebx
c01055d4:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01055d7:	eb 18                	jmp    c01055f1 <vprintfmt+0x22>
            if (ch == '\0') {
c01055d9:	85 db                	test   %ebx,%ebx
c01055db:	75 05                	jne    c01055e2 <vprintfmt+0x13>
                return;
c01055dd:	e9 d1 03 00 00       	jmp    c01059b3 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01055e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055e9:	89 1c 24             	mov    %ebx,(%esp)
c01055ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ef:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01055f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01055f4:	8d 50 01             	lea    0x1(%eax),%edx
c01055f7:	89 55 10             	mov    %edx,0x10(%ebp)
c01055fa:	0f b6 00             	movzbl (%eax),%eax
c01055fd:	0f b6 d8             	movzbl %al,%ebx
c0105600:	83 fb 25             	cmp    $0x25,%ebx
c0105603:	75 d4                	jne    c01055d9 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105605:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105609:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105613:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105616:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010561d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105620:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105623:	8b 45 10             	mov    0x10(%ebp),%eax
c0105626:	8d 50 01             	lea    0x1(%eax),%edx
c0105629:	89 55 10             	mov    %edx,0x10(%ebp)
c010562c:	0f b6 00             	movzbl (%eax),%eax
c010562f:	0f b6 d8             	movzbl %al,%ebx
c0105632:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105635:	83 f8 55             	cmp    $0x55,%eax
c0105638:	0f 87 44 03 00 00    	ja     c0105982 <vprintfmt+0x3b3>
c010563e:	8b 04 85 80 70 10 c0 	mov    -0x3fef8f80(,%eax,4),%eax
c0105645:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105647:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010564b:	eb d6                	jmp    c0105623 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010564d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105651:	eb d0                	jmp    c0105623 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105653:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010565a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010565d:	89 d0                	mov    %edx,%eax
c010565f:	c1 e0 02             	shl    $0x2,%eax
c0105662:	01 d0                	add    %edx,%eax
c0105664:	01 c0                	add    %eax,%eax
c0105666:	01 d8                	add    %ebx,%eax
c0105668:	83 e8 30             	sub    $0x30,%eax
c010566b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010566e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105671:	0f b6 00             	movzbl (%eax),%eax
c0105674:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105677:	83 fb 2f             	cmp    $0x2f,%ebx
c010567a:	7e 0b                	jle    c0105687 <vprintfmt+0xb8>
c010567c:	83 fb 39             	cmp    $0x39,%ebx
c010567f:	7f 06                	jg     c0105687 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105681:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0105685:	eb d3                	jmp    c010565a <vprintfmt+0x8b>
            goto process_precision;
c0105687:	eb 33                	jmp    c01056bc <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0105689:	8b 45 14             	mov    0x14(%ebp),%eax
c010568c:	8d 50 04             	lea    0x4(%eax),%edx
c010568f:	89 55 14             	mov    %edx,0x14(%ebp)
c0105692:	8b 00                	mov    (%eax),%eax
c0105694:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105697:	eb 23                	jmp    c01056bc <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0105699:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010569d:	79 0c                	jns    c01056ab <vprintfmt+0xdc>
                width = 0;
c010569f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01056a6:	e9 78 ff ff ff       	jmp    c0105623 <vprintfmt+0x54>
c01056ab:	e9 73 ff ff ff       	jmp    c0105623 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01056b0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01056b7:	e9 67 ff ff ff       	jmp    c0105623 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01056bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056c0:	79 12                	jns    c01056d4 <vprintfmt+0x105>
                width = precision, precision = -1;
c01056c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01056c8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01056cf:	e9 4f ff ff ff       	jmp    c0105623 <vprintfmt+0x54>
c01056d4:	e9 4a ff ff ff       	jmp    c0105623 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01056d9:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01056dd:	e9 41 ff ff ff       	jmp    c0105623 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01056e2:	8b 45 14             	mov    0x14(%ebp),%eax
c01056e5:	8d 50 04             	lea    0x4(%eax),%edx
c01056e8:	89 55 14             	mov    %edx,0x14(%ebp)
c01056eb:	8b 00                	mov    (%eax),%eax
c01056ed:	8b 55 0c             	mov    0xc(%ebp),%edx
c01056f0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01056f4:	89 04 24             	mov    %eax,(%esp)
c01056f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01056fa:	ff d0                	call   *%eax
            break;
c01056fc:	e9 ac 02 00 00       	jmp    c01059ad <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105701:	8b 45 14             	mov    0x14(%ebp),%eax
c0105704:	8d 50 04             	lea    0x4(%eax),%edx
c0105707:	89 55 14             	mov    %edx,0x14(%ebp)
c010570a:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010570c:	85 db                	test   %ebx,%ebx
c010570e:	79 02                	jns    c0105712 <vprintfmt+0x143>
                err = -err;
c0105710:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105712:	83 fb 06             	cmp    $0x6,%ebx
c0105715:	7f 0b                	jg     c0105722 <vprintfmt+0x153>
c0105717:	8b 34 9d 40 70 10 c0 	mov    -0x3fef8fc0(,%ebx,4),%esi
c010571e:	85 f6                	test   %esi,%esi
c0105720:	75 23                	jne    c0105745 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0105722:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105726:	c7 44 24 08 6d 70 10 	movl   $0xc010706d,0x8(%esp)
c010572d:	c0 
c010572e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105731:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105735:	8b 45 08             	mov    0x8(%ebp),%eax
c0105738:	89 04 24             	mov    %eax,(%esp)
c010573b:	e8 61 fe ff ff       	call   c01055a1 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105740:	e9 68 02 00 00       	jmp    c01059ad <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105745:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105749:	c7 44 24 08 76 70 10 	movl   $0xc0107076,0x8(%esp)
c0105750:	c0 
c0105751:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105754:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105758:	8b 45 08             	mov    0x8(%ebp),%eax
c010575b:	89 04 24             	mov    %eax,(%esp)
c010575e:	e8 3e fe ff ff       	call   c01055a1 <printfmt>
            }
            break;
c0105763:	e9 45 02 00 00       	jmp    c01059ad <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105768:	8b 45 14             	mov    0x14(%ebp),%eax
c010576b:	8d 50 04             	lea    0x4(%eax),%edx
c010576e:	89 55 14             	mov    %edx,0x14(%ebp)
c0105771:	8b 30                	mov    (%eax),%esi
c0105773:	85 f6                	test   %esi,%esi
c0105775:	75 05                	jne    c010577c <vprintfmt+0x1ad>
                p = "(null)";
c0105777:	be 79 70 10 c0       	mov    $0xc0107079,%esi
            }
            if (width > 0 && padc != '-') {
c010577c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105780:	7e 3e                	jle    c01057c0 <vprintfmt+0x1f1>
c0105782:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105786:	74 38                	je     c01057c0 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105788:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c010578b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010578e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105792:	89 34 24             	mov    %esi,(%esp)
c0105795:	e8 15 03 00 00       	call   c0105aaf <strnlen>
c010579a:	29 c3                	sub    %eax,%ebx
c010579c:	89 d8                	mov    %ebx,%eax
c010579e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057a1:	eb 17                	jmp    c01057ba <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01057a3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01057a7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01057aa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057ae:	89 04 24             	mov    %eax,(%esp)
c01057b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b4:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057b6:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01057ba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057be:	7f e3                	jg     c01057a3 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01057c0:	eb 38                	jmp    c01057fa <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c01057c2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01057c6:	74 1f                	je     c01057e7 <vprintfmt+0x218>
c01057c8:	83 fb 1f             	cmp    $0x1f,%ebx
c01057cb:	7e 05                	jle    c01057d2 <vprintfmt+0x203>
c01057cd:	83 fb 7e             	cmp    $0x7e,%ebx
c01057d0:	7e 15                	jle    c01057e7 <vprintfmt+0x218>
                    putch('?', putdat);
c01057d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057d9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01057e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e3:	ff d0                	call   *%eax
c01057e5:	eb 0f                	jmp    c01057f6 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c01057e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057ea:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057ee:	89 1c 24             	mov    %ebx,(%esp)
c01057f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f4:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01057f6:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01057fa:	89 f0                	mov    %esi,%eax
c01057fc:	8d 70 01             	lea    0x1(%eax),%esi
c01057ff:	0f b6 00             	movzbl (%eax),%eax
c0105802:	0f be d8             	movsbl %al,%ebx
c0105805:	85 db                	test   %ebx,%ebx
c0105807:	74 10                	je     c0105819 <vprintfmt+0x24a>
c0105809:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010580d:	78 b3                	js     c01057c2 <vprintfmt+0x1f3>
c010580f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105813:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105817:	79 a9                	jns    c01057c2 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105819:	eb 17                	jmp    c0105832 <vprintfmt+0x263>
                putch(' ', putdat);
c010581b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010581e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105822:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105829:	8b 45 08             	mov    0x8(%ebp),%eax
c010582c:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010582e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105832:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105836:	7f e3                	jg     c010581b <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0105838:	e9 70 01 00 00       	jmp    c01059ad <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010583d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105840:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105844:	8d 45 14             	lea    0x14(%ebp),%eax
c0105847:	89 04 24             	mov    %eax,(%esp)
c010584a:	e8 0b fd ff ff       	call   c010555a <getint>
c010584f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105852:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105855:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105858:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010585b:	85 d2                	test   %edx,%edx
c010585d:	79 26                	jns    c0105885 <vprintfmt+0x2b6>
                putch('-', putdat);
c010585f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105862:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105866:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010586d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105870:	ff d0                	call   *%eax
                num = -(long long)num;
c0105872:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105875:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105878:	f7 d8                	neg    %eax
c010587a:	83 d2 00             	adc    $0x0,%edx
c010587d:	f7 da                	neg    %edx
c010587f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105882:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105885:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010588c:	e9 a8 00 00 00       	jmp    c0105939 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105891:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105894:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105898:	8d 45 14             	lea    0x14(%ebp),%eax
c010589b:	89 04 24             	mov    %eax,(%esp)
c010589e:	e8 68 fc ff ff       	call   c010550b <getuint>
c01058a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01058a9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058b0:	e9 84 00 00 00       	jmp    c0105939 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01058b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058b8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058bc:	8d 45 14             	lea    0x14(%ebp),%eax
c01058bf:	89 04 24             	mov    %eax,(%esp)
c01058c2:	e8 44 fc ff ff       	call   c010550b <getuint>
c01058c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01058cd:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01058d4:	eb 63                	jmp    c0105939 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01058d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058dd:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01058e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e7:	ff d0                	call   *%eax
            putch('x', putdat);
c01058e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058f0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01058f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01058fa:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01058fc:	8b 45 14             	mov    0x14(%ebp),%eax
c01058ff:	8d 50 04             	lea    0x4(%eax),%edx
c0105902:	89 55 14             	mov    %edx,0x14(%ebp)
c0105905:	8b 00                	mov    (%eax),%eax
c0105907:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010590a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105911:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105918:	eb 1f                	jmp    c0105939 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010591a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010591d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105921:	8d 45 14             	lea    0x14(%ebp),%eax
c0105924:	89 04 24             	mov    %eax,(%esp)
c0105927:	e8 df fb ff ff       	call   c010550b <getuint>
c010592c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010592f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105932:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105939:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010593d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105940:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105944:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105947:	89 54 24 14          	mov    %edx,0x14(%esp)
c010594b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010594f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105952:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105955:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105959:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010595d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105960:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105964:	8b 45 08             	mov    0x8(%ebp),%eax
c0105967:	89 04 24             	mov    %eax,(%esp)
c010596a:	e8 97 fa ff ff       	call   c0105406 <printnum>
            break;
c010596f:	eb 3c                	jmp    c01059ad <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105971:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105974:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105978:	89 1c 24             	mov    %ebx,(%esp)
c010597b:	8b 45 08             	mov    0x8(%ebp),%eax
c010597e:	ff d0                	call   *%eax
            break;
c0105980:	eb 2b                	jmp    c01059ad <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105982:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105985:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105989:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105990:	8b 45 08             	mov    0x8(%ebp),%eax
c0105993:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105995:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105999:	eb 04                	jmp    c010599f <vprintfmt+0x3d0>
c010599b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010599f:	8b 45 10             	mov    0x10(%ebp),%eax
c01059a2:	83 e8 01             	sub    $0x1,%eax
c01059a5:	0f b6 00             	movzbl (%eax),%eax
c01059a8:	3c 25                	cmp    $0x25,%al
c01059aa:	75 ef                	jne    c010599b <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c01059ac:	90                   	nop
        }
    }
c01059ad:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01059ae:	e9 3e fc ff ff       	jmp    c01055f1 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01059b3:	83 c4 40             	add    $0x40,%esp
c01059b6:	5b                   	pop    %ebx
c01059b7:	5e                   	pop    %esi
c01059b8:	5d                   	pop    %ebp
c01059b9:	c3                   	ret    

c01059ba <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01059ba:	55                   	push   %ebp
c01059bb:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01059bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059c0:	8b 40 08             	mov    0x8(%eax),%eax
c01059c3:	8d 50 01             	lea    0x1(%eax),%edx
c01059c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059c9:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01059cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059cf:	8b 10                	mov    (%eax),%edx
c01059d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059d4:	8b 40 04             	mov    0x4(%eax),%eax
c01059d7:	39 c2                	cmp    %eax,%edx
c01059d9:	73 12                	jae    c01059ed <sprintputch+0x33>
        *b->buf ++ = ch;
c01059db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059de:	8b 00                	mov    (%eax),%eax
c01059e0:	8d 48 01             	lea    0x1(%eax),%ecx
c01059e3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01059e6:	89 0a                	mov    %ecx,(%edx)
c01059e8:	8b 55 08             	mov    0x8(%ebp),%edx
c01059eb:	88 10                	mov    %dl,(%eax)
    }
}
c01059ed:	5d                   	pop    %ebp
c01059ee:	c3                   	ret    

c01059ef <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01059ef:	55                   	push   %ebp
c01059f0:	89 e5                	mov    %esp,%ebp
c01059f2:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01059f5:	8d 45 14             	lea    0x14(%ebp),%eax
c01059f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01059fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a02:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a05:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a09:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a10:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a13:	89 04 24             	mov    %eax,(%esp)
c0105a16:	e8 08 00 00 00       	call   c0105a23 <vsnprintf>
c0105a1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a21:	c9                   	leave  
c0105a22:	c3                   	ret    

c0105a23 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105a23:	55                   	push   %ebp
c0105a24:	89 e5                	mov    %esp,%ebp
c0105a26:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105a29:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a32:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a35:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a38:	01 d0                	add    %edx,%eax
c0105a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105a44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105a48:	74 0a                	je     c0105a54 <vsnprintf+0x31>
c0105a4a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a50:	39 c2                	cmp    %eax,%edx
c0105a52:	76 07                	jbe    c0105a5b <vsnprintf+0x38>
        return -E_INVAL;
c0105a54:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105a59:	eb 2a                	jmp    c0105a85 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105a5b:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a5e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a62:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a65:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a69:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a70:	c7 04 24 ba 59 10 c0 	movl   $0xc01059ba,(%esp)
c0105a77:	e8 53 fb ff ff       	call   c01055cf <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105a7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a7f:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a85:	c9                   	leave  
c0105a86:	c3                   	ret    

c0105a87 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105a87:	55                   	push   %ebp
c0105a88:	89 e5                	mov    %esp,%ebp
c0105a8a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105a8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105a94:	eb 04                	jmp    c0105a9a <strlen+0x13>
        cnt ++;
c0105a96:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105a9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a9d:	8d 50 01             	lea    0x1(%eax),%edx
c0105aa0:	89 55 08             	mov    %edx,0x8(%ebp)
c0105aa3:	0f b6 00             	movzbl (%eax),%eax
c0105aa6:	84 c0                	test   %al,%al
c0105aa8:	75 ec                	jne    c0105a96 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105aaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105aad:	c9                   	leave  
c0105aae:	c3                   	ret    

c0105aaf <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105aaf:	55                   	push   %ebp
c0105ab0:	89 e5                	mov    %esp,%ebp
c0105ab2:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105ab5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105abc:	eb 04                	jmp    c0105ac2 <strnlen+0x13>
        cnt ++;
c0105abe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105ac2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105ac5:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105ac8:	73 10                	jae    c0105ada <strnlen+0x2b>
c0105aca:	8b 45 08             	mov    0x8(%ebp),%eax
c0105acd:	8d 50 01             	lea    0x1(%eax),%edx
c0105ad0:	89 55 08             	mov    %edx,0x8(%ebp)
c0105ad3:	0f b6 00             	movzbl (%eax),%eax
c0105ad6:	84 c0                	test   %al,%al
c0105ad8:	75 e4                	jne    c0105abe <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105ada:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105add:	c9                   	leave  
c0105ade:	c3                   	ret    

c0105adf <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105adf:	55                   	push   %ebp
c0105ae0:	89 e5                	mov    %esp,%ebp
c0105ae2:	57                   	push   %edi
c0105ae3:	56                   	push   %esi
c0105ae4:	83 ec 20             	sub    $0x20,%esp
c0105ae7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105aed:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105af3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105af9:	89 d1                	mov    %edx,%ecx
c0105afb:	89 c2                	mov    %eax,%edx
c0105afd:	89 ce                	mov    %ecx,%esi
c0105aff:	89 d7                	mov    %edx,%edi
c0105b01:	ac                   	lods   %ds:(%esi),%al
c0105b02:	aa                   	stos   %al,%es:(%edi)
c0105b03:	84 c0                	test   %al,%al
c0105b05:	75 fa                	jne    c0105b01 <strcpy+0x22>
c0105b07:	89 fa                	mov    %edi,%edx
c0105b09:	89 f1                	mov    %esi,%ecx
c0105b0b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105b0e:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105b11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105b17:	83 c4 20             	add    $0x20,%esp
c0105b1a:	5e                   	pop    %esi
c0105b1b:	5f                   	pop    %edi
c0105b1c:	5d                   	pop    %ebp
c0105b1d:	c3                   	ret    

c0105b1e <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105b1e:	55                   	push   %ebp
c0105b1f:	89 e5                	mov    %esp,%ebp
c0105b21:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105b24:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b27:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105b2a:	eb 21                	jmp    c0105b4d <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b2f:	0f b6 10             	movzbl (%eax),%edx
c0105b32:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b35:	88 10                	mov    %dl,(%eax)
c0105b37:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b3a:	0f b6 00             	movzbl (%eax),%eax
c0105b3d:	84 c0                	test   %al,%al
c0105b3f:	74 04                	je     c0105b45 <strncpy+0x27>
            src ++;
c0105b41:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105b45:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105b49:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105b4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b51:	75 d9                	jne    c0105b2c <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105b53:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105b56:	c9                   	leave  
c0105b57:	c3                   	ret    

c0105b58 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105b58:	55                   	push   %ebp
c0105b59:	89 e5                	mov    %esp,%ebp
c0105b5b:	57                   	push   %edi
c0105b5c:	56                   	push   %esi
c0105b5d:	83 ec 20             	sub    $0x20,%esp
c0105b60:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b66:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b69:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105b6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b72:	89 d1                	mov    %edx,%ecx
c0105b74:	89 c2                	mov    %eax,%edx
c0105b76:	89 ce                	mov    %ecx,%esi
c0105b78:	89 d7                	mov    %edx,%edi
c0105b7a:	ac                   	lods   %ds:(%esi),%al
c0105b7b:	ae                   	scas   %es:(%edi),%al
c0105b7c:	75 08                	jne    c0105b86 <strcmp+0x2e>
c0105b7e:	84 c0                	test   %al,%al
c0105b80:	75 f8                	jne    c0105b7a <strcmp+0x22>
c0105b82:	31 c0                	xor    %eax,%eax
c0105b84:	eb 04                	jmp    c0105b8a <strcmp+0x32>
c0105b86:	19 c0                	sbb    %eax,%eax
c0105b88:	0c 01                	or     $0x1,%al
c0105b8a:	89 fa                	mov    %edi,%edx
c0105b8c:	89 f1                	mov    %esi,%ecx
c0105b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105b91:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105b94:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105b9a:	83 c4 20             	add    $0x20,%esp
c0105b9d:	5e                   	pop    %esi
c0105b9e:	5f                   	pop    %edi
c0105b9f:	5d                   	pop    %ebp
c0105ba0:	c3                   	ret    

c0105ba1 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105ba1:	55                   	push   %ebp
c0105ba2:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105ba4:	eb 0c                	jmp    c0105bb2 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105ba6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105baa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bae:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105bb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bb6:	74 1a                	je     c0105bd2 <strncmp+0x31>
c0105bb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bbb:	0f b6 00             	movzbl (%eax),%eax
c0105bbe:	84 c0                	test   %al,%al
c0105bc0:	74 10                	je     c0105bd2 <strncmp+0x31>
c0105bc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bc5:	0f b6 10             	movzbl (%eax),%edx
c0105bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bcb:	0f b6 00             	movzbl (%eax),%eax
c0105bce:	38 c2                	cmp    %al,%dl
c0105bd0:	74 d4                	je     c0105ba6 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105bd2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bd6:	74 18                	je     c0105bf0 <strncmp+0x4f>
c0105bd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bdb:	0f b6 00             	movzbl (%eax),%eax
c0105bde:	0f b6 d0             	movzbl %al,%edx
c0105be1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105be4:	0f b6 00             	movzbl (%eax),%eax
c0105be7:	0f b6 c0             	movzbl %al,%eax
c0105bea:	29 c2                	sub    %eax,%edx
c0105bec:	89 d0                	mov    %edx,%eax
c0105bee:	eb 05                	jmp    c0105bf5 <strncmp+0x54>
c0105bf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105bf5:	5d                   	pop    %ebp
c0105bf6:	c3                   	ret    

c0105bf7 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105bf7:	55                   	push   %ebp
c0105bf8:	89 e5                	mov    %esp,%ebp
c0105bfa:	83 ec 04             	sub    $0x4,%esp
c0105bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c00:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c03:	eb 14                	jmp    c0105c19 <strchr+0x22>
        if (*s == c) {
c0105c05:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c08:	0f b6 00             	movzbl (%eax),%eax
c0105c0b:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c0e:	75 05                	jne    c0105c15 <strchr+0x1e>
            return (char *)s;
c0105c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c13:	eb 13                	jmp    c0105c28 <strchr+0x31>
        }
        s ++;
c0105c15:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105c19:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c1c:	0f b6 00             	movzbl (%eax),%eax
c0105c1f:	84 c0                	test   %al,%al
c0105c21:	75 e2                	jne    c0105c05 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105c23:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c28:	c9                   	leave  
c0105c29:	c3                   	ret    

c0105c2a <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105c2a:	55                   	push   %ebp
c0105c2b:	89 e5                	mov    %esp,%ebp
c0105c2d:	83 ec 04             	sub    $0x4,%esp
c0105c30:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c33:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c36:	eb 11                	jmp    c0105c49 <strfind+0x1f>
        if (*s == c) {
c0105c38:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c3b:	0f b6 00             	movzbl (%eax),%eax
c0105c3e:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c41:	75 02                	jne    c0105c45 <strfind+0x1b>
            break;
c0105c43:	eb 0e                	jmp    c0105c53 <strfind+0x29>
        }
        s ++;
c0105c45:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105c49:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c4c:	0f b6 00             	movzbl (%eax),%eax
c0105c4f:	84 c0                	test   %al,%al
c0105c51:	75 e5                	jne    c0105c38 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105c53:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105c56:	c9                   	leave  
c0105c57:	c3                   	ret    

c0105c58 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105c58:	55                   	push   %ebp
c0105c59:	89 e5                	mov    %esp,%ebp
c0105c5b:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105c5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105c65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105c6c:	eb 04                	jmp    c0105c72 <strtol+0x1a>
        s ++;
c0105c6e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105c72:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c75:	0f b6 00             	movzbl (%eax),%eax
c0105c78:	3c 20                	cmp    $0x20,%al
c0105c7a:	74 f2                	je     c0105c6e <strtol+0x16>
c0105c7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c7f:	0f b6 00             	movzbl (%eax),%eax
c0105c82:	3c 09                	cmp    $0x9,%al
c0105c84:	74 e8                	je     c0105c6e <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105c86:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c89:	0f b6 00             	movzbl (%eax),%eax
c0105c8c:	3c 2b                	cmp    $0x2b,%al
c0105c8e:	75 06                	jne    c0105c96 <strtol+0x3e>
        s ++;
c0105c90:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c94:	eb 15                	jmp    c0105cab <strtol+0x53>
    }
    else if (*s == '-') {
c0105c96:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c99:	0f b6 00             	movzbl (%eax),%eax
c0105c9c:	3c 2d                	cmp    $0x2d,%al
c0105c9e:	75 0b                	jne    c0105cab <strtol+0x53>
        s ++, neg = 1;
c0105ca0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105ca4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105cab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105caf:	74 06                	je     c0105cb7 <strtol+0x5f>
c0105cb1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105cb5:	75 24                	jne    c0105cdb <strtol+0x83>
c0105cb7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cba:	0f b6 00             	movzbl (%eax),%eax
c0105cbd:	3c 30                	cmp    $0x30,%al
c0105cbf:	75 1a                	jne    c0105cdb <strtol+0x83>
c0105cc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc4:	83 c0 01             	add    $0x1,%eax
c0105cc7:	0f b6 00             	movzbl (%eax),%eax
c0105cca:	3c 78                	cmp    $0x78,%al
c0105ccc:	75 0d                	jne    c0105cdb <strtol+0x83>
        s += 2, base = 16;
c0105cce:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105cd2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105cd9:	eb 2a                	jmp    c0105d05 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105cdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cdf:	75 17                	jne    c0105cf8 <strtol+0xa0>
c0105ce1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce4:	0f b6 00             	movzbl (%eax),%eax
c0105ce7:	3c 30                	cmp    $0x30,%al
c0105ce9:	75 0d                	jne    c0105cf8 <strtol+0xa0>
        s ++, base = 8;
c0105ceb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105cef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105cf6:	eb 0d                	jmp    c0105d05 <strtol+0xad>
    }
    else if (base == 0) {
c0105cf8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cfc:	75 07                	jne    c0105d05 <strtol+0xad>
        base = 10;
c0105cfe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105d05:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d08:	0f b6 00             	movzbl (%eax),%eax
c0105d0b:	3c 2f                	cmp    $0x2f,%al
c0105d0d:	7e 1b                	jle    c0105d2a <strtol+0xd2>
c0105d0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d12:	0f b6 00             	movzbl (%eax),%eax
c0105d15:	3c 39                	cmp    $0x39,%al
c0105d17:	7f 11                	jg     c0105d2a <strtol+0xd2>
            dig = *s - '0';
c0105d19:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d1c:	0f b6 00             	movzbl (%eax),%eax
c0105d1f:	0f be c0             	movsbl %al,%eax
c0105d22:	83 e8 30             	sub    $0x30,%eax
c0105d25:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d28:	eb 48                	jmp    c0105d72 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105d2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d2d:	0f b6 00             	movzbl (%eax),%eax
c0105d30:	3c 60                	cmp    $0x60,%al
c0105d32:	7e 1b                	jle    c0105d4f <strtol+0xf7>
c0105d34:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d37:	0f b6 00             	movzbl (%eax),%eax
c0105d3a:	3c 7a                	cmp    $0x7a,%al
c0105d3c:	7f 11                	jg     c0105d4f <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105d3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d41:	0f b6 00             	movzbl (%eax),%eax
c0105d44:	0f be c0             	movsbl %al,%eax
c0105d47:	83 e8 57             	sub    $0x57,%eax
c0105d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d4d:	eb 23                	jmp    c0105d72 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105d4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d52:	0f b6 00             	movzbl (%eax),%eax
c0105d55:	3c 40                	cmp    $0x40,%al
c0105d57:	7e 3d                	jle    c0105d96 <strtol+0x13e>
c0105d59:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d5c:	0f b6 00             	movzbl (%eax),%eax
c0105d5f:	3c 5a                	cmp    $0x5a,%al
c0105d61:	7f 33                	jg     c0105d96 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105d63:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d66:	0f b6 00             	movzbl (%eax),%eax
c0105d69:	0f be c0             	movsbl %al,%eax
c0105d6c:	83 e8 37             	sub    $0x37,%eax
c0105d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d75:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105d78:	7c 02                	jl     c0105d7c <strtol+0x124>
            break;
c0105d7a:	eb 1a                	jmp    c0105d96 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105d7c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d80:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d83:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105d87:	89 c2                	mov    %eax,%edx
c0105d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d8c:	01 d0                	add    %edx,%eax
c0105d8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105d91:	e9 6f ff ff ff       	jmp    c0105d05 <strtol+0xad>

    if (endptr) {
c0105d96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105d9a:	74 08                	je     c0105da4 <strtol+0x14c>
        *endptr = (char *) s;
c0105d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d9f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105da2:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105da4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105da8:	74 07                	je     c0105db1 <strtol+0x159>
c0105daa:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dad:	f7 d8                	neg    %eax
c0105daf:	eb 03                	jmp    c0105db4 <strtol+0x15c>
c0105db1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105db4:	c9                   	leave  
c0105db5:	c3                   	ret    

c0105db6 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105db6:	55                   	push   %ebp
c0105db7:	89 e5                	mov    %esp,%ebp
c0105db9:	57                   	push   %edi
c0105dba:	83 ec 24             	sub    $0x24,%esp
c0105dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dc0:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105dc3:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105dc7:	8b 55 08             	mov    0x8(%ebp),%edx
c0105dca:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105dcd:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105dd0:	8b 45 10             	mov    0x10(%ebp),%eax
c0105dd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105dd6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105dd9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105ddd:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105de0:	89 d7                	mov    %edx,%edi
c0105de2:	f3 aa                	rep stos %al,%es:(%edi)
c0105de4:	89 fa                	mov    %edi,%edx
c0105de6:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105de9:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105dec:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105def:	83 c4 24             	add    $0x24,%esp
c0105df2:	5f                   	pop    %edi
c0105df3:	5d                   	pop    %ebp
c0105df4:	c3                   	ret    

c0105df5 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105df5:	55                   	push   %ebp
c0105df6:	89 e5                	mov    %esp,%ebp
c0105df8:	57                   	push   %edi
c0105df9:	56                   	push   %esi
c0105dfa:	53                   	push   %ebx
c0105dfb:	83 ec 30             	sub    $0x30,%esp
c0105dfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e01:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e07:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e0a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e0d:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e13:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105e16:	73 42                	jae    c0105e5a <memmove+0x65>
c0105e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e21:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105e24:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e27:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e2d:	c1 e8 02             	shr    $0x2,%eax
c0105e30:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105e32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105e35:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e38:	89 d7                	mov    %edx,%edi
c0105e3a:	89 c6                	mov    %eax,%esi
c0105e3c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e3e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e41:	83 e1 03             	and    $0x3,%ecx
c0105e44:	74 02                	je     c0105e48 <memmove+0x53>
c0105e46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e48:	89 f0                	mov    %esi,%eax
c0105e4a:	89 fa                	mov    %edi,%edx
c0105e4c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105e4f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105e52:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105e55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e58:	eb 36                	jmp    c0105e90 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105e5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e5d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105e60:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e63:	01 c2                	add    %eax,%edx
c0105e65:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e68:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e6e:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105e71:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e74:	89 c1                	mov    %eax,%ecx
c0105e76:	89 d8                	mov    %ebx,%eax
c0105e78:	89 d6                	mov    %edx,%esi
c0105e7a:	89 c7                	mov    %eax,%edi
c0105e7c:	fd                   	std    
c0105e7d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e7f:	fc                   	cld    
c0105e80:	89 f8                	mov    %edi,%eax
c0105e82:	89 f2                	mov    %esi,%edx
c0105e84:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105e87:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105e8a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105e90:	83 c4 30             	add    $0x30,%esp
c0105e93:	5b                   	pop    %ebx
c0105e94:	5e                   	pop    %esi
c0105e95:	5f                   	pop    %edi
c0105e96:	5d                   	pop    %ebp
c0105e97:	c3                   	ret    

c0105e98 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105e98:	55                   	push   %ebp
c0105e99:	89 e5                	mov    %esp,%ebp
c0105e9b:	57                   	push   %edi
c0105e9c:	56                   	push   %esi
c0105e9d:	83 ec 20             	sub    $0x20,%esp
c0105ea0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ea3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ea9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105eac:	8b 45 10             	mov    0x10(%ebp),%eax
c0105eaf:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105eb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105eb5:	c1 e8 02             	shr    $0x2,%eax
c0105eb8:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ec0:	89 d7                	mov    %edx,%edi
c0105ec2:	89 c6                	mov    %eax,%esi
c0105ec4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105ec6:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105ec9:	83 e1 03             	and    $0x3,%ecx
c0105ecc:	74 02                	je     c0105ed0 <memcpy+0x38>
c0105ece:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105ed0:	89 f0                	mov    %esi,%eax
c0105ed2:	89 fa                	mov    %edi,%edx
c0105ed4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105ed7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105eda:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105ee0:	83 c4 20             	add    $0x20,%esp
c0105ee3:	5e                   	pop    %esi
c0105ee4:	5f                   	pop    %edi
c0105ee5:	5d                   	pop    %ebp
c0105ee6:	c3                   	ret    

c0105ee7 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105ee7:	55                   	push   %ebp
c0105ee8:	89 e5                	mov    %esp,%ebp
c0105eea:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105eed:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ef0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ef6:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105ef9:	eb 30                	jmp    c0105f2b <memcmp+0x44>
        if (*s1 != *s2) {
c0105efb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105efe:	0f b6 10             	movzbl (%eax),%edx
c0105f01:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f04:	0f b6 00             	movzbl (%eax),%eax
c0105f07:	38 c2                	cmp    %al,%dl
c0105f09:	74 18                	je     c0105f23 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105f0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f0e:	0f b6 00             	movzbl (%eax),%eax
c0105f11:	0f b6 d0             	movzbl %al,%edx
c0105f14:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f17:	0f b6 00             	movzbl (%eax),%eax
c0105f1a:	0f b6 c0             	movzbl %al,%eax
c0105f1d:	29 c2                	sub    %eax,%edx
c0105f1f:	89 d0                	mov    %edx,%eax
c0105f21:	eb 1a                	jmp    c0105f3d <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105f23:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105f27:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105f2b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f2e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105f31:	89 55 10             	mov    %edx,0x10(%ebp)
c0105f34:	85 c0                	test   %eax,%eax
c0105f36:	75 c3                	jne    c0105efb <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105f38:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f3d:	c9                   	leave  
c0105f3e:	c3                   	ret    
