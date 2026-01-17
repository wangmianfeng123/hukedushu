//
//  HKGuideCommentDialog.m
//  Code
//
//  Created by Ivan li on 2018/1/24.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKGuideCommentDialog.h"

@interface HKGuideCommentDialog()

@property(nonatomic,strong)UIView *bgView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIButton *leftBtn;

@property(nonatomic,strong)UIButton *rightBtn;
/** 中间分隔线 */
@property(nonatomic,strong)UILabel *lineLabel;

@property(nonatomic,strong)UIButton *closeBtn;

@end



@implementation HKGuideCommentDialog



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)createUI {
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.lineLabel];
    [self.bgView addSubview:self.leftBtn];
    [self.bgView addSubview:self.rightBtn];
    [self.bgView addSubview:self.closeBtn];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(19);
    }];
}



- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
    }
    return _bgView;
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_333333 titleFont:@"17" titleAligment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}


- (UILabel*)lineLabel {
    if (!_lineLabel) {
        _lineLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_333333 titleFont:nil titleAligment:NSTextAlignmentCenter];
    }
    return _lineLabel;
}

- (UIButton*)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithTitle:@"吐个槽" titleColor:COLOR_333333 titleFont:@"15" imageName:@"thumb_brown"];
    }
    return _leftBtn;
}


- (UIButton*)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithTitle:@"点个赞" titleColor:COLOR_333333 titleFont:@"15" imageName:@"face_yellow"];
    }
    return _rightBtn;
}


- (UIButton*)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithTitle:nil titleColor:COLOR_333333 titleFont:@"15" imageName:@"delete_gray"];
    }
    return _closeBtn;
}







@end
