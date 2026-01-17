//
//  HKUserLearnedVC.h
//  Code
//
//  Created by Ivan li on 2018/5/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@interface HKUserLearnedVC : HKBaseVC

@property (nonatomic, strong)HKUserModel *userModel;

/** type *1-已学课程 2-收藏课程 */
@property (nonatomic, copy)NSString *type;

@end
