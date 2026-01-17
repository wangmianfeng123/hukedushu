//
//  DownloadModel.h
//  DownLoader
//
//  Created by bfec on 17/2/14.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DownloadNotExist = -1,
    DownloadWating = 0,
    DownloadPause = 1,
    Downloading = 2,
    DownloadFinished = 3,
    DownloadFailed = 4,
}DownloadStatus;

@interface DownloadModel : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *url;//目前标识一个视频的字段
@property (nonatomic,assign) DownloadStatus status;
@property (nonatomic,assign) double downloadPercent;
@property (nonatomic,copy) NSString *resumeData;
@property (nonatomic,assign) BOOL isM3u8Url;
@property (nonatomic,assign) long long videoSize;
@property (nonatomic,strong) NSError *error;

@property (nonatomic,copy) NSString *category; //类别
@property (nonatomic,copy) NSString *hardLevel; //jibie
@property (nonatomic,copy) NSString *imageUrl;  //
@property (nonatomic,copy) NSString *videoDuration; //时长

@property (nonatomic,copy) NSString *userID; //用户ID
@property (nonatomic,copy) NSString *videoId; //视频ID
@property (nonatomic, assign) int videoType; //视频ID

#pragma mark - 用于全选 删除 视频
@property (nonatomic, assign) NSInteger cellClickState;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger indexState;

@end
