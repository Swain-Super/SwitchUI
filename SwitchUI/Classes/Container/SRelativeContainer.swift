//
//  SRelativeContainer.swift
//  SWUI
//
//  Created by swain wang on 2024/12/5.
//

import Foundation
import UIKit

/// 相对布局容器
open class SRelativeContainer: SContainer {
    
    public override func layout() {
        
        // 布局函数hack，帮助筛查问题
        if let layoutHack = self.sHookBlockArray["layoutHack"] as? (() -> Void) {
            layoutHack()
        }
     
        self.layoutFrame()
        
        // SRelativeContainer布局必须有宽度，如果没有则设置为父级宽度
        if !isConstWidth {
            self.n_width = superview?.n_width ?? 0
        }
        // SRelativeContainer布局必须有高度，如果没有则设置为父级高度
        if !isConstHeight {
            self.n_height = superview?.n_height ?? 0
        }
        
        // 子视图尺寸排列
        self.subviews.forEach { view in
            if view.isUseSWUI() {
                view.sw_layoutSize(contentSize: self.sContentSize(), padding: self.padding)
                
                // 如果容器的子view也是SColumn或SRow容器，并且宽高还需要计算的，就先去算一下
                if let container = view as? SContainer, (view is SColumn || view is SRow) , (!view.isConstWidth || !view.isConstHeight)  {
                    container.layout()
                    // 标记已经布局完毕了
                    var sTags = container.sTags ?? [:]
                    sTags["markLayout"] = true
                    container.sTags = sTags
                }
            }
        }
        
        self.subviews.forEach { view in
            if view.isUseSWUI(), view.sPosition == nil {
                self.layoutAlignRules(view: view)
            }
        }
        
        super.layout()
    }
    
    /// 基于AlignRules来布局
    /// - Parameter view: 视图
    func layoutAlignRules(view: UIView) {
        
        let marginLeft: CGFloat = countSWValue(value: view.sLeft, contentSize: self.sContentSize())
        let marginRight: CGFloat = countSWValue(value: view.sRight, contentSize: self.sContentSize())
        let marginTop: CGFloat = countSWValue(value: view.sTop, contentSize: self.sContentSize())
        let marginBottom: CGFloat = countSWValue(value: view.sBottom, contentSize: self.sContentSize())
        
        if let alignRules = view.sAlignRules {
            // 计算x的位置，centerX优先级最高
            if let centerX = alignRules.centerX {
                view.n_centerX = self.getAnchorPosition(anchorItem: centerX)
            } else {
                if let left = alignRules.left {
                    view.n_left = self.getAnchorPosition(anchorItem: left)
                } else if let right = alignRules.right {
                    view.n_right = self.getAnchorPosition(anchorItem: right)
                }
            }
            
            if view.sLeft != nil {
                view.n_left+=marginLeft
            } else if view.sRight != nil {
                view.n_right-=marginRight
            }
            
            // 计算y的位置，centerY优先级最高
            if let centerY = alignRules.centerY {
                view.n_centerY = self.getAnchorPosition(anchorItem: centerY)
            } else {
                if let top = alignRules.top {
                    view.n_top = self.getAnchorPosition(anchorItem: top)
                } else if let bottom = alignRules.bottom {
                    view.n_bottom = self.getAnchorPosition(anchorItem: bottom)
                }
            }
            
            if view.sTop != nil {
                view.n_top+=marginTop
            } else if view.sBottom != nil {
                view.n_bottom+=marginBottom
            }
        } else {
            if view.sLeft != nil {
                view.n_left = marginLeft + CGFloat(padding.left)
            } else if view.sRight != nil {
                view.n_right = self.n_width - marginRight - CGFloat(padding.right)
            }
            if view.sTop != nil {
                view.n_top = marginTop + CGFloat(padding.top)
            } else if view.sBottom != nil {
                view.n_bottom = self.n_height - CGFloat(padding.bottom) - marginBottom
            }
        }
    }
    
    /// 获取对比对象的位置
    /// - Parameter anchorItem: 关联对象
    /// - Returns: 定位
    func getAnchorPosition(anchorItem: SWAlignRuleItem) -> CGFloat {
        
        if let anchor = self.getAnchor(anchor: anchorItem.anchor) {
            
            switch anchorItem.position {
            case .left:
                return anchor.n_left
                break
            case .right:
                return anchor.n_right
                break
            case .top:
                return anchor.n_top
                break
            case .bottom:
                return anchor.n_bottom
                break
            case .centerX:
                return anchor.n_centerX
                break
            case .centerY:
                return anchor.n_centerY
                break
            default:
                break
            }
        }
        return 0.0
    }
    
    /// 获取关注对象
    /// - Parameter anchor: 对象标识 Id
    /// - Returns: 关注对象
    func getAnchor(anchor: String) -> UIView? {
        if anchor == SSuperContainer {
            return self
        } else {
            return SUIManager.shared.findComponents(viewId: anchor)
        }
    }
}
