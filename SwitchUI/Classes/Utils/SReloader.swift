//
//  SReloader.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/6/16.
//

import Foundation
import UIKit

public class SReloader: NSObject  {
    
    /// 入参
    public typealias ConditionExecute = () -> [Any]
    /// 子类构建Block
    var executeBlock: ConditionExecute?
    /// 父类viewId
    var superViewId: String?
    
    public init(_ executeBlock: @escaping ConditionExecute, _ states: [SState]? = nil) {
        super.init()
        
        self.executeBlock = executeBlock
        
        _ = states?.map({ state in
            state.addObserver { [weak self] x in
                guard let self = self else {return}
                self.triggerReloader()
            }
        })
    }
    
    /// 触发Reloader
    public func triggerReloader() {
        
        if let viewId = self.superViewId {
            let superView = SUIManager.shared.findComponents(viewId: viewId)
 
            // 重新布局
            if let container = superView as? SContainer {
                container.reloadSubViews()
            }
        }
    }
    
    
    
}
