//
//  NFWeiboPoster.m
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/7.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import "NFWeiboPoster.h"
#import "NFSharingService.h"
#import "NFWeiboAuthManager.h"
#import "NFSharingService.h"
#import "NFDisplayableResource.h"
#import "NFWXEmotionExporter.h"

#import <AFNetworking/AFNetworking.h>

@interface NFWeiboPoster ()
@property (nonatomic,strong) NSMutableArray *tasks;
@property (nonatomic,strong) NSThread *workingThread;
@property (nonatomic,strong) dispatch_semaphore_t semaphore;
@end

@implementation NFWeiboPoster

+ (instancetype)sharedPoster
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
        _tasks = [NSMutableArray array];
        _workingThread = [[NSThread alloc] initWithTarget:self selector:@selector(mainloop) object:nil];
        _semaphore = dispatch_semaphore_create(0);
        [_workingThread start];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifyNewTask)
                                                     name:kNFWeiboAuthManagerDidUpdateTokenNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)notifyNewTask
{
    dispatch_semaphore_signal(_semaphore);
}

- (void)mainloop
{
    while (1) {
        
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        
        NFWeiboPostTask *task = [_tasks firstObject];
        NFSharingData *data = task.sharingData;
        
        NFWXEmotion *emotion = [[[NFWXEmotionExporter alloc] init] exportEmoation:data.data];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *url = @"https://upload.api.weibo.com/2/statuses/upload.json";
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        [manager POST:url
           parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
    
                [formData appendPartWithFileData:emotion.emotionData
                                            name:@"pic"
                                        fileName:@"pic"
                                        mimeType:@"image/jpeg"];
                [formData appendPartWithFormData:[[NFWeiboAuthManager sharedInstance].token dataUsingEncoding:NSUTF8StringEncoding]
                                            name:@"access_token"];
                [formData appendPartWithFormData:[data.resouce.desc dataUsingEncoding:NSUTF8StringEncoding]
                                            name:@"status"];
           }
              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
                task.callback(YES,responseObject);
              }
              failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error){
                task.callback(NO,error);
              }];
        
        
    }
}


- (void)postWeibo:(NSString *)text image:(NFSharingData *)sharingData callback:(void (^)(BOOL, id))callback
{
    NFWeiboPostTask *task = [[NFWeiboPostTask alloc] init];
    task.text = text;
    task.sharingData = sharingData;
    task.callback = callback;
    [_tasks addObject:task];
    
    if ([NFWeiboAuthManager sharedInstance].expired ||
        [NFWeiboAuthManager sharedInstance].token == nil) {
        [[NFWeiboAuthManager sharedInstance] startAuthSession];
    }else{
        [self notifyNewTask];
    }
}


@end


@implementation NFWeiboPostTask

@end
