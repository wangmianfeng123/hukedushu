//
//  HKEditUserTitleVC.h
//  Code
//
//  Created by Ivan li on 2018/3/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"


typedef void(^EditAblumTitleBlock)(NSString *title,NSIndexPath *indexPath);

@interface HKEditUserTitleVC : HKBaseVC

@property(nonatomic,copy)EditAblumTitleBlock editAblumTitleBlock;

@property(nonatomic,strong)NSIndexPath *indexPath;

@end
