#
# Be sure to run `pod lib lint DynamicOverlay.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DynamicOverlay'
  s.version          = '1.0.0'
  s.summary          = 'DynamicOverlay'
  s.swift_version    = "5.0"

  s.description      = 'DynamicOverlay'

  s.homepage         = 'https://github.com/fabernovel/DynamicOverlay'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  # s.author           = { 'DynamicOverlay' => 'DynamicOverlay@fabernovel.com' }
  s.source           = { :git => 'https://github.com/fabernovel/DynamicOverlay.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.source_files = 'Source/Classes/**/*'
end
