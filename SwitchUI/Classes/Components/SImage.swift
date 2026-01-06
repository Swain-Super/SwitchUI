//
//  SImage.swift
//  SwitchUI
//
//  Created by Swain on 2025/01/06.
//  Copyright © 2025 swain. All rights reserved.
//

import UIKit

// MARK: - SImageLoadState
public enum SImageLoadState {
    case idle           // 空闲状态
    case loading        // 加载中
    case success        // 加载成功
    case failed         // 加载失败
}

// MARK: - SImage
public class SImage: UIImageView {
    
    // 图片源
    public var s_image: UIImage?
    public var s_imageName: String?
    public var s_imageURL: String?
    
    // 占位图
    public var s_placeholder: UIImage?
    public var s_placeholderName: String?
    
    // 错误图
    public var s_errorImage: UIImage?
    public var s_errorImageName: String?
    
    // 加载状态
    public var loadState: SImageLoadState = .idle
    
    // 内容模式
    public var s_contentMode: UIView.ContentMode = .scaleAspectFill
    
    // 圆角
    public var s_cornerRadius: CGFloat?
    
    // 边框
    public var s_borderWidth: CGFloat?
    public var s_borderColor: UIColor?
    
    // 是否圆形
    public var s_isCircle: Bool = false
    
    // 缓存策略
    public var s_cacheEnabled: Bool = true
    
    // 超时时间
    public var s_timeout: TimeInterval = 30
    
    // 渐入动画
    public var s_fadeIn: Bool = true
    public var s_fadeInDuration: TimeInterval = 0.3
    
    // 加载指示器
    public var s_showLoadingIndicator: Bool = false
    private var loadingIndicator: UIActivityIndicatorView?
    
    // 加载回调
    public var onLoadStart: (() -> Void)?
    public var onLoadSuccess: ((UIImage) -> Void)?
    public var onLoadFailed: ((Error?) -> Void)?
    
    // 缓存字典（简单内存缓存）
    private static var imageCache: [String: UIImage] = [:]
    
    // 当前下载任务
    private var downloadTask: URLSessionDataTask?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
    
    // MARK: - Chainable Methods
    
    @discardableResult
    public func s_image(_ image: UIImage?) -> Self {
        self.s_image = image
        return self
    }
    
    @discardableResult
    public func s_imageName(_ name: String) -> Self {
        self.s_imageName = name
        return self
    }
    
    @discardableResult
    public func s_imageURL(_ url: String) -> Self {
        self.s_imageURL = url
        return self
    }
    
    @discardableResult
    public func s_placeholder(_ image: UIImage?) -> Self {
        self.s_placeholder = image
        return self
    }
    
    @discardableResult
    public func s_placeholderName(_ name: String) -> Self {
        self.s_placeholderName = name
        return self
    }
    
    @discardableResult
    public func s_errorImage(_ image: UIImage?) -> Self {
        self.s_errorImage = image
        return self
    }
    
    @discardableResult
    public func s_errorImageName(_ name: String) -> Self {
        self.s_errorImageName = name
        return self
    }
    
    @discardableResult
    public func s_contentMode(_ mode: UIView.ContentMode) -> Self {
        self.s_contentMode = mode
        return self
    }
    
    @discardableResult
    public func s_cornerRadius(_ radius: CGFloat) -> Self {
        self.s_cornerRadius = radius
        return self
    }
    
    @discardableResult
    public func s_borderWidth(_ width: CGFloat) -> Self {
        self.s_borderWidth = width
        return self
    }
    
    @discardableResult
    public func s_borderColor(_ color: UIColor) -> Self {
        self.s_borderColor = color
        return self
    }
    
    @discardableResult
    public func s_borderColor(_ hexString: String) -> Self {
        self.s_borderColor = hexString.hexColor()
        return self
    }
    
    @discardableResult
    public func s_isCircle(_ isCircle: Bool) -> Self {
        self.s_isCircle = isCircle
        return self
    }
    
    @discardableResult
    public func s_cacheEnabled(_ enabled: Bool) -> Self {
        self.s_cacheEnabled = enabled
        return self
    }
    
    @discardableResult
    public func s_timeout(_ timeout: TimeInterval) -> Self {
        self.s_timeout = timeout
        return self
    }
    
    @discardableResult
    public func s_fadeIn(_ enabled: Bool, duration: TimeInterval = 0.3) -> Self {
        self.s_fadeIn = enabled
        self.s_fadeInDuration = duration
        return self
    }
    
    @discardableResult
    public func s_showLoadingIndicator(_ show: Bool) -> Self {
        self.s_showLoadingIndicator = show
        return self
    }
    
    // MARK: - Event Callbacks
    
    @discardableResult
    public func onLoadStart(_ callback: @escaping () -> Void) -> Self {
        self.onLoadStart = callback
        return self
    }
    
    @discardableResult
    public func onLoadSuccess(_ callback: @escaping (UIImage) -> Void) -> Self {
        self.onLoadSuccess = callback
        return self
    }
    
    @discardableResult
    public func onLoadFailed(_ callback: @escaping (Error?) -> Void) -> Self {
        self.onLoadFailed = callback
        return self
    }
    
    // MARK: - Render
    
    @discardableResult
    public func s_render() -> Self {
        // 设置内容模式
        self.contentMode = s_contentMode
        
        // 设置圆角
        if let cornerRadius = s_cornerRadius {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
        
        // 设置边框
        if let borderWidth = s_borderWidth {
            self.layer.borderWidth = borderWidth
        }
        if let borderColor = s_borderColor {
            self.layer.borderColor = borderColor.cgColor
        }
        
        // 加载图片
        loadImage()
        
        return self
    }
    
    // MARK: - Private Methods
    
    private func loadImage() {
        // 1. 优先使用直接设置的 UIImage
        if let image = s_image {
            setImage(image)
            return
        }
        
        // 2. 加载本地图片
        if let imageName = s_imageName, let image = UIImage(named: imageName) {
            setImage(image)
            return
        }
        
        // 3. 加载网络图片
        if let imageURL = s_imageURL {
            loadRemoteImage(from: imageURL)
            return
        }
        
        // 如果没有任何图片源，显示占位图
        showPlaceholder()
    }
    
    private func setImage(_ image: UIImage) {
        self.image = image
        loadState = .success
        onLoadSuccess?(image)
    }
    
    private func showPlaceholder() {
        if let placeholder = s_placeholder {
            self.image = placeholder
        } else if let placeholderName = s_placeholderName, let placeholder = UIImage(named: placeholderName) {
            self.image = placeholder
        }
    }
    
    private func showErrorImage() {
        if let errorImage = s_errorImage {
            self.image = errorImage
        } else if let errorImageName = s_errorImageName, let errorImage = UIImage(named: errorImageName) {
            self.image = errorImage
        } else {
            // 如果没有错误图，显示占位图
            showPlaceholder()
        }
    }
    
    private func showLoadingIndicator() {
        if s_showLoadingIndicator {
            if loadingIndicator == nil {
                loadingIndicator = UIActivityIndicatorView(style: .gray)
                loadingIndicator?.hidesWhenStopped = true
                self.addSubview(loadingIndicator!)
            }
            loadingIndicator?.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
            loadingIndicator?.startAnimating()
        }
    }
    
    private func hideLoadingIndicator() {
        loadingIndicator?.stopAnimating()
    }
    
    /// 创建 URL（自动处理中文和特殊字符编码）
    private func createURL(from urlString: String) -> URL? {
        // 1. 先尝试直接创建（如果 URL 已经编码过，或者不包含特殊字符）
        if let url = URL(string: urlString) {
            return url
        }
        
        // 2. 如果失败，尝试进行百分号编码
        // 使用 URLComponents 来智能处理 URL 的各个部分
        if let components = URLComponents(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString) {
            return components.url
        }
        
        // 3. 如果 URLComponents 也失败，手动编码整个字符串
        // 但保留 URL 的基本字符（:, /, ?, &, =, #）
        var allowedCharacters = CharacterSet.urlQueryAllowed
        allowedCharacters.insert(charactersIn: ":#[]@!$&'()*+,;=")
        
        if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: allowedCharacters),
           let url = URL(string: encodedString) {
            return url
        }
        
        // 4. 所有方法都失败，返回 nil
        return nil
    }
    
    private func loadRemoteImage(from urlString: String) {
        // 显示占位图
        showPlaceholder()
        
        // 检查缓存
        if s_cacheEnabled, let cachedImage = SImage.imageCache[urlString] {
            setImage(cachedImage)
            return
        }
        
        // 取消之前的下载任务
        downloadTask?.cancel()
        
        // 创建 URL（自动处理中文和特殊字符）
        guard let url = createURL(from: urlString) else {
            loadState = .failed
            showErrorImage()
            onLoadFailed?(nil)
            return
        }
        
        // 开始加载
        loadState = .loading
        showLoadingIndicator()
        onLoadStart?()
        
        // 创建下载任务
        let session = URLSession.shared
        downloadTask = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.hideLoadingIndicator()
                
                // 检查错误
                if let error = error {
                    self.loadState = .failed
                    self.showErrorImage()
                    self.onLoadFailed?(error)
                    return
                }
                
                // 检查数据
                guard let data = data, let image = UIImage(data: data) else {
                    self.loadState = .failed
                    self.showErrorImage()
                    self.onLoadFailed?(nil)
                    return
                }
                
                // 缓存图片
                if self.s_cacheEnabled {
                    SImage.imageCache[urlString] = image
                }
                
                // 设置图片
                if self.s_fadeIn {
                    self.alpha = 0
                    self.image = image
                    UIView.animate(withDuration: self.s_fadeInDuration) {
                        self.alpha = 1
                    }
                } else {
                    self.image = image
                }
                
                self.loadState = .success
                self.onLoadSuccess?(image)
            }
        }
        
        downloadTask?.resume()
    }
    
    // MARK: - Public Methods
    
    /// 重新加载图片
    @discardableResult
    public func reload() -> Self {
        loadImage()
        return self
    }
    
    /// 清除缓存
    public static func clearCache() {
        imageCache.removeAll()
    }
    
    /// 清除指定 URL 的缓存
    public static func clearCache(for url: String) {
        imageCache.removeValue(forKey: url)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // 如果设置为圆形，根据宽高最小值设置圆角
        if s_isCircle {
            self.layer.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
            self.layer.masksToBounds = true
        }
        
        // 更新加载指示器位置
        loadingIndicator?.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }
    
    deinit {
        downloadTask?.cancel()
    }
}

