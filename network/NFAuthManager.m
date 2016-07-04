//
//  NFAuthManager.m
//  BeautifulGirls
//
//  Created by ChenJidong on 16/3/8.
//  Copyright © 2016年 Nirvawolf. All rights reserved.
//

#import "NFAuthManager.h"
#import "Utils.h"
#import "NSString+Random.h"
#import "NFAppNetInterface.h"
#import "NFRefrences.h"

#import <AFNetworking/AFNetworking.h>

#define kPublicKey @"pentaq"

@interface NFAuthManager ()

@property (nonatomic,copy) NSString *signature;
@property (nonatomic,copy) NSString *seed;

@end

@implementation NFAuthManager

+ (instancetype)sharedInstance
{
    static id sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[[self class] alloc] init];
    });
    
    return sInstance;
}

- (NSString *)generateSignature:(NSString *)seed
{
    
    NSArray *strs = @[kPublicKey,seed];
    strs = [strs sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSString *str = @"";
    for(NSString *tmp  in strs){
        str = [str stringByAppendingString:tmp];
    }
    
    str = [Utils sha1:str];
   
    return str;
}

- (BOOL)tokenExpired
{
    if (![self token]) {
        return YES;
    }else{
        
        NSDate *now = [NSDate date];
        NSTimeInterval gap = [now timeIntervalSinceDate: [NFRefrences sharedInstance].tokenExpireDate];
        
        if (gap > 3600) {
            return YES;
        }
        
    }
    
    return NO;
}

- (void)reqeustToken:(void (^)(BOOL, NSString *))callback
{
    if (![self tokenExpired]) {
        
        callback(YES,[self token]);
        
    }else{
        
        [self startAuth:callback];
        
    }
}

- (void)startAuth:(void (^)(BOOL, NSString *))callback
{
    self.seed = [NSString randomizedString];
    self.signature = [self generateSignature:_seed];
    
    [[NFAppNetInterface interface] get:@"access_token"
                parameters:@{@"signature":_signature,@"random_token":_seed}
                 comletion:^(BOOL suc, id obj){
                     
                     if (!suc) {
                         callback(NO,obj);
                         return ;
                     }
                     
                     NSString *aToken = obj[@"token"];
                     if (suc&&aToken) {
                         [self setToken:aToken];
                         callback(YES,aToken);
                     }else{
                         callback(NO,obj);
                     }
                 }];
    
}

- (void)setToken:(NSString *)token
{
    [NFRefrences sharedInstance].appAccessToken = token;
    [NFRefrences sharedInstance].tokenExpireDate = [NSDate date];
}

- (NSString *)token
{
    return [NFRefrences sharedInstance].appAccessToken;
}


@end
