
#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "CartyAdmobBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface CartyAdmobNative : CartyAdmobBase

- (void)loadForAdConfiguration:(GADMediationNativeAdConfiguration *)adConfiguration completionHandler:(GADMediationNativeLoadCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
