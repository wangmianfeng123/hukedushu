//
//  HKTabBookCell.h
//  Code
//
//  Created by Ivan li on 2019/10/31.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKBookCoverImageView ,HKBookModel;

@interface HKTabBookCell : UITableViewCell

@property (nonatomic,strong) HKBookCoverImageView *coverIV;

@property (nonatomic,strong) HKBookModel *model;

@end


NS_ASSUME_NONNULL_END
