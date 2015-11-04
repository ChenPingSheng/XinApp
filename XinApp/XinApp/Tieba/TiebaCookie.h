//
//  TiebaCookie.h
//  XinApp
//
//  Created by Kingyee on 15/11/2.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TiebaCookie : NSObject

+ (void)fetchCookieWithURL:(NSURL *)theURL;
+ (void)clearCookieWithURL:(NSURL *)theURL;

@end
