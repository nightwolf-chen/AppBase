//
//  NFSharingController.h
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/1.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NFDisplayableResource;
@interface NFSharingController : NSObject

@property (nonatomic,readonly,strong) NFDisplayableResource *resource;

@property (nonatomic,readonly,assign) BOOL showFavoriteButton;

+ (instancetype)sharedController;

- (void)startShare:(NFDisplayableResource *)resource showFavorites:(BOOL)showFavorites;

- (void)shareAppInViewController:(UIViewController *)viewController;

@end
