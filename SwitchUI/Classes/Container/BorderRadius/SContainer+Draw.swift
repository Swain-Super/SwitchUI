//
//  SContainer+Draw.swift
//
//  Created by swain on 2024/12/30.
//

import Foundation
import QuartzCore

extension SContainer {
    
    /// 获取圆角信息
    /// - Returns: 圆角内容
    func getCornerRadii() -> SWCornerRadii {
        
        return SWCornerRadii.init(topLeft: CGFloat(self.s_radius?.topLeft ?? 0), topRight: CGFloat(self.s_radius?.topRight ?? 0), bottomLeft: CGFloat(self.s_radius?.bottomLeft ?? 0), bottomRight: CGFloat(self.s_radius?.bottomRight ?? 0))
    }
    
    /// 获取边框厚度
    /// - Returns: 边框内容
    func getBorderInsets() -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: CGFloat(self.s_borderWidth?.top ?? 0), left: CGFloat(self.s_borderWidth?.left ?? 0), bottom: CGFloat(self.s_borderWidth?.bottom ?? 0), right: CGFloat(self.s_borderWidth?.right ?? 0))
    }
    
    /// 获取边框颜色
    /// - Returns: 图片结构体
    func getBorderColors() -> SWBorderColors {
        
        var topColor: UIColor = .clear
        var leftColor: UIColor = .clear
        var bottomColor: UIColor = .clear
        var rightColor: UIColor = .clear
        
        // top
        if let top = self.s_borderColor?.top {
            topColor = top ?? .clear
        }
        // left
        if let left = self.s_borderColor?.left {
            leftColor = left ?? .clear
        }
        // bottom
        if let bottom = self.s_borderColor?.bottom {
            bottomColor = bottom ?? .clear
        }
        // right
        if let right = self.s_borderColor?.right {
            rightColor = right ?? .clear
        }
        
        return SWBorderColors.init(top: Unmanaged.passRetained(topColor.cgColor), left: Unmanaged.passRetained(leftColor.cgColor), bottom: Unmanaged.passRetained(bottomColor.cgColor), right: Unmanaged.passRetained(rightColor.cgColor))
    }
    
    /// 自绘制
    /// - Parameter layer:
    public func customDisplay(_ layer: CALayer) {
        
        if layer.bounds.size == .zero {
            return
        }
        
        // 边框样式 - 实心的,还有其他的样式
        var borderStyle: SWBorderStyle = .solid
        // 圆角
        var cornerRadii: SWCornerRadii = self.getCornerRadii()
        // 边框
        var borderInsets: UIEdgeInsets = self.getBorderInsets()
        // 边框颜色
        var borderColors: SWBorderColors = self.getBorderColors()
        
        // iOS clips to the outside of the border, but CSS clips to the inside. To
        // solve this, we'll need to add a container view inside the main view to
        // correctly clip the subviews.
        
        // 背景颜色
        var backgroundColor: UIColor = .clear
        if let bgColor = self.s_backgroundColor {
            backgroundColor = bgColor
        }
        
        // iOS draws borders in front of the content whereas CSS draws them behind
                // the content. For this reason, only use iOS border drawing when clipping
                // or when the border is hidden.
        var useIOSBorderRendering = SWCornerRadiiAreEqual(cornerRadii) && SWBorderInsetsAreEqual(borderInsets) && SWBorderColorsAreEqual(borderColors) && (borderInsets.top == 0 || self.clipsToBounds)
        
        // 使用iOS属性直接赋值不用画
        if (useIOSBorderRendering) {
            layer.cornerRadius = cornerRadii.topLeft
            layer.borderColor = borderColors.left?.takeUnretainedValue()
            layer.borderWidth = borderInsets.left
            layer.backgroundColor = backgroundColor.cgColor
            layer.contents = nil
            layer.needsDisplayOnBoundsChange = false
            layer.mask = nil
            return
        }
        
        // ======== 获取绘制的图片 ========
        var image = SWGetBorderImage(borderStyle, layer.bounds.size, cornerRadii, borderInsets, borderColors, backgroundColor.cgColor, self.clipsToBounds)
        layer.backgroundColor = nil
        
        if image == nil {
            layer.contents = nil
            layer.needsDisplayOnBoundsChange = false
            return
        }
        
        layer.contents = image?.cgImage
        layer.contentsScale = image?.scale ?? 0.0
        layer.needsDisplayOnBoundsChange = true
        layer.magnificationFilter = .nearest
        
        if image?.capInsets != .zero {
            var x = (image?.capInsets.left ?? 0) / (image?.size.width ?? 0)
            var y = (image?.capInsets.top ?? 0) / (image?.size.height ?? 0)
            var width = 1.0 / (image?.size.width ?? 0)
            var height = 1.0 / (image?.size.height ?? 0)
            var contentsCenter = CGRect(x: x, y: y, width: (1.0 / (image?.size.width ?? 0)), height: height)
            layer.contentsCenter = contentsCenter
        }else {
            layer.contentsCenter = CGRectMake(0.0, 0.0, 1.0, 1.0)
        }
        
        // 画切割
        self.updateClipping(layer: layer)
    }
    
    /// 绘制切割图形
    /// - Parameter layer: 层
    func updateClipping(layer: CALayer) {
        var mask: CALayer? = nil
        var cornerRadius: CGFloat = 0.0
        
        if self.clipsToBounds {
            var cornerRadii: SWCornerRadii = self.getCornerRadii()
            if SWCornerRadiiAreEqual(cornerRadii) {
                cornerRadius = cornerRadii.topLeft
            } else {
                var shapeLayer: CAShapeLayer = CAShapeLayer()
                var path = SWPathCreateWithRoundedRect(self.bounds, SWGetCornerInsets(cornerRadii, .zero), nil)
                shapeLayer.path = path.takeUnretainedValue()
                mask = shapeLayer
            }
        }
        
        layer.cornerRadius = cornerRadius
        layer.mask = mask
    }
    
}
