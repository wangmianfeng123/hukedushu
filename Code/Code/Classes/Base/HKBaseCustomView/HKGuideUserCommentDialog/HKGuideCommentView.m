//
//  HKGuideCommentVC.m
//  Code
//
//  Created by Ivan li on 2018/1/24.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKGuideCommentView.h"
#import "UIImage+Helper.h"
#import "UIButton+Style.h"
#import "UIView+SNFoundation.h"


@interface HKGuideCommentView (){
    
}
/** 背景 */
@property(nonatomic,strong)UIView *bgView;
/** 标题 */
@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIButton *leftBtn;

@property(nonatomic,strong)UIButton *rightBtn;
/** 中间分隔线 */
@property(nonatomic,strong)UILabel *lineLabel;
/** 关闭按钮 */
@property(nonatomic,strong)UIButton *closeBtn;

@property(nonatomic,strong)UIImageView *topIV;
/// 拼接 图片  下面的图片
@property(nonatomic,strong)UIImageView *downIV;

@end

@implementation HKGuideCommentView


- (instancetype)init {
    if (self = [super init]) {
        
        [self createUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.6];
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.lineLabel];
    [self.bgView addSubview:self.leftBtn];
    [self.bgView addSubview:self.rightBtn];
    
    [self.bgView addSubview:self.closeBtn];
    [self.bgView addSubview:self.topIV];
    [self.bgView addSubview:self.downIV];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.topIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_top);
        make.centerX.equalTo(self.bgView);
    }];
    
    [self.downIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.centerX.equalTo(self.bgView);
    }];
    
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(290, 190));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(36);
        make.centerX.width.equalTo(self.bgView);
    }];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLabel);
        make.width.mas_equalTo(1);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(self.leftBtn.imageView.image.size.height);
    }];
        
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(12);
        make.right.equalTo(self.bgView).offset(-12);
    }];
    
    self.leftBtn.y = 75;
    self.leftBtn.x = 20;
    
    self.rightBtn.centerY = self.leftBtn.centerY;
    self.rightBtn.right = 290 - 20;
}



- (UIImageView*)topIV {
    if (!_topIV) {
        _topIV = [[UIImageView alloc]init];
        _topIV.image = imageName(@"pic_doyoulike_top_v2_15");
    }
    return _topIV;
}


- (UIImageView*)downIV {
    if (!_downIV) {
        _downIV = [[UIImageView alloc]init];
        _downIV.image = imageName(@"pic_doyoulike_down_v2_15");
    }
    return _downIV;
}

- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5;
    }
    return _bgView;
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTitle:CGRectZero title:@"你喜欢虎课吗？" titleColor:COLOR_27323F
                                    titleFont:nil titleAligment:NSTextAlignmentCenter];
        _titleLabel.font = HK_FONT_SYSTEM_BOLD(18);
    }
    return _titleLabel;
}


- (UILabel*)lineLabel {
    if (!_lineLabel) {
        _lineLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_333333 titleFont:nil titleAligment:NSTextAlignmentCenter];
        _lineLabel.backgroundColor = [UIColor clearColor];
    }
    return _lineLabel;
}

- (UIButton*)leftBtn {
    if (!_leftBtn) {
        _leftBtn =[UIButton buttonWithTitle:@"我喜欢!" titleColor:COLOR_27323F titleFont:@"14" imageName:nil];
        [_leftBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_leftBtn setImage:imageName(@"ic_like_v2_15")forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        
        [_leftBtn hkLayoutButtonWithEdgeInsetsStyle:ICButtonEdgeInsetsStyleTop imageTitleSpace:0];
        _leftBtn.tag = 10;
        [_leftBtn sizeToFit];
        
    }
    return _leftBtn;
}


- (UIButton*)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithTitle:@"想吐槽~" titleColor:COLOR_27323F titleFont:@"14" imageName:nil];
        [_rightBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setImage:imageName(@"ic_shit_v2_15") forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        
        [_rightBtn hkLayoutButtonWithEdgeInsetsStyle:ICButtonEdgeInsetsStyleTop imageTitleSpace:0];
        _rightBtn.tag = 11;
        [_rightBtn sizeToFit];
    }
    return _rightBtn;
}


- (UIButton*)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithTitle:nil titleColor:COLOR_333333 titleFont:@"15" imageName:@"ic_close_v2_15"];
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.tag = 12;
        [_closeBtn setHKEnlargeEdge:20];
    }
    return _closeBtn;
}



- (void)closeBtnClick:(UIButton*)sender {
    
    [UIView animateWithDuration:1 animations:^{
        self.alpha = 0;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSInteger tag = [sender tag];
            if (10 == tag) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_URL]];
                //self.pariseBlock ? self.pariseBlock(nil) :nil;
                [MobClick event:um_pop_comment_like];
            }else if (11 == tag){
                [MobClick event:um_pop_comment_dislike];
                self.commentBlock ? self.commentBlock(nil) :nil;
            }else if (12 == tag){
                [MobClick event:um_pop_comment_close];
            }
            [self performSelector:@selector(removeGuidePage) withObject:nil afterDelay:0];
        });
    }];
}

- (void)removeGuidePage {
    [self removeFromSuperview];
}






@end







