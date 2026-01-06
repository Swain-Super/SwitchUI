//
//  UIView+sTouch.swift
//  SwitchUI
//
//  Created by swain on 2023/7/22.
//

import UIKit

// MARK: - 手势事件管理类

/// 点击手势管理
class SUIViewClick: Any {
    var click: (UIView) -> Void = { _ in }
    var tap: UITapGestureRecognizer?
}

/// 长按手势管理
class SUIViewLongPress: Any {
    var action: (UIView) -> Void = { _ in }
    var gesture: UILongPressGestureRecognizer?
}

/// 滑动手势管理
class SUIViewSwipe: Any {
    var action: (UIView, UISwipeGestureRecognizer.Direction) -> Void = { _, _ in }
    var gestures: [UISwipeGestureRecognizer] = []
}

/// 拖拽手势管理
class SUIViewPan: Any {
    var action: (UIView, UIPanGestureRecognizer) -> Void = { _, _ in }
    var gesture: UIPanGestureRecognizer?
}

/// 捏合手势管理
class SUIViewPinch: Any {
    var action: (UIView, CGFloat, UIPinchGestureRecognizer) -> Void = { _, _, _ in }
    var gesture: UIPinchGestureRecognizer?
}

/// 旋转手势管理
class SUIViewRotation: Any {
    var action: (UIView, CGFloat, UIRotationGestureRecognizer) -> Void = { _, _, _ in }
    var gesture: UIRotationGestureRecognizer?
}

// MARK: - Associated Object Keys

private var _sViewClick: Void?
private var _sViewLongPress: Void?
private var _sViewSwipe: Void?
private var _sViewPan: Void?
private var _sViewPinch: Void?
private var _sViewRotation: Void?

// MARK: - UIView 手势扩展

public extension UIView {
    
    // MARK: - 存储属性
    
    /// 点击手势管理对象
    internal var sViewClick: SUIViewClick? {
        get {
            return objc_getAssociatedObject(self, &_sViewClick) as? SUIViewClick
        }
        set {
            objc_setAssociatedObject(self, &_sViewClick, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 长按手势管理对象
    internal var sViewLongPress: SUIViewLongPress? {
        get {
            return objc_getAssociatedObject(self, &_sViewLongPress) as? SUIViewLongPress
        }
        set {
            objc_setAssociatedObject(self, &_sViewLongPress, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 滑动手势管理对象
    internal var sViewSwipe: SUIViewSwipe? {
        get {
            return objc_getAssociatedObject(self, &_sViewSwipe) as? SUIViewSwipe
        }
        set {
            objc_setAssociatedObject(self, &_sViewSwipe, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 拖拽手势管理对象
    internal var sViewPan: SUIViewPan? {
        get {
            return objc_getAssociatedObject(self, &_sViewPan) as? SUIViewPan
        }
        set {
            objc_setAssociatedObject(self, &_sViewPan, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 捏合手势管理对象
    internal var sViewPinch: SUIViewPinch? {
        get {
            return objc_getAssociatedObject(self, &_sViewPinch) as? SUIViewPinch
        }
        set {
            objc_setAssociatedObject(self, &_sViewPinch, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 旋转手势管理对象
    internal var sViewRotation: SUIViewRotation? {
        get {
            return objc_getAssociatedObject(self, &_sViewRotation) as? SUIViewRotation
        }
        set {
            objc_setAssociatedObject(self, &_sViewRotation, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: - 1. 点击手势 (Tap)
    
    /// 配置点击事件
    /// - Parameter click: 点击回调
    /// - Returns: Self
    @discardableResult
    func onClick(_ click: @escaping (UIView) -> Void) -> Self {
        self.sViewClick = SUIViewClick()
        self.sViewClick?.click = click
        
        if let control = self as? UIControl {
            control.addTarget(self, action: #selector(onClickAction), for: .touchUpInside)
        } else {
            // 移除旧手势
            if let tap = self.sViewClick?.tap {
                self.removeGestureRecognizer(tap)
            }
            
            self.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(onClickAction))
            self.sViewClick?.tap = tap
            self.addGestureRecognizer(tap)
        }
        return self
    }
    
    @objc private func onClickAction() {
        if let click = self.sViewClick?.click {
            click(self)
        }
    }
    
    // MARK: - 2. 长按手势 (Long Press)
    
    /// 配置长按手势
    /// - Parameters:
    ///   - minimumPressDuration: 最小按压时长，默认 0.5 秒
    ///   - action: 长按回调
    /// - Returns: Self
    @discardableResult
    func onLongPress(
        minimumPressDuration: TimeInterval = 0.5,
        _ action: @escaping (UIView) -> Void
    ) -> Self {
        self.sViewLongPress = SUIViewLongPress()
        self.sViewLongPress?.action = action
        
        // 移除旧手势
        if let gesture = self.sViewLongPress?.gesture {
            self.removeGestureRecognizer(gesture)
        }
        
        self.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressAction(_:)))
        longPress.minimumPressDuration = minimumPressDuration
        self.sViewLongPress?.gesture = longPress
        self.addGestureRecognizer(longPress)
        
        return self
    }
    
    @objc private func onLongPressAction(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            if let action = self.sViewLongPress?.action {
                action(self)
            }
        }
    }
    
    // MARK: - 3. 滑动手势 (Swipe)
    
    /// 配置滑动手势
    /// - Parameters:
    ///   - direction: 滑动方向
    ///   - action: 滑动回调
    /// - Returns: Self
    @discardableResult
    func onSwipe(
        _ direction: UISwipeGestureRecognizer.Direction,
        _ action: @escaping (UIView, UISwipeGestureRecognizer.Direction) -> Void
    ) -> Self {
        if self.sViewSwipe == nil {
            self.sViewSwipe = SUIViewSwipe()
        }
        
        self.sViewSwipe?.action = action
        self.isUserInteractionEnabled = true
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeAction(_:)))
        swipe.direction = direction
        self.sViewSwipe?.gestures.append(swipe)
        self.addGestureRecognizer(swipe)
        
        return self
    }
    
    /// 配置多个方向的滑动手势
    /// - Parameters:
    ///   - directions: 滑动方向数组
    ///   - action: 滑动回调
    /// - Returns: Self
    @discardableResult
    func onSwipe(
        directions: [UISwipeGestureRecognizer.Direction],
        _ action: @escaping (UIView, UISwipeGestureRecognizer.Direction) -> Void
    ) -> Self {
        for direction in directions {
            self.onSwipe(direction, action)
        }
        return self
    }
    
    @objc private func onSwipeAction(_ gesture: UISwipeGestureRecognizer) {
        if let action = self.sViewSwipe?.action {
            action(self, gesture.direction)
        }
    }
    
    // MARK: - 4. 拖拽手势 (Pan/Drag)
    
    /// 配置拖拽手势
    /// - Parameter action: 拖拽回调，提供视图和手势对象
    /// - Returns: Self
    @discardableResult
    func onDrag(_ action: @escaping (UIView, UIPanGestureRecognizer) -> Void) -> Self {
        self.sViewPan = SUIViewPan()
        self.sViewPan?.action = action
        
        // 移除旧手势
        if let gesture = self.sViewPan?.gesture {
            self.removeGestureRecognizer(gesture)
        }
        
        self.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPanAction(_:)))
        self.sViewPan?.gesture = pan
        self.addGestureRecognizer(pan)
        
        return self
    }
    
    /// 配置简单拖拽（自动移动视图）
    /// - Parameters:
    ///   - bounded: 是否限制在父视图边界内
    ///   - animated: 回弹时是否使用动画
    /// - Returns: Self
    @discardableResult
    func draggable(bounded: Bool = false, animated: Bool = true) -> Self {
        var originalCenter: CGPoint = self.center
        
        self.onDrag { [weak self] view, gesture in
            guard let self = self else { return }
            
            let translation = gesture.translation(in: view.superview)
            
            switch gesture.state {
            case .began:
                originalCenter = view.center
                
            case .changed:
                var newCenter = CGPoint(
                    x: originalCenter.x + translation.x,
                    y: originalCenter.y + translation.y
                )
                
                // 限制在父视图边界内
                if bounded, let superview = view.superview {
                    let halfWidth = view.bounds.width / 2
                    let halfHeight = view.bounds.height / 2
                    
                    newCenter.x = max(halfWidth, min(superview.bounds.width - halfWidth, newCenter.x))
                    newCenter.y = max(halfHeight, min(superview.bounds.height - halfHeight, newCenter.y))
                }
                
                view.center = newCenter
                
            case .ended, .cancelled:
                if bounded, let superview = view.superview {
                    // 检查是否超出边界，如果超出则回弹
                    let halfWidth = view.bounds.width / 2
                    let halfHeight = view.bounds.height / 2
                    
                    var finalCenter = view.center
                    finalCenter.x = max(halfWidth, min(superview.bounds.width - halfWidth, finalCenter.x))
                    finalCenter.y = max(halfHeight, min(superview.bounds.height - halfHeight, finalCenter.y))
                    
                    if animated && finalCenter != view.center {
                        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut) {
                            view.center = finalCenter
                        }
                    } else {
                        view.center = finalCenter
                    }
                }
                
            default:
                break
            }
        }
        
        return self
    }
    
    @objc private func onPanAction(_ gesture: UIPanGestureRecognizer) {
        if let action = self.sViewPan?.action {
            action(self, gesture)
        }
    }
    
    // MARK: - 5. 捏合手势 (Pinch)
    
    /// 配置捏合手势
    /// - Parameter action: 捏合回调，提供视图、缩放比例和手势对象
    /// - Returns: Self
    @discardableResult
    func onPinch(_ action: @escaping (UIView, CGFloat, UIPinchGestureRecognizer) -> Void) -> Self {
        self.sViewPinch = SUIViewPinch()
        self.sViewPinch?.action = action
        
        // 移除旧手势
        if let gesture = self.sViewPinch?.gesture {
            self.removeGestureRecognizer(gesture)
        }
        
        self.isUserInteractionEnabled = true
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(onPinchAction(_:)))
        self.sViewPinch?.gesture = pinch
        self.addGestureRecognizer(pinch)
        
        return self
    }
    
    /// 配置简单捏合缩放（自动缩放视图）
    /// - Parameters:
    ///   - minScale: 最小缩放比例，默认 0.5
    ///   - maxScale: 最大缩放比例，默认 3.0
    /// - Returns: Self
    @discardableResult
    func pinchable(minScale: CGFloat = 0.5, maxScale: CGFloat = 3.0) -> Self {
        var lastScale: CGFloat = 1.0
        
        self.onPinch { [weak self] view, scale, gesture in
            guard let self = self else { return }
            
            switch gesture.state {
            case .began:
                lastScale = 1.0
                
            case .changed:
                let currentScale = view.transform.a // 获取当前的缩放比例
                var newScale = currentScale * scale / lastScale
                
                // 限制缩放范围
                newScale = max(minScale, min(maxScale, newScale))
                
                view.transform = view.transform.scaledBy(x: scale / lastScale, y: scale / lastScale)
                lastScale = scale
                
            case .ended, .cancelled:
                lastScale = 1.0
                
            default:
                break
            }
        }
        
        return self
    }
    
    @objc private func onPinchAction(_ gesture: UIPinchGestureRecognizer) {
        if let action = self.sViewPinch?.action {
            action(self, gesture.scale, gesture)
        }
    }
    
    // MARK: - 6. 旋转手势 (Rotation)
    
    /// 配置旋转手势
    /// - Parameter action: 旋转回调，提供视图、旋转角度和手势对象
    /// - Returns: Self
    @discardableResult
    func onRotate(_ action: @escaping (UIView, CGFloat, UIRotationGestureRecognizer) -> Void) -> Self {
        self.sViewRotation = SUIViewRotation()
        self.sViewRotation?.action = action
        
        // 移除旧手势
        if let gesture = self.sViewRotation?.gesture {
            self.removeGestureRecognizer(gesture)
        }
        
        self.isUserInteractionEnabled = true
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(onRotationAction(_:)))
        self.sViewRotation?.gesture = rotation
        self.addGestureRecognizer(rotation)
        
        return self
    }
    
    /// 配置简单旋转（自动旋转视图）
    /// - Returns: Self
    @discardableResult
    func rotatable() -> Self {
        var lastRotation: CGFloat = 0
        
        self.onRotate { [weak self] view, rotation, gesture in
            guard let self = self else { return }
            
            switch gesture.state {
            case .began:
                lastRotation = 0
                
            case .changed:
                let rotationDelta = rotation - lastRotation
                view.transform = view.transform.rotated(by: rotationDelta)
                lastRotation = rotation
                
            case .ended, .cancelled:
                lastRotation = 0
                
            default:
                break
            }
        }
        
        return self
    }
    
    @objc private func onRotationAction(_ gesture: UIRotationGestureRecognizer) {
        if let action = self.sViewRotation?.action {
            action(self, gesture.rotation, gesture)
        }
    }
    
    // MARK: - 7. 组合手势
    
    /// 配置可交互视图（同时支持拖拽、缩放、旋转）
    /// - Parameters:
    ///   - draggable: 是否可拖拽
    ///   - pinchable: 是否可缩放
    ///   - rotatable: 是否可旋转
    ///   - bounded: 拖拽是否限制在边界内
    /// - Returns: Self
    @discardableResult
    func interactive(
        draggable: Bool = true,
        pinchable: Bool = true,
        rotatable: Bool = true,
        bounded: Bool = false
    ) -> Self {
        if draggable {
            self.draggable(bounded: bounded)
        }
        if pinchable {
            self.pinchable()
        }
        if rotatable {
            self.rotatable()
        }
        
        // 启用手势同时识别
        if let gestures = self.gestureRecognizers {
            for gesture in gestures {
                gesture.cancelsTouchesInView = false
                if let otherGestures = self.gestureRecognizers {
                    for otherGesture in otherGestures where gesture != otherGesture {
                        gesture.require(toFail: otherGesture)
                    }
                }
            }
        }
        
        return self
    }
    
    // MARK: - 8. 手势管理
    
    /// 移除所有手势
    /// - Returns: Self
    @discardableResult
    func removeAllGestures() -> Self {
        self.gestureRecognizers?.forEach { self.removeGestureRecognizer($0) }
        
        // 清理存储
        self.sViewClick = nil
        self.sViewLongPress = nil
        self.sViewSwipe = nil
        self.sViewPan = nil
        self.sViewPinch = nil
        self.sViewRotation = nil
        
        return self
    }
    
    /// 启用/禁用手势
    /// - Parameter enabled: 是否启用
    /// - Returns: Self
    @discardableResult
    func gesturesEnabled(_ enabled: Bool) -> Self {
        self.gestureRecognizers?.forEach { $0.isEnabled = enabled }
        return self
    }
}
