//
//  SIF.swift
//
//
//  Created by swain wang on 2025/8/21.
//

import Foundation
import UIKit

/// 条件包装类
public class SIF: NSObject  {
    
    /// 条件结果
    var condition: Bool = false
    /// trueStyle
    var trueStyle: [UIView]?
    /// falseStyle
    var falseStyle: [UIView]?
    /// true Block
    var trueBlock: (() -> [UIView]?)?
    /// false Block
    var falseBlock: (() -> [UIView]?)?
    
    public init(condition: Bool, trueStyle: [UIView]?, falseStyle: [UIView]?) {
        super.init()
        
        self.condition = condition
        self.trueStyle = trueStyle
        self.falseStyle = falseStyle
    }
    
    public init(condition: Bool, trueBlock: (() -> [UIView]?)?, falseBlock: (() -> [UIView]?)?) {
        super.init()
        
        self.condition = condition
        self.trueBlock = trueBlock
        self.falseBlock = falseBlock
    }
    
    public func getTrueStyle() -> [UIView]? {
        if let trueBlock {
            return trueBlock()
        }
        return trueStyle
    }
    
    public func getFalseStyle() -> [UIView]? {
        if let falseBlock {
            return falseBlock()
        }
        return falseStyle
    }
}
