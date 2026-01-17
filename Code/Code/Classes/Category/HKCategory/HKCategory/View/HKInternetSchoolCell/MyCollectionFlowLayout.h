//
//  MyCollectionFlowLayout.h
//  PageCollectionViewDemo
//
//  Created by Caolu on 2019/3/13.
//  Copyright © 2019 RoadCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCollectionFlowLayout : UICollectionViewFlowLayout
@property (nonatomic , strong) void(^currentIndexBlock)(NSInteger _currentIndex);    // 当前页码（滑动前）
@end

NS_ASSUME_NONNULL_END
