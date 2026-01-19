
#import "CartyAdmobAppOpen.h"
#import "CartyCustomExtras.h"

@interface CartyAdmobAppOpen()<CTAppOpenAdDelegate,GADMediationAppOpenAd>
{
    GADMediationAppOpenLoadCompletionHandler _loadCompletionHandler;
    id<GADMediationAppOpenAdEventDelegate> _adEventDelegate;
}
@property (nonatomic,strong)CTAppOpenAd *opanAd;
@end

@implementation CartyAdmobAppOpen

- (void)loadForAdConfiguration:(GADMediationAppOpenAdConfiguration *)adConfiguration completionHandler:(GADMediationAppOpenLoadCompletionHandler)completionHandler
{
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationAppOpenLoadCompletionHandler originalCompletionHandler =
      [completionHandler copy];

    _loadCompletionHandler = ^id<GADMediationAppOpenAdEventDelegate>(
    _Nullable id<GADMediationAppOpenAd> ad, NSError *_Nullable error) {
    if (atomic_flag_test_and_set(&completionHandlerCalled)) {
      return nil;
    }

    id<GADMediationAppOpenAdEventDelegate> delegate = nil;
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
    
    self.opanAd = [[CTAppOpenAd alloc] init];
    self.opanAd.placementid = pid;
    self.opanAd.delegate = self;
    self.opanAd.isMute = GADMobileAds.sharedInstance.applicationMuted;
    if([adConfiguration.extras isKindOfClass:[CartyCustomExtras class]])
    {
        CartyCustomExtras *extras = adConfiguration.extras;
        self.opanAd.isMute = extras.isMute;
    }
    [self.opanAd loadAd];
}

- (void)presentFromViewController:(nonnull UIViewController *)viewController
{
    if([self.opanAd isReady])
    {
        [self.opanAd showAd:viewController];
    }
    else
    {
        NSError *error = [NSError errorWithDomain:@"CartyAdmobAdapter" code:403 userInfo:@{NSLocalizedDescriptionKey:@"not ad to show"}];
        _adEventDelegate = _loadCompletionHandler(nil, error);
    }
}

- (void)CTOpenAdDidLoad:(nonnull CTAppOpenAd *)ad
{
    _adEventDelegate = _loadCompletionHandler(self, nil);
}

- (void)CTOpenAdLoadFail:(nonnull CTAppOpenAd *)ad withError:(nonnull NSError *)error
{
    _adEventDelegate = _loadCompletionHandler(nil, error);
}

- (void)CTOpenAdDidShow:(nonnull CTAppOpenAd *)ad
{ 
    [_adEventDelegate willPresentFullScreenView];
    [_adEventDelegate reportImpression];
}

- (void)CTOpenAdShowFail:(nonnull CTAppOpenAd *)ad withError:(nonnull NSError *)error
{
    [_adEventDelegate didFailToPresentWithError:error];
}

- (void)CTOpenAdDidClick:(nonnull CTAppOpenAd *)ad
{
    [_adEventDelegate reportClick];
}

- (void)CTOpenAdDidDismiss:(nonnull CTAppOpenAd *)ad
{
    [_adEventDelegate willDismissFullScreenView];
    [_adEventDelegate didDismissFullScreenView];
}

@end
