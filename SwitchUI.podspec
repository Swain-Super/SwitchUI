#
# Be sure to run `pod lib lint SwitchUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'SwitchUI'
    s.version          = "1.2.0"
    s.summary          = 'A Swift declarative UI framework inspired by SwiftUI'
    s.description      = <<-DESC
    SwitchUI is a lightweight Swift declarative UI framework that provides a simple and elegant way to build user interfaces.
    It offers a SwiftUI-like syntax while maintaining compatibility with UIKit.
    DESC
    s.homepage         = 'https://github.com/Swain-Super/SwitchUI'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'swain' => 'shiwen@guanghe.tv' }
    s.source           = { :git => 'https://github.com/Swain-Super/SwitchUI.git',
        :tag => s.version.to_s
    }
    s.social_media_url = 'https://github.com/Swain-Super'
    s.documentation_url = 'https://github.com/Swain-Super/SwitchUI/wiki'
    
    s.ios.deployment_target = '10.0'
    s.cocoapods_version     = '>= 1.4.0'
    s.swift_version = '5.0'
    
    s.source_files = 'SwitchUI/Classes/**/*'
    
    s.frameworks = 'UIKit', 'Foundation'
    s.requires_arc = true
    
    # MARK: Third Part Libs
      
end
