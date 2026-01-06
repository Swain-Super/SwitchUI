//
//  STextField.swift
//  SwitchUI
//
//  Created by Swain on 2025/01/06.
//  Copyright © 2025 swain. All rights reserved.
//

import UIKit

// MARK: - STextFieldStyle
public enum STextFieldStyle {
    case `default`      // 默认样式
    case outlined       // 边框样式
    case filled         // 填充样式
    case underlined     // 下划线样式
}

// MARK: - STextField
public class STextField: UITextField {
    
    // 文本内容
    public var s_text: String?
    // 占位符文字
    public var s_placeholder: String?
    // 占位符颜色
    public var s_placeholderColor: UIColor?
    // 文字颜色
    public var s_textColor: UIColor?
    // 字体大小
    public var s_fontSize: CGFloat = 17
    // 字体
    public var s_font: UIFont?
    // 字体字重
    public var s_fontWeight: String?
    // 文字横向排列方式
    public var s_textAlignment: NSTextAlignment = .left
    // 键盘类型
    public var s_keyboardType: UIKeyboardType = .default
    // 返回键类型
    public var s_returnKeyType: UIReturnKeyType = .default
    // 是否安全输入（密码）
    public var s_isSecure: Bool = false
    // 最大字符数
    public var s_maxLength: Int?
    // 左侧图标
    public var s_leftIcon: UIImage?
    // 右侧图标
    public var s_rightIcon: UIImage?
    // 清除按钮模式
    public var s_clearButtonMode: UITextField.ViewMode = .never
    // 输入框样式
    public var s_style: STextFieldStyle = .default
    // 边框颜色
    public var s_borderColor: UIColor?
    // 边框宽度
    public var s_borderWidth: CGFloat = 1
    // 圆角
    public var s_cornerRadius: CGFloat?
    // 背景色
    public var s_backgroundColor: UIColor?
    // 内边距
    public var s_padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    // 错误状态
    public var s_isError: Bool = false
    // 错误提示文字
    public var s_errorText: String?
    // 是否禁用
    public var s_isDisabled: Bool = false
    
    // 回调闭包
    public var onTextChanged: ((String) -> Void)?
    public var onEditingBegan: (() -> Void)?
    public var onEditingEnded: (() -> Void)?
    public var onReturn: (() -> Bool)?
    public var onShouldChange: ((NSRange, String) -> Bool)?
    
    // 私有视图
    private var leftIconView: UIImageView?
    private var rightIconView: UIImageView?
    private var errorLabel: UILabel?
    private var underlineView: UIView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        self.delegate = self
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.borderStyle = .none
    }
    
    // MARK: - Chainable Methods
    
    @discardableResult
    public func s_text(_ text: String) -> Self {
        self.s_text = text
        return self
    }
    
    @discardableResult
    public func s_placeholder(_ placeholder: String) -> Self {
        self.s_placeholder = placeholder
        return self
    }
    
    @discardableResult
    public func s_placeholderColor(_ color: UIColor) -> Self {
        self.s_placeholderColor = color
        return self
    }
    
    @discardableResult
    public func s_placeholderColor(_ hexString: String) -> Self {
        self.s_placeholderColor = hexString.hexColor()
        return self
    }
    
    @discardableResult
    public func s_textColor(_ color: UIColor) -> Self {
        self.s_textColor = color
        return self
    }
    
    @discardableResult
    public func s_textColor(_ hexString: String) -> Self {
        self.s_textColor = hexString.hexColor()
        return self
    }
    
    @discardableResult
    public func s_fontSize(_ size: CGFloat) -> Self {
        self.s_fontSize = size
        return self
    }
    
    @discardableResult
    public func s_font(_ font: UIFont) -> Self {
        self.s_font = font
        return self
    }
    
    @discardableResult
    public func s_fontWeight(_ weight: String) -> Self {
        self.s_fontWeight = weight
        return self
    }
    
    @discardableResult
    public func s_textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.s_textAlignment = alignment
        return self
    }
    
    @discardableResult
    public func s_keyboardType(_ type: UIKeyboardType) -> Self {
        self.s_keyboardType = type
        return self
    }
    
    @discardableResult
    public func s_returnKeyType(_ type: UIReturnKeyType) -> Self {
        self.s_returnKeyType = type
        return self
    }
    
    @discardableResult
    public func s_isSecure(_ isSecure: Bool) -> Self {
        self.s_isSecure = isSecure
        return self
    }
    
    @discardableResult
    public func s_maxLength(_ length: Int) -> Self {
        self.s_maxLength = length
        return self
    }
    
    @discardableResult
    public func s_leftIcon(_ image: UIImage?) -> Self {
        self.s_leftIcon = image
        return self
    }
    
    @discardableResult
    public func s_rightIcon(_ image: UIImage?) -> Self {
        self.s_rightIcon = image
        return self
    }
    
    @discardableResult
    public func s_clearButtonMode(_ mode: UITextField.ViewMode) -> Self {
        self.s_clearButtonMode = mode
        return self
    }
    
    @discardableResult
    public func s_style(_ style: STextFieldStyle) -> Self {
        self.s_style = style
        return self
    }
    
    @discardableResult
    public func s_borderColor(_ color: UIColor) -> Self {
        self.s_borderColor = color
        return self
    }
    
    @discardableResult
    public func s_borderColor(_ hexString: String) -> Self {
        self.s_borderColor = hexString.hexColor()
        return self
    }
    
    @discardableResult
    public func s_borderWidth(_ width: CGFloat) -> Self {
        self.s_borderWidth = width
        return self
    }
    
    @discardableResult
    public func s_cornerRadius(_ radius: CGFloat) -> Self {
        self.s_cornerRadius = radius
        return self
    }
    
    @discardableResult
    public func s_backgroundColor(_ color: UIColor) -> Self {
        self.s_backgroundColor = color
        return self
    }
    
    @discardableResult
    public func s_backgroundColor(_ hexString: String) -> Self {
        self.s_backgroundColor = hexString.hexColor()
        return self
    }
    
    @discardableResult
    public func s_padding(_ padding: UIEdgeInsets) -> Self {
        self.s_padding = padding
        return self
    }
    
    @discardableResult
    public func s_padding(_ all: CGFloat) -> Self {
        self.s_padding = UIEdgeInsets(top: all, left: all, bottom: all, right: all)
        return self
    }
    
    @discardableResult
    public func s_isError(_ isError: Bool) -> Self {
        self.s_isError = isError
        return self
    }
    
    @discardableResult
    public func s_errorText(_ text: String?) -> Self {
        self.s_errorText = text
        return self
    }
    
    @discardableResult
    public func s_isDisabled(_ isDisabled: Bool) -> Self {
        self.s_isDisabled = isDisabled
        return self
    }
    
    // MARK: - Event Callbacks
    
    @discardableResult
    public func onTextChanged(_ callback: @escaping (String) -> Void) -> Self {
        self.onTextChanged = callback
        return self
    }
    
    @discardableResult
    public func onEditingBegan(_ callback: @escaping () -> Void) -> Self {
        self.onEditingBegan = callback
        return self
    }
    
    @discardableResult
    public func onEditingEnded(_ callback: @escaping () -> Void) -> Self {
        self.onEditingEnded = callback
        return self
    }
    
    @discardableResult
    public func onReturn(_ callback: @escaping () -> Bool) -> Self {
        self.onReturn = callback
        return self
    }
    
    @discardableResult
    public func onShouldChange(_ callback: @escaping (NSRange, String) -> Bool) -> Self {
        self.onShouldChange = callback
        return self
    }
    
    // MARK: - Render
    
    @discardableResult
    public func s_render() -> Self {
        // 设置文本
        if let text = s_text {
            self.text = text
        }
        
        // 设置占位符
        if let placeholder = s_placeholder {
            if let placeholderColor = s_placeholderColor {
                self.attributedPlaceholder = NSAttributedString(
                    string: placeholder,
                    attributes: [.foregroundColor: placeholderColor]
                )
            } else {
                self.placeholder = placeholder
            }
        }
        
        // 设置文字颜色
        if let textColor = s_textColor {
            self.textColor = textColor
        }
        
        // 设置字体
        if let font = s_font {
            self.font = font
        } else {
            var font: UIFont?
            if let fontWeight = s_fontWeight {
                var fontW = UIFont.Weight.regular
                switch fontWeight {
                case "100": fontW = .ultraLight
                case "200": fontW = .thin
                case "300": fontW = .light
                case "400": fontW = .regular
                case "500": fontW = .medium
                case "600": fontW = .semibold
                case "700": fontW = .bold
                case "800": fontW = .heavy
                case "900": fontW = .black
                case "normal": fontW = .regular
                case "bold": fontW = .bold
                default: break
                }
                font = UIFont.systemFont(ofSize: s_fontSize, weight: fontW)
            } else {
                font = UIFont.systemFont(ofSize: s_fontSize)
            }
            self.font = font
        }
        
        // 设置文字对齐
        self.textAlignment = s_textAlignment
        
        // 设置键盘类型
        self.keyboardType = s_keyboardType
        self.returnKeyType = s_returnKeyType
        
        // 设置安全输入
        self.isSecureTextEntry = s_isSecure
        
        // 设置清除按钮
        self.clearButtonMode = s_clearButtonMode
        
        // 设置禁用状态
        self.isEnabled = !s_isDisabled
        self.alpha = s_isDisabled ? 0.5 : 1.0
        
        // 应用样式
        applyStyle()
        
        // 设置左侧图标
        if let leftIcon = s_leftIcon {
            setupLeftIcon(leftIcon)
        }
        
        // 设置右侧图标
        if let rightIcon = s_rightIcon {
            setupRightIcon(rightIcon)
        }
        
        // 设置错误状态
        if s_isError {
            showError()
        } else {
            hideError()
        }
        
        return self
    }
    
    // MARK: - Private Methods
    
    private func applyStyle() {
        switch s_style {
        case .default:
            if let bgColor = s_backgroundColor {
                self.backgroundColor = bgColor
            }
            if let borderColor = s_borderColor {
                self.layer.borderColor = borderColor.cgColor
                self.layer.borderWidth = s_borderWidth
            }
            if let cornerRadius = s_cornerRadius {
                self.layer.cornerRadius = cornerRadius
                self.layer.masksToBounds = true
            }
            
        case .outlined:
            self.backgroundColor = .clear
            self.layer.borderColor = (s_borderColor ?? UIColor.lightGray).cgColor
            self.layer.borderWidth = s_borderWidth
            self.layer.cornerRadius = s_cornerRadius ?? 8
            self.layer.masksToBounds = true
            
        case .filled:
            self.backgroundColor = s_backgroundColor ?? UIColor(white: 0.95, alpha: 1.0)
            self.layer.borderWidth = 0
            self.layer.cornerRadius = s_cornerRadius ?? 8
            self.layer.masksToBounds = true
            
        case .underlined:
            self.backgroundColor = .clear
            self.layer.borderWidth = 0
            
            // 添加下划线
            if underlineView == nil {
                underlineView = UIView()
                self.addSubview(underlineView!)
            }
            underlineView?.backgroundColor = s_borderColor ?? UIColor.lightGray
            underlineView?.frame = CGRect(x: 0, y: self.bounds.height - s_borderWidth, width: self.bounds.width, height: s_borderWidth)
        }
    }
    
    private func setupLeftIcon(_ image: UIImage) {
        if leftIconView == nil {
            leftIconView = UIImageView()
            leftIconView?.contentMode = .scaleAspectFit
        }
        leftIconView?.image = image
        
        let iconSize: CGFloat = 24
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: iconSize + 12, height: iconSize))
        leftIconView?.frame = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
        iconView.addSubview(leftIconView!)
        
        self.leftView = iconView
        self.leftViewMode = .always
    }
    
    private func setupRightIcon(_ image: UIImage) {
        if rightIconView == nil {
            rightIconView = UIImageView()
            rightIconView?.contentMode = .scaleAspectFit
        }
        rightIconView?.image = image
        
        let iconSize: CGFloat = 24
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: iconSize + 12, height: iconSize))
        rightIconView?.frame = CGRect(x: 12, y: 0, width: iconSize, height: iconSize)
        iconView.addSubview(rightIconView!)
        
        self.rightView = iconView
        self.rightViewMode = .always
    }
    
    private func showError() {
        if let errorText = s_errorText, !errorText.isEmpty {
            if errorLabel == nil {
                errorLabel = UILabel()
                errorLabel?.font = UIFont.systemFont(ofSize: 12)
                errorLabel?.textColor = .red
                errorLabel?.numberOfLines = 0
                self.superview?.addSubview(errorLabel!)
            }
            errorLabel?.text = errorText
            errorLabel?.frame = CGRect(x: self.frame.origin.x, y: self.frame.maxY + 4, width: self.frame.width, height: 20)
        }
        
        // 更改边框颜色为红色
        if s_style == .outlined || s_style == .underlined {
            self.layer.borderColor = UIColor.red.cgColor
            underlineView?.backgroundColor = .red
        }
    }
    
    private func hideError() {
        errorLabel?.removeFromSuperview()
        errorLabel = nil
        
        // 恢复原有边框颜色
        if s_style == .outlined || s_style == .underlined {
            self.layer.borderColor = (s_borderColor ?? UIColor.lightGray).cgColor
            underlineView?.backgroundColor = s_borderColor ?? UIColor.lightGray
        }
    }
    
    @objc private func textFieldDidChange() {
        onTextChanged?(self.text ?? "")
    }
    
    // MARK: - Override Text Rect Methods for Padding
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: s_padding)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: s_padding)
    }
    
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: s_padding)
    }
    
    public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += s_padding.left
        return rect
    }
    
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= s_padding.right
        return rect
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // 更新下划线位置
        if s_style == .underlined, let underlineView = underlineView {
            underlineView.frame = CGRect(x: 0, y: self.bounds.height - s_borderWidth, width: self.bounds.width, height: s_borderWidth)
        }
    }
    
    deinit {
        errorLabel?.removeFromSuperview()
    }
}

// MARK: - UITextFieldDelegate
extension STextField: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        onEditingBegan?()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        onEditingEnded?()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return onReturn?() ?? true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 检查最大长度限制
        if let maxLength = s_maxLength {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            if updatedText.count > maxLength {
                return false
            }
        }
        
        // 调用自定义回调
        return onShouldChange?(range, string) ?? true
    }
}

