//
//  HKVIPOtherVC.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/27.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"
#import "HKBuyVipModel.h"


@protocol HKVIPWholeLifeVCDelegate <NSObject>
- (void)moveToNextVC;

@end

@interface HKVIPWholeLifeVC : HKBaseVC

@property (nonatomic, copy)NSString *class_type; // 当前选中的model vip_type

@property (nonatomic, copy)NSString *button_type; // 当前选中的model vip_type

@property (nonatomic, assign)BOOL isShowDialg; // 显示弹框下载受限说明

@property (nonatomic, weak)id<HKVIPWholeLifeVCDelegate> delegate;

@end
