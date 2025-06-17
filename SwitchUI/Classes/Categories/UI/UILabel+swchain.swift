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
    func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult
    func font(_ block: @escaping (UIView) -> UIFont,_ states: [SState]? = nil) -> Self {
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
