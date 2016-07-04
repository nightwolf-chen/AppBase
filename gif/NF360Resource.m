//
//  NF360Resource.m
//  NFGifFunny
//
//  Created by ChenJidong on 16/5/12.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import "NF360Resource.h"
#import "FMMacros.h"

#import <Mantle.h>

@implementation NF360Resource

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             SelectorString(desc): @"title",
             SelectorString(fileSize): @"imgsize",
             SelectorString(height): @"height",
             SelectorString(width): @"width",
             SelectorString(resourceId): @"id",
             SelectorString(imageType): @"imgtype",
             SelectorString(name): @"title",
             SelectorString(qiniuUrl): @"img",
             SelectorString(url): @"img"
             };
}

+ (NSValueTransformer *)heightJSONTransformer{
    return [MTLJSONAdapter transformerForModelPropertiesOfClass:[NSNumber class]];
}

+ (NSValueTransformer *)widthJSONTransformer{
    return [MTLJSONAdapter transformerForModelPropertiesOfClass:[NSNumber class]];
}

- (NSString *)name
{
    NSString *tmp = [super.name stringByReplacingOccurrencesOfString:@"<em>" withString:@" "];
    tmp = [tmp stringByReplacingOccurrencesOfString:@"</em>" withString:@" "];
    
    return tmp;
}

- (NSString *)desc
{
    NSString *tmp = [super.desc stringByReplacingOccurrencesOfString:@"<em>" withString:@" "];
    tmp = [tmp stringByReplacingOccurrencesOfString:@"</em>" withString:@" "];
    
    return tmp;
}


@end
