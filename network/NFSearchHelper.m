//
//  NFSearchEngineHelper.m
//  NFGifFunny
//
//  Created by ChenJidong on 16/5/12.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import "NFSearchHelper.h"
#import "NFAppNetInterface.h"
#import "NFDisplayableResource.h"
#import "NF360Resource.h"

#import <Mantle/Mantle.h>
#import <AFNetworking.h>

#define kPerPageCount 8

@implementation NFSearchHelper

+ (void)search:(NSString *)keyword
         scope:(NFSearchScope)scope
    parameters:(NSDictionary *)parameters
    completion:(void (^)(BOOL suc , NFEmotionSearchResult * result))completionBlock;
{
    switch (scope) {
        case NFSearchScopeInApp:
        {
            [self searchInApp:keyword
                   parameters:parameters
                   completion:completionBlock];
        }
            break;
            
        case NFSearchScopeInternet:
        {
            [self searchInternet:keyword
                      parameters:parameters
                      completion:completionBlock];
        }
            break;
    }
}

+ (void)searchInApp:(NSString *)keyword
         parameters:(NSDictionary *)parameters
         completion:(void (^)(BOOL suc , NFEmotionSearchResult * result))completionBlock;
{
    [[NFAppNetInterface interface] request:@"search"
                                    method:NFHTTPMethodGET
                                parameters:parameters
                                 comletion:^(BOOL suc , id obj){
                                     
                                     
                                     if (suc) {
                                         NSArray *tResources = [MTLJSONAdapter modelsOfClass:[NFDisplayableResource class]
                                                                               fromJSONArray:obj[@"images"]
                                                                                       error:nil];
                                         //TODO:
                                         int page = 0;
                                         NFEmotionSearchResult *result = [[NFEmotionSearchResult alloc] init];
                                         result.page = page;
                                         result.images = tResources;
                                         completionBlock(YES,result);
                                         
                                     }else{
                                         completionBlock(NO,nil);
                                     }
                                     
                                     
                                 }];
}

+ (void)searchInternet:(NSString *)keyword
            parameters:(NSDictionary *)parameters
            completion:(void (^)(BOOL suc , NFEmotionSearchResult * result))completionBlock;
{
    
    NSString *q = [keyword stringByAppendingString:@"动态表情"];
    NSInteger page = [parameters[@"page"] integerValue];
    
    NSInteger sn = page * kPerPageCount;
    
    NSDictionary *wrapedParameters = @{
                                       @"q":q,
                                       @"sn":@(sn),
                                       @"pn":@(kPerPageCount)
                                       };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSSet *acContents = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/javascript"];
    manager.responseSerializer.acceptableContentTypes = acContents;
    
    [manager GET:@"http://image.so.com/j"
      parameters:wrapedParameters
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
             
             if (responseObject) {
                 
                 int total = (int)[responseObject[@"total"] integerValue];
                 int page = (int)[responseObject[@"lastindex"] integerValue];
                 BOOL end = [responseObject[@"end"] boolValue];
                 NSArray *jsonArray = responseObject[@"list"];
                 NSError *err = nil;
                 NSArray *tResources = [MTLJSONAdapter modelsOfClass:[NF360Resource class]
                                                       fromJSONArray:jsonArray
                                                               error:&err];
                 if (!err) {
                     NFEmotionSearchResult *result = [[NFEmotionSearchResult alloc] init];
                     result.images = tResources;
                     result.page = page;
                     result.perPageCount = kPerPageCount;
                     result.total = total;
                     result.end = end;
                     
                     completionBlock(YES,result);
                 }else{
                     completionBlock(NO,nil);
                 }
                 
             }else{
                 completionBlock(NO,nil);
             }
             
         }failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error){
             completionBlock(NO,nil);
         }];
}



@end






@implementation NFEmotionSearchResult


@end
