//
//  NSString+Pinyin.m
//  XinApp
//
//  Created by Kingyee on 15/11/4.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "NSString+Pinyin.h"

@implementation NSString (Pinyin)

- (NSString *)stringByTransformingToPinyin {
    NSMutableString *string = [[NSMutableString alloc] initWithString:self];
    if (!CFStringTransform((__bridge CFMutableStringRef)string, 0, kCFStringTransformMandarinLatin, NO)) {
        return self;
    }
    //不带音标
    if (!CFStringTransform((__bridge CFMutableStringRef)string, 0, kCFStringTransformStripDiacritics, NO)) {
        return self;
    }
    return string;
}

- (NSString*)firstLetterOfPinyin {
    if (self.length < 1) {
        return self;
    }
    NSString *string = [self stringByTransformingToPinyin];
    return [[string substringToIndex:1] uppercaseString];
}

@end
