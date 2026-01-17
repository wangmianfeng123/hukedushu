//
//  HKPrecentImageShareVC.h
//  Code
//
//  Created by hanchuangkeji on 2018/6/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HKPresentHeaderModel;

@interface HKPrecentImageShareVC : UIViewController

@property (nonatomic, strong)HKPresentHeaderModel *model;

@property (nonatomic, copy)void(^recBlockClick)();

@end
