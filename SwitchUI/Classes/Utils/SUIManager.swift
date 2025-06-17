//
//  SUIManager.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/6/13.
//

import Foundation
import UIKit

public class SUIManager {
    
    static var shared = SUIManager()
    
    /// UI属性更新反射方法
    private var uiAttributeReflect: [String: Any] = [:]
    
    /// 页面所有组件，组件Id : 组件对象
    private var components: [String: SWView] = [:]
    
    /// 等待刷新组件
    private var waitCheckLayouts: [String] = []
    
    /// Timer对象
    private var timer: Timer?
    
    init() {
        
        // 自动注册UI刷新映射
        self.addAttributeReflect(reflect: UIViewUI.registerRefresh())
        self.addAttributeReflect(reflect: UIButtonUI.registerRefresh())
        self.addAttributeReflect(reflect: UIControlUI.registerRefresh())
        self.addAttributeReflect(reflect: UIImageViewUI.registerRefresh())
        self.addAttributeReflect(reflect: UILabelUI.registerRefresh())
        self.addAttributeReflect(reflect: UISwitchUI.registerRefresh())
        self.addAttributeReflect(reflect: UITableViewUI.registerRefresh())
        self.addAttributeReflect(reflect: UITextFieldUI.registerRefresh())
        self.addAttributeReflect(reflect: UITextViewUI.registerRefresh())
        self.addAttributeReflect(reflect: UIStackViewUI.registerRefresh())
    }
    
    /// 添加页面组件
    /// - Parameters:
    ///   - viewId: 组件id
    ///   - component: 组件对象
    func add(viewId: String, component: UIView) {
        self.components[viewId] = SWView(value: component)
    }
    
    /// 删除页面组件
    /// - Parameter viewId: 组件id
    func remove(viewId: String) {
        self.components.removeValue(forKey: viewId)
    }
    
    /// 刷新UI
    /// - Parameter viewId: 组件id
    func render(viewId: String) {
        self.components[viewId]?.value?.sRefreshUI()
    }
    
    /// 查找组件
    /// - Parameter viewId: 组件id
    /// - Returns: 组件
    func findComponents(viewId: String) -> UIView? {
        if let target = self.components[viewId] {
            return target.value
        }
        return nil
    }
    
    /// UI刷新属性方法反射
    /// - Parameter reflect: 反射
    func addAttributeReflect(reflect : [String: Any]) {
        if reflect.count > 0 {
            self.uiAttributeReflect = self.uiAttributeReflect.merging(reflect, uniquingKeysWith: { first, _ in first })
        }
    }
    
    /// 获取反射方法
    /// - Parameter key: key
    /// - Returns: 反射方法
    func getAttributeReflect(key: String) -> Any? {
        return self.uiAttributeReflect[key]
    }
    
    /// 执行UI更新反射方法
    /// - Parameter key: key
    /// - Returns: 反射方法
    @discardableResult
    func runAttributeReflect(key: String, view: UIView, value: Any) -> Bool {
        if let block = self.getAttributeReflect(key: key) as? (UIView, Any) -> Void {
            block(view, value)
            return true
        }
        return false
    }
    
    // MARK: - 自动更新UI
    
    /// 添加要刷新的组件到刷新池子
    /// - Parameter view: 组件
    func addRefreshPool(view: UIView, attributeKey: String) {
        
        // 查找要刷新的父级
        var targetContainer: SContainer? = self.findRefreshContainer(view: view) as? SContainer
        if let targetContainer = targetContainer, !waitCheckLayouts.contains(targetContainer.sViewId) {
            // 刷新UI
            waitCheckLayouts.append(targetContainer.sViewId)
            self.startLayoutTimer()
        }
    }
    
    /// 递归查找要刷新的父级UI
    /// - Parameter view: 组件
    /// - Returns: 目标组件
    func findRefreshContainer(view: UIView) -> UIView? {
        
        if let container = view as? SContainer, container.isConstWidth, container.isConstHeight {
            return container
        }
        
        if let superView = view.superview {
            return self.findRefreshContainer(view: superView)
        } else {
            return nil
        }
    }
    
    /// 开始刷新UI定时器
    func startLayoutTimer() {
        self.stopTimer()
        
        if timer == nil {
            // 启动定时器
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:
            #selector(timerAction), userInfo: nil, repeats: false)
            
            RunLoop.current.add(timer!, forMode: .common)
        }
    }
    
    /// 停止
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    /// 触发定时器
    @objc func timerAction() {
        
        // 觉得刷新的UI
        var finialLayoutUI: [String: String] = [:]
        
        // 触发刷新UI， 自动收束刷新树更新范围
        waitCheckLayouts.map { viewId in
            guard let view = self.findComponents(viewId: viewId) else {return}
            
            var viewTree = ""
            self.findAllSubViews(view: view, viewTree: &viewTree)
            
            if finialLayoutUI.count == 0 {
                
                finialLayoutUI[viewId] = viewTree
            } else {
                var isContained = false
                var containKey = ""
                finialLayoutUI.map { (key: String, value: String) in
                    if value.count > viewTree.count {
                        if value.contains(viewTree) {
                            isContained = true
                        }
                    } else {
                        if viewTree.contains(value) {
                            containKey = key
                        }
                    }
                }
                
                // 移除重复的容器
                if containKey.isEmpty == false {
                    finialLayoutUI.removeValue(forKey: containKey)
                }
                
                // 添加这个刷新树
                if !isContained {
                    finialLayoutUI[viewId] = viewTree
                }
            }
        }
        
        // 刷新UI
        finialLayoutUI.map { (key: String, value: String) in
            if let container = self.findComponents(viewId: key) as? SContainer {
                container.layout()
            }
        }
        
        // 清空刷新
        waitCheckLayouts.removeAll()
        
        stopTimer()
    }
    
    /// 发现组件及所有子节点的viewId拼接串
    /// - Parameters:
    ///   - view: 目标组件
    ///   - viewTree: 拼接串
    func findAllSubViews(view: UIView, viewTree: inout String) {
        
        viewTree = viewTree.appending(view.sViewId + "_")
        if view.subviews.isEmpty == false  {
            view.subviews.map { sView in
                findAllSubViews(view: sView, viewTree: &viewTree)
            }
        }
    }
    
    
}
