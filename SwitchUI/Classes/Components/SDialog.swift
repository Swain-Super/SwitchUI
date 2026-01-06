//
//  SDialog.swift
//  SwitchUI
//
//  Created by Swain on 2025/01/06.
//  Copyright © 2025 swain. All rights reserved.
//

import UIKit

// MARK: - SDialogAction
public struct SDialogAction {
    public var title: String
    public var style: Style
    public var handler: (() -> Void)?
    
    public enum Style {
        case `default`
        case cancel
        case destructive
    }
    
    public init(title: String, style: Style = .default, handler: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

// MARK: - SDialog
public class SDialog: UIView {
    
    // 标题
    public var s_title: String?
    
    // 内容文本
    public var s_message: String?
    
    // 自定义内容视图
    public var s_contentView: UIView?
    
    // 标题颜色
    public var s_titleColor: UIColor = .black
    
    // 标题字体大小
    public var s_titleFontSize: CGFloat = 18
    
    // 内容颜色
    public var s_messageColor: UIColor = .darkGray
    
    // 内容字体大小
    public var s_messageFontSize: CGFloat = 14
    
    // 对话框宽度
    public var s_width: CGFloat = 280
    
    // 对话框最大高度
    public var s_maxHeight: CGFloat = 400
    
    // 背景色
    public var s_backgroundColor: UIColor = .white
    
    // 圆角
    public var s_cornerRadius: CGFloat = 12
    
    // 遮罩颜色
    public var s_maskColor: UIColor = UIColor.black.withAlphaComponent(0.5)
    
    // 是否点击遮罩关闭
    public var s_closeOnMaskTap: Bool = false
    
    // 内边距
    public var s_padding: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    // 按钮列表
    public var s_actions: [SDialogAction] = []
    
    // 关闭回调
    public var onDismiss: (() -> Void)?
    
    // 私有视图
    private var sMaskView: UIView?
    private var containerView: UIView?
    private var titleLabel: UILabel?
    private var messageLabel: UILabel?
    private var contentStackView: UIStackView?
    private var buttonStackView: UIStackView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.frame = UIScreen.main.bounds
        self.backgroundColor = .clear
    }
    
    // MARK: - Chainable Methods
    
    @discardableResult
    public func s_title(_ title: String) -> Self {
        self.s_title = title
        return self
    }
    
    @discardableResult
    public func s_message(_ message: String) -> Self {
        self.s_message = message
        return self
    }
    
    @discardableResult
    public func s_contentView(_ view: UIView) -> Self {
        self.s_contentView = view
        return self
    }
    
    @discardableResult
    public func s_titleColor(_ color: UIColor) -> Self {
        self.s_titleColor = color
        return self
    }
    
    @discardableResult
    public func s_titleColor(_ hexString: String) -> Self {
        self.s_titleColor = hexString.hexColor()
        return self
    }
    
    @discardableResult
    public func s_titleFontSize(_ size: CGFloat) -> Self {
        self.s_titleFontSize = size
        return self
    }
    
    @discardableResult
    public func s_messageColor(_ color: UIColor) -> Self {
        self.s_messageColor = color
        return self
    }
    
    @discardableResult
    public func s_messageColor(_ hexString: String) -> Self {
        self.s_messageColor = hexString.hexColor()
        return self
    }
    
    @discardableResult
    public func s_messageFontSize(_ size: CGFloat) -> Self {
        self.s_messageFontSize = size
        return self
    }
    
    @discardableResult
    public func s_width(_ width: CGFloat) -> Self {
        self.s_width = width
        return self
    }
    
    @discardableResult
    public func s_maxHeight(_ height: CGFloat) -> Self {
        self.s_maxHeight = height
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
    public func s_cornerRadius(_ radius: CGFloat) -> Self {
        self.s_cornerRadius = radius
        return self
    }
    
    @discardableResult
    public func s_maskColor(_ color: UIColor) -> Self {
        self.s_maskColor = color
        return self
    }
    
    @discardableResult
    public func s_closeOnMaskTap(_ close: Bool) -> Self {
        self.s_closeOnMaskTap = close
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
    public func addAction(_ action: SDialogAction) -> Self {
        self.s_actions.append(action)
        return self
    }
    
    @discardableResult
    public func onDismiss(_ callback: @escaping () -> Void) -> Self {
        self.onDismiss = callback
        return self
    }
    
    // MARK: - Build & Show
    
    @discardableResult
    public func show() -> Self {
        buildDialog()
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return self
        }
        
        window.addSubview(self)
        
        // 入场动画
        sMaskView?.alpha = 0
        containerView?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        containerView?.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: []) {
            self.sMaskView?.alpha = 1
            self.containerView?.transform = .identity
            self.containerView?.alpha = 1
        }
        
        return self
    }
    
    @discardableResult
    public func dismiss(animated: Bool = true) -> Self {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.sMaskView?.alpha = 0
                self.containerView?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.containerView?.alpha = 0
            }) { _ in
                self.removeFromSuperview()
                self.onDismiss?()
            }
        } else {
            self.removeFromSuperview()
            self.onDismiss?()
        }
        return self
    }
    
    // MARK: - Private Methods
    
    private func buildDialog() {
        // 清除旧视图
        self.subviews.forEach { $0.removeFromSuperview() }
        
        // 创建遮罩
        sMaskView = UIView(frame: self.bounds)
        sMaskView?.backgroundColor = s_maskColor
        self.addSubview(sMaskView!)
        
        // 添加遮罩点击手势
        if s_closeOnMaskTap {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(maskTapped))
            sMaskView?.addGestureRecognizer(tapGesture)
        }
        
        // 创建容器
        containerView = UIView()
        containerView?.backgroundColor = s_backgroundColor
        containerView?.layer.cornerRadius = s_cornerRadius
        containerView?.layer.masksToBounds = true
        self.addSubview(containerView!)
        
        // 创建内容堆栈
        contentStackView = UIStackView()
        contentStackView?.axis = .vertical
        contentStackView?.spacing = 12
        contentStackView?.alignment = .fill
        containerView?.addSubview(contentStackView!)
        
        // 添加标题
        if let title = s_title, !title.isEmpty {
            titleLabel = UILabel()
            titleLabel?.text = title
            titleLabel?.font = UIFont.systemFont(ofSize: s_titleFontSize, weight: .bold)
            titleLabel?.textColor = s_titleColor
            titleLabel?.textAlignment = .center
            titleLabel?.numberOfLines = 0
            contentStackView?.addArrangedSubview(titleLabel!)
        }
        
        // 添加内容
        if let contentView = s_contentView {
            contentStackView?.addArrangedSubview(contentView)
        } else if let message = s_message, !message.isEmpty {
            messageLabel = UILabel()
            messageLabel?.text = message
            messageLabel?.font = UIFont.systemFont(ofSize: s_messageFontSize)
            messageLabel?.textColor = s_messageColor
            messageLabel?.textAlignment = .center
            messageLabel?.numberOfLines = 0
            contentStackView?.addArrangedSubview(messageLabel!)
        }
        
        // 添加按钮
        if !s_actions.isEmpty {
            buttonStackView = UIStackView()
            buttonStackView?.axis = s_actions.count > 2 ? .vertical : .horizontal
            buttonStackView?.distribution = .fillEqually
            buttonStackView?.spacing = 8
            
            for action in s_actions {
                let button = createActionButton(action)
                buttonStackView?.addArrangedSubview(button)
            }
            
            containerView?.addSubview(buttonStackView!)
        }
        
        // 布局
        layoutDialog()
    }
    
    private func createActionButton(_ action: SDialogAction) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(action.title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        switch action.style {
        case .default:
            button.setTitleColor(.systemBlue, for: .normal)
            button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        case .cancel:
            button.setTitleColor(.darkGray, for: .normal)
            button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        case .destructive:
            button.setTitleColor(.systemRed, for: .normal)
            button.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        }
        
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
        button.tag = s_actions.firstIndex(where: { $0.title == action.title }) ?? 0
        
        return button
    }
    
    private func layoutDialog() {
        guard let contentStackView = contentStackView else { return }
        
        // 计算内容尺寸
        let maxWidth = s_width - s_padding.left - s_padding.right
        contentStackView.frame = CGRect(x: s_padding.left, y: s_padding.top, width: maxWidth, height: 0)
        
        var contentHeight: CGFloat = 0
        for view in contentStackView.arrangedSubviews {
            let size = view.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
            contentHeight += size.height
        }
        contentHeight += CGFloat(contentStackView.arrangedSubviews.count - 1) * contentStackView.spacing
        
        contentStackView.frame.size.height = min(contentHeight, s_maxHeight - s_padding.top - s_padding.bottom - 60)
        
        // 按钮区域
        var totalHeight = contentStackView.frame.maxY + 16
        
        if let buttonStackView = buttonStackView {
            let buttonHeight: CGFloat = s_actions.count > 2 ? CGFloat(s_actions.count) * 44 + CGFloat(s_actions.count - 1) * 8 : 44
            buttonStackView.frame = CGRect(x: s_padding.left, y: totalHeight, width: maxWidth, height: buttonHeight)
            totalHeight = buttonStackView.frame.maxY + s_padding.bottom
        } else {
            totalHeight += s_padding.bottom
        }
        
        // 设置容器尺寸和位置
        let containerWidth = s_width
        let containerHeight = totalHeight
        containerView?.frame = CGRect(x: (self.bounds.width - containerWidth) / 2,
                                      y: (self.bounds.height - containerHeight) / 2,
                                      width: containerWidth,
                                      height: containerHeight)
    }
    
    @objc private func maskTapped() {
        if s_closeOnMaskTap {
            dismiss()
        }
    }
    
    @objc private func actionButtonTapped(_ sender: UIButton) {
        let action = s_actions[sender.tag]
        dismiss()
        action.handler?()
    }
    
    // MARK: - Static Helper Methods
    
    /// 显示警告对话框
    public static func alert(title: String?, message: String?, confirmTitle: String = "确定", onConfirm: (() -> Void)? = nil) {
        let dialog = SDialog()
            .s_title(title ?? "")
            .s_message(message ?? "")
            .addAction(SDialogAction(title: confirmTitle, style: .default, handler: onConfirm))
        dialog.show()
    }
    
    /// 显示确认对话框
    public static func confirm(title: String?, message: String?, confirmTitle: String = "确定", cancelTitle: String = "取消", onConfirm: (() -> Void)? = nil, onCancel: (() -> Void)? = nil) {
        let dialog = SDialog()
            .s_title(title ?? "")
            .s_message(message ?? "")
            .addAction(SDialogAction(title: cancelTitle, style: .cancel, handler: onCancel))
            .addAction(SDialogAction(title: confirmTitle, style: .default, handler: onConfirm))
        dialog.show()
    }
}

