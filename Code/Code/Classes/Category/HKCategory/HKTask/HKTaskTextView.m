

//
//  HKTaskTextView.m
//  Code
//
//  Created by Ivan li on 2018/7/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTaskTextView.h"
#import "UIView+SNFoundation.h"


@implementation HKTaskTextView


- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.countBtn];
        [self addSubview:self.tipBtn];
        [self addShadowWithColor:[COLOR_E1E7EB colorWithAlphaComponent:0.5] alpha:1 radius:1 offset:CGSizeMake(0, -2)];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self.countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(PADDING_15);
        make.centerY.equalTo(self.tipBtn);
//        make.size.mas_equalTo(CGSizeMake(35, 25));
    }];
    
    [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(50);
        make.right.equalTo(self).offset(-15);
        //make.top.equalTo(self).offset(18);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(self).offset(-9);
    }];
}



- (UIButton*)countBtn {
    if (!_countBtn) {
        _countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_countBtn setImage:imageName(@"comment_bubble_gray") forState:UIControlStateNormal];
        [_countBtn setTitleColor:COLOR_7B8196 forState:UIControlStateNormal];
        [_countBtn addTarget:self action:@selector(publishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_countBtn setEnlargeEdgeWithTop:PADDING_15 right:PADDING_25 bottom:PADDING_25 left:PADDING_25];
    }
    return _countBtn;
}



- (void)publishBtnClick:(UIButton*)btn {
    
    if ([self.delegate respondsToSelector:@selector(didClick:)]) {
        [self.delegate didClick:btn];
    }
}


- (UIButton*)tipBtn {
    if (!_tipBtn) {
        _tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tipBtn.backgroundColor = COLOR_F8F9FA;
        _tipBtn.layer.cornerRadius = 15;
        _tipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //[_tipBtn setTitle:nil forState:UIControlStateNormal];
        _tipBtn.titleLabel.font = HK_FONT_SYSTEM(14);
        _tipBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [_tipBtn setTitleColor:COLOR_A8ABBE forState:UIControlStateNormal];
        [_tipBtn addTarget:self action:@selector(publishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipBtn;
}




- (void)setTitle:(NSString *)title {
    [_tipBtn setTitle:title forState:UIControlStateNormal];
    //self.tipLabel.attributedText = [self attributedString:title];
}


//- (NSAttributedString*)attributedString:(NSString*)title {
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.alignment = NSTextAlignmentLeft;  //对齐
//    paraStyle.firstLineHeadIndent = 15;//首行缩进
//    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:title attributes:@{NSParagraphStyleAttributeName:paraStyle}];
//    return attrText;
//}


@end



