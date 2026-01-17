//
//  ZFHKNormalPlayerMaterialTipView.m
//  Code
//
//  Created by Ivan li on 2019/3/14.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "ZFHKNormalPlayerMaterialTipView.h"


@interface ZFHKNormalPlayerMaterialTipView()

//@property (nonatomic,strong) UILabel *tipLabel;

@property (nonatomic,strong) UILabel *tipDetailLabel;

@property (nonatomic,strong) UIButton *closeBtn;

@end


@implementation ZFHKNormalPlayerMaterialTipView

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
    self.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.5];
    
    //[self addSubview:self.tipLabel];
    [self addSubview:self.closeBtn];
    [self addSubview:self.tipDetailLabel];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 3.5)), dispatch_get_main_queue(), ^{
//        [self removeView];
//    });
    [self performSelector:@selector(removeView) withObject:nil afterDelay:4];
}




- (void)layoutSubviews {
    [super layoutSubviews];
//    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(PADDING_15);
//        make.top.equalTo(self).offset(PADDING_10);
//    }];
//
//    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_tipDetailLabel.mas_right);
//        make.top.equalTo(self).offset(PADDING_10);
//    }];
//
//    [_tipDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_tipLabel.mas_bottom).offset(PADDING_5);
//        make.left.equalTo(self).offset(PADDING_15);
//    }];
    
//    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(PADDING_10);
//        make.top.equalTo(self).offset(8);
//    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(_tipDetailLabel);
        make.size.mas_lessThanOrEqualTo(CGSizeMake(16, 16));
    }];
    
    [_tipDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self).offset(PADDING_10);
        make.right.equalTo(_closeBtn.mas_left).offset(-2);
    }];
}




- (UIButton*)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn setImage:imageName(@"hkplayer_fork_white") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setHKEnlargeEdge:20];
    }
    return _closeBtn;
}



//- (UILabel*)tipLabel {
//    if (!_tipLabel) {
//        _tipLabel = [UILabel labelWithTitle:CGRectZero title:@"温馨小提示：" titleColor:COLOR_ffffff titleFont:@"12" titleAligment:0];
//    }
//    return _tipLabel;
//}


- (UILabel*)tipDetailLabel {
    if (!_tipDetailLabel) {
        _tipDetailLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_ffffff titleFont:@"12" titleAligment:0];
        NSString *str = @"温馨小提示：\n本课素材源文件请至网\n站该视频页下载哦~";
        NSMutableAttributedString *text = [NSMutableAttributedString changeLineSpaceWithTotalString:str LineSpace:3];
        _tipDetailLabel.attributedText = text;
        
        _tipDetailLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipLabelClickEvent:)];
        [_tipDetailLabel addGestureRecognizer:tapGest];
        _tipDetailLabel.numberOfLines = 0;
    }
    return _tipDetailLabel;
}


- (void)tipLabelClickEvent:(id)sender {
    [self removeView];
}


- (void)removeView {
    
    [self removeFromSuperview];
    
//    [UIView animateWithDuration:0.5 animations:^{
//        self.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
}


- (void)immediateRemoveView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeView) object:nil];
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self removeView];
}


- (void)dealloc {
    [self immediateRemoveView];
}

@end
