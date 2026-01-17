//
//  HKTeacherNavBarView.h
//  Code
//
//  Created by hanchuangkeji on 2018/3/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKTeacherNavBarView : UIView

@property (nonatomic, copy)void(^backClickBlock)();

@property (nonatomic, copy)void(^shareClickBlock)(HKUserModel *model);


@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (nonatomic, strong)HKUserModel *user;



@end
