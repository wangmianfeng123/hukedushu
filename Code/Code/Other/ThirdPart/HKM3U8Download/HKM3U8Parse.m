//
//  HKM3U8Parse.h
//  Code
//
//  Created by hanchuangkeji on 2017/12/18.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "HKM3U8Parse.h"
#import "AES128Helper.h"
#import "HKDownloadManager.h"


#define HKNSErrorCustomDomain @"HKNSErrorCustomDomain"

//-------------- 沙盒缓存目录 ---------------//
#define HKkLibraryCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#define HKDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

#define HKLocaHost @"http://127.0.0.1:12345/"
#define HKKeyDocument @"/Tempkey"

#define HKURIKEY  @"e10adc3949ba59abbe56e057f20f883e"

//NSString const *HKVideoKey = @"HKUEkyTnvBqs3+Qmpgodb7K8oxkReTlGLa5WX/l7ucQ=";
NSString const *HKVideoKey = @"zit9iK3jVv1gf5t5SYZPvLK8oxkReTlGLa5WX/l7ucQ=";

@interface HKM3U8Parse()

@property(nonatomic,copy)NSString *baseUrl;

@end


@implementation HKM3U8Parse


- (HKDownloadModel *)analyseVideoUrl:(NSString *)videoUrl error:(NSError **)error videoID:(NSString *)videoID videoType:(int)videoType
                          chapter_id:(NSString *)chapter_id
                          section_id:(NSString *)section_id
                           career_id:(NSString *)career_id {
    
    HKDownloadModel *modelTemp = [[HKDownloadModel alloc] init];
    modelTemp.videoId = videoID;
    modelTemp.videoType = videoType;
    /// v2.17
    if (HKVideoType_JobPath == videoType || HKVideoType_JobPath_Practice == videoType) {
        modelTemp.chapter_id = chapter_id;
        modelTemp.career_id = career_id;
        modelTemp.section_id = section_id;
    }
        
    if ([videoUrl containsString:@"http:"] || [videoUrl containsString:@"https:"]) {
        
    } else {
        videoUrl = [[HKDownloadManager class] refreshContentURLSyn:modelTemp];
    }
    
    //截取主路径
    NSString *baseTempUrl = videoUrl;
    NSRange  baseurlRange = [baseTempUrl rangeOfString:@".com"];
    self.baseUrl = [baseTempUrl substringToIndex:baseurlRange.location+4];
    
    if ([videoUrl isEqualToString:@""] || videoUrl == nil)
    {
        //NSLog(@"videoUrl must not nil or empty!");
        NSDictionary *userInfo = @{@"errorDes":@"videoUrl must not nil or empty!"};
        *error = [NSError errorWithDomain:HKNSErrorCustomDomain code:-111 userInfo:userInfo];
    }
    NSURL *url = [NSURL URLWithString:videoUrl];
    NSError *err = nil;
    
    // 这里耗时操作放入子线程
    NSString *m3u8Str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
    
    if (err || ![m3u8Str containsString:@"#EXTINF:"]){
        
        NSDictionary *userInfo = err.userInfo;
        *error = [NSError errorWithDomain:HKNSErrorCustomDomain code:-222 userInfo:userInfo];
        
        NSLog(@"======第一次解析加载出错，尝试第二次中...  %@", err.localizedDescription);
        
        // 再次获取
        videoUrl = [[HKDownloadManager class] refreshContentURLSyn:modelTemp];
        NSURL *url = [NSURL URLWithString:videoUrl];
        // 这里耗时操作放入子线程
        m3u8Str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
        
        if (![m3u8Str containsString:@"#EXTINF:"]) {
            NSLog(@"第2次解析加载出错，需要排查错误， %@", m3u8Str);
        }
        
        if (err) {
            NSLog(@"====== 同步加载出错  %@", err.localizedDescription);
        }
    }
    
    //NSLog(@"videoUrl --- %@",videoUrl);
    if (![m3u8Str containsString:@"#EXTINF:"]) return nil;
    return [self _analyseWithM3U8Str:m3u8Str videoUrl:videoUrl videoID:videoID videoType:videoType];
}


- (HKDownloadModel *)_analyseWithM3U8Str:(NSString *)m3u8Str videoUrl:(NSString *)videoUrl videoID:(NSString *)videoID videoType:(int)videoType
{
    
    NSMutableArray *segments = [[NSMutableArray alloc] init];
    NSString* tempM3u8Str = m3u8Str;
    
    // 设置域名
    NSRange range = [videoUrl rangeOfString:@".com"];
    NSString *baseUrl = @"";
    if (range.length) {
        baseUrl = [videoUrl substringWithRange:NSMakeRange(0, range.location + range.length)];
    }
    
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
    int index = 0;
    while (segmentRange.location != NSNotFound) {
        
        HKSegmentModel *segment = [[HKSegmentModel alloc] init];
        segment.indexSegment = index++;
        //读取TS片段时长
        NSRange commaRange = [tempM3u8Str rangeOfString:@","];
        NSString* value = [tempM3u8Str substringWithRange:NSMakeRange([@"#EXTINF:" length], commaRange.location - [@"#EXTINF:" length])];
        segment.videoId = videoID;
        segment.videoType = videoType;
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
        
        segment.url = [NSString stringWithFormat:@"%@%@", baseUrl, downUrl];
        segment.shortUrl = downUrl;
        segment.isFinish = NO; // 没有完成
        // 拼接本地路径
        segment.localUrl = [HKM3U8Parse getLocalUrlWithVideoID:videoID videoType:videoType index:[NSString stringWithFormat:@"%ld", segmentIndex]];
        
        segmentIndex++;
        [segments addObject:segment];
        segmentRange = [tempM3u8Str rangeOfString:@"#EXTINF:"];
        if (segmentRange.location != NSNotFound) {
            tempM3u8Str = [tempM3u8Str substringFromIndex:(segmentRange.location)];
        }
    }
    
    HKDownloadModel *segmentList = [[HKDownloadModel alloc] initWithSegments:segments];
    segmentList.totalDurations = totalSeconds;
    segmentList.videoUrl = videoUrl;
    segmentList.keyUrl = urlvalue; //密钥
    segmentList.isFinish = NO; // 没有完成
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

#pragma mark 创建m3u8文件ID
+ (NSString *)getLocalUrlWithVideoID:(NSString *)videoID videoType:(int)videoType index:(NSString *)index{
    
    NSString *filePath = [NSString stringWithFormat:@"%@/download/%@_%d", HKDocumentPath, videoID, videoType];
    NSString *file = [NSString stringWithFormat:@"%@/download/%@_%d/%@.ts", HKDocumentPath, videoID, videoType, index];
    
    // 相对路径
    NSString *relativePath = [file stringByReplacingOccurrencesOfString:HKDocumentPath withString:@""];
    
    // 创建文件
    NSError *error = nil;
    BOOL isDirectory = YES;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    BOOL createFileSuccess = NO;
    if (!exist) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    // 创建文件
    if (error == nil) {
        createFileSuccess = YES;
    }
    
    return createFileSuccess? relativePath : nil;
}


#pragma mark 创建m3u8文件

+ (NSString *)getMP4LocalUrlWithVideoUrl:(NSString *)videoUrl
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
            subStr = [HKkLibraryCache stringByAppendingPathComponent:subStr];
            return subStr;
        }
        return nil;
    }
}


+ (NSString *)getM3U8LocalUrlWithVideoUrl:(NSString *)videoUrl
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

#pragma mark - 获取文件夹目录
+ (NSString *)getLocalUrlWithVideoUrl:(NSString *)videoUrl
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
        } else if ([videoUrl length] > 8 && [videoUrl containsString:@"https://"])
        {
            NSString *subStr = [videoUrl substringFromIndex:8];
            subStr = [subStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
            subStr = [@"download" stringByAppendingPathComponent:subStr];
            subStr = [subStr stringByReplacingOccurrencesOfString:@"." withString:@"_"];
            return subStr;
        }
        return nil;
    }
}

#pragma mark - 创建加密文件 //创建temp 文件 保存URL 密钥
+ (BOOL)tb_createKeyFile:(NSString *)videoID videoType:(int)videoType keyUrl:(NSString *)keyUrl {
    
    NSString *docuPath = HKDocumentPath;//[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *locaStr = [NSString stringWithFormat:@"download/%@", videoID];
    if (isEmpty(locaStr)) {
        //showTipDialog(@"url nil");
        return NO;
    }
    
    NSString *tempPath = [docuPath stringByAppendingPathComponent:locaStr];
    
    // 兼容1.7版本
    BOOL isDirectory1_7 = YES;
    BOOL exist1_7 = [[NSFileManager defaultManager] fileExistsAtPath:tempPath isDirectory:&isDirectory1_7];
    if (!exist1_7) {
        // 1.8版本
        tempPath = [NSString stringWithFormat:@"%@/download/%@_%d", HKDocumentPath, videoID, videoType];
    }
    
    tempPath = [tempPath stringByAppendingString:@"/temp"];
    NSString *filePath = [tempPath stringByAppendingString:HKKeyDocument];
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
    
    // 无法获取key，让用户重试
    if (isEmpty(key)) {
        return NO;
    }
    
    NSString *decrStr = [AES128Helper AES128EncryptText:key key:HKURIKEY];     //加密
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


+ (BOOL)createKeyFile:(NSString *)videoUrl keyUrl:(NSString *)keyUrl {
    
    NSString *docuPath = HKkLibraryCache;//[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *locaStr = [self getLocalUrlWithVideoUrl:videoUrl];
    if (isEmpty(locaStr)) {
        //showTipDialog(@"url nil");
        return NO;
    }
    
    NSString *tempPath = [docuPath stringByAppendingPathComponent:locaStr];
    tempPath = [tempPath stringByAppendingString:@"/temp"];
    NSString *filePath = [tempPath stringByAppendingString:HKKeyDocument];
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
        key = [AES128Helper AES128DecryptText:HKVideoKey key:HKURIKEY];
    }
    NSString *decrStr = [AES128Helper AES128EncryptText:key key:HKURIKEY];     //加密
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


#pragma mark - 获取key
+ (NSString *)getKey:(NSString *)URI{
    NSURL *url = [NSURL URLWithString:URI];
    NSError *err = nil;
    NSString *key = @"";
    
    // 重试2次，可能会无法获取到
    key = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
    if (err != nil) {
        key = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
    }
    return key;
}


+ (void)createM3U8File:(NSString*)videoUrl videoType:(int)videoType  segmentList:(HKDownloadModel *)segmentList finish:(void(^)(BOOL))createM3U8FileBlock{
    
    __block HKDownloadModel *tempSegmentList = segmentList;
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *savePath = [NSString stringWithFormat:@"%@/download/%@_%d", HKDocumentPath, segmentList.videoId, videoType];
        
        NSString *tempFilePath = savePath;
        
        savePath = [savePath stringByAppendingPathComponent:@"movie.m3u8"];
        //获取文件夹目录
        NSString *locaStr = [NSString stringWithFormat:@"download/%@_%d", segmentList.videoId, videoType];
        
        NSString *headUrl = [NSString stringWithFormat:@"http://127.0.0.1:12345/%@%@",locaStr,@"/temp/Tempkey"];
        
        NSString *tempHead = @"#EXTM3U\n#EXT-X-VERSION:3\n#EXT-X-MEDIA-SEQUENCE:0\n#EXT-X-ALLOW-CACHE:YES\n#EXT-X-TARGETDURATION:19\n#EXT-X-KEY:METHOD=AES-128,URI=";
        
        NSString *head = [NSString stringWithFormat:@"%@\"%@\"\n",tempHead,headUrl];
        
        NSInteger count = [tempSegmentList.segments count];
        NSArray *fileTotal = [[NSFileManager defaultManager]subpathsAtPath: tempFilePath]; //文件夹中文件个数
        if(count != fileTotal.count) {
            NSLog(@"文件个数不对啊");
        }
        //创建解密文件
        BOOL bTrue = [self tb_createKeyFile:segmentList.videoId videoType:videoType keyUrl:tempSegmentList.keyUrl];
        if (bTrue) {
            //填充片段数据
            for(int i = 0; i < count; i++)
            {
                HKSegmentModel *segInfo = [tempSegmentList getSegmentByIndex:i];
                NSString *length = [NSString stringWithFormat:@"#EXTINF:%ld,\n",(long)segInfo.duration];
                
                NSString *url = [NSString stringWithFormat:@"%@%@/%d.ts",HKLocaHost,locaStr, segInfo.indexSegment];
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
                createM3U8FileBlock(YES);
            } else {
                createM3U8FileBlock(NO);
                NSLog(@"M3U8数据保存失败");
            }
        } else {
            // 获取key失败，创建解码文件错误
            createM3U8FileBlock(NO);
            NSLog(@"获取key失败，创建解码文件错误");
        }
    //});
}




@end
