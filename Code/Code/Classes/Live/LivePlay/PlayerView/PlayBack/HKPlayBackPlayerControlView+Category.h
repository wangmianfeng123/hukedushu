//
//  HKPlayBackPlayerControlView+Category.h
//  Code
//
//  Created by eon Z on 2021/12/24.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKPlayBackPlayerControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKPlayBackPlayerControlView (Category)
/**
 @return Yes 已下载
 */
- (BOOL)isDownloadFinsh:(HKPermissionVideoModel *)detailModel;
/**
 已下载的视频 NSURL
 
 @return NSURL
 */
- (NSURL *)downloadFilePath;
/**
 开启本地服务
 
 @param sucess 回调
 @param fail
 */
- (void)startLocalServer:(void(^)())sucess fail:(void(^)())fail;

- (NSInteger)resetPlayTime:(HKPermissionVideoModel *)model;

//保存播放记录;
- (void)recordVideoProgress;

//上传播放进度到后台
- (void)recordVideoProgress:(NSInteger)currentTime  videoId:(NSString*)videoId  totalTime:(NSInteger)totalTime;
@end

NS_ASSUME_NONNULL_END
