
#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "CartyAdmobBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface CartyAdmobInterstitial : CartyAdmobBase

- (void)loadForAdConfiguration:(GADMediationInterstitialAdConfiguration *)adConfiguration completionHandler:(GADMediationInterstitialLoadCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
