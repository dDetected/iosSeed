workspace 'Numbers'
project 'Project/Numbers.xcodeproj'

platform :ios, '8.0'
inhibit_all_warnings!
use_frameworks!

target 'Numbers' do

  pod 'SDWebImage'
  pod 'TesseractOCRiOS'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.to_s == "TesseractOCRiOS"
        target.build_configurations.each do |config|
          config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
      end
    end
  end

end
