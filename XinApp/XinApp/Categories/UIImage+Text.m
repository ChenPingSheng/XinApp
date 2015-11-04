//
//  UIImage+Text.m
//  XinApp
//
//  Created by Kingyee on 15/11/2.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "UIImage+Text.h"

@implementation UIImage (Text)

+ (UIImage*)imageWithText:(NSString*)text size:(CGSize)size {
    if (text.length == 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setAlignment:NSTextAlignmentCenter];
    
    CGFloat fontSize = size.height/text.length;
    
    [text drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:ps}];
    
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

@end
