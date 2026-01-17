//
//  HKSearchSortView.h
//  Code
//
//  Created by eon Z on 2022/1/12.
//  Copyright © 2022 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKDropMenuModel;

@protocol HKSearchSortViewDelegate <NSObject>

- (void)searchSortViewDidfiltrateBtn:(HKDropMenuModel *)dropModel;
- (void)searchSortViewDidSortBtn:(HKDropMenuModel *)dropModel;

@end

@interface HKSearchSortView : UIView

@property (nonatomic , strong) NSMutableArray *titles;

@property (nonatomic , weak) id<HKSearchSortViewDelegate>delegate ;

@end

NS_ASSUME_NONNULL_END
