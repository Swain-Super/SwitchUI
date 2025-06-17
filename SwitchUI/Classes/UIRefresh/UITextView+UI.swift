//
//  UITextView+UI.swift
//  Swain
//
//  Created by swain on 2023/7/22.
//

import UIKit

/// UI自动刷新Key
public enum UITextViewAKey: String {
    case text
    case keyboardType
    case font
    case textColor
    case textAlignment
    case attributedText
    case isEditable
    case isSelectable
    case textContainerInset
}

public class UITextViewUI {
    
    /// 注册UI刷新属性反射方法
    /// - Returns: 属性更新方法
    static func registerRefresh() -> [String: Any] {
        
        var reflect: [String: Any] = [:]
        
        // text
        let textBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String, let view = view as? UITextView {
                view.text(block(view))
            }
        }
        reflect[UITextViewAKey.text.rawValue] = textBlk
        
        // keyboardType
        let keyboardTypeBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIKeyboardType, let view = view as? UITextView {
                view.keyboardType(block(view))
            }
        }
        reflect[UITextViewAKey.keyboardType.rawValue] = keyboardTypeBlk
        
        // font
        let fontBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIFont, let view = view as? UITextView {
                view.font(block(view))
            }
        }
        reflect[UITextViewAKey.font.rawValue] = fontBlk
        
        // textColor
        let textColorBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIColor, let view = view as? UITextView {
                view.textColor(block(view))
            }
        }
        reflect[UITextViewAKey.textColor.rawValue] = textColorBlk
        
        // textAlignment
        let textAlignmentBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> NSTextAlignment, let view = view as? UITextView {
                view.textAlignment(block(view))
            }
        }
        reflect[UITextViewAKey.textAlignment.rawValue] = textAlignmentBlk
        
        // attributedText
        let attributedTextBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> NSAttributedString?, let view = view as? UITextView {
                view.attributedText(block(view))
            }
        }
        reflect[UITextViewAKey.attributedText.rawValue] = attributedTextBlk
        
        
        // isEditable
        let isEditableBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Bool, let view = view as? UITextView {
                view.isEditable(block(view))
            }
        }
        reflect[UITextViewAKey.isEditable.rawValue] = isEditableBlk
        
        // isSelectable
        let isSelectableBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Bool, let view = view as? UITextView {
                view.isSelectable(block(view))
            }
        }
        reflect[UITextViewAKey.isSelectable.rawValue] = isSelectableBlk
        
        // textContainerInset
        let textContainerInsetBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIEdgeInsets, let view = view as? UITextView {
                view.textContainerInset(block(view))
            }
        }
        reflect[UITextViewAKey.textContainerInset.rawValue] = textContainerInsetBlk
        
        return reflect
    }
}
