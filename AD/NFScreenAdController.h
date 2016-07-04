//
//  NFBaiduScreenAddController.h
//  BeautifulGirls
//
//  Created by ChenJidong on 16/1/10.
//  Copyright © 2016年 Nirvawolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface NFScreenAdController : NSObject<GADInterstitialDelegate>

@property (nonatomic,retain) GADInterstitial *interstitialView;

+ (id)sharedController;

- (void)loadAD;

- (void)loadADWithDelay:(float)delay;

- (void)showBannerInView:(UIViewController *)rootViewController;

@end
