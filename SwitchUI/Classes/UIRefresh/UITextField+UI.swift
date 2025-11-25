//
//  UITextField+UI.swift
//  Swain
//
//  Created by swain on 2023/7/22.
//

import UIKit

/// UI自动刷新Key
public enum UITextFieldKey: String {
    case text
    case keyboardType
    case font
    case textColor
    case textColorB
    case textAlignment
    case attributedText
    case adjustsFontSizeToFitWidth
    case placeholder
    case attributedPlaceholder
}

public class UITextFieldUI {
    
    /// 注册UI刷新属性反射方法
    /// - Returns: 属性更新方法
    static func registerRefresh() -> [String: Any] {
        
        var reflect: [String: Any] = [:]
        
        // text
        let textBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String, let view = view as? UITextField {
                view.text(block(view))
            }
        }
        reflect[UITextFieldKey.text.rawValue] = textBlk
        
        // keyboardType
        let keyboardTypeBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIKeyboardType, let view = view as? UITextField {
                view.keyboardType(block(view))
            }
        }
        reflect[UITextFieldKey.keyboardType.rawValue] = keyboardTypeBlk
        
        // font
        let fontBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIFont?, let view = view as? UITextField {
                view.font(block(view))
            }
        }
        reflect[UITextFieldKey.font.rawValue] = fontBlk
        
        // textColor
        let textColorBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIColor, let view = view as? UITextField {
                view.textColor(block(view))
            }
        }
        reflect[UITextFieldKey.textColor.rawValue] = textColorBlk
        
        // textColorB
        let textColorBBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String, let view = view as? UITextField {
                view.textColor(block(view))
            }
        }
        reflect[UITextFieldKey.textColorB.rawValue] = textColorBBlk
        
        // textAlignment
        let textAlignmentBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> NSTextAlignment, let view = view as? UITextField {
                view.textAlignment(block(view))
            }
        }
        reflect[UITextFieldKey.textAlignment.rawValue] = textAlignmentBlk
        
        // attributedText
        let attributedTextBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> NSAttributedString?, let view = view as? UITextField {
                view.attributedText(block(view))
            }
        }
        reflect[UITextFieldKey.attributedText.rawValue] = attributedTextBlk
        
        // adjustsFontSizeToFitWidth
        let adjustsFontSizeToFitWidthBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Bool, let view = view as? UITextField {
                view.adjustsFontSizeToFitWidth(block(view))
            }
        }
        reflect[UITextFieldKey.adjustsFontSizeToFitWidth.rawValue] = adjustsFontSizeToFitWidthBlk
        
        // placeholder
        let placeholderBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String, let view = view as? UITextField {
                view.placeholder(block(view))
            }
        }
        reflect[UITextFieldKey.placeholder.rawValue] = placeholderBlk
        
        // attributedPlaceholder
        let attributedPlaceholderBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> NSAttributedString, let view = view as? UITextField {
                view.attributedPlaceholder(block(view))
            }
        }
        reflect[UITextFieldKey.attributedPlaceholder.rawValue] = attributedPlaceholderBlk
        
        return reflect
    }
}
