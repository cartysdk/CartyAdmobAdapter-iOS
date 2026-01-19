
#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface CartyAdmobAdapter : NSObject <GADMediationAdapter>

+ (void)setGDPRStatus:(BOOL)bo;
+ (void)setDoNotSell:(BOOL)bo;
+ (void)setCOPPAStatus:(BOOL)bo;
+ (void)setLGPDStatus:(BOOL)bo;
+ (void)setUserID:(NSString *)userID;
@end

NS_ASSUME_NONNULL_END
