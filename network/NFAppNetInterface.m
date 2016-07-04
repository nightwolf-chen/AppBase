//
//  NFAppServerHelper.m
//  BeautifulGirls
//
//  Created by ChenJidong on 16/3/3.
//  Copyright © 2016年 Nirvawolf. All rights reserved.
//

#import "NFAppNetInterface.h"
#import "NFAuthManager.h"

#import <AFNetworking.h>

@implementation NFAppNetInterface

+ (instancetype)interfaceWithHost:(NSString *)host
{
    return [[self alloc] initWithHost:host];
}

+ (instancetype)interface
{
    return [self interfaceWithHost:kDefaultHost];
}

- (instancetype)initWithHost:(NSString *)host
{
    if (self = [super init]) {
        _host = host;
    }
    
    return self;
}

- (NSString *)requestUrlWithInterfaceName:(NSString *)name
{
    return [NSString stringWithFormat:@"http://%@/1.0/%@",_host,name];
}

- (void)get:(NSString *)interfaceName parameters:(NSDictionary *)dic comletion:(void (^)(BOOL, id))completion
{
    [[AFHTTPRequestOperationManager manager] GET:[self requestUrlWithInterfaceName:interfaceName]
                                      parameters:dic
                                         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
                                             completion(YES,responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error){
                                             completion(NO,error);
                                         }];
    
}

- (void)post:(NSString *)interfaceName parameters:(NSDictionary *)dic comletion:(void (^)(BOOL, id))completion
{
    [[AFHTTPRequestOperationManager manager] POST:[self requestUrlWithInterfaceName:interfaceName]
                                       parameters:dic
                                          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
                                              completion(YES,responseObject);
                                          }
                                          failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error){
                                              completion(NO,error);
                                          }];
}

- (void)put:(NSString *)interfaceName parameters:(NSDictionary *)dic comletion:(void (^)(BOOL, id))completion
{
    [[AFHTTPRequestOperationManager manager] PUT :[self requestUrlWithInterfaceName:interfaceName]
                                       parameters:dic
                                          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
                                              completion(YES,responseObject);
                                          }
                                          failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error){
                                              completion(NO,error);
                                          }];
}

- (void)doDelete:(NSString *)interfaceName parameters:(NSDictionary *)dic comletion:(void (^)(BOOL, id))completion
{
    [[AFHTTPRequestOperationManager manager] DELETE:[self requestUrlWithInterfaceName:interfaceName]
                                       parameters:dic
                                          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
                                              completion(YES,responseObject);
                                          }
                                          failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error){
                                              completion(NO,error);
                                          }];
}

- (void)request:(NSString *)interfaceName method:(NFHTTPMethod)method parameters:(NSDictionary *)params comletion:(void (^)(BOOL, id))completion
{
    [[NFAuthManager sharedInstance] reqeustToken:^(BOOL suc, NSString * token){
        if (suc) {
            
            NSMutableDictionary *wrapedParams = [NSMutableDictionary dictionary];
            [wrapedParams setObject:token forKey:@"access_token"];
            [wrapedParams addEntriesFromDictionary:params];
            
            switch (method) {
                case NFHTTPMethodGET:
                    [self get:interfaceName parameters:wrapedParams comletion:completion];
                    break;
                case NFHTTPMethodPOST:
                    [self post:interfaceName parameters:wrapedParams comletion:completion];
                    break;
                    
                case NFHTTPMethodPUT:
                    [self put:interfaceName parameters:wrapedParams comletion:completion];
                    break;
                case NFHTTPMethodDELETE:
                    [self doDelete:interfaceName parameters:wrapedParams comletion:completion];
                    break;
                    
            }
            
        }else{
            completion(NO,@"access授权失败!");
        }
    }];
    
}


@end
