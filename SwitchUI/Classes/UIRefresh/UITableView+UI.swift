//
//  UITableView+UI.swift
//  Swain
//
//  Created by swain on 2023/7/22.
//

import UIKit

/// UI自动刷新Key
public enum UITableViewKey: String {
    case separatorStyle
    case rowHeight
}

public class UITableViewUI {
    
    /// 注册UI刷新属性反射方法
    /// - Returns: 属性更新方法
    static func registerRefresh() -> [String: Any] {
        
        var reflect: [String: Any] = [:]
        
        // separatorStyle
        let separatorStyleBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UITableViewCell.SeparatorStyle, let view = view as? UITableView {
                view.separatorStyle(block(view))
            }
        }
        reflect[UITableViewKey.separatorStyle.rawValue] = separatorStyleBlk
        
        // rowHeight
        let rowHeightBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> CGFloat, let view = view as? UITableView {
                view.rowHeight(block(view))
            }
        }
        reflect[UITableViewKey.rowHeight.rawValue] = rowHeightBlk
        
        
        return reflect
    }
}
