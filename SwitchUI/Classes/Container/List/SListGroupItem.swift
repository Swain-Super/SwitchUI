//
//  SListGroupItem.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/7/16.
//

import Foundation

public class SListGroupItem: SListItem {
    
    /// 初始化容器
    /// - Parameter block: 闭包构造
    convenience init(_ block: ((inout [SListItem]) -> Void)?) {
        self.init()
        
    }
    
    public override func layout(_ contentSize: CGSize, _ scrollType: SWScrollType) {
        
        // 子SListItem布局
        _ = self.subViews?.map({ view in
            if let view = view as? SListItem {
                if scrollType == .scrolly {
                    // 垂直排列时，每一个项如果没设置宽度，则默认设置容器的宽
                    if view.sWidth == nil {
                        view.width("100%")
                    }
                } else if scrollType == .scrollx {
                    // 水平排列时，每一个项如果没设置高度，则默认设置容器的高
                    if view.sHeight == nil {
                        view.height("100%")
                    }
                }
                view.sw_layoutSize(contentSize: contentSize, padding: self.padding)
                view.layout(contentSize, scrollType)
            }
        })
        
        if scrollType == .scrolly {
            /// 垂直排列
            if self.rowContainer == nil, let subViews = self.subViews {
                self.rowContainer = SRow(subViews).width("100%")
                self.rowContainer?.padding = self.padding
                self.addSubview(self.rowContainer!)
            }
            self.rowContainer?.layout(true)
            
            if self.sHeight == nil {
                self.n_height = self.rowContainer?.n_height ?? 0
            }
        } else if scrollType == .scrollx {
            /// 水平排列
            if self.columnContainer == nil, let subViews = self.subViews {
                self.columnContainer = SColum(subViews).height("100%")
                self.columnContainer?.padding = self.padding
                self.addSubview(self.columnContainer!)
            }
            self.columnContainer?.layout(true)
            
            if self.sWidth == nil {
                self.n_width = self.columnContainer?.n_width ?? 0
            }
        }
    }
}
