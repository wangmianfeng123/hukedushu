//
//  HKBookCommentSectionController.h
//  Code
//
//  Created by Ivan li on 2019/8/27.
//  Copyright © 2019 pg. All rights reserved.
//

//#import "IGListSectionController.h"
#import <IGListKit/IGListKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKBookCommentModel,HKBookCommentTopCell,HKBookCommentActionCell,HKBookCommentChildrenCell,HKBookCommentSectionController;

@protocol HKBookCommentSectionControllerDelegate <NSObject>
@optional

//评论
- (void)bookCommentSectionController:(HKBookCommentSectionController*)sectionController bookCommentTopCell:(HKBookCommentTopCell*)cell headViewCommentAction:(NSInteger)section model:(HKBookCommentModel*)model;

//头像
- (void)bookCommentSectionController:(HKBookCommentSectionController*)sectionController bookCommentTopCell:(HKBookCommentTopCell*)cell headViewuserImageViewClick:(NSInteger)section model:(HKBookCommentModel*)model;

//评论图片
- (void)bookCommentSectionController:(HKBookCommentSectionController*)sectionController bookCommentTopCell:(HKBookCommentTopCell*)cell headViewCommentImageViewClick:(NSInteger)section model:(HKBookCommentModel*)model;

#pragma mark - HKBookCommentActionCell
///  评价
- (void)bookCommentSectionController:(HKBookCommentSectionController*)sectionController hkBookCommentActionCell:(HKBookCommentActionCell*)cell  commentBtn:(UIButton*)btn;

///  举报
- (void)bookCommentSectionController:(HKBookCommentSectionController*)sectionController hkBookCommentActionCell:(HKBookCommentActionCell*)cell  complainAction:(UIButton*)btn;

///  删除
- (void)bookCommentSectionController:(HKBookCommentSectionController*)sectionController hkBookCommentActionCell:(HKBookCommentActionCell*)cell  deleteAction:(UIButton*)btn;

#pragma mark --- HKBookCommentChildrenCell
///  mainCommentModel 父评论
- (void)bookCommentSectionController:(HKBookCommentSectionController*)sectionController bookCommentChildrenCell:(HKBookCommentChildrenCell*)cell model:(HKBookCommentModel*)model mainCommentModel:(HKBookCommentModel*)mainCommentModel;

/// 更新
- (void)bookCommentSectionController:(HKBookCommentSectionController*)sectionController updateCell:(HKBookCommentModel*)model;

@end

@interface HKBookCommentSectionController <HKBookCommentModel> : IGListBindingSectionController //IGListSectionController

@property(nonatomic,weak)id <HKBookCommentSectionControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
