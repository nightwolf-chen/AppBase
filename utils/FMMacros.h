//
//  FMMacros.h
//  DoubanFM
//
//  Created by nirvawolf on 19/6/14.
//  Copyright (c) 2014 nirvawolf. All rights reserved.
//

#ifndef DoubanFM_FMMacros_h
#define DoubanFM_FMMacros_h


#define SCREEN_SIZE  [[UIScreen mainScreen] bounds].size
#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height


#define VIDEO_WIDTH 320
#define VIDEO_HEIGHT 256

#define ImageNamed( _name_ ) [UIImage imageNamed:_name_]
#define NibNamed(_name_) [UINib nibWithNibName:_name_ bundle:[NSBundle mainBundle]]


#define STATUSBAR_SIZE [[UIApplication sharedApplication] statusBarFrame].size
#define STATUSBAR_WIDTH [[UIApplication sharedApplication] statusBarFrame].size.width
#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height


#define RECT(x,y,w,h) CGRectMake(x,y,w,h)
#define RGBCOLOR(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#pragma mark - NSCoding Helper macros
#define SelectorString(_x_) NSStringFromSelector(@selector(_x_))
#define NSCoderEncodeObject(aCoder,selector) [aCoder encodeObject:_##selector forKey:SelectorString(selector)]
#define NSCoderDecodeObject(aDecoder,selector) _##selector = [aDecoder decodeObjectForKey:SelectorString(selector)]

#define NSCoderEncodeInteger(aCoder,selector) [aCoder encodeInteger:_##selector forKey:SelectorString(selector)]
#define NSCoderDecodeInteger(aDecoder,selector) _##selector = [aDecoder decodeIntegerForKey:SelectorString(selector)]

#define AbstractMethodAssert() NSAssert(NO, @"Abstract method!")

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define DELEGATE_CHECK(_delegate_ , _selector_) (_delegate_ && [_delegate respondsToSelector:_selector_])

#define WINDOW_APP [[UIApplication sharedApplication].delegate window]

#define THEME_COLOR_GREEN RGBCOLOR(30,30,40)
#define THEME_COLOR_GREEN_DARK RGBCOLOR(45,122,126)
#define THEME_COLOR_GREEN_LIGHT RGBCOLOR(80,186,55)
#define THEME_COLOR_BG_GRAY RGBCOLOR(236,236,236)
#define THEME_COLOR_BG_WHITE RGBCOLOR(255,255,255)
#define THEME_COLOR_RED RGBCOLOR(244,57,82)
#define THEME_COLOR_GRAY RGBCOLOR(214,230,222)
#define THEME_COLOR_YELLOW RGBCOLOR(255,204,0)
#define THEME_COLOR_BLUE RGBCOLOR(48,167,236)
#define THEME_COLOR_BLACK RGBCOLOR(42,47,54)


#endif
