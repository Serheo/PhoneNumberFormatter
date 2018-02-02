Pod::Spec.new do |s|
  s.name         = "SwiftPhoneNumberFormatter"
  s.version      = "1.2"
  s.summary      = "PhoneNumberFormatter for iOS"
  s.homepage     = "https://github.com/Serheo/PhoneNumberFormatter"
  s.license      = 'MIT'
  s.author       = { "Sergei Shatunov" => "sshatunov@gmail.com" }
  s.source       = { :git => "https://github.com/Serheo/PhoneNumberFormatter.git", :tag => s.version.to_s }
  s.platform     = :ios, '9.0'
  s.source_files = 'PhoneNumberFormatter/Sources/**/*.{swift}'
  s.requires_arc = true
end