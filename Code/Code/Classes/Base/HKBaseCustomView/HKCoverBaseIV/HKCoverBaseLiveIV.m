//
//  HKCoverBaseIV.m
//  Code
//
//  Created by Ivan li on 2018/12/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCoverBaseLiveIV.h"
#import "HKCustomMarginLabel.h"
#import "UIButton+ImageTitleSpace.h"


@interface HKCoverBaseLiveIV ()


@end


@implementation HKCoverBaseLiveIV

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
    [self addSubview:self.bottomBgView];
    [self addSubview:self.textLB];
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
    
    [self.imageTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self).mas_offset(-5);
    }];
    
    [self.serLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(35);
    }];
    
    [self.bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(35);
    }];
}


- (HKCustomMarginLabel*)textLB {
    if (!_textLB) {
        _textLB  = [[HKCustomMarginLabel alloc] init];
        _textLB.textInsets = UIEdgeInsetsMake(7, 10, 7, 15);
        [_textLB setTextColor:[UIColor whiteColor]];
        _textLB.font = HK_FONT_SYSTEM(14);
        _textLB.textAlignment = NSTextAlignmentLeft;
        //_textLB.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
        _textLB.hidden = YES;
        [_textLB setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
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
        _imageTextBtn.titleLabel.font = HK_FONT_SYSTEM_BOLD(15);
        [_imageTextBtn setBackgroundImage:imageName(@"image_text_bg") forState:UIControlStateNormal];
        [_imageTextBtn setBackgroundImage:imageName(@"image_text_bg") forState:UIControlStateHighlighted];
        [_imageTextBtn setTitle:@"有图文" forState:UIControlStateNormal];
        _imageTextBtn.hidden = YES;
    }
    return _imageTextBtn;
}


- (UIView*)bottomBgView {
    if (!_bottomBgView) {
        _bottomBgView = [UIView new];
        _bottomBgView.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
    }
    return _bottomBgView;
}



- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
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




