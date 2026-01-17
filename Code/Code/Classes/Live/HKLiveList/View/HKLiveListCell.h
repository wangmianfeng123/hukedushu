//
//  HKLiveListCell.h
//  Code
//
//  Created by Ivan li on 2018/10/15.
//  Copyright © 2018年 pg. All rights reserved.
//


#import <UIKit/UIKit.h>

@class HKLiveListModel,HKLiveCoverIV;

@interface HKLiveListCell : UICollectionViewCell

@property(nonatomic,strong)HKLiveCoverIV *coverIV;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *typeLabel;

@property(nonatomic,strong)HKLiveListModel  *model;
/**报名 */
@property(nonatomic,strong)UIButton *enrolmentBtn;

@property(nonatomic,strong)UIImageView *iconIV;

@property(nonatomic,strong)UILabel *nameLabel;
/** 报名 回调 */
@property(nonatomic,copy)void(^enrolmentBlock)(NSIndexPath *indexPath, HKLiveListModel *model);
/** 报名 */
@property(nonatomic,copy)void(^avatarClickBlock)(NSIndexPath *indexPath, HKLiveListModel *model);

@property(nonatomic,strong)NSIndexPath *indexPath;

@end
