//
//  ZhiHuAPI.h
//  XinApp
//
//  Created by Kingyee on 15/10/23.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface ZhiHuAPI : NSObject

//最新消息
+ (void)latestNewsWithSuccess:(void (^)(NSString *date, NSArray *stories, NSArray *topStories))success
                      failure:(void (^)(NSError *error))failure;

//过往消息
+ (void)beforeNewsWithDate:(NSString *)date success:(void (^)(NSString *date, NSArray *stories))success
                   failure:(void (^)(NSError *error))failure;

//消息内容
+ (void)fetchNewsDetail:(id)newsID success:(void (^)(NSDictionary *newsDetail))success
                    failure:(void (^)(NSError *error))failure;

//消息额外信息
+ (void)fetchNewsExtra:(id)newsID success:(void (^)(NSDictionary *newsExtra))success
               failure:(void (^)(NSError *error))failure;

//主题
+ (void)fetchThemesWithSuccess:(void (^)(NSArray *themes))success
                       failure:(void (^)(NSError *error))failure;

//主题详细
+ (void)fetchThemeDetail:(id)themeID success:(void (^)(NSArray *stories))success
                            failure:(void (^)(NSError *error))failure;


@end
