//
//  NFEmotionExporter.m
//  NFGifFunny
//
//  Created by ChenJidong on 16/3/8.
//  Copyright © 2016年 nirvawolf. All rights reserved.
//

#import "NFWXEmotionExporter.h"
#import "UIImage+Resize.h"

#import <YYImage/YYImage.h>

#define kEmoationSingleMainSize CGSizeMake(200,200)
#define kEmoationMainSize CGSizeMake(120,120)
#define kEmoationThumbSize CGSizeMake(120,120)
#define kMaxFrameCount 24

@implementation NFWXEmotionExporter

- (NFWXEmotion *)exportEmoation:(NSData *)data
{
    YYImageDecoder *decoder = [YYImageDecoder decoderWithData:data scale:2.0f];
    
    if (decoder.frameCount > 1) {
        return [self exportGifEmoation:data decoder:decoder];
    }else{
        return [self exportImageEmoation:data decoder:decoder];
    }
    
}

- (NFWXEmotion *)exportGifEmoation:(NSData *)data decoder:(YYImageDecoder *)decoder
{
    NFWXEmotion *emoation = [[NFWXEmotion alloc] init];
    YYImageEncoder *encoder = [[YYImageEncoder alloc] initWithType:YYImageTypeGIF];
    encoder.quality = 0.2;
    
    UIImage *thumbImage = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
    thumbImage = [thumbImage resizedImageToFitInSize:kEmoationThumbSize scaleIfSmaller:YES];
    
    emoation.thumbData = UIImageJPEGRepresentation(thumbImage , 0.2);
    
    const int frameToSkip = (int)decoder.frameCount - kMaxFrameCount;
    
    BOOL needSkipFrame = frameToSkip > 0 ? YES : NO;
    float tmp = (float)decoder.frameCount / (float)frameToSkip;
//    int gap = (tmp + 0.5);
    int gap = tmp;
    int counter = 0;
    
    int encodeFrameCount = 0;
    float durationAccumulator = 0;
    int frameSkiped = 0;
    
    for(int i = 0 ; i < decoder.frameCount ; i++){
        
        @autoreleasepool {
            //防止帧数过多进行平均跳帧
            if (needSkipFrame && frameSkiped < frameToSkip && counter == gap) {
                durationAccumulator = [decoder frameDurationAtIndex:i];
                counter = 0;
                frameSkiped++;
                continue;
            }
            
            encodeFrameCount++;
            
            UIImage *originFrame = [decoder frameAtIndex:i decodeForDisplay:YES].image;
            float duration = [decoder frameDurationAtIndex:i];
            if (durationAccumulator > 0) {
                duration += durationAccumulator;
                durationAccumulator = 0;
            }
            UIImage *emotionFrame = [originFrame resizedImageToFitInSize:kEmoationMainSize
                                                          scaleIfSmaller:NO];
//            NSData *compressData = UIImageJPEGRepresentation(emotionFrame, 0.25);
//            UIImage *image = [UIImage imageWithData:compressData];
            [encoder addImage:emotionFrame duration:duration];
            
            counter++;
        }
        
    }
    
    NSLog(@"origin:(%d) %d frame encoded!",(int)decoder.frameCount, encodeFrameCount);
    
    emoation.emotionData = [encoder encode];
    
    return emoation;
}

- (NFWXEmotion *)exportImageEmoation:(NSData *)data decoder:(YYImageDecoder *)decoder
{
    NFWXEmotion *emoation = [[NFWXEmotion alloc] init];
    
    UIImage *firstFrame = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
    UIImage *thumbImage = [firstFrame resizedImageToFitInSize:kEmoationThumbSize scaleIfSmaller:YES];
    UIImage *emotionImage = [firstFrame resizedImageToFitInSize:kEmoationSingleMainSize scaleIfSmaller:YES];
    
    emoation.thumbData = UIImageJPEGRepresentation(thumbImage,0.2);
//    emoation.emotionData = UIImageJPEGRepresentation(emotionImage, 0.5);
//    emoation.thumbData = UIImagePNGRepresentation(thumbImage);
    emoation.emotionData = UIImagePNGRepresentation(emotionImage);
    
    return emoation;
}

@end


@implementation NFWXEmotion


@end