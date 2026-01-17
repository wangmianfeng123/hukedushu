//
//  HomeVideloCell.h
//  Code
//
//  Created by Ivan li on 2017/7/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  DownloadModel,VideoModel;



@interface HomeVideloCell : UITableViewCell

//@interface HomeVideloCell : TBCollectionHighLightedCell

typedef void(^ZFNormalBtnClickBlock)(DownloadModel *downloadModel);

typedef void(^HomeVideloCellBlock)(HomeVideloCell *cell);

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *categoryLabel;

@property(nonatomic,strong)UILabel *sizeLabel;

@property(nonatomic,strong)UILabel *timeLabel;


@property(nonatomic,copy)VideoModel  *model;

/** 下载按钮点击回调block */
@property (nonatomic, copy) ZFNormalBtnClickBlock  btnClickBlock;

@property(nonatomic,strong)DownloadModel *downloadModel;


@end
