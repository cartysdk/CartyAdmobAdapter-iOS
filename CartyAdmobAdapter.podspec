Pod::Spec.new do |spec|
  spec.name         = "CartyAdmobAdapter"
  spec.version      = "0.1.8"
  spec.summary      = "CartyAdmobAdapter"
  spec.description  = <<-DESC
             CartyAdmobAdapter for iOS. 
                   DESC
  spec.homepage     = "https://github.com/cartysdk/CartyAdmobAdapter-iOS"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "carty" => "ssp_tech@carty.io" } 
  spec.source       = { :git => "https://github.com/cartysdk/CartyAdmobAdapter-iOS.git", :tag => spec.version }
  spec.platform     = :ios, '13.0'
  spec.ios.deployment_target = '13.0'
  spec.pod_target_xcconfig = {
    'OTHER_LDFLAGS' => '-ObjC'
  }
  spec.source_files = 'CartyAdmobAdapter/*.{h,m}'
  spec.static_framework = true

  spec.dependency 'CartySDK'
  spec.dependency 'Google-Mobile-Ads-SDK'
end
