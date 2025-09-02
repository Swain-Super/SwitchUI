//
//  UILabel+UI.swift
//  Swain
//
//  Created by swain on 2023/7/22.
//

import UIKit

public enum UILabelKey: String {
    case text
    case font
    case textColorA
    case textColorB
    case textAlignment
    case lineBreakMode
    case attributedText
    case highlightedTextColor
    case numberOfLines
    case adjustsFontSizeToFitWidth
    case baselineAdjustment
}

public class UILabelUI {
    
    /// 注册UI刷新属性反射方法
    /// - Returns: 属性更新方法
    static func registerRefresh() -> [String: Any] {
        
        var reflect: [String: Any] = [:]
        
        // text
        var textBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String, let view = view as? UILabel {
                let newValue = block(view)
                let oldValue = view.text
                view.text(newValue)
                
                // 标记去刷新
                if ((!view.isConstWidth || !view.isConstHeight) && oldValue != newValue) {
                    SUIManager.shared.addRefreshPool(view: view, attributeKey: UILabelKey.text.rawValue)
                }
            }
        }
        reflect[UILabelKey.text.rawValue] = textBlk
        
        // font
        var fontBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIFont?, let view = view as? UILabel {
                view.font(block(view))
            }
        }
        reflect[UILabelKey.font.rawValue] = fontBlk
        
        // textColorA
        var textColorABlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIColor, let view = view as? UILabel {
                view.textColor(block(view))
            }
        }
        reflect[UILabelKey.textColorA.rawValue] = textColorABlk
        
        // textColorB
        var textColorBBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String, let view = view as? UILabel {
                view.textColor(block(view))
            }
        }
        reflect[UILabelKey.textColorB.rawValue] = textColorBBlk
        
        // textAlignment
        var textAlignmentBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> NSTextAlignment, let view = view as? UILabel {
                view.textAlignment(block(view))
            }
        }
        reflect[UILabelKey.textAlignment.rawValue] = textAlignmentBlk
        
        // lineBreakMode
        var lineBreakModeBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> NSLineBreakMode, let view = view as? UILabel {
                view.lineBreakMode(block(view))
            }
        }
        reflect[UILabelKey.lineBreakMode.rawValue] = lineBreakModeBlk
        
        // attributedText
        var attributedTextBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> NSAttributedString?, let view = view as? UILabel {
                view.attributedText(block(view))
            }
        }
        reflect[UILabelKey.attributedText.rawValue] = attributedTextBlk
        
        // highlightedTextColor
        var highlightedTextColorBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIColor?, let view = view as? UILabel {
                view.highlightedTextColor(block(view))
            }
        }
        reflect[UILabelKey.highlightedTextColor.rawValue] = highlightedTextColorBlk
        
        // numberOfLines
        var numberOfLinesBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Int, let view = view as? UILabel {
                view.numberOfLines(block(view))
            }
        }
        reflect[UILabelKey.numberOfLines.rawValue] = numberOfLinesBlk
        
        // adjustsFontSizeToFitWidth
        var adjustsFontSizeToFitWidthBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Bool, let view = view as? UILabel {
                view.adjustsFontSizeToFitWidth(block(view))
            }
        }
        reflect[UILabelKey.adjustsFontSizeToFitWidth.rawValue] = adjustsFontSizeToFitWidthBlk
        
        // baselineAdjustment
        var baselineAdjustmentBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIBaselineAdjustment, let view = view as? UILabel {
                view.baselineAdjustment(block(view))
            }
        }
        reflect[UILabelKey.baselineAdjustment.rawValue] = baselineAdjustmentBlk
        
        return reflect
    }
}
