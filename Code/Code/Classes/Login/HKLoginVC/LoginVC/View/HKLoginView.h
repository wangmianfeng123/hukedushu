//
//  HKLoginView.h
//  Code
//
//  Created by Ivan li on 2018/7/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>




@class HKWaterView,HKWaterWaveView,HKLoginView;



@protocol HKLoginViewDeletate <NSObject>
@optional
/** 协议 */
- (void)agreementBtnClickAction:(UIButton*)sender;
/** 手机登录 和 三方平台登录 */
- (void)thirdPlatformLogin:(UIButton*)sender;

- (void)hkLoginView:(HKLoginView*)view closeButton:(UIButton*)btn;
/** 隐私 协议 */
- (void)privacyBtnClickAction:(UIButton*)sender;

@end





@interface HKLoginView : UIView

@property(nonatomic,weak)id<HKLoginViewDeletate> delegate;

@property(nonatomic,strong)UIButton *phoneLoginBtn;
/** 注册协议 按钮 */
@property(nonatomic,strong)UIButton *agreementBtn;
/** QQ 按钮 */
@property(nonatomic,strong)UIButton *qqLoginBtn;
/** 微信 按钮 */
@property(nonatomic,strong)UIButton *weChatLoginBtn;
/** 微博 按钮 */
@property(nonatomic,strong)UIButton *weiBoLoginBtn;
/** 气泡图片*/
@property(nonatomic,strong)UIImageView *bubleImageView;
/** logo图片*/
@property(nonatomic,strong)UIImageView *logoImageView;

@property(nonatomic,strong)HKWaterWaveView *kywaterView;

@property(nonatomic,assign)HKLoginViewType loginViewType;
/** 登录提示 */
@property(nonatomic,strong)UILabel *loginTipLB;
/** 注册协议 选择 按钮 */
@property(nonatomic,strong)UIButton *selectBtn;

@property(nonatomic,strong)UIImageView *loginTipIV;
/** YES 选择协议 */
@property(nonatomic,assign)BOOL isSelectAgree;

@property(nonatomic,assign)BOOL isShowAgreeTip;

@property(nonatomic,strong)UIButton *colseButton;
/** 登录提示 */
@property(nonatomic,strong)UILabel *loginThemeLB;
/** YES - 极验登陆 */
@property(nonatomic,assign)BOOL isShowLoginGift;

/** 隐私协议 按钮 */
@property(nonatomic,strong)UIButton *privacyBtn;

@property(nonatomic,strong)UIButton *bgBtn;


- (void)setLoginText:(NSString*)text isShowLoginGift:(BOOL)isShowLoginGift;

@end


