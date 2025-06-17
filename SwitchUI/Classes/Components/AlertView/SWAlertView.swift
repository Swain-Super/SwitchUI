//
//  SWAlertView.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2025/2/27.
//

import Foundation

public class SWAlertView: UIView {
    // MARK: - 属性
    /// 标题
    var title: String = ""
    /// 消息
    var message: String = ""
    /// 确定按钮标题
    var confirmTitle: String = ""
    /// 取消按钮标题
    var cancleTitle: String = ""
    /// 确定按钮回调
    var confirmBlock: (() -> Void)?
    /// 取消按钮回调
    var cancelBlock: (() -> Void)?
    
    var container: UIView?
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        // MARK: - 反初始化器
    deinit { print("SWAlertView deinit~") }
    
        // MARK: - 初始化器
    init(frame: CGRect,
         title: String = "提示",
         message: String = "",
         confirmTitle: String = "确定",
         cancleTitle: String = "取消",
         confirmBlock: (() -> Void)? = nil,
         cancelBlock: (() -> Void)? = nil) {
        super.init(frame: frame)
        
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle
        self.cancleTitle = cancleTitle
        self.confirmBlock = confirmBlock
        self.cancelBlock = cancelBlock
        
        self.createUI()
    }
    
    func createUI() {
        let container: SContainer = self.build()
        self.container = container
        self.addSubview(container)
        container.layout()
        container.n_centerX = self.n_width/2
        container.n_centerY = self.n_height/2
    }
    
    func build() -> SContainer {
            SColum([
                
                UILabel()
                    .text(self.title)
                    .numberOfLines(0)
                    .textColor(.white)
                    .top(30.0)
                    .numberOfLines(0),
                
                UILabel()
                    .text(self.message)
                    .numberOfLines(0)
                    .textColor(.white)
                    .top(15.0)
                    .numberOfLines(0),
                
                SRow(SReloader({ [weak self] in
                    guard let self = self else { return []}
                    var array = []
                    
                    if self.confirmTitle.count > 0 {
                        let confirm = UILabel()
                            .text(self.confirmTitle)
                            .numberOfLines(0)
                            .textColor(.white)
                            .onClick { [weak self] _ in
                                guard let self = self else { return }
                                if let confirmBlock = self.confirmBlock {
                                    confirmBlock()
                                }
                                self.hide()
                            }
                        array.append(confirm)
                    }
                    
                    if self.cancleTitle.count > 0 {
                        let cancle = UILabel()
                            .text(self.cancleTitle)
                            .numberOfLines(0)
                            .textColor(.white)
                            .onClick { [weak self] _ in
                                guard let self = self else { return }
                                if let cancelBlock = self.cancelBlock {
                                    cancelBlock()
                                }
                                self.hide()
                            }
                            .left("50")
                        array.append(cancle)
                    }
                    
                    return array
                }))
                .alignContent(.center)
                .top(20)
                .bottom(30)
            ])
            .alignContent(.center)
            .backgroundColor("#D9000000")
            .cornerRadius(10)
            .width("80%")
        
    }
    
    
    func show() {
        
        self.container?.transform = CGAffineTransformMakeScale(0.2, 0.2);
        
        UIView.animate(
                withDuration: 0.7,
                delay: 0,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0, options: .curveLinear) {
                    self.container?.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }
    }
    
    func hide() {
        
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0, options: .curveLinear, animations: {
                self.container?.transform = CGAffineTransformMakeScale(0, 0);
            }, completion: { isSuc in
                self.removeFromSuperview()
            })
    }
}

public extension SWWrapper where Base : UIView {
    
        /// 展示loading框(主线程中刷新UI)
    func showAlert(title: String = "提示",
                   message: String = "",
                   confirmTitle: String = "确定",
                   cancleTitle: String = "取消",
                   confirmBlock: (() -> Void)? = nil,
                   cancelBlock: (() -> Void)? = nil) {
            // 若当前视图已加载CCLoadingView,则先移除后,再添加;
        if let lastView = base.subviews.last as? SWAlertView {
            lastView.removeFromSuperview()
        }
        
        let alert = SWAlertView(
            frame: base.bounds,
            title: title,
            message: message,
            confirmTitle: confirmTitle,
            cancleTitle: cancleTitle,
            confirmBlock: confirmBlock,
            cancelBlock: cancelBlock)
        
        base.addSubview(alert)
        alert.show()
        
    }
    
}
