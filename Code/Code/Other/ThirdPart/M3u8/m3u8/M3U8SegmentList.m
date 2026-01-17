//
//  M3U8SegmentList.m
//  DownLoader
//
//  Created by bfec on 17/3/8.
//  Copyright © 2017年 com. All rights reserved.
//

#import "M3U8SegmentList.h"
#import "DownloadManager+Utils.h"

@implementation M3U8SegmentList

- (id)initWithSegments:(NSMutableArray *)segments
{
    if (self = [super init])
    {
        self.segments = segments;
    }
    return self;
}

- (M3U8SegmentInfo *)getSegmentByIndex:(int)index
{
    if (index < [self.segments count] && index >= 0)
    {
        return [self.segments objectAtIndex:index];
    }
    return nil;
}

- (void)setVideoUrl:(NSString *)videoUrl
{
    _videoUrl = [videoUrl copy];
    
    //NSString *tsFullPath = [videoUrl stringByDeletingLastPathComponent];
    
    //截取主路径
    NSString *baseTempUrl = videoUrl;
    NSRange  baseurlRange = [baseTempUrl rangeOfString:@".com"];
    NSString *baseUrl = [baseTempUrl substringToIndex:baseurlRange.location+4];
    
    NSString *m3u8Path = [DownloadManager getM3U8LocalUrlWithVideoUrl:videoUrl];
    for (M3U8SegmentInfo *segment in self.segments)
    {
        NSString *tempStr = [segment.url  stringByReplacingOccurrencesOfString:@"/" withString:@"_"];;
        NSString *tsPath = [m3u8Path stringByAppendingPathComponent:tempStr];
        tsPath = [tsPath stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        segment.localUrl = tsPath;
        
#pragma mark - 将主路径和子路径拼接
        NSString *tmpTsFullPath = [baseUrl stringByAppendingPathComponent:segment.url];
        
        tmpTsFullPath = [tmpTsFullPath stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        segment.url = tmpTsFullPath;
    }
}

@end
