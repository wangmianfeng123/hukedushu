//
//  HKCategorySoftwareCell.h
//  Code
//
//  Created by Ivan li on 2018/4/16.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKcategoryChilderenModel;

@interface HKCategorySoftwareCell : UICollectionViewCell

@property(nonatomic,strong)HKcategoryChilderenModel *childerenModel;

/** 分割线显示 */
- (void)showBottomLine:(NSInteger)row;

@end
