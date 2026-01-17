//
//  HKEditUserTitleVC.m
//  Code
//
//  Created by Ivan li on 2018/3/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKEditUserTitleVC.h"
#import "HKContainerModel.h"
#import "DetailModel.h"

@interface HKEditUserTitleVC ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *titleField;

@property(nonatomic,strong)UILabel *tipLabel;

@end

@implementation HKEditUserTitleVC

- (void)loadView {
    [super loadView];
    [self createUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    self.title = @"编辑昵称";
    //self.view.backgroundColor = [UIColor whiteColor];
    [self createLeftBarButton];
    //[self rightBarButtonItemWithTitle:@"确认" action:@selector(editTitle)];
    [self rightBarButtonItemWithTitle:@"确认" color:COLOR_27323F_EFEFF6 action:@selector(editTitle)];
    
    [self.view addSubview:self.titleField];
    [self.view addSubview:self.tipLabel];
    
    [_titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(KNavBarHeight64+PADDING_15);
        make.left.equalTo(self.view.mas_left).offset(PADDING_15);
        make.right.equalTo(self.view.mas_right).offset(-PADDING_15);
        make.height.mas_equalTo(45);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleField);
        make.top.equalTo(_titleField.mas_bottom).offset(2);
    }];
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
}



- (void)editTitle {
    
    NSString *title = self.titleField.text;
    if (!isEmpty(title)) {
        //[self setAlbumWithAlbumName:title];
        if (title.length >0 && title.length<2) {
            showTipDialog(@"请输入2~8个字符");
            return;
        }
        // 清除字符串 首位空格
        NSString *temp = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [self modifyNickNameWithName:temp];
        
    }else{
        showTipDialog(@"昵称不能为空");
    }
}


- (UITextField*)titleField {
    
    if (!_titleField) {
        _titleField = [UITextField new];
        _titleField.delegate = self;
        [_titleField setBackgroundColor:COLOR_F6F6F6];
        //_titleField.placeholder = @"请填写昵称";
        _titleField.font = HK_FONT_SYSTEM(14);
        [_titleField setTextColor:COLOR_333333];
        _titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _titleField.layer.cornerRadius = PADDING_5;
        [_titleField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _titleField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 6, 0)];
        //设置显示模式为永远显示(默认不显示)
        _titleField.leftViewMode = UITextFieldViewModeAlways;
        _titleField.text = [HKAccountTool shareAccount].username;
        _titleField.backgroundColor = COLOR_F6F6F6_3D4752;
        _titleField.textColor = [UIColor hkdm_colorWithColorLight:COLOR_333333 dark:COLOR_EFEFF6];
        _titleField.tintColor = [UIColor hkdm_colorWithColorLight:COLOR_27323F dark:COLOR_EFEFF6];
        
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请填写昵称" attributes:@{NSForegroundColorAttributeName:COLOR_7B8196,NSFontAttributeName :HK_FONT_SYSTEM(14)}];
        _titleField.attributedPlaceholder = placeholderString;
    }
    return _titleField;
}


- (UILabel*)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel labelWithTitle:CGRectZero title:@"请输入2-8个字符" titleColor:COLOR_999999 titleFont:@"13" titleAligment:0];
        _tipLabel.textColor = [UIColor hkdm_colorWithColorLight:COLOR_999999 dark:COLOR_A8ABBE];
    }
    return _tipLabel;
}


- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.titleField) {
        
        //NSString *textString = textField.text;
        // NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
        // 键盘输入模式// currentInputMode 在ios7之后弃用了。用下面的。
        NSString *lang = textField.textInputMode.primaryLanguage; // 键盘输入模式
        if ([lang isEqualToString:@"zh-Hans"]) {
            // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计、限制等处理
            if (!position) {
                if (textField.text.length > 8) {
                    textField.text = [textField.text substringToIndex:8];
                }
            }else{
                // 有高亮选择的字符串，则暂不对文字进行统计、限制等处理
            }
        }else{
            // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if (textField.text.length > 8) {
                textField.text = [textField.text substringToIndex:8];
            }
        }
    }
}









/** 修改用户昵称 */
- (void)modifyNickNameWithName:(NSString*)name {
    
    WeakSelf;
    [HKHttpTool POST:USER_UPDATE_USERNAME  parameters:@{@"username":name} success:^(id responseObject) {
        StrongSelf;
        if (HKReponseOK) {
            [strongSelf modifySucessWithName:name];
        }
    } failure:^(NSError *error) {
        
    }];
}



/** 修改昵称成功 回调 */
- (void)modifySucessWithName:(NSString*)name {
    
    showTipDialog(@"修改成功");
    HKUserModel *model = [HKAccountTool shareAccount];
    model.username = name;
    [HKAccountTool saveOrUpdateAccount:model];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:name forKey:LOGIN_NAME];
//    [defaults synchronize];
    
    HK_NOTIFICATION_POST(HKUserInfoChangeNotification, nil);
    self.editAblumTitleBlock ? self.editAblumTitleBlock(name,self.indexPath) :nil;
    [self backAction];
}





@end

