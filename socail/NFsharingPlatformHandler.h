//
//  NFsharingPlatformHandler.h
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/29.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NFsharingPlatformHandler;
@class NFDisplayableResource;

/**
 *
 */
@interface NFSharingData : NSObject
@property (nonatomic,strong) NFDisplayableResource *resouce;
@property (nonatomic,strong) NSData *data;
@property (nonatomic,strong) NSData *imagePreview;
//分享内容的类型
@property (nonatomic,strong) NSString *contentType;
@end


/**
 *
 */
@interface NFSharingAPPInfo : NSObject
@property (nonatomic,copy) NSString *appName;
@property (nonatomic,copy) NSString *appDesc;
@end


/**
 *
 */
@interface NFSharingPlatform : NSObject
@property (nonatomic,copy) NSString *appID;
@property (nonatomic,copy) NSString *secret;
@property (nonatomic,copy) NSString *displayname;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) NSArray *targets;
@property (nonatomic,assign) Class handlerClass;

@property (nonatomic,weak) NFsharingPlatformHandler *handler;
@end


/**
 *
 */
@interface NFSharingPlatformTarget : NSObject
@property (nonatomic,strong) NSString *displayname;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,weak) NFSharingPlatform *platform;
@end



/**
 *
 */
@interface NFsharingPlatformHandler : NSObject
{
    NFSharingPlatform *_platform;
}

- (BOOL)isInstalled;

- (void)startSession:(NFSharingData *)data
              target:(NFSharingPlatformTarget *)target
            callback:(void (^)(BOOL suc , NSError *err))callback;

- (NFSharingPlatform *)currentPlatform;

- (NFSharingPlatform *)registerWithPlatformAppID:(NSString *)appID
                                          iOSApp:(NFSharingAPPInfo *)appInfo
                                          secret:(NSString *)secret __attribute__((objc_requires_super));

- (NFSharingPlatform *)createPlatformWithAppID:(NSString *)appID
                                        iOSApp:(NFSharingAPPInfo *)appInfo
                                        secret:(NSString *)secret;


- (BOOL)handleURL:(NSURL *)url;

@end
