//
//  HKHomeLiveCell.h
//  Code
//
//  Created by ivan on 2020/4/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKLiveListModel,HKLiveCoverIV;

@interface HKHomeLiveCell : UICollectionViewCell

@property(nonatomic,strong)HKLiveCoverIV *coverIV;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)HKLiveListModel  *model;

@property(nonatomic,strong)UIImageView *iconIV;

@property(nonatomic,strong)UILabel *nameLabel;
/** 头像点击回调 */
@property(nonatomic,copy)void(^avatarClickBlock)(HKLiveListModel *model);

//@property (nonatomic , strong)NSIndexPath * indexPath;
@end

