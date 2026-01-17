//
//  M3U8Analyser.m
//  DownLoader
//
//  Created by bfec on 17/3/8.
//  Copyright © 2017年 com. All rights reserved.
//

#define NSErrorCustomDomain @"NSErrorCustomDomain"

#import "M3U8Analyser.h"


@implementation M3U8Analyser


- (M3U8SegmentList *)analyseVideoUrl:(NSString *)videoUrl error:(NSError *__autoreleasing *)error
{
    
    NSLog(@"videoUrl1111 =%@", videoUrl);
    if ([videoUrl containsString:@"http:"] || [videoUrl containsString:@"https:"]) {
        
    }else{
        return nil;
    }
    
    //截取主路径
    NSString *baseTempUrl = videoUrl;
    NSRange  baseurlRange = [baseTempUrl rangeOfString:@".com"];
    self.baseUrl = [baseTempUrl substringToIndex:baseurlRange.location+4];
    
    if ([videoUrl isEqualToString:@""] || videoUrl == nil)
    {
        //NSLog(@"videoUrl must not nil or empty!");
        NSDictionary *userInfo = @{@"errorDes":@"videoUrl must not nil or empty!"};
        *error = [NSError errorWithDomain:NSErrorCustomDomain code:-111 userInfo:userInfo];
        return nil;
    }
    NSURL *url = [NSURL URLWithString:videoUrl];
    NSError *err = nil;
    NSString *m3u8Str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
    
    if (err){
        //NSLog(@"videoUrl error --- %@",videoUrl);
        NSDictionary *userInfo = err.userInfo;
        *error = [NSError errorWithDomain:NSErrorCustomDomain code:-222 userInfo:userInfo];
        return nil;
    }
    
    //NSLog(@"videoUrl --- %@",videoUrl);
    return [self _analyseWithM3U8Str:m3u8Str videoUrl:videoUrl];
}


- (M3U8SegmentList *)_analyseWithM3U8Str:(NSString *)m3u8Str videoUrl:(NSString *)videoUrl
{
    
    NSMutableArray *segments = [[NSMutableArray alloc] init];
    NSString* tempM3u8Str = m3u8Str;
    
    //解析TS文件
    NSRange segmentRange = [tempM3u8Str rangeOfString:@"#EXTINF:"];
    if (segmentRange.location == NSNotFound) {
        //M3U8里没有TS文件
        return nil;
    }
    
    NSString *temp = [tempM3u8Str substringFromIndex:segmentRange.location];
    tempM3u8Str = temp;

    
    //读取URI：
    NSString *urlKey = temp;
    NSRange urlRange = [urlKey rangeOfString:@"URI="];
    urlKey = [urlKey substringFromIndex:urlRange.location];
    NSRange httpRange = [urlKey rangeOfString:@","];
    NSString* urlvalue = nil;
    if (httpRange.location != NSNotFound) {
        urlvalue = [urlKey substringWithRange:NSMakeRange([@"URI=" length]+1, httpRange.location - 6)];
    }
    
    //逐个解析TS文件，并存储
    NSInteger segmentIndex = 0;
    double totalSeconds = 0;
    while (segmentRange.location != NSNotFound) {
        
        M3U8SegmentInfo *segment = [[M3U8SegmentInfo alloc] init];
        //读取TS片段时长
        NSRange commaRange = [tempM3u8Str rangeOfString:@","];
        NSString* value = [tempM3u8Str substringWithRange:NSMakeRange([@"#EXTINF:" length], commaRange.location - [@"#EXTINF:" length])];
        segment.duration = [value intValue];
        totalSeconds+=segment.duration;
        //截取M3U8
        tempM3u8Str = [tempM3u8Str substringFromIndex:commaRange.location];
        //获取TS下载链接,这需要根据具体的M3U8获取链接
        NSRange linkRangeBegin = [tempM3u8Str rangeOfString:@","];
        
        NSRange linkRangeEnd = [tempM3u8Str rangeOfString:@"#EXT-X-KEY"];
        NSString* linkUrl = nil;
        NSString *downUrl = nil;
        
        if (linkRangeEnd.location == NSNotFound) {
            NSRange linkRangeComplete = [tempM3u8Str rangeOfString:@"#EXT-X-ENDLIST"];
            linkUrl = [tempM3u8Str substringWithRange:NSMakeRange(linkRangeBegin.location + 2, linkRangeComplete.location-3)];
            
            //downUrl = [NSString stringWithFormat:@"%@%@",self.baseUrl,linkUrl];
            downUrl = [self removeSpaceAndNewlineAndOtherFlag:linkUrl];
            
        }else{
            linkUrl = [tempM3u8Str substringWithRange:NSMakeRange(linkRangeBegin.location + 2, linkRangeEnd.location-3)];
            //downUrl = [NSString stringWithFormat:@"%@%@",self.baseUrl,linkUrl];
            downUrl = [self removeSpaceAndNewlineAndOtherFlag:linkUrl];
        }
        
        segment.url = downUrl;
        segment.shortUrl = downUrl;
        segmentIndex++;
        [segments addObject:segment];
        segmentRange = [tempM3u8Str rangeOfString:@"#EXTINF:"];
        if (segmentRange.location != NSNotFound) {
            tempM3u8Str = [tempM3u8Str substringFromIndex:(segmentRange.location)];
        }
    }
    
    M3U8SegmentList *segmentList = [[M3U8SegmentList alloc] initWithSegments:segments];
    segmentList.totalDurations = totalSeconds;
    segmentList.videoUrl = videoUrl;
    segmentList.keyUrl = urlvalue; //密钥
    return segmentList;
}




- (NSString *)removeSpaceAndNewlineAndOtherFlag:(NSString *)str {
    
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"," withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    return temp;
}















@end
