//
//  SForEach.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/7/16.
//

import Foundation

public class SForEach: NSObject {
    
    public var list: [Any]?
    
    public var itemIterate: ((Any, Int) -> UIView)?
    
    /// 初始化容器
    /// - Parameter block: 闭包构造
    public convenience init(list: [Any], _ itemIterate: ((Any, Int) -> UIView)?) {
        self.init()
        
        self.list = list
        self.itemIterate = itemIterate
    }
    
    @discardableResult
    public func callSelf<T>(_ object: AutoreleasingUnsafeMutablePointer<T?>) -> Self {
        object.pointee = self as? T
        return self
    }
}
