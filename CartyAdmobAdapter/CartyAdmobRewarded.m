
#import "CartyAdmobRewarded.h"
#import "CartyCustomExtras.h"

@interface CartyAdmobRewarded()<CTRewardedVideoAdDelegate,GADMediationRewardedAd>
{
    GADMediationRewardedLoadCompletionHandler _loadCompletionHandler;
    id <GADMediationRewardedAdEventDelegate> _adEventDelegate;
}
@property (nonatomic,strong)CTRewardedVideoAd *rewardedVideoAd;
@end

@implementation CartyAdmobRewarded

- (void)loadForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler
{
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationRewardedLoadCompletionHandler originalCompletionHandler =
      [completionHandler copy];

    _loadCompletionHandler = ^id<GADMediationRewardedAdEventDelegate>(
      _Nullable id<GADMediationRewardedAd> ad, NSError *_Nullable error) {
          
    if (atomic_flag_test_and_set(&completionHandlerCalled)) {
      return nil;
    }

    id<GADMediationRewardedAdEventDelegate> delegate = nil;
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
    
    self.rewardedVideoAd = [[CTRewardedVideoAd alloc] init];
    self.rewardedVideoAd.placementid = pid;
    self.rewardedVideoAd.delegate = self;
    self.rewardedVideoAd.isMute = GADMobileAds.sharedInstance.applicationMuted;
    if([adConfiguration.extras isKindOfClass:[CartyCustomExtras class]])
    {
        CartyCustomExtras *extras = adConfiguration.extras;
        self.rewardedVideoAd.customRewardString = extras.customRewardString;
        self.rewardedVideoAd.isMute = extras.isMute;
    }
    else
    {
        self.rewardedVideoAd.isMute = GADMobileAds.sharedInstance.applicationMuted;
    }
    [self.rewardedVideoAd loadAd];
}

- (void)presentFromViewController:(nonnull UIViewController *)viewController
{
    if([self.rewardedVideoAd isReady])
    {
        [self.rewardedVideoAd showAd:viewController];
    }
    else
    {
        NSError *error = [NSError errorWithDomain:@"CartyAdmobAdapter" code:403 userInfo:@{NSLocalizedDescriptionKey:@"not ad to show"}];
        _adEventDelegate = _loadCompletionHandler(nil, error);
    }
}

- (void)CTRewardedVideoAdDidLoad:(nonnull CTRewardedVideoAd *)ad
{
    _adEventDelegate = _loadCompletionHandler(self, nil);
}

- (void)CTRewardedVideoAdLoadFail:(nonnull CTRewardedVideoAd *)ad withError:(nonnull NSError *)error
{
    _adEventDelegate = _loadCompletionHandler(nil, error);
}

- (void)CTRewardedVideoAdDidShow:(nonnull CTRewardedVideoAd *)ad
{
    [_adEventDelegate willPresentFullScreenView];
    [_adEventDelegate didStartVideo];
    [_adEventDelegate reportImpression];
}

- (void)CTRewardedVideoAdShowFail:(nonnull CTRewardedVideoAd *)ad withError:(nonnull NSError *)error
{
    [_adEventDelegate didFailToPresentWithError:error];
}

- (void)CTRewardedVideoAdDidClick:(nonnull CTRewardedVideoAd *)ad
{
    [_adEventDelegate reportClick];
}

- (void)CTRewardedVideoAdDidDismiss:(nonnull CTRewardedVideoAd *)ad
{
    [_adEventDelegate willDismissFullScreenView];
    [_adEventDelegate didEndVideo];
    [_adEventDelegate didDismissFullScreenView];
}

- (void)CTRewardedVideoAdDidEarnReward:(nonnull CTRewardedVideoAd *)ad rewardInfo:(nonnull NSDictionary *)rewardInfo
{
    [_adEventDelegate didRewardUser];
}
@end
