//
//  SState.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/6/12.
//

import Foundation
import UIKit

typealias SWView = SWeakRef<UIView>

public enum StateValueType {
    case `Any`
    case Float
    case Int
    case String
    case Double
    case Array
    case Map
    case Bool
}

public class SState: NSObject  {
    
    private var isFirstChange = true
    
    /// 值
    private var _value: Any?
    /// 值类型枚举
    private var valueType: StateValueType = .Any
    
    public var value: Any? {
        get {
            return _value
        }
        set {
            _value = newValue
            
            // 检查当前值类型
            self.checkValueType()
            
            if isFirstChange {
                isFirstChange = false
                return
            }
            
            // 触发观察者响应
            self.triggerObserver()
            
            // 刷新绑定的UI
            self.triggerRefresh()
            
        }
    }
    
    /// 检查当前的值类型
    private func  checkValueType() {
        if value is Int {
            self.valueType = .Int
        }else if value is Float {
            self.valueType = .Float
        } else if value is String {
            self.valueType = .String
        } else if value is Double {
            self.valueType = .Double
        } else if value is Array<Any> {
            self.valueType = .Array
        } else if value is Dictionary<String, Any> {
            self.valueType = .Map
        } else if value is Bool {
            self.valueType = .Bool
        }
    }
    
    /// 尝试转换值类型
    private func tryCovertValueType(type: StateValueType) -> Any {
        
        // 现将当前值转换为String
        var convertedValue: String? = self.value as? String

        if self.valueType != .String {
            switch self.valueType {
                case .Float:
                convertedValue = "\(self.value as? Float ?? 0.0)"
                case .Int:
                convertedValue = "\(self.value as? Int ?? 0)"
                case .Double:
                convertedValue = "\(self.value as? Double ?? 0.0)"
                case .Array:
                if let array = self.value as? [Any],
                   let jsonData = try? JSONSerialization.data(withJSONObject: array, options: []),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    convertedValue = jsonString
                } else {
                    convertedValue = "[]"
                }
                case .Map:
                if let dict = self.value as? [String: Any],
                   let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    convertedValue = jsonString
                } else {
                    convertedValue = "{}"
                }
                case .Bool:
                convertedValue = (self.value as? Bool ?? false) ? "1" : "0" // 统一用 "1"/"0" 便于后续解析
            default:
                break
            }
        }
            
        if let value = convertedValue {
            return self.convertValue(value, to: type)
        }
        return ""
    }
    
    /// 转换值类型
    func convertValue(_ value: String, to type: StateValueType) -> Any {
        
        var result: Any? = nil
        
        switch type {
            case .Float:
                result = Float(value) ?? 0.0
            case .Int:
                if let intValue = Int(value) {
                    result = intValue // 直接是整数，转换成功
                } else if let doubleValue = Double(value) {
                    result = Int(doubleValue) // 浮点数，转换为整数
                }
            case .Double:
                result = Double(value) ?? 0.0
            case .Array:
                if let data = value.data(using: .utf8),
                   let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                    result = jsonArray
                } else {
                    result = value.components(separatedBy: ",") // 备用方案
                }
            case .Map:
                if let data = value.data(using: .utf8),
                   let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    result =  json
                }
                return [:]
            case .Bool:
                return ["true", "yes", "1"].contains(value.lowercased()) // 处理布尔值
            case .String:
                result =  value
            case .Any:
                result =  value
        }
        return result ?? ""
    }

    public var boolValue: Bool {
        get {
            return _value as? Bool ?? (self.tryCovertValueType(type: .Bool) as? Bool ?? false)
        }
    }
    
    public var intValue: Int {
        get {
            return _value as? Int ?? (self.tryCovertValueType(type: .Int) as? Int ?? 0)
        }
    }
    
    public var floatValue: Float {
        get {
            return _value as? Float ?? (self.tryCovertValueType(type: .Float) as? Float ?? 0.0)
        }
    }
    
    public var doubleValue: Double {
        get {
            return _value as? Double ?? (self.tryCovertValueType(type: .Double) as? Double ?? 0.0)
        }
    }
    
    public var stringValue: String {
        get {
            return _value as? String ?? (self.tryCovertValueType(type: .String) as? String ?? "")
        }
    }
    
    public var arrayValue: Array<Any> {
        get {
            return _value as? Array ?? (self.tryCovertValueType(type: .Array) as? Array<Any> ?? [])
        }
    }
    
    public var mapValue: Dictionary<String, Any> {
        get {
            return _value as? Dictionary ?? (self.tryCovertValueType(type: .Map) as? Dictionary<String, Any> ?? [:])
        }
    }
    
    /// 绑定对象View Id
    var bindViews: [String] = []
    
    /// 绑定的观察者
    var bindObservers: [(Any?) -> Void] = []
    
    public init(_ value: Any) {
        super.init()
        self.value = value
    }
    
    /// 添加绑定
    /// - Parameters:
    ///   - sender: 对象
    ///   - attribute:
    public func addBind(viewId: String) {
        
        if self.bindViews.contains(viewId) {
            return
        }
        self.bindViews.append(viewId)
    }
    
    /// 添加观察者监听
    /// - Parameter block: 监听
    public func addObserver(block: @escaping (Any) -> Void) {
        self.bindObservers.append(block)
    }
    
    /// 刷新绑定对象属性
    public func triggerRefresh() {
        
        _ = self.bindViews.map { viewId in
            SUIManager.shared.render(viewId: viewId)
        }
    }
    
    /// 触发观察者监听
    public func triggerObserver() {
        _ = self.bindObservers.map { block in
            block(self.value)
        }
    }
    
}

