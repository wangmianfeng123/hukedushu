//
//  NSMutableAttributedString+HBAttributed.h
//  Code
//
//  Created by Ivan li on 2018/4/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (HBAttributed)
/**
 *  单纯改变一句话中的某些字的颜色（一种颜色）
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subArray 需要改变颜色的文字数组(要是有相同的 只取第一个)
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)changeCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray;



/**
 *  单纯改变句子的字间距（需要 <CoreText/CoreText.h>）
 *
 *  @param totalString 需要更改的字符串
 *  @param space       字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)changeSpaceWithTotalString:(NSString *)totalString Space:(CGFloat)space;



/**
 *  单纯改变段落的行间距
 *
 *  @param totalString 需要更改的字符串
 *  @param lineSpace   行间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)changeLineSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace;


/**
 *   首行缩进行间距和字间距
 *  @param firstLineSpace 首行间距
 *  @param totalString 需要改变的字符串
 *  @param lineSpace   行间距
 *  @param textSpace   字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *) changeLineAndTextSpaceWithTotalString:(NSString *)totalString firstLineSpace:(CGFloat)firstLineSpace LineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace;


/**
 *  同时更改行间距和字间距
 *
 *  @param totalString 需要改变的字符串
 *  @param lineSpace   行间距
 *  @param textSpace   字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)changeLineAndTextSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace;


/**
 *  改变某些文字的颜色 并单独设置其字体
 *
 *  @param font        设置的字体
 *  @param color       颜色
 *  @param totalString 总的字符串
 *  @param subArray    想要变色的字符数组
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)changeFontAndColor:(UIFont *)font Color:(UIColor *)color TotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray;



/**
 *  为某些文字改为链接形式
 *
 *  @param totalString 总的字符串
 *  @param subArray    需要改变颜色的文字数组(要是有相同的 只取第一个)
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)addLinkWithTotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray;


/**
 *  中划线 字符串
 */
+ (NSMutableAttributedString *)middleLineAttributedString:(NSString *)content  titleColor:(UIColor*)titleColor;


/**
 *  下划线 字符串
 */
+ (NSMutableAttributedString *)bottomLineAttributedString:(NSString *)content;


/**
 *  添加 图片
 *  @param image
 *  @param bounds
 *
 *  @return 生成的图片富文本
 */
+ (NSAttributedString *)attributedStringWithImage:(UIImage *)image imageBounds:(CGRect)bounds;

/**
 *  文字在前  图片在后 富文本
 *  @param image
 *  @param bounds
 *
 *  @return 文字在前  图片在后 富文本
 */
+ (NSMutableAttributedString*)mutableAttributedString:(NSString*)title font:(UIFont*)font  titleColor:(UIColor*)titleColor  image:(UIImage*)image  bounds:(CGRect)bounds;



/**
 同时更改行间距和字间距

 @param totalString <#totalString description#>
 @param lineSpace <#lineSpace description#>
 @param textSpace <#textSpace description#>
 @param font <#font description#>
 @param titleColor <#titleColor description#>
 @return <#return value description#>
 */
+ (NSMutableAttributedString *) changeLineAndTextSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace font:(CGFloat)font titleColor:(UIColor*)titleColor;




/// 文字  图片 富文本
/// @param title 字符
/// @param font 字体
/// @param titleColor 字体颜色
/// @param image 图片
/// @param bounds 图片 frame
/// @param index  图片插入 index

+ (NSMutableAttributedString*)mutableAttributedString:(NSString*)title font:(UIFont*)font  titleColor:(UIColor*)titleColor
                                                image:(UIImage*)image  bounds:(CGRect)bounds index:(NSInteger)index;


/// 生成的富文本
/// @param string 字符串
/// @param lineSpace 行间距
/// @param color 文本颜色
/// @param font 文本 字体
+ (NSMutableAttributedString *)mutableAttributedString:(NSString *)string
                                             LineSpace:(CGFloat)lineSpace
                                                 color:(UIColor*)color
                                                  font:(UIFont*)font;



/// 生成的富文本
/// @param string 开始 字符串
/// @param endString 结尾 字符串
/// @param lineSpace 行间距
/// @param color 开始 文本颜色
/// @param endColor 结尾 文本颜色
/// @param font 开始 文本字体
/// @param endFont 结尾 文本字体
+ (NSMutableAttributedString *)mutableAttributedString:(NSString *)string
                                             endString:(NSString *)endString
                                             LineSpace:(CGFloat)lineSpace
                                                 color:(UIColor*)color
                                              endColor:(UIColor*)endColor
                                                  font:(UIFont*)font
                                               endFont:(UIFont*)endFont;

/// 生成的富文本
/// @param string 开始 字符串
/// @param endString 结尾 字符串
/// @param lineSpace 行间距
/// @param color 开始 文本颜色
/// @param endColor 结尾 文本颜色
/// @param font 开始 文本字体
/// @param endFont 结尾 文本字体
/// @param isWrap 是否 换行显示
+ (NSMutableAttributedString *)mutableAttributedString:(NSString *)string
                                             endString:(NSString *)endString
                                             LineSpace:(CGFloat)lineSpace
                                                 color:(UIColor*)color
                                              endColor:(UIColor*)endColor
                                                  font:(UIFont*)font
                                               endFont:(UIFont*)endFont
                                                isWrap:(BOOL)isWrap
                                         textAlignment:(NSTextAlignment)textAlignment;


@end
