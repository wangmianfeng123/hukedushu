//
//  M3U8SegmentListDownloader.m
//  DownLoader
//
//  Created by bfec on 17/3/9.
//  Copyright © 2017年 com. All rights reserved.
//

#import "M3U8SegmentListDownloader.h"
#import "M3U8SegmentDownloader.h"
#import "DownloadManager+Utils.h"
#import "AES128Helper.h"
#import "DownloadCacher.h"


#define locaHost @"http://127.0.0.1:12345/"
#define keyDocument @"/Tempkey"

#define URIKEY  @"e10adc3949ba59abbe56e057f20f883e"

NSString const *videoKey = @"HKUEkyTnvBqs3+Qmpgodb7K8oxkReTlGLa5WX/l7ucQ=";

static M3U8SegmentListDownloader *instance;

@interface M3U8SegmentListDownloader ()<M3U8SegmentDownloaderDelegate>

@property (nonatomic,strong) M3U8SegmentList *segmentList;
@property (nonatomic,strong) DownloadModel *downloadingModel;
@property (nonatomic,assign) NSInteger downloadingIndex;
@property (nonatomic,strong) M3U8SegmentDownloader *segmentDownloader;
@property (nonatomic,assign) long long alreadyDownloadSize;
@property (nonatomic,assign) long long tmpSize;

//add
@property (nonatomic,assign) NSInteger allTSAcount;


@end

@implementation M3U8SegmentListDownloader

+ (id)shareInstance
{
    static dispatch_once_t token2;
    dispatch_once(&token2, ^{
        instance = [[M3U8SegmentListDownloader alloc] init];
    });
    return instance;
}

- (M3U8SegmentDownloader *)segmentDownloader
{
    if (!_segmentDownloader)
    {
        _segmentDownloader = [M3U8SegmentDownloader shareInstance];
        _segmentDownloader.urlSession = self.urlSession;
        _segmentDownloader.delegate = self;
        _segmentDownloader.downloadCacher = self.downloadCacher;
    }
    return _segmentDownloader;
}


- (void)startDownload:(DownloadModel *)downloadModel andSegmentList:(M3U8SegmentList *)segmentList withInfo:(NSDictionary *)m3u8Info
{
    self.segmentList = segmentList;
    self.downloadingModel = downloadModel;
    
    self.alreadyDownloadSize = [m3u8Info[@"m3u8AlreadyDownloadSize"] integerValue];
    self.downloadingIndex = [m3u8Info[@"tsDownloadTSIndex"] integerValue];
    
    self.allTSAcount = [m3u8Info[@"allTsAcount"] integerValue];
    
    if (self.downloadingIndex < [segmentList.segments count] && self.downloadingIndex > 0)
    {
        M3U8SegmentInfo *segment = [self.segmentList.segments objectAtIndex:self.downloadingIndex];
        [self _startDownload:segment withResumeData:nil];
    }
    else if (self.downloadingIndex == 0)
    {
        M3U8SegmentInfo *segment = [self.segmentList.segments firstObject];
        [self _startDownload:segment withResumeData:nil];
    }
}



- (void)pauseDownload:(DownloadModel *)downloadModel withResumeData:(NSData *)resumeData
{
    //NSLog(@"%@当前ts-----%ld 总数ts-----%ld",downloadModel.name,(long)self.downloadingIndex,self.segmentList.segments.count);
    self.downloadingModel.status = DownloadPause;
    //modify  yang
    [self.segmentDownloader pauseDownloadWithResumeData:resumeData downloadIndex:self.downloadingIndex downloadSize:self.tmpSize url:self.downloadingModel.url allTsAcount:[self.segmentList.segments count]];
}

- (void)_startDownload:(M3U8SegmentInfo *)segment withResumeData:(NSString *)resumeData
{
    [self.segmentDownloader startDownload:segment withResumeData:resumeData];
}



#pragma mark - SegmentDownloaderDelegate

- (void)m3u8SegmentDownloader:(M3U8SegmentDownloader *)m3u8SegmentDownloader downloadingBegin:(M3U8SegmentInfo *)segment task:(NSURLSessionDownloadTask *)task
{
    if ([self.delegate respondsToSelector:@selector(m3u8SegmentListDownloader:beginDownload:segment:task:)])
    {
        [self.delegate m3u8SegmentListDownloader:self beginDownload:nil segment:segment task:task];
    }
}

- (void)m3u8SegmentDownloader:(M3U8SegmentDownloader *)m3u8SegmentDownloader downloadingUpdateProgress:(NSProgress *)progress
{

    if ([self.delegate respondsToSelector:@selector(m3u8SegmentListDownloader:updateDownload:progress:)])
    {
        self.tmpSize = self.alreadyDownloadSize + progress.completedUnitCount;
        //CGFloat downloadProgress = (self.alreadyDownloadSize + progress.completedUnitCount) / (self.downloadingModel.videoSize * 1.0);
        //add yang
        CGFloat loadingProgress = 0;
        
        if (self.downloadingIndex == 0) {
            
        }else{
            NSInteger index =  self.downloadingIndex ;
            NSInteger count =  self.segmentList.segments.count;
            loadingProgress = ((CGFloat)index/(CGFloat)count);
        }
        
        if (progress.completedUnitCount == progress.totalUnitCount)
        {
            self.alreadyDownloadSize += progress.totalUnitCount;
        }
        [self.delegate m3u8SegmentListDownloader:self updateDownload:nil progress:loadingProgress];
    }
}

- (void)m3u8SegmentDownloader:(M3U8SegmentDownloader *)m3u8SegmentDownloader downloadingPause:(M3U8SegmentInfo *)segment resumeData:(NSData *)resumeData
{
    
    if ([self.delegate respondsToSelector:@selector(m3u8SegmentListDownloader:pauseDownload:resumeData:tsIndex:alreadyDownloadSize:)])
    {
        
        [self.delegate m3u8SegmentListDownloader:self pauseDownload:self.downloadingModel resumeData:resumeData tsIndex:self.downloadingIndex alreadyDownloadSize:self.alreadyDownloadSize];
    }
}

- (void)m3u8SegmentDownloader:(M3U8SegmentDownloader *)m3u8SegmentDownloader downloadFailed:(NSError *)error
{
    //终止下载任务
    if ([self.urlSession downloadTasks].count >0) {
        
            [[self.urlSession downloadTasks] enumerateObjectsUsingBlock:^(NSURLSessionDownloadTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSURLSessionDownloadTask *task = obj;
                if (task.state == NSURLSessionTaskStateRunning)
                {
                    [task cancel];
                    [[self.urlSession downloadTasks] makeObjectsPerformSelector:@selector(cancel)];
                    //*stop = YES;
                }
            }];
    }
    
    [self.segmentDownloader pauseDownloadWithResumeData:nil downloadIndex:self.downloadingIndex downloadSize:self.tmpSize url:self.downloadingModel.url allTsAcount:[self.segmentList.segments count]];
    if ([self.delegate respondsToSelector:@selector(m3u8SegmentListDownloader:failedDownload:)])
    {
        self.downloadingModel.error = error;
        [self.delegate m3u8SegmentListDownloader:self failedDownload:self.downloadingModel];
    }
}

- (void)m3u8SegmentDownloader:(M3U8SegmentDownloader *)m3u8SegmentDownloader downloadingFinished:(M3U8SegmentInfo *)segment
{
    self.downloadingIndex++;
    
    if (self.downloadingIndex < [self.segmentList.segments count])
    {
        M3U8SegmentInfo *nextSegment = [self.segmentList.segments objectAtIndex:self.downloadingIndex];
        [self.segmentDownloader startDownload:nextSegment withResumeData:nil];
        //NSLog(@"当前ts-----%ld 总数ts-----%ld",(long)self.downloadingIndex,self.segmentList.segments.count);
    }
    else//所有的ts都下载完成
    {
        if ([self.delegate respondsToSelector:@selector(m3u8SegmentListDownloader:finishDownload:)])
        {
            [self _createM3U8File:_downloadingModel.url segmentList:self.segmentList];
            [self.delegate m3u8SegmentListDownloader:self finishDownload:self.downloadingModel];
        }
    }
}

- (void)_createM3U8File:(NSString*)videoUrl  segmentList:(M3U8SegmentList *)segmentList
{
    
    __block NSString *tempVideoUrl = videoUrl;
    __block M3U8SegmentList *tempSegmentList = segmentList;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *savePath = [DownloadManager getM3U8LocalUrlWithVideoUrl:tempVideoUrl];
        NSString *tempFilePath = savePath;
        
        savePath = [savePath stringByAppendingPathComponent:@"movie.m3u8"];
        //获取文件夹目录
        NSString *locaStr = [self getLocalUrlWithVideoUrl:tempSegmentList.videoUrl];
        
        NSString *headUrl = [NSString stringWithFormat:@"http://127.0.0.1:12345/%@%@",locaStr,@"/temp/Tempkey"];
        
        NSString *tempHead = @"#EXTM3U\n#EXT-X-VERSION:3\n#EXT-X-MEDIA-SEQUENCE:0\n#EXT-X-ALLOW-CACHE:YES\n#EXT-X-TARGETDURATION:19\n#EXT-X-KEY:METHOD=AES-128,URI=";
        
        NSString *head = [NSString stringWithFormat:@"%@\"%@\"\n",tempHead,headUrl];
        
        NSInteger count = [tempSegmentList.segments count];
        NSArray *fileTotal = [[NSFileManager defaultManager]subpathsAtPath: tempFilePath]; //文件夹中文件个数
        if(count != fileTotal.count) {
            NSLog(@"文件个数不对啊");
        }
        
        BOOL bTrue = [self createKeyFile:tempVideoUrl keyUrl:tempSegmentList.keyUrl];
        if (bTrue) {
            //填充片段数据
            for(int i = 0;i<count;i++)
            {
                M3U8SegmentInfo *segInfo = [tempSegmentList getSegmentByIndex:i];
                NSString *length = [NSString stringWithFormat:@"#EXTINF:%ld,\n",(long)segInfo.duration];
                
                NSString *url = [NSString stringWithFormat:@"%@%@/%@.ts",locaHost,locaStr,[segInfo.shortUrl stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
                head = [NSString stringWithFormat:@"%@%@%@\n",head,length,url];
            }
            //创建尾部
            NSString *end = @"#EXT-X-ENDLIST";
            head = [head stringByAppendingString:end];
            NSMutableData *writer = [[NSMutableData alloc] init];
            [writer appendData:[head dataUsingEncoding:NSUTF8StringEncoding]];
            BOOL bSucc = [writer writeToFile:savePath atomically:YES];
            if (bSucc) {
                NSLog(@"M3U8数据保存成功");
            } else {
                NSLog(@"M3U8数据保存失败");
                return ;
            }
            // add yang  下载完成发送通知
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                //__block NSMutableArray *downladed =  [self.downloadCacher selectNoDownloadModels];
                
                __block NSMutableArray *downladed =  [[DownloadCacher shareInstance] selectNoDownloadModels];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //NSDictionary *dict =  @{KdownloadCount: [NSString stringWithFormat:@"%lu",(unsigned long)downladed.count],KdownloadArray:downladed};
                    NSDictionary *dict = nil;
                    if (downladed.count>0) {
                        dict =  @{KdownloadCount: [NSString stringWithFormat:@"%lu",(unsigned long)downladed.count],KdownloadArray:downladed};
                    }else{
                        dict =  @{KdownloadCount: [NSString stringWithFormat:@"%lu",(unsigned long)downladed.count]};
                    }
                    [MyNotification postNotificationName:KdownloadingChangeNotification object:nil userInfo:dict];
                });
            });
        }
    });
}



#pragma mark - 获取文件夹目录
- (NSString *)getLocalUrlWithVideoUrl:(NSString *)videoUrl
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
            subStr = [subStr stringByReplacingOccurrencesOfString:@"." withString:@"_"];
            return subStr;
        }
        return nil;
    }
}


#pragma mark - 获取key
- (NSString *)getKey:(NSString *)URI{
    
//    __block NSString *result;
//    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:URI] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", result);
//    }] resume];
    
    NSURL *url = [NSURL URLWithString:URI];
    NSError *err = nil;
    NSString *key = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
    //NSLog(@"获取err---%@--/n%@ ---%d",err.userInfo,err.localizedDescription,[NSThread currentThread]);
    return key;
}



#pragma mark - 创建加密文件 //创建temp 文件 保存URL 密钥
- (BOOL)createKeyFile:(NSString *)videoUrl keyUrl:(NSString *)keyUrl {
    
    NSString *docuPath = kLibraryCache;//[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *locaStr = [self getLocalUrlWithVideoUrl:videoUrl];
    if (isEmpty(locaStr)) {
        //showTipDialog(@"url nil");
        return NO;
    }
    
    NSString *tempPath = [docuPath stringByAppendingPathComponent:locaStr];
    tempPath = [tempPath stringByAppendingString:@"/temp"];
    NSString *filePath = [tempPath stringByAppendingString:keyDocument];
    NSError *tempPatherror;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
        BOOL createTempPath = [[NSFileManager defaultManager] createDirectoryAtPath:tempPath withIntermediateDirectories:NO attributes:nil error:&tempPatherror];
        if (!createTempPath) {
            //NSLog(@"创建fail");
            return NO;
        }
    }
    NSMutableData *tempWriter = [[NSMutableData alloc] init];
    NSString *key =  [self getKey:keyUrl];
    if (isEmpty(key)) {
        key = [AES128Helper AES128DecryptText:videoKey key:URIKEY];
    }
    NSString *decrStr = [AES128Helper AES128EncryptText:key key:URIKEY];     //加密
    [tempWriter appendData:[decrStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *temperror;
    BOOL bTempSucc =[tempWriter writeToFile:filePath options:NSDataWritingAtomic error:&temperror];
    if(bTempSucc){
        return YES;
    }else{
        //NSLog(@"create m3u8file failed:%@", temperror);
        return NO;
    }
}















@end
