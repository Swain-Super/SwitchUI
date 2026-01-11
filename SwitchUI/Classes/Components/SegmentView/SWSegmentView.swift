//
//  SWSegmentView.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2025/3/20.
//

import Foundation

open class SWSegmentView: UIView {
    
    // MARK: - 属性
    /// 容器
    var container: SContainer?
    /// 滑块背景view
    var segmentBGView: UIView?
    /// 选择滑块回调
    var changeAction: ((Int, String) -> Void)?
    /// 当前选择索引
    var selectIndex: SState = SState(0)
    /// 滑块内容
    var segmentContents: SState = SState([])
    /// 滑块字体大小
    var segmentFont: SState = SState(13)
    /// 滑块选中状态背景颜色
    var segmentBarBgColor: SState = SState("#ffffff")
    /// 背景颜色
    var segmentBackgroundColor: SState = SState("#F4F5F2")
    /// 滑块选择后字体颜色
    var segmentSelectFontColor: SState = SState("#6D7278")
    /// 滑块常规字体颜色
    var segmentNormalFontColor: SState = SState("#6D7278")
    /// 滑块宽度
    var segmentWidth: SState = SState(27.0)
    /// 滑块间隔
    var segmentSpace: CGFloat = 5.0
    
    public init() {
        super.init(frame: .zero)
        
        self.createUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        guard container == nil else {
            return
        }
        
        let container = self.build()
        self.addSubview(container)
        container.layout()
        
        self.updateSelectsegment()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.container?.layout()
        self.updateSelectsegment()
    }
    
    private func build() -> SContainer  {
        SRow(
            SReloader({[
                // 当前选择滑块背景
                UIView()
                    .width({_ in self.segmentWidth.cgfloatValue}, [self.segmentWidth])
                    .height("100%-8")
                    .backgroundColor({ _ in self.segmentBarBgColor.stringValue} , [self.segmentBarBgColor])
                    .position([.left: 0, .top: 4.0])
                    .callSelf(&self.segmentBGView)
                    .cornerRadius(8.0),
                
                // 滑块信息
                SForEach(list: self.segmentContents.arrayValue, { item, index in
                    UILabel()
                        .text(item as? String ?? "")
                        .textAlignment(.center)
                        .numberOfLines(0)
                        .textColor({
                            _ in
                            if self.selectIndex.intValue == index {
                                return self.segmentSelectFontColor.stringValue
                            } else {
                                return self.segmentNormalFontColor.stringValue
                            }
                        }, [self.selectIndex])
                        .font({
                            _ in
                            if self.selectIndex.intValue == index {
                                return UIFont.boldSystemFont(ofSize: CGFloat(self.segmentFont.cgfloatValue))
                            } else {
                                return UIFont.systemFont(ofSize: CGFloat(self.segmentFont.cgfloatValue))
                            }
                        }, [self.segmentFont])
                        .height("100%")
                        .left(self.segmentSpace)
                        .width({_ in self.segmentWidth.cgfloatValue}, [self.segmentWidth])
                        .onClick { [weak self] _ in
                            guard let self = self else { return }
                            self.selectIndex.value = index
                            self.updateSelectsegment()
                            // 回调
                            if let action = self.changeAction {
                                action(index, item as? String ?? "")
                            }
                        }
                })
            ]}, [self.segmentContents])
        )
        .width("100%")
        .height("100%")
        .backgroundColor({ _ in self.segmentBackgroundColor.stringValue}, [self.segmentBackgroundColor])
        .callSelf(&self.container)
        .cornerRadius(8.0)
    }
    
    // MARK: - 更新选择滑块
    func updateSelectsegment() {
        UIView.animate(withDuration: 0.3) {
            self.segmentBGView?.n_centerX = CGFloat(self.selectIndex.intValue + 1) * self.segmentSpace + self.segmentWidth.cgfloatValue * 0.5 + CGFloat(self.selectIndex.intValue) * self.segmentWidth.cgfloatValue
        } completion: { _ in
            
        }
    }
}

public extension SWSegmentView {
    
    @discardableResult
    func selectIndex(_ value: Int) -> Self {
        self.selectIndex.value = value
        return self
    }
    
    @discardableResult
    func segmentContents(_ value: [String]) -> Self {
        self.segmentContents.value = value
        return self
    }
    
    @discardableResult
    func segmentBarBgColor(_ value: String) -> Self {
        self.segmentBarBgColor.value = value
        return self
    }
    
    @discardableResult
    func segmentFontNumber(_ value: Int) -> Self {
        self.segmentFont.value = value
        return self
    }
    
    @discardableResult
    func segmentBackgroundColor(_ value: String) -> Self {
        self.segmentBackgroundColor.value = value
        return self
    }
    
    @discardableResult
    func segmentSelectFontColor(_ value: String) -> Self {
        self.segmentSelectFontColor.value = value
        return self
    }
    
    @discardableResult
    func segmentNormalFontColor(_ value: String) -> Self {
        self.segmentNormalFontColor.value = value
        return self
    }
    
    @discardableResult
    func segmentWidth(_ value: CGFloat) -> Self {
        self.segmentWidth.value = value
        return self
    }
    
    /// 设置切换回调
    @discardableResult
    func onChange(_ action: @escaping (Int, String) -> Void) -> Self {
        self.changeAction = action
        return self
    }
}
