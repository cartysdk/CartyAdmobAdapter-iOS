
#import "CartyAdmobNative.h"
#import "CartyCustomExtras.h"

@interface CartyAdmobNative()<GADMediationNativeAd,CTNativeAdDelegate>
{
    GADMediationNativeLoadCompletionHandler _loadCompletionHandler;
    id<GADMediationNativeAdEventDelegate> _adEventDelegate;
}
@property (nonatomic,strong)CTNativeAd *nativeAd;
@property (nonatomic,strong)GADNativeAdImage *iconImage;
@end

@implementation CartyAdmobNative

- (void)loadForAdConfiguration:(GADMediationNativeAdConfiguration *)adConfiguration completionHandler:(GADMediationNativeLoadCompletionHandler)completionHandler
{
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationNativeLoadCompletionHandler originalCompletionHandler =
        [completionHandler copy];

        _loadCompletionHandler = ^id<GADMediationNativeAdEventDelegate>(
          _Nullable id<GADMediationNativeAd> ad, NSError *_Nullable error) {
        if (atomic_flag_test_and_set(&completionHandlerCalled)) {
          return nil;
        }

        id<GADMediationNativeAdEventDelegate> delegate = nil;
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
    self.nativeAd = [[CTNativeAd alloc] init];
    self.nativeAd.placementid = pid;
    self.nativeAd.delegate = self;
    self.nativeAd.isMute = GADMobileAds.sharedInstance.applicationMuted;
    if([adConfiguration.extras isKindOfClass:[CartyCustomExtras class]])
    {
        CartyCustomExtras *extras = adConfiguration.extras;
        self.nativeAd.isMute = extras.isMute;
    }
    [self.nativeAd loadAd];
}

- (nullable NSString *)headline
{
  return self.nativeAd.title;
}

- (nullable NSString *)body
{
    return self.nativeAd.desc;
}

- (nullable GADNativeAdImage *)icon
{
  return self.iconImage;
}

- (nullable NSString *)callToAction
{
  return self.nativeAd.ctaText;
}

- (nullable UIView *)adChoicesView
{
  return self.nativeAd.adChoiceView;
}

- (nullable UIView *)mediaView
{
  return self.nativeAd.mediaView;
}

- (BOOL)hasVideoContent
{
    return YES;
}

- (nullable NSString *)store
{
  return nil;
}

- (nullable NSString *)price
{
  return nil;
}

- (nullable NSString *)advertiser
{
  return nil;
}

- (nullable NSDecimalNumber *)starRating
{
  return nil;
}

- (nullable NSArray<GADNativeAdImage *> *)images
{
  return nil;
}

- (nullable NSDictionary<NSString *, id> *)extraAssets
{
  return nil;
}

- (BOOL)handlesUserClicks
{
  return YES;
}

- (BOOL)handlesUserImpressions
{
  return YES;
}

- (void)didRenderInView:(nonnull UIView *)view
       clickableAssetViews:
           (nonnull NSDictionary<GADNativeAssetIdentifier, UIView *> *)clickableAssetViews
    nonclickableAssetViews:
        (nonnull NSDictionary<GADNativeAssetIdentifier, UIView *> *)nonclickableAssetViews
            viewController:(nonnull UIViewController *)viewController
{
    [self.nativeAd registerContainer:view withClickableViews:clickableAssetViews.allValues];
}

- (void)CTNativeAdDidLoad:(nonnull CTNativeAd *)ad
{
    if(self.nativeAd.iconImageURL != nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.nativeAd.iconImageURL]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.iconImage = [[GADNativeAdImage alloc] initWithImage:[UIImage imageWithData:data]];
                self->_adEventDelegate = self->_loadCompletionHandler(self, nil);
            });
        });
    }
    else
    {
        _adEventDelegate = _loadCompletionHandler(self, nil);
    }
}

- (void)CTNativeAdLoadFail:(nonnull CTNativeAd *)ad withError:(nonnull NSError *)error
{
    _adEventDelegate = _loadCompletionHandler(nil, error);
}

- (void)CTNativeAdDidShow:(nonnull CTNativeAd *)ad
{
    [_adEventDelegate reportImpression];
}

- (void)CTNativeAdShowFail:(nonnull CTNativeAd *)ad withError:(nonnull NSError *)error
{
    
}

- (void)CTNativeAdDidClick:(nonnull CTNativeAd *)ad
{
    [_adEventDelegate reportClick];
}

@end
