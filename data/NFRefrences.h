//
//  NFPersistantValues.h
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/7.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import <PAPreferences/PAPreferences.h>

@interface NFRefrences : PAPreferences

@property (nonatomic,assign) NSString *weiboAccessToken;
@property (nonatomic,assign) NSDate *weiboAccessTokenExpireDate;

@property (nonatomic,assign) NSNumber *tokenExpireTime;
@property (nonatomic,assign) NSDate *tokenExpireDate;

@property (nonatomic,assign) NSString *appAccessToken;

@property (nonatomic,assign) NSData *favoritesData;

@property (nonatomic,assign) NSData *userTagsData;


@end
