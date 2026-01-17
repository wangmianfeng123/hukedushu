//
//  HKLiveCommentCell.h
//  Code
//
//  Created by Ivan li on 2020/12/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKLiveCommentModel;

@protocol HKLiveCommentCellDelegate <NSObject>

- (void)liveCommentCellDidDeleteBtn:(HKLiveCommentModel *)commentModel;
- (void)liveCommentCellDidZanBtn:(HKLiveCommentModel *)commentModel;
- (void)liveCommentCellDidHeaderImg:(HKLiveCommentModel *)commentModel;
@end

@interface HKLiveCommentCell : UITableViewCell
@property (nonatomic , strong) HKLiveCommentModel * commentModel;
@property(nonatomic,weak)id<HKLiveCommentCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
