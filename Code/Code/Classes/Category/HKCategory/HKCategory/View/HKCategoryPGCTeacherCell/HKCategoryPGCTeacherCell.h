//
//  HKPGCTeacherCell.h
//  Code
//
//  Created by Ivan li on 2018/4/16.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKcategoryChilderenModel;

@interface HKCategoryPGCTeacherCell : UICollectionViewCell

@property(nonatomic,strong)NSMutableArray<HKcategoryChilderenModel *> *seriesArr;

@property(nonatomic, copy)void(^CategoryPGCTeacherSelectBlock)(NSIndexPath *indexPath, HKcategoryChilderenModel *model);

@end
