//
//  UIImageView+UI.swift
//  Swain
//
//  Created by swain on 2023/7/22.
//

import UIKit

/// UI自动刷新Key
public enum UIImageViewKey: String {
    case imageObject
    case imageName
    case tintColor
    case tintColor2
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
        reflect[UIImageViewKey.imageObject.rawValue] = imageBlk
        
        // imageName
        let imageNameBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String, let view = view as? UIImageView {
                view.imageName(block(view))
            }
        }
        reflect[UIImageViewKey.imageName.rawValue] = imageNameBlk
        
        // tintColor
        let tintColorBlk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> UIColor, let view = view as? UIImageView {
                view.tintColor(block(view))
            }
        }
        reflect[UIImageViewKey.tintColor.rawValue] = tintColorBlk
        
        // tintColor2
        let tintColor2Blk: (UIView, Any) -> Void = { (view, block) -> Void in
            if let block = block as? (UIView) -> String, let view = view as? UIImageView {
                view.tintColor(block(view))
            }
        }
        reflect[UIImageViewKey.tintColor2.rawValue] = tintColor2Blk
        
        return reflect
    }
}
