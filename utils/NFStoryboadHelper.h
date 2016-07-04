//
//  NFStoryboadHelper.h
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/17.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NFStoryboadHelper : NSObject

+ (UIViewController *)controller:(NSString *)vid
                   fromStoryboard:(NSString *)storyboardName;

@end
