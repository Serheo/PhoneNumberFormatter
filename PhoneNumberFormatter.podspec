Pod::Spec.new do |s|
  s.name           = "PhoneNumberFormatter"
  s.version        = "1.5.rc.1"
  s.summary        = "PhoneNumberFormatter for iOS"
  s.homepage       = "https://github.com/Nixon506E/PhoneNumberFormatter"
  s.license        = 'MIT'
  s.author         = { "Sergei Shatunov" => "sshatunov@gmail.com" }
  s.source         = { :git => "https://github.com/Nixon506E/PhoneNumberFormatter.git", :tag => s.version.to_s }
  s.platform       = :ios, '9.0'
  s.swift_versions = ['5.0']
  s.source_files   = 'PhoneNumberFormatter/Sources/**/*.{swift}'
  s.requires_arc   = true
end
