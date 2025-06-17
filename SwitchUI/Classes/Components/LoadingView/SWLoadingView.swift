//
//  SWLoadingView.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/12/15.
//

import Foundation

public class SWLoadingView: UIView {

    var activity: UIActivityIndicatorView?
    
    var title: String = ""
    
    var timer: Timer?
    
    var time: TimeInterval = 3.0
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 反初始化器
    deinit { print("SWLoadingView deinit~") }
    
    // MARK: - 初始化器
    init(frame: CGRect, title: String, time: TimeInterval = 3.0) {
        super.init(frame: frame)
        self.title = title
        self.time = time
        
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
            SColum([
                UILabel()
                    .text(self.title)
                    .numberOfLines(0)
                    .textColor(.white)
                    .bottom(10.0)
                    .numberOfLines(0),
                UIActivityIndicatorView(style: .white)
                    .width(30)
                    .height(30)
                    .callSelf(&self.activity)
                    .start()
            ])
            .alignContent(.center)
            .cornerRadius(10)
            .padding(UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 10))
            .width("100")
            .height("100%")
            .alignRules([
                .centerX : [SAnchor: SSuperContainer, SAlign: SWPositionType.centerX],
                .centerY : [SAnchor: SSuperContainer, SAlign: SWPositionType.centerY]
            ])
        ])
        .width("100%")
        .height("100%")
        
    }
}

public extension SWWrapper where Base : UIView {
    
    /// 展示loading框(主线程中刷新UI)
    func showLoading(_ message: String = "") {
        // 若当前视图已加载CCLoadingView,则先移除后,再添加;
        if let lastView = base.subviews.last as? SWLoadingView { lastView.removeFromSuperview() }
        
        let loadingView = SWLoadingView(frame: base.bounds, title: message)
        base.addSubview(loadingView)
    }
    
    /// 隐藏loading框(主线程中刷新UI)
    func hideLoading() {
        for item in base.subviews {
            if item.isKind(of: SWLoadingView.self) {
                item.removeFromSuperview()
            }
        }
    }
}
