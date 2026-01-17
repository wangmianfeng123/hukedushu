//
//  HKEditAblumTitleVC.m
//  Code
//
//  Created by Ivan li on 2017/12/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKEditAblumTitleVC.h"
#import "HKContainerModel.h"
#import "DetailModel.h"
#import "HKTextField.h"

@interface HKEditAblumTitleVC ()<UITextFieldDelegate>

@property(nonatomic,strong)HKTextField *titleField;

@property(nonatomic,strong)UILabel *tipLabel;


@end

@implementation HKEditAblumTitleVC

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
    self.title = @"编辑名称";
    self.view.backgroundColor =  COLOR_FFFFFF_333D48;//[UIColor whiteColor];
    [self createLeftBarButton];
    [self rightBarButtonItemWithTitle:@"完成" color:COLOR_27323F_EFEFF6 action:@selector(editTitle)];
    
    [self.view addSubview:self.titleField];
    [self.view addSubview:self.tipLabel];
    
    [_titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(KNavBarHeight64+22);
        make.height.mas_equalTo(32);
        make.left.equalTo(self.view).offset(PADDING_15);
        make.right.equalTo(self.view).offset(-PADDING_15);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleField.mas_bottom).offset(6);
        make.right.equalTo(self.titleField);
    }];
}



- (void)editTitle {
    
    NSString *title = self.titleField.text;
    if (!isEmpty(title)) {
        //[self setAlbumWithAlbumName:title];
        self.editAblumTitleBlock ? self.editAblumTitleBlock(title,self.indexPath) :nil;
        [self backAction];
    }else{
        showTipDialog(@"请输入专辑标题～");
    }
}



- (HKTextField*)titleField {
    
    if (!_titleField) {
        _titleField = [[HKTextField alloc]init];
        
        _titleField.clipsToBounds = YES;
        _titleField.layer.cornerRadius = 16;
        
        _titleField.delegate = self;
        [_titleField setBackgroundColor:COLOR_EFEFF6];
        //_titleField.placeholder = @"请填写合集名称";
        _titleField.font = HK_FONT_SYSTEM(14);
        [_titleField setTextColor:COLOR_27323F_EFEFF6];
        
        _titleField.backgroundColor = COLOR_F6F6F6_3D4752;
        NSString *placeholder = @"请填写合集名称";
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName : COLOR_7B8196_A8ABBE,NSFontAttributeName :HK_FONT_SYSTEM(14)}];
        _titleField.attributedPlaceholder = placeholderString;
        
        _titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_titleField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _titleField;
}




- (UILabel*)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel labelWithTitle:CGRectZero title:@"请输入1～15个字符哦" titleColor:COLOR_A8ABBE titleFont:@"12" titleAligment:NSTextAlignmentRight];
    }
    return _tipLabel;
}


- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.titleField) {
        NSLog(@"---->>>%@",textField.text);
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
        }
    }
}






@end
