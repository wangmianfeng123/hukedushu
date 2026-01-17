//
//  HKTaskDetailVC.h
//  Code
//
//  Created by Ivan li on 2018/7/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@class HKTaskModel,HKTaskCommentModel;

@interface HKTaskDetailVC : HKBaseVC

@property(nonatomic,strong) HKTaskModel *model;

@property(nonatomic,strong) HKTaskCommentModel *commentModel;

@property(nonatomic,assign) NSInteger row;

@end
