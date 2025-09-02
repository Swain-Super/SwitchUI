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
    /// 真Block
    var trueBlock: [UIView]?
    /// 假Block
    var falseBlock: [UIView]?
    
    public init(condition: Bool, trueBlock: [UIView]?, falseBlock: [UIView]?) {
        super.init()
        
        self.condition = condition
        self.trueBlock = trueBlock
        self.falseBlock = falseBlock
    }
    
}
