//
//  NFDisplayableResource.m
//  BeautifulGirls
//
//  Created by ChenJidong on 16/2/26.
//  Copyright © 2016年 Nirvawolf. All rights reserved.
//

#import "NFDisplayableResource.h"
#import "FMMacros.h"

#import <StandardPaths.h>

@implementation NFDisplayableResource

/*
 description = sdfsdf;
 "file_size" = 98551;
 height = 736;
 id = 6;
 "image_type" = jpeg;
 name = test;
 "qiniu_url" = "http://77fy3d.com1.z0.glb.clouddn.com/6.jpeg";
 url = "http://77fy3g.com1.z0.glb.clouddn.com/005804ff_9945_4f6b_9216_da002467cd06";
 width = 753;
 */

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             SelectorString(desc): @"description",
             SelectorString(fileSize): @"file_size",
             SelectorString(height): @"height",
             SelectorString(width): @"width",
             SelectorString(resourceId): @"id",
             SelectorString(imageType): @"image_type",
             SelectorString(name): @"name",
             SelectorString(qiniuUrl): @"qiniu_url",
             SelectorString(url): @"url"
             };
}

- (id)initWithLocal:(NSURL *)assetUrl
{
    if (self = [super init]) {
        _url = assetUrl.absoluteString;
        
        if ([_url containsString:@"GIF"] || [_url containsString:@"gif"]) {
            _imageType = @"gif";
        }else{
            _imageType = @"image";
        }
        
        _isLocal = YES;
    }
    
    return self;
}


- (NSString *)importPath
{
    NSString *path = [[NSFileManager defaultManager] publicDataPath];
    path = [path stringByAppendingPathComponent:@"imported"];
    BOOL *isDir = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:true
                                                   attributes:nil
                                                        error:nil];
    }
    
    return path;
}

- (NSString *)url
{
    if (_isLocal) {
        return [self importFilePathWithFileName:_filenameImported];
    }else{
        return _url;
    }
}

- (NSString *)importFilePathWithFileName:(NSString *)filename
{
    NSString *dirPath = [self importPath];
    return [dirPath stringByAppendingPathComponent:filename];
}

+ (NSValueTransformer *)resourceIdJSONTransformer{
    return [MTLJSONAdapter transformerForModelPropertiesOfClass:[NSString class]];
}

+ (NSValueTransformer *)fileSizeJSONTransformer{
    return [MTLJSONAdapter transformerForModelPropertiesOfClass:[NSString class]];
}

- (BOOL)isGif
{
    if ([self.imageType isEqual:@"gif"]) {
        return YES;
    }
    
    if ([self.url hasSuffix:@"gif"]) {
        return YES;
    }
    
    if ([self.imageType isEqual:@"OTHER"]) {
        return YES;
    }
    
    
    return NO;
}


@end
