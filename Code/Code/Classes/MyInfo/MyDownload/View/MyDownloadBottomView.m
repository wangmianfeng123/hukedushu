//
//  MyDownloadBottomView.m
//  Code
//
//  Created by Ivan li on 2017/8/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "MyDownloadBottomView.h"

@implementation MyDownloadBottomView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)createUI {
    
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    [self addSubview:self.checkBoxBtn];
    [self addSubview:self.deleteBtn];
    [self addSubview:self.lineLabel];
    [self addSubview:self.topLineLabel];
}


- (void)makeConstraints {
    [_topLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    [_checkBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH/2-0.5);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.top.bottom.equalTo(self);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH/2-0.5);
    }];
}


- (UILabel*)lineLabel {
    
    if (!_lineLabel) {
        _lineLabel = [UILabel new];
        _lineLabel.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_eeeeee dark:COLOR_27323F];
    }
    return _lineLabel;
}


- (UILabel*)topLineLabel {
    
    if (!_topLineLabel) {
        _topLineLabel = [UILabel new];
        _topLineLabel.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_ffffff dark:COLOR_27323F];
    }
    return _topLineLabel;
}




- (UIButton*)checkBoxBtn {
    
    if (!_checkBoxBtn) {
        _checkBoxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBoxBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_checkBoxBtn setTitle:@"取消全选" forState:UIControlStateSelected];
        [_checkBoxBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
        [_checkBoxBtn setTitleColor:COLOR_27323F_EFEFF6  forState:UIControlStateSelected];
        [_checkBoxBtn addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBoxBtn;
}



-(void)checkboxClick:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    self.allSelectBlock ? self.allSelectBlock(btn) : nil;
}



- (UIButton*)deleteBtn {
    
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitleColor:COLOR_FF3221 forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:COLOR_FF3221 forState:UIControlStateSelected];
        _deleteBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_deleteBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateSelected];
        [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _deleteBtn;
}


- (void)setPurchaseCount:(NSString*)count {
    
    [self.deleteBtn setTitle:count forState:UIControlStateNormal];
}


- (void)deleteAction:(UIButton *)btn {
    self.deleteBlock ? self.deleteBlock(btn) : nil;
}


- (void)setCheckTitlNormalColor:(UIColor *)checkTitlNormalColor {
    _checkTitlNormalColor = checkTitlNormalColor;
    [_checkBoxBtn setTitleColor:checkTitlNormalColor forState:UIControlStateNormal];
}


- (void)setCheckTitlSelectedColor:(UIColor *)checkTitlSelectedColor {
    _checkTitlSelectedColor = checkTitlSelectedColor;
    [_checkBoxBtn setTitleColor:checkTitlSelectedColor forState:UIControlStateSelected];
}



- (void)setDeleteTitlNormaColor:(UIColor *)deleteTitlNormaColor {
    _deleteTitlNormaColor = deleteTitlNormaColor;
    [_deleteBtn setTitleColor:deleteTitlNormaColor forState:UIControlStateNormal];
}


- (void)setDeleteTitlSelectedColor:(UIColor *)deleteTitlSelectedColor {
    _deleteTitlSelectedColor = deleteTitlSelectedColor;
    [_deleteBtn setTitleColor:deleteTitlSelectedColor forState:UIControlStateSelected];
}





@end



