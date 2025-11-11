//
//  UITextField+swchain.swift
//  Swain
//
//  Created by swain on 2023/7/29.
//

import Foundation
import UIKit

public extension UITextField {
    
    @discardableResult
    func text(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    @discardableResult
    func text(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UITextFieldKey.text.rawValue, block: block, states: states)
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
            self.autoBindAndRun(key: UITextFieldKey.keyboardType.rawValue, block: block, states: states)
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
            self.autoBindAndRun(key: UITextFieldKey.font.rawValue, block: block, states: states)
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
            self.autoBindAndRun(key: UITextFieldKey.textColor.rawValue, block: block, states: states)
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
            self.autoBindAndRun(key: UITextFieldKey.textAlignment.rawValue, block: block, states: states)
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
            self.autoBindAndRun(key: UITextFieldKey.attributedText.rawValue, block: block, states: states)
        } else {
            self.attributedText(block(self))
        }
        return self
    }
    
    @discardableResult
    func adjustsFontSizeToFitWidth(_ adjustsFontSizeToFitWidth: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return self
    }
    
    @discardableResult
    func adjustsFontSizeToFitWidth(_ block: @escaping (UIView) -> Bool,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UITextFieldKey.adjustsFontSizeToFitWidth.rawValue, block: block, states: states)
        } else {
            self.adjustsFontSizeToFitWidth(block(self))
        }
        return self
    }
    
    @discardableResult
    func placeholder(_ placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }
    
    @discardableResult
    func placeholder(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UITextFieldKey.placeholder.rawValue, block: block, states: states)
        } else {
            self.placeholder(block(self))
        }
        return self
    }
    
    @discardableResult
    func attributedPlaceholder(_ attributedPlaceholder: NSAttributedString) -> Self {
        self.attributedPlaceholder = attributedPlaceholder
        return self
    }
    
    @discardableResult
    func attributedPlaceholder(_ block: @escaping (UIView) -> NSAttributedString,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UITextFieldKey.attributedPlaceholder.rawValue, block: block, states: states)
        } else {
            self.attributedPlaceholder(block(self))
        }
        return self
    }
    
}
