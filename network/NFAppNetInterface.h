//
//  NFAppServerHelper.h
//  BeautifulGirls
//
//  Created by ChenJidong on 16/3/3.
//  Copyright © 2016年 Nirvawolf. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAliHost @"139.129.42.34"
#define kOpenshiftHost @"www.supersean.org"
//#define kDefaultHost kOpenshiftHost
#define kDefaultHost kAliHost

typedef NS_ENUM(NSUInteger ,NFHTTPMethod) {
    NFHTTPMethodGET,
    NFHTTPMethodPOST,
    NFHTTPMethodPUT,
    NFHTTPMethodDELETE
};

@interface NFAppNetInterface : NSObject

@property (nonatomic,copy) NSString *host;

+ (instancetype)interfaceWithHost:(NSString *)host;

+ (instancetype)interface;

- (void)request:(NSString *)interfaceName
         method:(NFHTTPMethod)method
     parameters:(NSDictionary *)params
      comletion:(void (^)(BOOL, id))completion;

- (void)get:(NSString *)interfaceName
 parameters:(NSDictionary *)dic
  comletion:(void (^)(BOOL suc , id obj))completion;

- (void)post:(NSString *)interfaceName
  parameters:(NSDictionary *)dic
   comletion:(void (^)(BOOL suc , id obj))completion;

- (void)put:(NSString *)interfaceName
 parameters:(NSDictionary *)dic
  comletion:(void (^)(BOOL, id))completion;

- (void)doDelete:(NSString *)interfaceName
parameters:(NSDictionary *)dic
comletion:(void (^)(BOOL, id))completion;

- (NSString *)requestUrlWithInterfaceName:(NSString *)name;
@end
