
//
//  UserIconTableViewCell.h
//  Code
//
//  Created by pg on 2017/2/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKUserModel;

@protocol UserIconCellDelegate <NSObject>

- (void)userIconCellAction:(id)sender image:(UIImage*)image model:(HKUserModel*)model;

- (void)nameLabelAction:(id)sender;

- (void)openVipAction:(id)sender;

@end

@interface UserIconCell : UITableViewCell


@property(nonatomic,strong)UIButton     *iconBtn;
@property(nonatomic,strong)UIButton     *setUpBtn;

@property(nonatomic,strong)UIButton     *presentBtn;// 签到有奖
@property(nonatomic,strong)UILabel      *nickNameLabel;
@property(nonatomic,strong)UILabel      *carIdLabel;

@property(nonatomic,copy)NSString     *sign_type;// 当前签到
@property(nonatomic,copy)NSString     *sign_continue_num;// 连续签到天数

@property(nonatomic,strong)UIButton     *nickNameBtn;
@property(nonatomic,strong)UIImageView   *allVipImageView;

@property(nonatomic,copy)void(^presentEntranceBlock)();// 签到有奖点击事件block

@property(nonatomic,weak)id<UserIconCellDelegate> delegate;
@property(nonatomic,strong)HKUserModel *userInfoModel;
/** 头像 */
@property(nonatomic,strong)UIImage *iconImage;

@end






