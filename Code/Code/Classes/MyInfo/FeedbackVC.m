//
//  FeedbackVC.m
//  Code
//
//  Created by Ivan li on 2017/8/31.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "FeedbackVC.h"
#import "UserInfoServiceMediator.h"
#import "HKPlaceholderTextView.h"


#define KFeedBackPlaceholder  @"请详细描述你遇到的问题或建议（至少15个字）"

#define  registerBtnBgColor   [UIColor colorWithHexString:@"#ffd500"];
#define btnBgColor RGB(210, 210, 210, 1);



@interface FeedbackVC ()<UITextViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)UIButton *submitBtn;

@property(nonatomic,strong)UITextField *phoneTextField;

@property(nonatomic,assign) BOOL isFeedbackEmpty;

@property(nonatomic,assign) BOOL isQQEmpty;

@property(nonatomic,strong)HKPlaceholderTextView *feedbackView;

/**  */
@property(nonatomic,assign)BOOL isSubmit;




@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self createLeftBarButton];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)createUI {
    
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.view addSubview:self.feedbackView];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.submitBtn];
    
    [self.feedbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(KNavBarHeight64+PADDING_20);
        make.right.equalTo(self.view.mas_right).offset(-PADDING_20);
        make.left.equalTo(self.view.mas_left).offset(PADDING_20);
        make.height.mas_equalTo(IS_IPHONE6PLUS ?180:150);
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.feedbackView);
        make.top.equalTo(self.feedbackView.mas_bottom).offset(PADDING_20);
        make.height.mas_equalTo(PADDING_20*2);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(33);
        make.right.left.equalTo(self.feedbackView);
        make.height.mas_equalTo(PADDING_25*2);
    }];
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.view.backgroundColor = COLOR_F8F9FA_333D48;
}




- (HKPlaceholderTextView*)feedbackView {

    if (!_feedbackView) {
        _isFeedbackEmpty = YES;
        
        _feedbackView = [[HKPlaceholderTextView alloc]initWithMaxTextLenght:500 isShowLimitCount:NO];
        _feedbackView.placeholder = KFeedBackPlaceholder;

        [_feedbackView setPlaceholderFont:[UIFont systemFontOfSize:(IS_IPHONE6PLUS ? 16:14)]];
        _feedbackView.delegate = self;
        _feedbackView.font = [UIFont systemFontOfSize:(IS_IPHONE6PLUS ? 16:14)];
        _feedbackView.keyboardType = UIKeyboardTypeDefault;
        _feedbackView.textAlignment = NSTextAlignmentLeft;
        //_feedbackView.backgroundColor = [UIColor whiteColor];
        _feedbackView.textColor = COLOR_333333;
        _feedbackView.clipsToBounds = YES;
        _feedbackView.layer.cornerRadius = 3;
        _feedbackView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedbackInfoDidChange) name:UITextViewTextDidChangeNotification object:_feedbackView];
        
        _feedbackView.backgroundColor = COLOR_FFFFFF_3D4752;
        [_feedbackView setPlaceholderColor:COLOR_A8ABBE_7B8196];
        _feedbackView.textColor = [UIColor hkdm_colorWithColorLight:COLOR_333333 dark:COLOR_EFEFF6];
        _feedbackView.tintColor = [UIColor hkdm_colorWithColorLight:COLOR_27323F dark:COLOR_EFEFF6];
    }
    return _feedbackView;
}


- (UITextField*)phoneTextField {
    
    if (!_phoneTextField) {
        
        _isQQEmpty = YES;
        _phoneTextField = [UITextField new];
        _phoneTextField.delegate = self;
        _phoneTextField.backgroundColor = COLOR_FFFFFF_3D4752;
        _phoneTextField.font = [UIFont systemFontOfSize:(IS_IPHONE6PLUS ? 16:14)];
        _phoneTextField.keyboardType = UIKeyboardTypeDefault;
        
        //_phoneTextField.textc
        NSMutableAttributedString *attributed = [NSMutableAttributedString changeCorlorWithColor:COLOR_A8ABBE_7B8196
                                                                                     TotalString:@"请输入邮箱、QQ、手机号"
                                                                                  SubStringArray:@[@"请输入邮箱、QQ、手机号"]];
        _phoneTextField.attributedPlaceholder = attributed;
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.clipsToBounds = YES;
        _phoneTextField.layer.cornerRadius = 3;
        [_phoneTextField sizeToFit];
        
        UILabel *contactWayLB = [[UILabel alloc] init];
        contactWayLB.text = @"    联系方式    ";
        contactWayLB.textColor = COLOR_27323F_EFEFF6;// HKColorFromHex(0x27323F, 1.0);
        contactWayLB.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS? 16.0 : 14.0 ];
        [contactWayLB sizeToFit];
        contactWayLB.width = contactWayLB.width + 10.0;
        _phoneTextField.leftView = contactWayLB;
        //设置显示模式为永远显示(默认不显示)
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:_phoneTextField];
    }
    return _phoneTextField;
}




- (UIButton*)submitBtn {
    
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithTitle:@"提交" titleColor:[UIColor whiteColor] titleFont:nil imageName:nil];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_submitBtn setTitleColor:HKColorFromHex(0x7B8196, 1.0) forState:UIControlStateDisabled];
        
        UIColor *color = [UIColor colorWithHexString:@"#ff8c00"];
        UIColor *color1 = [UIColor colorWithHexString:@"#ffa000"];
        UIColor *color2 = [UIColor colorWithHexString:@"#ffb200"];
        UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(430 * 0.5, 75 * 0.5) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        [_submitBtn setBackgroundImage:imageTemp forState:UIControlStateNormal];
        
        [_submitBtn setBackgroundImage:imageTemp forState:UIControlStateDisabled];
        
        _submitBtn.clipsToBounds = YES;
        _submitBtn.layer.cornerRadius = PADDING_25;
        [_submitBtn addTarget:self action:@selector(submitFeedback:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}



- (void)feedbackInfoDidChange {
    
    if (_feedbackView.text.length > 0) {
        self.isFeedbackEmpty = NO;
        if (self.isQQEmpty == NO) {
        }
    }else{
        self.isFeedbackEmpty = YES;
    }
}




- (void)phoneTextFieldDidChange {
    
    if (self.phoneTextField.text.length > 0) {
        self.isQQEmpty = NO;
        if (self.isFeedbackEmpty == NO ){
        }
    }else{
        self.isQQEmpty = YES;
    }
}



#pragma mark UITextField 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.phoneTextField resignFirstResponder];
    return YES;
}



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)submitFeedback:(id)sender {
    
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    NSString *mess = _feedbackView.text;
    NSUInteger textLength = mess.length;
    NSString *phone =  _phoneTextField.text;
    
    // 少于剂15个字
    if (isEmpty(mess) || textLength < 15) {
        showTipDialog(@"请完善描述，不能少于15个字哦~");
        return;
    } else if (isEmpty(phone)) {
        // 联系方式不能为空
        showTipDialog(@"请输入您的联系方式");
        return;
    } else if (!isEmpty(mess) && !isEmpty(phone) &&(textLength >= 15)) {
        [MobClick event:UM_RECORD_MYINFO_SUGGEST];
        [self submitMessage:mess qq:phone commentId:self.commentId];
    }
}


- (void)submitMessage:(NSString*)content qq:(NSString*)qq commentId:(NSString*)commentId {
    
    WeakSelf;
    _submitBtn.userInteractionEnabled = NO;
    UserInfoServiceMediator *mange = [UserInfoServiceMediator sharedInstance];
    [mange submitMessageWithToken:nil content:content qq:qq commentId:commentId completion:^(FWServiceResponse *response) {
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            showTipDialog(@"提交成功");
            [weakSelf backAction];
        }else{
            showTipDialog(@"提交失败");
        }
        weakSelf.submitBtn.userInteractionEnabled = YES;
    } failBlock:^(NSError *error) {
        showTipDialog(@"提交失败");
        weakSelf.submitBtn.userInteractionEnabled = YES;
    }];
}


@end



