#
# Be sure to run `pod lib lint DynamicOverlay.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DynamicOverlay'
  s.version          = '1.0.1'
  s.summary          = 'OverlayContainer is a SwiftUI library which makes it easier to develop overlay based interfaces.'
  s.swift_version    = "5.0"

  s.description      = <<-DESC
  OverlayContainer is a SwiftUI library written in Swift. It makes it easier to develop overlay based interfaces, such as the one presented in the Apple Maps, Stocks or Shortcuts apps.
                       DESC

  s.homepage         = 'https://github.com/fabernovel/DynamicOverlay'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gaetanzanella' => 'gaetan.zanella@fabernovel.com' }
  s.source           = { :git => 'https://github.com/fabernovel/DynamicOverlay.git', :tag => s.version.to_s }
  s.dependency       'OverlayContainer', '~> 3.5'

  s.ios.deployment_target = '13.0'
  s.source_files = 'Source/**/*.swift'
end
