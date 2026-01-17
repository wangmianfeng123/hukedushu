//
//  HKDownloadModel.m
//  DownLoader
//
//  Created by bfec on 17/3/8.
//  Copyright © 2017年 com. All rights reserved.
//

#import "HKDownloadModel.h"

//-------------- 沙盒缓存目录 ---------------//
#define kLibraryCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

@implementation HKDownloadModel

- (NSInteger)directSort {
    
    // 更新序列 保持格式一致 mark 20170115
    if (!_directSort) {
        // 更新序列
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        //获取当前时间
        NSDate *dateNow = [NSDate date];
        NSString *dateString = [formatter stringFromDate:dateNow];
        _directSort = [dateString integerValue];
    }
    return _directSort;
}

- (NSMutableArray<HKDownloadModel *> *)children {
    if (_children == nil) {
        _children = [NSMutableArray array];
    }
    return _children;
}

- (NSString *)category {
    return _category.length? _category : _video_application;
}

- (NSString *)hardLevel {
    return _hardLevel.length? _hardLevel : _viedeo_difficulty;
}

- (NSString *)videoDuration {
    return _videoDuration.length? _videoDuration : _video_duration;
}

- (NSString *)name {
    return _name.length? _name : _title;
}

- (NSString *)imageUrl {
    return _imageUrl.length? _imageUrl : _img_cover_url;
}

- (int)videoType {
    if (!_videoType) {
        return _video_type;
    }else {
        return _videoType;
    }
}

- (int)video_type {
    if (!_video_type) {
        return _videoType;
    }else {
        return _video_type;
    }
}


- (NSString *)video_url {
    return _video_url.length? _video_url : _videoUrl.length? _videoUrl : _url;
}

- (NSString *)videoUrl {
    return _videoUrl.length? _videoUrl : _video_url.length? _video_url : _url;
}

- (NSString *)url {
    return _url.length? _url : _video_url.length? _video_url : _videoUrl;
}

- (NSString *)videoId {
    if (_videoId == nil) {
        return _video_id;
    }else {
        return _videoId;
    }
}

- (NSString *)video_id {
    if (_video_id == nil) {
        return _videoId;
    }else {
        return _video_id;
    }
}


- (NSString *)userID {
    
    if (_userID == nil) {
        _userID = [HKAccountTool shareAccount].ID;
        _userID = _userID.length? _userID : @"";
    }
    return _userID;
}

- (id)initWithSegments:(NSMutableArray *)segments
{
    if (self = [super init])
    {
        self.segments = segments;
    }
    return self;
}

- (HKSegmentModel *)getSegmentByIndex:(int)index
{
    if (index < [self.segments count] && index >= 0)
    {
        return [self.segments objectAtIndex:index];
    }
    return nil;
}


- (NSString *)getM3U8LocalUrlWithVideoUrl:(NSString *)videoUrl
{
    NSString *m3u8Path = [self getMP4LocalUrlWithVideoUrl:videoUrl];
    m3u8Path = [m3u8Path stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    BOOL isDirectory = YES;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:m3u8Path isDirectory:&isDirectory];
    if (!exist)
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:m3u8Path withIntermediateDirectories:NO attributes:nil error:&error];
        if (!error)
        {
            return m3u8Path;
        }
    }
    else
    {
        return m3u8Path;
    }
    return nil;
}


- (NSString *)getMP4LocalUrlWithVideoUrl:(NSString *)videoUrl
{
    if (videoUrl == nil || [videoUrl isEqualToString:@""])
    {
        return nil;
    }
    else{
        if ([videoUrl length] > 7 && [videoUrl containsString:@"http://"])
        {
            NSString *subStr = [videoUrl substringFromIndex:7];
            subStr = [subStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
            subStr = [@"download" stringByAppendingPathComponent:subStr];
            //subStr = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:subStr];
            subStr = [kLibraryCache stringByAppendingPathComponent:subStr];
            return subStr;
        }
        return nil;
    }
}


@end
