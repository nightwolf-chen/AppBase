//
//  NFsharingPlatformHandler.m
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/29.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import "NFsharingPlatformHandler.h"
#import "FMMacros.h"

@implementation NFsharingPlatformHandler

- (void)startSession:(NFSharingData *)data target:(NFSharingPlatformTarget *)target callback:(void (^)(BOOL, NSError *))callback
{
    AbstractMethodAssert();
}

- (NFSharingPlatform *)registerWithPlatformAppID:(NSString *)appID
                                          iOSApp:(NFSharingAPPInfo *)appInfo
                                          secret:(NSString *)secret
{
    _platform = [self createPlatformWithAppID:appID iOSApp:appInfo secret:secret];
    _platform.handlerClass = self.class;
    _platform.handler = self;
    
    return _platform;
}

- (BOOL)isInstalled
{
    return NO;
}

- (BOOL)handleURL:(NSURL *)url
{
    return NO;
}

- (NFSharingPlatform *)createPlatformWithAppID:(NSString *)appID iOSApp:(NFSharingAPPInfo *)appInfo secret:(NSString *)secret
{
    AbstractMethodAssert();
    return nil;
}

- (NFSharingPlatform *)currentPlatform
{
    return _platform;
}


@end


/**
 *  NFSharingPlatform
 */
@implementation NFSharingPlatform
- (void)setTargets:(NSArray *)targets
{
    _targets  = targets;
    
    for (NFSharingPlatformTarget *target in _targets) {
        target.platform = self;
    }
}
@end

/**
 *  NFSharingAppInfo
 */
@implementation NFSharingAPPInfo
@end



/**
 *  NFSharingPlatformTarget
 */
@implementation NFSharingPlatformTarget

@end
