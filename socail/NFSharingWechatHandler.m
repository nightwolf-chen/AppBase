//
//  NFSharingWechatHandler.m
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/29.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import "NFSharingWechatHandler.h"
#import "NFWXEmotionExporter.h"
#import "NFSharingService.h"

#import "WXApi.h"

@interface NFSharingWechatHandler ()<WXApiDelegate>

@end

@implementation NFSharingWechatHandler

- (void)startSession:(NFSharingData *)data
              target:(NFSharingPlatformTarget *)target
            callback:(void (^)(BOOL, NSError *))callback
{
    if ([target.name isEqual:kSharingTargetWechatSession]) {
        [self startWechatSession:data callback:callback];
        return;
    }
    
    if ([target.name isEqual:kSharingTargetWechatTimeline]) {
        [self startWechatFriendsSession:data callback:callback];
        return;
    }
    
    NSAssert(NO, @"UnKownTarget");
}

- (void)startWechatSession:(NFSharingData *)data callback:(void (^)(BOOL, NSError *))callback
{
    NFWXEmotion *emotion = [[[NFWXEmotionExporter alloc] init] exportEmoation:data.data];
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    [message setThumbData:emotion.thumbData];
    
    WXEmoticonObject *imageObj = [WXEmoticonObject object];
    imageObj.emoticonData = emotion.emotionData;
    message.mediaObject = imageObj;
    
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    BOOL suc = [WXApi sendReq:req];
    callback(suc,nil);
}

- (void)startWechatFriendsSession:(NFSharingData *)data callback:(void (^)(BOOL, NSError *))callback
{
    NFWXEmotion *emotion = [[[NFWXEmotionExporter alloc] init] exportEmoation:data.data];
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    [message setThumbData:emotion.thumbData];
    
    WXImageObject *imageObj = [WXImageObject object];
    imageObj.imageData = emotion.emotionData;
    message.mediaObject = imageObj;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    BOOL suc = [WXApi sendReq:req];
    callback(suc,nil);
}

- (NFSharingPlatform *)registerWithPlatformAppID:(NSString *)appID
                                          iOSApp:(NFSharingAPPInfo *)appInfo
                                          secret:(NSString *)secret
{
    
    NFSharingPlatform *platform = [super registerWithPlatformAppID:appID iOSApp:appInfo secret:secret];
    
    [WXApi registerApp:appID withDescription:@"表情大帝"];
    
    return platform;
}


- (NFSharingPlatform *)createPlatformWithAppID:(NSString *)appID iOSApp:(NFSharingAPPInfo *)appInfo secret:(NSString *)secret
{
    NFSharingPlatform *platform = [[NFSharingPlatform alloc] init];
    platform.displayname = @"微信";
    platform.name = @"wechat";
    platform.appID = appID;
    platform.secret = secret;
    
    NFSharingPlatformTarget *wechatSession = [[NFSharingPlatformTarget alloc] init];
    wechatSession.displayname = @"微信好友";
    wechatSession.name = kSharingTargetWechatSession;
    
    NFSharingPlatformTarget *friends = [[NFSharingPlatformTarget alloc] init];
    friends.displayname = @"微信朋友圈";
    friends.name = kSharingTargetWechatTimeline;
    
    platform.targets = @[wechatSession,friends];
    
    return platform;
}

- (BOOL)handleURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)isInstalled
{
    return [WXApi isWXAppInstalled];
}

@end
