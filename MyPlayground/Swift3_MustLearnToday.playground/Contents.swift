//: Playground - noun: a place where people can play

import UIKit

struct Point {
    var x: CGFloat
    var y: CGFloat
}

extension Point {
    init(sumXY: CGFloat, x: CGFloat) {
        self.x = x
        self.y = sumXY - x
    }
}

// 1.当在原有值类型中自定义构造后，默认构造器（包括结构体的逐一类型构造器）将不能使用。
// 2. 将自定义构造期放在值类型的扩展中，将不会影响原有默认构造器的使用。

let point1 = Point(x: 1.0, y: 1.0)
debugPrint("point1 = \(point1)")

let point = Point(sumXY: 3.0, x: 1.0)
debugPrint("point0 = \(point)")
