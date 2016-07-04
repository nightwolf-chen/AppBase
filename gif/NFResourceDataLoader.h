//
//  NFResourceDataLoader.h
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/1.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NFDisplayableResource;

@interface NFResourceDataLoader : NSObject

+ (instancetype)loader;

- (void)load:(NFDisplayableResource *)resource
    callback:(void (^)(BOOL, NSData * , NSError *))callback;

@end
