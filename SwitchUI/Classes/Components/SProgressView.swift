//
//  SProgressView.swift
//  SwitchUI
//
//  Created by Swain on 2025/01/06.
//  Copyright © 2025 swain. All rights reserved.
//

import UIKit

// MARK: - SProgressStyle
public enum SProgressStyle {
    case linear         // 线性进度条
    case circular       // 圆形进度条
    case ring           // 环形进度条
}

// MARK: - SProgressView
public class SProgressView: UIView {
    
    // 进度值 (0.0 - 1.0)
    public var s_progress: CGFloat = 0
    
    // 样式
    public var s_style: SProgressStyle = .linear
    
    // 进度条颜色
    public var s_progressColor: UIColor = .systemBlue
    
    // 背景轨道颜色
    public var s_trackColor: UIColor = UIColor.systemGray.withAlphaComponent(0.3)
    
    // 线性进度条高度
    public var s_height: CGFloat = 4
    
    // 圆形/环形进度条线宽
    public var s_lineWidth: CGFloat = 4
    
    // 圆角
    public var s_cornerRadius: CGFloat?
    
    // 是否显示百分比文字
    public var s_showPercentage: Bool = false
    
    // 百分比文字颜色
    public var s_percentageColor: UIColor = .darkGray
    
    // 百分比文字大小
    public var s_percentageFontSize: CGFloat = 12
    
    // 是否动画
    public var s_animated: Bool = true
    
    // 动画时长
    public var s_animationDuration: TimeInterval = 0.3
    
    // 渐变色（可选）
    public var s_gradientColors: [UIColor]?
    
    // 进度完成回调
    public var onProgressComplete: (() -> Void)?
    
    // 私有视图
    private var trackLayer: CAShapeLayer?
    private var progressLayer: CAShapeLayer?
    private var percentageLabel: UILabel?
    private var gradientLayer: CAGradientLayer?
    
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
    public func s_progress(_ progress: CGFloat) -> Self {
        self.s_progress = min(max(progress, 0), 1)
        return self
    }
    
    @discardableResult
    public func s_style(_ style: SProgressStyle) -> Self {
        self.s_style = style
        return self
    }
    
    @discardableResult
    public func s_progressColor(_ color: UIColor) -> Self {
        self.s_progressColor = color
        return self
    }
    
    @discardableResult
    public func s_progressColor(_ hexString: String) -> Self {
        self.s_progressColor = hexString.hexColor()
        return self
    }
    
    @discardableResult
    public func s_trackColor(_ color: UIColor) -> Self {
        self.s_trackColor = color
        return self
    }
    
    @discardableResult
    public func s_trackColor(_ hexString: String) -> Self {
        self.s_trackColor = hexString.hexColor()
        return self
    }
    
    @discardableResult
    public func s_height(_ height: CGFloat) -> Self {
        self.s_height = height
        return self
    }
    
    @discardableResult
    public func s_lineWidth(_ width: CGFloat) -> Self {
        self.s_lineWidth = width
        return self
    }
    
    @discardableResult
    public func s_cornerRadius(_ radius: CGFloat) -> Self {
        self.s_cornerRadius = radius
        return self
    }
    
    @discardableResult
    public func s_showPercentage(_ show: Bool) -> Self {
        self.s_showPercentage = show
        return self
    }
    
    @discardableResult
    public func s_percentageColor(_ color: UIColor) -> Self {
        self.s_percentageColor = color
        return self
    }
    
    @discardableResult
    public func s_percentageColor(_ hexString: String) -> Self {
        self.s_percentageColor = hexString.hexColor()
        return self
    }
    
    @discardableResult
    public func s_percentageFontSize(_ size: CGFloat) -> Self {
        self.s_percentageFontSize = size
        return self
    }
    
    @discardableResult
    public func s_animated(_ animated: Bool) -> Self {
        self.s_animated = animated
        return self
    }
    
    @discardableResult
    public func s_animationDuration(_ duration: TimeInterval) -> Self {
        self.s_animationDuration = duration
        return self
    }
    
    @discardableResult
    public func s_gradientColors(_ colors: [UIColor]) -> Self {
        self.s_gradientColors = colors
        return self
    }
    
    @discardableResult
    public func onProgressComplete(_ callback: @escaping () -> Void) -> Self {
        self.onProgressComplete = callback
        return self
    }
    
    // MARK: - Render
    
    @discardableResult
    public func s_render() -> Self {
        // 清除旧的 layers
        trackLayer?.removeFromSuperlayer()
        progressLayer?.removeFromSuperlayer()
        gradientLayer?.removeFromSuperlayer()
        percentageLabel?.removeFromSuperview()
        
        switch s_style {
        case .linear:
            renderLinearProgress()
        case .circular:
            renderCircularProgress()
        case .ring:
            renderRingProgress()
        }
        
        // 设置百分比标签
        if s_showPercentage {
            setupPercentageLabel()
        }
        
        return self
    }
    
    // MARK: - Private Methods
    
    private func renderLinearProgress() {
        let progressHeight = s_height
        let cornerRadius = s_cornerRadius ?? progressHeight / 2
        
        // 轨道层
        trackLayer = CAShapeLayer()
        trackLayer?.frame = bounds
        trackLayer?.fillColor = s_trackColor.cgColor
        trackLayer?.cornerRadius = cornerRadius
        trackLayer?.frame = CGRect(x: 0, y: (bounds.height - progressHeight) / 2, width: bounds.width, height: progressHeight)
        self.layer.addSublayer(trackLayer!)
        
        // 进度层
        progressLayer = CAShapeLayer()
        progressLayer?.frame = CGRect(x: 0, y: (bounds.height - progressHeight) / 2, width: bounds.width * s_progress, height: progressHeight)
        progressLayer?.cornerRadius = cornerRadius
        
        if let gradientColors = s_gradientColors, gradientColors.count > 1 {
            // 使用渐变色
            gradientLayer = CAGradientLayer()
            gradientLayer?.frame = progressLayer!.frame
            gradientLayer?.colors = gradientColors.map { $0.cgColor }
            gradientLayer?.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer?.endPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer?.cornerRadius = cornerRadius
            self.layer.addSublayer(gradientLayer!)
        } else {
            // 使用单色
            progressLayer?.fillColor = s_progressColor.cgColor
            self.layer.addSublayer(progressLayer!)
        }
    }
    
    private func renderCircularProgress() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - s_lineWidth / 2
        
        // 轨道层
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        trackLayer = CAShapeLayer()
        trackLayer?.path = trackPath.cgPath
        trackLayer?.strokeColor = s_trackColor.cgColor
        trackLayer?.fillColor = UIColor.clear.cgColor
        trackLayer?.lineWidth = s_lineWidth
        self.layer.addSublayer(trackLayer!)
        
        // 进度层
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + .pi * 2 * s_progress
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressLayer = CAShapeLayer()
        progressLayer?.path = progressPath.cgPath
        progressLayer?.strokeColor = s_progressColor.cgColor
        progressLayer?.fillColor = UIColor.clear.cgColor
        progressLayer?.lineWidth = s_lineWidth
        progressLayer?.lineCap = .round
        self.layer.addSublayer(progressLayer!)
    }
    
    private func renderRingProgress() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - s_lineWidth / 2
        
        // 轨道层（完整圆环）
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        trackLayer = CAShapeLayer()
        trackLayer?.path = trackPath.cgPath
        trackLayer?.strokeColor = s_trackColor.cgColor
        trackLayer?.fillColor = UIColor.clear.cgColor
        trackLayer?.lineWidth = s_lineWidth
        self.layer.addSublayer(trackLayer!)
        
        // 进度层（部分圆环）
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + .pi * 2 * s_progress
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressLayer = CAShapeLayer()
        progressLayer?.path = progressPath.cgPath
        progressLayer?.strokeColor = s_progressColor.cgColor
        progressLayer?.fillColor = UIColor.clear.cgColor
        progressLayer?.lineWidth = s_lineWidth
        progressLayer?.lineCap = .round
        
        if let gradientColors = s_gradientColors, gradientColors.count > 1 {
            // 使用渐变色
            gradientLayer = CAGradientLayer()
            gradientLayer?.frame = bounds
            gradientLayer?.colors = gradientColors.map { $0.cgColor }
            gradientLayer?.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer?.endPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer?.mask = progressLayer
            self.layer.addSublayer(gradientLayer!)
        } else {
            self.layer.addSublayer(progressLayer!)
        }
    }
    
    private func setupPercentageLabel() {
        if percentageLabel == nil {
            percentageLabel = UILabel()
            self.addSubview(percentageLabel!)
        }
        
        percentageLabel?.font = UIFont.systemFont(ofSize: s_percentageFontSize, weight: .medium)
        percentageLabel?.textColor = s_percentageColor
        percentageLabel?.textAlignment = .center
        
        let percentage = Int(s_progress * 100)
        percentageLabel?.text = "\(percentage)%"
        
        if s_style == .linear {
            // 线性进度条：标签在右侧
            percentageLabel?.frame = CGRect(x: bounds.width + 8, y: 0, width: 50, height: bounds.height)
        } else {
            // 圆形/环形进度条：标签在中心
            percentageLabel?.frame = bounds
        }
    }
    
    // MARK: - Public Methods
    
    /// 设置进度（支持动画）
    @discardableResult
    public func setProgress(_ progress: CGFloat, animated: Bool = true) -> Self {
        let newProgress = min(max(progress, 0), 1)
        
        if animated && s_animated {
            let oldProgress = s_progress
            s_progress = newProgress
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = oldProgress
            animation.toValue = newProgress
            animation.duration = s_animationDuration
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            progressLayer?.add(animation, forKey: "progressAnimation")
            
            // 动画更新百分比文字
            if s_showPercentage {
                UIView.animate(withDuration: s_animationDuration) {
                    let percentage = Int(newProgress * 100)
                    self.percentageLabel?.text = "\(percentage)%"
                }
            }
            
            // 检查是否完成
            if newProgress >= 1.0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + s_animationDuration) {
                    self.onProgressComplete?()
                }
            }
        } else {
            s_progress = newProgress
            s_render()
            
            if newProgress >= 1.0 {
                onProgressComplete?()
            }
        }
        
        return self
    }
    
    /// 重置进度
    @discardableResult
    public func reset() -> Self {
        setProgress(0, animated: false)
        return self
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        s_render()
    }
}

