//
//  SWWrapper.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/12/15.
//

import Foundation

// 数据转换包装类型
public struct SWWrapper<Base> {
    internal let base: Base
    internal init(_ base: Base) {
        self.base = base
    }
}

// 数据转换包装协议
public protocol SWCompatible {

}

public extension SWCompatible {
    public var sw: SWWrapper<Self> {
        get { return SWWrapper(self) }
    }
}

extension UIView: SWCompatible { }

