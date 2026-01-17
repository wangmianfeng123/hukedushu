//
//  HKEditAblumTitleVC.h
//  Code
//
//  Created by Ivan li on 2017/12/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"

typedef void(^EditAblumTitleBlock)(NSString *title,NSIndexPath *indexPath);

@interface HKEditAblumTitleVC : HKBaseVC

@property(nonatomic,copy)EditAblumTitleBlock editAblumTitleBlock;

@property(nonatomic,strong)NSIndexPath *indexPath;

@end
