//
//  HKCategoryDesignCell.h
//  Code
//
//  Created by Ivan li on 2018/12/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKcategoryChilderenModel;

@interface HKCategoryDesignCell : UICollectionViewCell

@property(nonatomic,strong)HKcategoryChilderenModel *childerenModel;

- (void)showBottomLine:(NSInteger)row;

@end
