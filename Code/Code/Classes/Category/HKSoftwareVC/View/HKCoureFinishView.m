//
//  HKCoureFinishView.m
//  Code
//
//  Created by yxma on 2020/9/2.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKCoureFinishView.h"
#import "HKCustomMarginLabel.h"

@interface HKCoureFinishView ()

@end

@implementation HKCoureFinishView

-(instancetype)init{
    if ([super init]) {
        self.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
        [self createUI];
    }
    return self;
}

- (void)createUI{
    [self addSubview:self.txtLabel];
    [self addSubview:self.imgV];
}

-(HKCustomMarginLabel *)txtLabel{
    if (_txtLabel == nil) {
        _txtLabel  = [[HKCustomMarginLabel alloc] init];
        _txtLabel.text = @"已获得课程证书";
        _txtLabel.textInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_txtLabel setTextColor:[UIColor whiteColor]];
        _txtLabel.font = HK_FONT_SYSTEM(9);
        _txtLabel.textAlignment = NSTextAlignmentLeft;
        _txtLabel.backgroundColor = [UIColor clearColor];
        _txtLabel.hidden = NO;
    }
    return _txtLabel;
}

-(UIImageView *)imgV{
    if (_imgV == nil) {
        _imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_softwarelist_complete"]];
    }
    return _imgV;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.txtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.txtLabel.mas_left);
        make.centerY.equalTo(self.txtLabel);
    }];
    
}

@end
