//
//  HKHomeFollowCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKRecommendTxtModel;

@interface HKHomeFollowV2Cell : TBCollectionHighLightedCell

//@property (nonatomic, strong)NSMutableArray<HKUserModel *> *teacher_list;
@property (nonatomic, strong)NSMutableArray<HKRecommendTxtModel *> *content_list;// 推荐笔记和评论


@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;

@property (nonatomic, copy)void(^homeMyFollowVideoSelectedBlock)(NSIndexPath *indexPath, HKRecommendTxtModel * model);

//@property (nonatomic, copy)void(^followTeacherSelectedBlock)(NSIndexPath *indexPath, HKRecommendTxtModel * model);

//@property (nonatomic, copy)void(^videoSelectedBlock)(VideoModel *model);
@property (nonatomic, copy)void(^videoSelectedBlock)(HKRecommendTxtModel * model);


@end
