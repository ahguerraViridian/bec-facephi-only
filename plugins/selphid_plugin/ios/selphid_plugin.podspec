#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'selphid_plugin'
  s.version          = '1.0.0'
  s.summary          = 'SelphID plugin for Flutter.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://www.facephi.com'
  s.platform            = :ios, "10.0"
  s.license          = { :file => '../LICENSE' }
  s.author           = { "Facephi" => "support@facephi.com" }
  s.source           = { :git => '.' }
  s.source_files = 'Classes/*.{h,m,swift}'
  s.public_header_files = 'Classes/*.h'
  
  s.resources = ['Resources/fphi-selphid-widget-resources-selphid-1.0.zip']

s.dependency 'zipzap'
s.dependency 'Flutter'
s.dependency 'GoogleMLKit/TextRecognition'
s.dependency 'FPhiSelphIDWidgetiOS'  
s.dependency 'FPhiMBWidgetiOS'
s.static_framework = true

end

