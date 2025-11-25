//
//  SStack.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/5/11.
//

import Foundation
import UIKit

/// 栈布局容器
open class SStack: SContainer {
    
    public override func layout() {
        
        // 布局函数hack，帮助筛查问题
        if let layoutHack = self.sHookBlockArray["layoutHack"] as? (() -> Void) {
            layoutHack()
        }
     
        self.layoutFrame()
        
        // SStack布局必须有宽度，如果没有则设置为父级宽度
        if !isConstWidth {
            self.n_width = superview?.n_width ?? 0
        }
        // SStack布局必须有高度，如果没有则设置为父级高度
        if !isConstHeight {
            self.n_height = superview?.n_height ?? 0
        }
        
        // 子视图尺寸排列
        self.subviews.forEach { view in
            if view.isUseSWUI() {
                view.sw_layoutSize(contentSize: self.sContentSize(), padding: self.padding)
            }
        }
        
        self.subviews.forEach { view in
            if view.isUseSWUI(), view.sPosition == nil {
                
                let marginLeft: CGFloat = countSWValue(value: view.sLeft, contentSize: self.sContentSize())
                let marginRight: CGFloat = countSWValue(value: view.sRight, contentSize: self.sContentSize())
                let marginTop: CGFloat = countSWValue(value: view.sTop, contentSize: self.sContentSize())
                let marginBottom: CGFloat = countSWValue(value: view.sBottom, contentSize: self.sContentSize())
                
                if view.sLeft != nil {
                    view.n_left = marginLeft + CGFloat(padding.left)
                } else if view.sRight != nil {
                    view.n_right = self.n_width - marginRight - CGFloat(padding.right)
                } else {
                    view.n_centerX = self.n_width/2
                }
                
                if view.sTop != nil {
                    view.n_top = marginTop + CGFloat(padding.top)
                } else if view.sBottom != nil {
                    view.n_bottom = self.n_height - CGFloat(padding.bottom) - marginBottom
                } else {
                    view.n_centerY = self.n_height/2
                }
            }
        }
        
        super.layout()
    }
}
