//: Playground - noun: a place where people can play

import UIKit


protocol Pizzeria {
    
    func makePizza(_ ingredients: [String])
    func makeBigPizza()
    
}

extension Pizzeria {
    
    // 为协议中的函数提供默认实现
    func makeBigPizza() {
        return makePizza(["big pizza"])
    }
    // ！！！直接扩展一个函数 并实现
    func makeMargherita() {
        return makePizza(["tomato", "mozzarella"])
    }
    
}

struct Lombardis: Pizzeria {
    
    var name: String?
    
    // 实现协议中的函数
    func makePizza(_ ingredients: [String]) {
        print(ingredients)
    }
    
    func makeBigPizza() {
        return makePizza(["lalal"])
    }
    
    func makeMargherita() {
        return makePizza(["tomato", "basil", "mozzarella"])
    }
    
}

let lombardis1: Pizzeria = Lombardis()
let lombardis2: Lombardis = Lombardis()

lombardis1.makeBigPizza() // 调用的是Lombardis中实现的函数
lombardis2.makeBigPizza() // 调用的是Lombardis中实现的函数

lombardis1.makeMargherita() // ！！！调用的是扩展中的函数
lombardis2.makeMargherita() // 调用的是Lombardis中实现的函数


