Pod::Spec.new do |s|
  s.name         = "ToastMessage"
  s.version      = "1.0"
  s.summary      = "Toast messages for iOS"
  s.homepage     = "https://github.com/Serheo/ToastMessage"
  s.license      = 'MIT'
  s.author       = { "Serheo Shatunov" => "sshatunov@gmail.com" }
  s.source       = { :git => "https://github.com/Serheo/ToastMessage.git", :tag => s.version.to_s }
  s.platform     = :ios, '9.0'
  s.source_files = 'ToastMessage/Sources/**/*.{swift}'
  s.requires_arc = true
end