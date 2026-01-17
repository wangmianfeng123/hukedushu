//
//  HKLiveCourseVC.h
//  Code
//
//  Created by hanchuangkeji on 2018/10/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"
#import "HKLiveListModel.h"

NS_ASSUME_NONNULL_BEGIN
@class HKLiveCourseBottomView,commentBottomView;

@interface HKLiveCourseVC : HKBaseVC


@property (nonatomic, copy)void(^refreshBlock)(HKLiveListModel *model);
// 底部购买
@property (nonatomic, strong)HKLiveCourseBottomView *bottomView;
/** 底部评价 */
@property(nonatomic,strong)commentBottomView  *commentView;
@property(nonatomic,strong)UIView * recentlyView;
@property(nonatomic,assign)BOOL showRecentlyView; //1展示  2不展示
@property (nonatomic, copy)NSString *course_id;

@property(nonatomic, assign)BOOL isLocalVideo ; //标记本地视频，从本地下载过来
@property (nonatomic, copy)NSString *live_id;  //直播小节id

@end

NS_ASSUME_NONNULL_END
