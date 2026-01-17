//
//  HomeRecomdCell.m
//  Code
//
//  Created by Ivan li on 2017/10/12.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKHotProductHeaderCell.h"

@implementation HKHotProductHeaderCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    if (self) {
        [self createUI];
    }
    return self;
}





- (void)createUI {
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.grayLabel];
    [self addSubview:self.tagLabel];
    [self addSubview:self.changeBtn];
    
    [_grayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(8);
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.grayLabel.mas_bottom).offset(18);
        make.left.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-18);
        make.width.mas_equalTo(2);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).mas_offset(10);
        make.left.equalTo(self).offset(PADDING_15);
    }];
    
    [_changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.titleLabel);
        make.right.equalTo(self.mas_right).offset(-11);
    }];
}


- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        [_titleLabel setTextColor:HKColorFromHex(0x27323F, 1.0)];
        
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 19: 18 weight:UIFontWeightBold];
        _titleLabel.text = @"推荐文章";
    }
    return _titleLabel;
}

- (void)setChangeBtnText:(NSString *)count {
    
    NSString *completeStr = [NSString stringWithFormat:@"今日已更新%@篇", count];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:completeStr];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, completeStr.length)];
    [str addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0xA8ABBE, 1.0) range:NSMakeRange(0, completeStr.length)];
    [str addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0xFF7820, 1.0) range:NSMakeRange(5, count.length)];
    
    [self.changeBtn setAttributedTitle:str forState:UIControlStateNormal];
}

- (UILabel*)grayLabel {
    if (!_grayLabel) {
        _grayLabel  = [UILabel new];
        _grayLabel.backgroundColor = HKColorFromHex(0xF8F9FA, 1.0);
    }
    return _grayLabel;
}


- (UILabel*)tagLabel {
    if (!_tagLabel) {
        _tagLabel  = [UILabel new];
        _tagLabel.hidden = YES;
        _tagLabel.backgroundColor = COLOR_333333;
    }
    return _tagLabel;
}



- (UIButton*)changeBtn {
    
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateNormal];
        [_changeBtn setTitle:@"1900位用户在围观" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:HKColorFromHex(0xA8ABBE, 1.0) forState:UIControlStateNormal];
        [_changeBtn.titleLabel setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13]];
        _changeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_changeBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_changeBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        
//        [_changeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_changeBtn.imageView.image.size.width, 0, _changeBtn.imageView.image.size.width)];
//
//        CGFloat imageOffset = IS_IPHONE6PLUS? 63 : 58;
//        [_changeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, imageOffset, 0, -imageOffset)];
    }
    return _changeBtn;
}



- (void)rightBtnClick:(id)sender {
    [MobClick event:UM_RECORD_HOME_BEGINNER_MORE];
    !self.self.moreSolfwareBlock? : self.moreSolfwareBlock();
}










@end
