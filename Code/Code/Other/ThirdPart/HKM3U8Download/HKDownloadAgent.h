//
//  HKDownloadAgent.h
//  Code
//
//  Created by hanchuangkeji on 2017/12/18.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "HKDownloadModel.h"
#import "HKDownloadManager.h"

@interface HKDownloadAgent : NSObject

@property (nonatomic, weak)id<HKDownloadManagerDelegate> delegate;

@property (nonatomic, weak)HKDownloadManager *manager; //下载manager

@property (nonatomic, weak)HKDownloadModel *modelForDelegate; //下载对象


/**
 创建一个下载代理数据监听对象

 @param manager HKDownloadManager
 @param modelForDelegate 视频对象
 @param delegate 需要回调给谁
 @return 返回实例
 */
+ (HKDownloadAgent *)initManager:(HKDownloadManager *)manager HKDownloadModel:(HKDownloadModel *)modelForDelegate delegate:(id<HKDownloadManagerDelegate>)delegate;


/**
 执行代理方法，比如下载开启，暂停，失败等...

 @param action 方法名称
 @param array 方法执行的参数
 */
- (void)excuteFunc:(SEL)action arguments:(NSArray *)array;


@end
