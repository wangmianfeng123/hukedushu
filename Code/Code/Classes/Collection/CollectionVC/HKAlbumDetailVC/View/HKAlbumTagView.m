//
//  HKAlbumTagView.m
//  Code
//
//  Created by Ivan li on 2017/12/4.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKAlbumTagView.h"

@interface HKAlbumTagView()

@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *tagLabel;
@end



@implementation HKAlbumTagView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.iconImageView];
    [self addSubview:self.tagLabel];
    [self makeConstraints];
}

- (void)makeConstraints {
    WeakSelf;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(weakSelf);
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(6);
        make.top.height.equalTo(weakSelf.iconImageView);
        make.right.lessThanOrEqualTo(weakSelf.mas_right).offset(-7);
    }];
}


- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        //_iconImageView.clipsToBounds = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}


- (UILabel*)tagLabel {
    if (!_tagLabel) {
        _tagLabel  = [UILabel new];
        [_tagLabel setTextColor:COLOR_ffffff];
        _tagLabel.textAlignment = NSTextAlignmentLeft;
        _tagLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13];
    }
    return _tagLabel;
}



- (void)setImageWithName:(NSString*)imageName  text:(NSString*)text  type:(NSString*)type {
    _iconImageView.image = imageName(imageName);
    _tagLabel.text = [NSString stringWithFormat:@"%@",text];
}


- (void)setImageWithName:(NSString*)imageName  text:(NSString*)text  type:(NSString*)type textColor:(UIColor*)textColor {
    _iconImageView.image = imageName(imageName);
    _tagLabel.textColor = textColor;
    _tagLabel.text = [NSString stringWithFormat:@"%@%@",text,type];
}


@end
