//
//  NFGiphyResource.m
//  GiphyDude
//
//  Created by ChenJidong on 16/7/1.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import "NFGiphyResource.h"
#import <Giphy-iOS/AXCGiphy.h>

@implementation NFGiphyResource

/*
 @property (nonatomic,strong) NSString *resourceId;
 @property (nonatomic,copy) NSString *url;
 @property (nonatomic,strong) NSString *fileSize;
 @property (nonatomic,copy) NSString *desc;
 @property (nonatomic,copy) NSString *imageType;
 @property (nonatomic,copy) NSString *name;
 @property (nonatomic,copy) NSString *qiniuUrl;
 @property (nonatomic,strong) NSNumber *width;
 @property (nonatomic,strong) NSNumber *height;
 */
+ (NFGiphyResource *)resourceFromGiphy:(AXCGiphy *)giphy
{
    NFGiphyResource *resource = [[NFGiphyResource alloc] init];
//    resource.giphy = giphy;
    resource.resourceId = giphy.gifID;
    resource.url = giphy.fixedWidthImage.url.absoluteString;
    resource.desc = @"";
    resource.imageType = @"gif";
    resource.name = @"";
    
    return resource;
}

+ (NSArray *)resourcesFromGiphies:(NSArray *)sources
{
    NSMutableArray *tmp = [NSMutableArray array];
    for(AXCGiphy *giphy in sources){
        [tmp addObject:[self resourceFromGiphy:giphy]];
    }
    
    return tmp;
}

@end
