# lab2实验报告

计25班 姚鑫 2012011360
---

## 练习0
使用`SourceGear DiffMerge`工具进行比较和合并。


## 练习1
首先阅读相关的头文件，了解list的方法以及一些宏的定义，保留了demo中的`default_init`。
这个实验采用的虽然是连续内存分配，但是启用了页机制，每个`free block`都包含了若干个`page`。

`default_init_memmap`：这个函数是用来初始化`a free block`的，具体做法是对其中的每一个`page`分别初始化。
将`free block`的第一个`page`的`property`属性设为整个`block`的`page`个数，其他`page`的`property`属性设为0。
对于每个`page`，`p->flags = 0; p->ref = 0`，然后将这些`page`依次添加到`free_list`中。
最后，要修改空闲内存块的数目，也就是`nr_free`。

`default_alloc_pages`：按照`first fit`算法找到并分配合适的内存块。
首先要遍历整个`free_list`，如果找到合适大小的`page`，也即满足`p->property >= n`，就将接下来的n个`page`分配掉。
对于分配出去的`page`，利用相应的宏命令设置`p->flags = 1; p->property = 0`，并将其从`free_list`中删掉。
如果该`free_block`在分配了n个`page`之后，仍有剩余空间，则将这些剩余空间修改为一个新的`free_block`。
最后，要修改空闲内存块的数目，也就是`nr_free`。

`default_free_pages`：将指定空间重新加入`free_list`并视情况与前后的block合并。
首先遍历整个`free_list`，找到合适的插入位置，将每个`page`依次插入，并设置`flags`，`property`和`ref`等参数。
然后判断其前后的`free block`是否在地址上与当前块相邻，如果是的，就执行合并。
合并的过程，主要是修改待合并的两个`free block`的第一个`page`的相关参数。
最后，要修改空闲内存块的数目，也就是`nr_free`。


## 练习2
这个练习是要修改`pmm.c`中的`get_pte`函数，其功能是找到一个虚地址对应的二级页表项的内核虚地址，如果此二级页表项不存在，则分配一个包含此项的二级页表。
在注释中，很清晰的描述了该函数的工作流程：
- 找到虚拟地址`la`对应的`pde表`的`index`；
- 判断该`entry`是否是符合要求的；
- 如果不是，则判断时候需要分配一个二级页表；
- 如果需要，这分配一个新的二级页表，并设置好相关参数并将内容清空；
- 最后返回`pte表`的一个条目。

整个过程并不复杂，在实验中感到复杂的是其中的地址关系。最后我们得到的是一个一级页表`pde表`的条目，然后通过宏命令`PDE_ADDR`得到该条目中储存的物理地址，
该地址也是二级页表的基址，然后通过宏命令`KADDR`将该物理地址转换成对应的内核虚地址。
然后再通过宏命令`PTX`得到虚拟地址`la`在对应的二级页表`pte表`中的`index`，有了二级页表的基址和索引，最终找到二级页表项，即`pte表`中的`entry`。
---

下面是页目录项`pde`和页表项`pte`的标志位：
```
#define PTE_P           0x001                   // Present
#define PTE_W           0x002                   // Writeable
#define PTE_U           0x004                   // User
#define PTE_PWT         0x008                   // Write-Through
#define PTE_PCD         0x010                   // Cache-Disable
#define PTE_A           0x020                   // Accessed
#define PTE_D           0x040                   // Dirty
#define PTE_PS          0x080                   // Page Size
#define PTE_MBZ         0x180                   // Bits must be zero
#define PTE_AVAIL       0xE00                   // Available for software use
```
这些标志位的主要功能是权限控制和信息标识。除了这些标志位之外，页目录项和页表项还分别保存了对应二级页表和物理内存区域的基址，这一部分是为了寻址。
---

如果ucore执行过程中访问内存，出现了页访问异常，硬件首先会将当前执行的程序的相关信息保存到栈中，然后调用中断处理服务。


## 练习3
这个练习是要修改`pmm.c`中的`page_remove_pte`函数，其功能是释放一个包含某虚地址的物理内存页。
首先需要让对应此物理内存页的管理数据结构Page做相关的清除处理，使得此物理内存页成为空闲；另外还需把表示虚地址与物理地址对应关系的二级页表项清除。
在注释中，很清晰的描述了该函数的工作流程：
- 判断该`pte`是否是符合要求的；
- 找到该`pte`对应的`page`；
- `page->ref`减1,如果减到0,这释放该`page`；
- flush tlb。
---

页表是从end开始的连续一段内存存放的

