//
//  HKhomeLoginView.h
//  Code
//
//  Created by ivan on 2020/6/22.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKhomeLoginView : UIView
/// 关闭按钮
@property (nonatomic,strong)UIButton *closeBtn;
/// 登录按钮
@property (nonatomic,strong)UIButton *loginBtn;
/// logo
@property (nonatomic,strong)UIImageView *logoIV;
/// 登录描述
@property (nonatomic,strong)UILabel *descLB;

@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,copy) void (^loginBtnActionBlock)(UIButton *btn);
/// 是否 当天需要显示login view 
+ (BOOL)isNeedShowHomeLoginOfDay;

@end

NS_ASSUME_NONNULL_END
