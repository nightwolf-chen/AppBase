//
//  NFShareManager.m
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/1.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//
#import <AFNetworking.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
//#import <UMengSocial/UMSocialQQHandler.h>
//#import <UMengSocial/UMSocialWechatHandler.h>
//#import <UMengSocial/UMSocialSinaSSOHandler.h>

#import "NFSharingService.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "NFSharingDefines.h"
#import "NFWeiboAuthManager.h"
#import "NFDisplayableResource.h"
#import "NFWXEmotionExporter.h"

#define kAppDownloadURL @"https://itunes.apple.com/cn/app/biao-qing-digif/id1089442179?l=zh&ls=1&mt=8"


@interface NFSharingService ()
@property (nonatomic,strong) NSArray *sharingHandlers;
@property (nonatomic,strong) NSArray *sharingTargets;
@end

@implementation NFSharingService

+ (instancetype)sharedService
{
    static id sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[[self class] alloc] init];
    });
    
    return sInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _sharingHandlers = [NSArray array];
        [self setupSharingPlatforms];
    }
    
    return self;
}

- (NSArray *)sharingTargets
{
    if (!_sharingTargets) {
        NSMutableArray *tmp = [NSMutableArray array];
        for(NFsharingPlatformHandler *handler in _sharingHandlers){
            [tmp addObjectsFromArray:handler.currentPlatform.targets];
        }
        
        self.sharingTargets = tmp;
    }
    
    return _sharingTargets;
}

- (void)registerHandler:(Class)handlerClass appID:(NSString *)appID appSecret:(NSString *)secret
{
    NFSharingAPPInfo *appInfo = [[NFSharingAPPInfo alloc] init];
    appInfo.appName = @"表情帝GIF";
    appInfo.appDesc = @"表情帝GIF";
    
    
    BOOL found = NO;
    for(NFsharingPlatformHandler *handler in _sharingHandlers){
        if ([handler isMemberOfClass:handlerClass]) {
            found = YES;
        }
        
    }
    
    if (found) {
        return;
    }
    
    NFsharingPlatformHandler *handler = [[handlerClass alloc] init];
    [handler registerWithPlatformAppID:appID
                                iOSApp:appInfo
                                secret:secret];
 
    
    NSMutableArray *tmp = [_sharingHandlers mutableCopy];
    [tmp addObject:handler];
    
    self.sharingHandlers = tmp;
}

- (void)setupSharingPlatforms
{
    NSArray *classes = @[[NFSharingWechatHandler class],[NFSharingQQHandler class],[NFSharingWeiboHandler class],[NFSharingLocalHandler class]];
    NSArray *appKeys = @[kWechatAppKey,kQQAppID,kWeiboAppKey,@"0"];
    NSArray *appSecrets = @[kWechatAppSecret,kQQAppSecret,kWeiboAppSecret,@"0"];
    
    for(int i = 0 ; i < classes.count ; i++){
        Class handlerClass = classes[i];
        NSString *appID = appKeys[i];
        NSString *appSecret = appSecrets[i];
        [self registerHandler:handlerClass appID:appID appSecret:appSecret];
    }
    
//    [self setUmengShare];
}

- (void)startSharingSession:(NFSharingPlatformTarget *)target
                    content:(NFSharingData *)data
                   callback:(void (^)(BOOL, NSError *))callback
{
    [target.platform.handler startSession:data
                                   target:target
                                 callback:callback];
}

- (void)startSharingSessionWithTargetName:(NSString *)targetName
                                  content:(NFSharingData *)data
                                 callback:(void (^)(BOOL, NSError *))callback
{
    for(NFSharingPlatformTarget *target in self.sharingTargets){
        if ([target.name isEqual:targetName]) {
            [target.platform.handler startSession:data target:target callback:callback];
            return;
        }
    }
    
    NSAssert(NO, @"wrong name!");
}

- (BOOL)handleURL:(NSURL *)url
{
    BOOL f = NO;
    for(NFsharingPlatformHandler *handler in _sharingHandlers){
        f = [handler handleURL:url];
    }
    
    return f;
}


//- (void)setUmengShare
//{
//    [UMSocialData setAppKey:kUmengAPPID];
//    
//    [UMSocialConfig hiddenNotInstallPlatforms:nil];
//    
//    [UMSocialQQHandler setQQWithAppId:kQQAppID
//                               appKey:kQQAppSecret
//                                  url:kAppDownloadURL];
//    
//    [UMSocialWechatHandler setWXAppId:kWechatAppKey
//                            appSecret:kWechatAppSecret
//                                  url:kAppDownloadURL];
//    
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kWeiboAppKey
//                                              secret:kWeiboAppSecret
//                                         RedirectURL:kAppDownloadURL];
//}

//- (void)shareAppInViewController:(UIViewController *)viewController
//{
//    [UMSocialSnsService presentSnsIconSheetView:viewController
//                                         appKey:kUmengAPPID
//                                      shareText:@"给你推荐一款iOS表情神器表情帝GIF"
//                                     shareImage: [UIImage imageNamed:@"AppIcon60x60"]
//                                shareToSnsNames:@[UMShareToWechatSession,
//                                                  UMShareToWechatTimeline,
//                                                  UMShareToQQ,
//                                                  UMShareToQzone,
//                                                  UMShareToSina]
//                                       delegate:self];
//}


@end





@implementation NFSharingData


@end