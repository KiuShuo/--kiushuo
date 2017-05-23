### POP 面向协议编程

***
#### 写在前面：
本文并非原创，而是对他人文章的总结，本文的性质仅是学习笔记，目的是为了更好的理解学习面向协议编程。  
参考资料：  
[Swift 协议](http://wiki.jikexueyuan.com/project/swift/chapter2/22_Protocols.html)  
[从 Swift 的面向协议编程说开去](https://bestswifter.com/pop/)  
[Swift面向协议编程初探](http://www.cocoachina.com/swift/20150902/12824.html)  
[Swift面向协议编程基础篇（一）](http://www.jianshu.com/p/1d1572662456?utm_campaign=haruki&utm_content=note&utm_medium=reader_share&utm_source=weibo&url_type=39&object_type=webpage&pos=1)

***

#### 面向协议编程是什么？

你可能听过类似的概念：面向对象编程、函数式编程、泛型编程，再加上苹果今年新提出的面向协议编程，这些统统可以理解为==是一种编程范式==。所谓编程范式，是隐藏在编程语言背后的思想，代表着语言的作者想要用怎样的方式去解决怎样的问题。不同的编程范式反应在现实世界中，就是不同的编程语言适用于不同的领域和环境，比如在面向对象编程思想中，开发者用对象来描述万事万物并试图用对象来解决所有可能的问题。编程范式都有其各自的偏好和使用限制，所以越来越多的现代编程语言开始支持多范式，使语言自身更强壮也更具适用性。

#### 为什么要面向协议？
首先，面向协议的思想已经提出很多年了，很多经典书籍中都提出过:“面向接口编程，而不是面向实现编程”的概念。

这句话很好理解，假设我们有一个类——灯泡，还有一个方法，参数类型是灯泡，方法中可以调用灯泡的“打开”和“关闭”方法。用面向接口的思想来写，就会把参数类型定义为某个接口，比如叫 Openable，并且在这个接口中定义了打开和关闭方法。

这样做的好处在于，假设你将来又多了一个类，比如说是电视机，只要它实现了 Openable 接口，就可以作为上述方法的参数使用。这就满足了:“对拓展开放，对修改关闭”的思想。

很自然的想法是，为什么我不能定义一个灯泡和电视机的父类，而是偏偏选择接口？答案很简单，因为灯泡和电视机很可能已经有父类了，即使没有，也不能如此草率的为它们定义父类。

#### 面向协议和面向对象的区别？

面向对象编程和面向协议编程最明显的区别在于程序设计过程中对数据类型的抽取（抽象）上，==面向对象编程使用类和继承的手段，数据类型是引用类型；而面向协议编程使用的是遵守协议的手段，数据类型是值类型（Swift中的结构体或枚举）==。

面向协议编程是在面向对象编程基础上发展而来的，而并不是完全背离面向对象编程的思想。

面向对象编程是伟大的编程思想，也是当今主流的编程思想，它的问题在于被过多的使用在其实并不需要使用它的情况下。

#### 什么时候使用继承？  
Swift是一门支持多编程范式的语言，既支持面向对象编程，也支持面向协议编程，同时还支持函数式编程。在项目开发过程中，==控制器和视图部分由于使用系统框架，应更多采用面向对象编程的方式；而模型或业务逻辑等自定义类型部分，则应优先考虑面向协议编程==。

答案是:“当你是父类的一种细化时”，这也就是我们强调的 is-a 的概念。只有当你确实是父类，能在任何父类出现的地方替换父类(里氏替换原则)时，才应该使用继承。  

比方说：所有的UIViewController继承自BaseViewController，所有的UITableViewCell继承自BaseTableViewCell。  

Stack不能继承Array。

***

#### 面向协议例子
接下来我们就正式进入Swift的面向协议编程的世界。首先我们来对比如下两段示例代码，代码的功能是定义一个更具扩展性的二分查找法。

```
	// 继承的做法：	
	class Ordered {
	    func precedes(other: Ordered) -> Bool { fatalError("implement me!") }
	}
	class Number: Ordered {
	    var value: Double = 0
	    override func precedes(other: Ordered) -> Bool {
	        return self.value < (other as! Number).value
	    }
	}
	func binarySearch(sortedKeys: [Ordered], forKey k: Ordered) -> Int {
	    var lo = 0
	    var hi = sortedKeys.count
	    while hi > lo {
	        let mid = lo + (hi - lo) / 2
	        if sortedKeys[mid].precedes(k) { lo = mid + 1 }
	        else { hi = mid }
	    }
	    return lo
	}
	
	// 面向协议的做法
	protocol Ordered {
	    func precedes(other: Self) -> Bool
	}
	struct Number: Ordered {
	    var value: Double = 0
	    func precedes(other: Number) -> Bool {
	        return self.value < other.value
	    }
	}
	func binarySearch(sortedKeys: [T], forKey k: T) -> Int {
	    var lo = 0
	    var hi = sortedKeys.count
	    while hi > lo {
	        let mid = lo + (hi - lo) / 2
	        if sortedKeys[mid].precedes(k) { lo = mid + 1 }
	        else { hi = mid }
	    }
	    return lo
	}
```
应该不难看出两者之间的区别以及孰优孰劣，简单解释一下前者的缺点，反过来也就是后者的优点了。

OC语言中没有抽象类这个概念，所有抽象类都是靠文档注释标明，这很蛋疼~
其他类型若想使用该二分查找法，必须继承自Ordered抽象类，在单继承体系中，该类型将无法再继承其他类型
方法参数接收的数组中，类型要求不严格，可以放入多种不同类型的Ordered子类对象
基于前一点原因，为保证严谨性，必须在方法实现内部增加类型判断，这更加蛋疼~~
基于上面的例子，我们可以稍微感受到面向协议编程在扩展性上的优势了，这里再提几个注意点。

Swift 2.0新特性之一，将Self用于约束泛型，功能类似于OC中的instancetype，示例：extension Ordered where Self: Comparable
Swift 2.0另一个重要的新特性，协议可扩展，意味着你不仅可以扩展一个类型使其遵守Ordered协议，还可以直接扩展某个协议，详见如下两段代码示例。

```
	// 扩展类型
	extension Int: Ordered {
	    func precedes(other: Int) -> Bool {
	        return self < other
	    }
	}
	extension String: Ordered {
	    func precedes(other: String) -> Bool {
	        return self < other
	    }
	}
	let intIndex = binarySearch([2, 3, 5, 7], forKey: 5) // 输出结果2
	let stringIndex = binarySearch(["2", "3", "5", "7"], forKey: "5") // 输出结果2
	
	// 扩展协议
	extension Comparable {
	    func precedes(other: Self) -> Bool {
	        return self < other
	    }
	}
	extension Int: Ordered {}
	extension String: Ordered {}
	let intIndex = binarySearch([2, 3, 5, 7], forKey: 5) // 输出结果2
	let stringIndex = binarySearch(["2", "3", "5", "7"], forKey: "5") // 输出结果2
```

从上面的代码我们可以看出，协议可扩展所带来的功能之一就是能够为协议中的方法提供默认实现。