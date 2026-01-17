//
//  HomeRecomdCell.m
//  Code
//
//  Created by Ivan li on 2017/10/12.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HomeRecommendeFooterMoreCell.h"

@interface HomeRecommendeFooterMoreCell()

@property (nonatomic, strong)UIView *separatorLine;

@end

@implementation HomeRecommendeFooterMoreCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    
    [self addSubview:self.changeBtn];
    [self addSubview:self.separatorLine];
    
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.top.left.right.mas_equalTo(self);
    }];
    
    [_changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
    [_changeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];//图片位置偏移
}

- (UIView *)separatorLine {
    
    if (!_separatorLine) {
        _separatorLine  = [UILabel new];
        _separatorLine.backgroundColor = COLOR_F8F9FA_3D4752;
    }
    return _separatorLine;
}

- (UIButton*)changeBtn {
    
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn setImage:imageName(@"change_orange") forState:UIControlStateSelected];
        [_changeBtn setImage:imageName(@"change_orange") forState:UIControlStateNormal];
        [_changeBtn setImage:imageName(@"change_orange") forState:UIControlStateHighlighted];
        [_changeBtn setTitle:@"换一批" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:HKColorFromHex(0xA8ABBE, 1.0) forState:UIControlStateNormal];
        [_changeBtn.titleLabel setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13]];
        [_changeBtn addTarget:self action:@selector(changeVideoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBtn;
}



- (void)changeVideoAction:(id)sender {
    
    if (self.changeVideoBlock) {
        self.changeVideoBlock();
        CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//绕着z轴为矢量，进行旋转(@"transform.rotation.z"==@@"transform.rotation")
        anima.toValue = [NSNumber numberWithFloat:M_PI * 4];
        anima.duration = 2.0f;
        [_changeBtn.imageView.layer addAnimation:anima forKey:@"rotateAnimation"];
        [MobClick event:UM_RECORD_HOME_BATCH];
    }
}


@end
