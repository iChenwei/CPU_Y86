#### 前递技术（forwarding）
- 又叫：数据旁路技术（bypassing）
- 不需要走完流水线的所有阶段，将数据提前写回寄存器文件（register file）节省实现提高效率
- 解决数据冲突/数据冒险，和插入nop过多
