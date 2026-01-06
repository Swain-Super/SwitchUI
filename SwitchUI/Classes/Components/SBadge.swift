//
//  SBadge.swift
//  SwitchUI
//
//  Created by Swain on 2025/01/06.
//  Copyright © 2025 swain. All rights reserved.
//

import UIKit

// MARK: - SBadgePosition
public enum SBadgePosition {
    case topRight       // 右上角
    case topLeft        // 左上角
    case bottomRight    // 右下角
    case bottomLeft     // 左下角
    case center         // 中心
    case custom(x: CGFloat, y: CGFloat)  // 自定义位置
}

// MARK: - SBadgeStyle
public enum SBadgeStyle {
    case dot            // 圆点样式
    case number         // 数字样式
    case text           // 文本样式
}

// MARK: - SBadge
public class SBadge: UIView {
    
    // 角标样式
    public var s_style: SBadgeStyle = .number
    
    // 角标文本
    public var s_text: String?
    
    // 角标数字
    public var s_count: Int = 0
    
    // 最大数字（超过显示 99+）
    public var s_maxCount: Int = 99
    
    // 角标位置
    public var s_position: SBadgePosition = .topRight
    
    // 角标背景色
    public var s_backgroundColor: UIColor = .systemRed
    
    // 角标文字颜色
    public var s_textColor: UIColor = .white
    
    // 角标文字大小
    public var s_fontSize: CGFloat = 10
    
    // 角标大小（dot 样式）
    public var s_dotSize: CGFloat = 8
    
    // 角标内边距（number/text 样式）
    public var s_padding: UIEdgeInsets = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
    
    // 角标偏移（微调位置）
    public var s_offset: CGPoint = .zero
    
    // 是否隐藏
    public var s_isHidden: Bool = false
    
    // 是否显示零
    public var s_showZero: Bool = false
    
    // 边框宽度
    public var s_borderWidth: CGFloat = 0
    
    // 边框颜色
    public var s_borderColor: UIColor = .white
    
    // 是否自动隐藏（当 count = 0 时）
    public var s_autoHide: Bool = true
    
    // 动画效果
    public var s_animated: Bool = true
    
    // 私有视图
    private var contentLabel: UILabel?
    private var targetView: UIView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.isUserInteractionEnabled = false
    }
    
    // MARK: - Chainable Methods
    
    @discardableResult
    public func s_style(_ style: SBadgeStyle) -> Self {
        self.s_style = style
        return self
    }
    
    @discardableResult
    public func s_text(_ text: String) -> Self {
        self.s_text = text
        return self
    }
    
    @discardableResult
    public func s_count(_ count: Int) -> Self {
        self.s_count = count
        return self
    }
    
    @discardableResult
    public func s_maxCount(_ maxCount: Int) -> Self {
        self.s_maxCount = maxCount
        return self
    }
    
    @discardableResult
    public func s_position(_ position: SBadgePosition) -> Self {
        self.s_position = position
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
    public func s_dotSize(_ size: CGFloat) -> Self {
        self.s_dotSize = size
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
    public func s_offset(_ offset: CGPoint) -> Self {
        self.s_offset = offset
        return self
    }
    
    @discardableResult
    public func s_offset(x: CGFloat, y: CGFloat) -> Self {
        self.s_offset = CGPoint(x: x, y: y)
        return self
    }
    
    @discardableResult
    public func s_isHidden(_ isHidden: Bool) -> Self {
        self.s_isHidden = isHidden
        return self
    }
    
    @discardableResult
    public func s_showZero(_ showZero: Bool) -> Self {
        self.s_showZero = showZero
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
    public func s_autoHide(_ autoHide: Bool) -> Self {
        self.s_autoHide = autoHide
        return self
    }
    
    @discardableResult
    public func s_animated(_ animated: Bool) -> Self {
        self.s_animated = animated
        return self
    }
    
    // MARK: - Render
    
    @discardableResult
    public func s_render() -> Self {
        // 清除旧视图
        contentLabel?.removeFromSuperview()
        self.subviews.forEach { $0.removeFromSuperview() }
        
        // 检查是否自动隐藏
        if s_autoHide && s_count == 0 && !s_showZero && s_style == .number {
            self.isHidden = true
            return self
        }
        
        self.isHidden = s_isHidden
        
        // 设置背景色和边框
        self.backgroundColor = s_backgroundColor
        self.layer.borderWidth = s_borderWidth
        self.layer.borderColor = s_borderColor.cgColor
        
        switch s_style {
        case .dot:
            renderDotStyle()
        case .number:
            renderNumberStyle()
        case .text:
            renderTextStyle()
        }
        
        return self
    }
    
    // MARK: - Private Methods
    
    private func renderDotStyle() {
        let size = s_dotSize
        self.frame.size = CGSize(width: size, height: size)
        self.layer.cornerRadius = size / 2
        self.layer.masksToBounds = true
    }
    
    private func renderNumberStyle() {
        let displayText: String
        if s_count > s_maxCount {
            displayText = "\(s_maxCount)+"
        } else {
            displayText = "\(s_count)"
        }
        
        setupContentLabel(text: displayText)
    }
    
    private func renderTextStyle() {
        guard let text = s_text else { return }
        setupContentLabel(text: text)
    }
    
    private func setupContentLabel(text: String) {
        if contentLabel == nil {
            contentLabel = UILabel()
            self.addSubview(contentLabel!)
        }
        
        contentLabel?.text = text
        contentLabel?.font = UIFont.systemFont(ofSize: s_fontSize, weight: .medium)
        contentLabel?.textColor = s_textColor
        contentLabel?.textAlignment = .center
        
        // 计算尺寸
        let size = (text as NSString).size(withAttributes: [.font: contentLabel!.font!])
        let width = max(size.width + s_padding.left + s_padding.right, size.height + s_padding.top + s_padding.bottom)
        let height = size.height + s_padding.top + s_padding.bottom
        
        self.frame.size = CGSize(width: width, height: height)
        contentLabel?.frame = self.bounds
        
        // 设置圆角
        self.layer.cornerRadius = height / 2
        self.layer.masksToBounds = true
    }
    
    private func calculatePosition(in targetView: UIView) -> CGPoint {
        var position: CGPoint = .zero
        
        switch s_position {
        case .topRight:
            position = CGPoint(x: targetView.bounds.width - self.bounds.width / 2, y: -self.bounds.height / 2)
        case .topLeft:
            position = CGPoint(x: -self.bounds.width / 2, y: -self.bounds.height / 2)
        case .bottomRight:
            position = CGPoint(x: targetView.bounds.width - self.bounds.width / 2, y: targetView.bounds.height - self.bounds.height / 2)
        case .bottomLeft:
            position = CGPoint(x: -self.bounds.width / 2, y: targetView.bounds.height - self.bounds.height / 2)
        case .center:
            position = CGPoint(x: targetView.bounds.width / 2 - self.bounds.width / 2, y: targetView.bounds.height / 2 - self.bounds.height / 2)
        case .custom(let x, let y):
            position = CGPoint(x: x, y: y)
        }
        
        // 应用偏移
        position.x += s_offset.x
        position.y += s_offset.y
        
        return position
    }
    
    // MARK: - Public Methods
    
    /// 添加到目标视图
    @discardableResult
    public func attach(to view: UIView) -> Self {
        self.targetView = view
        view.addSubview(self)
        
        s_render()
        
        // 计算位置
        let position = calculatePosition(in: view)
        self.frame.origin = position
        
        // 入场动画
        if s_animated {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: []) {
                self.transform = .identity
            }
        }
        
        return self
    }
    
    /// 更新数字（带动画）
    @discardableResult
    public func updateCount(_ count: Int, animated: Bool = true) -> Self {
        let oldCount = s_count
        s_count = count
        
        if animated && s_animated && oldCount != count {
            // 缩放动画
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                self.s_render()
                if let targetView = self.targetView {
                    self.frame.origin = self.calculatePosition(in: targetView)
                }
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                }
            }
        } else {
            s_render()
            if let targetView = targetView {
                self.frame.origin = calculatePosition(in: targetView)
            }
        }
        
        return self
    }
    
    /// 增加数字
    @discardableResult
    public func increment(by value: Int = 1) -> Self {
        updateCount(s_count + value)
        return self
    }
    
    /// 减少数字
    @discardableResult
    public func decrement(by value: Int = 1) -> Self {
        updateCount(max(0, s_count - value))
        return self
    }
    
    /// 显示角标（带动画）
    @discardableResult
    public func show(animated: Bool = true) -> Self {
        if animated && s_animated {
            self.alpha = 0
            self.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1
            }
        } else {
            self.isHidden = false
        }
        return self
    }
    
    /// 隐藏角标（带动画）
    @discardableResult
    public func hide(animated: Bool = true) -> Self {
        if animated && s_animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { _ in
                self.isHidden = true
                self.alpha = 1
            }
        } else {
            self.isHidden = true
        }
        return self
    }
}

// MARK: - UIView Extension for Badge
public extension UIView {
    
    /// 添加角标
    @discardableResult
    func addBadge(_ configure: (SBadge) -> SBadge) -> SBadge {
        let badge = SBadge()
        let configuredBadge = configure(badge)
        configuredBadge.attach(to: self)
        return configuredBadge
    }
    
    /// 移除角标
    func removeBadge() {
        self.subviews.filter { $0 is SBadge }.forEach { $0.removeFromSuperview() }
    }
    
    /// 获取角标
    var badge: SBadge? {
        return self.subviews.first { $0 is SBadge } as? SBadge
    }
}

