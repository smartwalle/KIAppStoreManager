Pod::Spec.new do |s|
  s.name         = "KIAppStoreManager"
  s.version      = "0.1"
  s.summary      = "KIAppStoreManager"
  s.description  = <<-DESC
                  KIAppStoreManager.
                   DESC

  s.homepage     = "https://github.com/smartwalle/KIAppStoreManager"
  s.license      = "MIT"
  s.author             = { "SmartWalle" => "smartwalle@gmail.com" }
  s.platform     = :ios, "5.0"
  s.source       = { :git => "https://github.com/smartwalle/KIAppStoreManager.git", :branch => "master" }
  s.source_files  = "KIAppStoreManager/KIAppStoreManager/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.requires_arc = true
end
