
#import "CartyAdmobAdapter.h"
#import <CartySDK/CartySDK.h>
#import "CartyAdmobBanner.h"
#import "CartyAdmobNative.h"
#import "CartyAdmobRewarded.h"
#import "CartyAdmobInterstitial.h"
#import "CartyAdmobAppOpen.h"
#import "CartyCustomExtras.h"

@interface CartyAdmobAdapter()

@property (nonatomic,strong)CartyAdmobBanner *banner;
@property (nonatomic,strong)CartyAdmobNative *native;
@property (nonatomic,strong)CartyAdmobRewarded *rewarded;
@property (nonatomic,strong)CartyAdmobInterstitial *interstitial;
@property (nonatomic,strong)CartyAdmobAppOpen *appOpen;
@end

@implementation CartyAdmobAdapter 

+ (GADVersionNumber)adSDKVersion
{
    NSString *sdkVersion = [CartyADSDK sdkVersion];
    NSArray *versionComponents = [sdkVersion componentsSeparatedByString:@"."];
    GADVersionNumber version = {0};
      if (versionComponents.count >= 3) {
        version.majorVersion = [versionComponents[0] integerValue];
        version.minorVersion = [versionComponents[1] integerValue];
        version.patchVersion = [versionComponents[2] integerValue];
      }
      return version;
}

+ (GADVersionNumber)adapterVersion
{
    GADVersionNumber version = {1,0,0};
    return version;
}

+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass
{
    return [CartyCustomExtras class];
}

+ (void)setUserID:(NSString *)userID
{
    [CartyADSDK sharedInstance].userid = userID;
}

+ (void)setGDPRStatus:(BOOL)bo
{
    [[CartyADSDK sharedInstance] setGDPRStatus:bo];
}

+ (void)setDoNotSell:(BOOL)bo
{
    [[CartyADSDK sharedInstance] setDoNotSell:bo];
}

+ (void)setCOPPAStatus:(BOOL)bo
{
    [[CartyADSDK sharedInstance] setCOPPAStatus:bo];
}

+ (void)setLGPDStatus:(BOOL)bo
{
    [[CartyADSDK sharedInstance] setLGPDStatus:bo];
}

+ (void)setUpWithConfiguration:(GADMediationServerConfiguration *)configuration completionHandler:(GADMediationAdapterSetUpCompletionBlock)completionHandler
{
    NSString *appid = nil;
    NSError *error = nil;
    if(configuration.credentials != nil && configuration.credentials.firstObject)
    {
        NSString *parameter = configuration.credentials.firstObject.settings[@"parameter"];
        if(parameter)
        {
            NSDictionary *parameterDic = [NSJSONSerialization JSONObjectWithData:[parameter dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
            if(parameterDic)
            {
                appid = parameterDic[@"appid"];
            }
            if(appid == nil)
            {
                error = [NSError errorWithDomain:@"CartyAdmobAdapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"not appid"}];
            }
        }
    }
    if(error)
    {
        completionHandler(error);
        return;
    }
    NSNumber *tagForChildDirectedTreatment =
          GADMobileAds.sharedInstance.requestConfiguration.tagForChildDirectedTreatment;
    NSNumber *tagForUnderAgeOfConsent =
          GADMobileAds.sharedInstance.requestConfiguration.tagForUnderAgeOfConsent;
    if ([tagForChildDirectedTreatment isEqual:@YES] || [tagForUnderAgeOfConsent isEqual:@YES])
    {
        [[CartyADSDK sharedInstance] setCOPPAStatus:YES];
    }
    else if ([tagForChildDirectedTreatment isEqual:@NO] || [tagForUnderAgeOfConsent isEqual:@NO])
    {
        [[CartyADSDK sharedInstance] setCOPPAStatus:NO];
    }
    [CartyADSDK sharedInstance].mediation = @"Admob";
    [[CartyADSDK sharedInstance] start:appid completion:^{
        completionHandler(nil);
    }];
}

- (void)loadBannerForAdConfiguration:
            (GADMediationBannerAdConfiguration *)adConfiguration
                   completionHandler:(GADMediationBannerLoadCompletionHandler)
                                completionHandler
{
    self.banner = [[CartyAdmobBanner alloc] init];
    [self.banner loadForAdConfiguration:adConfiguration completionHandler:completionHandler];
}

- (void)loadInterstitialForAdConfiguration:
            (nonnull GADMediationInterstitialAdConfiguration *)adConfiguration
                         completionHandler:(nonnull GADMediationInterstitialLoadCompletionHandler)
                                               completionHandler
{
    self.interstitial = [[CartyAdmobInterstitial alloc] init];
    [self.interstitial loadForAdConfiguration:adConfiguration completionHandler:completionHandler];
}

- (void)loadNativeAdForAdConfiguration:(nonnull GADMediationNativeAdConfiguration *)adConfiguration
                     completionHandler:
                         (nonnull GADMediationNativeLoadCompletionHandler)completionHandler
{
    self.native = [[CartyAdmobNative alloc] init];
    [self.native loadForAdConfiguration:adConfiguration completionHandler:completionHandler];
}

- (void)loadRewardedAdForAdConfiguration:
            (nonnull GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:
                           (nonnull GADMediationRewardedLoadCompletionHandler)completionHandler
{
    self.rewarded = [[CartyAdmobRewarded alloc] init];
    [self.rewarded loadForAdConfiguration:adConfiguration completionHandler:completionHandler];
}

- (void)loadAppOpenAdForAdConfiguration:
            (nonnull GADMediationAppOpenAdConfiguration *)adConfiguration
                      completionHandler:
                          (nonnull GADMediationAppOpenLoadCompletionHandler)completionHandler
{
    self.appOpen = [[CartyAdmobAppOpen alloc] init];
    [self.appOpen loadForAdConfiguration:adConfiguration completionHandler:completionHandler];
}
@end



  

  ;
