
#import "CartyAdmobInterstitial.h"
#import "CartyCustomExtras.h"

@interface CartyAdmobInterstitial() <GADMediationInterstitialAd,CTInterstitialAdDelegate>
{
    GADMediationInterstitialLoadCompletionHandler _loadCompletionHandler;
    id<GADMediationInterstitialAdEventDelegate> _adEventDelegate;
}
@property (nonatomic,strong)CTInterstitialAd *interstitialAd;
@end

@implementation CartyAdmobInterstitial

- (void)loadForAdConfiguration:(GADMediationInterstitialAdConfiguration *)adConfiguration completionHandler:(GADMediationInterstitialLoadCompletionHandler)completionHandler
{
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationInterstitialLoadCompletionHandler originalCompletionHandler =
      [completionHandler copy];

    _loadCompletionHandler = ^id<GADMediationInterstitialAdEventDelegate>(
      _Nullable id<GADMediationInterstitialAd> ad, NSError *_Nullable error){
        if (atomic_flag_test_and_set(&completionHandlerCalled)) {
          return nil;
        }

        id<GADMediationInterstitialAdEventDelegate> delegate = nil;
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
    
    self.interstitialAd = [[CTInterstitialAd alloc] init];
    self.interstitialAd.placementid = pid;
    self.interstitialAd.delegate = self;
    self.interstitialAd.isMute = GADMobileAds.sharedInstance.applicationMuted;
    if([adConfiguration.extras isKindOfClass:[CartyCustomExtras class]])
    {
        CartyCustomExtras *extras = adConfiguration.extras;
        self.interstitialAd.isMute = extras.isMute;
    }
    [self.interstitialAd loadAd];
}

- (void)presentFromViewController:(nonnull UIViewController *)viewController
{
    if([self.interstitialAd isReady])
    {
        [self.interstitialAd showAd:viewController];
    }
    else
    {
        NSError *error = [NSError errorWithDomain:@"CartyAdmobAdapter" code:403 userInfo:@{NSLocalizedDescriptionKey:@"not ad to show"}];
        _adEventDelegate = _loadCompletionHandler(nil, error);
    }
}

- (void)CTInterstitialAdDidLoad:(nonnull CTInterstitialAd *)ad
{
    _adEventDelegate = _loadCompletionHandler(self, nil);
}

- (void)CTInterstitialAdLoadFail:(nonnull CTInterstitialAd *)ad withError:(nonnull NSError *)error
{
    _adEventDelegate = _loadCompletionHandler(nil, error);
}

- (void)CTInterstitialAdDidShow:(nonnull CTInterstitialAd *)ad
{
    [_adEventDelegate willPresentFullScreenView];
    [_adEventDelegate reportImpression];
}

- (void)CTInterstitialAdShowFail:(nonnull CTInterstitialAd *)ad withError:(nonnull NSError *)error
{
    [_adEventDelegate didFailToPresentWithError:error];
}

- (void)CTInterstitialAdDidClick:(nonnull CTInterstitialAd *)ad
{
    [_adEventDelegate reportClick];
}

- (void)CTInterstitialAdDidDismiss:(nonnull CTInterstitialAd *)ad
{
    [_adEventDelegate willDismissFullScreenView];
    [_adEventDelegate didDismissFullScreenView];
}

@end
