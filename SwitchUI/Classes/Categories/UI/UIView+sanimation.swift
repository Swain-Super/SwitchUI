//
//  UIView+sAnimation.swift
//  SwitchUI
//
//  Created by SwitchUI on 2024/01/06.
//

import UIKit

// MARK: - 动画配置类型

/// 动画曲线类型
public enum SAnimationCurve {
    case linear                                    // 线性
    case easeIn                                    // 缓入
    case easeOut                                   // 缓出
    case easeInOut                                 // 缓入缓出
    case spring(damping: CGFloat, velocity: CGFloat) // 弹簧动画
    case custom(CGFloat, CGFloat, CGFloat, CGFloat)  // 自定义贝塞尔曲线
    
    /// 转换为 UIView.AnimationOptions
    var animationOptions: UIView.AnimationOptions {
        switch self {
        case .linear:
            return .curveLinear
        case .easeIn:
            return .curveEaseIn
        case .easeOut:
            return .curveEaseOut
        case .easeInOut:
            return .curveEaseInOut
        default:
            return .curveEaseInOut
        }
    }
    
    /// 是否是弹簧动画
    var isSpring: Bool {
        if case .spring = self {
            return true
        }
        return false
    }
    
    /// 获取弹簧动画参数
    var springParams: (damping: CGFloat, velocity: CGFloat) {
        if case .spring(let damping, let velocity) = self {
            return (damping, velocity)
        }
        return (0.7, 0.5)
    }
}

/// 过渡效果类型
public enum STransition {
    case opacity                    // 透明度渐变
    case scale                      // 缩放
    case slide(SSlideDirection)     // 滑动
    case move(CGFloat, CGFloat)     // 移动
    case rotate(CGFloat)            // 旋转
    case combined([STransition])    // 组合效果
    
    /// 滑动方向
    public enum SSlideDirection {
        case top, bottom, left, right
    }
}

/// 动画配置
public class SAnimation {
    var duration: TimeInterval = 0.3
    var delay: TimeInterval = 0
    var curve: SAnimationCurve = .easeInOut
    var transition: STransition?
    var repeatCount: Float = 0  // 0 表示不重复
    var autoreverses: Bool = false
    var completion: (() -> Void)?
    
    public init(
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        curve: SAnimationCurve = .easeInOut
    ) {
        self.duration = duration
        self.delay = delay
        self.curve = curve
    }
    
    /// 便捷构造方法 - 线性动画
    public static func linear(duration: TimeInterval = 0.3) -> SAnimation {
        return SAnimation(duration: duration, curve: .linear)
    }
    
    /// 便捷构造方法 - 缓入动画
    public static func easeIn(duration: TimeInterval = 0.3) -> SAnimation {
        return SAnimation(duration: duration, curve: .easeIn)
    }
    
    /// 便捷构造方法 - 缓出动画
    public static func easeOut(duration: TimeInterval = 0.3) -> SAnimation {
        return SAnimation(duration: duration, curve: .easeOut)
    }
    
    /// 便捷构造方法 - 缓入缓出动画
    public static func easeInOut(duration: TimeInterval = 0.3) -> SAnimation {
        return SAnimation(duration: duration, curve: .easeInOut)
    }
    
    /// 便捷构造方法 - 弹簧动画
    public static func spring(
        duration: TimeInterval = 0.5,
        damping: CGFloat = 0.7,
        velocity: CGFloat = 0.5
    ) -> SAnimation {
        return SAnimation(duration: duration, curve: .spring(damping: damping, velocity: velocity))
    }
    
    /// 设置延迟
    @discardableResult
    public func delayed(_ delay: TimeInterval) -> SAnimation {
        self.delay = delay
        return self
    }
    
    /// 设置重复次数
    @discardableResult
    public func `repeat`(_ count: Float = Float.infinity, autoreverses: Bool = false) -> SAnimation {
        self.repeatCount = count
        self.autoreverses = autoreverses
        return self
    }
    
    /// 设置过渡效果
    @discardableResult
    public func transition(_ transition: STransition) -> SAnimation {
        self.transition = transition
        return self
    }
    
    /// 设置完成回调
    @discardableResult
    public func onComplete(_ completion: @escaping () -> Void) -> SAnimation {
        self.completion = completion
        return self
    }
}

// MARK: - 动画存储 Key

private var _sAnimation: Void?
private var _sAnimationEnabled: Void?

// MARK: - UIView 动画扩展

public extension UIView {
    
    /// 当前视图的动画配置
    var sAnimation: SAnimation? {
        get {
            return objc_getAssociatedObject(self, &_sAnimation) as? SAnimation
        }
        set {
            objc_setAssociatedObject(self, &_sAnimation, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 是否启用动画
    var sAnimationEnabled: Bool {
        get {
            return objc_getAssociatedObject(self, &_sAnimationEnabled) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &_sAnimationEnabled, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: - 动画配置方法
    
    /// 设置动画配置
    @discardableResult
    func animation(_ animation: SAnimation?) -> Self {
        self.sAnimation = animation
        return self
    }
    
    /// 禁用动画
    @discardableResult
    func animationDisabled(_ disabled: Bool = true) -> Self {
        self.sAnimationEnabled = !disabled
        return self
    }
    
    // MARK: - 便捷动画方法
    
    /// 执行动画
    func withAnimation(
        _ animation: SAnimation? = nil,
        _ changes: @escaping () -> Void
    ) {
        let config = animation ?? self.sAnimation ?? SAnimation()
        
        if !self.sAnimationEnabled {
            changes()
            return
        }
        
        // 应用过渡效果（进入前）
        if let transition = config.transition {
            applyTransition(transition, entering: true)
        }
        
        // 执行动画
        if config.curve.isSpring {
            let params = config.curve.springParams
            UIView.animate(
                withDuration: config.duration,
                delay: config.delay,
                usingSpringWithDamping: params.damping,
                initialSpringVelocity: params.velocity,
                options: [config.autoreverses ? .autoreverse : [], config.repeatCount > 0 ? .repeat : []],
                animations: {
                    changes()
                    
                    // 应用过渡效果（动画中）
                    if let transition = config.transition {
                        self.applyTransition(transition, entering: false)
                    }
                },
                completion: { _ in
                    config.completion?()
                }
            )
        } else {
            UIView.animate(
                withDuration: config.duration,
                delay: config.delay,
                options: [config.curve.animationOptions, config.autoreverses ? .autoreverse : [], config.repeatCount > 0 ? .repeat : []],
                animations: {
                    changes()
                    
                    // 应用过渡效果（动画中）
                    if let transition = config.transition {
                        self.applyTransition(transition, entering: false)
                    }
                },
                completion: { _ in
                    config.completion?()
                }
            )
        }
    }
    
    /// 应用过渡效果
    private func applyTransition(_ transition: STransition, entering: Bool) {
        switch transition {
        case .opacity:
            self.alpha = entering ? 0 : 1
            
        case .scale:
            let scale: CGFloat = entering ? 0.01 : 1.0
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        case .slide(let direction):
            if entering {
                switch direction {
                case .top:
                    self.transform = CGAffineTransform(translationX: 0, y: -self.bounds.height)
                case .bottom:
                    self.transform = CGAffineTransform(translationX: 0, y: self.bounds.height)
                case .left:
                    self.transform = CGAffineTransform(translationX: -self.bounds.width, y: 0)
                case .right:
                    self.transform = CGAffineTransform(translationX: self.bounds.width, y: 0)
                }
            } else {
                self.transform = .identity
            }
            
        case .move(let x, let y):
            if entering {
                self.transform = CGAffineTransform(translationX: x, y: y)
            } else {
                self.transform = .identity
            }
            
        case .rotate(let angle):
            if entering {
                self.transform = CGAffineTransform(rotationAngle: angle)
            } else {
                self.transform = .identity
            }
            
        case .combined(let transitions):
            transitions.forEach { applyTransition($0, entering: entering) }
        }
    }
    
    // MARK: - 预设动画效果
    
    /// 淡入
    func fadeIn(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        self.alpha = 0
        self.withAnimation(
            SAnimation.easeIn(duration: duration)
                .transition(.opacity)
                .onComplete { completion?() }
        ) {
            self.alpha = 1
        }
    }
    
    /// 淡出
    func fadeOut(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        self.withAnimation(
            SAnimation.easeOut(duration: duration)
                .transition(.opacity)
                .onComplete { completion?() }
        ) {
            self.alpha = 0
        }
    }
    
    /// 缩放进入
    func scaleIn(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        self.withAnimation(
            SAnimation.spring(duration: duration, damping: 0.6, velocity: 0.5)
                .transition(.scale)
                .onComplete { completion?() }
        ) {
            // transition 会自动处理
        }
    }
    
    /// 缩放退出
    func scaleOut(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        self.withAnimation(
            SAnimation.easeIn(duration: duration)
                .onComplete { completion?() }
        ) {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.alpha = 0
        }
    }
    
    /// 滑入
    func slideIn(from direction: STransition.SSlideDirection, duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        self.withAnimation(
            SAnimation.easeOut(duration: duration)
                .transition(.slide(direction))
                .onComplete { completion?() }
        ) {
            // transition 会自动处理
        }
    }
    
    /// 滑出
    func slideOut(to direction: STransition.SSlideDirection, duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        self.withAnimation(
            SAnimation.easeIn(duration: duration)
                .onComplete { completion?() }
        ) {
            switch direction {
            case .top:
                self.transform = CGAffineTransform(translationX: 0, y: -self.bounds.height)
            case .bottom:
                self.transform = CGAffineTransform(translationX: 0, y: self.bounds.height)
            case .left:
                self.transform = CGAffineTransform(translationX: -self.bounds.width, y: 0)
            case .right:
                self.transform = CGAffineTransform(translationX: self.bounds.width, y: 0)
            }
        }
    }
    
    /// 弹跳效果
    func bounce(scale: CGFloat = 1.1, duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        self.withAnimation(
            SAnimation.spring(duration: duration, damping: 0.4, velocity: 0.8)
                .onComplete { completion?() }
        ) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 0.5) {
            self.withAnimation(
                SAnimation.spring(duration: duration * 0.5, damping: 0.6, velocity: 0.5)
            ) {
                self.transform = .identity
            }
        }
    }
    
    /// 摇晃效果
    func shake(duration: TimeInterval = 0.5, completion: (() -> Void)? = nil) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = duration
        animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        animation.completion = { completion?() }
        self.layer.add(animation, forKey: "shake")
    }
    
    /// 脉冲效果
    func pulse(scale: CGFloat = 1.05, duration: TimeInterval = 0.6, completion: (() -> Void)? = nil) {
        self.withAnimation(
            SAnimation.easeInOut(duration: duration)
                .repeat(Float.infinity, autoreverses: true)
        ) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    /// 停止脉冲
    func stopPulse() {
        self.layer.removeAllAnimations()
        self.withAnimation(SAnimation.easeOut(duration: 0.2)) {
            self.transform = .identity
        }
    }
    
    /// 旋转
    func rotate360(duration: TimeInterval = 1.0, repeatCount: Float = 1, completion: (() -> Void)? = nil) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.completion = { completion?() }
        self.layer.add(animation, forKey: "rotation")
    }
    
    /// 翻转
    func flip(duration: TimeInterval = 0.6, axis: FlipAxis = .y, completion: (() -> Void)? = nil) {
        let transitionOptions: UIView.AnimationOptions
        switch axis {
        case .x:
            transitionOptions = .transitionFlipFromTop
        case .y:
            transitionOptions = .transitionFlipFromLeft
        }
        
        UIView.transition(
            with: self,
            duration: duration,
            options: transitionOptions,
            animations: nil,
            completion: { _ in completion?() }
        )
    }
    
    enum FlipAxis {
        case x, y
    }
}

// MARK: - CAAnimation 完成回调扩展

private var completionKey: Void?

extension CAAnimation {
    var completion: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &completionKey) as? (() -> Void)
        }
        set {
            objc_setAssociatedObject(self, &completionKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            self.delegate = AnimationDelegate.shared
        }
    }
}

private class AnimationDelegate: NSObject, CAAnimationDelegate {
    static let shared = AnimationDelegate()
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            anim.completion?()
        }
    }
}

// MARK: - 与 SState 集成的动画属性

public extension UIView {
    
    /// 带动画的属性更新
    @discardableResult
    func animatedWidth(_ block: @escaping (UIView) -> CGFloat, _ states: [SState]? = nil, animation: SAnimation? = nil) -> Self {
        if let states = states, states.count > 0 {
            self.autoBindAndRun(key: "animatedWidth", block: { [weak self] view in
                guard let self = self else { return }
                let newValue = block(view)
                self.withAnimation(animation ?? self.sAnimation) {
                    self.width(newValue)
                }
            }, states: states)
        } else {
            self.width(block(self))
        }
        return self
    }
    
    /// 带动画的高度更新
    @discardableResult
    func animatedHeight(_ block: @escaping (UIView) -> CGFloat, _ states: [SState]? = nil, animation: SAnimation? = nil) -> Self {
        if let states = states, states.count > 0 {
            self.autoBindAndRun(key: "animatedHeight", block: { [weak self] view in
                guard let self = self else { return }
                let newValue = block(view)
                self.withAnimation(animation ?? self.sAnimation) {
                    self.height(newValue)
                }
            }, states: states)
        } else {
            self.height(block(self))
        }
        return self
    }
    
    /// 带动画的透明度更新
    @discardableResult
    func animatedAlpha(_ block: @escaping (UIView) -> CGFloat, _ states: [SState]? = nil, animation: SAnimation? = nil) -> Self {
        if let states = states, states.count > 0 {
            self.autoBindAndRun(key: "animatedAlpha", block: { [weak self] view in
                guard let self = self else { return }
                let newValue = block(view)
                self.withAnimation(animation ?? self.sAnimation) {
                    self.alpha = newValue
                }
            }, states: states)
        } else {
            self.alpha(block(self))
        }
        return self
    }
    
    /// 带动画的背景色更新
    @discardableResult
    func animatedBackgroundColor(_ block: @escaping (UIView) -> UIColor, _ states: [SState]? = nil, animation: SAnimation? = nil) -> Self {
        if let states = states, states.count > 0 {
            self.autoBindAndRun(key: "animatedBackgroundColor", block: { [weak self] view in
                guard let self = self else { return }
                let newValue = block(view)
                self.withAnimation(animation ?? self.sAnimation) {
                    self.backgroundColor = newValue
                }
            }, states: states)
        } else {
            self.backgroundColor(block(self))
        }
        return self
    }
    
    /// 带动画的变换更新
    @discardableResult
    func animatedTransform(_ block: @escaping (UIView) -> CGAffineTransform, _ states: [SState]? = nil, animation: SAnimation? = nil) -> Self {
        if let states = states, states.count > 0 {
            self.autoBindAndRun(key: "animatedTransform", block: { [weak self] view in
                guard let self = self else { return }
                let newValue = block(view)
                self.withAnimation(animation ?? self.sAnimation) {
                    self.transform = newValue
                }
            }, states: states)
        } else {
            self.transform = block(self)
        }
        return self
    }
}

