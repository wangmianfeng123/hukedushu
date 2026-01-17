//
//  OtherSetUpCell2.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/8.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "OtherSetUpCell2.h"
#import "HKUserModel.h"
#import "HKCouponModel.h"

@implementation OtherSetUpCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.unreadMessage.backgroundColor = [UIColor redColor];
    self.unreadMessage.clipsToBounds = YES;
    self.unreadMessage.layer.cornerRadius = 9.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserModel:(HKUserModel *)userModel {
    _userModel = userModel;
    /** 1-显示即将过期，要变颜色 2-多少张 */
    NSString *type = userModel.coupon_data.show_type;
    self.leftLB.textColor = [type isEqualToString:@"1"] ?COLOR_ff3b30 :COLOR_A8ABBE;
    self.leftLB.text = userModel.coupon_data.show_str;
}


@end
