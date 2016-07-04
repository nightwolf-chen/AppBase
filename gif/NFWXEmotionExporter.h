//
//  NFEmotionExporter.h
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/8.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFWXEmotion : NSObject
@property (nonatomic,strong) NSData *thumbData;
@property (nonatomic,strong) NSData *emotionData;
@end

@interface NFWXEmotionExporter : NSObject

- (NFWXEmotion *)exportEmoation:(NSData *)data;

@end
