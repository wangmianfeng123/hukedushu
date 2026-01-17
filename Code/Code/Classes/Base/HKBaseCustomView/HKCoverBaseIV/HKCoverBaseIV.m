//
//  HKCoverBaseIV.m
//  Code
//
//  Created by Ivan li on 2018/12/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCoverBaseIV.h"
#import "HKCustomMarginLabel.h"
#import "UIButton+ImageTitleSpace.h"
#import "HKCoureFinishView.h"

@interface HKCoverBaseIV ()


@end


@implementation HKCoverBaseIV

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


- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super initWithImage:image]) {
        [self createUI];
    }
    return self;
}



- (void)createUI {
    [self addSubview:self.textLB];
    [self addSubview:self.finishView];
    [self addSubview:self.imageTextBtn];
    [self addSubview:self.serLB];
    self.clipsToBounds = YES;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self.textLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo((self.textLBHeight >0)?self.textLBHeight :35);
    }];
    [self.finishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.textLB);
    }];
    [self.imageTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).mas_offset(-8.0);;
        make.right.equalTo(self).mas_offset(-3.0);
        make.size.mas_equalTo(CGSizeMake(IS_IPHONEMORE4_7INCH? 110 * 0.5 : 106 * 0.5, IS_IPHONEMORE4_7INCH? 55 * 0.5 : 52 * 0.5));
    }];
    
    [self.serLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(35);
    }];
}


- (HKCustomMarginLabel*)textLB {
    if (!_textLB) {
        _textLB  = [[HKCustomMarginLabel alloc] init];
        _textLB.textInsets = UIEdgeInsetsMake(7, 15, 7, 15);
        [_textLB setTextColor:[UIColor whiteColor]];
        _textLB.font = HK_FONT_SYSTEM(14);
        _textLB.textAlignment = NSTextAlignmentLeft;
        _textLB.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
        _textLB.hidden = YES;
    }
    return _textLB;
}

- (UILabel *)serLB {
    if (!_serLB) {
        _serLB  = [[UILabel alloc] init];
        _serLB.textColor = [UIColor whiteColor];
        _serLB.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightBold];
        _serLB.hidden = YES;
    }
    return _serLB;
}



- (UIButton *)imageTextBtn {
    if (!_imageTextBtn) {
        _imageTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageTextBtn.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONEMORE4_7INCH? 14.0 : 13.0];
        [_imageTextBtn setBackgroundImage:imageName(@"hk_video_string_black") forState:UIControlStateNormal];
        [_imageTextBtn setBackgroundImage:imageName(@"hk_video_string_black") forState:UIControlStateHighlighted];
        [_imageTextBtn setTitle:@"有图文" forState:UIControlStateNormal];
        _imageTextBtn.hidden = YES;
    }
    return _imageTextBtn;
}

- (HKCoureFinishView *)finishView{
    if (_finishView == nil) {
        _finishView = [[HKCoureFinishView alloc] init];
        _finishView.hidden = YES;
    }
    return _finishView;
}


- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

-(void)setIcon_show:(BOOL)icon_show{
    _icon_show = icon_show;
    _finishView.hidden = _icon_show ? NO : YES;
}


- (void)setHiddenText:(BOOL)hiddenText {
    _hiddenText = hiddenText;
    self.textLB.hidden = hiddenText;
}

- (void)setHasPictext:(BOOL)hasPictext {
    _hasPictext = hasPictext;
    _imageTextBtn.hidden = hasPictext;
}



- (void)setCourseCount:(NSInteger)courseCount {
    _courseCount = courseCount;
    if (courseCount > 0) {
        self.textLB.text = [NSString stringWithFormat:@"共%ld节",(long)courseCount];
        self.textLB.hidden = NO;
    }else{
        self.textLB.hidden = YES;
    }
}


- (void)setTextInsets:(UIEdgeInsets)textInsets {
    _textInsets = textInsets;
    self.textLB.textInsets = textInsets;
}


- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    self.textLB.font = textFont;
}


- (void)setTextLBHeight:(CGFloat)textLBHeight {
    _textLBHeight = textLBHeight;
}



@end





