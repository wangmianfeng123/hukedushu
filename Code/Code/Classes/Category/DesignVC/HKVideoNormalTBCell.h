//
//  HKVideoNormalTBCell.h
//  Code
//
//  Created by Ivan li on 2017/9/26.
//  Copyright © 2017年 pg. All rights reserved.
//


#import <UIKit/UIKit.h>

@class  DownloadModel,VideoModel,HKCoverBaseIV;


@interface HKVideoNormalTBCell : TBHighLightedCell

typedef void(^ZFNormalBtnClickBlock)(DownloadModel *downloadModel);

@property(nonatomic,strong)HKCoverBaseIV *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *categoryLabel;

@property(nonatomic,strong)UILabel *sizeLabel;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIView *seapratorView;

@property(nonatomic,strong)VideoModel  *model;

@property(nonatomic,strong)DownloadModel *downloadModel;

// 收藏功能
@property(nonatomic,strong)UIButton *collectionBtn;

@property (nonatomic, copy)void(^collectionBlock)(NSIndexPath *indexPath, VideoModel *model);

@property (nonatomic, strong)NSIndexPath *indexPath;


@end
