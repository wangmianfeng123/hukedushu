//
//  HKAdsCell.h
//  Code
//
//  Created by Ivan li on 2018/1/7.
//  Copyright © 2018年 pg. All rights reserved.
//  222

#import "TBCollectionHighLightedCell.h"


@class HKMapModel;

@interface HKAdsCell : TBCollectionHighLightedCell

@property(nonatomic,strong)HKMapModel *model;

@end
