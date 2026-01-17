//
//  HkCategoryStudentCell.h
//  Code
//
//  Created by Ivan li on 2019/11/14.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKcategoryChilderenModel;

@interface HkCategoryStudentCell : UICollectionViewCell

@property(nonatomic,strong)HKcategoryChilderenModel *childerenModel;

/** 分割线显示 */
- (void)showBottomLine:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END


