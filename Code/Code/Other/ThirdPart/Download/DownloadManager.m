//
//  DownloadManager.m
//  DownLoader
//
//  Created by bfec on 17/2/14.
//  Copyright © 2017年 com. All rights reserved.
//

#import "DownloadManager.h"
#import "AppDelegate.h"
#import "DownloadManager+Helper.h"
#import "DownloadManager+Utils.h"
#import "DownloadCacher+M3U8.h"
#import "DownloadManager_M3U8.h"
  
#import "StudyVedioRecord.h"
//#import <AFHTTPSessionManager.h>
#import "UIDeviceHardware.h"
#import "HKDownloadModel.h"
#import "HKDownloadManager.h"



static DownloadManager *instance;

@interface DownloadManager ()<DownloadManager_M3U8_Delegate, HKDownloadManagerDelegate>

@property (nonatomic,strong) DownloadModel *downloadingModel;
@property (nonatomic,strong) DownloadManager_M3U8 *m3u8DownloadManager;
@property (nonatomic,assign) UIBackgroundTaskIdentifier bgTask;

@end

@implementation DownloadManager



+ (id)shareInstance
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[DownloadManager alloc] init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
        
//        NSURLSessionConfiguration * configurationSession = [NSURLSessionConfiguration backgroundSessionConfiguration:@"backgroundSession"];
//        AFHTTPSessionManager *_currentSessionManager =  [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configurationSession];
//        NSURLSessionDownloadTask * downloadTask = [_currentSessionManager downloadTaskWithRequet]
    
        NSURLSessionConfiguration *scf = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.cainiu.HuKeWang"];
        scf.sessionSendsLaunchEvents = YES;
        
        //scf.discretionary = YES;
        scf.discretionary = NO; //系统自动选择最佳网络下载
        scf.timeoutIntervalForRequest = 20;
        scf.allowsCellularAccess = YES;
        self.urlSession = [[AFURLSessionManager alloc] initWithSessionConfiguration:scf];
        
        
        [self.urlSession setDidFinishEventsForBackgroundURLSessionBlock:^(NSURLSession * _Nonnull session) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if (appDelegate.backgroundSessionCompletionHandler)
            {
                appDelegate.backgroundSessionCompletionHandler();
                appDelegate.backgroundSessionCompletionHandler = nil;
            }
        }];
        
        self.downloadCacher = [DownloadCacher shareInstance];
        [StudyVedioRecord shareInstance];//初始化t_study_video
        [self _checkOrCreateDownloadFolder];
        [self initM3U8];
        [self _networkObserver];
        
        self.bgTask = UIBackgroundTaskInvalid;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onEnterForegound)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}





 
 - (void)_onEnterForegound
 {
    if (self.bgTask != UIBackgroundTaskInvalid)
    {
    [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
    }
    self.bgTask = UIBackgroundTaskInvalid;
 }
 
 - (void)_onEnterBackground
 {
     UIApplication* application = [UIApplication sharedApplication];
     
     self.bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
     [application endBackgroundTask:self.bgTask];
     self.bgTask = UIBackgroundTaskInvalid;
     }];
 }
 


- (DownloadManager_M3U8 *)m3u8DownloadManager
{
    if (!_m3u8DownloadManager)
    {
        _m3u8DownloadManager = [DownloadManager_M3U8 shareInstance];
    }
    return _m3u8DownloadManager;
}


#pragma mark - 下载队列数量改变通知
- (void)downloadingChangeNotification {
    
     NSMutableArray *downladed =  [self.downloadCacher selectNoDownloadModels];
    __block NSDictionary *dict = nil;
    if (downladed.count>0) {
        dict =  @{KdownloadCount: [NSString stringWithFormat:@"%lu",(unsigned long)downladed.count],KdownloadArray:downladed};
    }else{
        dict =  @{KdownloadCount: [NSString stringWithFormat:@"%lu",(unsigned long)downladed.count]};
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MyNotification postNotificationName:KdownloadingChangeNotification object:nil userInfo:dict];
    });
}

- (void)beginDownload:(HKDownloadModel *)model {
    NSLog(@"%s", __func__);
}
- (void)download:(HKDownloadModel *)model progress:(NSProgress *)progress{
    NSLog(@"%s %lld", __func__, progress.completedUnitCount);
}
- (void)didFailedDownload:(HKDownloadModel *)model {
    NSLog(@"%s", __func__);
}
- (void)didFinishedDownload:(HKDownloadModel *)model {
    NSLog(@"%s", __func__);
}
- (void)didPausedDownload:(HKDownloadModel *)model {
    NSLog(@"%s", __func__);
}
- (void)didDeletedDownload:(HKDownloadModel *)model {
    NSLog(@"%s", __func__);
}


- (void)dealDownloadModel:(DownloadModel *)downloadModel
{
    HKDownloadModel *modelChange = [HKDownloadModel mj_objectWithKeyValues:downloadModel.mj_JSONData];
    [[HKDownloadManager shareInstance] downloadModel:modelChange withDelegate:self];

    return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        DownloadStatus tempStatus = downloadModel.status;
        switch (tempStatus) {
            case DownloadNotExist:
                [self addDownloadModel:downloadModel];
                //[self downloadingChangeNotification];
                break;
            case Downloading:
            {
                [self pauseDownloadModel:downloadModel];
                break;
            }
            case DownloadWating:
            {
                downloadModel.status = DownloadPause;
                [self _changeStatusWithModel:downloadModel];
                break;
            }
            case DownloadPause:
            case DownloadFailed:
            {
                downloadModel.status = DownloadWating;
                [self _changeStatusWithModel:downloadModel];
                break;
            }
            case DownloadFinished:
                break;
            default:
                break;
        }
        [self _tryToOpenNewDownloadTask];
    });
}





- (void)dealExitDownloadModel:(DownloadModel *)downloadModel
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        [self _tryToOpenNewDownloadTask];
    });
}






- (void)initM3U8 {
    
    self.m3u8DownloadManager.delegate = self;
    self.m3u8DownloadManager.downloadCacher = self.downloadCacher;
    self.m3u8DownloadManager.urlSession = self.urlSession;
}



- (void)addDownloadModel:(DownloadModel *)downloadModel
{
    downloadModel.status = DownloadWating;
    BOOL isSucess = [self.downloadCacher insertDownloadModel:downloadModel];
    if (isSucess) {
        [self downloadingChangeNotification];
        [DownloadManager postNotification:DownloadingUpdateNotification andObject:downloadModel];
    }else{
        NSLog(@"插入记录失败");
        return;
    }
}



- (BOOL)pauseDownloadModel:(DownloadModel *)downloadModel
{
    
    __block BOOL isPause = YES;
    if ([self.downloadCacher checkIsExistDownloading])
    {
        if (nil == downloadModel) {
            return isPause;
        }
        
        //NSInteger  downCount = [[self.urlSession downloadTasks] count];
        //NSLog(@"[[self.urlSession downloadTasks] count]   ===   %lu",downCount);
        [[self.urlSession downloadTasks] enumerateObjectsUsingBlock:^(NSURLSessionDownloadTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSURLSessionDownloadTask *task = obj;
            if (task.state == NSURLSessionTaskStateRunning)
            {
                if (downloadModel.isM3u8Url)
                {
                    [task cancel];
                    [[self.urlSession downloadTasks] makeObjectsPerformSelector:@selector(cancel)];
                    downloadModel.status = DownloadPause;
                    [self.downloadCacher updateDownloadModel:downloadModel];
                    [self.m3u8DownloadManager pauseDownloadModel:downloadModel withResumeData:nil];
                    //NSLog(@"停止下载任务");
                }
                else
                {
                    [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                        NSString *resumeDataStr = [[NSString alloc] initWithData:resumeData encoding:NSUTF8StringEncoding];
                        downloadModel.resumeData = resumeDataStr;
                        downloadModel.status = DownloadPause;
                        [self.downloadCacher updateDownloadModel:downloadModel];
                    }];
                }
                *stop = YES;
            }
        }];
        return isPause;
    }else{
        //NSLog(@"NO Download ing task");
        return isPause;
    }
}




//- (void)pauseDownloadModel:(DownloadModel *)downloadModel
//{
//
//    __block BOOL isPause = NO;
//    if ([self.downloadCacher checkIsExistDownloading])
//    {
//        if (nil == downloadModel) {
//            return;
//        }
//        //NSLog(@"[[self.urlSession downloadTasks] count]   ===   %lu",(unsigned long)[[self.urlSession downloadTasks] count]);
//        
//        NSInteger  downCount = [[self.urlSession downloadTasks] count];
//        NSLog(@"[[self.urlSession downloadTasks] count]   ===   %lu",downCount);
//        //if (downCount > 0) {
//            [[self.urlSession downloadTasks] enumerateObjectsUsingBlock:^(NSURLSessionDownloadTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                NSURLSessionDownloadTask *task = obj;
//                if (task.state == NSURLSessionTaskStateRunning)
//                {
//                    if (downloadModel.isM3u8Url)
//                    {
//                        [task cancel];
//                        [[self.urlSession downloadTasks] makeObjectsPerformSelector:@selector(cancel)];
//                        downloadModel.status = DownloadPause;
//                        [self.downloadCacher updateDownloadModel:downloadModel];
//                        [self.m3u8DownloadManager pauseDownloadModel:downloadModel withResumeData:nil];
//                    }
//                    else
//                    {
//                        [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
//                            NSString *resumeDataStr = [[NSString alloc] initWithData:resumeData encoding:NSUTF8StringEncoding];
//                            downloadModel.resumeData = resumeDataStr;
//                            downloadModel.status = DownloadPause;
//                            [self.downloadCacher updateDownloadModel:downloadModel];
//                        }];
//                    }
//                    *stop = YES;
//                }
//            }];
//    }else{
//        //NSLog(@"NO Download ing task");
//        return isPause;
//    }
//}


- (void)_changeStatusWithModel:(DownloadModel *)downloadModel
{
    [self.downloadCacher updateDownloadModel:downloadModel];
    dispatch_async(dispatch_get_main_queue(), ^{
        [DownloadManager postNotification:DownloadingUpdateNotification andObject:downloadModel];
    });
    
}



- (void)deleteDownloadModelArr:(NSArray *)downloadArr
{
    if ([downloadArr containsObject:_downloadingModel])
    {
        NSURLSessionDownloadTask *task = [[self.urlSession downloadTasks] firstObject];
        [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            [self _deleteTmpFileWithResumeData:resumeData];
            _downloadingModel = nil;
        }];
    }
    [self.downloadCacher deleteDownloadModels:downloadArr];
    [self _tryToOpenNewDownloadTask];
}



- (void)_deleteTmpFileWithResumeData:(NSData *)resumeData
{
    NSError *error = nil;
    NSPropertyListFormat format = NSPropertyListXMLFormat_v1_0;
    NSDictionary *dict = [NSPropertyListSerialization propertyListWithData:resumeData options:0 format:&format error:&error];
    if (!error)
    {
        NSString *tmpPath = [dict valueForKey:@"NSURLSessionResumeInfoTempFileName"];
        tmpPath = [NSString stringWithFormat:@"%@/tmp/%@",NSHomeDirectory(),tmpPath];
        BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:tmpPath];
        if (fileExist)
        {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:&error];
            if (!error)
            {
                NSLog(@"删除无用的临时文件成功!");
            }
        }
    }
}


#pragma mark - 开始所有下载任务
- (void)startAllDownload
{
    NSArray *arr = [self.downloadCacher startAllDownloadModels];
    for (DownloadModel *model in arr)
    {
        [DownloadManager postNotification:DownloadingUpdateNotification andObject:model];
    }
    [self _tryToOpenNewDownloadTask];
}


#pragma mark - 暂停所有下载任务
- (void)pauseAllDownload {
    
    [self pauseDownloadModel:_downloadingModel];
    //结束所有下载任务
    [[self.urlSession downloadTasks] enumerateObjectsUsingBlock:^(NSURLSessionDownloadTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLSessionDownloadTask *task = obj;
        if (task.state == NSURLSessionTaskStateRunning)
        {
            [task cancel];
            [[self.urlSession downloadTasks] makeObjectsPerformSelector:@selector(cancel)];
            *stop = YES;
        }
    }];
    NSArray *arr = [self.downloadCacher pauseAllDownloadModels];
    for (DownloadModel *model in arr)
    {
        [DownloadManager postNotification:DownloadingUpdateNotification andObject:model];
    }
}


#pragma mark - 开启下载任务
- (void)_tryToOpenNewDownloadTask
{
    if ([self.downloadCacher checkIsExistDownloading])//存在正在下载
        return;
    DownloadModel *topWaitingModel = [self.downloadCacher queryTopWaitingDownloadModel];
    if (!topWaitingModel)
    {
        //NSLog(@"not find waiting model...");
    }
    else{
        
        topWaitingModel.status = Downloading;
        //[self.downloadCacher updateDownloadModel:topWaitingModel];
        [self _changeStatusWithModel:topWaitingModel]; //更新数据表中记录 并发送更新通知
        
        _downloadingModel = topWaitingModel;
        if (topWaitingModel.isM3u8Url)
        {
            NSDictionary *m3u8Info = [self.downloadCacher queryM3U8Record:topWaitingModel.url];// 查询 m3u8
            [self.m3u8DownloadManager m3u8Downloading:topWaitingModel withInfo:m3u8Info];
        }
        else
        {
            [self _mp4Downloading:topWaitingModel];
        }
    }
}



#pragma mark - MP4下载
- (void)_mp4Downloading:(DownloadModel *)downloadModel
{
    if (downloadModel.resumeData)
    {
        NSData *resumeData = [downloadModel.resumeData dataUsingEncoding:NSUTF8StringEncoding];
        NSURLSessionDownloadTask *task = [self _downloadTaskWithOriginResumeData:resumeData withDownloadModel:downloadModel];
        [task resume];
    }
    else
    {
        NSURLRequest *rq = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadModel.url]];
        NSURLSessionDownloadTask *task = [self.urlSession downloadTaskWithRequest:rq progress:^(NSProgress * _Nonnull downloadProgress) {
            
            downloadModel.downloadPercent = downloadProgress.completedUnitCount / (downloadProgress.totalUnitCount * 1.0);
            [self.downloadCacher updateDownloadModel:downloadModel];
            [DownloadManager postNotification:DownloadingUpdateNotification andObject:downloadModel];
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            return [NSURL fileURLWithPath:[DownloadManager getMP4LocalUrlWithVideoUrl:downloadModel.url]];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            
            [self dealDownloadFinishedOrFailedWithError:error andDownloadModel:downloadModel];
            [self _tryToOpenNewDownloadTask];
        }];
        [task resume];
    }
    [DownloadManager postNotification:DownloadBeginNotification andObject:downloadModel];
}



- (void)_checkOrCreateDownloadFolder
{
    NSString *downloadFolderPath = [NSString stringWithFormat:@"%@/download",kLibraryCache];
    BOOL isDirectory = YES;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:downloadFolderPath isDirectory:&isDirectory];
    if (!exist)
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:downloadFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error)
        {
            //NSLog(@"create downloadFolderPath failed...");
        }
        else
        {
            NSLog(@"create downloadFolderPath successful...");
        }
    }
}




- (void)initializeDownloadModelFromDBCahcher:(DownloadModel *)downloadModel
{
    [[DownloadCacher shareInstance] initializeDownloadModelFromDBCahcher:downloadModel];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNetworkStatusNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceBatteryLevelDidChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceBatteryStateDidChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}




#pragma mark - DownloadManager_M3U8_Delegate

- (void)m3u8Downloader:(DownloadManager_M3U8 *)m3u8Downloader beginDownload:(DownloadModel *)downloadModel segment:(M3U8SegmentInfo *)segment task:(NSURLSessionDownloadTask *)task
{
    self.downloadingModel = downloadModel;
    [DownloadManager postNotification:DownloadBeginNotification andObject:downloadModel];
}

- (void)m3u8Downloader:(DownloadManager_M3U8 *)m3u8Downloader updateDownload:(DownloadModel *)downloadModel progress:(CGFloat)progress
{
    downloadModel.downloadPercent = progress;
    [self.downloadCacher updateDownloadModel:downloadModel];
    [DownloadManager postNotification:DownloadingUpdateNotification andObject:downloadModel];
}

- (void)m3u8Downloader:(DownloadManager_M3U8 *)m3u8Downloader pauseDownload:(DownloadModel *)downloadModel resumeData:(NSData *)resumeData tsIndex:(NSInteger)tsIndex alreadyDownloadSize:(long long)alreadyDownloadSize
{
    [DownloadManager postNotification:DownloadingUpdateNotification andObject:downloadModel];
}


#pragma mark - 下载失败
- (void)m3u8Downloader:(DownloadManager_M3U8 *)m3u8Downloader failedDownload:(DownloadModel *)downloadModel
{
    
//    downloadModel.status = DownloadFailed;
//    [self.downloadCacher updateDownloadModel:downloadModel];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [DownloadManager postNotification:DownloadingUpdateNotification andObject:downloadModel];
//    });
    
    //[DownloadManager postNotification:DownloadingUpdateNotification andObject:downloadModel];
    downloadModel.status = DownloadFailed;
    [self.downloadCacher updateDownloadModel:downloadModel];
    dispatch_async(dispatch_get_main_queue(), ^{
        [DownloadManager postNotification:DownloadFailedNotification andObject:downloadModel];
    });
    [self _tryToOpenNewDownloadTask];
}


#pragma mark - 下载完成
- (void)m3u8Downloader:(DownloadManager_M3U8 *)m3u8Downloader finishDownload:(DownloadModel *)downloadModel
{

    downloadModel.status = DownloadFinished;
    downloadModel.downloadPercent = 1.0;
    
    [self.downloadCacher updateDownloadModel:downloadModel];
    [self.downloadCacher deleteM3U8Record:downloadModel.url];
    [DownloadManager postNotification:DownloadFinishNotification andObject:downloadModel];
    [self _tryToOpenNewDownloadTask];
}



- (void)m3u8Downloader:(DownloadManager_M3U8 *)m3u8Downloader dealModelFinished:(DownloadModel *)downloadModel
{
    [self _tryToOpenNewDownloadTask];
}


- (void)m3u8Downloader:(DownloadManager_M3U8 *)m3u8Downloader analyseFailed:(DownloadModel *)downloadModel
{
    [DownloadManager postNotification:DownloadM3U8AnalyseFailedNotification andObject:downloadModel];
}




#pragma mark - MP4 下载
- (void)dealDownloadFinishedOrFailedWithError:(NSError *)error andDownloadModel:(DownloadModel *)downloadModel
{
    if (error)
    {
        //手动暂停的
        if ([error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData])
        {
            NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
            downloadModel.resumeData = [[NSString alloc] initWithData:resumeData encoding:NSUTF8StringEncoding];
            downloadModel.status = DownloadPause;
            [self.downloadCacher updateDownloadModel:downloadModel];
            dispatch_async(dispatch_get_main_queue(), ^{
                [DownloadManager postNotification:DownloadingUpdateNotification andObject:downloadModel];
            });
        }
        //下载出现错误
        else
        {
            //NSLog(@"下载出现错误");
            downloadModel.status = DownloadFailed;
            [self.downloadCacher updateDownloadModel:downloadModel];
            downloadModel.error = error;
            [DownloadManager postNotification:DownloadFailedNotification andObject:downloadModel];
        }
    }
    //下载完成
    else
    {
        downloadModel.status = DownloadFinished;
        downloadModel.downloadPercent = 1.0;
        [self.downloadCacher updateDownloadModel:downloadModel];
        [DownloadManager postNotification:DownloadFinishNotification andObject:downloadModel];
    }
}




#pragma mark - 网络改变通知通知
- (void)_networkObserver {
    
    [MyNotification addObserver:self
                       selector:@selector(networkNotification:)
                           name:KNetworkStatusNotification
                         object:nil];
}



- (void)networkNotification:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    NSInteger  status  = [dict[@"status"] integerValue];
    
    self.internetStatus = status;
    
    if (status == AFNetworkReachabilityStatusNotReachable){
        //无网中断下载
        [[DownloadManager shareInstance]pauseAllDownload];
    }else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
        //手机流量中断下载
        //showTipDialog(Mobile_Network);
        [[DownloadManager shareInstance]pauseAllDownload];
    }
}





@end
