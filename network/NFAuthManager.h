//
//  NFAuthManager.h
//  BeautifulGirls
//
//  Created by ChenJidong on 16/3/8.
//  Copyright © 2016年 Nirvawolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFAuthManager : NSObject

+ (instancetype)sharedInstance;

//- (void)startAuth:(void (^)(BOOL ,NSString *))callback;

//- (NSString *)token;

- (void)reqeustToken:(void (^)(BOOL ,NSString *))callback;

//- (void)setToken:(NSString *)token;

@end
