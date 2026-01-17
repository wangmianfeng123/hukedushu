//
//  HKInternetSchoolCell.h
//  Code
//
//  Created by ivan on 2020/5/18.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class HKLiveListModel,HKLiveCoverIV;

@interface HKInternetSchoolCell : UICollectionViewCell

@property(nonatomic,strong)HKLiveCoverIV *coverIV;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)HKLiveListModel  *model;

@property(nonatomic,strong)UIImageView *iconIV;

@property(nonatomic,strong)UILabel *nameLabel;
/** 报名 回调 */
@property(nonatomic,copy)void(^enrolmentBlock)(NSIndexPath *indexPath, HKLiveListModel *model);
/** 报名 */
@property(nonatomic,copy)void(^avatarClickBlock)(NSIndexPath *indexPath, HKLiveListModel *model);

@property(nonatomic,strong)NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END

