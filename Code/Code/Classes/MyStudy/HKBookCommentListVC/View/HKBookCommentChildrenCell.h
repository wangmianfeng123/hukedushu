//
//  HKBookCommentChildrenCell.h
//  Code
//
//  Created by Ivan li on 2019/8/21.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IGListKit/IGListKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKBookCommentModel,HKBookCommentChildrenCell,HKBookMidCommentModel;


@protocol BookCommentChildrenCellDelegate <NSObject>

@optional
//评论
- (void)bookCommentChildrenCell:(HKBookCommentChildrenCell*)cell model:(HKBookCommentModel*)model;
@end


@interface HKBookCommentChildrenCell : UICollectionViewCell<IGListBindable>

@property (nonatomic, strong)HKBookCommentModel *model;

@property(nonatomic,weak)id <BookCommentChildrenCellDelegate> delegate;

-(void)bindViewModel:(HKBookMidCommentModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
