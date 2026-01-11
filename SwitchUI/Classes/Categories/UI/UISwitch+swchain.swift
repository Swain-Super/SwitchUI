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
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UISwitchKey.isOn.rawValue, block: block, states: states)
        } else {
            self.setOn(block(self))
        }
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
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UISwitchKey.setTintColor.rawValue, block: block, states: states)
        } else {
            self.tintColor = block(self)
        }
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
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UISwitchKey.setOnTintColor.rawValue, block: block, states: states)
        } else {
            self.setOnTintColor(block(self))
        }
        return self
    }
    
    @discardableResult
    func setThumbTintColor(_ color: UIColor) -> Self {
        self.thumbTintColor = color
        return self
    }
    
    @discardableResult
    func setThumbTintColor(_ block: @escaping (UIView) -> UIColor,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UISwitchKey.setThumbTintColor.rawValue, block: block, states: states)
        } else {
            self.setThumbTintColor(block(self))
        }
        return self
    }
    
    @discardableResult
    func setTransform(_ transform: CGAffineTransform) -> Self {
        self.transform = transform
        return self
    }
    
    @discardableResult
    func setTransform(_ block: @escaping (UIView) -> CGAffineTransform,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UISwitchKey.setTransform.rawValue, block: block, states: states)
        } else {
            self.setTransform(block(self))
        }
        return self
    }

    /// 添加切换变化事件回调
    @discardableResult
    func onValueChanged(_ action: @escaping (UISwitch) -> Void) -> Self {
        self.addTarget(ClosureSleeve(action: action), action: #selector(ClosureSleeve.invoke(_:)), for: .valueChanged)
        return self
    }
    
private class ClosureSleeve {
    let action: (UISwitch) -> Void
    
    init(action: @escaping (UISwitch) -> Void) {
        self.action = action
    }
    
    @objc func invoke(_ sender: UISwitch) {
        action(sender)
    }
}
}
