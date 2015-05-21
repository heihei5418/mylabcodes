# lab8实验报告

### 计25班 姚鑫 2012011360

## 练习0
使用`SourceGear DiffMerge`工具进行比较和合并。并对之前的代码进行了进一步的修改。


## 练习1
这个练习补全`sfs_inode.c`的`sfs_io_nolock`函数。
该函数实现的功能是对`[offset, endpos]`区间内容进行io操作。

对于完整的block，用`blk_io`操作，否则用`buf_io`操作。
所以只需要对开头和结尾的块进行特殊判断，根据情况调用不同的函数处理即可。

ret返回的是io操作是否成功，io操作成功的字符串长度通过指针alen传递。

---

使用VFS机制提供的接口，设计一个pipe用的`pipefs`,在系统调用时，创建出两个file，一个只读，一个只写，并使这两个file连接到同一个inode上，inode使用pipefs里定义的
`pipefs_inode`，并在其中维护一个数据缓冲区，使用VFS提供的read/write接口，在该数据缓冲区里读写数据。

在缓冲区里提供了一个head和一个tail指针，当两个指针重合时数据为空，并且在filefs_inode中提供了一个管程wait,用来对进程间的同步进行管理。


## 练习2
这个练习是补全`proc.c`中的`load_icode`函数。`load_icode`函数是将用户态的程序加载到当前的进程中。

通过与lab7对比可以发现，lab7是从内存中加载数据，现在是提供了一个文件句柄fd，从文件系统中加载数据。可以通过`load_icode_read`函数从文件系统中读取`elfheader`和`proghdr`，从而加载程序的`TEXT/DATA/BSS`部分。

然后要设置好内存参数(cr3等)和用户堆栈(uargc, uargv)等信息。

---

- 硬链接机制的设计实现：
  vfs中预留了硬链接的实现接口`int vfs_link(char *old_path, char *new_path);`。
  在实现硬链接机制的时候，只要为`new_path`创建对应的file，并把其inode指向
  `old_path`所对应的inode，并将其引用计数加1；在unlink时将引用计数减1即可。

- 软链接机制的设计实现：
  可以在创建软链接时创建一个新的文件，将被链接文件的存储信息，特别是位置信息存放到文件中去。
  对于这种文件的`inode`进行操作，
  首先要读取其中保存的被链接文件的相关信息，然后对该文件的`inode`进行相应的操作。
  unlink时类似于删除一个普通的文件
