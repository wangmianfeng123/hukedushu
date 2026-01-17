//
//  HKMyFollowCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/10/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKMyFollowCell.h"

@interface HKMyFollowCell()

@property (weak, nonatomic) IBOutlet UIImageView *headerIV;// 头像
@property (weak, nonatomic) IBOutlet UILabel *nameLB;// 名字
@property (weak, nonatomic) IBOutlet UILabel *fansCountLB;// 粉丝数量
@property (weak, nonatomic) IBOutlet UIButton *followBtn;// 关注按钮

@end



@implementation HKMyFollowCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // 按钮边距
    self.followBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    
    // 圆形头像
    self.headerIV.clipsToBounds = YES;
    self.headerIV.layer.cornerRadius = self.headerIV.height * 0.5;
    
    // 关注按钮
    [self.followBtn setImage:imageName(@"my_add_follow_black") forState:UIControlStateNormal];
    [self.followBtn setImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
}

- (void)setUserModel:(HKUserModel *)userModel {
    _userModel = userModel;
    
    // 头像等信息设置
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:userModel.avator] placeholderImage:imageName(HK_Placeholder)];
    self.nameLB.text = userModel.name.length? userModel.name : userModel.username;
    self.fansCountLB.text = [NSString stringWithFormat:@"%@粉丝", userModel.follow_count.length? userModel.follow_count : @"0"];
    self.followBtn.selected = userModel.is_follow;
}


/**
 关注按钮事件

 @param sender sender
 */
- (IBAction)followBtnClick:(id)sender {
    !self.followBtnClickBlock?  : self.followBtnClickBlock(self.userModel, self.indexPath);
    
}

@end
