//
//  HKBookCommentThemeCell.h
//  Code
//
//  Created by Ivan li on 2019/8/21.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IGListKit/IGListKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKBookCommentModel,HKBookCommentTopCell,NewCommentModel,HKBookTopModel;

@protocol HKBookCommentTopCellDelegate <NSObject>
@optional
//评论
- (void)bookCommentTopCell:(HKBookCommentTopCell*)cell headViewCommentAction:(NSInteger)section model:(HKBookCommentModel*)model;
//头像
- (void)bookCommentTopCell:(HKBookCommentTopCell*)cell headViewuserImageViewClick:(NSInteger)section model:(HKBookCommentModel*)model;
//评论图片
- (void)bookCommentTopCell:(HKBookCommentTopCell*)cell headViewCommentImageViewClick:(NSInteger)section model:(HKBookCommentModel*)model;

@end

@interface HKBookCommentTopCell : UICollectionViewCell <IGListBindable>

@property (nonatomic, strong)HKBookCommentModel *model;

@property (nonatomic, copy)void(^userTapActionBlock)(HKBookCommentModel *model);

@property(nonatomic,weak)id <HKBookCommentTopCellDelegate> delegate;

@property (nonatomic, strong)NewCommentModel *videoCommentModel;


-(void)bindViewModel:(HKBookTopModel*)viewModel;

@end

NS_ASSUME_NONNULL_END
