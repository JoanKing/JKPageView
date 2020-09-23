#
# Be sure to run `pod lib lint JKPageView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JKPageView'
  s.version          = '0.1.7'
  s.summary          = '标题滚动组件'
  s.description      = '这是一个标题和容器联动的组件库'

  s.homepage         = 'https://github.com/JoanKing/JKPageView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JoanKing' => 'wangchong@cloud-young.com' }
  s.source           = { :git => 'https://github.com/JoanKing/JKPageView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'JKPageView/Classes/**/*'
  
  s.swift_version = '5.0'
  
end
