//
//  LoginBindPhoneView.h
//  Code
//
//  Created by Ivan li on 2017/9/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VerificationCodeButton;

@protocol LoginBindPhoneDeletate <NSObject>

- (void)loginBindPhoneWithAuthcode:(id)sender;

@end

@interface LoginBindPhoneView : UIView<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *phoneTextField;
@property(nonatomic,strong)UITextField *authCodeTextField;
@property(nonatomic,strong)VerificationCodeButton   *getAuthCodeBtn;
@property(nonatomic,strong)UIButton     *registerBtn;
@property(nonatomic,weak)id<LoginBindPhoneDeletate>delegate;
@property(nonatomic,strong)UIImageView *phoneTextFieldBackground;

@property(nonatomic,strong)UIView *phoneLine;
@property(nonatomic,strong)UIView *authCodeLine;
@property(nonatomic,strong)UILabel *tipLabel;

@property (nonatomic, assign) BOOL isPhoneEmpty;
@property (nonatomic, assign) BOOL isAuthCodeEmpty;

@end
