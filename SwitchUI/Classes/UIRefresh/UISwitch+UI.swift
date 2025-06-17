//
//  UITableView+UI.swift
//  Swain
//
//  Created by swain on 2023/7/22.
//

import UIKit

/// UI自动刷新Key
public enum UISwitchKey: String {
    case isOn
    case setTintColor
    case setOnTintColor
    case setThumbTintColor
    case setTransform
}

public class UISwitchUI {
    
    /// 注册UI刷新属性反射方法
    /// - Returns: 属性更新方法
    static func registerRefresh() -> [String: Any] {
        
        var reflect: [String: Any] = [:]
        
        // isOn
        var isOnBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Bool, let view = view as? UISwitch {
                view.setOn(block(view))
            }
        }
        reflect[UISwitchKey.isOn.rawValue] = isOnBlk
        
        // setTintColor
        let setTintColorBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIColor, let view = view as? UISwitch {
                view.setTintColor(block(view))
            }
        }
        reflect[UISwitchKey.setTintColor.rawValue] = setTintColorBlk
    
        // setOnTintColor
        let setOnTintColorBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIColor, let view = view as? UISwitch {
                view.setOnTintColor(block(view))
            }
        }
        reflect[UISwitchKey.setOnTintColor.rawValue] = setOnTintColorBlk
        
        // setThumbTintColor
        let setThumbTintColorBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIColor, let view = view as? UISwitch {
                view.setThumbTintColor(block(view))
            }
        }
        reflect[UISwitchKey.setThumbTintColor.rawValue] = setThumbTintColorBlk
        
        // setTransform
        let setTransformBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> CGAffineTransform, let view = view as? UISwitch {
                view.setTransform(block(view))
            }
        }
        reflect[UISwitchKey.setTransform.rawValue] = setTransformBlk
        
        return reflect
    }
}
