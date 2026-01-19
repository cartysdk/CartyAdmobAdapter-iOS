
#import "CartyAdmobBase.h"

@implementation CartyAdmobBase

- (nullable NSString *)getPidWithParameter:(nullable NSString *)parameter
{
    if(parameter)
    {
        NSDictionary *parameterDic = [NSJSONSerialization JSONObjectWithData:[parameter dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if(parameterDic)
        {
            return parameterDic[@"pid"];
        }
        
    }
    return nil;
}

@end
