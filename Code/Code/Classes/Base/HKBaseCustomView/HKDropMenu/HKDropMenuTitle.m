//
//  HKDropMenuTitle.m
//  Code
//
//  Created by Ivan li on 2019/1/7.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKDropMenuTitle.h"
#import "HKDropMenuModel.h"
#import "NSString+Size.h"



@implementation HKDropMenuTitle


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}


- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.label];
    [self addSubview:self.imageView];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.dropMenuModel.titleCenter) {
            make.centerX.equalTo(self);
        }else{
            make.left.equalTo(self).offset(PADDING_15);
        }
        make.centerY.equalTo(self);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label.mas_right).offset(PADDING_5);
        make.centerY.equalTo(self).offset(2);
    }];
}



- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = [UIColor darkGrayColor];
    }
    return _bottomLine;
}


- (UIView *)topLine {
    if (_topLine == nil) {
        _topLine = [[UIView alloc]init];
        _topLine.backgroundColor = [UIColor darkGrayColor];
    }
    return _topLine;
}


- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}


- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc]init];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = COLOR_27323F;
    }
    return _label;
}




- (void)setDropMenuModel:(HKDropMenuModel *)dropMenuModel {
    _dropMenuModel = dropMenuModel;
    self.label.text = dropMenuModel.title;
        
    UIColor *textColor = (dropMenuModel.titleSeleted || dropMenuModel.isHaveSectionSeleted)?dropMenuModel.titleSelectColor :dropMenuModel.titleColor;
    self.label.textColor = textColor;
    
    self.label.font = dropMenuModel.titleFont ?dropMenuModel.titleFont : [UIFont systemFontOfSize:14];
    // 箭头显示
    self.imageView.hidden = dropMenuModel.hiddenArrow;
    self.label.textAlignment = dropMenuModel.titleCenter ?NSTextAlignmentCenter :NSTextAlignmentLeft;
    
    NSString *name = (dropMenuModel.titleSeleted || dropMenuModel.isHaveSectionSeleted)?dropMenuModel.menuHighlightedImageName :dropMenuModel.menuImageName;
    
    self.imageView.image = [UIImage imageNamed:name];
    self.imageView.highlighted = dropMenuModel.titleSeleted;
}


@end

