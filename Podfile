# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TakeFlight' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TakeFlight
  # Firebase
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Messaging'

  # Networking
  pod 'Alamofire', '~> 4.5'

  # User Interface
  pod 'RSKImageCropper' 
  pod 'Spring', :git => 'https://github.com/MengTo/Spring.git'
  
  # Reactive 
  pod 'RxSwift',  '~> 4.0'
  pod 'RxCocoa',  '~> 4.0'
  
  # Other
  pod 'JTAppleCalendar', :git => 'https://github.com/patchthecode/JTAppleCalendar.git', :branch => 'master'

  target 'TakeFlightTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick'
    pod 'Nimble'
  end

  target 'TakeFlightUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
