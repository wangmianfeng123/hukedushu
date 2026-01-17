//
//  MyInfoHeadCell.h
//  Code
//
//  Created by Ivan li on 2018/9/23.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HKUserModel ,HKMyInfoVipView,HKMyInfoVipModel;

@protocol MyInfoHeadCellDelegate <NSObject>

- (void)userIconCellAction:(id)sender image:(UIImage*)image model:(HKUserModel*)model;

- (void)nameLabelAction:(id)sender;
/** vip 跳转 */
- (void)vipPushAction:(id)sender;

- (void)openVipAction:(id)sender;

@end




@interface MyInfoHeadCell : UICollectionViewCell

/** 背景图 */
@property(nonatomic,strong)UIImageView  *bgIV;
/** 头像 */
@property(nonatomic,strong)UIImageView  *iconIV;
/**签到有奖 */
@property(nonatomic,strong)UIButton     *presentBtn;
/** 昵称 */
@property(nonatomic,strong)UILabel      *nickNameLabel;
/** ID 编号 */
@property(nonatomic,strong)UILabel      *carIdLabel;
// 当前签到
@property(nonatomic,copy)NSString     *sign_type;
// 连续签到天数
@property(nonatomic,copy)NSString     *sign_continue_num;
/** vip 图标 */
//@property(nonatomic,strong)UIImageView  *allVipImageView;
/** 头像 */
@property(nonatomic,strong)UIImage *iconImage;

@property(nonatomic,strong)HKMyInfoVipView  *vipView;

// 签到有奖点击事件block
@property(nonatomic,copy)void(^presentEntranceBlock)();

@property(nonatomic,weak)id<MyInfoHeadCellDelegate> delegate;

@property(nonatomic,strong)HKUserModel *userInfoModel;

@property(nonatomic,strong)HKMyInfoVipModel *vipModel;

@end






