//
//  NFWeiboAuthManager.h
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/7.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNFWeiboAuthManagerDidUpdateTokenNotification @"NFWeiboAuthManagerDidUpdateTokenNotification"

@interface NFWeiboAuthManager : NSObject

+ (instancetype)sharedInstance;

- (NSString *)token;
- (void)setToken:(NSString *)token;

- (BOOL)expired;

- (void)startAuthSession;

- (void)notifyAuthResult:(id)resp;

@end
