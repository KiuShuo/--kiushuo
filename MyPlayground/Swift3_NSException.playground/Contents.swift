//: Playground - noun: a place where people can play

import UIKit

let exceptionName = NSExceptionName(rawValue: "自定义异常")
let exceptionReason = "我长得太帅了，所以程序会崩溃"
var exceptionUserInfo: [AnyHashable: Any]?
let exception: NSException = NSException(name: exceptionName, reason: exceptionReason, userInfo: exceptionUserInfo)
let aboutMe = "太帅了"
if aboutMe == "太帅了" {
    exception.raise()
} else {
    debugPrint("123")
}


