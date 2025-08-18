//
//  UILabel+swchain.swift
//  Swain
//
//  Created by swain on 2023/7/22.
//

import Foundation
import UIKit

public extension UILabel {
    
    @discardableResult
    func text(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    @discardableResult
    func text(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UILabelKey.text.rawValue, block: block, states: states)
        return self
    }
    
    @discardableResult
    func font(_ font: UIFont?) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult
    func font(_ block: @escaping (UIView) -> UIFont?,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UILabelKey.font.rawValue, block: block, states: states)
        return self
    }
    
    @discardableResult
    func textColor(_ textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }
    
    @discardableResult
    func textColor(_ block: @escaping (UIView) -> UIColor,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UILabelKey.textColorA.rawValue, block: block, states: states)
        return self
    }
    
    @discardableResult
    func textColor(_ hexColor: String) -> Self {
        self.textColor = hexColor.hexColor()
        return self
    }
    
    @discardableResult
    func textColor(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UILabelKey.textColorB.rawValue, block: block, states: states)
        return self
    }
    
    @discardableResult
    func textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }
    
    @discardableResult
    func textAlignment(_ block: @escaping (UIView) -> NSTextAlignment,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UILabelKey.textAlignment.rawValue, block: block, states: states)
        return self
    }
    
    @discardableResult
    func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        self.lineBreakMode = lineBreakMode
        return self
    }
    
    @discardableResult
    func lineBreakMode(_ block: @escaping (UIView) -> NSLineBreakMode,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UILabelKey.lineBreakMode.rawValue, block: block, states: states)
        return self
    }
    
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString?) -> Self {
        self.attributedText = attributedText
        return self
    }
    
    @discardableResult
    func attributedText(_ block: @escaping (UIView) -> NSAttributedString?,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UILabelKey.attributedText.rawValue, block: block, states: states)
        return self
    }
    
    @discardableResult
    func highlightedTextColor(_ highlightedTextColor: UIColor?) -> Self {
        self.highlightedTextColor = highlightedTextColor
        return self
    }
    
    @discardableResult
    func highlightedTextColor(_ block: @escaping (UIView) -> UIColor?,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UILabelKey.highlightedTextColor.rawValue, block: block, states: states)
        return self
    }
    
    @discardableResult
    func numberOfLines(_ numberOfLines: Int) -> Self {
        self.numberOfLines = numberOfLines
        return self
    }
    
    @discardableResult
    func numberOfLines(_ block: @escaping (UIView) -> Int,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UILabelKey.numberOfLines.rawValue, block: block, states: states)
        return self
    }
    
    @discardableResult
    func adjustsFontSizeToFitWidth(_ adjustsFontSizeToFitWidth: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return self
    }
    
    @discardableResult
    func adjustsFontSizeToFitWidth(_ block: @escaping (UIView) -> Bool,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UILabelKey.adjustsFontSizeToFitWidth.rawValue, block: block, states: states)
        return self
    }
    
    @discardableResult
    func baselineAdjustment(_ baselineAdjustment: UIBaselineAdjustment) -> Self {
        self.baselineAdjustment = baselineAdjustment
        return self
    }
    
    @discardableResult
    func baselineAdjustment(_ block: @escaping (UIView) -> UIBaselineAdjustment,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UILabelKey.baselineAdjustment.rawValue, block: block, states: states)
        return self
    }
    
}

private var _lineSpace: Void?
private var _lineHeight: Void?

public extension UILabel {
    
    var slineSpace: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &_lineSpace) as? CGFloat
        }
        set {
            objc_setAssociatedObject(self, &_lineSpace, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var slineHeight: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &_lineHeight) as? CGFloat
        }
        set {
            objc_setAssociatedObject(self, &_lineHeight, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @discardableResult
    func lineSpace(_ linespace: CGFloat) -> Self {
        self.slineSpace = linespace
        return self
    }
    
    @discardableResult
    func lineHeight(_ lineheight: CGFloat) -> Self {
        self.slineHeight = lineheight
        return self
    }
    
    @discardableResult
    func renderAttributedText() -> Self {
        
        guard let text = self.text else { return self }
        
        // 排版样式
        var paragraphStyle = NSMutableParagraphStyle.init()
        
        // 富文本对象
        var attributeString = NSMutableAttributedString.init(string: text)
        
        var textCount = attributeString.length
        
        // 字体颜色
        if let textColor = self.textColor {
            
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : textColor], range: NSRange.init(location: 0, length: textCount ))
        }
        
        // 文字字体
        if let font = self.font {
            attributeString.addAttributes([NSAttributedString.Key.font : font], range: NSRange.init(location: 0, length: textCount))
        }
        
        // 文字对齐方式, 只有设置了控件的宽度才能设置对齐方式，要不然会有布局问题
        paragraphStyle.alignment = self.textAlignment;
        
        // 截断方式
        paragraphStyle.lineBreakMode = self.lineBreakMode
        
        // 行间距
        if let lineSpace = self.slineSpace {
            paragraphStyle.lineSpacing = CGFloat(lineSpace) - (self.font.lineHeight - self.font.pointSize)
        }
        
        // 行高
        if let lineHeight = self.slineHeight {
            paragraphStyle.maximumLineHeight = CGFloat(lineHeight)
            paragraphStyle.minimumLineHeight = CGFloat(lineHeight)
            
            // MARK: iOS的问题设置了行高之后，文字会偏下一些，设置基线调整一下位置
            var baseLineOffset = (CGFloat(lineHeight) - self.font.lineHeight) / 4
            attributeString.addAttributes([NSAttributedString.Key.baselineOffset : baseLineOffset], range: NSRange.init(location: 0, length: textCount))
        }
        
        // 设置文字样式
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, textCount))
        
        self.attributedText = attributeString
        
        return self
    }
    
}
