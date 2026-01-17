


//
//  HKShareSucessView.m
//  Code
//
//  Created by Ivan li on 2018/8/6.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKShareSucessView.h"


@interface HKShareSucessView()

@property (nonatomic,strong) UIImageView *sucessIV;

@property (nonatomic,strong) UILabel *sucessLB;

@end




@implementation HKShareSucessView


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
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.sucessIV];
    [self addSubview:self.sucessLB];
    [self makeConstraints];
}



- (void)makeConstraints {
    
    [self.sucessIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(22);
    }];
    
    [self.sucessLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.sucessIV);
        make.top.equalTo(self.sucessIV.mas_bottom).offset(6);
        make.right.left.equalTo(self);
    }];
}



- (UIImageView*)sucessIV {
    if(!_sucessIV){
        _sucessIV = [UIImageView new];
        _sucessIV.image = imageName(@"share_finish");
    }
    return _sucessIV;
}


- (UILabel*)sucessLB {
    if (!_sucessLB) {
        _sucessLB =  [UILabel labelWithTitle:CGRectZero title:@"领取成功" titleColor:COLOR_27323F titleFont:@"15" titleAligment:NSTextAlignmentCenter];
    }
    return _sucessLB;
}



@end






