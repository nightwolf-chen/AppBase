//
//  NFDisplayablePresentor.m
//  BeautifulGirls
//
//  Created by ChenJidong on 16/2/26.
//  Copyright © 2016年 Nirvawolf. All rights reserved.
//

#import "NFDisplayablePresentor.h"
#import "NFDisplayableResource.h"
#import "utils.h"
#import "NFResourceDataLoader.h"


#import <FLAnimatedImage.h>
#import <UIImageView+WebCache.h>
#import <UIImage+GIF.h>
#import <AFNetworking.h>
#import <PINCache/PINCache.h>

@interface NFDisplayablePresentor ()
@property (nonatomic,weak) UIView *imageView;
@property (nonatomic,strong) UIImageView *placeholderImage;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;
@end

@implementation NFDisplayablePresentor

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)showLoading
{
//    if (!_placeholderImage) {
//        _placeholderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_holder"]];
//        _placeholderImage.frame = self.bounds;
//        [self addSubview:_placeholderImage];
//    }
    
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
        [self addSubview:_indicator];
    }
    
    [_indicator startAnimating];
    _indicator.hidden = NO;
}

- (void)present:(NFDisplayableResource *)resource callback:(void (^)(BOOL, NSError *))callback
{
    self.resource = resource;
    
    [self showLoading];
    
    if (resource.isGif){
        
        [self presentGif:resource callback:^(BOOL suc , NSError *err){
            dispatch_on_main(^{
                [_indicator stopAnimating];
                _indicator.hidden = YES;
            });
            callback(suc,err);
        }];
    }else{
        [self presentImage:resource callback:^(BOOL suc , NSError *err){
            dispatch_on_main(^{
                [_indicator stopAnimating];
                _indicator.hidden = YES;
            });
            callback(suc,err);
        }];
    }
}

- (void)setAnimatedImage:(NSData *)data resource:(NFDisplayableResource *)resource callback:(void (^)(BOOL,NSError *))callback
{
    //异步读取内存缓存内容
    [[PINMemoryCache sharedCache] objectForKey:resource.url block:^(PINMemoryCache * _Nonnull cache, NSString * _Nonnull key, id  _Nullable object){
        dispatch_on_main(^{
            
            //以为异步的关系，要检测resouce是否在读取数据期间已经被更改
//            if (![_resource.resourceId isEqual:resource.resourceId]) {
            if (_resource != resource) {
                NSLog(@"Presentor Resource ID dismatch!");
                callback(NO,nil);
                return ;
            }
            
            FLAnimatedImage *image = object;
            if (!image) {
                 image = [[FLAnimatedImage alloc] initWithAnimatedGIFData:data];
                [[PINMemoryCache sharedCache] setObject:image
                                                 forKey:resource.url];
            }
        
            if (!_imageView || ![_imageView isKindOfClass:[FLAnimatedImageView class]]) {
                
                if (_imageView) {
                    [_imageView removeFromSuperview];
                    self.imageView = nil;
                }
                
                FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] initWithFrame:self.bounds];
                [self addSubview:imageView];
                self.imageView = imageView;
            }
                
            ((FLAnimatedImageView *)_imageView).animatedImage = image;
            
            if (callback) {
                callback(YES,nil);
            }
        });
        
    }];
        
}


- (void)presentGif:(NFDisplayableResource *)resource callback:(void (^)(BOOL, NSError *))callback
{
    
    if (_imageView) {
        [_imageView removeFromSuperview];
        self.imageView = nil;
    }
    
    //把图片data缓存到磁盘进行异步读取
    [[NFResourceDataLoader loader] load:resource callback:^(BOOL suc, NSData *data, NSError *err){
        
        if (suc) {
            [self setAnimatedImage:data resource:resource callback:callback];
        }else{
            if (callback) {
                callback(NO,err);
            }
        }
    }];
    
}

- (void)clear
{
    if (_imageView) {
        [_imageView removeFromSuperview];
        self.imageView = nil;
    }
    
    _resource = nil;
}

- (void)present:(NFDisplayableResource *)resource
           data:(NSData *)data
       callback:(void (^)(BOOL, NSError *))callback
{
    if (_imageView) {
        [_imageView removeFromSuperview];
        self.imageView = nil;
    }
    
    self.resource = resource;
    
    if ([resource.imageType isEqual:@"gif"]) {
        
        __weak NFDisplayablePresentor *weakSelf = self;
        [self setAnimatedImage:data resource:resource callback:^(BOOL suc , NSError *err){
            
            dispatch_on_main(^{
                [weakSelf.indicator stopAnimating];
                weakSelf.indicator.hidden = YES;
            });
            
            callback(suc,err);
        }];
        
    }else{
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];
        imageView.frame = self.bounds;
        [self addSubview:imageView];
        self.imageView = imageView;
        
        dispatch_on_main(^{
            [_indicator stopAnimating];
            _indicator.hidden = YES;
        });
    }
}



- (void)presentImage:(NFDisplayableResource *)resource callback:(void (^)(BOOL, NSError *))callback
{
    if (_imageView) {
        [_imageView removeFromSuperview];
        self.imageView = nil;
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    NSURL *url =[NSURL URLWithString:resource.url];
    if (resource.isLocal) {
        url = [NSURL fileURLWithPath:resource.url];
    }
    
    [imageView sd_setImageWithURL:url
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        if (error) {
            if (callback) {
                callback(NO,error);
            }
        }else {
            if (callback) {
                callback(YES,nil);
            }
        }
    }];
    
    self.imageView = imageView;
    imageView.frame = self.bounds;
    [self addSubview:imageView];
}

- (void)layoutSubviews
{
    _imageView.frame = self.bounds;
    _placeholderImage.frame = self.bounds;
    _indicator.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
}



@end
