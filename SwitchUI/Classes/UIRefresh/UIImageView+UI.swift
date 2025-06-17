//
//  UIImageView+UI.swift
//  Swain
//
//  Created by swain on 2023/7/22.
//

import UIKit

/// UI自动刷新Key
public enum UIImageViewKey: String {
    case image
    case imageName
}

public class UIImageViewUI {
    
    /// 注册UI刷新属性反射方法
    /// - Returns: 属性更新方法
    static func registerRefresh() -> [String: Any] {
        
        var reflect: [String: Any] = [:]
        
        // image
        let imageBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIImage?, let view = view as? UIImageView {
                view.image(block(view))
            }
        }
        reflect[UIImageViewKey.image.rawValue] = imageBlk
        
        // imageName
        let imageNameBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String, let view = view as? UIImageView {
                view.imageName(block(view))
            }
        }
        reflect[UIImageViewKey.imageName.rawValue] = imageNameBlk
        
        return reflect
    }
}
