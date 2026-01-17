//
//  HKInternetRcommandCell.h
//  Code
//
//  Created by Ivan li on 2021/7/12.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKcategoryOnlineSchoolListModel,HKLiveListModel;

@interface HKInternetRcommandCell : UICollectionViewCell
//@property(nonatomic,copy)NSArray<HKLiveListModel*> *list;
@property (nonatomic , strong) HKcategoryOnlineSchoolListModel *model;
@property (nonatomic , strong) void(^didCellBlock)(HKLiveListModel * model , BOOL isTrain);

@end

NS_ASSUME_NONNULL_END
