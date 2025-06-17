//
//  SWSheetView.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2025/3/9.
//

import Foundation

open class SWSheetView: UIView {
    
    // MARK: - 属性
    /// 容器
    var container: SContainer?
    /// 内容视图
    var contentView: UIView?
    /// 背景视图
    var backgroundView: UIView?
    /// 关闭回调
    public var closeAction: (() -> Void)?
    /// 显示回调
    public var showAction: (() -> Void)?
    /// 是否点击背景隐藏
    var isClickBackgroundHide: Bool = true
    
    public init(frame: CGRect, contentView: UIView) {
        super.init(frame: frame)
        
        self.contentView = contentView
        
        self.createUI()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        let container = self.build()
        self.addSubview(container)
        container.layout()
    }
    
    private func build() -> SContainer  {
        SRelativeContainer([
            
            /// 背景视图
            UIView()
                .backgroundColor("#26000000")
                .alpha(0.86)
                .onClick { _ in
                    if self.isClickBackgroundHide {
                        self.hide()
                    }
                }
                .width("100%")
                .height("100%")
                .callSelf(&self.backgroundView),
             
            /// 内容视图
            self.contentView ?? UIView(),
        ])
        .width("100%")
        .height("100%")
        .callSelf(&self.container)
    }
    
}

public extension SWSheetView {
    
    /// 绑定新内容视图
    func bindContentView(contentView: UIView) {
        self.contentView = contentView
        self.container?.removeFromSuperview()
        self.createUI()
    }
    
    /// 绑定父 view
    /// - Parameter view: 父 view
    func bindView(view: UIView?) {
        
        self.removeFromSuperview()
        
        if let view {
            view.addSubview(self)
        }
    }
    
    /// 显示
    func show() {
        self.isHidden = false
        self.contentView?.isHidden = false
        self.contentView?.n_top = self.n_height
        UIView.animate(withDuration: 0.3) {
            self.contentView?.n_top = self.n_height - (self.contentView?.n_height ?? 0.0)
        } completion: { isSuc in
            if let showAction = self.showAction {
                showAction()
            }
        }
    }
    
    /// 隐藏
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.contentView?.n_top = self.n_height
        } completion: { isSuc in
            if let closeAction = self.closeAction {
                closeAction()
            }
            self.contentView?.isHidden = true
            self.isHidden = true
        }
    }
    
}


