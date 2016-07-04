//
//  ASLookupViewModel.m
//  AppStore Lookup View Model
//
//  Created by Qeye Wang on 4/14/16.
//  Copyright © 2016 Qeye.Inc All rights reserved.
//

#import "ASAppViewModel.h"
#import <StoreKit/StoreKit.h>
#import <UIImageView+WebCache.h>

@interface ASAppModel ()
@end
@implementation ASAppModel
@end

@interface ASAppViewModel () <SKStoreProductViewControllerDelegate> {

}
@property(nonatomic, strong)UIViewController *presenter;
@end

@implementation ASAppViewModel
+ (void)lookupApp:(NSString *)appid presenter:(UIViewController *)vc completion:(void (^)(NSError *, ASAppViewModel *))block {
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appid]]
                                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                 if (!data) {
                                                                     block(error, nil);
                                                                     return;
                                                                 } else {
                                                                     NSDictionary *retDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                                                     if (retDic && [retDic isKindOfClass:[NSDictionary class]]) {
                                                                         BOOL finded = [retDic[@"resultCount"] integerValue] == 1;
                                                                         NSArray *appArr = retDic[@"results"];
                                                                         if (finded && appArr && appArr.count == 1) {
                                                                             NSDictionary *appInfo = appArr[0];
                                                                             ASAppViewModel *appViewModel = [ASAppViewModel new];
                                                                             ASAppModel *app = [ASAppModel new];
                                                                             app.name = appInfo[@"trackName"];
                                                                             app.desc = appInfo[@"description"];
                                                                             app.author = appInfo[@"artistName"];
                                                                             app.icon60 = appInfo[@"artworkUrl60"];
                                                                             app.icon100 = appInfo[@"artworkUrl100"];
                                                                             app.icon512 = appInfo[@"artworkUrl512"];
                                                                             app.identifier = appInfo[@"trackId"];
                                                                             app.screenshots = appInfo[@"screenshotUrls"];
                                                                             
                                                                             appViewModel.model = app;
//                                                                             appViewModel.presenter = vc;
                                                                             block(nil, appViewModel);
                                                                         } else {
                                                                             block([NSError errorWithDomain:@"com.qeye.opensource" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"fetal error: find multiple app"}], nil);
                                                                             return;
                                                                         }
                                                                     } else {
                                                                         block([NSError errorWithDomain:@"com.qeye.opensource" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"fetal error: parse ret failed"}], nil);
                                                                         return;
                                                                     }
                                                                 }
                                }];
    [task resume];
}

- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, 80, 100)]) {
        _actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionBtn setFrame:self.bounds];
        [_actionBtn addTarget:self action:@selector(openInappAppStore) forControlEvents:UIControlEventTouchUpInside];
        [_actionBtn setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self addSubview:_actionBtn];
        
        _iconView = [[UIImageView alloc] init];
        _iconView.layer.cornerRadius = 10.0;
        [self addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _iconView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds));
    _titleLabel.frame = CGRectMake(5, CGRectGetMaxY(_iconView.frame) + 5, CGRectGetWidth(self.bounds)-10, CGRectGetHeight(self.bounds)-CGRectGetHeight(_iconView.bounds));
}

- (void)setModel:(ASAppModel *)model {
    _model = model;
    _titleLabel.text = model.name.length > 8 ? [model.name substringToIndex:8] : model.name;
    __weak typeof(self) wSelf = self;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.icon100]];
    
//    NSURLSessionTask *imageTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:model.icon100]
//                                                              completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                                                                  if (data) {
//                                                                      wSelf.iconView.image = [UIImage imageWithData:data];
//                                                                      [wSelf setNeedsDisplay];
//                                                                  }
//                                                              }];
//    [imageTask resume];
}

- (void)openInappAppStore {
    SKStoreProductViewController *productController = [[SKStoreProductViewController alloc] init];
    productController.delegate = self;
    NSDictionary *appIdDic = [NSDictionary dictionaryWithObjectsAndKeys:_model.identifier, SKStoreProductParameterITunesItemIdentifier, nil];
    [productController loadProductWithParameters:appIdDic completionBlock:^(BOOL result, NSError *error) {
        if (result) {
        }
    }];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:productController animated:YES completion:nil];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
@end
