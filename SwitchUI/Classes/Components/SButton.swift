//
//  SButton.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/6/3.
//

import Foundation
import UIKit

public class SButton: UIButton {
    
    /// 初始化容器
    /// - Parameter subViews: 容器的子View
    public convenience init(_ subViews: [UIView]? = nil) {
        self.init(frame: .zero)
        
        subViews?.forEach { view in
            self.addSubview(view)
        }
    }
    
    /// 初始化容器2
    /// - Parameter block: 闭包构造
    public convenience init(_ block: ((inout [UIView]) -> Void)?) {
        self.init()
        
        if let block = block {
            var subViews: [UIView] = []
            block(&subViews)
            subViews.forEach { view in
                self.addSubview(view)
            }
        }
    }
}
