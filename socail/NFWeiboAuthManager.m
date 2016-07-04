//
//  NFWeiboAuthManager.m
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/7.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import "NFWeiboAuthManager.h"
#import "NFRefrences.h"

#import <WeiboSDK.h>

@implementation NFWeiboAuthManager

+ (instancetype)sharedInstance
{
    static id sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[self alloc] init];
    });
    
    return sInstance;
}

- (void)startAuthSession
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    request.scope = @"all";
//    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)notifyAuthResult:(id)resp
{
    WBAuthorizeResponse *response = resp;
    [self setToken:response.accessToken];
    [NFRefrences sharedInstance].weiboAccessTokenExpireDate = response.expirationDate;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNFWeiboAuthManagerDidUpdateTokenNotification
                                                        object:nil];
}

- (NSString *)token
{
    return [NFRefrences sharedInstance].weiboAccessToken;
}

- (void)setToken:(NSString *)token
{
    [NFRefrences sharedInstance].weiboAccessToken = token;
}

- (BOOL)expired
{
    return YES;
    
    NSDate *expireDate = [NFRefrences sharedInstance].weiboAccessTokenExpireDate;
    if (!expireDate) {
        NSDate *now = [NSDate date];
        if([now timeIntervalSinceDate:expireDate] > 0){
            return YES;
        }
    }
    
    return NO;
}


@end
