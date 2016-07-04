//
//  NFSearchEngineHelper.h
//  NFGifFunny
//
//  Created by ChenJidong on 16/5/12.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,NFSearchScope) {
    NFSearchScopeInApp,
    NFSearchScopeInternet
};

@interface NFEmotionSearchResult : NSObject

@property (nonatomic,assign) int page;
@property (nonatomic,assign) int total;
@property (nonatomic,assign) int perPageCount;
@property (nonatomic,assign) BOOL end;
@property (nonatomic,strong) NSArray *images;

@end

@interface NFSearchHelper : NSObject

+ (void)search:(NSString *)keyword
         scope:(NFSearchScope)scope
    parameters:(NSDictionary *)parameters
    completion:(void (^)(BOOL suc , NFEmotionSearchResult * result))completionBlock;

@end
