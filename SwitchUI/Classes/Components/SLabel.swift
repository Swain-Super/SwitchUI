//
//  SLabel.swift
//
//  Created by Swain on 2024/12/30.
//  Copyright © 2024 swain. All rights reserved.
//

import UIKit

class SLabel: UILabel {
    
    var s_text: String?
    var s_textColor: UIColor?
    var s_fontName: String?
    var s_fontSize: Float = 17
    var s_fontWidth: String?
    var s_linkBreakMode: NSLineBreakMode?
    var s_lineSpace: Float?
    var s_lineHeight: Float?
    var s_textAlignment: NSTextAlignment?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override var frame: CGRect {
        set {
            super.frame = newValue
        }
        
        get {
            return super.frame
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
       
    }
    
    @discardableResult
    func s_text(object: String) -> Self {
        self.s_text = object
        return self
    }
    
    @discardableResult
    func s_textColor(object: String) -> Self {
        self.s_textColor = object.hexColor()
        return self
    }
    
    @discardableResult
    func s_textAlignment(object: NSTextAlignment) -> Self {
        self.s_textAlignment = object
        return self
    }
    
    @discardableResult
    func s_fontName(object: String) -> Self {
        self.s_fontName = object
        return self
    }
    
    @discardableResult
    func s_fontSize(object: Float) -> Self {
        self.s_fontSize = object
        return self
    }
    
    @discardableResult
    func s_fontWidth(object: String) -> Self {
        self.s_fontWidth = object
        return self
    }
    
    @discardableResult
    func s_linkBreakMode(object: NSLineBreakMode) -> Self {
        self.s_linkBreakMode = object
        return self
    }
    
    @discardableResult
    func s_lineSpace(object: Float) -> Self {
        self.s_lineSpace = object
        return self
    }
    
    @discardableResult
    func s_lineHeight(object: Float) -> Self {
        self.s_lineHeight = object
        return self
    }
    
    @discardableResult
    func s_render() -> Self {
        
        guard let text = s_text else { return self }
        
        // 排版样式
        var paragraphStyle = NSMutableParagraphStyle.init()
        
        // 富文本对象
        var attributeString = NSMutableAttributedString.init(string: text)
        
        var textCount = attributeString.length
        
        // 字体颜色
        if let textColor = s_textColor {
            
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : textColor], range: NSRange.init(location: 0, length: textCount ))
        }
        
        // 文字字体
        if var fontName = s_fontName {
            let fontSize: Float = s_fontSize >= 0 ? s_fontSize : 17
            
            let font = UIFont(name: fontName, size: CGFloat(fontSize)) ?? UIFont.systemFont(ofSize: CGFloat(fontSize))
            attributeString.addAttributes([NSAttributedString.Key.font : font], range: NSRange.init(location: 0, length: textCount))
        } else {
            var font: UIFont?
            // 字重
            if let fontWeight = s_fontWidth {
                // 字重 UIFontWeight枚举包含以下选项：
                // ultraLight，thin，light，regular，medium，semibold，bold，heavy，black
                var fontW = UIFont.Weight.bold
                switch fontWeight {
                case "100":
                    fontW = .ultraLight
                    break
                case "200":
                    fontW = .thin
                    break
                case "300":
                    fontW = .light
                    break
                case "400":
                    fontW = .regular
                    break
                case "500":
                    fontW = .medium
                    break
                case "600":
                    fontW = .semibold
                    break
                case "700":
                    fontW = .bold
                    break
                case "800":
                    fontW = .heavy
                    break
                case "900":
                    fontW = .black
                    break
                case "normal":
                    fontW = .regular
                    break
                case "bold":
                    fontW = .bold
                    break
                default:
                    break
                }
                font = UIFont.systemFont(ofSize: CGFloat(s_fontSize >= 0 ? s_fontSize : 17), weight: fontW)
            }else {
                font = UIFont.systemFont(ofSize: CGFloat(s_fontSize >= 0 ? s_fontSize : 17))
            }
            attributeString.addAttributes([NSAttributedString.Key.font : font], range: NSRange.init(location: 0, length: textCount))
        }
        
        // 文字对齐方式, 只有设置了控件的宽度才能设置对齐方式，要不然会有布局问题
        if let textAlignment = s_textAlignment {
            paragraphStyle.alignment = textAlignment;
            self.textAlignment = textAlignment
        }
        
        // 截断方式
        if let lineBreakMode = s_linkBreakMode {
            paragraphStyle.lineBreakMode = lineBreakMode
        }
        
        // 行间距
        if let lineSpace = s_lineSpace {
            paragraphStyle.lineSpacing = CGFloat(lineSpace) - (self.font.lineHeight - self.font.pointSize)
        }
        
        // 行高
        if let lineHeight = s_lineHeight {
            paragraphStyle.maximumLineHeight = CGFloat(lineHeight)
            paragraphStyle.minimumLineHeight = CGFloat(lineHeight)
            
            // MARK: iOS的问题设置了行高之后，文字会偏下一些，设置基线调整一下位置
            var baseLineOffset = (CGFloat(lineHeight) - self.font.lineHeight) / 4
            attributeString.addAttributes([NSAttributedString.Key.baselineOffset : baseLineOffset], range: NSRange.init(location: 0, length: textCount))
        }
        
        // 设置文字样式
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, textCount))
        
        self.attributedText = attributeString
        
        return self
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

