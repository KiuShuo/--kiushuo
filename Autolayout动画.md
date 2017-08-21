# AutoLayout动画

#### AutoLayout优先级

参考资料：  
[iOS的一个小技巧——AutoLayout约束的优先级](http://www.jianshu.com/p/1410f4eab8b3)

Conetnt Hugging Priority 抗拉伸优先级  
当父视图的范围比较大于要显示的子视图时，会对子视图进行拉伸；此时优先级越大的，越晚被拉伸。

![拉伸优先级](image/ContentHuggingPriority.png)

Content Compression Resistance Priority  抗压缩优先级  
当子视图的内容超出父视图的范围时，会对子视图进行压缩；此时压缩优先级越大，越晚被压缩。
![压缩优先级](image/ContentCompressionResistancePriority.png)

#### AutoLayout动画
