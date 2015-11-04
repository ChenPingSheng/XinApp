//
//  ZhiHuAPI.m
//  XinApp
//
//  Created by Kingyee on 15/10/23.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "ZhiHuAPI.h"

/*
 https://github.com/izzyleung/ZhihuDailyPurify/wiki/知乎日报-API-分析
 */
NSString *const ZhiHuDailyAPI4 = @"http://news-at.zhihu.com/api/4/";

@implementation ZhiHuAPI

+ (void)latestNewsWithSuccess:(void (^)(NSString *date, NSArray *stories, NSArray *topStories))success
                  failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:ZhiHuDailyAPI4]];
    
    [sessionManager GET:@"news/latest" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (responseObject) {
            success(responseObject[@"date"], responseObject[@"stories"], responseObject[@"top_stories"]);
        }
        else {
            failure(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+ (void)beforeNewsWithDate:(NSString *)date success:(void (^)(NSString *date, NSArray *stories))success
                   failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:ZhiHuDailyAPI4]];
    
    NSString *path = [NSString stringWithFormat:@"news/before/%@", date];
    [sessionManager GET:path parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (responseObject) {
            success(responseObject[@"date"], responseObject[@"stories"]);
        }
        else {
            failure(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)fetchNewsDetail:(id)newsID success:(void (^)(NSDictionary *newsDetail))success
                    failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:ZhiHuDailyAPI4]];
    NSString *path = [NSString stringWithFormat:@"news/%@", newsID];
    [sessionManager GET:path parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (responseObject) {
            success(responseObject);
        }
        else {
            failure(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+ (void)fetchNewsExtra:(id)newsID success:(void (^)(NSDictionary *newsExtra))success
               failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:ZhiHuDailyAPI4]];
    NSString *path = [NSString stringWithFormat:@"story-extra/%@", newsID];
    [sessionManager GET:path parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (responseObject) {
            success(responseObject);
        }
        else {
            failure(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)fetchThemesWithSuccess:(void (^)(NSArray *themes))success
                       failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:ZhiHuDailyAPI4]];
    
    [sessionManager GET:@"themes" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSArray *dataArray = responseObject[@"others"];
        if (dataArray && [dataArray isKindOfClass:[NSArray class]]) {
            success(dataArray);
        }
        else {
            failure(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+ (void)fetchThemeDetail:(id)themeID success:(void (^)(NSArray *stories))success
                 failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:ZhiHuDailyAPI4]];
    
    NSString *path = [NSString stringWithFormat:@"theme/%@", themeID];
    [sessionManager GET:path parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (responseObject) {
            success(responseObject[@"stories"]);
        }
        else {
            failure(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
