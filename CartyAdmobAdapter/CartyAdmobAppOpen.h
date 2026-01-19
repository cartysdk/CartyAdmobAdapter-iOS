
#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "CartyAdmobBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface CartyAdmobAppOpen : CartyAdmobBase

- (void)loadForAdConfiguration:(GADMediationAppOpenAdConfiguration *)adConfiguration completionHandler:(GADMediationAppOpenLoadCompletionHandler)completionHandler;
@end

NS_ASSUME_NONNULL_END
