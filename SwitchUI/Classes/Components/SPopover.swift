//
//  SPopover.swift
//  SwitchUI
//
//  Created by Swain on 2025/01/06.
//  Copyright © 2025 swain. All rights reserved.
//

import UIKit

// MARK: - SPopoverDirection
public enum SPopoverDirection {
    case top            // 上方
    case bottom         // 下方
    case left           // 左侧
    case right          // 右侧
    case auto           // 自动选择最佳位置
}

// MARK: - SPopover
public class SPopover: UIView {
    
    // 内容文本
    public var s_text: String?
    
    // 自定义内容视图
    public var s_contentView: UIView?
    
    // 文字颜色
    public var s_textColor: UIColor = .white
    
    // 文字大小
    public var s_fontSize: CGFloat = 14
    
    // 背景色
    public var s_backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.8)
    
    // 圆角
    public var s_cornerRadius: CGFloat = 8
    
    // 内边距
    public var s_padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    
    // 箭头方向
    public var s_direction: SPopoverDirection = .auto
    
    // 箭头大小
    public var s_arrowSize: CGSize = CGSize(width: 12, height: 6)
    
    // 是否显示箭头
    public var s_showArrow: Bool = true
    
    // 最大宽度
    public var s_maxWidth: CGFloat = 250
    
    // 与目标视图的距离
    public var s_offset: CGFloat = 8
    
    // 自动隐藏延迟（秒，0 表示不自动隐藏）
    public var s_autoDismissDelay: TimeInterval = 0
    
    // 是否点击任意位置关闭
    public var s_closeOnTap: Bool = true
    
    // 显示动画
    public var s_animated: Bool = true
    
    // 显示/隐藏回调
    public var onShow: (() -> Void)?
    public var onDismiss: (() -> Void)?
    
    // 私有属性
    private var containerView: UIView?
    private var arrowLayer: CAShapeLayer?
    private var contentLabel: UILabel?
    private var targetView: UIView?
    private var calculatedDirection: SPopoverDirection = .bottom
    private var autoDismissTimer: Timer?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Chainable Methods
    
    @discardableResult
    public func s_text(_ text: String) -> Self {
        self.s_text = text
        return self
    }
    
    @discardableResult
    public func s_contentView(_ view: UIView) -> Self {
        self.s_contentView = view
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
    public func s_direction(_ direction: SPopoverDirection) -> Self {
        self.s_direction = direction
        return self
    }
    
    @discardableResult
    public func s_arrowSize(_ size: CGSize) -> Self {
        self.s_arrowSize = size
        return self
    }
    
    @discardableResult
    public func s_showArrow(_ show: Bool) -> Self {
        self.s_showArrow = show
        return self
    }
    
    @discardableResult
    public func s_maxWidth(_ width: CGFloat) -> Self {
        self.s_maxWidth = width
        return self
    }
    
    @discardableResult
    public func s_offset(_ offset: CGFloat) -> Self {
        self.s_offset = offset
        return self
    }
    
    @discardableResult
    public func s_autoDismissDelay(_ delay: TimeInterval) -> Self {
        self.s_autoDismissDelay = delay
        return self
    }
    
    @discardableResult
    public func s_closeOnTap(_ close: Bool) -> Self {
        self.s_closeOnTap = close
        return self
    }
    
    @discardableResult
    public func s_animated(_ animated: Bool) -> Self {
        self.s_animated = animated
        return self
    }
    
    @discardableResult
    public func onShow(_ callback: @escaping () -> Void) -> Self {
        self.onShow = callback
        return self
    }
    
    @discardableResult
    public func onDismiss(_ callback: @escaping () -> Void) -> Self {
        self.onDismiss = callback
        return self
    }
    
    // MARK: - Show & Dismiss
    
    @discardableResult
    public func show(from view: UIView) -> Self {
        self.targetView = view
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return self
        }
        
        // 获取目标视图在 window 中的位置
        let targetFrame = view.convert(view.bounds, to: window)
        
        // 计算方向
        calculatedDirection = calculateDirection(targetFrame: targetFrame, in: window)
        
        // 构建视图
        buildPopover()
        
        // 计算位置
        let popoverFrame = calculateFrame(targetFrame: targetFrame, in: window)
        self.frame = popoverFrame
        
        // 添加到 window
        window.addSubview(self)
        
        // 显示动画
        if s_animated {
            showAnimation()
        } else {
            onShow?()
        }
        
        // 自动隐藏
        if s_autoDismissDelay > 0 {
            autoDismissTimer = Timer.scheduledTimer(withTimeInterval: s_autoDismissDelay, repeats: false) { [weak self] _ in
                self?.dismiss()
            }
        }
        
        return self
    }
    
    @discardableResult
    public func dismiss(animated: Bool = true) -> Self {
        autoDismissTimer?.invalidate()
        autoDismissTimer = nil
        
        if animated && s_animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 0
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
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
    
    private func buildPopover() {
        // 清除旧视图
        self.subviews.forEach { $0.removeFromSuperview() }
        arrowLayer?.removeFromSuperlayer()
        
        // 创建容器
        containerView = UIView()
        containerView?.backgroundColor = s_backgroundColor
        containerView?.layer.cornerRadius = s_cornerRadius
        containerView?.layer.masksToBounds = true
        self.addSubview(containerView!)
        
        // 添加内容
        if let contentView = s_contentView {
            containerView?.addSubview(contentView)
            contentView.frame = CGRect(origin: CGPoint(x: s_padding.left, y: s_padding.top),
                                      size: contentView.bounds.size)
        } else if let text = s_text {
            contentLabel = UILabel()
            contentLabel?.text = text
            contentLabel?.font = UIFont.systemFont(ofSize: s_fontSize)
            contentLabel?.textColor = s_textColor
            contentLabel?.numberOfLines = 0
            contentLabel?.textAlignment = .center
            containerView?.addSubview(contentLabel!)
            
            let maxContentWidth = s_maxWidth - s_padding.left - s_padding.right
            let textSize = (text as NSString).boundingRect(
                with: CGSize(width: maxContentWidth, height: CGFloat.greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [.font: contentLabel!.font!],
                context: nil
            ).size
            
            contentLabel?.frame = CGRect(x: s_padding.left, y: s_padding.top, width: textSize.width, height: textSize.height)
        }
        
        // 绘制箭头
        if s_showArrow {
            drawArrow()
        }
    }
    
    private func drawArrow() {
        arrowLayer = CAShapeLayer()
        arrowLayer?.fillColor = s_backgroundColor.cgColor
        
        let path = UIBezierPath()
        let arrowWidth = s_arrowSize.width
        let arrowHeight = s_arrowSize.height
        
        switch calculatedDirection {
        case .bottom:
            // 箭头在上方
            path.move(to: CGPoint(x: (containerView!.bounds.width - arrowWidth) / 2, y: 0))
            path.addLine(to: CGPoint(x: containerView!.bounds.width / 2, y: -arrowHeight))
            path.addLine(to: CGPoint(x: (containerView!.bounds.width + arrowWidth) / 2, y: 0))
            
        case .top:
            // 箭头在下方
            let y = containerView!.bounds.height
            path.move(to: CGPoint(x: (containerView!.bounds.width - arrowWidth) / 2, y: y))
            path.addLine(to: CGPoint(x: containerView!.bounds.width / 2, y: y + arrowHeight))
            path.addLine(to: CGPoint(x: (containerView!.bounds.width + arrowWidth) / 2, y: y))
            
        case .right:
            // 箭头在左侧
            path.move(to: CGPoint(x: 0, y: (containerView!.bounds.height - arrowWidth) / 2))
            path.addLine(to: CGPoint(x: -arrowHeight, y: containerView!.bounds.height / 2))
            path.addLine(to: CGPoint(x: 0, y: (containerView!.bounds.height + arrowWidth) / 2))
            
        case .left:
            // 箭头在右侧
            let x = containerView!.bounds.width
            path.move(to: CGPoint(x: x, y: (containerView!.bounds.height - arrowWidth) / 2))
            path.addLine(to: CGPoint(x: x + arrowHeight, y: containerView!.bounds.height / 2))
            path.addLine(to: CGPoint(x: x, y: (containerView!.bounds.height + arrowWidth) / 2))
            
        case .auto:
            break
        }
        
        path.close()
        arrowLayer?.path = path.cgPath
        containerView?.layer.addSublayer(arrowLayer!)
    }
    
    private func calculateDirection(targetFrame: CGRect, in window: UIView) -> SPopoverDirection {
        if s_direction != .auto {
            return s_direction
        }
        
        let contentSize = calculateContentSize()
        let spaceTop = targetFrame.minY
        let spaceBottom = window.bounds.height - targetFrame.maxY
        let spaceLeft = targetFrame.minX
        let spaceRight = window.bounds.width - targetFrame.maxX
        
        // 优先显示在空间最大的方向
        let maxSpace = max(spaceTop, spaceBottom, spaceLeft, spaceRight)
        
        if maxSpace == spaceBottom && spaceBottom >= contentSize.height + s_offset {
            return .bottom
        } else if maxSpace == spaceTop && spaceTop >= contentSize.height + s_offset {
            return .top
        } else if maxSpace == spaceRight && spaceRight >= contentSize.width + s_offset {
            return .right
        } else if maxSpace == spaceLeft && spaceLeft >= contentSize.width + s_offset {
            return .left
        }
        
        return .bottom  // 默认下方
    }
    
    private func calculateContentSize() -> CGSize {
        if let contentView = s_contentView {
            return CGSize(width: contentView.bounds.width + s_padding.left + s_padding.right,
                         height: contentView.bounds.height + s_padding.top + s_padding.bottom)
        } else if let text = s_text {
            let maxContentWidth = s_maxWidth - s_padding.left - s_padding.right
            let textSize = (text as NSString).boundingRect(
                with: CGSize(width: maxContentWidth, height: CGFloat.greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [.font: UIFont.systemFont(ofSize: s_fontSize)],
                context: nil
            ).size
            
            return CGSize(width: textSize.width + s_padding.left + s_padding.right,
                         height: textSize.height + s_padding.top + s_padding.bottom)
        }
        
        return .zero
    }
    
    private func calculateFrame(targetFrame: CGRect, in window: UIView) -> CGRect {
        let contentSize = calculateContentSize()
        var frame = CGRect.zero
        
        switch calculatedDirection {
        case .bottom:
            frame.origin.x = targetFrame.midX - contentSize.width / 2
            frame.origin.y = targetFrame.maxY + s_offset + (s_showArrow ? s_arrowSize.height : 0)
            
        case .top:
            frame.origin.x = targetFrame.midX - contentSize.width / 2
            frame.origin.y = targetFrame.minY - s_offset - contentSize.height - (s_showArrow ? s_arrowSize.height : 0)
            
        case .right:
            frame.origin.x = targetFrame.maxX + s_offset + (s_showArrow ? s_arrowSize.height : 0)
            frame.origin.y = targetFrame.midY - contentSize.height / 2
            
        case .left:
            frame.origin.x = targetFrame.minX - s_offset - contentSize.width - (s_showArrow ? s_arrowSize.height : 0)
            frame.origin.y = targetFrame.midY - contentSize.height / 2
            
        case .auto:
            break
        }
        
        frame.size = contentSize
        
        // 确保不超出屏幕
        frame.origin.x = max(8, min(frame.origin.x, window.bounds.width - frame.width - 8))
        frame.origin.y = max(8, min(frame.origin.y, window.bounds.height - frame.height - 8))
        
        return frame
    }
    
    private func showAnimation() {
        self.alpha = 0
        
        var transform: CGAffineTransform
        switch calculatedDirection {
        case .bottom:
            transform = CGAffineTransform(translationX: 0, y: -10)
        case .top:
            transform = CGAffineTransform(translationX: 0, y: 10)
        case .left:
            transform = CGAffineTransform(translationX: 10, y: 0)
        case .right:
            transform = CGAffineTransform(translationX: -10, y: 0)
        case .auto:
            transform = .identity
        }
        
        self.transform = transform
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: []) {
            self.alpha = 1
            self.transform = .identity
        } completion: { _ in
            self.onShow?()
        }
    }
    
    @objc private func handleTap() {
        if s_closeOnTap {
            dismiss()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        containerView?.frame = self.bounds
    }
    
    deinit {
        autoDismissTimer?.invalidate()
    }
}

// MARK: - UIView Extension for Popover
public extension UIView {
    
    /// 显示气泡提示
    @discardableResult
    func showPopover(_ configure: (SPopover) -> SPopover) -> SPopover {
        let popover = SPopover()
        let configuredPopover = configure(popover)
        configuredPopover.show(from: self)
        return configuredPopover
    }
}

