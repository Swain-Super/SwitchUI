//
//  UIControl+swchain.swift
//  SWUI
//
//  Created by swain wang on 2024/9/9.
//

import Foundation

class SUIControlClick : Any {
    var click : (UIControl) -> Void = {_ in return}
}

private var _saveClick: Void?

public extension UIControl {
    
    /// 保存点击事件对象
    internal var saveClick : SUIControlClick? {
        get {
            return objc_getAssociatedObject(self, &_saveClick) as? SUIControlClick
        }
        set {
            objc_setAssociatedObject(self, &_saveClick, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @discardableResult
    func onClick(_ click: @escaping ((UIView) -> Void), event: UIControl.Event = .touchUpInside) -> Self {
        self.saveClick = SUIControlClick()
        self.saveClick?.click = click
        self.addTarget(self, action: #selector(btnClick), for: event)
        return self
    }
    
    @objc func btnClick(){
        self.saveClick?.click(self)
    }
}
