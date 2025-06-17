//
//  UISwitch+swchain.swift
//  Swain
//
//  Created by swain on 2023/7/26.
//

import Foundation
import UIKit

public extension UISwitch {
    
    // 设置开关
    @discardableResult
    func setOn(_ isOn: Bool) -> Self {
        self.isOn = isOn
        return self
    }
    
    @discardableResult
    func setOn(_ block: @escaping (UIView) -> Bool,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UISwitchKey.isOn.rawValue, block: block, states: states)
        return self
    }
    
    // 设置默认颜色
    @discardableResult
    func setTintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    @discardableResult
    func setTintColor(_ block: @escaping (UIView) -> UIColor,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UISwitchKey.setTintColor.rawValue, block: block, states: states)
        return self
    }
    
    // 设置选中颜色
    @discardableResult
    func setOnTintColor(_ color: UIColor) -> Self {
        self.onTintColor = color
        return self
    }
    
    @discardableResult
    func setOnTintColor(_ block: @escaping (UIView) -> UIColor,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UISwitchKey.setOnTintColor.rawValue, block: block, states: states)
        return self
    }
    
    @discardableResult
    func setThumbTintColor(_ color: UIColor) -> Self {
        self.thumbTintColor = color
        return self
    }
    
    @discardableResult
    func setThumbTintColor(_ block: @escaping (UIView) -> UIColor,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UISwitchKey.setThumbTintColor.rawValue, block: block, states: states)
        return self
    }
    
    @discardableResult
    func setTransform(_ transform: CGAffineTransform) -> Self {
        self.transform = transform
        return self
    }
    
    @discardableResult
    func setTransform(_ block: @escaping (UIView) -> CGAffineTransform,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UISwitchKey.setTransform.rawValue, block: block, states: states)
        return self
    }
}
