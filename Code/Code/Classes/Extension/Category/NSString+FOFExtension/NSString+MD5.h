//
//  NSString+MD5.h
//  medicineplus
//
//  Created by gufei on 15-4-13.
//  Copyright (c) 2015年 chn_ruby@126.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

+(NSString *) md5: (NSString *) inPutText;

/**
 * 文本size
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

- (CGSize)heightWithFont:(UIFont *)font MaxWidth:(float)width;

/**
 *除去首位空格。及 换行符
 */
+ (NSString *)removeSpaceAndNewline:(NSString*)text;


/** 字符串 高度  包含 换行符 */
+ (CGFloat)heightWithStr:(NSString*)str  spacing:(CGFloat)spacing  titleFont:(UIFont*)titleFont width:(CGFloat)width;

/** 验证 URL  */
+ (BOOL)isUrl:(NSString*)URL;


/**
 图片转base64编码

 @param image
 @return 字符串
 */
+(NSString *)imageToBase64Str:(UIImage *)image;




/**
 短视频 点赞数量 格式化

 @param count  点赞数量
 @return  string
 */
+ (NSString *)shortVideoFormatCount:(NSInteger)count;

/**
 短视频 评论数量 格式化
 
 @param count  评论数量
 @return  string
 */
+ (NSString *)shortVideoCommentCount:(NSInteger)count;


/**
 Wifi 名称

 @return 名称
 */
+ (NSString *)hkWifiName;


/**
 阿拉伯转汉字

 @param arebic 数字
 @return 中文字符
 */
+ (NSString *)translation:(NSString *)arebic;


@end
