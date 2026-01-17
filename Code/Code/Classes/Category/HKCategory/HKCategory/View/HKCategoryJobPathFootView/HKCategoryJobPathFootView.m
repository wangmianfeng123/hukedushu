//
//  HKCategoryJobPathFootView.m
//  Code
//
//  Created by ivan on 2020/6/29.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKCategoryJobPathFootView.h"

@implementation HKCategoryJobPathFootView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}


- (void)creatUI{
    
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    [self addSubview:self.lineView];    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.left.equalTo(self).offset(PADDING_15);
        make.top.equalTo(self).offset(3);
        make.height.mas_equalTo(@1);
    }];
}


- (UIView*)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return  _lineView;
}

@end
