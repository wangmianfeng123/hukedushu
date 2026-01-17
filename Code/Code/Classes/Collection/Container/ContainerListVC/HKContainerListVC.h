//
//  HKContainerListVC.h
//  Code
//
//  Created by Ivan li on 2017/11/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"


@interface HKContainerListVC : HKBaseVC

@property (nonatomic,strong)DetailModel *detailModel;

@property (nonatomic,copy) void(^containerCloseBlock)(id sender);


@end
