//
//  HKTItleBadegeButton.m
//  Code
//
//  Created by hanchuangkeji on 2018/7/23.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTitleBadegeButton.h"

#define FONT10 10.0
#define FONT9 9.0

@interface HKTitleBadegeButton()

@property (nonatomic, weak)UIButton *badege;

@end

@implementation HKTitleBadegeButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    // 设置角标数量
    UIButton *badege = [UIButton buttonWithType:UIButtonTypeCustom];
    self.badege = badege;
    badege.backgroundColor = HKColorFromHex(0xFF3221, 1.0);
    badege.titleLabel.font = [UIFont systemFontOfSize:FONT10 weight:UIFontWeightBold];
    badege.userInteractionEnabled =  NO;
    [badege setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:badege];
    badege.clipsToBounds = YES;
    badege.hidden = YES;
    badege.layer.cornerRadius = 8.0;
    [badege mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16.0, 16.0));
        make.top.mas_equalTo(self.titleLabel).mas_offset(-4);
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(1);
    }];
}


- (void)setBadegeCount:(NSString *)count {
    self.badege.hidden = NO;
    [self.badege mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16.0, 16.0));
    }];
    
    if (!count || count.intValue <= 0) {
        self.badege.hidden = YES;
    } else if (count.intValue > 99) {
        [self.badege mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25.0, 16.0));
        }];
        [self.badege setTitle:@"99+" forState:UIControlStateNormal];
    } else {
        [self.badege setTitle:count forState:UIControlStateNormal];
    }
}



@end
