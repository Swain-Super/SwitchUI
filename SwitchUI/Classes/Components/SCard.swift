//
//  SCard.swift
//  SwitchUI
//
//  Created by Swain on 2025/01/06.
//  Copyright © 2025 swain. All rights reserved.
//

import UIKit

// MARK: - SCardStyle
public enum SCardStyle {
    case plain          // 简单卡片
    case elevated       // 带阴影的悬浮卡片
    case outlined       // 边框卡片
}

// MARK: - SCard
public class SCard: UIView {
    
    // 卡片样式
    public var s_style: SCardStyle = .elevated
    
    // 背景色
    public var s_backgroundColor: UIColor = .white
    
    // 圆角
    public var s_cornerRadius: CGFloat = 12
    
    // 边框宽度
    public var s_borderWidth: CGFloat = 1
    
    // 边框颜色
    public var s_borderColor: UIColor = .lightGray
    
    // 内边距
    public var s_padding: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    // 阴影配置（elevated 样式）
    public var s_shadowColor: UIColor = .black
    public var s_shadowOpacity: Float = 0.1
    public var s_shadowRadius: CGFloat = 8
    public var s_shadowOffset: CGSize = CGSize(width: 0, height: 2)
    
    // 是否可点击
    public var s_isClickable: Bool = false
    
    // 点击回调
    public var onClick: (() -> Void)?
    
    // 高亮效果
    public var s_highlightOnTouch: Bool = true
    
    // 内容容器
    private var contentContainer: UIView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    /// 初始化卡片（支持子视图数组）
    public convenience init(_ subViews: [UIView]? = nil) {
        self.init(frame: .zero)
        
        subViews?.forEach { view in
            self.addContent(view)
        }
    }
    
    /// 初始化卡片（支持闭包构造）
    public convenience init(_ block: ((inout [UIView]) -> Void)?) {
        self.init()
        
        if let block = block {
            var subViews: [UIView] = []
            block(&subViews)
            subViews.forEach { view in
                self.addContent(view)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // 创建内容容器
        contentContainer = UIView()
        self.addSubview(contentContainer!)
    }
    
    // MARK: - Chainable Methods
    
    @discardableResult
    public func s_style(_ style: SCardStyle) -> Self {
        self.s_style = style
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
    public func s_borderWidth(_ width: CGFloat) -> Self {
        self.s_borderWidth = width
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
    public func s_shadowColor(_ color: UIColor) -> Self {
        self.s_shadowColor = color
        return self
    }
    
    @discardableResult
    public func s_shadowColor(_ hexString: String) -> Self {
        self.s_shadowColor = hexString.hexColor()
        return self
    }
    
    @discardableResult
    public func s_shadowOpacity(_ opacity: Float) -> Self {
        self.s_shadowOpacity = opacity
        return self
    }
    
    @discardableResult
    public func s_shadowRadius(_ radius: CGFloat) -> Self {
        self.s_shadowRadius = radius
        return self
    }
    
    @discardableResult
    public func s_shadowOffset(_ offset: CGSize) -> Self {
        self.s_shadowOffset = offset
        return self
    }
    
    @discardableResult
    public func s_isClickable(_ clickable: Bool) -> Self {
        self.s_isClickable = clickable
        return self
    }
    
    @discardableResult
    public func onClick(_ callback: @escaping () -> Void) -> Self {
        self.onClick = callback
        self.s_isClickable = true
        return self
    }
    
    @discardableResult
    public func s_highlightOnTouch(_ highlight: Bool) -> Self {
        self.s_highlightOnTouch = highlight
        return self
    }
    
    // MARK: - Render
    
    @discardableResult
    public func s_render() -> Self {
        // 设置背景色
        self.backgroundColor = s_backgroundColor
        
        // 设置圆角
        self.layer.cornerRadius = s_cornerRadius
        self.layer.masksToBounds = false  // 允许阴影显示
        
        // 根据样式应用效果
        switch s_style {
        case .plain:
            self.layer.borderWidth = 0
            self.layer.shadowOpacity = 0
            
        case .elevated:
            self.layer.borderWidth = 0
            self.layer.shadowColor = s_shadowColor.cgColor
            self.layer.shadowOpacity = s_shadowOpacity
            self.layer.shadowRadius = s_shadowRadius
            self.layer.shadowOffset = s_shadowOffset
            
        case .outlined:
            self.layer.borderWidth = s_borderWidth
            self.layer.borderColor = s_borderColor.cgColor
            self.layer.shadowOpacity = 0
        }
        
        // 设置点击交互
        self.isUserInteractionEnabled = s_isClickable
        
        // 更新内容容器位置
        contentContainer?.frame = bounds.inset(by: s_padding)
        
        return self
    }
    
    // MARK: - Content Management
    
    /// 添加内容视图
    @discardableResult
    public func addContent(_ view: UIView) -> Self {
        contentContainer?.addSubview(view)
        return self
    }
    
    /// 清除所有内容
    @discardableResult
    public func clearContent() -> Self {
        contentContainer?.subviews.forEach { $0.removeFromSuperview() }
        return self
    }
    
    // MARK: - Touch Handling
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if s_isClickable && s_highlightOnTouch {
            UIView.animate(withDuration: 0.1) {
                self.alpha = 0.7
                self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if s_isClickable {
            UIView.animate(withDuration: 0.1) {
                self.alpha = 1.0
                self.transform = .identity
            }
            
            onClick?()
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        if s_isClickable && s_highlightOnTouch {
            UIView.animate(withDuration: 0.1) {
                self.alpha = 1.0
                self.transform = .identity
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentContainer?.frame = bounds.inset(by: s_padding)
    }
}

