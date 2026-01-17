//
//  HKSoftwareRecommenHeadView.m
//  Code
//
//  Created by Ivan li on 2018/4/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKSoftwareRecommenHeadView.h"


@interface HKSoftwareRecommenHeadView()

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,strong) UILabel *tipLabel;

@end

@implementation HKSoftwareRecommenHeadView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}



- (void)createUI {
    
    self.backgroundColor = [UIColor clearColor];//[COLOR_000000 colorWithAlphaComponent:0.8];
    [self addSubview:self.titleLabel];
    [self addSubview:self.tipLabel];
    [self addSubview:self.imageView];
    [self addSubview:self.closeBtn];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(IS_IPHONE_X ?80/2 :55/2);
        make.right.equalTo(self).offset(-PADDING_15);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(Ratio*224/2);
        make.centerX.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(PADDING_5);
        make.left.right.equalTo(self.imageView);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(77/2);
        make.left.equalTo(self).offset(PADDING_15);
        make.right.equalTo(self);
    }];
}


- (UIImageView*)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = imageName(@"software_letter");
    }
    return _imageView;
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:@"毕业证书可在\n【学习-学习成就】中查看"
                                    titleColor:[COLOR_ffffff colorWithAlphaComponent:0.8]
                                     titleFont:@"14" titleAligment:NSTextAlignmentCenter];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}


- (UILabel*)tipLabel {
    if (!_tipLabel) {
        
        _tipLabel  = [UILabel labelWithTitle:CGRectZero title:nil //@"听说学会photoshop的同学去学了这些教程！"
                                  titleColor:COLOR_ffffff
                                     titleFont:nil titleAligment:NSTextAlignmentLeft];
        _tipLabel.font = HK_FONT_SYSTEM_BOLD(16);
        _tipLabel.numberOfLines = 2;
    }
    return _tipLabel;
}


- (UIButton*)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:imageName(@"software_close_white") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (void)removeView {
    
    if ([self.delegate respondsToSelector:@selector(hkSoftwareHeadViewCloseBtnClick:)]) {
        [self.delegate hkSoftwareHeadViewCloseBtnClick:nil];
    }
}


- (void)setSoftwareName:(NSString *)softwareName {
    _softwareName = softwareName;
    _tipLabel.text = [NSString stringWithFormat:@"听说学会%@的同学去学了这些教程！", softwareName];
}




@end
