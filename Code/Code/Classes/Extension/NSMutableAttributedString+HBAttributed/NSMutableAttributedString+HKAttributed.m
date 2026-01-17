//
//  NSMutableAttributedString+HBAttributed.m
//  Code
//
//  Created by Ivan li on 2018/4/26.
//  Copyright © 2018年 pg. All rights reserved.
//


#import "NSMutableAttributedString+HKAttributed.h"
#import <CoreText/CoreText.h>

@implementation NSMutableAttributedString (HBAttributed)
/**
 *  单纯改变一句话中的某些字的颜色
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subArray 需要改变颜色的文字数组
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *) changeCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    for (NSString *rangeStr in subArray) {
        
        NSMutableArray *array = [self  getRangeWithTotalString:totalStr SubString:rangeStr];
        
        for (NSNumber *rangeNum in array) {
            
            NSRange range = [rangeNum rangeValue];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
    }
    return attributedStr;
}




/**
 *  单纯改变句子的字间距（需要 <CoreText/CoreText.h>）
 *
 *  @param totalString 需要更改的字符串
 *  @param space       字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *) changeSpaceWithTotalString:(NSString *)totalString Space:(CGFloat)space {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    long number = space;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedStr length])];
    CFRelease(num);
    
    return attributedStr;
}




/**
 *  单纯改变段落的行间距
 *
 *  @param totalString 需要更改的字符串
 *  @param lineSpace   行间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *) changeLineSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    // 过多的最后省略号
    [paragraphStyle setLineSpacing:lineSpace];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];
    
    return attributedStr;
}



/**
 *  同时更改行间距和字间距
 *
 *  @param totalString 需要改变的字符串
 *  @param lineSpace   行间距
 *  @param textSpace   字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *) changeLineAndTextSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];
    
    long number = textSpace;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedStr length])];
    CFRelease(num);
    
    return attributedStr;
}



/**
 *   首行缩进行间距和字间距
 *  @param firstLineSpace 首行间距
 *  @param totalString 需要改变的字符串
 *  @param lineSpace   行间距
 *  @param textSpace   字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *) changeLineAndTextSpaceWithTotalString:(NSString *)totalString firstLineSpace:(CGFloat)firstLineSpace LineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace{

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    //    style.headIndent = 30;//缩进
    
    style.firstLineHeadIndent = firstLineSpace;
    
    style.lineSpacing = lineSpace;//行距
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:totalString];
    //设置缩进、行距
    
    [attribute addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, totalString.length)];
    
    return attribute;
}
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
+ (NSMutableAttributedString *) changeFontAndColor:(UIFont *)font Color:(UIColor *)color TotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    

    
    for (NSString *rangeStr in subArray) {
        
        NSRange range = [totalString rangeOfString:rangeStr options:NSBackwardsSearch];
        
        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    }
    return attributedStr;
}

/**
 *  为某些文字改为链接形式
 *
 *  @param totalString 总的字符串
 *  @param subArray    需要改变颜色的文字数组(要是有相同的 只取第一个)
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *) addLinkWithTotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    for (NSString *rangeStr in subArray) {
        
        NSRange range = [totalString rangeOfString:rangeStr options:NSBackwardsSearch];
        [attributedStr addAttribute:NSLinkAttributeName value:totalString range:range];
    }
    return attributedStr;
}




/**
 *  获取某个字符串中子字符串的位置数组
 *
 *  @param totalString 总的字符串
 *  @param subString   子字符串
 *
 *  @return 位置数组
 */
+ (NSMutableArray *) getRangeWithTotalString:(NSString *)totalString SubString:(NSString *)subString {
    
    NSMutableArray *arrayRanges = [NSMutableArray array];
    
    if (subString == nil && [subString isEqualToString:@""]) {
        return nil;
    }
    
    NSRange rang = [totalString rangeOfString:subString];
    
    if (rang.location != NSNotFound && rang.length != 0) {
        
        [arrayRanges addObject:[NSNumber valueWithRange:rang]];
        
        NSRange      rang1 = {0,0};
        NSInteger location = 0;
        NSInteger   length = 0;
        
        for (int i = 0;; i++) {
            
            if (0 == i) {
                
                location = rang.location + rang.length;
                length = totalString.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            } else {
                
                location = rang1.location + rang1.length;
                length = totalString.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            
            rang1 = [totalString rangeOfString:subString options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0) {
                
                break;
            } else {
                
                [arrayRanges addObject:[NSNumber valueWithRange:rang1]];
            }
        }
        return arrayRanges;
    }
    return nil;
}



/**
 *  中划线 字符串
 */
+ (NSMutableAttributedString *)middleLineAttributedString:(NSString *)content  titleColor:(UIColor*)titleColor {
    
    if (isEmpty(content)) {
        return nil;
    }
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:content attributes:attribtDic];
    [attribtStr addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, content.length)];
    return attribtStr;
}




/**
 *  //下划线 字符串
 */
+ (NSMutableAttributedString *)bottomLineAttributedString:(NSString *)content {
    if (isEmpty(content)) {
        return nil;
    }
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:content attributes:attribtDic];
    return  attribtStr;
}



+ (NSMutableAttributedString*)mutableAttributedString:(NSString*)title font:(UIFont*)font  titleColor:(UIColor*)titleColor  image:(UIImage*)image  bounds:(CGRect)bounds {
    
    if (isEmpty(title)) {
        return nil;
    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    [attrString addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attrString.length)];
    if (image) {
        // 创建带有图片的富文本
        NSAttributedString *string = [NSMutableAttributedString attributedStringWithImage:image imageBounds:bounds];
        [attrString appendAttributedString:string];
    }
    return attrString;
}



+ (NSAttributedString *)attributedStringWithImage:(UIImage *)image imageBounds:(CGRect)bounds {
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    textAttachment.bounds = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
    NSAttributedString *attachmentAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    return attachmentAttributedString;
}



+ (NSMutableAttributedString *) changeLineAndTextSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace font:(CGFloat)font titleColor:(UIColor*)titleColor {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    
    [attributedStr addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, totalString.length)];
    [attributedStr addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM(font) range:NSMakeRange(0, totalString.length)];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];
    
    long number = textSpace;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedStr length])];
    CFRelease(num);
    
    return attributedStr;
}



+ (NSMutableAttributedString*)mutableAttributedString:(NSString*)title font:(UIFont*)font  titleColor:(UIColor*)titleColor  image:(UIImage*)image  bounds:(CGRect)bounds index:(NSInteger)index {
    
    if (isEmpty(title)) {
        return nil;
    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    [attrString addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attrString.length)];
    if (image) {
        // 创建带有图片的富文本
        NSAttributedString *string = [NSMutableAttributedString attributedStringWithImage:image imageBounds:bounds];
        //[attrString appendAttributedString:string];
        [attrString insertAttributedString:string atIndex:index];
    }
    return attrString;
}



/// 生成的富文本
/// @param string 字符串
/// @param lineSpace 行间距
/// @param color 文本颜色
/// @param font 文本 字体
+ (NSMutableAttributedString *)mutableAttributedString:(NSString *)string
                                             LineSpace:(CGFloat)lineSpace
                                                 color:(UIColor*)color
                                                  font:(UIFont*)font {
    if (isEmpty(string)) {
        return nil;
    }
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 过多的最后省略号
    [paragraphStyle setLineSpacing:lineSpace];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    if (color) {
        [attrString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length)];
    }
    if (font) {
        [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,string.length)];
    }
    return attrString;
}



+ (NSMutableAttributedString *)mutableAttributedString:(NSString *)string
                                             endString:(NSString *)endString
                                             LineSpace:(CGFloat)lineSpace
                                                 color:(UIColor*)color
                                              endColor:(UIColor*)endColor
                                                  font:(UIFont*)font
                                               endFont:(UIFont*)endFont {
   
    return [[self class] mutableAttributedString:string endString:endString LineSpace:lineSpace color:color endColor:endColor font:font endFont:endFont isWrap:YES textAlignment:NSTextAlignmentLeft];
}


+ (NSMutableAttributedString *)mutableAttributedString:(NSString *)string
                                             endString:(NSString *)endString
                                             LineSpace:(CGFloat)lineSpace
                                                 color:(UIColor*)color
                                              endColor:(UIColor*)endColor
                                                  font:(UIFont*)font
                                               endFont:(UIFont*)endFont
                                                isWrap:(BOOL)isWrap
                                         textAlignment:(NSTextAlignment)textAlignment {

    if (isEmpty(string)) {
        return nil;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    
    [paragraphStyle setAlignment:textAlignment];
      
    NSString *str = [NSString stringWithFormat:@"%@\n%@",string,endString];
    if (NO == isWrap) {
        str = [NSString stringWithFormat:@"%@%@",string,endString];
    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,attrString.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attrString.length)];
    if (!isEmpty(endString)) {
        
        if (NO == isWrap) {
            [attrString addAttribute:NSForegroundColorAttributeName value:endColor range:NSMakeRange(string.length,endString.length)];
            [attrString addAttribute:NSFontAttributeName value:endFont range:NSMakeRange(string.length,endString.length)];
        }else{
            [attrString addAttribute:NSForegroundColorAttributeName value:endColor range:NSMakeRange(string.length+1,endString.length)];
            [attrString addAttribute:NSFontAttributeName value:endFont range:NSMakeRange(string.length+1,endString.length)];
        }
    }
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrString length])];
    return attrString;
}




@end











