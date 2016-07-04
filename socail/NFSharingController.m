//
//  NFSharingController.m
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/1.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <SVProgressHUD.h>
#import <WeiboSDK.h>
#import <MobClick.h>

#import "NFSharingController.h"
#import "NFResourceDataLoader.h"
#import "NFSharingService.h"
#import "NFWeiboPoster.h"
#import "NFWeiboAuthManager.h"
#import "utils.h"
#import "NFFavoritesImageManager.h"
#import "NFScreenAdController.h"


@interface NFSharingController ()<UIActionSheetDelegate>

@property (nonatomic,strong) NSData *imageData;
@property (nonatomic,assign) BOOL sharing;
@property (nonatomic,assign) NFSharingPlatformTarget *sharingPlatformTarget;
@property (nonatomic,assign) BOOL dataLoadFinished;

@end

@implementation NFSharingController

+ (instancetype)sharedController
{
    static id s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[self alloc] init];
    });
    
    return s_instance;
}



- (void)startShare:(NFDisplayableResource *)resource showFavorites:(BOOL)showFavorites
{
    if (_sharing) {
        return;
    }
    
    self.sharing = YES;
    self.dataLoadFinished = NO;
    self.imageData = nil;
    
    _resource = resource;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择分享的平台"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    
    NSArray *sharingTargets = [NFSharingService sharedService].sharingTargets;
    for(NFSharingPlatformTarget *target in sharingTargets){
        
        if (!showFavorites && [target.displayname isEqual:@"收藏"]) {
            continue;
        }
        
        [actionSheet addButtonWithTitle:target.displayname];
    }
    
    [actionSheet showInView:[[UIApplication sharedApplication].delegate window]];
    
    [SVProgressHUD show];
    
    [[NFResourceDataLoader loader] load:resource callback:^(BOOL suc , NSData *data , NSError *err){
        
        self.dataLoadFinished = YES;
        
        if (suc) {
            self.imageData = data;
        }else{
            self.imageData = nil;
        }
        
        dispatch_on_main(^{
            [self tryShare];
        });
        
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 0 && buttonIndex <= [NFSharingService sharedService].sharingTargets.count) {
        
        self.sharing = YES;
        
        self.sharingPlatformTarget = [NFSharingService sharedService].sharingTargets[buttonIndex - 1];
        
        [self tryShare];
    }else{
        self.sharing = NO;
        [SVProgressHUD dismiss];
    }
    
}

- (void)tryShare
{
    if (_dataLoadFinished &&  _sharing &&_sharingPlatformTarget) {
        
        if (_imageData) {
            
            NFSharingData *data = [[NFSharingData alloc] init];
            data.data = _imageData;
            data.imagePreview = _imageData;
            data.resouce = _resource;
            
            [MobClick event:@"share" attributes: @{@"platform":_sharingPlatformTarget.name}];
            
            [[NFSharingService sharedService] startSharingSession:_sharingPlatformTarget
                                                          content:data
                                                         callback:^(BOOL suc, NSError *err){
                                                             
                                                            [self endCurrenSession];
                                                             
                                                             [SVProgressHUD dismiss];
                                                             
                                                             if (suc) {
                                                                 [SVProgressHUD showSuccessWithStatus:@"成功"];
                                                             }else{
                                                                 [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后再试"];
                                                             }
                                                             
                                                             
                                                         }];
            
//            [[NFScreenAdController sharedController] loadAD];
            
        }else{
            
            [self endCurrenSession];
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"数据加载失败，请稍后再试"];
            
        }
        
    }
}

- (void)endCurrenSession
{
    self.sharing = NO;
    self.dataLoadFinished = NO;
    self.sharingPlatformTarget = nil;
    self.imageData = nil;
}

- (void)shareAppInViewController:(UIViewController *)viewController
{
    [[NFSharingService sharedService] shareAppInViewController:viewController];
}


@end
