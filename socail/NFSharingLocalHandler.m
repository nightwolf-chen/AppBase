//
//  NFSharingLocalHandler.m
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/30.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import "NFSharingLocalHandler.h"
#import "NFFavoritesImageManager.h"
#import "NFSharingService.h"

#import <MobClick.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation NFSharingLocalHandler


- (void)startSession:(NFSharingData *)data
              target:(NFSharingPlatformTarget *)target
            callback:(void (^)(BOOL, NSError *))callback
{
    if ([target.name isEqual:kSharingTargetFavorite]) {
        [MobClick event:@"favorite"];
        [[NFFavoritesImageManager sharedInstance] addFavorite:data.resouce];
        callback(YES,nil);
    }
    
    if ([target.name isEqual:kSharingTargetSaveToSystemAlbum]) {
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        [library writeImageDataToSavedPhotosAlbum:data.data
                                         metadata:nil
                                  completionBlock:^(NSURL *assetURL, NSError *error) {
                                      callback(YES,nil);
                                  }];
         
         
    }
    
}




- (NFSharingPlatform *)createPlatformWithAppID:(NSString *)appID iOSApp:(NFSharingAPPInfo *)appInfo secret:(NSString *)secret
{
    NFSharingPlatform *platform = [[NFSharingPlatform alloc] init];
    platform.displayname = @"本地";
    platform.name = @"local";
    platform.appID = appID;
    platform.secret = secret;
    
    NFSharingPlatformTarget *weibo = [[NFSharingPlatformTarget alloc] init];
    weibo.displayname = @"收藏";
    weibo.name = kSharingTargetFavorite;
    
    NFSharingPlatformTarget *save = [[NFSharingPlatformTarget alloc] init];
    save.displayname = @"保存到系统相册";
    save.name = kSharingTargetSaveToSystemAlbum;
    
    platform.targets = @[weibo,save];
    
    return platform;
}

- (BOOL)isInstalled
{
    return YES;
}

@end
