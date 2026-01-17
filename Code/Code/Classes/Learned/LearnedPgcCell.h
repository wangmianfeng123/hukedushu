//
//  LearnedPgcCell.h
//  Code
//
//  Created by Ivan li on 2018/9/13.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKAlbumShadowImageView,HKCustomMarginLabel;

@interface LearnedPgcCell : UITableViewCell

/** 图片阴影 */
@property(nonatomic,strong)HKAlbumShadowImageView *bgImageView;

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;

/** 已学进度 */
@property(nonatomic,strong)UILabel *progressLabel;
/** 课时数 */
@property(nonatomic,strong)UILabel *courseLabel;

@property(nonatomic,strong)VideoModel  *model;

@property(nonatomic,strong)UIView  *cellBgView;


@end



