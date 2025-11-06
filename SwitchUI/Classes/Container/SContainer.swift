//
//  SContainer.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/5/11.
//

import Foundation
import UIKit

/// 基础布局容器
open class SContainer: UIScrollView {
    
    /// 构造Block
    var subViewblock: ((inout [Any]) -> Void)?
    /// 内边距
    var padding: UIEdgeInsets = .zero
    /// 首次刷新
    var firstLayout = true
    /// 重载子容器
    var reloader: SReloader?
    /// 子视图的数量
    var totalViewCount = 0
    /// Blank的数量
    var blankViewCount = 0
    /// Absolute的数量
    var absoluteViewCount = 0
    /// 绘制自定义边框圆角背景
    var s_borderColor: SBorderColor?
    var s_borderWidth: SBorderWidth?
    var s_radius: SRadius?
    var s_backgroundColor: UIColor?
    
    /// 初始化容器
    /// - Parameter subViews: 容器的子View, 类型为UIView或者SForEach
    public convenience init(_ subViews: [Any]? = nil) {
        self.init(frame: .zero)
        
        self.customInit()
        
        if let subViews = subViews {
            self.commonAddSubView(subViews: subViews)
        }
    }
    
    /// 初始化容器2
    /// - Parameter block: 闭包构造
    public convenience init(_ subViewblock: ((inout [Any]) -> Void)?) {
        self.init()
        
        self.customInit()
        
        self.subViewblock = subViewblock
        
        self.subViewAddBlock()
    }
    
    /// 初始化容器3
    /// - Parameter reload: 子view加载器
    public convenience init(_ reloader: SReloader) {
        self.init()
        
        self.customInit()
        
        self.reloader = reloader
        
        self.reloader?.superViewId = self.sViewId
        
        self.reloadSubViewAddBlock()
    }
    
    func customInit() {
        /// 移除内边距
        if #available(iOS 13.0, *) {
            self.automaticallyAdjustsScrollIndicatorInsets = false
        }
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
            self.insetsLayoutMarginsFromSafeArea = false
        }
        self.maskToBounds(false)
    }
    
    /// 添加子view
    /// - Parameter subViews: 子views
    func commonAddSubView(subViews: [Any]) {
        self.totalViewCount = 0
        self.blankViewCount = 0
        self.absoluteViewCount = 0
        
        /// 添加子view
        var subViewAppendBlk: (UIView) -> Void = { [weak self] (view) -> Void in
            guard let self = self else { return }
            
            self.totalViewCount += 1
            view.enableSWUI = true
            if view is SBlank {
                self.blankViewCount += 1
            }
            if view.sPosition != nil {
                self.absoluteViewCount += 1
                self.addSubview(view)
            } else {
                self.containerView().addSubview(view)
            }
        }
        
        subViews.forEach { view in
            if let view = view as? UIView {
                subViewAppendBlk(view)
            } else if let foreach = view as? SForEach, let itemIterate = foreach.itemIterate {
                var index = 0
                _ = foreach.list?.map({ x in
                    if let item = itemIterate(x, index) as? UIView {
                        subViewAppendBlk(item)
                        index+=1
                    }
                })
            } else if let sif = view as? SIF {
                if sif.condition, let trueBlock = sif.trueBlock {
                    trueBlock.map { x in
                        if let x = x as? UIView {
                            subViewAppendBlk(x)
                        }
                    }
                } else if !sif.condition, let falseBlock = sif.falseBlock {
                    falseBlock.map { x in
                        if let x = x as? UIView {
                            subViewAppendBlk(x)
                        }
                    }
                }
            }
        }
    }
    
    /// 根据Block构造子view
    func subViewAddBlock() {
        
        if let block = self.subViewblock {
            self.removeSubviews()
            
            var subViews: [Any] = []
            block(&subViews)
            
            self.commonAddSubView(subViews: subViews)
        }
    }
    
    /// 根据Reloader构造子view
    func reloadSubViewAddBlock() {
        
        if let executeBlock = self.reloader?.executeBlock {
            self.removeSubviews()
            let subViews = executeBlock()
            self.commonAddSubView(subViews: subViews)
        }
    }
    
    /// frame监听改动监听
    @discardableResult
    public func setLayoutHack(_ block: @escaping () -> Void) -> Self {
        self.sHookBlockArray["layoutHack"] = block
        return self
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func isUseSWUI() -> Bool {
        if unVisibleInSWUI {
            return false
        }
        return true
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if layer.bounds.size == .zero {
            return
        }
        
        /// 添加自定义border和radius
        if self.s_borderWidth != nil
            || self.s_radius != nil {
            self.customDisplay(self.layer)
        }
    }
    
    /// 自动布局
    public func layout() {
        
        // 布局设置了position的view
        if self.absoluteViewCount > 0 {
            self.subviews.forEach { view in
                if view.sPosition != nil {
                    view.sw_layoutSize(contentSize: self.sContentSize(), padding: self.padding)
                    self.layoutPosition(view: view)
                }
            }
        }
        
        layoutSubViews(superView: self)
        
        if firstLayout {
            firstLayout = false
        }
    }
    
    /// 自动布局
    /// - Parameter root: 是否是根节点
    public func layout(_ root: Bool = false) {
        
        self.layout()
        
        if root {
            if let sLeft = sLeft {
                let marginLeft: Float = countSWValue(value: self.sLeft, contentSize: self.sContentSize())
                self.n_left = marginLeft
            } else if let sRight = sRight {
                let marginRight: Float = countSWValue(value: self.sRight, contentSize: self.sContentSize())
                self.n_left = self.n_width - marginRight
            }
            
            if let sTop = sTop {
                let marginTop: Float = countSWValue(value: self.sTop, contentSize: self.sContentSize())
                self.n_top = marginTop
            } else if let sBottom = sBottom {
                let marginBottom: Float = countSWValue(value: self.sBottom, contentSize: self.sContentSize())
                self.n_top = self.n_height - marginBottom
            }
            
        }
    }
    
    func layoutSubViews(superView: UIView) {
          
        superView.subviews.forEach { view in
            
            // 被标记过已经先进行过布局的，不再布局
            if view.sTags?["markLayout"] as? Bool ?? false == true {
                view.sTags?["markLayout"] = false
                return
            }
            
            if let container: SContainer = view as? SContainer {
                let isroot = !(superView is SContainer)
                container.layout(isroot)
            } else {
                layoutSubViews(superView: view)
            }
        }
    }
    
    func layoutFrame() {
        
        // 先布局自身
        if let superContainer = self.superview as? SContainer {
            self.sw_layoutSize(contentSize: self.superContentSize(), padding: superContainer.padding)
        } else {
            self.sw_layoutSize(contentSize: self.superContentSize())
        }
        
        if let sLeft = self.sLeft, let sRight = self.sRight {
           // 同时设置了左和右,相当于确定了宽度
           let left: Float = countSWValue(value: sLeft, contentSize: self.superContentSize())
           let right: Float = countSWValue(value: sRight, contentSize: self.superContentSize())
           let width = Float(self.superview?.n_width ?? 0) - left - right
           frame.size.width = CGFloat(width)
           // isConstWidth = true
       }
    
       if let sTop = self.sTop, let sBottom = self.sBottom {
           // 同时设置了上和下
           let top: Float = countSWValue(value: sTop, contentSize: self.superContentSize())
           let bottom: Float = countSWValue(value: sBottom, contentSize: self.superContentSize())
           let height = Float(self.superview?.n_height ?? 0) - top - bottom
           frame.size.height = CGFloat(height)
           // isConstHeight = true
       }
    }
    
    /// 基于position来布局
    /// - Parameter view: 视图
    func layoutPosition(view: UIView) {
        if let position = view.sPosition {
            // 计算x的位置，centerX优先级最高
            if let centerX = position.centerX {
                let centerX: Float = countSWValue(value: centerX, contentSize: self.sContentSize())
                view.n_centerX = centerX
            } else {
                if let left = position.left {
                    let left: Float = countSWValue(value: left, contentSize: self.superContentSize())
                    view.n_left = left
                } else if let right = position.right {
                    let right: Float = countSWValue(value: right, contentSize: self.superContentSize())
                    view.n_right = self.n_width - right
                }
            }
            
            // 计算y的位置，centerY优先级最高
            if let centerY = position.centerY {
                let centerY: Float = countSWValue(value: centerY, contentSize: self.sContentSize())
                view.n_centerY = centerY
            } else {
                if let top = position.top {
                    let top: Float = countSWValue(value: top, contentSize: self.superContentSize())
                    view.n_top = top
                } else if let bottom = position.bottom {
                    let bottom: Float = countSWValue(value: bottom, contentSize: self.superContentSize())
                    view.n_bottom = self.n_height - bottom
                }
            }
        }
    }
    
    /// 删除所有子view
    func removeSubviews() {
        
        _ = self.containerView().subviews.map {
            $0.removeFromSuperview()
        }
    }
    
    /// 重新添加子view
    func reloadSubViews() {
        // 基于block构建的布局
        if self.reloader != nil {
            self.reloadSubViewAddBlock()
            self.layout()
        } else if self.subViewblock != nil {
            self.subViewAddBlock()
            self.layout()
        }
    }
    
    /// 自身容器父级尺寸
    /// - Returns: 尺寸
    func sContentSize() -> CGSize {
        return CGSize(width: CGFloat(self.n_width), height: CGFloat(self.n_height))
    }
    
    /// 父级容器尺寸
    /// - Returns: Size
    func superContentSize() -> CGSize {
        return CGSize(width: CGFloat(self.superview?.n_width ?? 0), height: CGFloat(self.superview?.n_height ?? 0))
    }
    
    ///  添加子view的容器
    /// - Returns: 容器
    func containerView() -> UIView {
        return self
    }
    
    @discardableResult
    /// 隐藏横向滚动条
    /// - Parameter isHide: 是否隐藏
    /// - Returns: self
    public func setHorizontalScrollBarHide(_ isHide: Bool) -> Self {
        self.showsHorizontalScrollIndicator = !isHide
        return self
    }
    
    @discardableResult
    /// 隐藏竖向滚动条
    /// - Parameter isHide: 是否隐藏
    /// - Returns: self
    public func setVerticalScrollBarHide(_ isHide: Bool) -> Self {
        self.showsVerticalScrollIndicator = !isHide
        return self
    }
}

extension SContainer {

    @discardableResult
    public func padding(_ padding: Float) -> Self {
        self.padding = UIEdgeInsets(top: CGFloat(padding), left: CGFloat(padding), bottom: CGFloat(padding), right: CGFloat(padding))
        return self
    }
    
    @discardableResult
    public func padding(_ padding: UIEdgeInsets) -> Self {
        self.padding = padding
        return self
    }
    
    @discardableResult
    public func paddingTop(_ value: Float) -> Self {
        self.padding.top = CGFloat(value)
        return self
    }
    
    @discardableResult
    public func paddingBottom(_ value: Float) -> Self {
        self.padding.bottom = CGFloat(value)
        return self
    }
    
    @discardableResult
    public func paddingLeft(_ value: Float) -> Self {
        self.padding.left = CGFloat(value)
        return self
    }
    
    @discardableResult
    public func paddingRight(_ value: Float) -> Self {
        self.padding.right = CGFloat(value)
        return self
    }
    
    @discardableResult
    public func paddingVertical(_ value: Float) -> Self {
        self.padding.top = CGFloat(value)
        self.padding.bottom = CGFloat(value)
        return self
    }
    
    @discardableResult
    public func paddingHorizontal(_ value: Float) -> Self {
        self.padding.left = CGFloat(value)
        self.padding.right = CGFloat(value)
        return self
    }
    
}

extension SContainer {
    
    @discardableResult
    public func s_borderColor(_ object: SBorderColor) -> Self {
        self.s_borderColor = object
        return self
    }
    
    @discardableResult
    public func s_borderWidth(_ object: SBorderWidth) -> Self {
        self.s_borderWidth = object
        return self
    }
    
    @discardableResult
    public func s_radius(_ object: SRadius) -> Self {
        self.s_radius = object
        return self
    }
    
    @discardableResult
    public func s_backgroundColor(_ color: String) -> Self {
        self.s_backgroundColor = color.hexColor()
        return self
    }
}
