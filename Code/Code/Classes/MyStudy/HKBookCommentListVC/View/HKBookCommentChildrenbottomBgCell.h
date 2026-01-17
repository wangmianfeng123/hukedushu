//
//  HKBookCommentChildrenbottomBgCell.h
//  Code
//
//  Created by Ivan li on 2019/8/31.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IGListKit/IGListKit.h>
#import <IGListKit/IGListDiffable.h>
NS_ASSUME_NONNULL_BEGIN

@class HKBookMidCommentBottomModel,HKBookCommentModel;

@interface HKBookCommentChildrenbottomBgCell : UICollectionViewCell<IGListBindable>

@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong)HKBookCommentModel *model;

- (void)bindViewModel:(HKBookMidCommentBottomModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
