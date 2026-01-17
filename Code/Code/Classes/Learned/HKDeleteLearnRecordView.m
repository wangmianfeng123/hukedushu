

//
//  HKDeleteLearnRecordView.m
//  Code
//
//  Created by Ivan li on 2018/9/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKDeleteLearnRecordView.h"
#import <UIView+SNFoundation.h>


@implementation HKDeleteLearnRecordView

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
    
    /** 阴影 COLOR_E1E7EB*/
    //[self addShadowWithColor:[UIColor grayColor] alpha:0.7 radius:5 offset:CGSizeMake(3, 3)];
    [self addShadowWithColor];
    
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    [self addSubview:self.checkBoxBtn];
    [self addSubview:self.deleteBtn];
    [self addSubview:self.lineLabel];
}


- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    
    if (@available(iOS 13.0, *)) {
        // 主题模式 发生改变
        [self addShadowWithColor];
    }
}



- (void)addShadowWithColor {
    if (@available(iOS 13.0, *)) {
        if (DMUserInterfaceStyleDark == DMTraitCollection.currentTraitCollection.userInterfaceStyle) {
            [self addShadowWithColor:COLOR_333D48 alpha:1 radius:5 offset:CGSizeMake(3, 3)];
        }else{
            [self addShadowWithColor:[UIColor grayColor] alpha:0.7 radius:5 offset:CGSizeMake(3, 3)];
        }
        
    }else{
        [self addShadowWithColor:[UIColor grayColor] alpha:0.7 radius:5 offset:CGSizeMake(3, 3)];
    }
}




- (void)makeConstraints {
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    /*
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
    */
}


- (UILabel*)lineLabel {
    
    if (!_lineLabel) {
        
        _lineLabel = [UILabel new];
        _lineLabel.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        _lineLabel.hidden = YES;
    }
    return _lineLabel;
}


- (UIButton*)checkBoxBtn {
    
    if (!_checkBoxBtn) {
        _checkBoxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBoxBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_checkBoxBtn setTitle:@"取消全选" forState:UIControlStateSelected];
        [_checkBoxBtn setTitleColor:[UIColor colorWithHexString:@"#9b9b9b"] forState:UIControlStateNormal];
        [_checkBoxBtn setTitleColor:[UIColor colorWithHexString:@"#9b9b9b"] forState:UIControlStateSelected];
        [_checkBoxBtn addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
        _checkBoxBtn.hidden = YES;
    }
    return _checkBoxBtn;
}



- (void)checkboxClick:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    self.allSelectBlock ? self.allSelectBlock(btn) : nil;
}



- (UIButton*)deleteBtn {
    
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:COLOR_FF3221 forState:UIControlStateSelected];
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




