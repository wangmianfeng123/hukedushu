

//
//  HKTextImageView.m
//  Code
//
//  Created by Ivan li on 2018/12/9.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTextImageView.h"

@implementation HKTextImageView

- (instancetype)init {
    if (self =[super init]) {
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
    
    [self addSubview:self.textLB];
    [self addSubview:self.iconIV];
    [self addSubview:self.desLB];
    
    [self.textLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
    }];
    
    [self.desLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textLB.mas_bottom).mas_offset(3.0);
        make.centerX.mas_equalTo(self.textLB);
    }];
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLB.mas_right).offset(PADDING_5);
        make.centerY.right.equalTo(self);
        make.size.mas_lessThanOrEqualTo(CGSizeMake(40, 20));
    }];
    
    [_textLB setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
}



- (UILabel*) textLB {
    if (!_textLB) {
        _textLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"17" titleAligment:NSTextAlignmentRight];
        _textLB.font = HK_FONT_SYSTEM_BOLD(17);
    }
    return _textLB;
}

- (UILabel *)desLB {
    if (!_desLB) {
        _desLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"17" titleAligment:NSTextAlignmentRight];
    }
    return _desLB;
}




- (UIImageView*)iconIV {
    if (!_iconIV) {
        _iconIV = [UIImageView new];
        _iconIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconIV;
}


- (void)setText:(NSString *)text {
    _text = text;
    _textLB.text = text;
}

- (void)setDes:(NSString *)des {
    _des = des;
    _desLB.text = des;
}


- (void)setUrl:(NSString *)url {
    _url = url;
    if (!isEmpty(url)) {
        [_iconIV sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:url])];
    }
}


- (void)setText:(NSString *)text url:(NSString*)url {
    self.text = text;
    self.url = url;
}

- (void)setText:(NSString *)text url:(NSString*)url des:(NSString *)des {
    self.text = text;
    self.url = url;
    self.des = des;
}


@end






