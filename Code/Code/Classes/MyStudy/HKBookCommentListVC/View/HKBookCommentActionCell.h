//
//  HKBookCommentActionCell.h
//  Code
//
//  Created by Ivan li on 2019/8/28.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IGListKit/IGListKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKBookCommentModel,HKBookCommentActionCell,HKBookActionModel;

@protocol BookCommentActionCellDelegate <NSObject>
///  评价
- (void)hkBookCommentActionCell:(HKBookCommentActionCell*)cell  commentBtn:(UIButton*)btn;
///  举报
- (void)hkBookCommentActionCell:(HKBookCommentActionCell*)cell  complainAction:(UIButton*)btn;
///  删除
- (void)hkBookCommentActionCell:(HKBookCommentActionCell*)cell  deleteAction:(UIButton*)btn;

@end

@interface HKBookCommentActionCell : UICollectionViewCell<IGListBindable>

@property (nonatomic, strong)HKBookCommentModel *model;

@property(nonatomic,weak)id <BookCommentActionCellDelegate> delegate;

- (void)bindViewModel:(HKBookActionModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
