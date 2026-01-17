//
//  HKBookCoverImageView.h
//  Code
//
//  Created by Ivan li on 2019/10/31.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKBookModel;

@interface HKBookCoverImageView : UIImageView

@property (nonatomic,strong) HKBookModel *model;
@property (strong, nonatomic)  UIImageView *shadowIV;

@end

NS_ASSUME_NONNULL_END
