//
//  UIButton+UI.swift
//  Swain
//
//  Created by swain on 2024/9/11.
//

import UIKit

/// UI自动刷新Key
public enum UIButtonKey: String {
    case image
    case setTitle
    case titleFont
    case setTitleColor
}

public class UIButtonUI {
    
    /// 注册UI刷新属性反射方法
    /// - Returns: 属性更新方法
    static func registerRefresh() -> [String: Any] {
        
        var reflect: [String: Any] = [:]
        
        // image
        let imageBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIImage?, let view = view as? UIButton {
                view.image(block(view), state: .normal)
            }
        }
        reflect[UIButtonKey.image.rawValue] = imageBlk
        
        // setTitle
        let setTitleBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> (String, UIControl.State), let view = view as? UIButton {
                let result = block(view)
                view.setTitle(result.0, state: result.1)
            }
        }
        reflect[UIButtonKey.setTitle.rawValue] = setTitleBlk
        
        // titleFont
        let titleFontBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIFont, let view = view as? UIButton {
                view.titleFont(block(view))
            }
        }
        reflect[UIButtonKey.titleFont.rawValue] = titleFontBlk
        
        // setTitleColor
        let setTitleColorBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIColor, let view = view as? UIButton {
                view.setTitleColor(block(view) , state: .normal)
            }
        }
        reflect[UIButtonKey.setTitleColor.rawValue] = setTitleColorBlk
        
        return reflect
    }
}
