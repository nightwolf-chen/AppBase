//
//  NFSharingWeiboHandler.m
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/29.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import "NFSharingWeiboHandler.h"
#import "NFWeiboAuthManager.h"
#import "NFSharingService.h"
#import "NFDisplayableResource.h"
#import "NFWeiboPoster.h"

#import <WeiboSDK.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>

@interface NFSharingWeiboHandler ()<WeiboSDKDelegate>

@end

@implementation NFSharingWeiboHandler

- (void)startSession:(NFSharingData *)data
              target:(NFSharingPlatformTarget *)target
            callback:(void (^)(BOOL, NSError *))callback
{
    if([self isInstalled]){
        [[NFWeiboPoster sharedPoster] postWeibo:@"" image:data callback:callback];
    }else{
        callback(NO,[[NSError alloc] init]);
    }
}

- (NFSharingPlatform *)registerWithPlatformAppID:(NSString *)appID
                                          iOSApp:(NFSharingAPPInfo *)appInfo
                                          secret:(NSString *)secret
{
    
    NFSharingPlatform *platform = [super registerWithPlatformAppID:appID iOSApp:appInfo secret:secret];
    
#ifdef DEBUG
    [WeiboSDK enableDebugMode:YES];
#endif
    [WeiboSDK registerApp:appID];
    
    return platform;
}


- (NFSharingPlatform *)createPlatformWithAppID:(NSString *)appID iOSApp:(NFSharingAPPInfo *)appInfo secret:(NSString *)secret
{
    NFSharingPlatform *platform = [[NFSharingPlatform alloc] init];
    platform.displayname = @"微博";
    platform.name = @"weibo";
    platform.appID = appID;
    platform.secret = secret;
    
    NFSharingPlatformTarget *weibo = [[NFSharingPlatformTarget alloc] init];
    weibo.displayname = @"微博";
    weibo.name = kSharingTargetWeibo;
    
    platform.targets = @[weibo];
    
    return platform;
}

- (BOOL)handleURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

#pragma mark - WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        [[NFWeiboAuthManager sharedInstance] notifyAuthResult:response];
    }
}

- (BOOL)isInstalled
{
    return [WeiboSDK isWeiboAppInstalled];
}

@end
