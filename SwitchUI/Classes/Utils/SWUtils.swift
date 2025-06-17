//
//  SWUtils.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/5/20.
//

import Foundation
import UIKit

/// 屏幕的宽度，⚠️计算属性，会随着横竖屏改变，比如需要横竖屏适配、纯横屏页面等情况，建议使用此属性
public var swScreenWidth: CGFloat { UIScreen.main.bounds.size.width }
/// 屏幕的高度，⚠️计算属性，会随着横竖屏改变，比如需要横竖屏适配、纯横屏页面等情况，建议使用此属性
public var swScreenHeight: CGFloat { UIScreen.main.bounds.size.height }

/// 横向排列
public enum SWAlign {
    case left   // 左边
    case center // 中间
    case right  // 右边
}

/// 纵向排列
public enum SWJustify {
    case top   // 上边
    case center // 中间
    case bottom  // 下边
}

/// 布局的属性位置
public enum SWPositionType {
    case width
    case height
    case left
    case top
    case right
    case bottom
    case centerX
    case centerY
}

/// 数值类型
public enum SWValueType {
    case auto           // 自动数值
    case point          // 具体数值
    case percentw       // 父View宽百分比
    case percenth       // 父View高百分比
    case screenvw       // 屏幕宽百分比
    case screenvh       // 屏幕高百分比
}

/// 滚动配置
public enum SWScrollType {
    case none           // 默认，不滚动
    case auto           // 如果内容被修剪，则会显示滚动条以便查看其余的内容。
    case scrollx        // 如果横向会被修剪，则会显示滚动条
    case scrolly        // 如果竖向会被修剪，则会显示滚动条
}

/// 边框宽度
public struct SBorderWidth {
    var left: Float?
    var right: Float?
    var top: Float?
    var bottom: Float?

    public init(left: Float? = nil, right: Float? = nil, top: Float? = nil, bottom: Float? = nil) {
        self.left = left
        self.right = right
        self.top = top
        self.bottom = bottom
    }
    
    public init(color: Float) {
        self.left = color
        self.right = color
        self.top = color
        self.bottom = color
    }
}

/// 边框颜色
public struct SBorderColor {
    var left: UIColor?
    var right: UIColor?
    var top: UIColor?
    var bottom: UIColor?

    public init(left: String? = nil, right: String? = nil, top: String? = nil, bottom: String? = nil) {
        self.left = left?.hexColor()
        self.right = right?.hexColor()
        self.top = top?.hexColor()
        self.bottom = bottom?.hexColor()
    }
    
    public init(color: String) {
        let cColor = color.hexColor()
        self.left = cColor
        self.right = cColor
        self.top = cColor
        self.bottom = cColor
    }
}

/// 圆角
public struct SRadius {
    var topLeft: Float?
    var topRight: Float?
    var bottomLeft: Float?
    var bottomRight: Float?

    public init(topLeft: Float? = nil, topRight: Float? = nil, bottomLeft: Float? = nil, bottomRight: Float? = nil) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
    
    public init(radius: Float) {
        self.topLeft = radius
        self.topRight = radius
        self.bottomLeft = radius
        self.bottomRight = radius
    }
}

/// 数值
public class SWValue: NSObject {
    
    /// 数值类型
    var type: SWValueType = .auto
    /// 值
    var value: String = "auto"
    /// 偏差值
    var offset: Float = 0
    
    /// 布局的位置类型
    var position: SWPositionType?
    
    public override init() {
        
    }
    
    init(value: String, _ position: SWPositionType, _ offset: Float = 0) {
        self.position = position
        let splitValue: (String, SWValueType, Float) = value.filterSizeValue(position: position)
        self.value = splitValue.0
        self.type = splitValue.1
        self.offset = splitValue.2
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        if let newObject = object as? SWValue, self.type == newObject.type, self.value == newObject.value, self.offset == newObject.offset, self.position == newObject.position {
            return true
        }
        return false
    }
}

/// 绝对定位对象
public class SWPosition: NSObject {
    
    var left: SWValue?
    var top: SWValue?
    var right: SWValue?
    var bottom: SWValue?
    var centerX: SWValue?
    var centerY: SWValue?
    
    init(value: [SWPositionType: String]?) {
        super.init()
        if let value = value {
            value.map { (key: SWPositionType, value: String) in
                switch key {
                case .left:
                    left =  SWValue(value: value, .left)
                    break
                case .right:
                    right =  SWValue(value: value, .right)
                    break
                case .top:
                    top =  SWValue(value: value, .top)
                    break
                case .bottom:
                    bottom =  SWValue(value: value, .bottom)
                    break
                case .centerX:
                    centerX =  SWValue(value: value, .centerX)
                    break
                case .centerY:
                    centerY =  SWValue(value: value, .centerY)
                    break
                default:
                    break
                }
            }
        } else {
            left =  SWValue(value: String(0.0), .left)
            top =  SWValue(value: String(0.0), .top)
        }
    }
    
    init(value: [SWPositionType: Float]?) {
        super.init()
        if let value = value {
            value.map { (key: SWPositionType, value: Float) in
                switch key {
                case .left:
                    left =  SWValue(value: String(value), .left)
                    break
                case .right:
                    right =  SWValue(value: String(value), .right)
                    break
                case .top:
                    top =  SWValue(value: String(value), .top)
                    break
                case .bottom:
                    bottom =  SWValue(value: String(value), .bottom)
                    break
                case .centerX:
                    centerX =  SWValue(value: String(value), .centerX)
                    break
                case .centerY:
                    centerY =  SWValue(value: String(value), .centerY)
                    break
                default:
                    break
                }
            }
        } else {
            left =  SWValue(value: String(0.0), .left)
            top =  SWValue(value: String(0.0), .top)
        }
    }
}

/// 相对布局项
public class SWAlignRuleItem: NSObject {
    
    /// 对象值
    var anchor: String = ""
    
    /// 布局的位置类型
    var position: SWPositionType?
    
    public override init() {
        
    }
    
    init(anchor: String, _ position: SWPositionType) {
        self.anchor = anchor
        self.position = position
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        if let newObject = object as? SWAlignRuleItem, self.anchor == newObject.anchor, self.position == newObject.position {
            return true
        }
        return false
    }
}

public let SSuperContainer: String = "__container__"
public let SAnchor: String = "anchor"
public let SAlign: String = "align"

/// 相对定位对象
public class SWAlignRules: NSObject {
    
    var left: SWAlignRuleItem?
    var top: SWAlignRuleItem?
    var right: SWAlignRuleItem?
    var bottom: SWAlignRuleItem?
    var centerX: SWAlignRuleItem?
    var centerY: SWAlignRuleItem?
    
    init(value: [SWPositionType: [String: Any]]?) {
        super.init()
        if let value = value {
            value.map { (key: SWPositionType, value: [String: Any]) in
                if let anchor = value[SAnchor] as? String, let align = value[SAlign] as? SWPositionType {
                    switch key {
                    case .left:
                        left = SWAlignRuleItem(anchor: anchor, align)
                        break
                    case .right:
                        right = SWAlignRuleItem(anchor: anchor, align)
                        break
                    case .top:
                        top = SWAlignRuleItem(anchor: anchor, align)
                        break
                    case .bottom:
                        bottom = SWAlignRuleItem(anchor: anchor, align)
                        break
                    case .centerX:
                        centerX = SWAlignRuleItem(anchor: anchor, align)
                        break
                    case .centerY:
                        centerY = SWAlignRuleItem(anchor: anchor, align)
                        break
                    default:
                        break
                    }
                }
            }
        } else {
            left =  SWAlignRuleItem(anchor: SSuperContainer, .left)
            top =  SWAlignRuleItem(anchor: SSuperContainer, .top)
        }
    }
}

/// 计算swvalue的值
/// - Parameters:
///   - value: 值
///   - view: 布局的view
/// - Returns: 计算好的值
public func countSWValue(value: SWValue?, contentSize: CGSize, _ padding: UIEdgeInsets = .zero) -> Float {
    
    guard let value = value else { return 0 }
    
    var result: Float = 0
    switch value.type {
    case .point:
        result = (value.value as NSString).floatValue + value.offset
        break
    case .percentw:
        let superWidth = Float(contentSize.width - padding.left - padding.right)
        result = (value.value as NSString).floatValue * 0.01 * superWidth + value.offset
        break
    case .percenth:
        let superHeight = Float(contentSize.height - padding.top - padding.bottom)
        result = (value.value as NSString).floatValue * 0.01 * superHeight + value.offset
        break
    case .screenvw:
        result = (value.value as NSString).floatValue * 0.01 * Float(swScreenWidth) + value.offset
        break
    case .screenvh:
        result = (value.value as NSString).floatValue * 0.01 * Float(swScreenHeight) + value.offset
        break
    default:
        break
    }
    
    return result
}

/// 添加变量与函数表达式的绑定
/// - Parameters:
///   - states: 监听对象
///   - viewId: 被监听对象的viewId
public func bindAction(states: [SState]? , viewId: String, attribute: String, block: Any) {
    
    guard let component = SUIManager.shared.findComponents(viewId: viewId) else {return}
    
    component.sAttributeBlockArray[attribute] = block
    
    _ = states?.map({ state in
        state.addBind(viewId: viewId)
    })
}
