//
//  String+Size.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/5/11.
//

import Foundation

public let sSizeUnitPercent = "%"   // 数值单位，当前屏幕的百分比，用于识别是否采用百分比布局，不参与实际计算
public let sSizeUnitVW = "vw"       // 数值单位，1单位=屏幕宽度的1%，参与实际计算
public let sSizeUnitVH = "vh"       // 数值单位，1单位=屏幕高度的1%，参与实际计算
public let sSizeUnitPlus = "+"      // 加
public let sSizeUnitReduce = "-"    // 减

public extension String {
    
    /// 清空左右空格
    /// - Returns: 返回新字符串
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    /// 清理字符串中的空格
    /// - Returns: 返回新字符串
    func replaceWhiteSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    /// 过滤字符串中的单位符号
    ///  @param containerSize 父级容器宽高
    /// - return 处理后的字符串
    func filterSizeValue(position: SWPositionType) -> (String, SWValueType, CGFloat) {
        
        if self == "auto" {
            return (self, SWValueType.auto, 0)
        }
        
        var target = self
        var offset: CGFloat = 0
        
        // 判断有没有组合运算的，识别 + - 操作
        if target.contains(sSizeUnitPlus) {
            let splitArr = (target as NSString).components(separatedBy: sSizeUnitPlus)
            if splitArr.count == 2, splitArr[0].count > 0, splitArr[1].count > 0 {
                target = splitArr[0].trim().replaceWhiteSpaces()
                offset = splitArr[1].trim().replaceWhiteSpaces().toCGFloat()
            }
        } else if target.contains(sSizeUnitReduce) {
            let splitArr = (target as NSString).components(separatedBy: sSizeUnitReduce)
            if splitArr.count == 2, splitArr[0].count > 0, splitArr[1].count > 0 {
                target = splitArr[0].trim().replaceWhiteSpaces()
                offset = splitArr[1].trim().replaceWhiteSpaces().toCGFloat() * -1
            }
        }
        
        if target.contains(sSizeUnitPercent) {
            // - Note: 过滤掉%
            let temp = self.replacingOccurrences(of: sSizeUnitPercent, with: "")

            if position == .width || position == .left || position == .right || position == .centerX {
                return (temp, SWValueType.percentw, offset)
            } else {
                return (temp, SWValueType.percenth, offset)
            }
        } else if self.contains(sSizeUnitVW) {
            // - Note: 过滤掉vw
            let temp = self.replacingOccurrences(of: sSizeUnitVW, with: "")
            return (temp, SWValueType.screenvw, offset)
        } else if self.contains(sSizeUnitVH) {
            // - Note: 过滤掉vh
            let temp = self.replacingOccurrences(of: sSizeUnitVH, with: "")
            return (temp, SWValueType.screenvh, offset)
        }
        
        return (target, SWValueType.point, offset)
    }
}
