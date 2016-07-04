//
//  NSObject+AssociatedObject.h
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/28.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (AssociatedObject)

- (void)setAssociatedObject:(id)obj
                     forKey:(NSString *)key
                     policy:(objc_AssociationPolicy)policy;

- (id)associatedObjectForKey:(NSString *)key;

@end
