//
//  HKTeacherDetailHeaderView.h
//  Code
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKUserModel.h"
#import "DetailModel.h"
#import "HKUserModel.h"


@protocol HKTeacherDetailHeaderViewDelegate <NSObject>

@optional
- (void)teacherHeadImageClick:(id)sender;

@end



@interface HKTeacherDetailHeaderView : UIView

@property (nonatomic, strong)HKUserModel *user;

@property (weak, nonatomic) IBOutlet UIImageView *headerIV;// 头像

@property (nonatomic, copy)void(^heightBlock)(CGFloat height);
@property (nonatomic, copy)void(^backClickBlock)();
@property (nonatomic, copy)void(^followBtnClickBlock)();
@property (nonatomic, copy)void(^shareClickBlock)(HKUserModel *model);

@property (nonatomic, copy)void(^headerHeightBlock)(CGFloat headerHeight);

@property (nonatomic, copy)void(^moreClickBlock)(HKUserModel *model);

@property(nonatomic,weak)id<HKTeacherDetailHeaderViewDelegate> delegate;


@end
