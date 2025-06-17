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
        
        // 子view自动计算尺寸
        var totalSubViewHeight: Float = Float(self.padding.top + self.padding.bottom)
        self.subviews.forEach { view in
            if view.isUseSWUI(), !(view is SBlank) {
                
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
        var startTop: Float = Float(padding.top)

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
        
        startTop += Float(padding.bottom)
        
        // 高度自适应
        if !isConstHeight {
            self.n_height = startTop
        } else {
            // 竖向自动滚动
            if (s_scrollType == .scrolly || s_scrollType == .auto), self.n_height < startTop {
                self.maskToBounds(true)
                var size: CGSize = .zero
                size.height = CGFloat(startTop)
                self.contentSize = size
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
}
