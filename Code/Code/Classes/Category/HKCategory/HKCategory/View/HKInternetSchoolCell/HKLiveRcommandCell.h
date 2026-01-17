//
//  HKLiveRcommandCell.h
//  Code
//
//  Created by eon Z on 2021/12/15.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKcategoryOnlineSchoolListModel,HKLiveListModel;

@interface HKLiveRcommandCell : UICollectionViewCell
@property (nonatomic , strong) HKcategoryOnlineSchoolListModel *model;
//@property (nonatomic , strong) void(^didCellBlock)(HKLiveListModel * model , BOOL isTrain);
@property (nonatomic , strong) void(^moreBtnBlock)(void);
@property (nonatomic , strong) void(^tapClickBlock)(HKLiveListModel * model);

@end

NS_ASSUME_NONNULL_END
