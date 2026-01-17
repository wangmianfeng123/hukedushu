//
//  VideoPlayVC+Category.h
//  Code
//
//  Created by Ivan li on 2018/4/17.
//  Copyright © 2018年 pg. All rights reserved.
//


#import "VideoPlayVC.h"

@interface VideoPlayVC (Category)

/**
 添加 软件入门推荐
 */
- (void)addHKSoftwareRecommenVC;


/** 软件入门 成就 弹窗  */
- (void)setAchieveDialogWithModel:(DetailModel*)model;

//添加提醒日程弹框
//- (void)showAddClockView:(void(^)(void))resultBlock;

- (void)loadCatalogueList:(HKVideoType)videoType resultBlock:(void(^)(NSMutableArray * dataArray,NSIndexPath * index))resultBlock;
@end

