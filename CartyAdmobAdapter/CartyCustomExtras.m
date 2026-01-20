
#import "CartyCustomExtras.h"

@implementation CartyCustomExtras
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isMute = YES;
        self.bannerSize = -1;
    }
    return self;
}

- (void)setDoNotSell:(BOOL)doNotSell
{
    _doNotSell = doNotSell;
    [[CartyADSDK sharedInstance] setDoNotSell:doNotSell];
}

- (void)setUserID:(NSString *)userID
{
    if(userID)
    {
        _userID = userID;
        [CartyADSDK sharedInstance].userid = userID;
    }
}
@end
