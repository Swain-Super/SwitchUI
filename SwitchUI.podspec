#
# Be sure to run `pod lib lint Riki.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'SwitchUI'
    s.version          = "1.0.3"
    s.summary          = 'Swift声明式框架'
    s.description      = <<-DESC
    Swift声明式框架
    DESC
    s.homepage         = 'https://gitlab.yc345.tv/ios/ycmath-platform-ios/privateLibs/SwitchUI'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'kuilin' => 'shiwen@guanghe.tv' }
    s.source           = { :git => 'git@gitlab.yc345.tv:ios/ycmath-platform-ios/privateLibs/SwitchUI.git',
        # REMARK: source tag for release mode
        :tag => s.version.to_s
        # REMARK: source branch for develop mode
        # :branch => 'develop'
    }
    s.ios.deployment_target = '10.0'
    s.osx.deployment_target = '11.0'
    s.cocoapods_version     = '>= 1.4.0'
    s.swift_version = '5.0'
    #s.default_subspecs      = 'iOS'
    
    s.source_files = 'SwitchUI/Classes/**/*'
    
    # MARK: Third Part Libs
    # s.dependency 'YC_YogaKit', '>= 1.0.0'
      
end
