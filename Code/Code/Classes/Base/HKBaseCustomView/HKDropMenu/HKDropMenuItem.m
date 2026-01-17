//
//  HKDropMenuItem.m
//  Code
//
//  Created by Ivan li on 2019/1/7.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKDropMenuItem.h"
#import "HKDropMenuModel.h"
#import "HKDropMenuTitle.h"
#import "UIView+HKLayer.h"

@interface HKDropMenuItem ()
@property (nonatomic , strong) UIView * bgView;
@end

@implementation HKDropMenuItem

- (void)setDropMenuModel:(HKDropMenuModel *)dropMenuModel {
    _dropMenuModel = dropMenuModel;
    self.dropMenuTitle.dropMenuModel = dropMenuModel;
//    _bgView.backgroundColor = _dropMenuModel.titleSeleted ? [UIColor colorWithHexString:@"#FFF0E6"]:[UIColor colorWithHexString:@"#F8F9FA"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor clearColor];
//    [self addSubview:self.bgView];
    [self addSubview:self.dropMenuTitle];
//    [self.bgView addCornerRadius:self.frame.size.height * 0.5];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dropMenuTitle.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    self.bgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
}

- (void)tap:(UITapGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropMenuItem:dropMenuModel:)]) {
        [self.delegate dropMenuItem:self dropMenuModel:self.dropMenuModel];
    }
}

//- (UIView *)bgView{
//    if (_bgView == nil) {
//        _bgView = [[UIView alloc] init];
//        _bgView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
//    }
//    return _bgView;
//}

- (HKDropMenuTitle *)dropMenuTitle {
    if (_dropMenuTitle == nil) {
        _dropMenuTitle = [[HKDropMenuTitle alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tap.delegate = self;
        [_dropMenuTitle addGestureRecognizer:tap];
    }
    return _dropMenuTitle;
}



@end

