//
//  HKCommentListCell.h
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKCommentModel;

@protocol HKCommentListCellDelegate <NSObject>

- (void)commentListCellDidMoreBtn:(HKCommentModel *)commentModel;
- (void)commentListCellDidLikeBtn:(HKCommentModel *)commentModel;
- (void)commentListCellDidLabel:(HKCommentModel *)commentModel subReplyModel:(HKCommentModel *)replyModel;
- (void)commentListCellDidHeaderBtn:(HKCommentModel *)commentModel;

@end

@interface HKCommentListCell : UITableViewCell
@property (nonatomic , strong) HKCommentModel * commentModel;
@property (nonatomic , strong) void(^didLookMoreBlock)(HKCommentModel * commentModel);
@property (nonatomic , weak) id<HKCommentListCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
