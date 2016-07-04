//
//  NFGiphyResource.h
//  GiphyDude
//
//  Created by ChenJidong on 16/7/1.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import "NFDisplayableResource.h"

@class AXCGiphy;

@interface NFGiphyResource : NFDisplayableResource
//@property (nonatomic,strong) AXCGiphy *giphy;

+ (NFGiphyResource *)resourceFromGiphy:(AXCGiphy *)giphy;
+ (NSArray *)resourcesFromGiphies:(NSArray *)sources;

@end
