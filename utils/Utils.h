//
//  Utils.h
//  BeautifulGirls
//
//  Created by ChenJidong on 16/3/3.
//  Copyright © 2016年 Nirvawolf. All rights reserved.
//

#import <Foundation/Foundation.h>

extern void dispatch_on_main(void (^block)(void));

@interface Utils : NSObject

+ (void)notificationMainThreadPost:(NSString *)name userInfo:(NSDictionary *)userInfo;

+ (NSString *)sha1:(NSString *)source;

+ (NSString *)sortCharacters:(NSString *)source;

+ (NSString *)combineStrs:(NSArray *)strs;

@end
