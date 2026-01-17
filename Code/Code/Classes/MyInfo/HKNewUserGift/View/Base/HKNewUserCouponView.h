//
//  HKNewUserCouponView.h
//  Code
//
//  Created by Ivan li on 2018/8/3.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HKHomeGiftModel;


@interface HKNewUserCouponView : UIView

@property (nonatomic,strong) UILabel *leftLB;

@property (nonatomic,strong) UILabel *rightLB;

@property (nonatomic,strong) UIImageView *leftBgIV;

@property (nonatomic,strong) UIImageView *rightBgIV;

@property (nonatomic,strong) HKHomeGiftModel *model;

@end
