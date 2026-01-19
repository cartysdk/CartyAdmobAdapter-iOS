
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
@end
