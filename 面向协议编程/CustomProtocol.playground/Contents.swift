//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

protocol AProtocol {
    func someOne() -> String
}

struct A {
    
    func doSomething() {
        let per = AProtocol().someOne()
        debugPrint("\(per)doSomething")
    }
    
   // private func someOne() -> String {
   //     debugPrint("needSomething")
            //return "xiaoMing"
    //}
    
}

let a = A()
a.doSomething()