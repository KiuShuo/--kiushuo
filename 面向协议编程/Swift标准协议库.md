### 标准协议库

参考资料：  
[我从55个Swift标准库协议中学到了什么？](http://www.cocoachina.com/swift/20160107/14868.html)

1. **`RawRepresentabel`**  
   服从该协议的类型，都可以由关联类转变回的原有的类型。  
   使用符合类型的原始值可简化与Objective-C和传统API的互操作，并简化与其他协议（如Equatable，Comparable和Hashable）的一致性。  
   RawRepresentable协议主要分为两类类型：具有原始值类型和选项集的枚举。
   
   ```
   public protocol RawRepresentable {
        associatedtype RawValue  // 关联类型
        // 以关联类型RawValue作为参数的构造器函数
        public init?(rawValue: Self.RawValue)
        // 获取相应的关联类型RawValue的值
        public var rawValue: Self.RawValue { get }
    }
   ```
    eg:
    
    ```
    // 默认实现RawRepresentable协议
    // 在不影响原有enum类型的同时实现了与关联类型String之间的相互转换
    enum Sex: String  { // typealias RawValue = String
        case man = "1"
        case woMan = "0"
    }
    // 使用rawValue可以直接使用Equatable协议 进行比较
    Sex.man.rawValue == "1" // true
    Sex(rawValue: "0") // woMan
    ```
    
