//
//  MyDownloadBottomView.m
//  Code
//
//  Created by Ivan li on 2017/8/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HkDownloadBottomView.h"

@implementation HKDownloadBottomView



- (instancetype) initWithFrame:(CGRect)frame  viewType:(HKDownloadBottomViewType)viewType {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewType = viewType;
        [self createUI];
    }
    return self;
}


- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)setupconfirmTitle:(NSString *)title {
    [self.confirmBtn setTitle:title forState:UIControlStateNormal];
}


- (void)setupconfirmTextColor:(UIColor *)cololor  selectColor:(UIColor *)selectColor {
    [self.confirmBtn setTitleColor:cololor forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:selectColor forState:UIControlStateSelected];
}


- (void)layoutSubviews {

    [super layoutSubviews];
    [self makeConstraints];
}


- (void)createUI {

    self.backgroundColor = COLOR_FFFFFF_3D4752;
    [self addSubview:self.lineLabel];
    [self addSubview:self.checkBoxBtn];
    [self addSubview:self.confirmBtn];
    
    if (HKDownloadBottomViewType_loading == self.viewType) {
        self.checkBoxBtn.hidden = YES;
        
        UIColor *color2 = [UIColor colorWithHexString:@"#FFB600"];
        UIColor *color1 = [UIColor colorWithHexString:@"#FFA300"];
        UIColor *color = [UIColor colorWithHexString:@"#FF8A00"];
        UIImage *image = [[UIImage alloc]createImageWithSize:CGSizeMake(SCREEN_WIDTH - 30, 50) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.5),@(1)] gradientType:GradientFromLeftToRight];
        
        self.confirmBtn.clipsToBounds = YES;
        self.confirmBtn.layer.cornerRadius = 25;
        [self.confirmBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.confirmBtn setBackgroundImage:image forState:UIControlStateSelected];
        [self.confirmBtn setTitleColor:COLOR_ffffff forState:UIControlStateSelected];
        [self.confirmBtn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
    }else{

    }
}


- (void)makeConstraints {
    
    
    if (HKDownloadBottomViewType_loading == self.viewType) {
        
        [self.checkBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH/2-0.5);
        }];
        
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.top.bottom.equalTo(self);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(5);
            make.left.equalTo(self).offset(15);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 50));
        }];
    }else{
        
        [self.checkBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH/2-0.5);
        }];
    
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.top.bottom.equalTo(self);
            make.centerX.equalTo(self.mas_centerX);
        }];
    
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH/2-0.5);
        }];
    }
}


- (UILabel*)lineLabel {

    if (!_lineLabel) {

        _lineLabel = [UILabel new];
        _lineLabel.hidden = YES;
        _lineLabel.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    }
    return _lineLabel;
}


- (UIButton*)checkBoxBtn {

    if (!_checkBoxBtn) {
        _checkBoxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBoxBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_checkBoxBtn setTitle:@"取消全选" forState:UIControlStateSelected];
        // v2.17
        [_checkBoxBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
        [_checkBoxBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateSelected];
        [_checkBoxBtn addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBoxBtn;
}



-(void)checkboxClick:(UIButton *)btn {

    btn.selected = !btn.selected;
    self.confirmBtn.selected = btn.selected;

    self.allSelectBlock ? self.allSelectBlock(btn) : nil;
}



- (UIButton*)confirmBtn {

    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitleColor:COLOR_A8ABBE forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:COLOR_27323F forState:UIControlStateSelected];
        _confirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_confirmBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [_confirmBtn setTitle:@"确认下载" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}


- (void)setPurchaseCount:(NSString*)count {

    [self.confirmBtn setTitle:count forState:UIControlStateNormal];
}


- (void)confirmAction:(UIButton *)btn {
    self.confirmBlock ? self.confirmBlock() : nil;
}


@end




