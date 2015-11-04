//
//  CXWebsiteManager.m
//  XinApp
//
//  Created by Kingyee on 15/11/4.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "CXWebsiteManager.h"

@implementation CXWebsiteManager

+ (instancetype)defaultManager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

+ (NSMutableArray *)sharedWebsites {
    NSMutableArray *websites = [[NSMutableArray alloc] init];
    
    NSURL *dstURL = [self fileURLForMainApp];
    NSURL *extURL = [self fileURLForAppGroup];
    
    NSArray *array = nil;
    NSArray *array1 = [NSArray arrayWithContentsOfURL:dstURL];
    NSArray *array2 = [NSArray arrayWithContentsOfURL:extURL];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (!array1) {
        NSURL *srcURL = [self fileURLForAppBundle];
        [fm copyItemAtURL:srcURL toURL:dstURL error:NULL];
    }
    if (!array2) {
        [fm copyItemAtURL:dstURL toURL:extURL error:NULL];
    }
    
    //如果两处不一致，用AppGroup里的
    if (![array1 isEqualToArray:array2]) {
        array = array2;
        [self saveWebsitesToMainApp:array2];
    }
    else {
        array = array1;
    }
    
    [websites addObjectsFromArray:array];
    
    [[self defaultManager] setWebsites:websites];
    
    return websites;
}

+ (NSURL *)fileURLForAppGroup {
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.chenxinapp.xinapp"];
    containerURL = [containerURL URLByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@", CXWebsiteFile]];
    return containerURL;
}

+ (NSURL *)fileURLForMainApp {
    NSString *dstFilePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", CXWebsiteFile]];
    return [NSURL fileURLWithPath:dstFilePath];
}

+ (NSURL *)fileURLForAppBundle {
    NSString *srcFilePath = [[NSBundle mainBundle] pathForResource:CXWebsiteFile ofType:nil];
    return [NSURL fileURLWithPath:srcFilePath];
}

+ (BOOL)websitesIsDifferent {
    
    NSURL *dstURL = [self fileURLForMainApp];
    NSURL *extURL = [self fileURLForAppGroup];
    
    NSArray *array1 = [NSArray arrayWithContentsOfURL:dstURL];
    NSArray *array2 = [NSArray arrayWithContentsOfURL:extURL];
    return ![array1 isEqualToArray:array2];
}

+ (BOOL)websiteExistsWithTitle:(NSString *)title url:(NSString*)url
{
    NSArray *array = [self sharedWebsites];
    for (NSDictionary *dict in array) {
        if ([title isEqualToString:dict[@"Title"]] && [url isEqualToString:dict[@"URL"]]) {
            return YES;
        }
    }
    return NO;
}

+ (void)addWebsiteWithTitle:(NSString *)title url:(NSString *)url fromExt:(BOOL)fromExt
{
    if ([self websiteExistsWithTitle:title url:url]) {
        return;
    }
    NSDictionary *dict = @{@"Title":title, @"URL":url};
    
    NSURL *extURL = [self fileURLForAppGroup];
    NSURL *dstURL = [self fileURLForMainApp];
    
    NSMutableArray *array = nil;
    if (fromExt) {
        array = [NSMutableArray arrayWithContentsOfURL:extURL];
    }
    else {
        array = [NSMutableArray arrayWithContentsOfURL:dstURL];
    }
    
    [array addObject:dict];
    [array writeToURL:extURL atomically:YES];
    [array writeToURL:dstURL atomically:YES];
}

+ (void)saveWebsites:(NSArray*)array
{
    [self saveWebsitesToAppGroup:array];
    [self saveWebsitesToMainApp:array];
}

+ (void)saveWebsitesToAppGroup:(NSArray*)array {
    
    NSURL *extURL = [self fileURLForAppGroup];
    [array writeToURL:extURL atomically:YES];
}

+ (void)saveWebsitesToMainApp:(NSArray*)array
{
    NSURL *dstURL = [self fileURLForMainApp];
    [array writeToURL:dstURL atomically:YES];
}

@end
