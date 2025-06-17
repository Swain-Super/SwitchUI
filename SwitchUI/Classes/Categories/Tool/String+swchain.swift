//
//  String+swchain.swift
//  SWUI
//
//  Created by swain wang on 2024/9/2.
//

import Foundation

public extension String {
    
    /// 根据16进制数据生成UIColor
    /// - Returns: UIColor对象
    func hexColor() -> UIColor {
        
        var cleanString = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        cleanString = cleanString.replacingOccurrences(of: "#", with: "")
        cleanString = cleanString.replacingOccurrences(of: "0X", with: "")

        // 检查字符串长度
        if cleanString.count == 6 || cleanString.count == 8 {
            var rgbValue: UInt64 = 0
            Scanner(string: cleanString).scanHexInt64(&rgbValue)
            
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            let alpha: CGFloat
            
            if cleanString.count == 8 {
                alpha = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            } else {
                alpha = 1.0
            }
            
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return UIColor.gray
        }
    }
}
