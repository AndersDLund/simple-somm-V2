use_frameworks!
platform :ios, '11.0'

target 'simple_somm_V2' do
  pod 'MaterialComponents'
  pod 'TesseractOCRiOS', '4.0.0'
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['ENABLE_BITCODE'] = 'NO'
          end
      end
  end
end
