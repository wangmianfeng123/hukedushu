//
//  HKCommentEmptyView.m
//  Code
//
//  Created by Ivan li on 2018/5/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCommentEmptyView.h"
#import "UIView+HKLayer.h"

@interface HKCommentEmptyView()

@property (nonatomic,strong) UIImageView *empetyImageView;
/** 分数 */
//@property (nonatomic,strong) UILabel *scoreLabel;

//@property (nonatomic,strong) UILabel *commentLabel;
//@property (nonatomic, strong) UIButton * commentTopRightBtn;


/** 评价按钮 */
//@property (nonatomic,strong) UIButton *commentBtn;

@end

@implementation HKCommentEmptyView


- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    [_commentLabel addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#ff8c00"].CGColor,(id)[UIColor colorWithHexString:@"#ffa000"].CGColor,(id)[UIColor colorWithHexString:@"#ffb200"].CGColor]];
//    _commentLabel.text = @"得虎课币";
//    _commentLabel.textColor = [UIColor blackColor];
}

- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.empetyImageView];
//    [self addSubview:self.scoreLabel];
//    [self addSubview:self.commentBtn];
//    [self addSubview:self.commentTopRightBtn];
    
//    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(PADDING_25);
//        make.top.equalTo(self).offset(PADDING_20);
//    }];
    
//    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-PADDING_15);
//        make.centerY.equalTo(self.scoreLabel);
//        make.size.mas_equalTo(CGSizeMake(160 * 0.5, 54 * 0.5));
//    }];
//
//    [_commentTopRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_commentBtn.mas_right);
//        make.bottom.equalTo(_commentBtn.mas_top).offset(5);
//        make.width.equalTo(@(45));
//        make.height.equalTo(@(15));
//    }];
    
    [_empetyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(100);
        make.centerX.equalTo(self);
    }];
}

- (UIImageView*)empetyImageView {
    if (!_empetyImageView) {
        _empetyImageView = [UIImageView new];
        _empetyImageView.image = imageName(@"pic_sofa");
    }
    return _empetyImageView;
}


//- (UILabel*)scoreLabel {
//    
//    if (!_scoreLabel) {
//        _scoreLabel  = [UILabel labelWithTitle:CGRectZero title:@"暂无评分"
//                                    titleColor:COLOR_A8ABBE
//                                     titleFont:nil
//                                 titleAligment:NSTextAlignmentLeft];
//        _scoreLabel.font = HK_FONT_SYSTEM(14);
//    }
//    return _scoreLabel;
//}
//
//- (UIButton*)commentBtn {
//    
//    if (!_commentBtn) {
//        
//        _commentBtn = [UIButton buttonWithTitle:@"我要评价" titleColor:COLOR_ffffff
//                                      titleFont:@"13" imageName:nil];
//        [_commentBtn.titleLabel setFont:HK_FONT_SYSTEM_WEIGHT(13, UIFontWeightMedium)];
//        [_commentBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.7] forState:UIControlStateSelected];
//        
//        UIColor *color = [UIColor colorWithHexString:@"#ff8c00"];
//        UIColor *color1 = [UIColor colorWithHexString:@"#ffa000"];
//        UIColor *color2 = [UIColor colorWithHexString:@"#ffb200"];
//        UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(430 * 0.5, 75 * 0.5) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
//        [_commentBtn setBackgroundImage:imageTemp forState:UIControlStateNormal];
//        [_commentBtn setBackgroundImage:imageTemp forState:UIControlStateHighlighted];
//        [_commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _commentBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 25/2, 0, 25/2);
//        _commentBtn.clipsToBounds = YES;
//        _commentBtn.layer.cornerRadius = 54 * 0.5 * 0.5;
//    }
//    return _commentBtn;
//}
//
//- (UIButton*)commentTopRightBtn {
//    
//    if (!_commentTopRightBtn) {
//        _commentTopRightBtn = [UIButton buttonWithTitle:@"得虎课币" titleColor:COLOR_ffffff
//                                      titleFont:@"8" imageName:nil];
//        [_commentTopRightBtn.titleLabel setFont:HK_FONT_SYSTEM(8)];
//        [_commentTopRightBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.7] forState:UIControlStateSelected];
//        
//        UIColor *color = [UIColor colorWithHexString:@"#FF755A"];
//        UIColor *color1 = [UIColor colorWithHexString:@"#FF4265"];
//        //UIColor *color2 = [UIColor colorWithHexString:@"#ffb200"];
//        UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(45, 15) gradientColors:@[(id)color,(id)color1] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
//        [_commentTopRightBtn setBackgroundImage:imageTemp forState:UIControlStateNormal];
//        [_commentTopRightBtn setBackgroundImage:imageTemp forState:UIControlStateHighlighted];
//        [_commentTopRightBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _commentTopRightBtn.clipsToBounds = YES;
//        _commentTopRightBtn.layer.cornerRadius = 7.5;
//        _commentTopRightBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//        _commentTopRightBtn.layer.borderWidth = 1.0;
//    }
//    return _commentTopRightBtn;
//}

- (void)commentBtnClick:(id)sender {
    self.commentEmptyViewBlock ?self.commentEmptyViewBlock(sender) : nil;
}

@end
