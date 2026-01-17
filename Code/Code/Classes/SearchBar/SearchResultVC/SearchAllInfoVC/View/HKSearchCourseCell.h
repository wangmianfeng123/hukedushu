//
//  HKSearchCourseCell.h
//  Code
//
//  Created by Ivan li on 2017/11/29.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "TBCollectionHighLightedCell.h"
//#import <YYImage.h>
//#import <YYWebImage.h>

@class VideoModel;
@interface HKSearchCourseCell : TBCollectionHighLightedCell

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *categoryLabel;

@property(nonatomic,strong)UILabel *sizeLabel;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)VideoModel  *model;

/** 观看次数 */
@property(nonatomic,strong,readwrite)UILabel *watchLabel;

@end












