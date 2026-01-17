//
//  NSString+sizeText.h
//  Code
//
//  Created by Ivan li on 2019/1/7.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Size)

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
/**
 *  @brief  判断字符串是否为空或者为nil,NULL
 *
 *  @param str 字符串
 *
 *  @return true 为空或者nil false 不为空,nil
 */
+ (BOOL)strIsNilOrEmpty:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
