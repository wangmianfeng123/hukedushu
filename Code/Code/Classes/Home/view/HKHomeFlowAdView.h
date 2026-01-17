//
//  HKHomeFlowAdView.h
//  Code
//
//  Created by hanchuangkeji on 2018/9/14.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"

@interface HKHomeFlowAdView : UIImageView

@property (nonatomic, copy)void(^adFlowBlock)(HKMapModel *);

+ (HKHomeFlowAdView *)addADViewToView:(UIView *)superView;

+ (void)hideADView;

+ (void)showADView;

@property (nonatomic, strong)HKMapModel *model;

@end
