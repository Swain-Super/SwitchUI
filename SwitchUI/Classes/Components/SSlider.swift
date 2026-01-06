//
//  SSlider.swift
//  SwitchUI
//
//  Created by Swain on 2025/01/06.
//  Copyright © 2025 swain. All rights reserved.
//

import UIKit

// MARK: - SSlider
public class SSlider: UISlider {
    
    // 当前值
    public var s_value: Float = 0
    
    // 最小值
    public var s_minimumValue: Float = 0
    
    // 最大值
    public var s_maximumValue: Float = 1
    
    // 步长
    public var s_step: Float?
    
    // 最小轨道颜色
    public var s_minimumTrackTintColor: UIColor?
    
    // 最大轨道颜色
    public var s_maximumTrackTintColor: UIColor?
    
    // 滑块颜色
    public var s_thumbTintColor: UIColor?
    
    // 自定义滑块图片
    public var s_thumbImage: UIImage?
    
    // 最小值图片
    public var s_minimumValueImage: UIImage?
    
    // 最大值图片
    public var s_maximumValueImage: UIImage?
    
    // 是否禁用
    public var s_isDisabled: Bool = false
    
    // 是否显示当前值标签
    public var s_showValueLabel: Bool = false
    
    // 当前值标签
    private var valueLabel: UILabel?
    
    // 值格式化器
    public var s_valueFormatter: ((Float) -> String)?
    
    // 值改变回调
    public var onValueChanged: ((Float) -> Void)?
    public var onEditingBegan: (() -> Void)?
    public var onEditingEnded: (() -> Void)?
    
    // 带状态的滑块（支持绑定到 SState）
    private var boundState: SState?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSlider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSlider() {
        self.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        self.addTarget(self, action: #selector(sliderEditingBegan), for: .touchDown)
        self.addTarget(self, action: #selector(sliderEditingEnded), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    // MARK: - Chainable Methods
    
    @discardableResult
    public func s_value(_ value: Float) -> Self {
        self.s_value = value
        return self
    }
    
    @discardableResult
    public func s_minimumValue(_ value: Float) -> Self {
        self.s_minimumValue = value
        return self
    }
    
    @discardableResult
    public func s_maximumValue(_ value: Float) -> Self {
        self.s_maximumValue = value
        return self
    }
    
    @discardableResult
    public func s_step(_ step: Float) -> Self {
        self.s_step = step
        return self
    }
    
    @discardableResult
    public func s_minimumTrackTintColor(_ color: UIColor) -> Self {
        self.s_minimumTrackTintColor = color
        return self
    }
    
    @discardableResult
    public func s_minimumTrackTintColor(_ hexString: String) -> Self {
        self.s_minimumTrackTintColor = hexString.hexColor()
        return self
    }
    
    @discardableResult
    public func s_maximumTrackTintColor(_ color: UIColor) -> Self {
        self.s_maximumTrackTintColor = color
        return self
    }
    
    @discardableResult
    public func s_maximumTrackTintColor(_ hexString: String) -> Self {
        self.s_maximumTrackTintColor = hexString.hexColor()
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
    public func s_thumbImage(_ image: UIImage?) -> Self {
        self.s_thumbImage = image
        return self
    }
    
    @discardableResult
    public func s_minimumValueImage(_ image: UIImage?) -> Self {
        self.s_minimumValueImage = image
        return self
    }
    
    @discardableResult
    public func s_maximumValueImage(_ image: UIImage?) -> Self {
        self.s_maximumValueImage = image
        return self
    }
    
    @discardableResult
    public func s_isDisabled(_ isDisabled: Bool) -> Self {
        self.s_isDisabled = isDisabled
        return self
    }
    
    @discardableResult
    public func s_showValueLabel(_ show: Bool) -> Self {
        self.s_showValueLabel = show
        return self
    }
    
    @discardableResult
    public func s_valueFormatter(_ formatter: @escaping (Float) -> String) -> Self {
        self.s_valueFormatter = formatter
        return self
    }
    
    // MARK: - Event Callbacks
    
    @discardableResult
    public func onValueChanged(_ callback: @escaping (Float) -> Void) -> Self {
        self.onValueChanged = callback
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
    
    // MARK: - State Binding
    
    @discardableResult
    public func bind(_ state: SState) -> Self {
        self.boundState = state
        self.s_value = state.floatValue
        
        // 监听状态变化
        state.addObserver { [weak self] newValue in
            guard let self = self else { return }
            if let newValue = newValue as? Float ,self.value != newValue {
                self.setValue(newValue, animated: true)
                self.updateValueLabel()
            }
        }
        
        return self
    }
    
    // MARK: - Render
    
    @discardableResult
    public func s_render() -> Self {
        // 设置范围
        self.minimumValue = s_minimumValue
        self.maximumValue = s_maximumValue
        
        // 设置当前值
        self.value = s_value
        
        // 设置颜色
        if let minimumTrackTintColor = s_minimumTrackTintColor {
            self.minimumTrackTintColor = minimumTrackTintColor
        }
        
        if let maximumTrackTintColor = s_maximumTrackTintColor {
            self.maximumTrackTintColor = maximumTrackTintColor
        }
        
        if let thumbTintColor = s_thumbTintColor {
            self.thumbTintColor = thumbTintColor
        }
        
        // 设置图片
        if let thumbImage = s_thumbImage {
            self.setThumbImage(thumbImage, for: .normal)
            self.setThumbImage(thumbImage, for: .highlighted)
        }
        
        if let minimumValueImage = s_minimumValueImage {
            self.minimumValueImage = minimumValueImage
        }
        
        if let maximumValueImage = s_maximumValueImage {
            self.maximumValueImage = maximumValueImage
        }
        
        // 设置禁用状态
        self.isEnabled = !s_isDisabled
        self.alpha = s_isDisabled ? 0.5 : 1.0
        
        // 设置值标签
        if s_showValueLabel {
            setupValueLabel()
            updateValueLabel()
        } else {
            valueLabel?.removeFromSuperview()
            valueLabel = nil
        }
        
        return self
    }
    
    // MARK: - Private Methods
    
    private func setupValueLabel() {
        if valueLabel == nil {
            valueLabel = UILabel()
            valueLabel?.font = UIFont.systemFont(ofSize: 12)
            valueLabel?.textColor = .darkGray
            valueLabel?.textAlignment = .center
            valueLabel?.backgroundColor = UIColor.white.withAlphaComponent(0.9)
            valueLabel?.layer.cornerRadius = 4
            valueLabel?.layer.masksToBounds = true
            valueLabel?.layer.borderWidth = 1
            valueLabel?.layer.borderColor = UIColor.lightGray.cgColor
            self.addSubview(valueLabel!)
        }
    }
    
    private func updateValueLabel() {
        guard let valueLabel = valueLabel else { return }
        
        // 格式化值
        let formattedValue: String
        if let formatter = s_valueFormatter {
            formattedValue = formatter(self.value)
        } else {
            formattedValue = String(format: "%.2f", self.value)
        }
        
        valueLabel.text = formattedValue
        valueLabel.sizeToFit()
        valueLabel.frame.size.width += 16
        valueLabel.frame.size.height += 8
        
        // 计算滑块位置
        let thumbRect = self.thumbRect(forBounds: self.bounds, trackRect: self.trackRect(forBounds: self.bounds), value: self.value)
        
        // 将标签放在滑块上方
        valueLabel.center = CGPoint(x: thumbRect.midX, y: thumbRect.minY - valueLabel.frame.height / 2 - 8)
    }
    
    @objc private func sliderValueChanged() {
        // 应用步长
        if let step = s_step, step > 0 {
            let roundedValue = round(self.value / step) * step
            self.value = roundedValue
        }
        
        // 更新值标签
        updateValueLabel()
        
        // 更新绑定的状态
        if let boundState = boundState {
            boundState.value = self.value
        }
        
        // 调用回调
        onValueChanged?(self.value)
    }
    
    @objc private func sliderEditingBegan() {
        // 显示值标签
        if s_showValueLabel {
            valueLabel?.alpha = 0
            valueLabel?.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.valueLabel?.alpha = 1
            }
        }
        
        onEditingBegan?()
    }
    
    @objc private func sliderEditingEnded() {
        // 隐藏值标签
        if s_showValueLabel {
            UIView.animate(withDuration: 0.2) {
                self.valueLabel?.alpha = 0
            } completion: { _ in
                self.valueLabel?.isHidden = true
            }
        }
        
        onEditingEnded?()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateValueLabel()
    }
    
    deinit {
        valueLabel?.removeFromSuperview()
    }
}

