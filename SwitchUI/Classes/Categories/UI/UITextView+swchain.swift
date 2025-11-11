//
//  UITextView+swchain.swift
//  Swain
//
//  Created by swain on 2023/8/5.
//

import Foundation
import UIKit

public extension UITextView {
    
    @discardableResult
    func text(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    @discardableResult
    func text(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UITextViewAKey.text.rawValue, block: block, states: states)
        } else {
            self.text(block(self))
        }
        return self
    }
    
    @discardableResult
    func keyboardType(_ keyboardType: UIKeyboardType) -> Self {
        self.keyboardType = keyboardType
        return self
    }
    
    @discardableResult
    func keyboardType(_ block: @escaping (UIView) -> UIKeyboardType,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UITextViewAKey.keyboardType.rawValue, block: block, states: states)
        } else {
            self.keyboardType(block(self))
        }
        return self
    }
    
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult
    func font(_ block: @escaping (UIView) -> UIFont,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UITextViewAKey.font.rawValue, block: block, states: states)
        } else {
            self.font(block(self))
        }
        return self
    }
    
    @discardableResult
    func textColor(_ textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }
    
    @discardableResult
    func textColor(_ block: @escaping (UIView) -> UIColor,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UITextViewAKey.textColor.rawValue, block: block, states: states)
        } else {
            self.textColor(block(self))
        }
        return self
    }
    
    @discardableResult
    func textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }
    
    @discardableResult
    func textAlignment(_ block: @escaping (UIView) -> NSTextAlignment,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UITextViewAKey.textAlignment.rawValue, block: block, states: states)
        } else {
            self.textAlignment(block(self))
        }
        return self
    }
    
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString?) -> Self {
        self.attributedText = attributedText
        return self
    }
    
    @discardableResult
    func attributedText(_ block: @escaping (UIView) -> NSAttributedString?,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UITextViewAKey.attributedText.rawValue, block: block, states: states)
        } else {
            self.attributedText(block(self))
        }
        return self
    }
    
    @discardableResult
    func isEditable(_ isEditable: Bool) -> Self {
        self.isEditable = isEditable
        return self
    }
    
    @discardableResult
    func isEditable(_ block: @escaping (UIView) -> Bool,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UITextViewAKey.isEditable.rawValue, block: block, states: states)
        } else {
            self.isEditable(block(self))
        }
        return self
    }
    
    @discardableResult
    func isSelectable(_ isSelectable: Bool) -> Self {
        self.isSelectable = isSelectable
        return self
    }
    
    @discardableResult
    func isSelectable(_ block: @escaping (UIView) -> Bool,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UITextViewAKey.isSelectable.rawValue, block: block, states: states)
        } else {
            self.isSelectable(block(self))
        }
        return self
    }
    
    @discardableResult
    func textContainerInset(_ textContainerInset: UIEdgeInsets) -> Self {
        self.textContainerInset = textContainerInset
        return self
    }
    
    @discardableResult
    func textContainerInset(_ block: @escaping (UIView) -> UIEdgeInsets,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UITextViewAKey.textContainerInset.rawValue, block: block, states: states)
        } else {
            self.textContainerInset(block(self))
        }
        return self
    }
    
}
