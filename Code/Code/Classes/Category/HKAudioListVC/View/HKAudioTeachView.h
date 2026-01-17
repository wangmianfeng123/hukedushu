//
//  HKAudioTeachView.h
//  Code
//
//  Created by Ivan li on 2018/3/27.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKUserModel;

@protocol HKAudioTeachViewDelegate <NSObject>

@optional
- (void)focusTeacher:(id)sender;

@end




@interface HKAudioTeachView : UIView

- (void)createUI;

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)HKUserModel *userInfo;

@property(nonatomic,strong)UIButton *focusBtn;

@property (nonatomic, copy)void(^avatorClickBlock)();// 头像点击的block

@property(nonatomic,weak)id <HKAudioTeachViewDelegate> delegate;

#pragma mark - 关注／取消关注  老师
- (void)followTeacherToServer:(UIButton*)btn;

- (void)makeConstraints;

@end
