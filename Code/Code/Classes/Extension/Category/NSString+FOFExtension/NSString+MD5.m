//
//  NSString+MD5.m
//  medicineplus
//
//  Created by gufei on 15-4-13.
//  Copyright (c) 2015年 chn_ruby@126.cn. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation NSString (MD5)

+(NSString *) md5: (NSString *) inPutText
{
     NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    NSData *gb2312data=[inPutText dataUsingEncoding:encoding];
    const char *cStr = [inPutText cStringUsingEncoding:encoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}


- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textSize;
}




- (CGSize)heightWithFont:(UIFont *)font MaxWidth:(float)width{
    if (self.length==0) {
        return CGSizeMake(0, 0);
    }
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin|
                   NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    
    return CGSizeMake((rect.size.width), (rect.size.height));
}




+ (NSString *)removeSpaceAndNewline:(NSString*)text {
    if (isEmpty(text)) {
        return nil;
    }
    NSString *str = [text stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return str;
}


/** 字符串 高度 */
+ (CGFloat)heightWithStr:(NSString*)str  spacing:(CGFloat)spacing  titleFont:(UIFont*)titleFont width:(CGFloat)width {
    
    if (0 == str.length) {
        return 0;
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:spacing];
    
    NSDictionary *attributes = @{ NSFontAttributeName:titleFont,NSParagraphStyleAttributeName:style };
    
    CGFloat H = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:NSStringDrawingTruncatesLastVisibleLine |
                 NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                               attributes:attributes
                                  context:nil].size.height;
    
    return H;
}



+ (BOOL)isUrl:(NSString*)URL {
    
    if(URL == nil) {
        return NO;
    }
    NSString *url = nil;
    if (URL.length>4 && [[URL substringToIndex:4] isEqualToString:@"www."]) {
        url = [NSString stringWithFormat:@"http://%@",URL];
    }else{
        url = URL;
    }
    NSString *urlRegex = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:url];
}



#pragma mark - 图片转base64编码
+(NSString *)imageToBase64Str:(UIImage *) image {
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}



+ (NSString *)shortVideoFormatCount:(NSInteger)count {
    if (count) {
        if(count < 10000) {
            return [NSString stringWithFormat:@"%ld",(long)count];
        }else {
            return [NSString stringWithFormat:@"%.1fw",count/10000.0f];
        }
    }else{
        return  @"点赞";
    }
}

+ (NSString *)shortVideoCommentCount:(NSInteger)count {
    if (count) {
        if(count < 10000) {
            return [NSString stringWithFormat:@"%ld",(long)count];
        }else {
            return [NSString stringWithFormat:@"%.1fw",count/10000.0f];
        }
    }else{
        return  @"评论";
    }
}


+ (NSString *)hkWifiName {
    NSString *ssid = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"SSID"]) {
            ssid = info[@"SSID"];
        }
    }
    return ssid;
}





// 阿拉伯转汉字
+ (NSString *)translation:(NSString *)arebic

{   NSString *str = arebic;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]])
        {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
            {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            }else
            {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum])
            {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    
    NSString *sumStr = [sums  componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    //NSLog(@"str %@",str);
    //NSLog(@"chinese %@",chinese);
    return chinese;
}


@end


