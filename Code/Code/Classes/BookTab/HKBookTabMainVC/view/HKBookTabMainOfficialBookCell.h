//
//  HKBookTabMainOfficialBookCell.h
//  Code
//
//  Created by Ivan li on 2019/10/31.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKBookCoverImageView ,HKBookModel;

@interface HKBookTabMainOfficialBookCell : UICollectionViewCell

@property (nonatomic,strong) HKBookCoverImageView *coverIV;

@property (nonatomic,strong) HKBookModel *model;
/// 我要听 按钮 回调
@property(nonatomic,copy)void (^playBtnClickBlock)(HKBookModel *model);

@end

NS_ASSUME_NONNULL_END
