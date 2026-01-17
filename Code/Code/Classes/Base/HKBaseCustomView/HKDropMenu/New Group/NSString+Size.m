//
//  NSString+sizeText.m
//  Code
//
//  Created by Ivan li on 2019/1/7.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
    
}

+ (BOOL)strIsNilOrEmpty:(NSString *)str
{    
    if (!str || str == (id)[NSNull null]) return YES;
    
    if ([str isKindOfClass:[NSString class]]) {
        return str.length == 0;
    } else {
        return YES;
    }
}
@end
