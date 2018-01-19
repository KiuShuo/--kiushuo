# UIKit动力学

参考资料：  
[iOS scheme跳转机制](https://www.jianshu.com/p/138b44833cda)  

需要说明的是：当从A应用跳转到B应用的时候，是否需要在A应用里面添加`scheme`取决于是否调用了`canOpenUrl`函数，如果直接调用`openUrl`函数是不需要在`info.plist`文件里面添加B应用的`scheme`的。


