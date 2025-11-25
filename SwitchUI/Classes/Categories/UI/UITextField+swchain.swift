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
    func font(_ font: UIFont?) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult
    func font(_ block: @escaping (UIView) -> UIFont?,_ states: [SState]? = nil) -> Self {
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
    func textColor(_ textColor: String) -> Self {
        self.textColor = textColor.hexColor()
        return self
    }
    
    @discardableResult
    func textColor(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UITextFieldKey.textColorB.rawValue, block: block, states: states)
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
    
    @discardableResult
    func inputView(_ view: UIView) -> Self {
        self.inputView = view
        return self
    }
    
}

public extension UITextField {
    
    /// 添加文本编辑变化监听，并支持链式调用
    /// - Parameter block: 文本变化时的回调，参数为当前文本
    /// - Returns: Self，支持链式调用
    @discardableResult
    func onEditingChanged(_ block: @escaping (String) -> Void) -> Self {
        // 存储闭包（避免强引用循环）
        self.editingChangedHandler = block
        
        // 添加 target-action 监听 editingChanged 事件
        self.addTarget(self, action: #selector(UITextField._editingChanged), for: .editingChanged)
        
        return self
    }
    
    // MARK: - Private
    
    // 用于存储闭包的属性
    private static var editingChangedKey: UInt8 = 0
    private var editingChangedHandler: ((String) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &Self.editingChangedKey) as? (String) -> Void
        }
        set {
            objc_setAssociatedObject(self, &Self.editingChangedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 响应方法
    @objc private func _editingChanged() {
        editingChangedHandler?(self.text ?? "")
    }
}
