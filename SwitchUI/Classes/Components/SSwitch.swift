//
//  SSwitch.swift
//  SwitchUI
//
//  Created by Swain on 2025/01/06.
//  Copyright © 2025 swain. All rights reserved.
//

import UIKit

// MARK: - SSwitch
public class SSwitch: UISwitch {
    
    // 开关状态
    public var s_isOn: Bool = false
    
    // 开启时的颜色
    public var s_onTintColor: UIColor?
    
    // 关闭时的颜色
    public var s_offTintColor: UIColor?
    
    // 滑块颜色
    public var s_thumbTintColor: UIColor?
    
    // 是否禁用
    public var s_isDisabled: Bool = false
    
    // 自定义尺寸
    public var s_scale: CGFloat = 1.0
    
    // 状态改变回调
    public var onValueChanged: ((Bool) -> Void)?
    
    // 带状态的开关（支持绑定到 SState）
    private var boundState: SState?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSwitch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSwitch() {
        self.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    // MARK: - Chainable Methods
    
    @discardableResult
    public func s_isOn(_ isOn: Bool) -> Self {
        self.s_isOn = isOn
        return self
    }
    
    @discardableResult
    public func s_onTintColor(_ color: UIColor) -> Self {
        self.s_onTintColor = color
        return self
    }
    
    @discardableResult
    public func s_onTintColor(_ hexString: String) -> Self {
        self.s_onTintColor = hexString.hexColor()
        return self
    }
    
    @discardableResult
    public func s_offTintColor(_ color: UIColor) -> Self {
        self.s_offTintColor = color
        return self
    }
    
    @discardableResult
    public func s_offTintColor(_ hexString: String) -> Self {
        self.s_offTintColor = hexString.hexColor()
        return self
    }
    
    @discardableResult
    public func s_thumbTintColor(_ color: UIColor) -> Self {
        self.s_thumbTintColor = color
        return self
    }
    
    @discardableResult
    public func s_thumbTintColor(_ hexString: String) -> Self {
        self.s_thumbTintColor = hexString.hexColor()
        return self
    }
    
    @discardableResult
    public func s_isDisabled(_ isDisabled: Bool) -> Self {
        self.s_isDisabled = isDisabled
        return self
    }
    
    @discardableResult
    public func s_scale(_ scale: CGFloat) -> Self {
        self.s_scale = scale
        return self
    }
    
    // MARK: - Event Callback
    
    @discardableResult
    public func onValueChanged(_ callback: @escaping (Bool) -> Void) -> Self {
        self.onValueChanged = callback
        return self
    }
    
    // MARK: - State Binding
    
    @discardableResult
    public func bind(_ state: SState) -> Self {
        self.boundState = state
        self.s_isOn = state.boolValue
        
        // 监听状态变化
        state.addObserver { [weak self] newValue in
            guard let self = self else { return }
            if let newValue = newValue as? Bool,self.isOn != newValue {
                self.setOn(newValue, animated: true)
            }
        }
        
        return self
    }
    
    // MARK: - Render
    
    @discardableResult
    public func s_render() -> Self {
        // 设置状态
        self.setOn(s_isOn, animated: false)
        
        // 设置颜色
        if let onTintColor = s_onTintColor {
            self.onTintColor = onTintColor
        }
        
        if let thumbTintColor = s_thumbTintColor {
            self.thumbTintColor = thumbTintColor
        }
        
        // iOS 不直接支持 offTintColor，但可以通过背景颜色模拟
        if let offTintColor = s_offTintColor {
            self.backgroundColor = offTintColor
            self.layer.cornerRadius = self.frame.height / 2
        }
        
        // 设置禁用状态
        self.isEnabled = !s_isDisabled
        self.alpha = s_isDisabled ? 0.5 : 1.0
        
        // 设置缩放
        if s_scale != 1.0 {
            self.transform = CGAffineTransform(scaleX: s_scale, y: s_scale)
        }
        
        return self
    }
    
    // MARK: - Private Methods
    
    @objc private func switchValueChanged() {
        // 更新绑定的状态
        if let boundState = boundState {
            boundState.value = self.isOn
        }
        
        // 调用回调
        onValueChanged?(self.isOn)
    }
    
    // MARK: - Public Methods
    
    /// 切换开关状态
    @discardableResult
    public func toggle(animated: Bool = true) -> Self {
        self.setOn(!self.isOn, animated: animated)
        switchValueChanged()
        return self
    }
}

