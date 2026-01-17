//
//  HKVIPCategoryVC.h
//  Code
//
//  Created by eon Z on 2021/11/8.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKVIPCategoryVC : HKBaseVC

@property (nonatomic, copy)NSString *class_type; // 当前选中的model vip_type
@property (nonatomic, copy)NSString *button_type; // 用于统计活动按钮的点击的type

@property (nonatomic, assign)BOOL isShowDialg; // 显示弹框下载受限说明

//@property (nonatomic , assign) int vipType; //分类，年会员 终生会员

@end

NS_ASSUME_NONNULL_END
