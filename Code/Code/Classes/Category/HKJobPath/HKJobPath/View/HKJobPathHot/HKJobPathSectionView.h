//
//  HKJobPathSectionView.h
//  Code
//
//  Created by Ivan li on 2021/5/17.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKJobPathSectionView : UICollectionReusableView
@property (nonatomic,strong) NSMutableArray <HKTagModel*>*titlesArr;
@property (nonatomic , assign) CGRect titleViewFrame ;
@property (nonatomic , strong) void(^didTagBlock)(HKTagModel *tagModel);

@end

NS_ASSUME_NONNULL_END
