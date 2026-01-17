//
//  HKVipHeaderView.h
//  Code
//
//  Created by eon Z on 2021/11/8.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HKVipHeaderViewDelegate <NSObject>

- (void)vipHeaderViewDidScrollToPage:(NSInteger)pageNumber;

@end

@interface HKVipHeaderView : UIView

@property (nonatomic , weak) id<HKVipHeaderViewDelegate>delegate;

@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,strong) void(^didHeaderBlock)(void);

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
