#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint haishin_kit.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'haishin_kit'
  s.version          = '0.14.3'
  s.summary          = 'A Flutter plugin for Camera and Microphone streaming library via RTMP.'
  s.description      = <<-DESC
A Flutter plugin for Camera and Microphone streaming library via RTMP for HaishinKit.
This plugin provides easy-to-use API for RTMP streaming functionality in Flutter applications.
                       DESC
  s.homepage         = 'https://github.com/HaishinKit/HaishinKit.dart'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'HaishinKit' => 'haishinkit.swift@gmail.com' }
  
  s.source           = { :path => '.' }
  s.source_files     = 'haishin_kit/Sources/**/*'
  s.dependency 'Flutter'
  s.dependency 'HaishinKit', '2.0.9'
  
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
