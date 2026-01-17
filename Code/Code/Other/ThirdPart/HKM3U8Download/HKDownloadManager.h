//                                  虎课下载总结构
//  ================================================================================
//  HKDownloadManager作为总控制器或者理解为总工厂
//  仅有一个实例对象的HKDownloadManager分别控制调用HKDownloadCore，HKDownloadDB，HKM3U8Parse，HKDownloadAgent
//  分别作用为：
//  HKDownloadCore 核心网络下载数据
//  HKDownloadDB 将视频数据与用户等相关数据记录在iPhone sqlite客户端中
//  HKM3U8Parse 解析m8u3
//  HKDownloadAgent 用于代理交互
//
//                                  简单下载视频流程说明
//  ================================================================================
//  1，启动HKDownloadManager - (AFURLSessionManager *)shareSessionManager;
//  2，调用HKDownloadManager 实例方法
//  - (void)downloadModel:(HKDownloadModel *)downloadModel withDelegate:(id<HKDownloadManagerDelegate>)delegate; 开启下载

//  3，步骤2方法中会判断VC是否需要代理监听，从而添加相应的HKDownloadAgent进行下载数据进度的变化回调给相应VC
//  4，HKDownloadManager实例自动调用 HKM3U8Parse 进行M3U8的解析
//  5，HKDownloadManager通过HKM3U8Parse 的解析功能获取相应数据，将该数据保存至HKDownloadDB中
//  6，HKDownloadManager创建网络核心下载组件HKDownloadCore 下载视频相应的切片资源
//  7，HKDownloadCore下载的同时会更新HKDownloadDB数据中视频的详情信息，直至整个视频完成,ts 文件下载完成，生成本地M3u8 文件和存储key 文件，用于本地播放。






//
//  HKDownloadManager.h
//  Code
//
//  Created by hanchuangkeji on 2017/12/18.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKDownloadModel.h"
#import "HKSeekTimeModel.h"

@class HKDownloadAgent;

@protocol HKDownloadManagerDelegate <NSObject>

@optional

/**
 开启了一个新视频下载

 @param model 下载的视频实例
 */
- (void)beginDownload:(HKDownloadModel *)model;

/**
 一个正在等待下载的视频
 
 @param model 等待下载的视频实例
 */
- (void)waitingDownload:(HKDownloadModel *)model;

/**
 正在下载的视频详情进度
 
 @param model 正在下载的视频实例
 */
- (void)download:(HKDownloadModel *)model progress:(NSProgress *)progress index:(NSString *)index;

/**
 失败的下载视频
 
 @param model 已经失败的视频下载实例
 */
- (void)didFailedDownload:(HKDownloadModel *)model;

/**
 完成的下载视频
 
 @param model 已经完成的视频下载实例
 */
- (void)didFinishedDownload:(HKDownloadModel *)model;

/**
 暂停的下载视频
 
 @param model 已经暂停的视频下载实例
 */
- (void)didPausedDownload:(HKDownloadModel *)model;

/**
 删除的下载视频
 
 @param model 删除的视频下载实例
 */
- (void)didDeletedDownload:(HKDownloadModel *)model;// 删除model

/**
 尚未完成的下载视频，包括正在下载，等待下载，暂停下载
 
 @param model 尚未完成的下载视频数组
 */
- (void)download:(HKDownloadModel *)model notFinishArray:(NSMutableArray<HKDownloadModel *> *)array;// 正在下载

/**
 已经完成下载的视频
 
 @param model 已经完成下载的视频数组
 */
- (void)downloaded:(HKDownloadModel *)model historyArray:(NSMutableArray<HKDownloadModel *> *)array;// 已经完成的所有下载

/**
 已经完成下载的视频目录
 
 @param model 已经完成下载的视频目录数组
 */
- (void)downloaded:(HKDownloadModel *)model directory:(NSMutableArray<HKDownloadModel *> *)array;// 总目录


/**
 已经完成某个视频的某个切片下载

 @param downloadModel 正在下载的实例
 @param segmentModel 正在下载的实例某个切片
 */
- (void)didFinishModel:(HKDownloadModel *)downloadModel Segment:(HKSegmentModel *)segmentModel;// 完成了某个切片

@end

@interface HKDownloadManager : NSObject

@property (nonatomic,assign,readonly)BOOL isHKDowning;
// 包括正在下载的Model
@property (nonatomic, strong,readonly)NSMutableArray<HKDownloadModel *> *notFinishArray;


/**
 获取HKDownloadManager唯一实例

 @return HKDownloadManager实例
 */
+ (id)shareInstance;



/**
 开启一个视频下载

 @param downloadModel 需要下载的是实例
 @param delegate 需要回调的代理对象
 */
- (void)downloadModel:(HKDownloadModel *)downloadModel withDelegate:(id<HKDownloadManagerDelegate>)delegate;


/**
 删除某个下载的视频，包括已完成的，暂停的，失败的，等待的...

 @param model 需要删除的视频对象
 @param deletModelBlock 删除成功的回调block
 */
- (void)deletedDownload:(HKDownloadModel *)model delete:(void (^)(BOOL success, HKDownloadModel *model))deletModelBlock;



/// 删除视频 包括已完成的，暂停的，失败的，等待的...
/// @param modelArr 需要删除的视频对象
- (void)deletedDownloadArr:(NSMutableArray <HKDownloadModel*> *)modelArr;

/**
 注册观察下载数据变化

 @param delegate 代理对象
 @param arrayBlock 未完成，已经完成，视频目录视频数组
 */
- (void)observerDownload:(id<HKDownloadManagerDelegate>)delegate array:(void(^)(NSMutableArray *notFinishArray, NSMutableArray *historyArray, NSMutableArray *directoryArray))arrayBlock;


/**
 暂停某个视频的下载

 @param model 需要暂停的对象
 @param next 是否开启下一个正在等待的下载对象
 @param pauseTaskBlock 暂停该下载对象之后的回调block
 */
//- (void)pauseTask:(HKDownloadModel *)model openNext:(BOOL)next completeBlock:(void(^)())pauseTaskBlock;

- (void)pauseTask:(HKDownloadModel *)model openNext:(BOOL)next completeBlock:(void(^)(BOOL completed))pauseTaskBlock;


/**
 暂停全部的下载
 */
- (void)pauseAllTask;


/**
 开启所有的下载
 */
- (void)startAllTask;


// 开始所有失败的下载
- (void)startAllFailedTask;


/**
 设置已经观看过某视频的标识

 @param model 需要设置视频对象
 */
- (void)changeNeedStudyLocal:(HKDownloadModel *)model;


/**
 根据视频对象查询某个视频的下载状态，未下载，已完成下载，未完成下载，下载失败，暂停，等待...

 @param model 需要查询的对象
 @return 下载状态
 */
- (HKDownloadStatus)queryStatus:(HKDownloadModel *)model;


/**
  根据视频对象ID查询某个视频的下载状态，未下载，已完成下载，未完成下载，下载失败，暂停，等待...

 @param videId 视频ID
 @param videoType 视频type
 @return 下载状态
 */
- (HKDownloadModel *)queryWidthID:(NSString *)videId videoType:(int)videoType;


/**
 更新下载视频的状态，比如从未完成状态更新为已下完成状态

 @param model 需要更新的视频对象
 @param dicOrModel 需要更新的键值对
 @return 是否更新成功
 */
- (BOOL)savedownloadModel:(HKDownloadModel *)model dicOrModel:(id)dicOrModel;


/**
 保存目录的封面，比如软件入门，系列课等

 @param directModel 课程总目录对象
 @return 是否保存成功
 */
- (BOOL)saveDirectoryModel:(HKDownloadModel *)directModel;


/**
 批量保存下载model, 稍后再解析segments下载

 @param array 批量加载准备下载的视频
 @param saveBlock 保存成功的回调
 */
- (void)saveArrayParseLater:(NSArray<HKDownloadModel *> *)array block:(void(^)())saveBlock;


/**
 开启下一个任务/可用于wifi自动下载
 */
- (void)downloadNextWaitingTask;

/**
 获取background下载的session

 @return 网络下载的AFURLSessionManager
 */
- (AFURLSessionManager *)shareSessionManager;


/**
 更新url 不常用，反正下载过程中url过期

 @param model 下载的视频对象
 @param updateSegmentsComplete 更新成功的block
 */
+ (void)updateSegmentsURLSave:(HKDownloadModel *)model block:(void(^)(BOOL completed, HKDownloadModel *model ))updateSegmentsComplete;


/**
 移除相应的代理对象，不再监听回调

 @param agent 代理对象
 @param stopModel 视频下载对象
 */
- (void)removeAgent:(HKDownloadAgent *)agent model:(HKDownloadModel *)stopModel;


/**
 兼容1.6版本的（不用理会）

 @param model 视频下载对象
 */
- (void)saveModelBefore1_6:(HKDownloadModel *)model;


/**
 获取/更新m3u8的url, 防止过期

 @param model 视频下载对象
 @param completecBlock 更新成功回调
 */
- (void)refreshContentURL:(HKDownloadModel *)model block:(void(^)(NSString *video_url, int videoType))completecBlock;

/**
 同步请求  下载权限

 @param model 视频对象
 @return 更新后的m3u8地址
 */
+ (NSString *)refreshContentURLSyn:(HKDownloadModel *)model;


/**
 兼容1.8目录（不用理会）
 */
+ (void)adaptDirInfo1_8;


/**
 保存播放进度

 @param model 视频对象
 @param dicOrModel 更新的键值对，即视频时长
 */
- (void)saveVideoProgress:(HKDownloadModel *)model dicOrModel:(id)dicOrModel;

/**
 记忆播放，保存或更新记忆播放

 @param model 视频对象
 @return 是否更新成功
 */
- (BOOL)saveOrUpdateSeekModel:(HKSeekTimeModel *)model;


/**
 查询记忆播放

 @param model 视频对象
 @return 记忆播放的对象
 */
- (HKSeekTimeModel *)querySeekModel:(HKSeekTimeModel *)model;

@end

