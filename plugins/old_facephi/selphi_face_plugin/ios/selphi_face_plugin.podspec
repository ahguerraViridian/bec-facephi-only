#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint selphi_face_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'selphi_face_plugin'
  s.version          = '1.0.0'
  s.summary          = 'Selphi plugin for Flutter.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://www.facephi.com'
  s.platform         = :ios, '9.0'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Facephi' => 'support@facephi.com' }
  s.source           = { :git => "." }
  s.source_files        = 'Classes/*.{h,m,swift}'
  s.public_header_files = 'Classes/*.h'

  s.vendored_frameworks = 'Frameworks/FPhiWidgetSelphi.xcframework', 'Frameworks/FPhiWidgetCore.xcframework', 'Frameworks/FPBExtractoriOS.xcframework'

  s.resources = ['Resources/fphi-selphi-widget-resources-selphi-live-1.2.zip']

  s.dependency 'zipzap'
  s.dependency 'Flutter'

  s.static_framework = true
end