//
//  HKBaseSearchTeacCell.h
//  Code
//
//  Created by Ivan li on 2017/11/29.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "TBCollectionHighLightedCell.h"


@class HKUserModel;
@protocol HKBaseSearchTeacCellDelegate <NSObject>
@optional
- (void)focusTeacher:(id)sender;
@end


@interface HKBaseSearchTeacCell : TBCollectionHighLightedCell

- (void)createUI;

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *fanCountLabel;

@property(nonatomic,strong)UILabel *videoCountLabel;


@property(nonatomic,strong)HKUserModel *userInfo;

@property(nonatomic,readwrite,strong)UILabel *lineLabel;

@property(nonatomic,strong)UIButton *focusBtn;

@property (nonatomic, copy)void(^avatorClickBlock)();// 头像点击的block

@property(nonatomic,weak)id <HKBaseSearchTeacCellDelegate> delegate;

#pragma mark - 关注／取消关注  老师
- (void)followTeacherToServer:(UIButton*)btn;

- (void)makeConstraints;

- (void)setUserInfo:(HKUserModel *)userInfo;

- (void)setFocusBtnStyle:(UIButton *)btn isFollow:(BOOL)isFollow;

@end
