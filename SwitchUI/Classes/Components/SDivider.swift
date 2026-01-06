//
//  SDivider.swift
//  SwitchUI
//
//  Created by Swain on 2025/01/06.
//  Copyright © 2025 swain. All rights reserved.
//

import UIKit

// MARK: - SDividerDirection
public enum SDividerDirection {
    case horizontal     // 水平分割线
    case vertical       // 垂直分割线
}

// MARK: - SDivider
public class SDivider: UIView {
    
    // 方向
    public var s_direction: SDividerDirection = .horizontal
    
    // 颜色
    public var s_color: UIColor = .lightGray
    
    // 厚度
    public var s_thickness: CGFloat = 1
    
    // 长度（可选，不设置则填充父容器）
    public var s_length: CGFloat?
    
    // 边距
    public var s_inset: UIEdgeInsets = .zero
    
    // 虚线样式（可选）
    public var s_dashPattern: [NSNumber]?  // 例如 [4, 2] 表示 4 点实线，2 点空白
    
    // 是否显示文字
    public var s_text: String?
    
    // 文字颜色
    public var s_textColor: UIColor = .gray
    
    // 文字大小
    public var s_fontSize: CGFloat = 12
    
    // 文字位置 (0.0 - 1.0, 0.5 表示居中)
    public var s_textPosition: CGFloat = 0.5
    
    // 文字内边距
    public var s_textPadding: CGFloat = 8
    
    // 渐变色（可选）
    public var s_gradientColors: [UIColor]?
    
    // 私有视图
    private var lineLayer: CAShapeLayer?
    private var gradientLayer: CAGradientLayer?
    private var textLabel: UILabel?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .clear
    }
    
    // MARK: - Chainable Methods
    
    @discardableResult
    public func s_direction(_ direction: SDividerDirection) -> Self {
        self.s_direction = direction
        return self
    }
    
    @discardableResult
    public func s_color(_ color: UIColor) -> Self {
        self.s_color = color
        return self
    }
    
    @discardableResult
    public func s_color(_ hexString: String) -> Self {
        self.s_color = hexString.hexColor()
        return self
    }
    
    @discardableResult
    public func s_thickness(_ thickness: CGFloat) -> Self {
        self.s_thickness = thickness
        return self
    }
    
    @discardableResult
    public func s_length(_ length: CGFloat) -> Self {
        self.s_length = length
        return self
    }
    
    @discardableResult
    public func s_inset(_ inset: UIEdgeInsets) -> Self {
        self.s_inset = inset
        return self
    }
    
    @discardableResult
    public func s_inset(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> Self {
        self.s_inset = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
        return self
    }
    
    @discardableResult
    public func s_dashPattern(_ pattern: [NSNumber]) -> Self {
        self.s_dashPattern = pattern
        return self
    }
    
    @discardableResult
    public func s_text(_ text: String) -> Self {
        self.s_text = text
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
    public func s_textPosition(_ position: CGFloat) -> Self {
        self.s_textPosition = min(max(position, 0), 1)
        return self
    }
    
    @discardableResult
    public func s_textPadding(_ padding: CGFloat) -> Self {
        self.s_textPadding = padding
        return self
    }
    
    @discardableResult
    public func s_gradientColors(_ colors: [UIColor]) -> Self {
        self.s_gradientColors = colors
        return self
    }
    
    // MARK: - Render
    
    @discardableResult
    public func s_render() -> Self {
        // 清除旧的 layers 和 views
        lineLayer?.removeFromSuperlayer()
        gradientLayer?.removeFromSuperlayer()
        textLabel?.removeFromSuperview()
        
        if let text = s_text, !text.isEmpty {
            renderWithText()
        } else {
            renderSimpleLine()
        }
        
        return self
    }
    
    // MARK: - Private Methods
    
    private func renderSimpleLine() {
        let path = UIBezierPath()
        
        switch s_direction {
        case .horizontal:
            let y = bounds.height / 2
            let startX = s_inset.left
            let endX = bounds.width - s_inset.right
            path.move(to: CGPoint(x: startX, y: y))
            path.addLine(to: CGPoint(x: endX, y: y))
            
        case .vertical:
            let x = bounds.width / 2
            let startY = s_inset.top
            let endY = bounds.height - s_inset.bottom
            path.move(to: CGPoint(x: x, y: startY))
            path.addLine(to: CGPoint(x: x, y: endY))
        }
        
        lineLayer = CAShapeLayer()
        lineLayer?.path = path.cgPath
        lineLayer?.lineWidth = s_thickness
        
        // 设置虚线
        if let dashPattern = s_dashPattern {
            lineLayer?.lineDashPattern = dashPattern
        }
        
        // 设置渐变色或单色
        if let gradientColors = s_gradientColors, gradientColors.count > 1 {
            lineLayer?.strokeColor = UIColor.black.cgColor
            
            gradientLayer = CAGradientLayer()
            gradientLayer?.frame = bounds
            gradientLayer?.colors = gradientColors.map { $0.cgColor }
            
            if s_direction == .horizontal {
                gradientLayer?.startPoint = CGPoint(x: 0, y: 0.5)
                gradientLayer?.endPoint = CGPoint(x: 1, y: 0.5)
            } else {
                gradientLayer?.startPoint = CGPoint(x: 0.5, y: 0)
                gradientLayer?.endPoint = CGPoint(x: 0.5, y: 1)
            }
            
            gradientLayer?.mask = lineLayer
            self.layer.addSublayer(gradientLayer!)
        } else {
            lineLayer?.strokeColor = s_color.cgColor
            self.layer.addSublayer(lineLayer!)
        }
    }
    
    private func renderWithText() {
        guard let text = s_text else { return }
        
        // 创建文字标签
        if textLabel == nil {
            textLabel = UILabel()
            self.addSubview(textLabel!)
        }
        
        textLabel?.text = text
        textLabel?.font = UIFont.systemFont(ofSize: s_fontSize)
        textLabel?.textColor = s_textColor
        textLabel?.textAlignment = .center
        textLabel?.sizeToFit()
        
        let textSize = textLabel!.bounds.size
        
        switch s_direction {
        case .horizontal:
            // 计算文字位置
            let textX = s_inset.left + (bounds.width - s_inset.left - s_inset.right - textSize.width) * s_textPosition
            let textY = (bounds.height - textSize.height) / 2
            textLabel?.frame = CGRect(x: textX, y: textY, width: textSize.width, height: textSize.height)
            
            // 左侧线条
            let leftPath = UIBezierPath()
            let y = bounds.height / 2
            leftPath.move(to: CGPoint(x: s_inset.left, y: y))
            leftPath.addLine(to: CGPoint(x: textX - s_textPadding, y: y))
            
            let leftLayer = CAShapeLayer()
            leftLayer.path = leftPath.cgPath
            leftLayer.strokeColor = s_color.cgColor
            leftLayer.lineWidth = s_thickness
            if let dashPattern = s_dashPattern {
                leftLayer.lineDashPattern = dashPattern
            }
            self.layer.addSublayer(leftLayer)
            
            // 右侧线条
            let rightPath = UIBezierPath()
            rightPath.move(to: CGPoint(x: textX + textSize.width + s_textPadding, y: y))
            rightPath.addLine(to: CGPoint(x: bounds.width - s_inset.right, y: y))
            
            let rightLayer = CAShapeLayer()
            rightLayer.path = rightPath.cgPath
            rightLayer.strokeColor = s_color.cgColor
            rightLayer.lineWidth = s_thickness
            if let dashPattern = s_dashPattern {
                rightLayer.lineDashPattern = dashPattern
            }
            self.layer.addSublayer(rightLayer)
            
        case .vertical:
            // 计算文字位置
            let textY = s_inset.top + (bounds.height - s_inset.top - s_inset.bottom - textSize.height) * s_textPosition
            let textX = (bounds.width - textSize.width) / 2
            textLabel?.frame = CGRect(x: textX, y: textY, width: textSize.width, height: textSize.height)
            
            // 上侧线条
            let topPath = UIBezierPath()
            let x = bounds.width / 2
            topPath.move(to: CGPoint(x: x, y: s_inset.top))
            topPath.addLine(to: CGPoint(x: x, y: textY - s_textPadding))
            
            let topLayer = CAShapeLayer()
            topLayer.path = topPath.cgPath
            topLayer.strokeColor = s_color.cgColor
            topLayer.lineWidth = s_thickness
            if let dashPattern = s_dashPattern {
                topLayer.lineDashPattern = dashPattern
            }
            self.layer.addSublayer(topLayer)
            
            // 下侧线条
            let bottomPath = UIBezierPath()
            bottomPath.move(to: CGPoint(x: x, y: textY + textSize.height + s_textPadding))
            bottomPath.addLine(to: CGPoint(x: x, y: bounds.height - s_inset.bottom))
            
            let bottomLayer = CAShapeLayer()
            bottomLayer.path = bottomPath.cgPath
            bottomLayer.strokeColor = s_color.cgColor
            bottomLayer.lineWidth = s_thickness
            if let dashPattern = s_dashPattern {
                bottomLayer.lineDashPattern = dashPattern
            }
            self.layer.addSublayer(bottomLayer)
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        switch s_direction {
        case .horizontal:
            return CGSize(width: s_length ?? UIView.noIntrinsicMetric, height: s_thickness + s_inset.top + s_inset.bottom)
        case .vertical:
            return CGSize(width: s_thickness + s_inset.left + s_inset.right, height: s_length ?? UIView.noIntrinsicMetric)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        s_render()
    }
}

