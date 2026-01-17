//
//  HKSetUserIconCell.m
//  Code
//
//  Created by Ivan li on 2018/5/14.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKSetUserIconCell.h"

@implementation HKSetUserIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.textColor = COLOR_27323F_EFEFF6;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}



- (void)setUserModel:(HKUserModel *)userModel {
    
    _nameLabel.text = (nil == userModel)? @"点击登录":@"账号资料";
    
    _userIconIV.layer.masksToBounds = YES;
    _userIconIV.layer.cornerRadius = _userIconIV.height/2;
    [_userIconIV sd_setImageWithURL:[NSURL URLWithString:userModel.avator] placeholderImage:imageName(@"huke_login_bg") options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.iconImage = image;
    }];
}

@end
