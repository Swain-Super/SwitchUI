//
//  SRow.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/5/11.
//

import Foundation
import UIKit

/// 行布局容器
open class SRow: SContainer {
    
    /// 横向布局
    var s_alignContent: SWAlign = .left
    /// 垂直布局
    var s_justifyContent: SWJustify = .top
    /// 滚动配置
    var s_scrollType: SWScrollType = .none
    /// 内容排列计算区域
    var contentRect: CGRect = .zero
    
    /// Row 布局
    public override func layout() {
        
        // 布局函数hack，帮助筛查问题
        if let layoutHack = self.sHookBlockArray["layoutHack"] as? (() -> Void) {
            layoutHack()
        }
        
        // 先布局自身
        self.layoutFrame()
        
        // 如果垂直布局设置为非顶部自定对齐，则高度自动设置为父view的高度
        if !isConstHeight, s_justifyContent != .top {
            self.n_height = superview?.n_height ?? 0
        }
        
        contentRect = self.bounds
        
        // 子view自动计算尺寸
        var totalSubViewWidth: Float = Float(self.padding.left + self.padding.right)
        self.subviews.forEach { view in
            if view.isUseSWUI(), !(view is SBlank) {
                
                view.sw_layoutSize(contentSize: self.sContentSize(), padding: self.padding)
                
                let marginLeft: Float = countSWValue(value: view.sLeft, contentSize: self.sContentSize())
                let marginRight: Float = countSWValue(value: view.sRight, contentSize: self.sContentSize())
                
                // 如果容器的子view也是SColum或SRow容器，并且宽高还需要计算的，就先去算一下
                if let container = view as? SContainer, (view is SColum || view is SRow) , (!view.isConstWidth || !view.isConstHeight)  {
                    container.layout()
                    // 标记已经布局完毕了
                    var sTags = container.sTags ?? [:]
                    sTags["markLayout"] = true
                    container.sTags = sTags
                }
                totalSubViewWidth += marginLeft + Float(view.n_width) + marginRight
            }
        }
        // 设置Blank的值
        if self.blankViewCount > 0, isConstWidth {
            let blankWidth: Float = (Float(self.n_width) - totalSubViewWidth)/Float(self.blankViewCount)
            self.subviews.forEach { view in
                if view is SBlank {
                    view.width(blankWidth)
                    view.sw_layoutSize(contentSize: self.sContentSize(), padding: self.padding)
                }
            }
        }
        
        // 左边的开始位置
        var startLeft: Float = 0.0
        // 顶部开始位置
        var startTop: Float = 0.0
        // 自动布局行高
        var cellHeight: Float = 0
        
        switch s_alignContent {
        case .left:
            self.subviews.forEach { view in
                if view.isUseSWUI(), view.sPosition == nil {
                    
                    let marginLeft: Float = countSWValue(value: view.sLeft, contentSize: self.sContentSize())
                    let marginRight: Float = countSWValue(value: view.sRight, contentSize: self.sContentSize())
                    let marginTop: Float = countSWValue(value: view.sTop, contentSize: self.sContentSize())
                    let marginBottom: Float = countSWValue(value: view.sBottom, contentSize: self.sContentSize())
                    
                    let targertLeft = marginLeft + startLeft
                    
                    view.n_left = targertLeft
                    switch s_justifyContent {
                    case .top:
                        view.n_top = marginTop + startTop
                        break
                    case .center:
                        view.n_centerY = self.n_height/2 - marginTop
                        break
                    case .bottom:
                        view.n_bottom = self.n_height - marginBottom
                        break
                    }
                    
                    // 获取每行排列最大的高
                    if Float(view.n_bottom) + marginBottom > cellHeight {
                        cellHeight = Float(view.n_bottom) + marginBottom
                    }
                    startLeft = Float(view.n_right) + marginRight
                }
            }
            startTop += cellHeight
            
            contentRect.origin.x = padding.left
            contentRect.origin.y = padding.top
            contentRect.size.width = CGFloat(startLeft)
            contentRect.size.height = CGFloat(startTop)
            
            var isScrollX = false
            var isScrollY = false
             
            // 宽度自适应
            if !isConstWidth {
                self.n_width = Float(contentRect.size.width + padding.left + padding.right)
            } else {
                
                if (s_scrollType == .scrollx || s_scrollType == .auto), Float(contentRect.size.width + padding.left + padding.right) > self.n_width  {
                    isScrollX = true
                }
                
            }
            // 高度自适应
            if !isConstHeight {
                self.n_height = Float(contentRect.size.height + padding.top + padding.bottom)
            } else {
                if (s_scrollType == .scrolly || s_scrollType == .auto), Float(contentRect.size.height + padding.top + padding.bottom) > self.n_height  {
                    isScrollY = true
                }
            }
            
            if isScrollX || isScrollY {
                self.maskToBounds(true)
                var size: CGSize = self.contentSize
                if isScrollX  {
                    size.width = contentRect.size.width + padding.left + padding.right
                }
                if isScrollY  {
                    size.height = contentRect.size.height + padding.top + padding.bottom
                }
                self.contentSize = size
            }
            
            break
        case .center:
            
            self.subviews.forEach { view in
                if view.isUseSWUI(), view.sPosition == nil {
                    
                    let marginLeft: Float = countSWValue(value: view.sLeft, contentSize: self.sContentSize())
                    let marginRight: Float = countSWValue(value: view.sRight, contentSize: self.sContentSize())
                    let marginTop: Float = countSWValue(value: view.sTop, contentSize: self.sContentSize())
                    let marginBottom: Float = countSWValue(value: view.sBottom, contentSize: self.sContentSize())
                    
                    let targertLeft = marginLeft + startLeft
                    
                    view.n_left = targertLeft
                    switch s_justifyContent {
                    case .top:
                        view.n_top = marginTop + startTop
                        break
                    case .center:
                        view.n_centerY = self.n_height/2 - marginTop
                        break
                    case .bottom:
                        view.n_bottom = self.n_height - marginBottom
                        break
                    }
                    
                    // 获取每行排列最大的高
                    if Float(view.n_bottom) + marginBottom > cellHeight {
                        cellHeight = Float(view.n_bottom) + marginBottom
                    }
                    startLeft = Float(view.n_right) + marginRight
                }
            }
            startTop += cellHeight
            
            contentRect.origin.x = padding.left
            contentRect.origin.y = padding.top
            contentRect.size.width = CGFloat(startLeft)
            contentRect.size.height = CGFloat(startTop)
            
            // 宽度自适应
            if !isConstWidth {
                self.n_width = Float(contentRect.size.width + padding.left + padding.right)
            } else {
                // 居中对齐
                contentRect.origin.x = CGFloat(self.n_width)/2 - contentRect.size.width/2
            }
            // 高度自适应
            if !isConstHeight {
                self.n_height = Float(contentRect.size.height + padding.top + padding.bottom)
            }
            break
        case .right:
            
            self.subviews.forEach { view in
                if view.isUseSWUI(), view.sPosition == nil {
                    
                    let marginLeft: Float = countSWValue(value: view.sLeft, contentSize: self.sContentSize())
                    let marginRight: Float = countSWValue(value: view.sRight, contentSize: self.sContentSize())
                    let marginTop: Float = countSWValue(value: view.sTop, contentSize: self.sContentSize())
                    let marginBottom: Float = countSWValue(value: view.sBottom, contentSize: self.sContentSize())
                    
                    let targertLeft = startLeft - marginRight - Float(view.n_width)
                    
                    view.n_left = targertLeft
                    switch s_justifyContent {
                    case .top:
                        view.n_top = marginTop + startTop
                        break
                    case .center:
                        view.n_centerY = self.n_height/2 - marginTop
                        break
                    case .bottom:
                        view.n_bottom = self.n_height - marginBottom
                        break
                    }
                    
                    // 获取每行排列最大的高
                    if Float(view.n_bottom) + marginBottom > cellHeight {
                        cellHeight = Float(view.n_bottom) + marginBottom
                    }
                    startLeft = Float(view.n_left) - marginLeft
                }
            }
            startTop += cellHeight
            
            contentRect.origin.x = padding.left
            contentRect.origin.y = padding.top
            contentRect.size.width = CGFloat(-startLeft)
            contentRect.size.height = CGFloat(startTop)
            
            let totalWidth: Float = startLeft
            // 数值回正
            self.subviews.forEach { view in
                if view.isUseSWUI() {
                    view.n_left = totalWidth - view.n_left
                }
            }
            
            var isScrollX = false
            var isScrollY = false
             
            // 宽度自适应
            if !isConstWidth {
                self.n_width = Float(contentRect.size.width + padding.left + padding.right)
            } else {
                if (s_scrollType == .scrollx || s_scrollType == .auto), Float(contentRect.size.width + padding.left + padding.right) > self.n_width  {
                    isScrollX = true
                }
            }
            // 高度自适应
            if !isConstHeight {
                self.n_height = Float(contentRect.size.height + padding.top + padding.bottom)
            } else {
                if (s_scrollType == .scrolly || s_scrollType == .auto), Float(contentRect.size.height + padding.top + padding.bottom) > self.n_height  {
                    isScrollY = true
                }
            }
            
            if isScrollX || isScrollY {
                self.maskToBounds(true)
                var size: CGSize = self.contentSize
                if isScrollX  {
                    size.width = contentRect.size.width + padding.left + padding.right
                }
                if isScrollY  {
                    size.height = contentRect.size.height + padding.top + padding.bottom
                }
                self.contentSize = size
            }
            
            break
        }
        
        // reset position
        self.subviews.forEach { view in
            if view.isUseSWUI(), view.sPosition == nil {
                view.n_left = Float(contentRect.origin.x) + view.n_left
                view.n_top = Float(contentRect.origin.y) + view.n_top
            }
        }
        
        super.layout()
    }
    
    /// 滚动配置
    @discardableResult
    public func scrollType(_ type: SWScrollType) -> Self {
        self.s_scrollType = type
        return self
    }
    
    /// 横向对齐方式
    @discardableResult
    public func alignContent(_ value: SWAlign) -> Self {
        self.s_alignContent = value
        return self
    }
    
    /// 垂直对齐方式
    /// param：value 对齐方式   top 上边 center 中间 bottom 下边(注意设置底部对齐一定要设置容器的高度，否则会不对)
    @discardableResult
    public func justifyContent(_ value: SWJustify) -> Self {
        self.s_justifyContent = value
        return self
    }
    
}
