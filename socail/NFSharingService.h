//
//  NFShareManager.h
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/1.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFsharingPlatformHandler.h"
#import "NFSharingQQHandler.h"
#import "NFSharingWechatHandler.h"
#import "NFSharingWeiboHandler.h"
#import "NFSharingLocalHandler.h"

@interface NFSharingService : NSObject

+ (instancetype)sharedService;

- (NSArray *)sharingTargets;

- (BOOL)handleURL:(NSURL *)url;


- (void)startSharingSession:(NFSharingPlatformTarget *)platformTarget
                    content:(NFSharingData *)data
                   callback:(void (^)(BOOL suc , NSError *err))callback;

- (void)startSharingSessionWithTargetName:(NSString *)targetName
                                  content:(NFSharingData *)data
                                 callback:(void (^)(BOOL, NSError *))callback;

- (void)shareAppInViewController:(UIViewController *)viewController;
@end
