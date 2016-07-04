//
//  NSObject+AssociatedObject.m
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/28.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import "NSObject+AssociatedObject.h"
#import <objc/runtime.h>

@implementation NSObject (AssociatedObject)

- (void)setAssociatedObject:(id)obj forKey:(NSString *)key  policy:(objc_AssociationPolicy)policy
{
    objc_setAssociatedObject(self, [key UTF8String], obj, policy);
}

- (id)associatedObjectForKey:(NSString *)key
{
    return objc_getAssociatedObject(self, [key UTF8String]);
}

@end
