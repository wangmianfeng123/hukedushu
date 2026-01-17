//
//  HKM3U8FileDownLoadOperation.m
//  Code
//
//  Created by Ivan li on 2020/1/14.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKM3U8FileDownLoadOperation.h"
#import "HKSegmentModel.h"


@interface HKM3U8FileDownLoadOperation (){
    BOOL hasStart;
}

@property (nonatomic, strong) HKSegmentModel *fileInfo;
@property (nonatomic, copy) HKM3U8FileDownLoadOperationResultBlock resultBlock;
@property (nonatomic, weak) AFURLSessionManager *sessionManager;
@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@property (nonatomic, strong) NSURLSessionDownloadTask *dataTask;

@end

@implementation HKM3U8FileDownLoadOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithFileInfo:(HKSegmentModel *)fileInfo sessionManager:(AFURLSessionManager*)sessionManager resultBlock:(HKM3U8FileDownLoadOperationResultBlock)resultBlock{
    //NSParameterAssert(fileInfo);
    self = [super init];
    if (self) {
        _fileInfo = fileInfo;
        _resultBlock = resultBlock;
        _sessionManager = sessionManager;
    }
    return self;
}

#pragma mark -
- (void)start
{
    //实现
    @synchronized (self) {
        if (self.isCancelled || self.isFinished) {
        //if (self.isCancelled) {
            self.finished = YES;
            [self reset];
            return;
        }
        ///file already exit
//        if([BNFileManager exitItemWithPath:_fileInfo.dstFilePath]){
//            _resultBlock(nil,_fileInfo);
//            [self done];
//            return;
//        }
        
        hasStart = YES;
        __block NSDate *lastTime = [NSDate date];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_fileInfo.url]];
        @weakify(self);
        NSURLSessionDownloadTask *downloadTask = [self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            @strongify(self);
            NSString *filePath = [NSString stringWithFormat:@"%@%@", HKDocumentPath, self.fileInfo.localUrl];
            NSURL *fileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
            return fileURL;
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            @strongify(self);
            @synchronized (self) {
                if (!error) {
                    /// 下载速率
                    NSTimeInterval time = [DateChange secondWithStarDate:lastTime endDate:[NSDate date]];
                    NSData *data = [NSData dataWithContentsOfURL:filePath];
                    if (time >0) {
                        CGFloat rate = floor([data length]/1024);
                        rate = floor(rate/time);// KB
                        self.fileInfo.segmentRate = rate;
                    }
                    
                    //[weakSelf saveData:data];
                    if(self.resultBlock) self.resultBlock(nil,self.fileInfo);
                    [self done];
                }
                else {
                    if(self.resultBlock) self.resultBlock(error,self.fileInfo);
                    [self done];
                }
            }
        }];
        self.dataTask = downloadTask;
        [downloadTask resume];
        self.executing = YES;
    }
}



- (void)cancel{
    @synchronized (self) {
        if(self.isFinished) return;
        [super cancel];
        [self.dataTask cancel];
        if (self.isExecuting) self.executing = NO;
        if (!self.isFinished) self.finished = YES;
        [self reset];
    }
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset {
    @synchronized (self) {
        self.dataTask = nil;
        self.fileInfo = nil;
    }
}

#pragma mark - need to realize kvo
- (void)setFinished:(BOOL)finished {
    if (!hasStart) return;
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    if (!hasStart) return;
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)dealloc {
    //NSLog(@"HKM3U8FileDownLoadOperation");
    
}


//- (void)saveData:(NSData *)data {
//    [[BNFileManager shareInstance] saveDate:data ToFile:[_fileInfo dstFilePath] completaionHandler:^(NSError *error) {
//        @synchronized (self) {
//            if (!error) {
//                if(self.resultBlock) self.resultBlock(nil,self.fileInfo);
//            }
//            else
//            {
//                if(self.resultBlock) self.resultBlock(error, self.fileInfo);
//            }
//            [self done];
//        }
//    }];
//}


@end

