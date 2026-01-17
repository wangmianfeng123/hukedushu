//
//  HKDownloadModel.h
//  DownLoader
//
//  Created by bfec on 17/3/8.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKSegmentModel.h"

@protocol HKDownloadManagerDelegate;

typedef enum {
    HKDownloadNotExist = -1,  //未下载
    HKDownloadWaiting = 0,  //等待下载
    HKDownloadPause = 1,    //下载暂停
    HKDownloading = 2,      //下载中
    HKDownloadFinished = 3, //下载完成
    HKDownloadFailed = 4,   //下载失败
}HKDownloadStatus;

@interface HKDownloadModel : NSObject

// JQFMDB 主键
@property (nonatomic, assign)NSInteger pkid;

@property (nonatomic, strong) NSMutableArray<HKSegmentModel *> *segments;
@property (nonatomic, assign) double totalDurations; //视频总时长
//https://m3u8.huke88.com/video/hls/v_1/2019-10-09/0624609B-672F-5789-3648-EE43409CA50F.m3u8?pm3u8/0/deadline/1639650458&e=1639637858&token=HUwgVvJnrW6fXOzqd_myfnE3FFoFLWJnNktg7ThD:imJsC_-DtdBv3xgllrCzK7grR-U=
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *video_url;
// add yang
@property (nonatomic, copy) NSString *keyUrl;  //密钥  https://asyn.huke88.com/video/decrypt

@property (nonatomic, copy)NSString *localUrl;
@property (nonatomic, assign)BOOL isFinish;

@property (nonatomic, assign)NSInteger downloadingCount; // 正在下载的个数，用于已学
@property (nonatomic, assign)BOOL isDownloadingCountModel;
@property (nonatomic, assign)BOOL isMoreModel;
/// 下载速率
@property (nonatomic ,assign) CGFloat downloadRate;

@property (nonatomic ,copy) NSString *rateStr;

// downloadModel
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *url;//目前标识一个视频的字段
@property (nonatomic,assign) NSInteger status;

@property (atomic ,assign) double downloadPercent;
@property (nonatomic,copy) NSString *resumeData;
@property (nonatomic,assign) BOOL isM3u8Url;
@property (nonatomic,assign) long long videoSize;
@property (nonatomic,strong) NSError *error;

@property (nonatomic,copy) NSString *category; //类别
@property (nonatomic,copy) NSString *hardLevel; //jibie
@property (nonatomic,copy) NSString *imageUrl;  //
@property (nonatomic,copy) NSString *videoDuration; //时长

@property (nonatomic, copy)NSString *video_application;
@property (nonatomic, copy)NSString *viedeo_difficulty;
@property (nonatomic, copy)NSString *video_duration;

@property (nonatomic,copy) NSString *userID; // 该视频是哪一个用户下载的
@property (nonatomic,copy) NSString *videoId; //视频ID
@property (nonatomic,copy) NSString *video_id; //视频ID

@property (nonatomic, assign) BOOL saveInCache; // 是否是保存在旧版本的缓存路径

@property (nonatomic, assign)int videoType; // 视频类型

@property (nonatomic, assign)NSInteger directSort; // 目录排序 越大越靠前

- (id)initWithSegments:(NSMutableArray *)segments;
- (HKSegmentModel *)getSegmentByIndex:(int)index;

// **** 带目录下载视频封面 ****
@property (nonatomic, copy)NSString *dir_id;
@property (nonatomic, assign)int video_type;  //999表示的是直播课回看视频
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *img_cover_url;
@property (nonatomic, copy)NSString *parent_direct_id;// 如果为空就是目录  为空就是封面文件夹model
@property (nonatomic, assign)int parent_direct_type;// 如果为空就是目录    为空就是封面文件夹model
@property (nonatomic, assign)BOOL isDirectory;// 仅为目录   存在没有目录的单节课程  封面文件夹model
@property (nonatomic, strong)NSMutableArray<HKDownloadModel *> *children;
// **** 带目录下载视频封面 ****

// response 二进制
@property (nonatomic, strong)NSData *responseDicData;

// **** 定时播放 ****
@property (nonatomic, assign)NSInteger playSeekTime; // 在第几秒播放
@property (nonatomic, copy)NSString *playSeekTimeUpdate; // 定时播放时间的更新


@property (nonatomic, assign)BOOL needStudyLocal;// 0已观看，1未观看


#pragma mark - 用于全选 删除 视频
@property (nonatomic, assign) NSInteger cellClickState;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger indexState;


/*********** 职业路径 ***********/
/// 职业路径 练习题 章节ID
@property (nonatomic, copy)NSString *chapter_id;
/// 职业路径 章节ID
@property (nonatomic, copy)NSString *section_id;
/// 职业路径 ID
@property (nonatomic, copy)NSString *career_id;
/// 直播课程ID
@property (nonatomic, copy)NSString * live_course_id;
/// 直播小节ID
@property (nonatomic, copy)NSString * live_id;

@end

