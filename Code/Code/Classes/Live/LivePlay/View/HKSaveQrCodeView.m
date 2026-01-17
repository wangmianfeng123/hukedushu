

//
//  HKSaveQrCodeView.m
//  Code
//
//  Created by ivan on 2020/7/30.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKSaveQrCodeView.h"
#import "LEEAlert.h"
#import "UIImage+Helper.h"
#import "UIImage+SNFoundation.h"
#import "HKVersionModel.h"
#import "UIView+SNFoundation.h"


@interface HKSaveQrCodeView ()
///  二维码 图片
@property (nonatomic , strong ) UIImageView *codeIV;

@property (nonatomic , strong ) UIButton *savePhotoBtn; //更新按钮

@property (nonatomic , strong ) UIButton *closeButton; //关闭按钮

@property (nonatomic , strong ) UIView *bgView;

@property (nonatomic , strong ) UILabel *themeLB;

@property (nonatomic, strong) UIView * lineView;

@property (nonatomic , strong ) UILabel *descrLB;

/// 开课提醒
@property (nonatomic , strong ) UIButton *courseBtn;
/// 行业交流
@property (nonatomic , strong ) UIButton *contactBtn;
/// 问题答疑
@property (nonatomic , strong ) UIButton *questionBtn;
///前辈分享
@property (nonatomic , strong ) UIButton *shareBtn;
@end

@implementation HKSaveQrCodeView


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //初始化子视图
        [self initSubview];
    }
    return self;
}


- (void)initSubview{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.closeButton];
    [self.bgView addSubview:self.themeLB];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.descrLB];
    
    [self.bgView addSubview:self.courseBtn];
    [self.bgView addSubview:self.contactBtn];
    [self.bgView addSubview:self.questionBtn];
    [self.bgView addSubview:self.shareBtn];
    
    [self.bgView addSubview:self.codeIV];
    [self.bgView addSubview:self.savePhotoBtn];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
    }];
    
    
    [self.themeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.bgView).offset(25);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.themeLB.mas_bottom).offset(15);
        make.height.equalTo(@1);
        make.left.right.equalTo(self);
    }];
    
    [self.descrLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.themeLB.mas_bottom).offset(38);
        make.left.equalTo(self.bgView).offset(20);
    }];
    
    [self.courseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descrLB.mas_bottom).offset(12);
        make.left.equalTo(self.bgView).offset(15);
        make.size.mas_equalTo(CGSizeMake(120, 40));
    }];
    
    [self.contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.courseBtn);
        make.right.equalTo(self.bgView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(120, 40));
    }];
    
    [self.questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.courseBtn.mas_bottom).offset(10);
        make.left.equalTo(self.bgView).offset(15);
        make.size.mas_equalTo(CGSizeMake(120, 40));
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.questionBtn);
        make.right.equalTo(self.bgView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(120, 40));
    }];
    
    [self.codeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_lessThanOrEqualTo(120);
        make.width.lessThanOrEqualTo(self.bgView);
        make.top.equalTo(self.questionBtn.mas_bottom).offset(25);
    }];
    
    [self.savePhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-25);
        make.centerX.equalTo(self.bgView);
    }];

}


- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR_FFFFFF_3D4752;
        _bgView.clipsToBounds = YES;
        _bgView.layer.cornerRadius = 5;
    }
    return _bgView;
}




- (UILabel*)themeLB {
    if (!_themeLB) {
        _themeLB = [UILabel labelWithTitle:CGRectZero title:@"报名成功" titleColor:COLOR_27323F_EFEFF6 titleFont:nil titleAligment:NSTextAlignmentCenter];
        _themeLB.font = HK_FONT_SYSTEM_BOLD(17);
        _themeLB.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _themeLB;
}

-(UIView*)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#F6F6FB"];
    }
    return _lineView;
}


- (UILabel*)descrLB {
    if (!_descrLB) {
        _descrLB = [UILabel labelWithTitle:CGRectZero title:@"请务必添加班主任好友进群与老师交流\n入群可获得以下特权" titleColor:COLOR_27323F_EFEFF6 titleFont:@"13" titleAligment:NSTextAlignmentCenter];
        _descrLB.numberOfLines = 0;
        _descrLB.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _descrLB;
}





- (UIImageView*)codeIV {
    if (!_codeIV) {
        _codeIV = [UIImageView new];
        _codeIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _codeIV;
}



- (UIButton*)savePhotoBtn {
    if (!_savePhotoBtn) {
        _savePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_savePhotoBtn.titleLabel setFont:HK_FONT_SYSTEM(17)];
        [_savePhotoBtn setTitle:@"保存二维码图片到相册" forState:UIControlStateNormal];
        [_savePhotoBtn setTitle:@"保存二维码图片到相册" forState:UIControlStateHighlighted];
        [_savePhotoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_savePhotoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_savePhotoBtn addTarget:self action:@selector(savePhotoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                
        UIColor *color = [UIColor colorWithHexString:@"#FFBF00"];
        UIColor *color1 = [UIColor colorWithHexString:@"#FF7E00"];
        
        _savePhotoBtn.size = CGSizeMake(215, 40);
        UIImage *image = [[UIImage alloc]createImageWithSize:CGSizeMake(215, 40) gradientColors:@[(id)color,(id)color1] percentage:@[@(0.1),@(1)] gradientType:GradientFromLeftToRight];
        [_savePhotoBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_savePhotoBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        [_savePhotoBtn setRoundedCorners:UIRectCornerAllCorners radius:20];
    }
    return _savePhotoBtn;
}


- (UIButton*)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:imageName(@"ic_close_v2_15") forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setHKEnlargeEdge:20];
    }
    return _closeButton;
}



- (UIButton*)courseBtn {
    if (!_courseBtn) {
        UIColor *color = [[UIColor colorWithHexString:@"#FF8967"]colorWithAlphaComponent:0.1];
        UIImage *image = [UIImage imageNamed:@"ic_popup_notice"];
        _courseBtn = [self customBtnWithTitle:@"开课提醒" bgColor:color image:image];
    }
    return _courseBtn;
}


- (UIButton*)contactBtn {
    if (!_contactBtn) {
        UIColor *color = [[UIColor colorWithHexString:@"#7BC144"]colorWithAlphaComponent:0.1];
        UIImage *image = [UIImage imageNamed:@"ic_popup_conversation"];
        _contactBtn = [self customBtnWithTitle:@"行业交流" bgColor:color image:image];
    }
    return _contactBtn;
}



- (UIButton*)questionBtn {
    if (!_questionBtn) {
        UIColor *color = [[UIColor colorWithHexString:@"#FFB767"]colorWithAlphaComponent:0.1];
        UIImage *image = [UIImage imageNamed:@"ic_popup_qa"];
        _questionBtn = [self customBtnWithTitle:@"问题答疑" bgColor:color image:image];
    }
    return _questionBtn;
}




- (UIButton*)shareBtn {
    if (!_shareBtn) {
        UIColor *color = [[UIColor colorWithHexString:@"#D2ACFF"]colorWithAlphaComponent:0.1];
        UIImage *image = [UIImage imageNamed:@"ic_popup_share"];
        _shareBtn = [self customBtnWithTitle:@"前辈分享" bgColor:color image:image];
    }
    return _shareBtn;
}



- (UIButton*)customBtnWithTitle:(NSString*)title bgColor:(UIColor*)bgColor image:(UIImage*)image {
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [customBtn.titleLabel setFont:HK_FONT_SYSTEM(13)];
    [customBtn setImage:image forState:UIControlStateNormal];
    [customBtn setImage:image forState:UIControlStateHighlighted];
    [customBtn setTitle:title forState:UIControlStateNormal];
    [customBtn setTitle:title forState:UIControlStateHighlighted];
    [customBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
    [customBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateHighlighted];
     
    [customBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    customBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [customBtn setBackgroundColor:bgColor forState:UIControlStateNormal];
    [customBtn setBackgroundColor:bgColor forState:UIControlStateHighlighted];
    customBtn.size = CGSizeMake(120, 40);
    [customBtn setRoundedCorners:UIRectCornerAllCorners radius:5];
    return customBtn;
}





- (void)savePhotoBtnAction:(UIButton *)sender{
    
    if (self.updateBlock) self.updateBlock();
}


#pragma mark - 关闭按钮点击事件
- (void)closeButtonAction:(UIButton *)sender{
    if (self.closeBlock) self.closeBlock();
}



- (void)setModel:(HKVersionModel *)model {
    _model = model;
    [self.codeIV sd_setImageWithURL:HKURL(model.url) placeholderImage:HK_PlaceholderImage];
}




+ (void)showDownAppViewWithModel:(HKVersionModel *)model nextBlock:( void (^)(void)) nextBlock {
    HKSaveQrCodeView *view = [[HKSaveQrCodeView alloc] initWithFrame:CGRectMake(0, 0, 280, 446)];
    view.model = model;
    view.closeBlock = ^{
        [LEEAlert closeWithCompletionBlock:nil];
    };
    view.updateBlock = ^{
        if (nextBlock) {
            nextBlock();
        }
        [LEEAlert closeWithCompletionBlock:nil];
    };
    [LEEAlert alert].config
    .LeeCustomView(view)
    .LeeQueue(YES)
    .LeePriority(1)
    .LeeCornerRadius(0)
    .LeeHeaderColor([UIColor clearColor])
    .LeeHeaderInsets(UIEdgeInsetsZero)
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeMaxWidth(320)
    .LeeShow();
}


@end






