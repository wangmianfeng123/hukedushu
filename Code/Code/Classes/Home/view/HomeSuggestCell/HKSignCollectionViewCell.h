//
//  HKSignCollectionViewCell.h
//  Code
//
//  Created by eon Z on 2021/8/31.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKHomeSignModel;

@protocol HKSignCollectionViewCellDelegate <NSObject>

- (void)signCollectionViewCellDidSgin:(HKHomeSignModel *)signModel;

@end

@interface HKSignCollectionViewCell : UICollectionViewCell
@property (nonatomic , strong) NSMutableArray * signArray;
@property(nonatomic,strong)void(^didCloseBlock)(void);
@property (nonatomic , weak) id <HKSignCollectionViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
