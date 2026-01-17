//
//  HKAutoRenewalCell.h
//  Code
//
//  Created by yxma on 2020/10/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKAutoRenewalCell : UITableViewCell
//@property (nonatomic, assign) BOOL isChoose;
@property (nonatomic, copy) void(^selectBtnBlock)(BOOL selected);
@property (nonatomic, strong)HKBuyVipModel *autoBuyModel; // 自动续费model

@end

NS_ASSUME_NONNULL_END
