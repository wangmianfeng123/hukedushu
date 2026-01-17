

//
//  HKBulidAlbumVCDialog.m
//  Code
//
//  Created by Ivan li on 2018/7/31.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBulidAlbumVCDialog.h"
#import "HKContainerModel.h"
#import "DetailModel.h"
#import "HKTextField.h"
#import <TBScrollViewEmpty/TBScrollViewEmpty.h>



#define  VIEW_HEIGHT  (IS_IPAD ?447 :SCREEN_HEIGHT-110*2)

@interface HKBulidAlbumVCDialog ()<UITextFieldDelegate>

@property(nonatomic,strong)HKTextField *titleField;

@property(nonatomic,strong)UILabel *tipLabel;

@property(nonatomic,strong)UIView *bgView;

@property(nonatomic,strong)UIView *headBgView;


@end



@implementation HKBulidAlbumVCDialog


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createUI {
    //self.title = @"新建专辑";
    //[self createLeftBarButton];
    //[self rightBarButtonItemWithTitle:@"完成" color:COLOR_27323F action:@selector(editTitle)];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bgView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-46, VIEW_HEIGHT));
    }];
    
    [self setHeaderView];
    [self.bgView addSubview:self.titleField];
    [self.bgView addSubview:self.tipLabel];
    
    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headBgView.mas_bottom);
        make.left.equalTo(self.headBgView).offset(PADDING_20);
        make.right.equalTo(self.headBgView).offset(-PADDING_20);
        make.height.mas_equalTo(32);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleField.mas_bottom).offset(6);
        make.right.equalTo(self.titleField);
    }];
}



- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR_FFFFFF_333D48;
        _bgView.clipsToBounds = YES;
        _bgView.layer.cornerRadius = 5;
    }
    return _bgView;
}


- (UIView*)headBgView {
    if (!_headBgView) {
        _headBgView = [UIView new];
    }
    return _headBgView;
}



- (void)setHeaderView {
    
    [self.bgView addSubview:self.headBgView];
    
    UIButton *closeBtn = [UIButton buttonWithTitle:nil titleColor:COLOR_333333 titleFont:@"15" imageName:@"ic_close"];
    UIImage *normalImage = [UIImage hkdm_imageWithNameLight:@"ic_close" darkImageName:@"ic_close_dark"];
    [closeBtn setImage:normalImage forState:UIControlStateNormal];
    
    [closeBtn setHKEnlargeEdge:PADDING_15];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headBgView addSubview:closeBtn];
    
    
    UIButton *bulidBtn = [UIButton buttonWithTitle:@"完成" titleColor:COLOR_27323F_EFEFF6 titleFont:@"16"  imageName:nil];
    [bulidBtn setHKEnlargeEdge:PADDING_15];
    [bulidBtn addTarget:self action:@selector(bulidBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headBgView addSubview:bulidBtn];
    
    
    [self.headBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.bgView);
        make.height.mas_equalTo(63);
    }];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headBgView.mas_left).offset(PADDING_20);
        make.top.equalTo(self.headBgView).offset(23);
    }];
    
    [bulidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headBgView.mas_right).offset(-PADDING_20);
        make.centerY.equalTo(closeBtn);
    }];
}



- (void)closeBtnClick {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}



- (void)bulidBtnClick {
    
    NSString *title = self.titleField.text;
    if (!isEmpty(title)) {
        [self bulidAlbumWithName:title];
    }else{
        showTipDialog(@"请输入专辑标题～");
    }
}



- (void)setDetailModel:(DetailModel *)detailModel {
    _detailModel = detailModel;
}



- (HKTextField*)titleField {
    
    if (!_titleField) {
        _titleField = [[HKTextField alloc]init];
        
        _titleField.clipsToBounds = YES;
        _titleField.layer.cornerRadius = 16;
        
        _titleField.delegate = self;
        [_titleField setBackgroundColor:COLOR_EFEFF6];
        _titleField.font = HK_FONT_SYSTEM(14);
        
        [_titleField setTextColor:COLOR_27323F_EFEFF6];
        _titleField.backgroundColor = COLOR_F6F6F6_3D4752;
        
        _titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_titleField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        NSString *placeholder = @"请填写合集名称";
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName : COLOR_7B8196_A8ABBE,NSFontAttributeName :HK_FONT_SYSTEM(14)}];
        _titleField.attributedPlaceholder = placeholderString;
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




#pragma mark - 创建专辑
- (void)bulidAlbumWithName:(NSString*)albumName {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:albumName,@"album_name",nil];
    [HKHttpTool POST:ALBUM_CREATE parameters:parameters success:^(id responseObject) {
        
        if (HKReponseOK) {
            HKAlbumModel *model = [HKAlbumModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.hKBulidAlbumBlock ?self.hKBulidAlbumBlock(model) :nil;
            [self closeBtnClick];
        }
    } failure:^(NSError *error) {
        
    }];
}




- (void)dealloc {
    HK_NOTIFICATION_REMOVE();

}

@end




