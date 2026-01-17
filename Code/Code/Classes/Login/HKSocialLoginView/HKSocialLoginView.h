//
//  HKSocialLoginView.h
//  Code
//
//  Created by ivan on 2020/6/17.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/// view 类型
typedef NS_ENUM(NSInteger, HKSocialLoginViewType) {
    /// 普通手机登录
    HKSocialLoginViewType_phoneLogin = 1,
    /// 极验登陆
    HKSocialLoginViewType_oneLoginSdk = 2
};

@interface HKSocialLoginView : UIView

//@property(nonatomic,strong)UILabel *themeLB;

//@property(nonatomic,strong)UIView *leftLineView;

//@property(nonatomic,strong)UIView *rightLineView;

@property(nonatomic,strong)UIView *centerLineView;
/** QQ 按钮 */
@property(nonatomic,strong)UIButton *qqLoginBtn;

@property(nonatomic,strong)UILabel *qqTextLB;
/** 微信 按钮 */
@property(nonatomic,strong)UIButton *weChatLoginBtn;

@property(nonatomic,strong)UILabel *weChatTextLB;

@property(nonatomic,strong)UIImageView *qqLoginTipLB;
@property(nonatomic,strong)UIImageView *weChatLoginTipLB;

/** 微博 按钮 */
@property(nonatomic,strong)UIButton *weiBoLoginBtn;
/** 微博 按钮 */
@property(nonatomic,strong)UIButton *weiBoLoginRoundBtn;

@property(nonatomic,copy) void (^socialLoginBlock)(UIButton *btn);

@property(nonatomic,assign) HKSocialLoginViewType socialLoginViewType;

/** 气泡图片*/
@property(nonatomic,strong)UIImageView *bubleImageView;

@end

NS_ASSUME_NONNULL_END
