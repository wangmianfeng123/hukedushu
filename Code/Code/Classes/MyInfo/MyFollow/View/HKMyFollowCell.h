//
//  HKMyFollowCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/10/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKUserModel.h"

@interface HKMyFollowCell : TBCollectionHighLightedCell

@property (nonatomic, strong)HKUserModel *userModel;

@property (nonatomic, strong)NSIndexPath *indexPath;

@property (nonatomic, copy) void(^followBtnClickBlock)(HKUserModel *user, NSIndexPath *indexPath);

@end
