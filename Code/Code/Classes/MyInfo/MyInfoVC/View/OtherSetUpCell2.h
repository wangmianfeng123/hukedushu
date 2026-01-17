//
//  OtherSetUpCell2.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/8.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HKUserModel;

@interface OtherSetUpCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rightIV;
@property (weak, nonatomic) IBOutlet UILabel *rightLB;
@property (weak, nonatomic) IBOutlet UILabel *leftLB;
@property (weak, nonatomic) IBOutlet UIImageView *leftIV;

@property (nonatomic,strong) HKUserModel *userModel;

@property (weak, nonatomic) IBOutlet UIButton *unreadMessage;


@end
