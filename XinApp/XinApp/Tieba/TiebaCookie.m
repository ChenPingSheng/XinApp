//
//  TiebaCookie.m
//  XinApp
//
//  Created by Kingyee on 15/11/2.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "TiebaCookie.h"

@implementation TiebaCookie

+ (void)fetchCookieWithURL:(NSURL *)theURL {
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:theURL];
    NSEnumerator *enumerator = [cookies objectEnumerator];
    NSHTTPCookie *cookie;
    while (cookie = [enumerator nextObject]) {
        NSLog(@"COOKIE{name: %@, value: %@}", [cookie name], [cookie value]);
    }
}

+ (void)clearCookieWithURL:(NSURL *)theURL {
    
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:theURL];
    NSEnumerator *enumerator = [cookies objectEnumerator];
    NSHTTPCookie *cookie;
    while (cookie = [enumerator nextObject]) {
        [sharedHTTPCookieStorage deleteCookie:cookie];
    }
}

@end
