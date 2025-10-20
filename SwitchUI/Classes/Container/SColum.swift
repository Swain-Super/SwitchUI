//
//  SColum.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/5/11.
//

import Foundation
import UIKit

/// 列布局容器
open class SColum: SContainer {
    
    /// 滚动配置
    var s_scrollType: SWScrollType = .none
    /// 横向布局
    var s_alignContent: SWAlign = .left
    /// 垂直布局
    var s_justifyContent: SWJustify = .top
    /// 内容排列计算区域
    var contentRect: CGRect = .zero
    
    public override func layout() {
        
        // 布局函数hack，帮助筛查问题
        if let layoutHack = self.sHookBlockArray["layoutHack"] as? (() -> Void) {
            layoutHack()
        }
        
        self.layoutFrame()
        
        // Colum布局必须有宽度，如果没有则设置为父级宽度
        if !isConstWidth {
            self.n_width = superview?.n_width ?? 0
        }
        
        contentRect = self.bounds
        
        // 子view自动计算尺寸
        var totalSubViewHeight: Float = Float(self.padding.top + self.padding.bottom)
        self.subviews.forEach { view in
            if view.isUseSWUI(), !(view is SBlank), view.sPosition == nil {
                
                view.sw_layoutSize(contentSize: self.sContentSize(), padding: self.padding)
                
                let marginTop: Float = countSWValue(value: view.sTop, contentSize: self.sContentSize())
                let marginBottom: Float = countSWValue(value: view.sBottom, contentSize: self.sContentSize())
                
                // 如果容器的子view也是SColum或SRow容器，并且宽高还需要计算的，就先去算一下
                if let container = view as? SContainer, (view is SColum || view is SRow) , (!view.isConstWidth || !view.isConstHeight)  {
                    container.layout()
                    // 标记已经布局完毕了
                    var sTags = container.sTags ?? [:]
                    sTags["markLayout"] = true
                    container.sTags = sTags
                }
                
                totalSubViewHeight += marginTop + Float(view.n_height) + marginBottom
            }
        }
        // 设置Blank的值
        if self.blankViewCount > 0, isConstHeight {
            var blankHeight: Float = (Float(self.n_height) - totalSubViewHeight)/Float(self.blankViewCount)
            self.subviews.forEach { view in
                if view is SBlank {
                    view.height(blankHeight)
                    view.sw_layoutSize(contentSize: self.sContentSize(), padding: self.padding)
                }
            }
        }
        
        // 左边的开始位置
        let startLeft: Float = Float(padding.left)
        // 右边的开始位置
        let startRight: Float = Float(padding.right)
        // 顶部开始位置
        var startTop: Float = Float(0)

        self.subviews.forEach { view in
            if view.isUseSWUI(), view.sPosition == nil {
                
                let marginLeft: Float = countSWValue(value: view.sLeft, contentSize: self.sContentSize())
                let marginRight: Float = countSWValue(value: view.sRight, contentSize: self.sContentSize())
                let marginTop: Float = countSWValue(value: view.sTop, contentSize: self.sContentSize())
                let marginBottom: Float = countSWValue(value: view.sBottom, contentSize: self.sContentSize())
                
                view.n_top = marginTop + startTop
                if view.sRight != nil && view.sLeft == nil {
                    view.n_right = self.n_width - marginRight - startRight
                } else {
                    if self.s_alignContent == .left {
                        view.n_left = marginLeft + startLeft
                    } else if self.s_alignContent == .center {
                        view.n_centerX = self.n_width/2 + marginLeft
                    } else if self.s_alignContent == .right {
                        view.n_right = self.n_width - marginRight - startRight
                    }
                }
                startTop = Float(view.n_bottom) + marginBottom
            }
        }
        
        contentRect.origin.x = padding.left
        contentRect.origin.y = padding.top
        contentRect.size.width = CGFloat(startLeft - Float(padding.left))
        contentRect.size.height = CGFloat(startTop)
        
        // 高度自适应
        if !isConstHeight {
            self.n_height = Float(contentRect.origin.y + contentRect.size.height + padding.bottom)
        } else {
            // 竖向自动滚动
            if (self.n_height < Float(CGRectGetMaxY(contentRect))) {
                if (s_scrollType == .scrolly || s_scrollType == .auto) {
                    self.maskToBounds(true)
                    var size: CGSize = .zero
                    size.height = CGRectGetMaxY(contentRect)
                    self.contentSize = size
                }
            }
        }
        
        // reset position
        if self.s_justifyContent != .top {
            if self.s_justifyContent == .center {
                contentRect.origin.y = contentRect.origin.y + (CGFloat(self.n_height) - contentRect.size.height)/2
            } else if self.s_justifyContent == .bottom {
                contentRect.origin.y = contentRect.origin.y + (CGFloat(self.n_height) - contentRect.size.height)
            }
            self.subviews.forEach { view in
                if view.isUseSWUI(), view.sPosition == nil {
                    view.n_left = Float(contentRect.origin.x) + view.n_left
                    view.n_top = Float(contentRect.origin.y) + view.n_top
                }
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
