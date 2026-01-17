//
//  HKPlayerSimilarVideoCell.m
//  Code
//
//  Created by Ivan li on 2018/4/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKPlayerSimilarVideoCell.h"


@interface HKPlayerSimilarVideoCell()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *iconImageView;
/** 立即观看 */
@property (nonatomic,strong) UIButton *lookBtn;
/** 重播 */
@property (nonatomic,strong) UIButton *resetBtn;
/** 相似推荐 */
@property (nonatomic,strong) UILabel *similarLabel;

@end


@implementation HKPlayerSimilarVideoCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.lookBtn];
        [self.contentView addSubview:self.resetBtn];
        [self.contentView addSubview:self.similarLabel];
        [self singleGesture];
    }
    return self;
}



- (void)singleGesture {
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick:)];
    //gest.delegate             = self;
    gest.numberOfTouchesRequired = 1; //手指数
    gest.numberOfTapsRequired   = 1;
    [self.contentView  addGestureRecognizer:gest];
}





- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.similarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(128/2*Ratio);;
        make.left.equalTo(self.contentView).offset(PADDING_30);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.similarLabel);
        make.top.equalTo(self.similarLabel.mas_bottom).offset(PADDING_10);
        make.size.mas_equalTo(CGSizeMake(260/2, 160/2));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(25/2);
        make.top.equalTo(self.iconImageView).offset(10);
        make.right.equalTo(self.contentView).offset(-1);
    }];
    
    [self.lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(47/2);
        make.size.mas_equalTo(CGSizeMake(170/2, 44/2));
    }];
    
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lookBtn.mas_right).offset(PADDING_15);
        make.centerY.equalTo(self.lookBtn);
        make.size.mas_equalTo(CGSizeMake(110/2, 60/2));
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.lookBtn.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(self.lookBtn.height/2, 0)];
        
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.frame       = self.lookBtn.bounds;
        borderLayer.path        = maskPath.CGPath;
        borderLayer.strokeColor = [COLOR_ffffff colorWithAlphaComponent:0.8].CGColor;
        borderLayer.fillColor   = [UIColor clearColor].CGColor;
        borderLayer.lineWidth   = 1;
        
        [self.lookBtn.layer addSublayer:borderLayer];
    });
}



- (UIImageView*)iconImageView {
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        //_iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = PADDING_5;
        _iconImageView.userInteractionEnabled = YES;
    }
    return _iconImageView;
    
}

- (UILabel*)similarLabel {
    
    if (!_similarLabel) {
        _similarLabel = [UILabel labelWithTitle:CGRectZero title:@"相似推荐" titleColor:[COLOR_ffffff colorWithAlphaComponent:0.8] titleFont:@"15" titleAligment:NSTextAlignmentLeft];
        _similarLabel.userInteractionEnabled = YES;
    }
    return _similarLabel;
}



- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:[COLOR_ffffff colorWithAlphaComponent:0.8]
                                     titleFont:@"14" titleAligment:NSTextAlignmentLeft];
        _titleLabel.userInteractionEnabled = YES;
    }
    return _titleLabel;
}



- (UIButton*)lookBtn {
    if(!_lookBtn){
        _lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookBtn.titleLabel.font = HK_FONT_SYSTEM(14);
        [_lookBtn setBackgroundColor:[UIColor clearColor]];
        [_lookBtn setTitle:@"立即观看" forState:UIControlStateNormal];
        [_lookBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        [_lookBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.7] forState:UIControlStateSelected];
        [_lookBtn addTarget:self action:@selector(viewClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookBtn;
}


- (UIButton*)resetBtn {
    if(!_resetBtn){
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetBtn.titleLabel.font = HK_FONT_SYSTEM(14);
        [_resetBtn setBackgroundColor:[UIColor clearColor]];
        [_resetBtn setTitle:@"重播" forState:UIControlStateNormal];
        [_resetBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        [_resetBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.7] forState:UIControlStateSelected];
        [_resetBtn setImage:imageName(@"hkplayer_reset") forState:UIControlStateNormal];
        [_resetBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_resetBtn addTarget:self action:@selector(resetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}


- (void)resetBtnClick {
    
    if ([self.playerSimilarVideoDelagate respondsToSelector:@selector(hkplayerRepeatVideoClick:)]) {
        [self.playerSimilarVideoDelagate hkplayerRepeatVideoClick:self.model];
        [self removeView];
    }
}


- (void)viewClick:(id)sender {
    
    if ([self.playerSimilarVideoDelagate respondsToSelector:@selector(hkplayerSimilarVideoCellClick:)]) {
        [self.playerSimilarVideoDelagate hkplayerSimilarVideoCellClick:self.model];
        [self removeView];
    }
    NSLog(@"layoutSubviews");
}



- (void)removeView {
    //移除手势
    for (UIGestureRecognizer *ges in self.contentView.gestureRecognizers) {
        [self removeGestureRecognizer:ges];
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}



- (void)setModel:(VideoModel *)model {
    _model = model;
    
    self.titleLabel.text = model.video_title;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.img_cover_url]] placeholderImage:imageName(HK_Placeholder)];
}

@end
