
#import <Foundation/Foundation.h>
#import <CartySDK/CartySDK.h>
#include <stdatomic.h>

NS_ASSUME_NONNULL_BEGIN

@interface CartyAdmobBase : NSObject

- (nullable NSString *)getPidWithParameter:(nullable NSString *)parameter;
@end

NS_ASSUME_NONNULL_END
