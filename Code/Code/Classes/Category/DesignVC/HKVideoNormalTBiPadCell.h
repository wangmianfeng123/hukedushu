//
//  HKVideoNormalTBCell.h
//  Code
//
//  Created by Ivan li on 2017/9/26.
//  Copyright © 2017年 pg. All rights reserved.
//


#import <UIKit/UIKit.h>

@class  DownloadModel,VideoModel,HKCoverBaseIV;

@interface HKVideoNormalTBiPadCell : TBHighLightedCell

typedef void(^ZFNormalBtnClickBlock)(DownloadModel *downloadModel);
typedef void(^ZFNormalBtnClickBlock2)(DownloadModel *downloadModel);

@property(nonatomic,strong)HKCoverBaseIV *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *categoryLabel;

@property(nonatomic,strong)UILabel *sizeLabel;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIView *seapratorView;

@property(nonatomic,strong)VideoModel  *model;

@property(nonatomic,strong)DownloadModel *downloadModel;

@property (nonatomic, copy)void(^tapModelBlock)(VideoModel  *model);

// 收藏功能
@property(nonatomic,strong)UIButton *collectionBtn;

@property (nonatomic, copy)void(^collectionBlock)(NSIndexPath *indexPath, VideoModel *model);

@property (nonatomic, strong)NSIndexPath *indexPath;

/** 右侧的cell **/
@property(nonatomic,strong)HKCoverBaseIV *iconImageView2;

@property(nonatomic,strong)UILabel *titleLabel2;

@property(nonatomic,strong)UILabel *categoryLabel2;

@property(nonatomic,strong)UILabel *sizeLabel2;

@property(nonatomic,strong)UILabel *timeLabel2;

@property(nonatomic,strong)UIView *seapratorView2;

@property(nonatomic,strong)VideoModel  *model2;

@property(nonatomic,strong)DownloadModel *downloadModel2;

// 收藏功能
@property(nonatomic,strong)UIButton *collectionBtn2;

@property (nonatomic, copy)void(^collectionBlock2)(NSIndexPath *indexPath2, VideoModel *model2);

@property (nonatomic, strong)NSIndexPath *indexPath2;

/** 右侧的cell **/

@end
