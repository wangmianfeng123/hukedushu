//
//  HomeVideoCollectionCell.h
//  Code
//
//  Created by Ivan li on 2017/9/26.
//  Copyright © 2017年 pg. All rights reserved.
//


#import <UIKit/UIKit.h>

@class VideoModel,HKCoverBaseIV;

@interface HomeVideoCollectionCell : TBCollectionHighLightedCell

@property(nonatomic,strong)HKCoverBaseIV *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *categoryLabel;

@property(nonatomic,strong)UILabel *sizeLabel;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIView *seapratorView;

@property(nonatomic,copy)VideoModel  *model;
// 收藏功能
@property(nonatomic,strong)UIButton *collectionBtn;

@property (nonatomic, copy)void(^collectionBlock)(NSIndexPath *indexPath, VideoModel *model);

@property (nonatomic, strong)NSIndexPath *indexPath;


@end
