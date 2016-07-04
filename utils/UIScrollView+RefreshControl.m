//
//  UIScrollView+RefreshControl.m
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/23.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import "UIScrollView+RefreshControl.h"
#import "FMMacros.h"
#import <objc/runtime.h>

NSString *const kScrollViewRefreshControlKey  = @"__kScrollViewRefreshControlKey__";

@implementation UIScrollView (RefreshControl)

- (UIRefreshControl *)nf_refreshControl
{
    id control = objc_getAssociatedObject(self, [kScrollViewRefreshControlKey UTF8String]);
    
    if (control) {
        return control;
    }
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = THEME_COLOR_GREEN;
    [self addSubview:refreshControl];
    
    objc_setAssociatedObject(self, [kScrollViewRefreshControlKey UTF8String], refreshControl, OBJC_ASSOCIATION_ASSIGN);
    
    return refreshControl;
}

@end
