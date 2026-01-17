



//
//  HKTagBtn.m
//  Code
//
//  Created by Ivan li on 2018/8/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTagBtnTool.h"
#import "HKCustomMarginLabel.h"

@implementation HKTagBtnTool

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }return self;
}


- (instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }return self;
}



- (void)createUI {
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tagBtn];
    [self addSubview:self.tagLB];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(PADDING_15);
        make.centerX.equalTo(self);
    }];
    
    [self.tagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagBtn.mas_centerX);
        make.centerY.equalTo(self.tagBtn.mas_top);
        make.right.lessThanOrEqualTo(self.mas_right).offset(-PADDING_5);
        //make.height.mas_equalTo(20);
    }];
}



- (UIButton*)tagBtn {
    if (!_tagBtn) {
        _tagBtn = [[UIButton alloc] init];
        [_tagBtn setImage:imageName(@"ic_signclose_v2_1") forState:UIControlStateNormal];
        [_tagBtn setImage:imageName(@"ic_signclose_v2_1") forState:UIControlStateHighlighted];
        [_tagBtn addTarget:self action:@selector(tagBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tagBtn;
}


- (void)tagBtnClick {
    self.tabBtnBlock ?self.tabBtnBlock(nil) :nil;
}


- (HKCustomMarginLabel*)tagLB {
    if (!_tagLB) {
        _tagLB  = [[HKCustomMarginLabel alloc]init];
        _tagLB.textInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        _tagLB.backgroundColor = [UIColor colorWithHexString:@"#FF6B54"];
        [_tagLB setTextColor:[UIColor whiteColor]];
        _tagLB.clipsToBounds = YES;
        _tagLB.font = HK_FONT_SYSTEM(14);
        _tagLB.layer.cornerRadius = (_tagLB.font.pointSize +10)/2;
        _tagLB.textAlignment = NSTextAlignmentLeft;
        _tagLB.text = @"明日再来更惊喜哦~";
        _tagLB.numberOfLines = 0;
    }
    return _tagLB;
}



- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    [_tagBtn setImage:imageName(imageName) forState:UIControlStateNormal];
    [_tagBtn setImage:imageName(imageName) forState:UIControlStateHighlighted];
}


- (void)setTagTitle:(NSString *)tagTitle  fontSize:(CGFloat)fontSize {
    //_tagTitle = tagTitle;
    if (fontSize) {
        _tagLB.font = HK_FONT_SYSTEM(fontSize);
        _tagLB.layer.cornerRadius = (_tagLB.font.pointSize +10)/2;
    }
    _tagLB.text = tagTitle;
}



@end








