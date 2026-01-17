//
//  HKSoftwareCourseCell.h
//  Code
//
//  Created by Ivan li on 2018/4/1.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HomeMyFollowVideoModel;
@class HKShadowImageView;

@interface HKSoftwareCourseCell : TBCollectionHighLightedCell

@property (nonatomic, strong)VideoModel *model;

@property (nonatomic, strong)HKShadowImageView *bgImageView;

@end
