//
//  BindPhoneView.h
//  Code
//
//  Created by Ivan li on 2017/9/1.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>



@class VerificationCodeButton,HKTextField,HKCustomMarginLabel;

@protocol RegisterVDeletate <NSObject>

- (void)registerWithAuthcode:(id)sender;

@end

@interface BindPhoneView : UIView<UITextFieldDelegate>

@property(nonatomic,weak)id<RegisterVDeletate>delegate;

@property(nonatomic,strong)HKTextField *phoneTextField;
@property(nonatomic,strong)HKTextField *authCodeTextField;
@property(nonatomic,strong)VerificationCodeButton   *getAuthCodeBtn;

@property(nonatomic,strong)UIButton     *registerBtn;
@property(nonatomic,strong)UIImageView *phoneTextFieldBackground;

@property(nonatomic,strong)UIView *phoneLine;
@property(nonatomic,strong)UIView *authCodeLine;

@property(nonatomic,strong)UILabel *tipLabel;

@property (nonatomic, assign) BOOL isPhoneEmpty;
@property (nonatomic, assign) BOOL isAuthCodeEmpty;

/** 警告 */
@property(nonatomic,strong)HKCustomMarginLabel *warnLabel;
/** 绑定类型 （默认普通绑定） */
@property(nonatomic,assign)HKBindPhoneType bindPhoneType;
/** 设置警告提示 */
- (void)setWarnWithText:(NSString*)text;

@end
