//
//  CXWebsiteManager.h
//  XinApp
//
//  Created by Kingyee on 15/11/4.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XinAppDefine.h"

@interface CXWebsiteManager : NSObject

@property (nonatomic, strong) NSMutableArray *websites;

+ (instancetype)defaultManager;

+ (NSURL *)fileURLForAppGroup;

+ (NSMutableArray *)sharedWebsites;

//AppGroup里的数据和主App不一致
+ (BOOL)websitesIsDifferent;

+ (BOOL)websiteExistsWithTitle:(NSString *)title url:(NSString*)url inArray:(NSArray*)array;

+ (void)addWebsiteWithTitle:(NSString *)title url:(NSString *)url fromExt:(BOOL)fromExt;
+ (void)saveWebsites:(NSArray*)array;
+ (void)saveWebsitesToAppGroup:(NSArray*)array;
+ (void)saveWebsitesToMainApp:(NSArray*)array;

@end
