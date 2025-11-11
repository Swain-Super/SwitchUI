//
//  UIStackView+swchain.swift
//  Swain
//
//  Created by swain on 2023/7/22.
//

import Foundation
import UIKit

public extension UIStackView {
    
    @discardableResult
    func axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        self.axis = axis
        return self
    }
    
    @discardableResult
    func axis(_ block: @escaping (UIView) -> NSLayoutConstraint.Axis,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIStackViewKey.axis.rawValue, block: block, states: states)
        } else {
            self.axis(block(self))
        }
        return self
    }
    
    @discardableResult
    func alignment(_ alignment: UIStackView.Alignment) -> Self {
        self.alignment = alignment
        return self
    }
    
    @discardableResult
    func alignment(_ block: @escaping (UIView) -> UIStackView.Alignment,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIStackViewKey.alignment.rawValue, block: block, states: states)
        } else {
            self.alignment(block(self))
        }
        return self
    }
    
    @discardableResult
    func spacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }
    
    @discardableResult
    func spacing(_ block: @escaping (UIView) -> CGFloat,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIStackViewKey.spacing.rawValue, block: block, states: states)
        } else {
            self.spacing(block(self))
        }
        return self
    }
    
    @discardableResult
    func distribution(_ distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }
    
    @discardableResult
    func distribution(_ block: @escaping (UIView) -> UIStackView.Distribution,_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIStackViewKey.distribution.rawValue, block: block, states: states)
        } else {
            self.distribution(block(self))
        }
        return self
    }
    
    @discardableResult
    func arrangedViews(_ views: [UIView]) -> Self {
        self.arrangedSubviews.forEach { v in
            self.removeArrangedSubview(v)
        }
        views.forEach { v in
            self.addArrangedSubview(v)
        }
        return self
    }
    
    @discardableResult
    func arrangedViews(_ block: @escaping (UIView) -> [UIView],_ states: [SState]? = nil) -> Self {
        if let states, states.count > 0 {
            self.autoBindAndRun(key: UIStackViewKey.arrangedViews.rawValue, block: block, states: states)
        } else {
            self.arrangedViews(block(self))
        }
        return self
    }
}
