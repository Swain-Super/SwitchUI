//
//  SWToastView.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/12/15.
//

import Foundation

public class SWToastView: UIView {
    
    var toast: String = ""
    
    var timer: Timer?
    
    var time: TimeInterval = 3.0

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 反初始化器
    deinit { print("SWToastView deinit~") }
    
    // MARK: - 初始化器
    init(frame: CGRect, toast: String, time: TimeInterval = 3.0) {
        super.init(frame: frame)
        self.toast = toast
        self.time = time
        
        self.isUserInteractionEnabled = false
        
        self.createUI()
        
        if time > 0 {
            self.timer = Timer.scheduledTimer(timeInterval: time, target: self, selector:#selector(autoHide), userInfo: nil, repeats: false)
        }
    }
    
    func createUI() {
        let container: SContainer = self.build()
        self.addSubview(container)
        container.layout()
    }
    
    @objc func autoHide() {

        self.removeFromSuperview()
    }
    
    func build() -> SContainer {
        SRelativeContainer([
            SRow([
                UILabel()
                    .text(self.toast)
                    .numberOfLines(0)
                    .textColor(.white)
                    .font(UIFont.systemFont(ofSize: 13))
            ])
            .padding(UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15))
            .alignRules([
                .centerX : [SAnchor: SSuperContainer, SAlign: SWPositionType.centerX],
                .centerY : [SAnchor: SSuperContainer, SAlign: SWPositionType.centerY]
            ])
            .cornerRadius(10)
            .backgroundColor("#D9000000")
        ])
        .width("100%")
        .height("100%")
    }
}

public extension SWWrapper where Base : UIView {
    
    /// 展示loading框(主线程中刷新UI)
    func showToast(_ message: String = "", _ time: TimeInterval = 3.0) {
        // 若当前视图已加载CCLoadingView,则先移除后,再添加;
        if let lastView = base.subviews.last as? SWToastView { lastView.removeFromSuperview() }
        
        let loadingView = SWToastView(frame: base.bounds, toast: message, time: time)
        base.addSubview(loadingView)
    }
    
    /// 隐藏loading框(主线程中刷新UI)
    func hideToast() {
        for item in base.subviews {
            if item.isKind(of: SWToastView.self) {
                item.removeFromSuperview()
            }
        }
    }
}
