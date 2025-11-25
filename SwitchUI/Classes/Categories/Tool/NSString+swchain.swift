//
//  NSString+swchain.swift
//  SwitchUI
//
//  Created by swain wang on 2025/11/25.
//

import Foundation


public extension NSString {
    
    func toCGFloat() -> CGFloat {
        return CGFloat(self.doubleValue)
    }
}
