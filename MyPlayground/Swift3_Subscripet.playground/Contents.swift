//: Playground - noun: a place where people can play

import UIKit

// Subscript 下标
// 下标可以定义在类、结构体、枚举中。是访问集合、列表或序列中元素的快捷方式。
// 一个类型可以有多个下标，下标可以是多维的。使用下标时通过入参的数量和类型进行区分，自动匹配合适的下标，这就是下标的重载。
// 下标可以接受任意数量的入参，并且这些入参可以是任意类型。下标的返回值也可以是任意类型。
// 下标可以使用变量参数和可变参数，但是不能使用输入输出参数，也不能给参数设置默认值。

struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = [Double](repeating: 0.0, count: rows * columns)
    }
    func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValidForRow(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValidForRow(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
    
    subscript(index: Int) -> Double {
        return grid[index]
    }
    
}

var matrix = Matrix(rows: 2, columns: 2)
matrix[0, 0] = 1.0
matrix[1, 1] = 1.0
matrix.grid
matrix[0]


