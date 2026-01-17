//
//  M3U8SegmentDownloader.m
//  DownLoader
//
//  Created by bfec on 17/3/9.
//  Copyright © 2017年 com. All rights reserved.
//

#import "M3U8SegmentDownloader.h"
#import "M3U8SegmentDownloader+Helper.h"
#import "AppDelegate.h"

static M3U8SegmentDownloader *instance;

@interface M3U8SegmentDownloader ()

@property (nonatomic,strong) M3U8SegmentInfo *segment;

@end

@implementation M3U8SegmentDownloader

+ (id)shareInstance
{
    static dispatch_once_t token3;
    dispatch_once(&token3, ^{
        instance = [[M3U8SegmentDownloader alloc] init];
    });
    return instance;
}

- (void)startDownload:(M3U8SegmentInfo *)segment withResumeData:(NSString *)resumeData
{
    self.segment = segment;
    __weak M3U8SegmentInfo *weakSegment = segment;

//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:segment.url]];
//    NSURLSessionConfiguration *sessionCon = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:segment.url];
//    self.urlSession = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionCon];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:segment.url]];
    assert(self.urlSession != nil);
    
    
    [self.urlSession setDownloadTaskDidFinishDownloadingBlock:^NSURL * _Nullable(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, NSURL * _Nonnull location) {
        
        NSString *tsFilePath = [NSString stringWithFormat:@"%@.ts",weakSegment.localUrl];
        return [NSURL fileURLWithPath:tsFilePath];
    }];
    
    NSURLSessionDownloadTask *task = [self.urlSession downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {

                                                                             if ([self.delegate respondsToSelector:@selector(m3u8SegmentDownloader:downloadingUpdateProgress:)])
                                                                             {
                                                                                 [self.delegate m3u8SegmentDownloader:self downloadingUpdateProgress:downloadProgress];
                                                                             }
                                                                         }
                                                                      destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                                          
                                                                          NSString *tsFilePath = [NSString stringWithFormat:@"%@.ts",weakSegment.localUrl];
                                                                          return [NSURL fileURLWithPath:tsFilePath];
                                                                      }
                                                                completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                                    [self _dealFinishOrFailedSegment:segment error:error];
                                                                }];
    [task resume];
    
     if ([self.delegate respondsToSelector:@selector(m3u8SegmentDownloader:downloadingBegin:task:)])
     {
        [self.delegate m3u8SegmentDownloader:self downloadingBegin:segment task:task];
     }
}


- (void)_dealFinishOrFailedSegment:(M3U8SegmentInfo *)segment error:(NSError *)error
{
    if (error)
    {
        //modify yang 手动暂停的
        if ([[error.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"cancelled"])
        {
            NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
            if ([self.delegate respondsToSelector:@selector(m3u8SegmentDownloader:downloadingPause:resumeData:)])
            {
                [self.delegate m3u8SegmentDownloader:self downloadingPause:segment resumeData:resumeData];
            }
        }
        else {
            //下载出现错误
            //NSLog(@"m3u8 --下载出现错误");
            if ([self.delegate respondsToSelector:@selector(m3u8SegmentDownloader:downloadFailed:)])
            {
                [self.delegate m3u8SegmentDownloader:self downloadFailed:error];
            }
        }
    }
    else//finish
    {
        if ([self.delegate respondsToSelector:@selector(m3u8SegmentDownloader:downloadingFinished:)])
        {
            [self.delegate m3u8SegmentDownloader:self downloadingFinished:segment];
        }
    }
}


#pragma mark - 暂停下载 在表中插入暂停 时状态
- (void)pauseDownloadWithResumeData:(NSData *)resumeData downloadIndex:(NSInteger)index downloadSize:(NSInteger)downloadSize url:(NSString *)url  allTsAcount:(NSInteger)allTsAcount
{
    NSString *resumeDataStr = [[NSString alloc] initWithData:resumeData encoding:NSUTF8StringEncoding];
    if (!isEmpty(url)) {
        NSDictionary *m3u8Info = @{@"videoUrl":url,
                                   @"m3u8AlreadyDownloadSize":@(downloadSize),
                                   @"tsDownloadTSIndex":@(index),
                                   @"resumeData":resumeDataStr,
                                   @"allTsAcount":@(allTsAcount),
                                   @"userID":[CommonFunction getUserId]};
        if (m3u8Info != nil) {
            [self.downloadCacher insertM3U8Record:m3u8Info];
        }
    }
}






@end
