//: Playground - noun: a place where people can play

import UIKit

// 1. RawRepresentable

// 默认实现RawRepresentable协议
enum Sex: String  { // typealias RawValue = String
    case man = "1"
    case woMan = "0"
}
// 使用rawValue可以直接使用Equatable协议
Sex.man.rawValue == "1"

Sex(rawValue: "0")





