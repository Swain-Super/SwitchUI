//
//  Marco.swift
//  MovieDisplay
//
//  Created by Swain on 2017/9/12.
//  Copyright © 2017年 gh. All rights reserved.
//

import UIKit
import Foundation

/// 屏幕适配工具
public class SScreenAdapter: NSObject {
    
    /// 屏幕的宽度，因为是`let`，不会随着横竖屏改变，大多数情况下，是可以直接使用此常量
    static let sPortraitScreenWidth = UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height ? UIScreen.main.bounds.size.width : UIScreen.main.bounds.size.height
    /// 屏幕的高度，因为是`let`，不会随着横竖屏改变，大多数情况下，是可以直接使用此常量
    static let sPortraitScreenHeight = UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width
    
    static public let iPad = (UIDevice().userInterfaceIdiom == UIUserInterfaceIdiom.pad)
    
    /** 宽缩放比例 */
    static public var ScaleW: Double { sPortraitScreenWidth/375.0 }
    /** 高缩放比例 */
    static public var ScaleH: Double { sPortraitScreenHeight/667.0 }

    /** Pad宽缩放比例 */
    static public var ScalePW: Double { sPortraitScreenWidth/768.0 }
    /** Pad高缩放比例 */
    static public var ScalePH: Double { sPortraitScreenHeight/1024.0 }

    /// 宽度比例
    static let ScaleWidth = iPad ? ScalePW : ScaleW
    /// 高度比例
    static let ScaleHeight = iPad ? ScalePH : ScaleH
    
    /// 基于宽为比例修改所有view及子view尺寸
    public static func resizeWidthScale(view: UIView, isLandscape: Bool = false) {
        
        resize(view: view, scale: (isLandscape ? ScaleHeight : ScaleWidth))
        
        view.subviews.forEach { subview in
            if !subview.sShouldSkipResize {
                resizeWidthScale(view: subview, isLandscape: isLandscape)
            }
        }
    }
    
    /// 始终基于宽为比例修改所有view及子view尺寸
    public static func resizeWidthScale(view: UIView) {
        resize(view: view, scale: ScaleWidth)
        view.subviews.forEach { subview in
            if !subview.sShouldSkipResize {
                resizeWidthScale(view: subview, isLandscape: false)
            }
        }
    }

    /// 基于宽为比例适配所有view
    public static func resizeWidthScale(views: [UIView]) {
        views.map {
            resizeWidthScale(view: $0)
        }
    }
    
    /// 基于高为比例修改所有view及子view尺寸
    public static func resizeHeightScale(view: UIView, isLandscape: Bool = false) {
        
        resize(view: view, scale: (isLandscape ? ScaleWidth : ScaleHeight))
        
        view.subviews.forEach { subview in
            if !subview.sShouldSkipResize {
                resizeHeightScale(view: subview, isLandscape: isLandscape)
            }
        }
    }
    
    /// 始终基于高为比例修改所有view及子view尺寸
    public static func resizeHeightScale(view: UIView) {
        resize(view: view, scale: ScaleHeight)
        view.subviews.forEach { subview in
            if !subview.sShouldSkipResize {
                resizeHeightScale(view: subview, isLandscape: false)
            }
        }
    }

    /// 基于高为比例适配所有view
    public static func resizeHeightScale(views: [UIView]) {
        views.map {
            resizeHeightScale(view: $0)
        }
    }
    
    /// 重置缩放标记
    public static func resizedReset(view: UIView) {
        view.sIsResized = false
        view.subviews.forEach { subview in
            resizedReset(view: subview)
        }
    }
    
    /// view 尺寸成
    /// - Parameters:
    ///   - view: 控件
    ///   - scale: 称号
    public static func resize(view: UIView, scale : Double) {
        
        // 如果view标记为跳过缩放，直接返回
        if view.sShouldSkipResize {
            return
        }
        
        // 如果是第一次缩放，保存原始值
        if !view.sIsResized {
            view.sOriginalFrame = view.frame
            view.sOriginalCornerRadius = view.layer.cornerRadius
            
            // 保存字体原始大小
            if let label = view as? UILabel {
                if let attributedText = label.attributedText, attributedText.length > 0 {
                    // 优先从 attributedString 获取字体
                    if let font = attributedText.attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
                        view.sOriginalFontSize = font.pointSize
                    }
                } else if let font = label.font {
                    view.sOriginalFontSize = font.pointSize
                }
            } else if let textField = view as? UITextField {
                if let attributedText = textField.attributedText, attributedText.length > 0 {
                    // 优先从 attributedString 获取字体
                    if let font = attributedText.attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
                        view.sOriginalFontSize = font.pointSize
                    }
                } else if let font = textField.font {
                    view.sOriginalFontSize = font.pointSize
                }
            } else if let textView = view as? UITextView {
                if let attributedText = textView.attributedText, attributedText.length > 0 {
                    // 优先从 attributedString 获取字体
                    if let font = attributedText.attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
                        view.sOriginalFontSize = font.pointSize
                    }
                } else if let font = textView.font {
                    view.sOriginalFontSize = font.pointSize
                }
            }
            
            view.sIsResized = true
        }
        
        // 基于原始值进行缩放
        guard let originalFrame = view.sOriginalFrame else {
            return
        }
        
        let newFrame = CGRect(
            x: originalFrame.origin.x * scale,
            y: originalFrame.origin.y * scale,
            width: originalFrame.size.width * scale,
            height: originalFrame.size.height * scale
        )
        view.frame = newFrame
        
        // 缩放字体
        if let originalFontSize = view.sOriginalFontSize {
            let newFontSize = originalFontSize * scale
            
            if let label = view as? UILabel {
                if let attributedText = label.attributedText, attributedText.length > 0 {
                    // 缩放 attributedString 的字体
                    let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
                    mutableAttributedText.enumerateAttribute(.font, in: NSRange(location: 0, length: mutableAttributedText.length), options: []) { value, range, _ in
                        if let oldFont = value as? UIFont {
                            let newFont = UIFont.init(name: oldFont.fontName, size: newFontSize)
                            mutableAttributedText.addAttribute(.font, value: newFont, range: range)
                        }
                    }
                    label.attributedText = mutableAttributedText
                } else if let font = label.font {
                    label.font = UIFont(name: font.fontName, size: newFontSize)
                }
            } else if let textField = view as? UITextField {
                if let attributedText = textField.attributedText, attributedText.length > 0 {
                    // 缩放 attributedString 的字体
                    let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
                    mutableAttributedText.enumerateAttribute(.font, in: NSRange(location: 0, length: mutableAttributedText.length), options: []) { value, range, _ in
                        if let oldFont = value as? UIFont {
                            let newFont = UIFont.init(name: oldFont.fontName, size: newFontSize)
                            mutableAttributedText.addAttribute(.font, value: newFont, range: range)
                        }
                    }
                    textField.attributedText = mutableAttributedText
                } else if let font = textField.font {
                    textField.font = UIFont(name: font.fontName, size: newFontSize)
                }
            } else if let textView = view as? UITextView {
                if let attributedText = textView.attributedText, attributedText.length > 0 {
                    // 缩放 attributedString 的字体
                    let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
                    mutableAttributedText.enumerateAttribute(.font, in: NSRange(location: 0, length: mutableAttributedText.length), options: []) { value, range, _ in
                        if let oldFont = value as? UIFont {
                            let newFont = UIFont.init(name: oldFont.fontName, size: newFontSize)
                            mutableAttributedText.addAttribute(.font, value: newFont, range: range)
                        }
                    }
                    textView.attributedText = mutableAttributedText
                } else if let font = textView.font {
                    textView.font = UIFont(name: font.fontName, size: newFontSize)
                }
            }
        }
        
        // 缩放圆角
        if let originalCornerRadius = view.sOriginalCornerRadius {
            view.layer.cornerRadius = originalCornerRadius * scale
        }
    }
    
    /// 重置view的缩放状态，清除保存的原始值
    /// - Parameter view: 要重置的view
    public static func resetResizeState(view: UIView) {
        view.sOriginalFrame = nil
        view.sOriginalFontSize = nil
        view.sOriginalCornerRadius = nil
        view.sIsResized = false
    }
    
    /// 重置view及其子view的缩放状态
    /// - Parameter view: 要重置的view
    public static func resetResizeStateRecursive(view: UIView) {
        resetResizeState(view: view)
        view.subviews.forEach { subview in
            resetResizeStateRecursive(view: subview)
        }
    }
}

// MARK: - 关联对象Key
private struct sAssociatedKeys {
    static var originalFrame = "originalFrame"
    static var originalFontSize = "originalFontSize"
    static var originalCornerRadius = "originalCornerRadius"
    // 是否跳过缩放
    static var shouldSkipResize = "shouldSkipResize"
    // 是否已经缩放过
    static var isResized = "isResized"
}


// MARK: - UIView扩展：存储原始值（内部使用）
public extension UIView {
    /// 原始frame（内部使用）
    var sOriginalFrame: CGRect? {
        get {
            return objc_getAssociatedObject(self, &sAssociatedKeys.originalFrame) as? CGRect
        }
        set {
            objc_setAssociatedObject(self, &sAssociatedKeys.originalFrame, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 原始字体大小（用于UILabel、UITextField、UITextView，内部使用）
    var sOriginalFontSize: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &sAssociatedKeys.originalFontSize) as? CGFloat
        }
        set {
            objc_setAssociatedObject(self, &sAssociatedKeys.originalFontSize, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 原始圆角（内部使用）
    var sOriginalCornerRadius: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &sAssociatedKeys.originalCornerRadius) as? CGFloat
        }
        set {
            objc_setAssociatedObject(self, &sAssociatedKeys.originalCornerRadius, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 是否跳过缩放（内部使用）
    var sShouldSkipResize: Bool {
        get {
            return objc_getAssociatedObject(self, &sAssociatedKeys.shouldSkipResize) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &sAssociatedKeys.shouldSkipResize, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 是否已经缩放过（用于标记是否需要保存原始值，内部使用）
    var sIsResized: Bool {
        get {
            return objc_getAssociatedObject(self, &sAssociatedKeys.isResized) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &sAssociatedKeys.isResized, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
