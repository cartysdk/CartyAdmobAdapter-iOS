
#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "CartyAdmobBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface CartyAdmobBanner : CartyAdmobBase

- (void)loadForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler;
@end

NS_ASSUME_NONNULL_END
