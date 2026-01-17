//
//  HKMyInfoVipView.h
//  Code
//
//  Created by Ivan li on 2018/9/25.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKMyInfoVipModel;

@protocol HKMyInfoVipViewDelegate <NSObject>

- (void)myInfoVipViewClickAction:(id)sender;

@end


@interface HKMyInfoVipView : UIView

@property (nonatomic,strong) UIImageView *bgIV;

@property (nonatomic,strong) UIImageView *vipIV;

@property (nonatomic,strong) UIButton *vipIconBtn;

@property (nonatomic,strong) UILabel *vipLB;

@property (nonatomic,strong) UILabel *vipInfoLB;

@property (nonatomic,strong) UIButton *buyVipBtn;

@property (nonatomic,strong)HKUserModel *userModel;

@property (nonatomic,strong)HKMyInfoVipModel *vipModel;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,weak)id <HKMyInfoVipViewDelegate> delegate;

@end
