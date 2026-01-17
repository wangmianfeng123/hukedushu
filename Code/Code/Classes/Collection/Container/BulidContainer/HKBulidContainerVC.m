
//
//  HKBulidContainerVC.m
//  Code
//
//  Created by Ivan li on 2017/11/27.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBulidContainerVC.h"
#import "HKContainerModel.h"
#import "DetailModel.h"
#import "HKTextField.h"

@interface HKBulidContainerVC ()<UITextFieldDelegate>

@property(nonatomic,strong)HKTextField *titleField;

@property(nonatomic,strong)UILabel *tipLabel;

@end

@implementation HKBulidContainerVC

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
    self.title = @"新建专辑";
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    [self createLeftBarButton];
    [self rightBarButtonItemWithTitle:@"完成" color:COLOR_27323F_EFEFF6 action:@selector(editTitle)];
    
    [self.view addSubview:self.titleField];
    [self.view addSubview:self.tipLabel];
    [self makeConstraints];
}


- (void)makeConstraints {
    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(KNavBarHeight64+PADDING_10);
        make.height.mas_equalTo(32);
        make.left.equalTo(self.view).offset(PADDING_15);
        make.right.equalTo(self.view).offset(-PADDING_15);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleField.mas_bottom).offset(6);
        make.left.equalTo(self.titleField).offset(PADDING_10);
        make.right.equalTo(self.titleField);
    }];
}



- (void)setDetailModel:(DetailModel *)detailModel {
    _detailModel = detailModel;
}



- (void)editTitle {
    
    NSString *title = self.titleField.text;
    if (!isEmpty(title)) {
        [self bulidAlbumWithName:title];
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
        UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_EFEFF6 dark:COLOR_333D48];
        [_titleField setBackgroundColor:bgColor];
        _titleField.font = HK_FONT_SYSTEM(14);
        [_titleField setTextColor:COLOR_27323F_EFEFF6];
        
        NSString *placeholder = @"为你的专辑添加一个标题";
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName : COLOR_7B8196_A8ABBE,NSFontAttributeName :HK_FONT_SYSTEM(14)}];
        _titleField.attributedPlaceholder = placeholderString;
        
        _titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_titleField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _titleField;
}


- (UILabel*)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel labelWithTitle:CGRectZero title:@"请输入1～15个字符哦" titleColor:COLOR_A8ABBE_7B8196 titleFont:@"12" titleAligment:NSTextAlignmentRight];
    }
    return _tipLabel;
}


- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.titleField) {
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
        }
    }
}


#pragma mark - 创建专辑
- (void)bulidAlbumWithName:(NSString*)albumName {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:albumName,@"album_name",nil];
    [HKHttpTool POST:ALBUM_CREATE parameters:parameters success:^(id responseObject) {
        
        if (HKReponseOK) {            
            HKAlbumModel *model = [HKAlbumModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            [self backAction];
            self.hkBulidContainerVCBlock ?self.hkBulidContainerVCBlock(model) :nil;
        }
    } failure:^(NSError *error) {
        
    }];
}



- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}

@end




