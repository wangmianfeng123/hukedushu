//
//  HKUserDetailHeaderView.h
//  Code
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKUserModel.h"
#import "DetailModel.h"
#import "HKUserModel.h"

@protocol HKUserDetailHeaderViewDelegate <NSObject>

@optional

- (void)headImageClick:(id)sender;

@end

@interface HKUserDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headerIV;// 头像

@property (nonatomic, strong)HKUserModel *user;

@property (nonatomic, copy)void(^backClickBlock)();

@property (nonatomic, copy)void(^editInfoClickBlock)(HKUserModel *model);

@property(nonatomic,weak)id<HKUserDetailHeaderViewDelegate> delegate;



@end



