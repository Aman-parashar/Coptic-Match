# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'HalalDating' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for HalalDating
  pod 'IQKeyboardManagerSwift'
  pod 'Reachability'
  pod 'Toast-Swift'
  pod 'TLFloatLabelTextField'
  pod 'DropDown'
  pod 'Popover'
  pod 'Alamofire'
  pod 'AlamofireImage'
  pod 'MBProgressHUD'
  pod 'ActionSheetPicker-3.0'
  pod 'SwiftyJSON'
  pod 'ObjectMapper'
  pod 'SDWebImage'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'MultiSlider'
  pod 'SwiftyGif'
  pod 'Koloda'
  pod 'Cartography'
  pod 'SKCountryPicker'
  pod 'QuickBlox'
  pod 'Quickblox-WebRTC'
  pod 'SVProgressHUD'
  pod 'FaceSDK'
  #pod 'FaceSDK', '4.1.1217'
  pod 'GoogleSignIn'
  pod 'Firebase/Crashlytics'
  pod 'GoogleMaps'
  pod 'SwiftyStoreKit'
  pod 'FirebaseFirestore'
  
  
  post_install do |installer|
    # Set IPHONEOS_DEPLOYMENT_TARGET for all pods
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
        config.build_settings['ENABLE_BITCODE'] = 'NO'
      end
    end
  end
end

