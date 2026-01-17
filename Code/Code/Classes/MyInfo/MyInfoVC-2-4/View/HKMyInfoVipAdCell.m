//
//  HKMyInfoVipAdCell.m
//  Code
//
//  Created by Ivan li on 2019/4/12.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKMyInfoVipAdCell.h"

@implementation HKMyInfoVipAdCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.adIV];
        [self.adIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}


- (UIImageView*)adIV {
    if (!_adIV) {
        _adIV = [UIImageView new];
        _adIV.contentMode = UIViewContentModeScaleAspectFit;
        _adIV.backgroundColor = [UIColor clearColor];
        
        //_adIV.image = imageName(@"ic_friend_share_v2_9");
    }
    return _adIV;
}


@end
