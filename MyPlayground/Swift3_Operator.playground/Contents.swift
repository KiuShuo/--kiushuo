//: Playground - noun: a place where people can play

import UIKit

// 参考资料：
// http://www.cocoachina.com/swift/20150204/11091.html
// http://ios.jobbole.com/89422/

// 运算符的重载
// 运算符重载允许你改变当前定义在类或结构体上的操作符的工作方式。

// 例如：改变+运算符在Int类型上的工作方式
func + (left: Int, right: Int) -> Int {
    return left - right
}

1 + 1

// 但是原则上不要做上面的重载操作，因为这样会影响该运算符原有的工作方式，带来不必要的麻烦。

// 通常，我们会给没有定义该操作符工作方式的类或者结构体重载该操作符，如下：

func + <Key, Value>(left: [Key: Value], right: [Key: Value]) -> [Key: Value] {
    var sum: [Key: Value] = [:]
    left.forEach { sum[$0] = $1 }
    right.forEach { sum[$0] = $1 }
    return sum
}

["xiaoHong": 18] + ["xiaoMing": 19]

// 或者，我们根本就不去重载原有的操作符，而是定义一个新的操作符，如下：
