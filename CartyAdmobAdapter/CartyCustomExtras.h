
#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <CartySDK/CartySDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface CartyCustomExtras : NSObject<GADAdNetworkExtras>

@property (nonatomic, copy)NSDictionary *additionalParameters;
@property (nonatomic,copy)NSString *customRewardString;
//isMute default YES
@property (nonatomic,assign)BOOL isMute;
@property (nonatomic,assign)CTBannerSizeType bannerSize;
@end

NS_ASSUME_NONNULL_END
