//
//  UIScrollView+RefreshControl.h
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/23.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kScrollViewRefreshControlKey;

@interface UIScrollView (RefreshControl)

- (UIRefreshControl *)nf_refreshControl;

@end
