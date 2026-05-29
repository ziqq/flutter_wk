#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_wk.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_wk'
  s.version          = '0.0.1'
  s.summary          = 'Flutter library for iOS Widgets Extensions. Integrate a Widget into your App.'
  s.description      = <<-DESC
Flutter library for iOS Widgets Extensions. Integrate a Widget into your App.
                       DESC
  s.homepage         = 'https://github.com/ziqq/flutter_wk'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Anton Ustinoff' => 'a.a.ustinoff@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'flutter_wk/Sources/flutter_wk/**/*.swift', 'flutter_wk/Sources/flutter_wk_core/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
