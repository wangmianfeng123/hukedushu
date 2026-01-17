//
//  HkDesignJobPathCell.h
//  Code
//
//  Created by Ivan li on 2019/8/1.
//  Copyright © 2019 pg. All rights reserved.
//


#import <UIKit/UIKit.h>


@class HKJobPathModel;

@interface HkDesignJobPathCell : UICollectionViewCell

@property(nonatomic,strong)NSMutableArray<HKJobPathModel *> *seriesArr;

@property(nonatomic, copy)void(^videoSelectedBlock)(NSIndexPath *indexPath, HKJobPathModel *jobPathModel);

@property (nonatomic , strong) void(^didVipBlock)(void);

@end




@interface HkDesignJobPathChildrenCell : UICollectionViewCell

@property(nonatomic,strong)HKJobPathModel *model;

@end



