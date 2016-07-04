//
//  NFStoryboadHelper.m
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/17.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import "NFStoryboadHelper.h"

@implementation NFStoryboadHelper

+ (UIViewController *)controller:(NSString *)vid fromStoryboard:(NSString *)storyboardName
{
    UIStoryboard *storyboad = [UIStoryboard storyboardWithName:storyboardName
                                                        bundle:[NSBundle mainBundle]];
    return [storyboad instantiateViewControllerWithIdentifier:vid];
}

@end
