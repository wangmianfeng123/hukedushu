//
//  HKVerificationPhoneView.h
//  Code
//
//  Created by Ivan li on 2018/7/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VerificationCodeButton,HKTextField,HKCustomMarginLabel,HKVerificationPhoneView;

@protocol HKVerificationPhoneViewDeletate <NSObject>

@optional
- (void)verificationPhone:(HKVerificationPhoneView*)view sender:(UIButton*)sender;

@end




@interface HKVerificationPhoneView : UIView <UITextFieldDelegate>

@property(nonatomic,weak)id<HKVerificationPhoneViewDeletate>delegate;

@property(nonatomic,strong)HKTextField *authCodeTextField;

@property(nonatomic,strong)VerificationCodeButton   *getAuthCodeBtn;

@property(nonatomic,strong)UIButton     *loginBtn;

@property(nonatomic,strong)UIView *authCodeLine;

@property(nonatomic, assign)BOOL isAuthCodeEmpty;

@property(nonatomic,strong)UILabel     *phoneLB;

@property(nonatomic,copy)NSString     *phoneNum;

/** 警告 */
@property(nonatomic,strong)HKCustomMarginLabel *warnLabel;
/** 设置警告提示 和 手机号 */
- (void)setWarnWithText:(NSString*)text phone:(NSString*)phone;

@end
