//
//  HKBookCommentChildrenTopBgCell.m
//  Code
//
//  Created by Ivan li on 2019/8/31.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookCommentChildrenTopBgCell.h"
#import "UIView+SNFoundation.h"
#import "HKBookCommentModel.h"


@implementation HKBookCommentChildrenTopBgCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    
    [self.contentView addSubview:self.bgView];
    //    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.bottom.equalTo(self.contentView);
    //        make.left.equalTo(self.contentView).offset(65);
    //        make.right.equalTo(self.contentView).offset(-15);
    //    }];
    self.bgView.frame = CGRectMake(65, 0, self.width - 80, 10);
    [self.bgView setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:5];
}


- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return _bgView;
}


- (void)setModel:(HKBookCommentModel *)model {
    _model = model;
}


-(void)bindViewModel:(HKBookActionModel *)viewModel {
    self.model = viewModel.model;
}



@end


