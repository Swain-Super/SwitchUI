//
//  UIView+UI.swift
//  Swain
//
//  Created by swain on 2023/7/22.
//

import UIKit

/// UI自动刷新Key
public enum UIViewAKey: String {
    case backgroundColorA
    case backgroundColorB
    case cornerRadius
    case borderColorA
    case borderColorB
    case borderWidth
    case alpha
    case clipsToBounds
    case maskToBounds
    case shadowOpacity
    case shadowRadius
    case shadowColorA
    case shadowColorB
    case shadowOffset
    case isUserInteractionEnabled
    case tag
    case contentMode
    case visible
    case s_widthA
    case s_widthB
    case s_heightA
    case s_heightB
    case s_leftA
    case s_leftB
    case s_topA
    case s_topB
    case s_rightA
    case s_rightB
    case s_bottomA
    case s_bottomB
    case s_centerXA
    case s_centerXB
    case s_centerYA
    case s_centerYB
    case s_positionA
    case s_positionB
    case s_alignRules
}

public class UIViewUI {
    
    /// 注册UI刷新属性反射方法
    /// - Returns: 属性更新方法
    static func registerRefresh() -> [String: Any] {
        
        var reflect: [String: Any] = [:]
        
        // backgroundColorA
        let backgroundColorABlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIColor {
                view.backgroundColor(block(view))
            }
        }
        reflect[UIViewAKey.backgroundColorA.rawValue] = backgroundColorABlk
        
        // backgroundColorB
        let backgroundColorBBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String {
                view.backgroundColor(block(view).hexColor())
            }
        }
        reflect[UIViewAKey.backgroundColorB.rawValue] = backgroundColorBBlk
        
        // cornerRadius
        let cornerRadiusBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> CGFloat {
                view.cornerRadius(block(view))
            }
        }
        reflect[UIViewAKey.cornerRadius.rawValue] = cornerRadiusBlk
        
        // borderColorA
        let borderColorABlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIColor {
                view.borderColor(block(view))
            }
        }
        reflect[UIViewAKey.borderColorA.rawValue] = borderColorABlk
        
        // borderColorB
        let borderColorBBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String {
                view.borderColor(block(view).hexColor())
            }
        }
        reflect[UIViewAKey.borderColorB.rawValue] = borderColorBBlk

        
        // borderWidth
        let borderWidthBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> CGFloat {
                view.borderWidth(block(view))
            }
        }
        reflect[UIViewAKey.borderWidth.rawValue] = borderWidthBlk
        
        // alpha
        let alphaBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> CGFloat {
                view.alpha(block(view))
            }
        }
        reflect[UIViewAKey.alpha.rawValue] = alphaBlk
        
        // clipsToBounds
        let clipsToBoundsBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Bool {
                view.clipsToBounds(block(view))
            }
        }
        reflect[UIViewAKey.clipsToBounds.rawValue] = clipsToBoundsBlk
        
        // maskToBounds
        let maskToBoundsBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Bool {
                view.maskToBounds(block(view))
            }
        }
        reflect[UIViewAKey.maskToBounds.rawValue] = maskToBoundsBlk
        
        // shadowOpacity
        let shadowOpacityBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Float {
                view.shadowOpacity(block(view))
            }
        }
        reflect[UIViewAKey.shadowOpacity.rawValue] = shadowOpacityBlk
        
        // shadowRadius
        let shadowRadiusBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> CGFloat {
                view.shadowRadius(block(view))
            }
        }
        reflect[UIViewAKey.shadowRadius.rawValue] = shadowRadiusBlk
        
        // shadowColorA
        let shadowColorABlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIColor {
                view.shadowColor(block(view))
            }
        }
        reflect[UIViewAKey.shadowColorA.rawValue] = shadowColorABlk
        
        // shadowColorB
        let shadowColorBBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String {
                view.shadowColor(block(view))
            }
        }
        reflect[UIViewAKey.shadowColorB.rawValue] = shadowColorBBlk
        
        // shadowOffset
        let shadowOffsetBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> CGSize {
                view.shadowOffset(block(view))
            }
        }
        reflect[UIViewAKey.shadowOffset.rawValue] = shadowOffsetBlk
        
        // isUserInteractionEnabled
        let isUserInteractionEnabledBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Bool {
                view.isUserInteractionEnabled(block(view))
            }
        }
        reflect[UIViewAKey.isUserInteractionEnabled.rawValue] = isUserInteractionEnabledBlk
        
        // tag
        let tagBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Int {
                view.tag(block(view))
            }
        }
        reflect[UIViewAKey.tag.rawValue] = tagBlk
        
        // contentMode
        let contentModeBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIView.ContentMode {
                view.contentMode(block(view))
            }
        }
        reflect[UIViewAKey.contentMode.rawValue] = contentModeBlk
        
        // visible
        let visibleBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Bool {
                view.visible(block(view))
            }
        }
        reflect[UIViewAKey.visible.rawValue] = visibleBlk
        
        // s_widthA
        let s_widthABlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String {
                
                var oldValue = view.sWidth
                view.width(block(view))
                var newValue = view.sWidth
                
                if oldValue != newValue {
                    SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_widthA.rawValue)
                }
            }
        }
        reflect[UIViewAKey.s_widthA.rawValue] = s_widthABlk
        
        // s_widthB
        let s_widthBBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Float {
                var oldValue = view.sWidth
                view.width(block(view))
                var newValue = view.sWidth
                
                if oldValue != newValue {
                    SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_widthB.rawValue)
                }
            }
        }
        reflect[UIViewAKey.s_widthB.rawValue] = s_widthBBlk
        
        // s_heightA
        let s_heightABlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String {
                var oldValue = view.sHeight
                view.height(block(view))
                var newValue = view.sHeight
                
                if oldValue != newValue {
                    SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_heightA.rawValue)
                }
            }
        }
        reflect[UIViewAKey.s_heightA.rawValue] = s_heightABlk
        
        // s_heightB
        let s_heightBBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Float {
                var oldValue = view.sHeight
                view.height(block(view))
                var newValue = view.sHeight
                
                if oldValue != newValue {
                    SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_heightB.rawValue)
                }
            }
        }
        reflect[UIViewAKey.s_heightB.rawValue] = s_heightBBlk
        
        // s_leftA
        let s_leftABlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String {
                var oldValue = view.sLeft
                view.left(block(view))
                var newValue = view.sLeft
                
                if oldValue != newValue {
                    SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_leftA.rawValue)
                }
            }
        }
        reflect[UIViewAKey.s_leftA.rawValue] = s_leftABlk
        
        // s_leftB
        let s_leftBBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Float {
                var oldValue = view.sLeft
                view.left(block(view))
                var newValue = view.sLeft
                
                if oldValue != newValue {
                    SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_leftB.rawValue)
                }
            }
        }
        reflect[UIViewAKey.s_leftB.rawValue] = s_leftBBlk
        
        // s_topA
        let s_topABlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String {
                var oldValue = view.sTop
                view.top(block(view))
                var newValue = view.sTop
                
                if oldValue != newValue {
                    SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_topA.rawValue)
                }
            }
        }
        reflect[UIViewAKey.s_topA.rawValue] = s_topABlk
        
        // s_topB
        let s_topBBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Float {
                var oldValue = view.sTop
                view.top(block(view))
                var newValue = view.sTop
                
                if oldValue != newValue {
                    SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_topB.rawValue)
                }
            }
        }
        reflect[UIViewAKey.s_topB.rawValue] = s_topBBlk
        
        // s_rightA
        let s_rightABlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String {
                var oldValue = view.sRight
                view.right(block(view))
                var newValue = view.sRight
                
                if oldValue != newValue {
                    SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_rightA.rawValue)
                }
            }
        }
        reflect[UIViewAKey.s_rightA.rawValue] = s_rightABlk
        
        // s_rightB
        let s_rightBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Float {
                var oldValue = view.sRight
                view.right(block(view))
                var newValue = view.sRight
                
                if oldValue != newValue {
                    SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_rightB.rawValue)
                }
            }
        }
        reflect[UIViewAKey.s_rightB.rawValue] = s_rightBlk
        
        // s_bottomA
        let s_bottomABlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String {
                var oldValue = view.sBottom
                view.bottom(block(view))
                var newValue = view.sBottom
                
                if oldValue != newValue {
                    SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_bottomA.rawValue)
                }
            }
        }
        reflect[UIViewAKey.s_bottomA.rawValue] = s_bottomABlk
        
        // s_bottomB
        let s_bottomBBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Float {
                var oldValue = view.sBottom
                view.bottom(block(view))
                var newValue = view.sBottom
                
                if oldValue != newValue {
                    SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_bottomB.rawValue)
                }
            }
        }
        reflect[UIViewAKey.s_bottomB.rawValue] = s_bottomBBlk
        
        // s_centerXA
        let s_centerXABlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String {
                var oldValue = view.sCenterX
                view.centerX(block(view))
                var newValue = view.sCenterX
                
                if oldValue != newValue {
                    SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_centerXA.rawValue)
                }
            }
        }
        reflect[UIViewAKey.s_centerXA.rawValue] = s_centerXABlk
        
        // s_centerXB
        let s_centerXBBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Float {
                var oldValue = view.sCenterX
                view.centerX(block(view))
                var newValue = view.sCenterX
                
                if oldValue != newValue {
                    SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_centerXB.rawValue)
                }
            }
        }
        reflect[UIViewAKey.s_centerXB.rawValue] = s_centerXBBlk
        
        // s_centerYA
        let s_centerYABlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String {
                var oldValue = view.sCenterY
                view.centerY(block(view))
                var newValue = view.sCenterY
                
                if oldValue != newValue {
                    SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_centerXA.rawValue)
                }
            }
        }
        reflect[UIViewAKey.s_centerXA.rawValue] = s_centerYABlk
        
        // s_centerYB
        let s_centerYBBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> Float {
                var oldValue = view.sCenterY
                view.centerY(block(view))
                var newValue = view.sCenterY
                
                if oldValue != newValue {
                    SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_centerYB.rawValue)
                }
            }
        }
        reflect[UIViewAKey.s_centerYB.rawValue] = s_centerYBBlk
        
        // s_positionA
        let s_positionABlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> [SWPositionType: String]? {
                view.position(block(view))
                
                SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_positionA.rawValue)
            }
        }
        reflect[UIViewAKey.s_positionA.rawValue] = s_positionABlk
        
        // s_positionB
        let s_positionBBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> [SWPositionType: Float]? {
                view.position(block(view))
                
                SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_positionB.rawValue)
            }
        }
        reflect[UIViewAKey.s_positionB.rawValue] = s_positionBBlk
        
        // s_alignRules
        let s_alignRulesBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> [SWPositionType: [String: Any]]? {
                view.alignRules(block(view))
                
                SUIManager.shared.addRefreshPool(view: view, attributeKey: UIViewAKey.s_alignRules.rawValue)
            }
        }
        reflect[UIViewAKey.s_alignRules.rawValue] = s_alignRulesBlk
        
        return reflect
    }
}
