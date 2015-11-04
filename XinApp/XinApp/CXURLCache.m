//
//  CXURLCache.m
//  XinApp
//  非WiFi网络环境下不加载图片，参考链接：http://www.icab.de/blog/2009/08/18/url-filtering-with-uiwebview-on-the-iphone/
//
//  Created by Kingyee on 15/11/4.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "CXURLCache.h"
#import <AFNetworkReachabilityManager.h>
#import "XinAppDefine.h"

@interface CXURLCache () {
    BOOL shouldLoadImg;
}

@end

@implementation CXURLCache

- (instancetype)init {
    // the path to the cache file
    NSString *path = NSTemporaryDirectory();
    NSUInteger diskCapacity = 10*1024*1024;
    NSUInteger memoryCapacity = 512*1024;
    self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path];
    
    shouldLoadImg = NO;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            shouldLoadImg = YES;
        }
        else {
            shouldLoadImg = NO;
        }
    }];
    
    return self;
}

- (BOOL)shouldBlockURL:(NSURL *)url
{
    BOOL noWiFiNoImage = [[NSUserDefaults standardUserDefaults] boolForKey:CXNoWiFiNoImageKey];
    if (!noWiFiNoImage) {
        return NO;
    }
    if (shouldLoadImg) {
        return NO;
    }
    NSString *urlString = [url.absoluteString lowercaseString];
    if ([urlString hasSuffix:@"jpg"] ||
        [urlString hasSuffix:@"png"] ||
        [urlString hasSuffix:@"gif"]) {
        return YES;
    }
    
    return NO;
}

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    NSURL *url = request.URL;
    if ([self shouldBlockURL:url]) {
        NSURLResponse *response =
        [[NSURLResponse alloc] initWithURL:url
                                  MIMEType:@"text/plain"
                     expectedContentLength:1
                          textEncodingName:nil];
        
        NSCachedURLResponse *cachedResponse =
        [[NSCachedURLResponse alloc] initWithResponse:response
                                                 data:[NSData dataWithBytes:" " length:1]];
        
        [super storeCachedResponse:cachedResponse forRequest:request];
    }
    return [super cachedResponseForRequest:request];
}

@end
