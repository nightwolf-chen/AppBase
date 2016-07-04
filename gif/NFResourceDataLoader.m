//
//  NFResourceDataLoader.m
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/1.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import "NFResourceDataLoader.h"
#import "NFDisplayableResource.h"

#import <PINCache.h>
#import <AFNetworking.h>
#import <SDWebImageManager.h>

@implementation NFResourceDataLoader

+ (instancetype)loader
{
    return [[self alloc] init];
}

- (void)load:(NFDisplayableResource *)resource callback:(void (^)(BOOL, NSData *, NSError *))callback
{
    if (resource.isLocal) {
        
        NSData *data = [NSData dataWithContentsOfFile:resource.url];
        if (data) {
            callback(YES,data,nil);
        }else{
            callback(NO,data,nil);
        }
        
        return;
    }
    
    
    if (![resource isGif]) {
        
        NSString *imageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:resource.url]];
        
        UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:imageKey];
        if (!image) {
            image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:imageKey];
        }
        
        if (image) {
            callback(YES,UIImagePNGRepresentation(image),nil);
            return;
        }
        
    }
    
    //把图片data缓存到磁盘进行异步读取
    [[PINCache sharedCache] objectForKey:resource.url block:^(PINCache * _Nonnull cache, NSString * _Nonnull key, id  _Nullable object){
        if (object) {
            callback(YES , object , nil);
        }else{
            [self loadDataFromServer:resource callback:callback];
        }
    }];
}


- (void)loadDataFromServer:(NFDisplayableResource *)resource callback:(void (^)(BOOL, NSData *, NSError *))callback
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    [manager GET:resource.url parameters:nil success:^(AFHTTPRequestOperation *op , id obj){
        [[PINCache sharedCache] setObject:obj forKey:resource.url
                                    block:nil];
        callback(YES,obj,nil);
    } failure:^(AFHTTPRequestOperation *op , NSError *err){
        callback(NO , nil , err);
    }];
}
@end
