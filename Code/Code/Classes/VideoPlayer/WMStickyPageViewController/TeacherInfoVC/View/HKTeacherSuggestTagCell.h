//
//  HKTeacherSuggestTagCell.h
//  Code
//
//  Created by Ivan li on 2021/5/20.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKcategoryChilderenModel;

@interface HKTeacherSuggestTagCell : UICollectionViewCell
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , strong) void(^callBackData)(CGFloat h , BOOL isUnfolded);
@property (nonatomic , assign) BOOL open ;
@property (nonatomic , strong) void(^didTagBlock)(HKcategoryChilderenModel * model);

@end

NS_ASSUME_NONNULL_END
