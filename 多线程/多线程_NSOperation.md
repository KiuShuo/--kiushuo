# 多线程之NSOperation

参考资料：  
[NSOperation](http://nshipster.cn/nsoperation/)  
[iOS多线程之NSOperation和NSOperationQueue](http://blog.devzeng.com/blog/ios-nsoperation-and-nsoperationqueue.html)  
[iOS多线程之NSOperation](http://www.jianshu.com/p/c6650fcc6612)  
[iOS 并发编程之 Operation Queues](http://blog.leichunfeng.com/blog/2015/07/29/ios-concurrency-programming-operation-queues/)  

`NSOperation`封装了需要执行的操作和执行操作所需要的数据，可以以并发或者非并发的方式执行操作，`NSOperation`本身是抽象基类，所以只能使用它的子类。  

系统给我们提供了两个`NSOperation`的子类： `NSBlockOperation`和`NSInvocationOperation`，当然我们也可以自定义。

自定义`NSOperation`的字类时需要注意：  

* 自定义非并发的`NSOperation`，只需要实现两个方法：自定义初始化方法和main方法。  

* 自定义并发的`NSOperation`有一些必须实现的方法和属性：  

	|方法／属性|描述|
	|:---:|---|
	|start|必须的，所有并发执行的`operation`都必须要重写这个方法，替换掉`NSOperation`类中的默认实现。`start`方法是一个`operation`的起点，我们可以在这里配置任务执行的线程或者一些其它的执行环境。另外，需要特别注意的是，在我们重写的`start`方法中一定不要调用父类的实现`[super start]`。|
	| main | 可选的，通常这个方法就是专门用来实现与该`operation`相关联的任务的。尽管我们可以直接在`start`方法中执行我们的任务，但是用`main`方法来实现我们的任务可以使设置代码和任务代码得到分离，从而使`operation`的结构更清晰；|
	|isExecuting 和 isFinish|必须的，并发执行的 operation 需要负责配置它们的执行环境，并且向外界客户报告执行环境的状态。因此，一个并发执行的 operation 必须要维护一些状态信息，用来记录它的任务是否正在执行，是否已经完成执行等。此外，当这两个方法所代表的值发生变化时，我们需要生成相应的 KVO 通知，以便外界能够观察到这些状态的变化。|
	| isConcurrent |必须的，这个方法的返回值用来标识一个`operation`是否是并发的 `operation`，我们需要重写这个方法并返回`YES`。|

#### NSOperation的使用：  
1. 执行操作
	`NSOperation`调用`-(void)start`方法即可开始执行操作，默认按同步方式执行，即在调用`start`方法所在的线程中执行。  
	`NSOperation`的`-(Bool)isConcurrent`方法会返回当前操作相对于调用start方法的线程是同步还是异步执行。默认返回NO，同步执行。
2. 取消操作  
	`NSOperation`开始执行操作之后默认会一直执行操作直到完成，可以调用`-(void)cancel`方法中途取消操作。需要注意的是，调用`cancel`方法后并不是立即取消的，而是在下一个`isCancelled`的检查点取消的。
3. 执行完成
	如果想在`NSOperation`执行操作完成之后做一些处理，可以调用`setCompletionBlock`方法来在`block`中处理。
