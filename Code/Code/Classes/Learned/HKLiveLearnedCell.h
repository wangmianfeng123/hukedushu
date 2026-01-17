//
//  LearnedCell.h
//  Code
//
//  Created by Ivan li on 2017/7/22.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class  DownloadModel, VideoModel, HKAlbumShadowImageView,HKCustomMarginLabel;


@interface HKLiveLearnedCell : UITableViewCell

/** 图片阴影 */
@property(nonatomic,strong)HKAlbumShadowImageView *bgImageView;

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *categoryLabel;

@property(nonatomic,strong)UILabel *sizeLabel;

@property(nonatomic,strong)UILabel *timeLabel;

//@property(nonatomic,strong)UILabel *deadlineLabel;
@property(nonatomic,strong)HKCustomMarginLabel *deadlineLabel;

/** 已学进度 */
@property(nonatomic,strong)UILabel *progressLabel;
/** 课时数 */
@property(nonatomic,strong)UILabel *courseLabel;
/** 观看人数 */
@property(nonatomic,strong)UILabel *scanLabel;

@property(nonatomic,strong)VideoModel  *model;

@property(nonatomic,strong)UIButton  *selectBtn;

@property(nonatomic,strong)UIView  *cellBgView;

@property(nonatomic,assign)BOOL isEdit;

@property(nonatomic,copy)void (^learnedCellBlock)(VideoModel  *model);

- (void)updateEditAllConstraints;

- (void)updateNoEditAllConstraints;

/**编辑状态下 点击 cell 选中 */
- (void)editSelectRow;

@end



