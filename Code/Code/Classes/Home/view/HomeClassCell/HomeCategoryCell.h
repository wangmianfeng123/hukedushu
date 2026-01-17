//
//  DCGoodsCountDownCell.h
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"
@class HomeCategoryModel;
@class HomeCategoryCell;

@class HomeClassCell;

@protocol HomeCategoryCellDelegate <NSObject>

@optional

- (void)HomeCategoryCell:(HomeCategoryModel *)model index:(NSInteger)index;

- (void)HomeCategoryCell:(HomeCategoryModel *)model x:(float)x y:(float)y rect:(CGRect)rect cell:(HomeClassCell*)cell;

@end

@interface HomeCategoryCell : TBCollectionHighLightedCell

@property (nonatomic,weak)id <HomeCategoryCellDelegate> delegate;

/* 推荐商品数据 */
@property (strong , nonatomic)NSMutableArray<PageCategoryModel *> *pageDataArray;

@end
