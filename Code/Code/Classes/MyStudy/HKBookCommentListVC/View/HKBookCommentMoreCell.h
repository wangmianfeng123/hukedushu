//
//  HKBookCommentMoreCell.h
//  Code
//
//  Created by Ivan li on 2019/8/21.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IGListKit/IGListKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKBookCommentModel,HKBookBottomModel;

@interface HKBookCommentMoreCell : UICollectionViewCell<IGListBindable>

@property (nonatomic, strong)HKBookCommentModel *model;

- (void)bindViewModel:(HKBookBottomModel *)viewModel;

@end

NS_ASSUME_NONNULL_END

