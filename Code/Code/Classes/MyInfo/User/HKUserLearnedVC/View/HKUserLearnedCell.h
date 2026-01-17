//
//  HKUserLearnedCell.h
//  Code
//
//  Created by Ivan li on 2018/5/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class  DownloadModel,VideoModel,HKAlbumShadowImageView;


@interface HKUserLearnedCell : UITableViewCell

/** 图片阴影 */
@property(nonatomic,strong)HKAlbumShadowImageView *bgImageView;

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *categoryLabel;

@property(nonatomic,strong)UILabel *sizeLabel;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UILabel *deadlineLabel;
/** 已学进度 */
@property(nonatomic,strong)UILabel *progressLabel;
/** 课时数 */
@property(nonatomic,strong)UILabel *courseLabel;
/** 观看人数 */
@property(nonatomic,strong)UILabel *scanLabel;

@property(nonatomic,copy)VideoModel  *model;


@end
