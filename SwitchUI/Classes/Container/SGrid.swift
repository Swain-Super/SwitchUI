//
//  SGrid.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/5/11.
//

import Foundation
import UIKit

/// 网格布局容器
open class SGrid: SContainer {
    
    /// 滚动配置
    var s_scrollType: SWScrollType = .scrolly
    /// 行间距
    var rowSpace: SWValue?
    /// 列间距
    var columnSpace: SWValue?
    /// 行中Item数量 默认：1个
    var rowsNumber: Int = 1
    /// 列中Item数量 默认：1个
    var columnsNumber: Int = 1
    /// 内容排列计算区域
    var contentRect: CGRect = .zero
    /// 每个网格的项目的高，设置后每个网格高都会指定为itemWidth
    var itemWidth: SWValue?
    /// 每个网格的项目的高，设置后每个网格高都会指定为itemHeight
    var itemHeight: SWValue?
    /// 自动分割view，view不用自己设置宽高会自动计算
    /// MARK：要使用必须设置 grid宽高，itemHeight 值
    var autoSplit: Bool = false
    
    public override func layout() {
        
        // 布局函数hack，帮助筛查问题
        if let layoutHack = self.sHookBlockArray["layoutHack"] as? (() -> Void) {
            layoutHack()
        }
        
        self.layoutFrame()
        
        // Grid布局必须有宽度或高度，如果都没有则设置为父级尺寸
        if !isConstWidth && !isConstHeight {
            self.n_width = superview?.n_width ?? 0
            self.n_height = superview?.n_height ?? 0
        }
        
        contentRect = self.bounds
        
        // 绝对布局计算
        if self.absoluteViewCount > 0 {
            self.subviews.forEach { view in
                if view.isUseSWUI() {
                    view.sw_layoutSize(contentSize: self.sContentSize(), padding: self.padding)
                }
            }
        }
        
        // 左边的开始位置
        var startLeft: CGFloat = CGFloat(padding.left)
        // 顶部开始位置
        var startTop: CGFloat = CGFloat(padding.top)
        // 行间距
        var rowSpace: CGFloat = countSWValue(value: rowSpace, contentSize: self.sContentSize())
        // 列间距
        var columnSpace: CGFloat = countSWValue(value: columnSpace, contentSize: self.sContentSize())
        
        var columnIndex: Int = 0
        var rowIndex: Int = 0
        var maxWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        var index: Int = 0
        
        var itemWidth: CGFloat = countSWValue(value: itemWidth, contentSize: self.sContentSize())
        var itemHeight: CGFloat = countSWValue(value: itemHeight, contentSize: self.sContentSize())
        
        if (s_scrollType == .scrolly) {
            /// 高度自适应的

            // 是否第一个item的宽高为所有 item 的宽高
            var isItemSizeDependFirstView: Bool = false
            if self.autoSplit {
                let contentWidth = self.n_width - CGFloat(padding.left) - CGFloat(padding.right)
                if self.rowSpace != nil, self.itemWidth == nil {
                    itemWidth = (contentWidth - (CGFloat(self.rowsNumber - 1) * rowSpace)) / CGFloat(self.rowsNumber)
                } else if self.rowSpace != nil, self.itemWidth != nil {
                    
                } else if self.rowSpace == nil, self.itemWidth == nil {
                    // 获取第一个item的宽高为所有 item 的宽高
                    //splitWidth = (contentWidth - (Float(self.rowsNumber - 1) * rowSpace)) / CGFloat(self.rowsNumber)
                    isItemSizeDependFirstView = true
                } else if self.rowSpace == nil, self.itemWidth != nil {
                    
                    // rowSpace 为空的，先平均分
                    if (self.totalViewCount > 1 && self.totalViewCount < self.rowsNumber) {
                        rowSpace = (contentWidth - CGFloat(self.totalViewCount) * itemWidth)/CGFloat(self.totalViewCount-1)
                    } else if self.rowsNumber > 1 {
                        rowSpace = (contentWidth - CGFloat(self.rowsNumber) * itemWidth)/CGFloat(self.rowsNumber-1)
                    }
                }
            }
            
            self.subviews.forEach { view in
                if view.isUseSWUI(), view.sPosition == nil {
                    view.sw_layoutSize(contentSize: self.sContentSize(), padding: self.padding)
                    
                    if self.itemHeight != nil {
                        view.n_height = itemHeight
                        view.height(itemHeight)
                    }
                    
                    /// 第一个item的宽高为所有 item 的宽高
                    if isItemSizeDependFirstView {
                        isItemSizeDependFirstView = false
                        if let container = view as? SContainer {
                            container.layout()
                        }
                        itemWidth = view.n_width
                        itemHeight = view.n_height
                    }
                    
                    view.n_width = itemWidth
                    view.width(itemWidth)
                    
                    view.n_left = CGFloat(startLeft + (rowIndex > 0 ? rowSpace : 0))
                    view.n_top = CGFloat(startTop + (columnIndex > 0 ? columnSpace : 0))

                    /// 高度最大值
                    if view.n_right > maxWidth {
                        maxWidth = view.n_right
                    }
                    
                    rowIndex+=1
                    
                    // 行排满了,换下一行
                    if rowIndex >= self.rowsNumber {
                        rowIndex = 0
                        columnIndex += 1
                        startTop = CGFloat(view.n_bottom)
                        startLeft = 0
                    } else {
                        startLeft = CGFloat(view.n_right)
                        // 最后一个了
                        if index == self.subviews.count-1 {
                            startTop = CGFloat(view.n_bottom)
                        }
                    }
                }
                index+=1
            }
            startLeft = CGFloat(maxWidth)
            
        } else if s_scrollType == .scrollx {

            // 是否第一个item的宽高为所有 item 的宽高
            var isItemSizeDependFirstView: Bool = false
            if self.autoSplit {
                let contentHeight: CGFloat = self.n_height - padding.top - padding.bottom
                if self.columnSpace != nil, self.itemHeight == nil {
                    itemHeight = (contentHeight - (CGFloat(self.columnsNumber - 1) * columnSpace)) / CGFloat(self.columnsNumber)
                } else if self.columnSpace != nil, self.itemHeight != nil {
                    
                } else if self.columnSpace == nil, self.itemHeight == nil {
                    // 获取第一个item的宽高为所有 item 的宽高
                    // splitHeight = (contentHeight - (Float(self.columnsNumber - 1) * columnSpace)) / CGFloat(self.columnsNumber)
                    isItemSizeDependFirstView = true
                } else if self.columnSpace == nil, self.itemHeight != nil {
                    if (self.totalViewCount > 1 && self.totalViewCount < self.columnsNumber) {
                        columnSpace = (contentHeight - CGFloat(self.totalViewCount) * itemHeight)/CGFloat(self.totalViewCount-1)
                    } else if self.columnsNumber > 1 {
                        columnSpace = (contentHeight - CGFloat(self.columnsNumber) * itemHeight)/CGFloat(self.columnsNumber-1)
                    }
                }
            }
            
            self.subviews.forEach { view in
                if view.isUseSWUI(), view.sPosition == nil {
                    view.sw_layoutSize(contentSize: self.sContentSize(), padding: self.padding)
                    
                    if self.itemWidth != nil {
                        view.n_width = itemWidth
                        view.width(itemWidth)
                    }
                    
                    /// 第一个item的宽高为所有 item 的宽高
                    if isItemSizeDependFirstView {
                        isItemSizeDependFirstView = false
                        if let container = view as? SContainer {
                            container.layout()
                        }
                        itemWidth = view.n_width
                        itemHeight = view.n_height
                    }
                    
                    view.n_height = itemHeight
                    view.height(itemHeight)
                    
                    
                    view.n_left = CGFloat(startLeft + (rowIndex > 0 ? rowSpace : 0))
                    view.n_top = CGFloat(startTop + (columnIndex > 0 ? columnSpace : 0))

                    /// 高度最大值
                    if view.n_bottom > maxHeight {
                        maxHeight = view.n_bottom
                    }
                    
                    columnIndex+=1
                    
                    // 列排满了,换下一列
                    if columnIndex >= self.columnsNumber {
                        columnIndex = 0
                        rowIndex += 1
                        startLeft = CGFloat(view.n_right)
                        startTop = 0
                    } else {
                        startTop = CGFloat(view.n_bottom)
                        // 最后一个了
                        if index == self.subviews.count-1 {
                            startLeft = CGFloat(view.n_right)
                        }
                    }
                }
                index+=1
            }
            startTop = CGFloat(maxHeight)
        }
        
        contentRect.origin.x = padding.left
        contentRect.origin.y = padding.top
        contentRect.size.width = CGFloat(startLeft)
        contentRect.size.height = CGFloat(startTop)
        
        var isScrollX = false
        var isScrollY = false
         
        // 宽度自适应
        if !isConstWidth {
            self.n_width = self.n_width + CGFloat(padding.left) + CGFloat(padding.right)
        } else {
            if (s_scrollType == .scrollx || s_scrollType == .auto), CGFloat(contentRect.size.width + padding.left + padding.right) > self.n_width  {
                isScrollX = true
            }
            
        }
        // 高度自适应
        if !isConstHeight {
            self.n_height = CGFloat(contentRect.size.height + padding.top + padding.bottom)
        } else {
            if (s_scrollType == .scrolly || s_scrollType == .auto), CGFloat(contentRect.size.height + padding.top + padding.bottom) > self.n_height  {
                isScrollY = true
            }
        }
        
        if isScrollX || isScrollY {
            
            var size: CGSize = self.contentSize
            if isScrollX  {
                size.width = contentRect.size.width + padding.left + padding.right
            }
            if isScrollY  {
                size.height = contentRect.size.height + padding.top + padding.bottom
            }
            self.contentSize = size
        }
        
        super.layout()
    }
    
    override func sContentSize() -> CGSize {
        return CGSize(width: CGFloat(self.n_width), height: CGFloat(self.n_height))
    }
    
    @discardableResult
    public func rowSpace(_ value: String) -> Self {
        self.rowSpace = SWValue(value: value, .left)
        return self
    }
    
    @discardableResult
    public func rowSpace(_ value: CGFloat) -> Self {
        self.rowSpace = SWValue(value: value.toString(), .left)
        return self
    }
    
    @discardableResult
    public func columnSpace(_ value: String) -> Self {
        self.columnSpace = SWValue(value: value, .left)
        return self
    }
    
    @discardableResult
    public func columnSpace(_ value: CGFloat) -> Self {
        self.columnSpace = SWValue(value: value.toString(), .left)
        return self
    }
    
    @discardableResult
    public func rowsNumber(_ value: Int) -> Self {
        self.rowsNumber = value
        return self
    }
    
    @discardableResult
    public func columnsNumber(_ value: Int) -> Self {
        self.columnsNumber = value
        return self
    }
    
    
    @discardableResult
    public func scrollType(_ type: SWScrollType) -> Self {
        self.s_scrollType = type
        return self
    }
    
    @discardableResult
    public func autoSplit(_ isAutoSplit: Bool) -> Self {
        self.autoSplit = isAutoSplit
        return self
    }
    
    @discardableResult
    public func itemWidth(_ value: String) -> Self {
        self.itemWidth = SWValue(value: value, .width)
        return self
    }
    
    @discardableResult
    public func itemWidth(_ value: CGFloat) -> Self {
        self.itemWidth = SWValue(value: value.toString(), .width)
        return self
    }
    
    @discardableResult
    public func itemHeight(_ value: String) -> Self {
        self.itemHeight = SWValue(value: value, .height)
        return self
    }
    
    @discardableResult
    public func itemHeight(_ value: CGFloat) -> Self {
        self.itemHeight = SWValue(value: value.toString(), .height)
        return self
    }
}
