# lab6实验报告

### 计25班 姚鑫 2012011360

## 练习0
使用`SourceGear DiffMerge`工具进行比较和合并。本次实验没有合并lab1 challenge部分的代码。
同时对lab1中`trap.c`和lab5中`proc.c`进行了进一步的修改。

说明：在这里，我发现了自己lab5中有一个笔误产生的bug。

`lab5\kern\process\proc.c`中第650行，应为：
```
tf->tf_cs = USER_CS;
```
而我之前版本中错误的写为：
```
tf->tf_cs = USER_DS;
```
在这次lab6实验中，已经对这一错误进行了修改。


## 练习1
- init：初始化调度队列；
- enqueue：把一个进程放入队列中；
- dequeue：把一个进程弹出队列； 
- pick_next：从队列中拿出一个合适的进程作为下次运行的进程。

---

初始化之后，系统通过schedule来调度进程。schedule首先把当前进程放入队列，然后从队列中挑选一个合适的进程运行。
round robin算法维护一个队列，当进程时间片用完时，调用schedule，把当前进程放到队尾，再取出当前队头作为下一个执行的进程。

---

有一个队列的列表，它是队列的总调度器，由它决定从哪个队列里pick_next作为切换到的进程。
该列表中有多个进程队列，这些队列实现了具体的调度算法。
总调度器把一个进程绑定在具体的进程队列中，这个进程的enqueue、dequeue都由相应的队列控制。


## 练习2
- 初始化：把队头设置为null，并把进程计数器置零
- enqueue：用斜堆的方法`skew_heap_insert`插入，更新`time_slice`和`proc_num`
- dequeue：用斜堆的方法`skew_heap_remove`删除，更新`proc_num`
- pick：选取堆顶的元素，并更新`stride`
- 时钟中断：每次时间片减1，如果时间片用尽，则重新调度。

