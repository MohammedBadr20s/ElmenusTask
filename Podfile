# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'elmenusTask' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for elmenusTask
  pod 'SwiftMessages', '~> 6.0.2'
  # pod 'Parchment'
  pod 'Alamofire', '~> 4.8.2'
  pod 'SwiftyJSON', '~> 5.0.0'
  pod 'Kingfisher', '~> 5.4.0'
  pod 'IQKeyboardManagerSwift', '~> 6.3.0'
  pod 'SVProgressHUD', '~> 2.2.5'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'

  target 'elmenusTaskTests' do
    inherit! :search_paths
    # Pods for testing
  end
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings.delete('CODE_SIGNING_ALLOWED')
      config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
  end
end
