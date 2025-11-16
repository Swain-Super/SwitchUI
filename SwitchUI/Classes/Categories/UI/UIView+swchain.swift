//
//  UIView+swchain.swift
//  Swain
//
//  Created by swain on 2023/7/22.
//

import UIKit

private var _enableSWUI: Void?
private var _unVisibleInSWUI: Void?
private var _viewId: Void?
private var _width: Void?
private var _height: Void?
private var _left: Void?
private var _top: Void?
private var _right: Void?
private var _bottom: Void?
private var _centerX: Void?
private var _centerY: Void?
private var _aspectRatio: Void?
private var _isConstWidth: Void?
private var _isConstHeight: Void?
private var _sHookBlockArray: Void?
private var _sAttributeBlockArray: Void?
private var _position: Void?
private var _tags: Void?
private var _markDirty: Void?
private var _alignRules: Void?

// MARK: 属性
public extension UIView {
    
    /// 添加子容器
    /// - Parameter subViews: 容器的子View
    func `as`(_ subViews: Array<UIView>? = nil) {
        subViews?.forEach { view in
            self.addSubview(view)
        }
    }
    
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult
    func backgroundColor(_ block: @escaping (UIView) -> UIColor,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.backgroundColorA.rawValue, block: block, states: states)
        } else {
            self.backgroundColor(block(self))
        }
        return self
    }
    
    @discardableResult
    func backgroundColor(_ color: String) -> Self {
        self.backgroundColor = color.hexColor()
        return self
    }
    
    @discardableResult
    func backgroundColor(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.backgroundColorB.rawValue, block: block, states: states)
        } else {
            self.backgroundColor(block(self))
        }
        return self
    }
    
    @discardableResult
    func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.layer.cornerRadius = cornerRadius
        return self
    }
    
    @discardableResult
    func cornerRadius(_ block: @escaping (UIView) -> CGFloat,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.cornerRadius.rawValue, block: block, states: states)
        } else {
            self.cornerRadius(block(self))
        }
        return self
    }
    
    @discardableResult
    func borderColor(_ borderColor: UIColor) -> Self {
        self.layer.borderColor = borderColor.cgColor
        return self
    }
    
    @discardableResult
    func borderColor(_ block: @escaping (UIView) -> UIColor,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.borderColorA.rawValue, block: block, states: states)
        } else {
            self.borderColor(block(self))
        }
        return self
    }
    
    @discardableResult
    func borderColor(_ color: String) -> Self {
        self.layer.borderColor = color.hexColor().cgColor
        return self
    }
    
    @discardableResult
    func borderColor(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.borderColorB.rawValue, block: block, states: states)
        } else {
            self.borderColor(block(self))
        }
        return self
    }
    
    @discardableResult
    func borderWidth(_ borderWidth: CGFloat) -> Self {
        self.layer.borderWidth = borderWidth
        return self
    }
    
    @discardableResult
    func borderWidth(_ block: @escaping (UIView) -> CGFloat,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.borderWidth.rawValue, block: block, states: states)
        } else {
            self.borderWidth(block(self))
        }
        return self
    }
    
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }
    
    @discardableResult
    func alpha(_ block: @escaping (UIView) -> CGFloat,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.alpha.rawValue, block: block, states: states)
        } else {
            self.alpha(block(self))
        }
        return self
    }
    
    @discardableResult
    func clipsToBounds(_ value: Bool) -> Self {
        self.clipsToBounds = value
        return self
    }
    
    @discardableResult
    func clipsToBounds(_ block: @escaping (UIView) -> Bool,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.clipsToBounds.rawValue, block: block, states: states)
        } else {
            self.clipsToBounds(block(self))
        }
        return self
    }
    
    @discardableResult
    func maskToBounds(_ value: Bool) -> Self {
        self.layer.masksToBounds = value
        return self
    }
    
    @discardableResult
    func maskToBounds(_ block: @escaping (UIView) -> Bool,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.maskToBounds.rawValue, block: block, states: states)
        } else {
            self.maskToBounds(block(self))
        }
        return self
    }
    
    @discardableResult
    func shadowOpacity(_ shadowOpacity: Float) -> Self {
        self.layer.shadowOpacity = shadowOpacity
        return self
    }
    
    @discardableResult
    func shadowOpacity(_ block: @escaping (UIView) -> Float,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.shadowOpacity.rawValue, block: block, states: states)
        } else {
            self.shadowOpacity(block(self))
        }
        return self
    }
    
    @discardableResult
    func shadowRadius(_ shadowRadius: CGFloat) -> Self {
        self.layer.shadowRadius = shadowRadius
        return self
    }
    
    @discardableResult
    func shadowRadius(_ block: @escaping (UIView) -> CGFloat,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.shadowRadius.rawValue, block: block, states: states)
        } else {
            self.shadowRadius(block(self))
        }
        return self
    }
    
    @discardableResult
    func shadowColor(_ shadowColor: UIColor) -> Self {
        self.layer.shadowColor = shadowColor.cgColor
        return self
    }
    
    @discardableResult
    func shadowColor(_ block: @escaping (UIView) -> UIColor,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.shadowColorA.rawValue, block: block, states: states)
        } else {
            self.shadowColor(block(self))
        }
        return self
    }
    
    @discardableResult
    func shadowColor(_ shadowColor: String) -> Self {
        self.layer.shadowColor = shadowColor.hexColor().cgColor
        return self
    }
    
    @discardableResult
    func shadowColor(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.shadowColorB.rawValue, block: block, states: states)
        } else {
            self.shadowColor(block(self))
        }
        return self
    }
    
    @discardableResult
    func shadowOffset(_ shadowOffset: CGSize) -> Self {
        self.layer.shadowOffset = shadowOffset
        return self
    }
    
    @discardableResult
    func shadowOffset(_ block: @escaping (UIView) -> CGSize,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.shadowOffset.rawValue, block: block, states: states)
        } else {
            self.shadowOffset(block(self))
        }
        return self
    }

    @discardableResult
    func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Self {
        self.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }
    
    @discardableResult
    func isUserInteractionEnabled(_ block: @escaping (UIView) -> Bool,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.isUserInteractionEnabled.rawValue, block: block, states: states)
        } else {
            self.isUserInteractionEnabled(block(self))
        }
        return self
    }
    
    @discardableResult
    func anchorPoint(_ anchorPoint: CGPoint) -> Self {
        self.layer.anchorPoint = anchorPoint
        return self
    }
    
    @discardableResult
    func tag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }
    
    @discardableResult
    func tag(_ block: @escaping (UIView) -> Int,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.tag.rawValue, block: block, states: states)
        } else {
            self.tag(block(self))
        }
        return self
    }
    
    @discardableResult
    func contentMode(_ contentMode: ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }
    
    @discardableResult
    func contentMode(_ block: @escaping (UIView) -> ContentMode,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.contentMode.rawValue, block: block, states: states)
        } else {
            self.contentMode(block(self))
        }
        return self
    }
    
    @discardableResult
    func visible(_ value: Bool) -> Self {
        self.isHidden = !value
        self.unVisibleInSWUI = !value
        return self
    }
    
    @discardableResult
    func visible(_ block: @escaping (UIView) -> Bool,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.visible.rawValue, block: block, states: states)
        } else {
            self.visible(block(self))
        }
        return self
    }
    
    @discardableResult
    func sizeToFit(_ size: CGSize?) -> Self {
        if let size = size {
            self.sizeThatFits(size)
        } else {
            self.sizeToFit()
        }
        return self
    }
    
    @discardableResult
    func viewId(_ viewId: String) -> Self {
        self.sViewId = viewId
        return self
    }
    
    @discardableResult
    func callSelf(_ block: @escaping (UIView) -> Void) -> Self {
        block(self)
        return self
    }
    
    @discardableResult
    func callSelf<T>(_ object: AutoreleasingUnsafeMutablePointer<T?>) -> Self {
        object.pointee = self as? T
        return self
    }
}



// MARK: 布局
public extension UIView {
    
    // MARK: Frame
     
    var sWidth: SWValue? {
        get {
            return objc_getAssociatedObject(self, &_width) as? SWValue
        }
        set {
            objc_setAssociatedObject(self, &_width, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var sHeight: SWValue? {
        get {
            return objc_getAssociatedObject(self, &_height) as? SWValue
        }
        set {
            objc_setAssociatedObject(self, &_height, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var sLeft: SWValue? {
        get {
            return objc_getAssociatedObject(self, &_left) as? SWValue
        }
        set {
            objc_setAssociatedObject(self, &_left, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var sTop: SWValue? {
        get {
            return objc_getAssociatedObject(self, &_top) as? SWValue
        }
        set {
            objc_setAssociatedObject(self, &_top, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var sRight: SWValue? {
        get {
            return objc_getAssociatedObject(self, &_right) as? SWValue
        }
        set {
            objc_setAssociatedObject(self, &_right, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var sBottom: SWValue? {
        get {
            return objc_getAssociatedObject(self, &_bottom) as? SWValue
        }
        set {
            objc_setAssociatedObject(self, &_bottom, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var sCenterX: SWValue? {
        get {
            return objc_getAssociatedObject(self, &_centerX) as? SWValue
        }
        set {
            objc_setAssociatedObject(self, &_centerX, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var sCenterY: SWValue? {
        get {
            return objc_getAssociatedObject(self, &_centerY) as? SWValue
        }
        set {
            objc_setAssociatedObject(self, &_centerY, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var sAspectRatio: Float? {
        get {
            return objc_getAssociatedObject(self, &_aspectRatio) as? Float
        }
        set {
            objc_setAssociatedObject(self, &_aspectRatio, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var isConstWidth: Bool {
        get {
            return objc_getAssociatedObject(self, &_isConstWidth) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &_isConstWidth, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var isConstHeight: Bool {
        get {
            return objc_getAssociatedObject(self, &_isConstHeight) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &_isConstHeight, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var sPosition: SWPosition? {
        get {
            return objc_getAssociatedObject(self, &_position) as? SWPosition
        }
        set {
            objc_setAssociatedObject(self, &_position, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var sAlignRules: SWAlignRules? {
        get {
            return objc_getAssociatedObject(self, &_alignRules) as? SWAlignRules
        }
        set {
            objc_setAssociatedObject(self, &_alignRules, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var sTags: [String: Any]? {
        get {
            return objc_getAssociatedObject(self, &_tags) as? [String: Any]
        }
        set {
            objc_setAssociatedObject(self, &_tags, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @discardableResult
    func width(_ value: String) -> Self {
        self.sWidth = SWValue(value: value, .width)
        return self
    }
    
    @discardableResult
    func width(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_widthA.rawValue, block: block, states: states)
        } else {
            self.width(block(self))
        }
        return self
    }
    
    @discardableResult
    func width(_ value: Float) -> Self {
        self.sWidth = SWValue(value: String(value), .width)
        return self
    }
    
    @discardableResult
    func width(_ block: @escaping (UIView) -> Float,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_widthB.rawValue, block: block, states: states)
        } else {
            self.width(block(self))
        }
        return self
    }
    
    @discardableResult
    func height(_ value: String) -> Self {
        self.sHeight = SWValue(value: value, .height)
        return self
    }
    
    @discardableResult
    func height(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_widthA.rawValue, block: block, states: states)
        } else {
            self.height(block(self))
        }
        return self
    }
    
    @discardableResult
    func height(_ value: Float) -> Self {
        self.sHeight = SWValue(value: String(value), .height)
        return self
    }
    
    @discardableResult
    func height(_ block: @escaping (UIView) -> Float,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_widthB.rawValue, block: block, states: states)
        } else {
            self.height(block(self))
        }
        return self
    }
    
    @discardableResult
    func left(_ value: String) -> Self {
        self.sLeft = SWValue(value: value, .left)
        return self
    }
    
    @discardableResult
    func left(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_leftA.rawValue, block: block, states: states)
        } else {
            self.left(block(self))
        }
        return self
    }
    
    @discardableResult
    func left(_ value: Float) -> Self {
        self.sLeft = SWValue(value: String(value), .left)
        return self
    }
    
    @discardableResult
    func left(_ block: @escaping (UIView) -> Float,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_leftB.rawValue, block: block, states: states)
        } else {
            self.left(block(self))
        }
        return self
    }

    @discardableResult
    func top(_ value: String) -> Self {
        self.sTop = SWValue(value: value, .top)
        return self
    }
    
    @discardableResult
    func top(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_topA.rawValue, block: block, states: states)
        } else {
            self.top(block(self))
        }
        return self
    }
    
    @discardableResult
    func top(_ value: Float) -> Self {
        self.sTop = SWValue(value: String(value), .top)
        return self
    }
    
    @discardableResult
    func top(_ block: @escaping (UIView) -> Float,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_topA.rawValue, block: block, states: states)
        } else {
            self.top(block(self))
        }
        return self
    }
    
    @discardableResult
    func right(_ value: String) -> Self {
        self.sRight = SWValue(value: value, .right)
        return self
    }
    
    @discardableResult
    func right(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_rightA.rawValue, block: block, states: states)
        } else {
            self.right(block(self))
        }
        return self
    }
    
    @discardableResult
    func right(_ value: Float) -> Self {
        self.sRight = SWValue(value: String(value), .right)
        return self
    }
    
    @discardableResult
    func right(_ block: @escaping (UIView) -> Float,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_rightB.rawValue, block: block, states: states)
        } else {
            self.right(block(self))
        }
        return self
    }

    @discardableResult
    func bottom(_ value: String) -> Self {
        self.sBottom = SWValue(value: value, .bottom)
        return self
    }
    
    @discardableResult
    func bottom(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_bottomA.rawValue, block: block, states: states)
        } else {
            self.bottom(block(self))
        }
        return self
    }
    
    @discardableResult
    func bottom(_ value: Float) -> Self {
        self.sBottom = SWValue(value: String(value), .bottom)
        return self
    }
    
    @discardableResult
    func bottom(_ block: @escaping (UIView) -> Float,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_bottomB.rawValue, block: block, states: states)
        } else {
            self.bottom(block(self))
        }
        return self
    }
    
    @discardableResult
    func centerX(_ value: String) -> Self {
        self.sCenterX = SWValue(value: value, .centerX)
        return self
    }
    
    @discardableResult
    func centerX(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_centerXA.rawValue, block: block, states: states)
        } else {
            self.centerX(block(self))
        }
        return self
    }
    
    @discardableResult
    func centerX(_ value: Float) -> Self {
        self.sCenterX = SWValue(value: String(value), .centerX)
        return self
    }
    
    @discardableResult
    func centerX(_ block: @escaping (UIView) -> Float,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_centerXB.rawValue, block: block, states: states)
        } else {
            self.centerX(block(self))
        }
        return self
    }
    
    @discardableResult
    func centerY(_ value: String) -> Self {
        self.sCenterY = SWValue(value: value, .centerY)
        return self
    }
    
    @discardableResult
    func centerY(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_centerYA.rawValue, block: block, states: states)
        } else {
            self.centerY(block(self))
        }
        return self
    }
    
    @discardableResult
    func centerY(_ value: Float) -> Self {
        self.sCenterY = SWValue(value: String(value), .centerY)
        return self
    }
    
    @discardableResult
    func centerY(_ block: @escaping (UIView) -> Float,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_centerYB.rawValue, block: block, states: states)
        } else {
            self.centerY(block(self))
        }
        return self
    }
    
    @discardableResult
    func aspectRatio(_ value: Float) -> Self {
        self.sAspectRatio = value
        return self
    }
    
    
    @discardableResult
    func position(_ value: [SWPositionType: String]?) -> Self {
        self.sPosition = SWPosition.init(value: value)
        return self
    }
    
    @discardableResult
    func position(_ value: [SWPositionType: Float]?) -> Self {
        self.sPosition = SWPosition.init(value: value)
        return self
    }
    
    @discardableResult
    func position(_ block: @escaping (UIView) -> [SWPositionType: String]?,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_positionA.rawValue, block: block, states: states)
        } else {
            self.position(block(self))
        }
        return self
    }
    
    @discardableResult
    func position(_ block: @escaping (UIView) -> [SWPositionType: Float]?,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_positionB.rawValue, block: block, states: states)
        } else {
            self.position(block(self))
        }
        return self
    }
    
    @discardableResult
    func alignRules(_ value: [SWPositionType: [String: Any]]?) -> Self {
        self.sAlignRules = SWAlignRules(value: value)
        return self
    }
    
    @discardableResult
    func alignRules(_ block: @escaping (UIView) -> [SWPositionType: [String: Any]]?,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIViewAKey.s_alignRules.rawValue, block: block, states: states)
        } else {
            self.alignRules(block(self))
        }
        return self
    }
    
    
    /// 判断是否使用了SWUI，加入的会参与自动布局，没使用的，不会进行布局
    /// - Returns: 是否用SWUI进行布局
    @objc func isUseSWUI() -> Bool {
        if (enableSWUI || ((sWidth != nil) || (sHeight != nil) || (sLeft != nil) || (sRight != nil) || (sTop != nil) || (sBottom != nil) || (sCenterX != nil) || (sCenterY != nil))) && !unVisibleInSWUI {
            return true
        }
        return false
    }
    
    /// 布局自身
    func sw_layoutSize(contentSize: CGSize, padding: UIEdgeInsets = .zero) {
        
        if let sWidth = self.sWidth, sWidth.type != .auto {
            let width: Float = countSWValue(value: sWidth, contentSize: contentSize, padding)
            n_width = width
            isConstWidth = true
        } else {
            isConstWidth = false
        }
        
        if let sHeight = self.sHeight, sHeight.type != .auto {
            let height: Float = countSWValue(value: sHeight, contentSize: contentSize, padding)
            n_height = height
            isConstHeight = true
        } else {
            isConstHeight = false
        }
        
        /// 没有给宽高尺寸的
        if !isConstWidth || !isConstHeight {
            
            // 设置了控件比例的
            if let sAspectRatio = self.sAspectRatio {
                if isConstWidth {
                    n_height = n_width / sAspectRatio
                    isConstHeight = true
                } else if isConstHeight {
                    n_width = n_height * sAspectRatio
                    isConstWidth = true
                }
            }
            
            // UILabel自适应大小
            if self is UILabel {
                var fitSize: CGSize = .zero
                if isConstWidth {
                    fitSize.width = CGFloat(self.n_width)
                }
                if isConstHeight {
                    fitSize.height = CGFloat(self.n_height)
                }
                self.n_size =  self.sizeThatFits(fitSize)
            }
        }
    }
    
    /// 数据Hook监听Block Array
    var sHookBlockArray: [String: Any] {
        get {
            if objc_getAssociatedObject(self, &_sHookBlockArray) == nil {
                self.sHookBlockArray = [:]
            }
            return objc_getAssociatedObject(self, &_sHookBlockArray) as! [String : Any]
        }
        set {
            objc_setAssociatedObject(self, &_sHookBlockArray, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// frame监听改动监听
    @discardableResult
    func setFrameHack(_ block: @escaping (CGRect) -> Void) -> Self {
        self.sHookBlockArray["frameHack"] = block
        self.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions([.new, .old]), context: nil)
        return self
    }
    
    /// kvo回调
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            if let frameHack = (object as? UIView)?.sHookBlockArray["frameHack"] as? ((CGRect) -> Void) {
                frameHack(change?[NSKeyValueChangeKey.newKey] as! CGRect)
            }
        }
    }

    @discardableResult
    func overlay(_ view: UIView?) -> Self {
        if let view = view as? SContainer {
            self.addSubview(view)
        } else {
            let stack = SStack([
                view
            ])
            self.addSubview(stack)
        }
        return self
    }
    
    @discardableResult
    func zIndex(_ zIndex: Float) -> Self {
        self.layer.zPosition = CGFloat(zIndex)
        return self
    }
    
}

// MARK: 渲染
public extension UIView {
    
    /// 标记使用swui布局, 默认为false
    var enableSWUI: Bool {
        get {
            return objc_getAssociatedObject(self, &_enableSWUI) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &_enableSWUI, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 标记不可见, 默认为false
    var unVisibleInSWUI: Bool {
        get {
            return objc_getAssociatedObject(self, &_unVisibleInSWUI) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &_unVisibleInSWUI, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
   /// 组件Id
   var sViewId: String {
       get {
           if objc_getAssociatedObject(self, &_viewId) == nil {
               self.sViewId = UUID().uuidString
               // 添加
               SUIManager.shared.add(viewId: self.sViewId, component: self)
           }
           return objc_getAssociatedObject(self, &_viewId) as? String ?? ""
       }
       set {
           objc_setAssociatedObject(self, &_viewId, newValue, .OBJC_ASSOCIATION_RETAIN)
           // 添加
           SUIManager.shared.add(viewId: self.sViewId, component: self)
       }
   }
    
    /// 标记组件UI是否需要刷新, 默认为false
    var markDirty: Bool {
        get {
            return objc_getAssociatedObject(self, &_markDirty) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &_markDirty, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 对象的数据Block
    var sAttributeBlockArray: [String: Any] {
        get {
            if objc_getAssociatedObject(self, &_sAttributeBlockArray) == nil {
                self.sAttributeBlockArray = [:]
            }
            return objc_getAssociatedObject(self, &_sAttributeBlockArray) as? [String : Any] ?? [:]
        }
        set {
            objc_setAssociatedObject(self, &_sAttributeBlockArray, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 属性渲染刷新
    func sRefreshUI() {
        
        _ = self.sAttributeBlockArray.map { (key: String, value: Any) in
            let isSuc = SUIManager.shared.runAttributeReflect(key: key, view: self, value: value)
            if (!isSuc) {
                print("\(key) 属性更新失败")
            }
        }
    }
    
    /// 属性&自动绑定，并执行
    func autoBindAndRun(key: String, block: Any, states: [SState]? = nil) {
        bindAction(states: states, viewId: self.sViewId, attribute: key, block: block)
        SUIManager.shared.runAttributeReflect(key: key, view: self, value: block)
    }
}


// MARK: 基础布局快捷获取
public extension UIView {
    
    var n_left: Float {
        set {
            self.frame = CGRect.init(origin: CGPoint.init(x: CGFloat(newValue), y: self.frame.origin.y), size: self.frame.size)
        }
        get {
            return Float(self.frame.origin.x)
        }
    }
    
    var n_top: Float {
        set {
            self.frame = CGRect.init(origin: CGPoint.init(x: self.frame.origin.x, y: CGFloat(newValue)), size: self.frame.size)
        }
        get {
            return Float(self.frame.origin.y)
        }
    }
    
    var n_right: Float {
        set {
            self.frame = CGRect.init(origin: CGPoint.init(x: CGFloat(newValue) - self.frame.size.width, y: self.frame.origin.y), size: self.frame.size)
        }
        get {
            return Float(self.frame.origin.x + self.frame.size.width)
        }
    }
    
    var n_height: Float {
        set {
            self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: CGFloat(newValue))
        }
        get {
            return Float(self.bounds.size.height)
        }
    }
    
    var n_width: Float {
        set {
            self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: CGFloat(newValue), height: self.frame.size.height)
        }
        get {
            return Float(self.bounds.size.width)
        }
    }
    
    var n_bottom: Float {
        set {
            self.frame = CGRect.init(origin: CGPoint.init(x: self.frame.origin.x, y: CGFloat(newValue) - self.frame.size.height), size: self.frame.size)
        }
        get {
            return Float(self.frame.size.height + self.frame.origin.y)
        }
    }
    
    var n_centerX: Float {
        set {
            self.center = CGPoint.init(x: CGFloat(newValue), y: self.center.y)
        }
        get {
            return Float(self.center.x)
        }
    }
    
    var n_centerY: Float {
        set {
            self.center = CGPoint.init(x: self.center.x, y: CGFloat(newValue))
        }
        get {
            return Float(self.center.y)
        }
    }
    
    var n_size: CGSize {
        set {
            self.frame = CGRect.init(origin: CGPoint.init(x: self.frame.origin.x, y: self.frame.origin.y), size: newValue)
        }
        get {
            return self.frame.size
        }
    }
}

class SUIViewClick : Any {
    /// 点击事件
    var click : (UIView) -> Void = {_ in return}
    /// 点击手势识别器
    var tap: UITapGestureRecognizer?
}

private var _sViewClick: Void?

// MARK: 点击事件
public extension UIView {
    
    /// 保存点击事件对象
    internal var sViewClick : SUIViewClick? {
        get {
            return objc_getAssociatedObject(self, &_sViewClick) as? SUIViewClick
        }
        set {
            objc_setAssociatedObject(self, &_sViewClick, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @discardableResult
    /// 配置点击事件
    /// - Parameter click: 点击
    /// - Returns: 返回
    func onClick(_ click: @escaping ((UIView) -> Void)) -> Self {
        self.sViewClick = SUIViewClick()
        self.sViewClick?.click = click
        
        if let self = self as? UIControl {
            self.addTarget(self, action: #selector(onClickAction), for: .touchUpInside)
        } else {
            if let tap = self.sViewClick?.tap {
                self.removeGestureRecognizer(tap)
                self.sViewClick?.tap = nil
            }
            self.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(onClickAction))
            self.sViewClick?.tap = tap
            self.addGestureRecognizer(tap)
        }
        return self
    }
    
    @objc func onClickAction() {
        if let click = self.sViewClick?.click {
            click(self)
        }
    }
    
}
