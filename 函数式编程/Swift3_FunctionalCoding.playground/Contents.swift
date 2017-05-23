//: Playground - noun: a place where people can play

import UIKit

// 1.reduce
var oneToHundred: [Int] = []
for i in 1...100 {
    oneToHundred.append(i)
}

var count = oneToHundred.reduce(0) { return $0 + $1 }
debugPrint(count)
count = oneToHundred.reduce(0, { (result, i) -> Int in
    return result + i
})
debugPrint(count)

// 2.map
var oldArray = [10,20,45,32]
var newArray = oldArray.map({money in "￥\(money)"})
newArray = oldArray.map{"$\($0)"}
debugPrint(newArray) // [￥10, ￥20, ￥45, ￥32]


// 3. filter
var oldArray1 = [10,20,45,32]
var filteredArray  = oldArray1.filter({
    return $0 > 30
})
debugPrint(filteredArray) // [45, 32]

// 4. flatMap

let possibleNumbers = ["1", "2", "three", "///4///", "5"]

let mapped: [Int?] = possibleNumbers.map { str in Int(str) }
debugPrint(mapped)
// [1, 2, nil, nil, 5]

func addOne(origin: Int) -> Int {
    return 1 + origin
}

var flatMapped: [Int] = possibleNumbers.flatMap { str in Int(str) }
flatMapped = possibleNumbers.flatMap { str in
    Int(str)
}
// 完整写法
flatMapped = possibleNumbers.flatMap { str -> Int? in
    return Int(str)
}
debugPrint(flatMapped)
// flatMap(_: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult]
// 参数为一个 (_: Enlement) -> ElementOfResult? 类型的func
let addOneForFlatMapped = flatMapped.flatMap(addOne) // addOne即为(_: Int) -> Int类型的func
debugPrint(addOneForFlatMapped)
// [1, 2, 5]
