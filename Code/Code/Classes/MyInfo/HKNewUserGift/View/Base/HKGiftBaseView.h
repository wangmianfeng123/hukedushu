//
//  HKGiftBaseView.h
//  Code
//
//  Created by Ivan li on 2018/8/6.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HKGiftWaterWaveView,HKTagBtnTool,HKNewUserCouponView,HKHomeGiftModel;


@interface HKGiftBaseView : UIView

@property (nonatomic,strong) HKTagBtnTool *tagBtnTool;

@property (nonatomic,copy)void(^hkNewUserFirstViewBlock)(NSString *title);

@property (nonatomic,strong) UIView *waterBgView;
/** 水波纹 */
@property (nonatomic,strong)HKGiftWaterWaveView *waterView;

@property (nonatomic,strong)UIView *couponBgView;
/** 优惠券 */
@property (nonatomic,strong)HKNewUserCouponView  *couponView;
/** 底部标签 提示 */
@property (nonatomic,strong)UILabel  *tagLB;
/** 三日礼包 提示 */
@property (nonatomic,strong)UILabel  *giftTagLB;

@property (nonatomic,strong)UIImageView  *giftTagIV;

@property (nonatomic,copy)NSString *bottomTagTitle;

@property (nonatomic,copy)NSString *giftTagTitle;


- (void)createUI;

- (void)makeConstraints;

@end






