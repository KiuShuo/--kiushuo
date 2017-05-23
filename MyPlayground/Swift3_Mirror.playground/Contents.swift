//: Playground - noun: a place where people can play

import UIKit

// Mirror 反射


/*
 /// Mirrors are used by playgrounds and the debugger.
 Mirror用于playground和调试器. 所以最好不要在正式的App中使用Mirror，以免苹果在未来某一天抛弃或做大的修改。
 
 目前来说，Mirror只能用来对属性进行读取，并不能对其设定。
 
 参考文章： http://www.jianshu.com/p/2a7176f3f879
          http://swifter.tips/reflect/

 */

let hello = "hello playground!"
let helloMirror = Mirror(reflecting: hello)
print(helloMirror.displayStyle) // 被反射对应的类型 nil
print(helloMirror.subjectType) // 被反射对象的静态类型 String
print(helloMirror.children.count)

struct Person {
    let name: String
    let age: Int
}

let xiaoMing = Person(name: "XiaoMing", age: 16)
let r = Mirror(reflecting: xiaoMing) // r 是 MirrorType

print(r.superclassMirror) // 获取父类的mirror 很显然结构体不能继承，没有父类，所以为nil
print("xiaoMing 是 \(r.displayStyle!)") // Struct
print(r.subjectType) // Person
print("属性个数:\(r.children.count)")

dump(xiaoMing)

r.children.forEach { (child) in
    print("\(String(describing: child.label)): \(child.value)")
}

