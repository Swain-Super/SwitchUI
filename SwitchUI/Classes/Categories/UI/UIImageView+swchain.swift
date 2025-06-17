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
        self.autoBindAndRun(key: UIImageViewKey.image.rawValue, block: block, states: states)
        return self
    }
    
    @discardableResult
    func imageName(_ imageName: String) -> Self {
        self.image = UIImage(named: imageName)
        return self
    }
    
    @discardableResult
    func imageName(_ block: @escaping (UIView) -> String,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UIImageViewKey.imageName.rawValue, block: block, states: states)
        return self
    }
    
}
