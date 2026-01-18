//
//  UIImageView+swchain.swift
//  Swain
//
//  Created by swain on 2023/8/6.
//

import Foundation
import UIKit

public extension UIImageView {
    
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
    
    @discardableResult
    func image(_ block: @escaping (UIView) -> UIImage?,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIImageViewKey.image.rawValue, block: block, states: states)
        } else {
            self.image(block(self))
        }
        return self
    }
    
    @discardableResult
    func imageName(_ imageName: String) -> Self {
        self.image = UIImage(named: imageName)
        return self
    }
    
    @discardableResult
    func imageName(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIImageViewKey.imageName.rawValue, block: block, states: states)
        } else {
            self.imageName(block(self))
        }
        return self
    }
    
    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    @discardableResult
    func tintColor(_ block: @escaping (UIView) -> UIColor,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIImageViewKey.tintColor.rawValue, block: block, states: states)
        } else {
            self.tintColor(block(self))
        }
        return self
    }
    
    @discardableResult
    func tintColor(_ color: String) -> Self {
        self.tintColor = color.hexColor()
        return self
    }
    
    @discardableResult
    func tintColor(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIImageViewKey.tintColor2.rawValue, block: block, states: states)
        } else {
            self.tintColor(block(self))
        }
        return self
    }
    
    
}
