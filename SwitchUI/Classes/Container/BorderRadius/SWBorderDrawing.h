#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
} SWCornerRadii;

typedef struct {
    CGSize topLeft;
    CGSize topRight;
    CGSize bottomLeft;
    CGSize bottomRight;
} SWCornerInsets;

typedef struct {
    CGColorRef _Nullable top;
    CGColorRef _Nullable left;
    CGColorRef _Nullable bottom;
    CGColorRef _Nullable right;
} SWBorderColors;

typedef NS_ENUM(NSUInteger, SWBorderStyle) {
    SWBorderStyleNone = 0,
    SWBorderStyleSolid,
    SWBorderStyleDotted,
    SWBorderStyleDashed,
};

/// Determine if the border widths, colors and radii are all equal.
FOUNDATION_EXTERN BOOL SWBorderInsetsAreEqual(UIEdgeInsets borderInsets);

FOUNDATION_EXTERN BOOL SWCornerRadiiAreEqual(SWCornerRadii cornerRadii);

FOUNDATION_EXTERN BOOL SWBorderColorsAreEqual(SWBorderColors borderColors);

/// Convert SWCornerRadii to SWCornerInsets by applying border insets.
/// Effectively, return radius - inset, with a lower bound of 0.0.
FOUNDATION_EXTERN SWCornerInsets SWGetCornerInsets(SWCornerRadii cornerRadii, UIEdgeInsets borderInsets);

/// Create a CGPath representing a rounded reactangle with specified bounds and corner insets. Note that the CGPathRef must be released by the caller.
FOUNDATION_EXTERN CGPathRef SWPathCreateWithRoundedRect(CGRect bounds, SWCornerInsets cornerInsets, const CGAffineTransform *_Nullable transform);

/// Draw a CSS-compliant border as an image. You can determine if it's scalable by inspecting the image's `capInsets`.
///
/// 默认边框黑色实线，浏览器默认 unset + black
///
/// 1. 圆角半径小于两边宽度 -> 外部圆角，内部直角
/// 2. a 边宽度 < 圆角半径 < b 边宽度 -> 外部圆角，内部直角
/// 3. 圆角半径大于两边宽度 -> 外部圆角，内部椭圆
///
/// borderStyle 仅支持统一设置
///
/// borderWidth 浏览器默认 medium，在 Firefox 上为 3px，Hummer 默认 0 pt/dp
///
/// borderStyle: dotted/dashed 要求 borderWidth/Color **四边**一样
///
/// `borderInsets` defines the border widths for each edge.
FOUNDATION_EXTERN UIImage *_Nullable SWGetBorderImage(SWBorderStyle borderStyle, CGSize viewSize, SWCornerRadii cornerRadii, UIEdgeInsets borderInsets, SWBorderColors borderColors, CGColorRef _Nullable backgroundColor, BOOL drawToEdge);

NS_ASSUME_NONNULL_END
