//
//  NSString+Pinyin.h
//  XinApp
//
//  Created by Kingyee on 15/11/4.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Pinyin)

- (NSString *)stringByTransformingToPinyin;

- (NSString*)firstLetterOfPinyin;

@end
