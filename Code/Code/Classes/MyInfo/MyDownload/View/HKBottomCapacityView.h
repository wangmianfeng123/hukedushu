//
//  HKBottomCapacityView.h
//  Code
//
//  Created by hanchuangkeji on 2018/3/6.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKBottomCapacityView : UIView

@property (weak, nonatomic) IBOutlet UILabel *capacityLB;

// 计算剩余空间
- (void)setSpace;
- (void)setCapacity:(CGFloat)capacity totalNeed:(CGFloat)total;
@end
