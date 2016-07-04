//
//  NFBaiduScreenAddController.m
//  BeautifulGirls
//
//  Created by ChenJidong on 16/1/10.
//  Copyright © 2016年 Nirvawolf. All rights reserved.
//

#import "NFScreenAdController.h"
#import "AppDelegate.h"
#import "FMMacros.h"

#ifdef DEBUG
static const int kAddTime = 120;
#else
static const int kAddTime = 120;
#endif

#define kAdViewPortraitRect CGRectMake(0, SCREEN_HEIGHT - 95, SCREEN_WIDTH, 50)
#define kADUnitTagScreen @"ca-app-pub-8187953332708697/3857429448"

@implementation NFScreenAdController


#pragma mark - View lifecycle

+ (id)sharedController
{
    static id SInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SInstance = [[self alloc] init];
    });
    return SInstance;
}


- (instancetype)init
{
    if (self = [super init]) {
//        [NSTimer scheduledTimerWithTimeInterval:kAddTime
//                                         target:self
//                                       selector:@selector(loadAD)
//                                       userInfo:nil
//                                        repeats:YES];
    }
    
    return self;
}

- (void)loadAD
{
    if (self.interstitialView) {
        return;
    }
    
    self.interstitialView = [[GADInterstitial alloc] initWithAdUnitID:kADUnitTagScreen];
    self.interstitialView.delegate = self;
    
    GADRequest *request = [GADRequest request];
#ifdef DEBUG
    request.testDevices = @[ @"c05943a862f79ea091a78d24b21a6008" ];
#endif
    
    [self.interstitialView loadRequest:request];
}

- (void)loadADWithDelay:(float)delay
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(delay * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        [self loadAD];
    });
}


- (void)showAD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.interstitialView.isReady) {
            UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
            [self.interstitialView presentFromRootViewController:rootVC];
            self.interstitialView = nil;
        }
    });
}

- (void)showBannerInView:(UIViewController *)rootViewController
{
    GADBannerView *banner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:kAdViewPortraitRect.origin];
    banner.adUnitID = @"ca-app-pub-8187953332708697/6810895846";
    banner.rootViewController = rootViewController;
    [rootViewController.view addSubview:banner];
    
    GADRequest *request = [GADRequest request];
#ifdef DEBUG
    request.testDevices = @[ @"c05943a862f79ea091a78d24b21a6008" ];
#endif
    [banner loadRequest:request];
}

#pragma mark - GoogleAdDelegate
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [self showAD];
}

/// Called just after dismissing an interstitial and it has animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    self.interstitialView = nil;
}


@end
