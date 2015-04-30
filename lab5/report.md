# lab5实验报告

### 计25班 姚鑫 2012011360

## 练习0
使用`SourceGear DiffMerge`工具进行比较和合并。本次实验没有合并lab1 challenge部分的代码。
同时对lab1中`trap.c`和lab4中`alloc_proc`和`do_fork`两个函数进行了进一步的修改。


## 练习1
这个练习是要补全`proc.c`中的`load_icode`函数，其功能是加载并解析一个处于内存中的ELF执行文件格式的应用程序，
建立相应的用户内存空间来放置应用程序的代码段、数据段等，且要设置好proc_struct结构中的成员变量trapframe中的内容。
我们的主要工作是设置正确的trapframe内容。
具体地，tf的cs段为用户代码段，ds、es、ss段为用户数据段， eip为程序开头，esp为用户栈顶，eflags为FL_IF，即允许中断。

---

执行switch_to切换进程之后，返回到fortret函数，然后调用fortrets，这里传递了参数tf，后面iret的时候，会返回到tf指向的位置。
而tf已经在load_icode中设置为用户态的段，所以就返回到用户态，并开始执行用户态程序。


## 练习2
这个练习是要补全`pmm.c`中的`copy_range`函数，
其功能是为拷贝当前进程（即父进程）的用户内存地址空间中的合法内容到新进程中（子进程），完成内存资源的复制。
	1. 找到源内存页和目标内存页对应的内核虚地址
	2. 用memcpy函数进行复制，大小为一页的大小
	3. 调用page_insert修改页表的映射关系

---

在dup_mmap中复制mm_struct的时候，直接复制vma的指针，相当于两个mm_struct共享同一份vma列表，并让这些vma只读。 然后发现缺页的时候，如果检测到在尝试写一个只读页，那么说明这里有多个进程在共用这个vma，
这个时候再去新建一个vma并用copy_range复制数据，同时修改相应的mm_struct即可。


## 练习3
fork：创建一个新的进程，把父进程的当前状态复制之后，令新的进程状态为RUNNABLE。

exec：将进程的mm置为NULL，然后调用load_icode，将用户进程拷贝进来，为用户进程建立处于用户态的新的内存空间以及用户栈，然后转到用户态执行。
如果load_icode失败，则会调用do_exit退出。

wait：如果找到了符合条件的子进程，则回收子进程的资源并正常返回；否则如果子进程正在运行，则通过schedule让自己变为SLEEPING，等到下次被唤醒的时候再去寻找子进程。

exit：首先回收大部分资源，并将当前进程设成ZOMBIE状态，然后查看父进程，如果在等待状态，则唤醒父进程；
接着遍历自己的子进程，把他们的父进程均设置为initproc，如果子进程有ZOMBIE状态且initproc为等待状态则唤醒initproc。

---

```
PROC_UNINIT(创建)     PROC_ZOMBIE(结束)
            |                   ^    do_exit
            | do_fork           |
            |                   |
            v                   |        do_wait
          PROC_RUNNABLE(就绪)-------------------------> PROC_SLEEPING(等待)
                            <------------------------
                                  wakeup_proc
```
