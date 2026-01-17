//
//  HKSearchScrollCell.h
//  Code
//
//  Created by Ivan li on 2018/3/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "TBCollectionHighLightedCell.h"

@class HKSearchCourseModel,HKSerieslistModel;



@interface HKSearchScrollCell : TBCollectionHighLightedCell

@property(nonatomic,strong)NSMutableArray<VideoModel *> *seriesArr;

@property(nonatomic, copy)void(^searchScrollVideoSelectedBlock)(NSIndexPath *indexPath, VideoModel *videoNodel);

/** 更多 按钮 点击回调 */
@property(nonatomic,copy)void (^moreBtnClickBackCall)();

@property(nonatomic,strong)HKSerieslistModel *serieslistModel;

@end
