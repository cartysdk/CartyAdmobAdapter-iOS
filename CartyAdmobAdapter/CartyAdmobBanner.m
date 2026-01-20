
#import "CartyAdmobBanner.h"
#import "CartyCustomExtras.h"

@interface CartyAdmobBanner()<CTBannerAdDelegate,GADMediationBannerAd>
{
    GADMediationBannerLoadCompletionHandler _loadCompletionHandler;
    id <GADMediationBannerAdEventDelegate> _adEventDelegate;
}
@property (nonatomic,strong)CTBannerAd *banner;
@end

@implementation CartyAdmobBanner

- (void)loadForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler
{
      __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
      __block GADMediationBannerLoadCompletionHandler originalCompletionHandler =
          [completionHandler copy];

      _loadCompletionHandler = ^id<GADMediationBannerAdEventDelegate>(
          _Nullable id<GADMediationBannerAd> ad, NSError *_Nullable error) {
        if (atomic_flag_test_and_set(&completionHandlerCalled)) {
          return nil;
        }

        id<GADMediationBannerAdEventDelegate> delegate = nil;
        if (originalCompletionHandler) {
          delegate = originalCompletionHandler(ad, error);
        }

        originalCompletionHandler = nil;

        return delegate;
      };
    
    
    
    NSString *parameter = adConfiguration.credentials.settings[@"parameter"];
    NSString *pid = [self getPidWithParameter:parameter];
    if(pid == nil)
    {
        NSError *error = [NSError errorWithDomain:@"CartyAdmobAdapter" code:400 userInfo:@{NSLocalizedDescriptionKey:@"not pid"}];
        _adEventDelegate = _loadCompletionHandler(nil, error);
        return;
    }
    
    self.banner = [[CTBannerAd alloc] init];
    self.banner.placementid = pid;
    self.banner.rootViewController = adConfiguration.topViewController;
    self.banner.delegate = self;
    self.banner.isMute = GADMobileAds.sharedInstance.applicationMuted;
    self.banner.isMute = GADMobileAds.sharedInstance.applicationMuted;
    if([adConfiguration.extras isKindOfClass:[CartyCustomExtras class]])
    {
        CartyCustomExtras *extras = adConfiguration.extras;
        self.banner.isMute = extras.isMute;
        if(extras.bannerSize >= 0)
        {
            self.banner.bannerSize = extras.bannerSize;
        }
        else
        {
            self.banner.bannerSize = [self getBannerSize:adConfiguration.adSize];
            CGRect rect = CGRectZero;
            rect.size = adConfiguration.adSize.size;
            self.banner.frame = rect;
        }
    }
    [self.banner loadAd];
}

- (CTBannerSizeType)getBannerSize:(GADAdSize )adSize
{
    if (adSize.size.width == 300 && adSize.size.height == 250)
    {
        return CTBannerSizeType300x250;
    }
    else if (adSize.size.width == 320 && adSize.size.height == 100)
    {
        return CTBannerSizeType320x100;
    }
    else if (adSize.size.width == 320 && adSize.size.height == 50)
    {
        return CTBannerSizeType320x50;
    }
    else if(adSize.size.height > 60)
    {
        return CTBannerSizeType320x100;
    }
    else if(adSize.size.height > 160)
    {
        return CTBannerSizeType300x250;
    }
    return CTBannerSizeType320x50;
}

#pragma mark GADMediationBannerAd implementation

- (nonnull UIView *)view
{
    return self.banner;
}

#pragma mark CTBannerAdDelegate implementation

- (void)CTBannerAdDidLoad:(nonnull CTBannerAd *)ad
{
    _adEventDelegate = _loadCompletionHandler(self, nil);
}

- (void)CTBannerAdLoadFail:(nonnull CTBannerAd *)ad withError:(nonnull NSError *)error
{
    _adEventDelegate = _loadCompletionHandler(nil, error);
}

- (void)CTBannerAdDidShow:(nonnull CTBannerAd *)ad
{
    [_adEventDelegate reportImpression];
}

- (void)CTBannerAdShowFail:(nonnull CTBannerAd *)ad withError:(nonnull NSError *)error
{
    
}

- (void)CTBannerAdDidClick:(nonnull CTBannerAd *)ad
{
    [_adEventDelegate reportClick];
}

- (void)CTBannerAdDidClose:(nonnull CTBannerAd *)ad
{
    
}

@end
