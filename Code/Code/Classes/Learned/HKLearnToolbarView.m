//
//  HKLearnToolbarView.m
//  Code
//
//  Created by Ivan li on 2018/9/4.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLearnToolbarView.h"
#import "UIButton+ImageTitleSpace.h"


@implementation HKLearnToolbarView

- (instancetype)init {
    if (self = [super init]) {
        [self createUI ];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    [self addSubview:self.toolView];
    [self.toolView addSubview:self.imageView];
    [self.toolView addSubview:self.textLB];
    [self.toolView addSubview:self.vipBtn];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(12);
        make.left.equalTo(self).offset(PADDING_15);
        make.right.equalTo(self).offset(-PADDING_15);
        make.height.mas_equalTo(40);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toolView);
        make.left.equalTo(self.toolView).offset(PADDING_15);
    }];
    
    [self.textLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(7.5);
        make.centerY.equalTo(self.imageView);
    }];
    
    [self.vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.toolView).offset(-PADDING_15);
        make.centerY.equalTo(self.imageView);
    }];
}



- (UIImageView*)toolView {
    if (!_toolView) {
        _toolView = [UIImageView new];
        _toolView.contentMode = UIViewContentModeScaleAspectFit;
        _toolView.clipsToBounds = YES;
        _toolView.layer.cornerRadius = PADDING_5;
        _toolView.userInteractionEnabled = YES;
        
        UIColor *color2 = [UIColor colorWithHexString:@"#FFEDA2"];
        UIColor *color1 = [UIColor colorWithHexString:@"#FFC17B"];
        UIColor *color = [UIColor colorWithHexString:@"#FF894B"];
        
        UIImage *bgImage = [[UIImage alloc]createImageWithSize:CGSizeMake(SCREEN_WIDTH-30, 40) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        _toolView.image = bgImage;
    }
    return _toolView;
}



- (UIImageView*)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = imageName(@"my_vip_tag_type_2");
    }
    return _imageView;
}


- (UILabel*)textLB {
    if (!_textLB) {
        _textLB = [UILabel labelWithTitle:CGRectZero title:@"加入VIP，无限次学习" titleColor:[UIColor whiteColor] titleFont:nil titleAligment:NSTextAlignmentLeft];
        _textLB.font = HK_FONT_SYSTEM_WEIGHT(13, UIFontWeightSemibold);
    }
    return _textLB;
}


- (UIButton*)vipBtn {
    if (!_vipBtn) {
        _vipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vipBtn setImage:imageName(@"open_vip_bg") forState:UIControlStateNormal];
        [_vipBtn setImage:imageName(@"open_vip_bg") forState:UIControlStateHighlighted];
        [_vipBtn addTarget:self action:@selector(vipBtnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_vipBtn setEnlargeEdgeWithTop:PADDING_15 right:PADDING_25 bottom:PADDING_25 left:200];
    }
    return _vipBtn;
}



- (void)vipBtnBtnClick:(UIButton*)btn {
    self.hKLearnToolbarViewBlock ?self.hKLearnToolbarViewBlock(nil) :nil;
}







@end
