//
//  UIStackView+UI.swift
//  Swain
//
//  Created by swain on 2024/9/11.
//

import UIKit

/// UI自动刷新Key
public enum UIStackViewKey: String {
    case axis
    case alignment
    case spacing
    case distribution
    case arrangedViews
}

public class UIStackViewUI {
    
    /// 注册UI刷新属性反射方法
    /// - Returns: 属性更新方法
    static func registerRefresh() -> [String: Any] {
        
        var reflect: [String: Any] = [:]
        
        // axis
        let axisBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> NSLayoutConstraint.Axis, let view = view as? UIStackView {
                view.axis(block(view))
            }
        }
        reflect[UIStackViewKey.axis.rawValue] = axisBlk
        
        // alignment
        let alignmentBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIStackView.Alignment, let view = view as? UIStackView {
                view.alignment(block(view))
            }
        }
        reflect[UIStackViewKey.alignment.rawValue] = alignmentBlk
        
        // spacing
        let spacingBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> CGFloat, let view = view as? UIStackView {
                view.spacing(block(view))
            }
        }
        reflect[UIStackViewKey.spacing.rawValue] = spacingBlk
        
        // distribution
        let distributionBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIStackView.Distribution, let view = view as? UIStackView {
                view.distribution(block(view))
            }
        }
        reflect[UIStackViewKey.distribution.rawValue] = distributionBlk
        
        // arrangedViews
        let arrangedViewsBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> [UIView], let view = view as? UIStackView {
                view.arrangedViews(block(view))
            }
        }
        reflect[UIStackViewKey.arrangedViews.rawValue] = arrangedViewsBlk
        
        return reflect
    }
}
