//
//  UIControl+UI.swift
//  Swain
//
//  Created by swain on 2023/7/22.
//

import UIKit

/// UI自动刷新Key
public enum UIControlKey: String {
    case isEnabled
    case isSelected
    case isHighlighted
}

public class UIControlUI {
    
    /// 注册UI刷新属性反射方法
    /// - Returns: 属性更新方法
    static func registerRefresh() -> [String: Any] {
        
        var reflect: [String: Any] = [:]
        
        // isEnabled
        let isEnabledBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Bool, let view = view as? UIControl {
                view.isEnabled(isEnabled: block(view))
            }
        }
        reflect[UIControlKey.isEnabled.rawValue] = isEnabledBlk
        
        // isSelected
        let isSelectedBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Bool, let view = view as? UIControl {
                view.isSelected(isSelected: block(view))
            }
        }
        reflect[UIControlKey.isSelected.rawValue] = isSelectedBlk
        
        // isHighlighted
        let isHighlightedBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Bool, let view = view as? UIControl {
                view.isHighlighted(isHighlighted: block(view))
            }
        }
        reflect[UIControlKey.isHighlighted.rawValue] = isHighlightedBlk
        
        return reflect
    }
}
