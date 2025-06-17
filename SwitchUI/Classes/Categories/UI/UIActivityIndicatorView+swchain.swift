//
//  UIActivityIndicatorView+swchain.swift
//  Swain
//
//  Created by swain on 2024/12/21.
//

import Foundation
import UIKit

public extension UIActivityIndicatorView {
    
    @discardableResult
    func start() -> Self {
        self.startAnimating()
        return self
    }
    
    @discardableResult
    func stop() -> Self {
        self.stopAnimating()
        return self
    }
    
}
