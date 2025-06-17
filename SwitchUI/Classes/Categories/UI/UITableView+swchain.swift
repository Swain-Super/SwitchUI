//
//  UITableView+swchain.swift
//  Swain
//
//  Created by swain on 2023/7/23.
//

import Foundation
import UIKit

public extension UITableView {
    
    @discardableResult
    func separatorStyle(_ separatorStyle: UITableViewCell.SeparatorStyle) -> Self {
        self.separatorStyle = separatorStyle
        return self
    }
    
    @discardableResult
    func separatorStyle(_ block: @escaping (UIView) -> UITableViewCell.SeparatorStyle,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UITableViewKey.separatorStyle.rawValue, block: block, states: states)
        return self
    }
    
    @discardableResult
    func rowHeight(_ rowHeight: CGFloat) -> Self {
        self.rowHeight = rowHeight
        return self
    }
    
    @discardableResult
    func rowHeight(_ block: @escaping (UIView) -> CGFloat,_ states: [SState]? = nil) -> Self {
        self.autoBindAndRun(key: UITableViewKey.rowHeight.rawValue, block: block, states: states)
        return self
    }
    
}
