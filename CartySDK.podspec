Pod::Spec.new do |spec|
  spec.name         = "CartySDK"
  spec.version      = "0.6.0"
  spec.summary      = "CartySDK"
  spec.description  = <<-DESC
             CartySDK for iOS. 
                   DESC
  spec.homepage     = "https://github.com/cartysdk/CartySDK-iOS"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "carty" => "ssp_tech@carty.io" } 
  spec.source       = { :git => "https://github.com/cartysdk/CartySDK-iOS.git", :tag => spec.version }
  spec.platform     = :ios, '13.0'
  spec.ios.deployment_target = '13.0'
  spec.pod_target_xcconfig = {
    'OTHER_LDFLAGS' => '-ObjC'
  }
  valid_archs = ['x86_64', 'arm64']
  spec.default_subspecs = 'CartySDK'

  spec.subspec 'CartySDK' do |ss|
     ss.ios.deployment_target = '13.0'
     ss.vendored_frameworks = ['CartySDK.xcframework']
     ss.resources = ['CartySDKResources.bundle']
  end
end
