//
//  SListItem.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/7/16.
//

import Foundation
import UIKit

open class SListItem: UIView {
    
    /// 项显示索引
    var index: Int = -1
    /// 行布局
    var rowContainer: SRow?
    /// 列布局
    var columnContainer: SColumn?
    /// 子view
    var subViews: [Any]? = nil
    /// 内边距
    var padding: UIEdgeInsets = .zero
    
    /// 初始化容器
    /// - Parameter subViews: 容器的子View, , 类型为UIView或者SForEach
    public convenience init(_ subViews: [Any]? = nil) {
        self.init(frame: .zero)
        
        self.subViews = subViews
        
        _ = self.subViews?.map({ view in
            if let view = view as? UIView {
                view.enableSWUI = true
            } else if let foreach = view as? SForEach, let itemIterate = foreach.itemIterate {
                var index = 0
                _ = foreach.list?.map({ x in
                    if let item = itemIterate(x, index) as? UIView {
                        item.enableSWUI = true
                        index+=1
                    }
                })
            }
        })
    }

    /// 布局Item
    public func layout(_ contentSize: CGSize, _ scrollType: SWScrollType) {
        
        if scrollType == .scrolly {
            /// 垂直排列
            if self.rowContainer == nil, let subViews = self.subViews {
                self.rowContainer = SRow(subViews).width("100%")
                self.rowContainer?.padding = self.padding
                self.addSubview(self.rowContainer!)
            }
            
            if self.sHeight != nil {
                self.rowContainer?.sHeight = self.sHeight
            }
            
            self.rowContainer?.layout(true)
            
            if self.sHeight == nil {
                self.n_height = self.rowContainer?.n_height ?? 0
            }
        } else if scrollType == .scrollx {
            /// 水平排列
            if self.columnContainer == nil, let subViews = self.subViews {
                self.columnContainer = SColumn(subViews).height("100%")
                self.columnContainer?.padding = self.padding
                self.addSubview(self.columnContainer!)
            }
            
            if self.sWidth != nil {
                self.columnContainer?.sWidth = self.sWidth
            }
            
            self.columnContainer?.layout(true)
            
            if self.sWidth == nil {
                self.n_width = self.columnContainer?.n_width ?? 0
            }
        }
    }
}

extension SListItem {

    @discardableResult
    public func padding(_ padding: UIEdgeInsets) -> Self {
        self.padding = padding
        return self
    }
    
    @discardableResult
    public func paddingTop(_ value: CGFloat) -> Self {
        self.padding.top = CGFloat(value)
        return self
    }
    
    @discardableResult
    public func paddingBottom(_ value: CGFloat) -> Self {
        self.padding.bottom = CGFloat(value)
        return self
    }
    
    @discardableResult
    public func paddingLeft(_ value: CGFloat) -> Self {
        self.padding.left = CGFloat(value)
        return self
    }
    
    @discardableResult
    public func paddingRight(_ value: CGFloat) -> Self {
        self.padding.right = CGFloat(value)
        return self
    }
    
    @discardableResult
    public func paddingVertical(_ value: CGFloat) -> Self {
        self.padding.top = CGFloat(value)
        self.padding.bottom = CGFloat(value)
        return self
    }
    
    @discardableResult
    public func paddingHorizontal(_ value: CGFloat) -> Self {
        self.padding.left = CGFloat(value)
        self.padding.right = CGFloat(value)
        return self
    }
    
}
