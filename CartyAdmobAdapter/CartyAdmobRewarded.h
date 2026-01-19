
#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "CartyAdmobBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface CartyAdmobRewarded : CartyAdmobBase

- (void)loadForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
