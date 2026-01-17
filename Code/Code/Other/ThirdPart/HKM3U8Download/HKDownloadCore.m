//
//  HKDownloadCore.h
//  Code
//
//  Created by hanchuangkeji on 2017/12/18.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "HKDownloadCore.h"
#import "HKDownloadManager.h"
#import "HKM3U8Parse.h"

#import "HKM3U8FileDownLoadOperation.h"
#import "HKDownloadOperationModel.h"


#define LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define UNLOCK(lock) dispatch_semaphore_signal(lock);

#define HKDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

@interface HKDownloadCore()<NSURLSessionTaskDelegate>

@property (nonatomic, strong)HKDownloadModel *downloadModel;
// 再次下载失败的segment
@property (nonatomic, strong)NSMutableArray<HKSegmentModel *> *failSegments;
// 失败重试次数
@property (nonatomic, assign)NSInteger downloadFailAgainCount;

// 自定义taskCount（background session config初始化就有36个task）
@property (nonatomic, assign)int taskCount;

@property (nonatomic, assign)int finishTaskCount;

@property (nonatomic, strong)NSProgress *progress;

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@property (nonatomic, strong) HKM3U8DownloadConfig *config;
@property (nonatomic, copy) NSString *downloadDstRootPath;
@property (nonatomic, copy) BNM3U8DownloadOperationResultBlock resultBlock;
@property (nonatomic, copy) BNM3U8DownloadOperationProgressBlock progressBlock;
//@property (nonatomic, strong) NSMutableDictionary <NSString*,HKM3U8FileDownLoadOperation*> *downloadOperationsMap;
@property (nonatomic, strong) NSMutableArray  *downloadOperationsMap;

//@property (nonatomic, strong) BNM3U8PlistInfo *plistInfo;
@property (nonatomic, strong) dispatch_semaphore_t operationSemaphore;

@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@property (nonatomic, strong) dispatch_semaphore_t downloadResultCountSemaphore;
@property (nonatomic, assign) NSInteger downloadSuccessCount;
@property (nonatomic, assign) NSInteger downloadFailCount;
@property (nonatomic, weak) AFURLSessionManager *sessionManager;

@property (nonatomic, strong)NSDate *lastTime;

@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;

@end


@implementation HKDownloadCore

///告诉编译器合成get set
@synthesize executing = _executing;
@synthesize finished = _finished;

- (NSProgress *)progress {
    if (_progress == nil) {
        NSProgress *progress = [NSProgress progressWithTotalUnitCount:1.0 * 100];
        _progress = progress;
    }
    return _progress;
}

- (instancetype)init {
    if (self = [super init]) {
        self.downloadFailAgainCount = 0;
    }
    return self;
}

- (NSMutableArray<HKSegmentModel *> *)failSegments {
    if (_failSegments == nil) {
        _failSegments = [NSMutableArray array];
    }
    return _failSegments;
}



/** 更新 下载Model 重新下载 */
- (void)updateSegmentsURLDownload {
    // 继续完成尚未失败的task 更新segment的url, 防止过期2
    [[HKDownloadManager class] updateSegmentsURLSave:self.downloadModel block:^(BOOL completed, HKDownloadModel *model) {

        if (model) {
            LOCK(self.operationSemaphore);
            self.downloadModel = model;
            UNLOCK(self.operationSemaphore);
            [self failSegmentDownloadWithRestart:YES];
        }else{
            // 失败
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didFailedDownload:self.downloadModel];
            });
            [self done];
        }
    }];
}



/** 生成u3m8文件*/
- (void)createM3U8File {
    
    [HKM3U8Parse createM3U8File:self.downloadModel.url videoType:self.downloadModel.videoType segmentList:self.downloadModel finish:^(BOOL success) {
        LOCK(self.operationSemaphore);
        if (success) {
            // 执行代理
            self.downloadModel.isFinish = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didFinishedDownload:self.downloadModel];
            });
        } else {
            // 失败
            self.downloadModel.isFinish = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didFailedDownload:self.downloadModel];
            });
        }
        UNLOCK(self.operationSemaphore);
        [self done];
    }];
}


- (void)getNetKeyAndCreateKeyFile {
    if (self.failSegments.count > 0) {
        
        switch (self.downloadFailAgainCount) {
            case 0:
            {// 只下载失败的切片
                [self failSegmentDownloadWithRestart:NO];
//                if (DEBUG) {
//                    [self updateSegmentsURLDownload];
//                }
            }
                break;
            case 1:
            {// 更新下载 Model 再下载
                [self updateSegmentsURLDownload];
            }
                break;
                
            default: {
                // 失败
                [self didFailedDownload];
            }
                break;
        }
        
    } else if (self.failSegments.count == 0) {
        if (self.downloadModel.segments.count >0) {
            [self createM3U8File];
        }else{
            // 失败
            [self didFailedDownload];
        }
    }else {
        // 失败
        [self didFailedDownload];
    }
}


- (void)didFailedDownload {
    // 失败
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate didFailedDownload:self.downloadModel];
    });
    [self done];
}


- (void)isFinishTask {
    
    if (self.downloadModel.status == HKDownloading && self.finishTaskCount == self.taskCount) {
        [self getNetKeyAndCreateKeyFile];
    }else if (self.downloadModel.status == HKDownloadPause && self.finishTaskCount == self.taskCount) {
        // 暂停代理, 由manager实现了
        [self done];
    }
}



/// 更新进度
- (void)updateProgressPercent:(HKSegmentModel *)segment {
    
    float currentPersent = self.downloadModel.downloadPercent + segment.duration / (self.downloadModel.totalDurations * 1.0);
    self.downloadModel.downloadPercent = currentPersent;
    
    // 浮点型计算有误差
    if (self.downloadModel.downloadPercent >= 0.9999) {
        self.downloadModel.downloadPercent = 0.999;
    }
    
    // 执行不断进行的代理
    self.progress.completedUnitCount = currentPersent * 100;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate download:self.downloadModel progress:self.progress];
        [self.delegate didFinishModel:self.downloadModel Segment:segment];
    });
}




- (instancetype)initWithConfig:(HKM3U8DownloadConfig *)config downloadDstRootPath:(NSString *)path sessionManager:(AFURLSessionManager *)sessionManager progressBlock:(BNM3U8DownloadOperationProgressBlock)progressBlock resultBlock:(BNM3U8DownloadOperationResultBlock)resultBlock downloadModel:(HKDownloadModel *)downloadModel {
    //NSParameterAssert(config);
    //NSParameterAssert(path);
    self = [super init];
    if (self) {
        
        _downloadFailAgainCount = 0;
        _downloadModel = downloadModel;
        _config = config;
        _downloadDstRootPath = path;
        _resultBlock = resultBlock;
        _progressBlock = progressBlock;
        _executing = NO;
        _finished = NO;
        _operationSemaphore = dispatch_semaphore_create(1);
        _downloadResultCountSemaphore = dispatch_semaphore_create(1);
        _downloadQueue = [[NSOperationQueue alloc]init];
        _downloadQueue.maxConcurrentOperationCount = self.config.maxConcurrenceCount;
        _downloadOperationsMap = NSMutableArray.new;
        _sessionManager = sessionManager;
        //_backgroundTaskId = UIBackgroundTaskInvalid;
    }
    return self;
}

- (void)start {
    //实现
    @synchronized (self) {
        if (self.isCancelled || self.finished) {
            self.finished = YES;
            [self reset];
            return;
        }
//        if (![self tryCreateRootDir]) {
//            NSError *error = [NSError errorWithDomain:@"创建文件目录失败" code:100 userInfo:nil];
//            self.resultBlock(error, nil);
//            [self done];
//            return;
//        }
        
//        Class UIApplicationClass = NSClassFromString(@"UIApplication");
//        BOOL hasApplication = UIApplicationClass && [UIApplicationClass respondsToSelector:@selector(sharedApplication)];
//        if (hasApplication) {
//            __weak __typeof__ (self) wself = self;
//            UIApplication * app = [UIApplicationClass performSelector:@selector(sharedApplication)];
//            self.backgroundTaskId = [app beginBackgroundTaskWithExpirationHandler:^{
//                //[wself cancel];
//            }];
//        }
        
        [self startDownload];
    }
    /// 目前没有重新发起的功能， 所以只会在这里设置execut
    self.executing = YES;
}



- (void)startDownload {
    
    if (self.downloadModel.isFinish) {
        // 已经完成
        [self.delegate didFinishedDownload:self.downloadModel];
    } else {
        // 开始下载
        self.taskCount = 0;
        self.finishTaskCount = 0;
                    
        for (HKSegmentModel *segment in self.downloadModel.segments) {
            if (!segment.isFinish) {
                [self createLoadOperation:segment];
            }
        }
        [self tryCallBack];
    }
}


/// 失败的重新下载
/// @param isRestart isRestart 从新下载，覆盖原来的
- (void)failSegmentDownloadWithRestart:(BOOL)isRestart {
    
    LOCK(self.operationSemaphore);
    self.taskCount = 0;
    self.finishTaskCount = 0;
    UNLOCK(self.operationSemaphore);
    
    if (isRestart) {
        for (HKSegmentModel *segment in self.downloadModel.segments) {
            if (!segment.isFinish) {
                [self createLoadOperation:segment];
            }
        }
    }else{
        for (HKSegmentModel *segment in self.failSegments) {
            if (!segment.isFinish) {
                [self createLoadOperation:segment];
            }
        }
    }
    
    LOCK(self.operationSemaphore);
    [self.failSegments removeAllObjects];
    self.downloadFailAgainCount ++;
    UNLOCK(self.operationSemaphore);
}


- (void)createLoadOperation:(HKSegmentModel *)segment {
    @weakify(self);
     HKM3U8FileDownLoadOperation *operation = [[HKM3U8FileDownLoadOperation alloc]initWithFileInfo:segment sessionManager:self.sessionManager resultBlock:^(NSError * _Nullable error, HKSegmentModel * _Nullable info) {

        @strongify(self);
        if (self) { //需要判断是否为空，由于AFURLSessionManager session不会nil, 因此当有的下载回调回来时，self可能为空;
            
            LOCK(self.operationSemaphore);
            // 下载回调后 清除下载URL
            [self removeOperationFormMapWithUrl:segment.url];
            UNLOCK(self.operationSemaphore);
            
            LOCK(self.downloadResultCountSemaphore);
            // 完成的任务数 (包含失败和成功)
            self.finishTaskCount++;
            [self setDownloadRate:info];
            
//            if (DEBUG) {
//                if (10 == self.finishTaskCount || 11 == self.finishTaskCount || 12 == self.finishTaskCount ) {
//                    error = [NSError errorWithDomain:@"hkNetworkLoss" code:1000 userInfo:nil];
//                }
//            }
            if (error) {
                [self acceptFileDownloadResult:NO segment:segment];
            }
            else{
                [self acceptFileDownloadResult:YES segment:nil];
                [self updateProgressPercent:segment];
            }
            UNLOCK(self.downloadResultCountSemaphore);
            [self tryCallBack];
        }
    }];
    
    LOCK(self.operationSemaphore);
     self.taskCount++;
    
     HKDownloadOperationModel * operationM = [[HKDownloadOperationModel alloc] init];
     operationM.url = segment.url;
     operationM.opration = operation;
     [self.downloadOperationsMap addObject:operationM];

    //[self.downloadOperationsMap setValue:operation forKey:segment.url];
     if (operation.isFinished || operation.isCancelled) {
     }
     [self.downloadQueue addOperation:operation];
    UNLOCK(self.operationSemaphore);
}




- (void)cancel{
    ///@synchronized (self) 内部是用递归锁实现的，可以嵌套使用
    @synchronized (self) {
        if(self.finished) return;
        [super cancel];
        LOCK(_operationSemaphore);
        
        NSLog(@"cancel =======  %ld ====== %ld",self.downloadModel.segments.count ,self.downloadOperationsMap.count);
//        for (HKSegmentModel *obj in self.downloadModel.segments) {
//            HKM3U8FileDownLoadOperation *operation = [self.downloadOperationsMap valueForKey:obj.url];
//            if (operation && !operation.isCancelled) {
//                [operation cancel];
//            }
//
//            if([self.downloadOperationsMap valueForKey:obj.url]){
//                [self.downloadOperationsMap removeObjectForKey:obj.url];
//            }
//        }
        
        
        
        for (int i = 0; i < self.downloadOperationsMap.count; i++) {
            HKDownloadOperationModel * operationM = self.downloadOperationsMap[i];
            
            HKM3U8FileDownLoadOperation *operation = operationM.opration;
            if (operation && !operation.isCancelled) {
                [operation cancel];
            }
            [self.downloadOperationsMap removeObject:operationM];
        }
        
        
        
        
//        for (NSString * url in [self.downloadOperationsMap allKeys]) {
//            HKM3U8FileDownLoadOperation *operation = [self.downloadOperationsMap valueForKey:url];
//            if (operation && !operation.isCancelled) {
//                [operation cancel];
//            }
//
//            if([self.downloadOperationsMap valueForKey:url]){
//                [self.downloadOperationsMap removeObjectForKey:url];
//            }
//        }
        
                
        NSLog(@"cancel =======  %ld ====== %ld",self.downloadModel.segments.count ,self.downloadOperationsMap.count);
        
        UNLOCK(_operationSemaphore);
        
        if(self.executing) self.executing = NO;
        if(!self.finished) self.finished = YES;
        [self reset];
    }
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset {
    LOCK(self.operationSemaphore);
    [self.downloadOperationsMap removeAllObjects];
    UNLOCK(self.operationSemaphore);
    
    @synchronized (self) {
        self.downloadSuccessCount = 0;
        self.downloadFailCount = 0;
        self.downloadFailAgainCount = 0;
        
//        if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
//            UIApplication * app = [UIApplication performSelector:@selector(sharedApplication)];
//            [app endBackgroundTask:self.backgroundTaskId];
//            self.backgroundTaskId = UIBackgroundTaskInvalid;
//        }
    }
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent {
    return YES;
}

#pragma mark - 移除下载
- (void)removeOperationFormMapWithUrl:(NSString *)url
{
    for (int i = 0; i < self.downloadOperationsMap.count; i++) {
        HKDownloadOperationModel * operationM = self.downloadOperationsMap[i];
        if ([operationM.url isEqual:url]) {
            [self.downloadOperationsMap removeObject:operationM];
        }
    }
    
//    if([self.downloadOperationsMap valueForKey:url]){
//        [self.downloadOperationsMap removeObjectForKey:url];
//    }
}

- (void)acceptFileDownloadResult:(BOOL)success  segment:(HKSegmentModel *)segment {
    if (success) {
        self.downloadSuccessCount += 1;
    }
    else{
        self.downloadFailCount += 1;
        [self.failSegments addObject:segment];
    }
}



- (void)tryCallBack {
    // 检测下载是否完成 生成m3u8索引文件
    [self isFinishTask];
}



- (void)setSuspend:(BOOL)suspend
{
    _suspend = suspend;
    _downloadQueue.suspended = _suspend;
}



/// 设置下载速率
- (void)setDownloadRate:(HKSegmentModel *)info {
    CGFloat rate = info.segmentRate;
    NSString *str = nil;
    if (rate >=1024) { //M
        rate = rate/1024;
        str = [NSString stringWithFormat:@"%.1fM/s",rate];
    }else{
        str = [NSString stringWithFormat:@"%.fKB/s",rate];
    }
    self.downloadModel.downloadRate = rate;
    self.downloadModel.rateStr = str;
}


- (void)dealloc {
    NSLog(@"HKDownloadCore");
}


//- (BOOL)tryCreateRootDir
//{
//    return  [BNFileManager tryGreateDir:[self.downloadDstRootPath stringByAppendingPathComponent:[BNTool uuidWithUrl:self.config.url]]];
//}


@end
