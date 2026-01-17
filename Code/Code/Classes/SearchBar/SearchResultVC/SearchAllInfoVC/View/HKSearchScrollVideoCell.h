//
//  HKSearchScrollVideoCell.h
//  Code
//
//  Created by Ivan li on 2018/3/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "TBCollectionHighLightedCell.h"


@class HomeMyFollowVideoModel;
@class HKShadowImageView;

@interface HKSearchScrollVideoCell : TBCollectionHighLightedCell

@property (nonatomic, strong)VideoModel *model;

- (void)setDefaultImageWithName:(NSString*)name;

@property (nonatomic, strong)HKShadowImageView *bgImageView;


@end



