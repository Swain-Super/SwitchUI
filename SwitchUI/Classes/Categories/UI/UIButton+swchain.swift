//
//  UIButton+swchain.swift
//  Swain
//
//  Created by swain on 2023/7/26.
//

import Foundation
import UIKit

public extension UIButton {
    
    @discardableResult
    func image(_ image: UIImage?, state: UIControl.State) -> Self {
        self.setImage(image, for: state)
        return self
    }
    
    @discardableResult
    func image(_ block: @escaping (UIView) -> UIImage?,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UIButtonKey.image.rawValue, block: block, states: states)
        return self
    }
    
    @discardableResult
    func setTitle(_ title: String, state: UIControl.State) -> Self {
        self.setTitle(title, for: state)
        return self
    }
    
    @discardableResult
    func setTitle(_ block: @escaping (UIView) -> (String, UIControl.State),_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UIButtonKey.setTitle.rawValue, block: block, states: states)
        return self
    }
    
    @discardableResult
    func titleFont(_ titleFont: UIFont) -> Self {
        self.titleLabel?.font = titleFont
        return self
    }
    
    @discardableResult
    func titleFont(_ block: @escaping (UIView) -> UIFont,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UIButtonKey.titleFont.rawValue, block: block, states: states)
        return self
    }
    
    @discardableResult
    func setTitleColor(_ color: UIColor, state: UIControl.State) -> Self {
        self.setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult
    func setTitleColor(_ block: @escaping (UIView) -> UIColor,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UIButtonKey.setTitleColor.rawValue, block: block, states: states)
        return self
    }
    
}
