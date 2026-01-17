//
//  HKLiveRecommendCourseCell.h
//  Code
//
//  Created by ivan on 2020/8/26.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class HKLiveRecommendCourseModel,HKCoverBaseIV;

@interface HKLiveRecommendCourseCell : UICollectionViewCell

@property(nonatomic,strong)HKCoverBaseIV *coverIV;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)HKLiveRecommendCourseModel  *model;

@property(nonatomic,strong)UIImageView *iconIV;

@property(nonatomic,strong)UIImageView *secondIconIV;

@property(nonatomic,strong)UILabel *nameLabel;
/// 报名人数
@property(nonatomic,strong)UILabel *countLB;

/** 报名 回调 */
@property(nonatomic,copy)void(^enrolmentBlock)(NSIndexPath *indexPath, HKLiveRecommendCourseModel *model);


@end

NS_ASSUME_NONNULL_END




