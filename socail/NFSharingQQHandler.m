//
//  NFSharingQQHandler.m
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/29.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import "NFSharingQQHandler.h"
#import "NFWXEmotionExporter.h"
#import "NFSharingService.h"
#import "NFDisplayableResource.h"

#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface NFSharingQQHandler ()<QQApiInterfaceDelegate,TencentSessionDelegate>
@property (nonatomic,strong) TencentOAuth *tencentAuth;
@end

@implementation NFSharingQQHandler

- (void)startSession:(NFSharingData *)data
              target:(NFSharingPlatformTarget *)target
            callback:(void (^)(BOOL, NSError *))callback
{
    if ([target.name isEqual:kSharingTargetQQSession]) {
        [self startQQSession:data target:target callback:callback];
        return;
    }
    
    if ([target.name isEqual:kSharingTargetQZone]) {
        [self startQZoneSession:data target:target callback:callback];
        return;
    }
    
    NSAssert(NO, @"UnKownTarget");
}

- (void)startQQSession:(NFSharingData *)data
              target:(NFSharingPlatformTarget *)target
            callback:(void (^)(BOOL, NSError *))callback
{
    NFWXEmotion *emotion = [[[NFWXEmotionExporter alloc] init] exportEmoation:data.data];
    
    QQApiImageObject* img = [QQApiImageObject objectWithData:emotion.emotionData
                                            previewImageData:emotion.thumbData
                                                       title:@""
                                                 description:@""];
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //    [self handleSendResult:sent callback:callback];
    [self handleSendResult:sent callback:callback];
    //    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
}


- (void)startQZoneSession:(NFSharingData *)data
              target:(NFSharingPlatformTarget *)target
            callback:(void (^)(BOOL, NSError *))callback
{
    NFWXEmotion *emotion = [[[NFWXEmotionExporter alloc] init] exportEmoation:data.data];
    
    QQApiURLObject *img = [QQApiURLObject objectWithURL:[NSURL URLWithString:data.resouce.url]
                                                  title:@"来自搞笑GIF大全的分享"
                                            description:@""
                                       previewImageData:emotion.thumbData
                                      targetContentType:QQApiURLTargetTypeNews];
    
    [img setCflag:kQQAPICtrlFlagQZoneShareOnStart];
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    
    [self handleSendResult:sent callback:callback];
}


- (NFSharingPlatform *)registerWithPlatformAppID:(NSString *)appID
                                          iOSApp:(NFSharingAPPInfo *)appInfo
                                          secret:(NSString *)secret
{
    
    NFSharingPlatform *platform = [super registerWithPlatformAppID:appID iOSApp:appInfo secret:secret];
    
    self.tencentAuth = [[TencentOAuth alloc] initWithAppId:appID andDelegate:self];
    
    return platform;
}


- (NFSharingPlatform *)createPlatformWithAppID:(NSString *)appID iOSApp:(NFSharingAPPInfo *)appInfo secret:(NSString *)secret
{
    NFSharingPlatform *platform = [[NFSharingPlatform alloc] init];
    platform.displayname = @"QQ";
    platform.name = @"QQ";
    platform.appID = appID;
    platform.secret = secret;
    
    NFSharingPlatformTarget *qqSession = [[NFSharingPlatformTarget alloc] init];
    qqSession.displayname = @"QQ好友";
    qqSession.name = kSharingTargetQQSession;
    
    NFSharingPlatformTarget *qZone = [[NFSharingPlatformTarget alloc] init];
    qZone.displayname = @"QQ空间";
    qZone.name = kSharingTargetQZone;
    
    platform.targets = @[qqSession,qZone];
    
    return platform;
}

- (BOOL)handleURL:(NSURL *)url
{
    return [QQApiInterface handleOpenURL:url delegate:self];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult callback:(void (^)(BOOL, NSError *))callback
{

    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
//            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                             message:@"App未注册"
//                                                            delegate:nil
//                                                   cancelButtonTitle:@"取消"
//                                                   otherButtonTitles:nil];
//            [msgbox show];

            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
//            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//            [msgbox show];

            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
//            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//            [msgbox show];

            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
//            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//            [msgbox show];

            break;
        }
        case EQQAPISENDFAILD:
        {
//            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//            [msgbox show];

            break;
        }
        default:
        {
            callback(YES,nil);
            return;
            break;
        }
    }

    callback(NO,nil);
}

- (BOOL)isInstalled
{
    return [QQApiInterface isQQInstalled];
}

@end
