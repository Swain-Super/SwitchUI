//
//  SList.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/7/16.
//

import Foundation

import UIKit

/// 列表子项构建类型
public enum SListBuildType {
    case itemList   // 列表构建
    case itemBlock  // 异步列表构建
    case forEach    // 循环对象构建
}

/// 列表
open class SList: SContainer {
    
    /// 滚动配置，默认垂直滚动
    var scrollType: SWScrollType = .scrolly
    /// 行间距
    var space: SWValue?
    /// 内容构造器对象
    public var itemIterate: (() -> [SListItem])?
    /// 循环构造器对象
    public var forEach: SForEach?
    /// 列表构建方式
    var buildType: SListBuildType = .itemList
    /// 内容排列计算区域
    var contentRect: CGRect = .zero
    /// 列表项的内容
    var itemList:[SListItem] = []
    /// 预加载的列表项数量 默认：1
    var preLoadCount: Int = 1
    
    /// 初始化容器
    /// - Parameter itemIterate: tiem迭代构造
    public convenience init(_ items: [SListItem]) {
        self.init()
        self.buildType = .itemList
        self.itemList = items
    }
    
    /// 初始化容器
    /// - Parameter itemIterate: tiem迭代构造
    public convenience init(_ itemIterate: @escaping (() -> [SListItem])) {
        self.init()
        self.buildType = .itemBlock
        self.itemIterate = itemIterate
    }
    
    /// 初始化容器
    /// - Parameter foreach: foreach对象构造
    public convenience init(_ foreach: SForEach) {
        self.init()
        self.buildType = .forEach
        self.forEach = foreach
    }
    
    /// 主动刷新列表
    public func reload() {
        
        // 先移除所有子项
        _ = self.itemList.map { listItem in
            
            listItem.removeFromSuperview()
        }
        self.itemList.removeAll()
        
        self.reloadListItem()
        
        // 自动构建内容，计算所有列表内容尺寸
        self.buildAllItemAndCountSize()
    }
    
    
    /// 移除子项
    /// - Parameter index: 索引
    public func removeItem(index: Int) {
        if index < self.itemList.count {
            var item = self.itemList[index]
            item.removeFromSuperview()
            self.itemList.remove(at: index)
        }
        self.buildAllItemAndCountSize()
    }
    
    /// 移除首个子项
    public func removeFirst() {
        self.removeItem(index: 0)
    }
    
    /// 移除尾部子项
    public func removeLast() {
        self.removeItem(index: self.itemList.count - 1)
    }
    
    /// 移除所有子项
    public func removeAll() {
        for item in self.itemList {
            item.removeFromSuperview()
        }
        self.itemList.removeAll()
    }
    
    /// 添加新子项
    /// - Parameters:
    ///   - item: 子项数据
    ///   - index: 索引 ，默认 -1 在尾部添加
    public func addItem(item:SListItem, index: Int = -1) {
        if index == -1 {
            self.itemList.append(item)
        } else {
            self.itemList.insert(item, at: index)
        }
        self.buildAllItemAndCountSize()
    }
    
    
    /// 替换新子项
    /// - Parameters:
    ///   - index: 索引
    ///   - item: 新子项
    public func replaceItem(index: Int, item: SListItem) {
        if index < self.itemList.count {
            var item = self.itemList[index]
            item.removeFromSuperview()
            self.itemList.insert(item, at: index)
        }
        self.buildAllItemAndCountSize()
    }
    
    /// 滚动配置
    @discardableResult
    public func scrollType(_ type: SWScrollType) -> Self {
        self.scrollType = type
        return self
    }
    
    /// 列表间隙
    @discardableResult
    public func space(_ value: String) -> Self {
        self.space = SWValue(value: value, .left)
        return self
    }
    
    /// 列表间隙
    @discardableResult
    public func space(_ value: Float) -> Self {
        self.space = SWValue(value: String(value), .left)
        return self
    }
    
    
    /// 加载数据
    func reloadListItem() {
            /// 列表项内容构建
        if self.buildType == .itemBlock {
            if let itemIterate = self.itemIterate {
                self.itemList = itemIterate()
            } else {
                self.itemList = []
            }
        } else if self.buildType == .forEach {
            self.itemList.removeAll()
            if let each = self.forEach, let itemIterate = each.itemIterate {
                var index = 0
                _ = each.list?.map({ x in
                    if let item = itemIterate(x, index) as? SListItem {
                        self.itemList.append(item)
                        index+=1
                    }
                })
            }
        }
    }
    
    /// 自动构建内容，计算所有列表内容尺寸
    func buildAllItemAndCountSize() {
        
        /// 间隙
        let space: Float = countSWValue(value: self.space, contentSize: self.sContentSize())
        
        /// =========================== 尺寸计算 ===========================
        _ = self.itemList.map { listItem in
            if self.scrollType == .scrolly {
                // 垂直排列时，每一个项如果没设置宽度，则默认设置容器的宽
                if listItem.sWidth == nil {
                    listItem.width("100%")
                }
            } else if self.scrollType == .scrollx {
                // 水平排列时，每一个项如果没设置高度，则默认设置容器的高
                if listItem.sHeight == nil {
                    listItem.height("100%")
                }
            }
            listItem.sw_layoutSize(contentSize: self.sContentSize(), padding: self.padding)
        }
        
        /// =========================== 排版 ===========================
        if self.scrollType == .scrolly {
            /// 垂直排列
            var top: Float = 0.0
            _ = self.itemList.map { listItem in
                
                let marginLeft: Float = countSWValue(value: listItem.sLeft, contentSize: self.sContentSize())
                // let marginRight: Float = countSWValue(value: listItem.sRight, contentSize: self.sContentSize())
                let marginTop: Float = countSWValue(value: listItem.sTop, contentSize: self.sContentSize())
                let marginBottom: Float = countSWValue(value: listItem.sBottom, contentSize: self.sContentSize())
                
                listItem.layout(self.sContentSize(), scrollType)
                listItem.n_top = top + marginTop
                listItem.n_left = marginLeft
                
                top += listItem.n_height + marginTop + marginBottom + space
                self.addSubview(listItem)
            }
            self.contentRect.size.height = CGFloat(top)
            self.contentSize = CGSizeMake(0, CGFloat(top))
        } else if self.scrollType == .scrollx {
            /// 水平排列
            var left: Float = 0
            _ = self.itemList.map { listItem in
                
                let marginLeft: Float = countSWValue(value: listItem.sLeft, contentSize: self.sContentSize())
                let marginRight: Float = countSWValue(value: listItem.sRight, contentSize: self.sContentSize())
                let marginTop: Float = countSWValue(value: listItem.sTop, contentSize: self.sContentSize())
                // let marginBottom: Float = countSWValue(value: listItem.sBottom, contentSize: self.sContentSize())
                
                listItem.layout(self.sContentSize(), scrollType)
                listItem.n_left = left + marginLeft
                listItem.n_top = marginTop
                
                left += listItem.n_width + marginLeft + marginRight + space
                self.addSubview(listItem)
            }
            self.contentRect.size.width = CGFloat(left)
            self.contentSize = CGSizeMake(CGFloat(left), 0)
        }
        self.contentRect.origin.x = padding.left
        self.contentRect.origin.y = padding.top
        
        // reset position
        self.subviews.forEach { view in
            if view.isUseSWUI(), view.sPosition == nil {
                view.n_left = Float(contentRect.origin.x) + view.n_left
                view.n_top = Float(contentRect.origin.y) + view.n_top
            }
        }
    }
    
    public override func layout() {
        
        // 布局函数hack，帮助筛查问题
        if let layoutHack = self.sHookBlockArray["layoutHack"] as? (() -> Void) {
            layoutHack()
        }
        
        self.layoutFrame()
        
        // 列表布局必须有宽度或高度，如果都没有则设置为父级尺寸
        if !isConstWidth && !isConstHeight {
            self.n_width = superview?.n_width ?? 0
            self.n_height = superview?.n_height ?? 0
        }
        
        self.contentRect = self.bounds
        
        // 重新加载数据
        self.reloadListItem()
        
        // 自动构建内容，计算所有列表内容尺寸
        self.buildAllItemAndCountSize()
    }
}
