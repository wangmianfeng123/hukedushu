//
//  HKPlayMaterialTipView.m
//  Code
//
//  Created by Ivan li on 2018/4/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKPlayMaterialTipView.h"

@implementation HKPlayMaterialTipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}


- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}


- (void)setUp {
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = PADDING_5;
    self.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.6];
    
    [self addSubview:self.tipLabel];
    [self addSubview:self.closeBtn];
    [self addSubview:self.tipDetailLabel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 3.5)), dispatch_get_main_queue(), ^{
            [self removeView];
    });
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(PADDING_15);
        make.top.equalTo(self).offset(PADDING_10);
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_tipDetailLabel.mas_right);
        make.top.equalTo(self).offset(PADDING_10);
    }];
    
    [_tipDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tipLabel.mas_bottom).offset(PADDING_5);
        make.left.equalTo(self).offset(PADDING_15);
    }];
}




- (UIButton*)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn setImage:imageName(@"hkplayer_fork_white") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setHKEnlargeEdge:15];
    }
    return _closeBtn;
}



- (UILabel*)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel labelWithTitle:CGRectZero title:@"温馨小提示：" titleColor:COLOR_ffffff titleFont:@"12" titleAligment:0];
    }
    return _tipLabel;
}


- (UILabel*)tipDetailLabel {
    if (!_tipDetailLabel) {
        _tipDetailLabel = [UILabel labelWithTitle:CGRectZero title:@"本课素材源文件请至网站该视频页下载哦~" titleColor:COLOR_ffffff titleFont:@"12" titleAligment:0];
        _tipDetailLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipLabelClickEvent:)];
        [_tipDetailLabel addGestureRecognizer:tapGest];
    }
    return _tipDetailLabel;
}


- (void)tipLabelClickEvent:(id)sender {
    [self removeView];
}




- (void)removeView {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self removeView];
}

@end
