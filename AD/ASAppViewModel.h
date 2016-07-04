//
//  ASAppViewModel.h
//  AppStore Lookup View Model
//
//  Created by Qeye Wang on 4/14/16.
//  Copyright © 2016 Qeye.Inc All rights reserved.
//
//  Get app's info on AppStore through URL like below, all you need is an appid
//  http://itunes.apple.com/lookup?id=978533517

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ASAppModel : NSObject
@property(nonatomic, strong)NSString    *identifier;
@property(nonatomic, strong)NSString    *name;
@property(nonatomic, strong)NSString    *desc;
@property(nonatomic, strong)NSString    *author;
@property(nonatomic, strong)NSString    *price;
@property(nonatomic, strong)NSString    *storeUrl;
@property(nonatomic, strong)NSString    *icon60;
@property(nonatomic, strong)NSString    *icon100;
@property(nonatomic, strong)NSString    *icon512;
@property(nonatomic, strong)NSString    *collection;//该作者所有作品
@property(nonatomic, strong)NSArray     *screenshots;
@end

@interface ASAppViewModel : UIView
@property(nonatomic, strong)ASAppModel  *model;
@property(nonatomic, readonly)UIButton *actionBtn;
@property(nonatomic, readonly)UIImageView *iconView;
@property(nonatomic, readonly)UILabel *titleLabel;

/**
 *  You should use this entry ONLY.
 *
 *  @param appid the app you are looking for
 *  @param vc    which will present a in-app App Store to show app details
 *  @param block result block
 */
+ (void)lookupApp:(nonnull NSString *)appid presenter:(nullable UIViewController *)vc completion:(nonnull void(^)( NSError * _Nullable error,  ASAppViewModel * _Nullable app))block;

- (void)openInappAppStore ;

@end