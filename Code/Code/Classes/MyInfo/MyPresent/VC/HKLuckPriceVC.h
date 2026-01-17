//
//  HKLuckPriceVC.h
//  抽奖
//
//  Created by hanchuangkeji on 2017/11/9.
//  Copyright © 2017年 亿缘. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKLuckPriceModel;
@class HKPresentHeaderModel;
@interface HKLuckPriceVC : UIViewController

@property (nonatomic, strong)NSArray<HKLuckPriceModel *> *modelArray;

@property (nonatomic, copy)void(^luckCompleteBlock)(HKPresentHeaderModel *model);

@property (nonatomic, strong)HKPresentHeaderModel *model2;

@end


@interface HKLuckPriceModel : NSObject
@property (nonatomic, copy)NSString *gold;
@property (nonatomic, copy)NSString *name_str;
@property (nonatomic, assign)BOOL is_winning;

@end

