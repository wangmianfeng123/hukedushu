//
//  HKNewUserThirdView.h
//  Code
//
//  Created by Ivan li on 2018/8/6.
//  Copyright © 2018年 pg. All rights reserved.
//


#import "HKGiftBaseView.h"


@protocol HKNewUserThirdViewDelegate <NSObject>

@end


@interface HKNewUserThirdView : HKGiftBaseView

@property (nonatomic,weak)id <HKNewUserThirdViewDelegate> delegate;

@property (nonatomic,strong) UIImageView *moneyIV;

@property (nonatomic,strong) UILabel *moneyLB;

@property (nonatomic,strong) HKHomeGiftModel *model;

/** 顶部图片 */
@property (nonatomic,strong) UIImageView *headIV;

@end
