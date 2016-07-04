//
//  NFDisplayablePresentor.h
//  BeautifulGirls
//
//  Created by ChenJidong on 16/2/26.
//  Copyright © 2016年 Nirvawolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NFDisplayableResource;

IB_DESIGNABLE

@interface NFDisplayablePresentor : UIView

@property (nonatomic,strong) NFDisplayableResource *resource;

- (void)present:(NFDisplayableResource *)resource
       callback:(void (^)(BOOL suc,NSError *err))callback;

- (void)present:(NFDisplayableResource *)resource
           data:(NSData *)data
       callback:(void (^)(BOOL suc,NSError *err))callback;

- (void)clear;


@end
