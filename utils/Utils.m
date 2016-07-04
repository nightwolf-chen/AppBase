//
//  Utils.m
//  BeautifulGirls
//
//  Created by ChenJidong on 16/3/3.
//  Copyright © 2016年 Nirvawolf. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>

void dispatch_on_main(void (^block)(void))
{
    dispatch_async(dispatch_get_main_queue(), block);
}

@implementation Utils

+ (void)notificationMainThreadPost:(NSString *)name userInfo:(NSDictionary *)userInfo
{
    dispatch_on_main(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                            object:nil
                                                          userInfo:userInfo];
    });
}

+ (NSString *)sha1:(NSString *)source
{
    const char *cstr = [source cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:source.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSString *)sortCharacters:(NSString *)source
{
    NSUInteger length = [source length];
    unichar *chars = (unichar *)malloc(sizeof(unichar) * length);
    
    // extract
    [source getCharacters:chars range:NSMakeRange(0, length)];
    
    // sort (for western alphabets only)
    qsort_b(chars, length, sizeof(unichar), ^(const void *l, const void *r) {
        unichar left = *(unichar *)l;
        unichar right = *(unichar *)r;
        return (int)(left - right);
    });
    
    // recreate
    NSString *sorted = [NSString stringWithCharacters:chars length:length];
    
    // clean-up
    free(chars);
    
    return sorted;
}

+ (NSString *)combineStrs:(NSArray *)strs
{
    NSString *str = @"";
    BOOL first = YES;
    for(NSString *tmp in strs){
        if (first) {
            first = NO;
        }else{
            str = [str stringByAppendingString:@","];
        }
        str = [str stringByAppendingString:tmp];
    }
    
    return str;
}

@end
