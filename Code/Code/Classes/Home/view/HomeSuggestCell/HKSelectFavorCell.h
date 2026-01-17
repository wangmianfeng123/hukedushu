//
//  HKSelectFavorCell.h
//  Code
//
//  Created by hanchuangkeji on 2018/5/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKSelectFavorCell : UICollectionReusableView

@property (nonatomic, copy)void(^clickIVClickBlock)();


- (void)setHiddenClick:(BOOL)hidden;

@end
