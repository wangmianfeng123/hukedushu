//
//  HKSearchBookCell.h
//  Code
//
//  Created by Ivan li on 2021/5/20.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKBookCoverImageView ,HKBookModel;

@interface HKSearchBookCell : UICollectionViewCell
@property (nonatomic,strong) HKBookCoverImageView *coverIV;

@property (nonatomic,strong) HKBookModel *model;

@end

NS_ASSUME_NONNULL_END
