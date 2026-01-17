//
//  HKJobPathLearnedCell.h
//  Code
//
//  Created by Ivan li on 2019/6/4.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class HKJobPathModel;

@interface HKJobPathLearnedCell : UICollectionViewCell

@property(nonatomic,strong)NSMutableArray<HKJobPathModel *> *seriesArr;

@property(nonatomic, copy)void(^videoSelectedBlock)(NSIndexPath *indexPath, HKJobPathModel *jobPathModel);
@property(nonatomic, copy)void(^vipClickBlock)(void);

@property (nonatomic , assign) BOOL showAllVip;

@end

NS_ASSUME_NONNULL_END
