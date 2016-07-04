//
//  NFWeiboPoster.h
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/7.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "NFSharingDefines.h"

@class NFSharingData;

@interface NFWeiboPostTask : NSObject

@property (nonatomic,copy) NSString *text;
@property (nonatomic,strong) NFSharingData *sharingData;
@property (nonatomic,strong) void (^callback)(BOOL , id);

@end

@class NFSharingData;

@interface NFWeiboPoster : NSObject

+ (instancetype)sharedPoster;

- (void)postWeibo:(NSString *)text
            image:(NFSharingData *)sharingData
         callback:(void (^)(BOOL,id resp))callback;

@end
