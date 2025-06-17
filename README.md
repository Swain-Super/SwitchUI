# SwitchUI

<div align="center">
  <img src="https://img.shields.io/badge/Swift-5.0-orange.svg" alt="Swift 5.0">
  <img src="https://img.shields.io/badge/iOS-10.0+-blue.svg" alt="iOS 10.0+">
  <img src="https://img.shields.io/badge/macOS-11.0+-blue.svg" alt="macOS 11.0+">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
</div>

<div align="center">
  <h3>一个简单易用的 Swift 声明式 UI 框架</h3>
</div>

<div align="center">
  <p>
    <a href="#特性">特性</a> •
    <a href="#安装">安装</a> •
    <a href="#布局容器">布局容器</a> •
    <a href="#注意事项">注意事项</a>
  </p>
</div>

<div align="center">
  <p>
    <b>SwitchUI</b> 是一个基于 Swift 的声明式 UI 框架，提供了一套简单易用的布局系统，帮助开发者快速构建 iOS/macOS 应用界面。它采用声明式语法，让 UI 代码更加简洁直观，同时提供了丰富的布局容器，满足各种布局需求。
  </p>
</div>

## 特性

- �� 声明式语法，代码简洁直观
- 📱 支持 iOS 10.0+ 和 macOS 11.0+
- 🎨 丰富的布局容器，满足各种布局需求
- 🔄 支持动态布局和自动计算
- 🛠 链式调用，使用便捷
- 📦 支持 CocoaPods 集成

## 安装

### CocoaPods

```ruby
pod 'SwitchUI'
```

## 布局容器

SwitchUI 提供了多种布局容器，满足不同的布局需求：

### 1. SContainer
基础布局容器，所有其他容器的基类。支持：
- 内边距设置
- 自定义边框和圆角
- 滚动条控制
- 子视图管理

```swift
// 基础容器示例
let container = SContainer([
    // 添加子视图
    UILabel().text("基础容器示例"),
    UIButton().title("按钮")
])
.padding(16)  // 设置内边距
.width("100%")  // 设置宽度为父视图的100%
.height(200)   // 设置固定高度
.backgroundColor(.white)  // 设置背景色
.borderColor(.gray)  // 设置边框颜色
.borderWidth(1)  // 设置边框宽度
.radius(8)  // 设置圆角

// 使用闭包方式添加子视图
let container2 = SContainer { views in
    views.append(UILabel().text("使用闭包添加子视图"))
    views.append(UIButton().title("按钮"))
}
```

### 2. SColum 列布局
列布局容器，用于垂直方向排列子视图：
- 支持顶部、中间、底部对齐
- 自动计算高度
- 支持空白占位（SBlank）
- 支持滚动配置

```swift
// 基础列布局
let column = SColum([
    // 顶部标题
    UILabel().text("标题").font(.systemFont(ofSize: 20)),
    
    // 中间内容
    SRow([
        UIImageView().image(UIImage(named: "icon")),
        UILabel().text("描述文本").lines(0)
    ]).height(60),
    
    // 底部按钮
    UIButton().title("确认").backgroundColor(.blue)
])
.padding(16)
.width("100%")

// 带空白占位的列布局
let columnWithBlank = SColum([
    UILabel().text("顶部内容"),
    SBlank(),  // 自动填充剩余空间
    UILabel().text("底部内容")
])
.height(300)

// 带滚动效果的列布局
let scrollableColumn = SColum([
    // 多个子视图
    UIView().height(100).backgroundColor(.red),
    UIView().height(100).backgroundColor(.blue),
    UIView().height(100).backgroundColor(.green)
])
.scrollType(.scrolly)  // 启用垂直滚动
.height(200)
```

### 3. SRow 行布局
行布局容器，用于水平方向排列子视图：
- 支持左、中、右对齐
- 支持顶部、中间、底部对齐
- 自动计算宽度
- 支持滚动配置
- 支持空白占位

```swift
// 基础行布局
let row = SRow([
    UIImageView().image(UIImage(named: "avatar")),
    UILabel().text("用户名"),
    UIButton().title("关注")
])
.height(44)
.padding(8)

// 居中对齐的行布局
let centeredRow = SRow([
    UILabel().text("左侧"),
    SBlank(),  // 自动填充中间空间
    UILabel().text("右侧")
])
.alignContent(.center)  // 水平居中对齐
.justifyContent(.center)  // 垂直居中对齐
.height(50)

// 带滚动效果的行布局
let scrollableRow = SRow([
    // 多个子视图
    UIView().width(100).backgroundColor(.red),
    UIView().width(100).backgroundColor(.blue),
    UIView().width(100).backgroundColor(.green)
])
.scrollType(.scrollx)  // 启用水平滚动
.width(300)
.height(100)
```

### 4. SStack 栈布局
栈布局容器，用于自由定位子视图：
- 支持任意位置布局
- 自动居中定位
- 支持边距设置

```swift
// 基础栈布局
let stack = SStack([
    // 左上角
    UILabel()
        .text("左上")
        .left(20)
        .top(20),
    
    // 右上角
    UILabel()
        .text("右上")
        .right(20)
        .top(20),
    
    // 左下角
    UILabel()
        .text("左下")
        .left(20)
        .bottom(20),
    
    // 右下角
    UILabel()
        .text("右下")
        .right(20)
        .bottom(20),
    
    // 中心
    UILabel()
        .text("中心")
        .centerX(0)
        .centerY(0)
])
.width(300)
.height(300)
.backgroundColor(.lightGray)

// 带边距的栈布局
let stackWithMargin = SStack([
    // 带边距的视图
    UIView()
        .backgroundColor(.blue)
        .left(20)
        .right(20)
        .top(20)
        .bottom(20),
    
    // 中心文本
    UILabel()
        .text("居中文本")
        .centerX(0)
        .centerY(0)
])
.width(200)
.height(200)
```

### 5. SRelativeContainer 相对布局
相对布局容器，用于创建基于参考视图的布局：
- 支持相对于其他视图定位
- 支持边距设置
- 支持动态调整

```swift
// 基础相对布局
let relativeContainer = SRelativeContainer([
    // 参考视图
    UIView()
        .width(100)
        .height(100)
        .backgroundColor(.red)
        .centerX(0)
        .centerY(0)
        .sViewId("centerView"),  // 设置视图ID，用于其他视图参考
    
    // 相对于中心视图的布局
    UIView()
        .width(50)
        .height(50)
        .backgroundColor(.blue)
        .alignRules(SAlignRules()
            .centerX("centerView")  // 与中心视图水平对齐
            .top("centerView", .bottom, 10)  // 在中心视图下方10点
        ),
    
    // 相对于父容器的布局
    UIView()
        .width(50)
        .height(50)
        .backgroundColor(.green)
        .left(20)  // 距离左边20点
        .top(20)   // 距离顶部20点
])
.width(300)
.height(300)
.backgroundColor(.lightGray)
```

### 6. SGrid 网格布局
网格布局容器，用于创建网格布局：
- 支持行列配置
- 支持行列间距
- 支持固定尺寸和自适应尺寸
- 支持自动换行/换列

```swift
// 基础网格布局
let grid = SGrid([
    // 2x2 网格
    UIView().backgroundColor(.red),
    UIView().backgroundColor(.blue),
    UIView().backgroundColor(.green),
    UIView().backgroundColor(.yellow)
])
.rows(2)  // 设置行数
.columns(2)  // 设置列数
.spacing(10)  // 设置间距
.width(300)
.height(300)

// 固定尺寸的网格
let fixedGrid = SGrid([
    // 多个子视图
    UIView().backgroundColor(.red),
    UIView().backgroundColor(.blue),
    UIView().backgroundColor(.green)
])
.rows(1)  // 一行
.columns(3)  // 三列
.itemWidth(100)  // 固定宽度
.itemHeight(100)  // 固定高度
.spacing(10)  // 间距
```

### 7. SList 列表布局
列表容器，用于创建列表视图：
- 支持垂直和水平滚动
- 支持分组列表
- 支持自定义列表项
- 支持动态加载

```swift
// 基础列表
let list = SList([
    // 列表项
    SListItem([
        UILabel().text("列表项 1")
    ]).height(44),
    
    SListItem([
        UILabel().text("列表项 2")
    ]).height(44),
    
    SListItem([
        UILabel().text("列表项 3")
    ]).height(44)
])
.scrollType(.scrolly)  // 垂直滚动
.width(300)
.height(200)

// 分组列表
let groupList = SList([
    // 分组1
    SListGroupItem([
        SListItem([
            UILabel().text("分组1-项目1")
        ]),
        SListItem([
            UILabel().text("分组1-项目2")
        ])
    ]),
    
    // 分组2
    SListGroupItem([
        SListItem([
            UILabel().text("分组2-项目1")
        ]),
        SListItem([
            UILabel().text("分组2-项目2")
        ])
    ])
])
.scrollType(.scrolly)
.width(300)
.height(400)
```

## 布局嵌套示例

```swift
// 复杂嵌套布局
let complexLayout = SColum([
    // 顶部导航栏
    SRow([
        UIButton().title("返回"),
        UILabel().text("标题").centerX(0),
        UIButton().title("更多")
    ]).height(44),
    
    // 内容区域
    SStack([
        // 左侧菜单
        SColum([
            UILabel().text("菜单1"),
            UILabel().text("菜单2"),
            UILabel().text("菜单3")
        ]).width(100),
        
        // 右侧内容
        SGrid([
            UIView().backgroundColor(.red),
            UIView().backgroundColor(.blue),
            UIView().backgroundColor(.green),
            UIView().backgroundColor(.yellow)
        ]).rows(2).columns(2)
    ]),
    
    // 底部工具栏
    SRow([
        UIButton().title("首页"),
        UIButton().title("消息"),
        UIButton().title("我的")
    ]).height(49)
])
.width("100%")
.height("100%")
```

## 布局属性

所有容器都支持以下通用属性：

- `padding`: 内边距
- `width/height`: 尺寸设置
- `left/right/top/bottom`: 边距设置
- `centerX/centerY`: 居中设置
- `backgroundColor`: 背景色
- `borderColor/borderWidth`: 边框设置
- `radius`: 圆角设置

## 注意事项

1. 容器尺寸计算：
   - 如果未设置固定尺寸，容器会自动计算所需尺寸
   - 某些容器（如 SColum、SRow）需要设置宽度或高度才能正确布局

2. 滚动配置：
   - 使用 `scrollType` 设置滚动方向
   - 可以隐藏滚动条

3. 性能优化：
   - 避免过深的嵌套层级
   - 合理使用空白占位符
   - 适当设置固定尺寸

## 贡献

欢迎提交 Issue 和 Pull Request。

## 许可证

MIT License

