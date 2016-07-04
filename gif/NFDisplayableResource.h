//
//  NFDisplayableResource.h
//  BeautifulGirls
//
//  Created by ChenJidong on 16/2/26.
//  Copyright © 2016年 Nirvawolf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mantle.h>

@interface NFDisplayableResource : MTLModel<MTLJSONSerializing>

@property (nonatomic,strong) NSString *resourceId;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,strong) NSString *fileSize;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *imageType;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *qiniuUrl;
@property (nonatomic,strong) NSNumber *width;
@property (nonatomic,strong) NSNumber *height;

@property (nonatomic,assign) BOOL isLocal;
@property (nonatomic,copy) NSString *filenameImported;

- (id)initWithLocal:(NSURL *)assetUrl;

- (BOOL)isGif;


@end
