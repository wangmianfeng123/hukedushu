//
//  HKArticleDetailCommentCell.h
//  Code
//
//  Created by hanchuangkeji on 2018/8/7.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKArticleCommentModel.h"

@protocol HKArticleCommentCellDelegate <NSObject>

@optional

//举报
- (void)complainAction:(NSInteger)section model:(HKArticleCommentModel *)model sender:(id)sender;
//删除评论
- (void)deleteCommentAction:(NSInteger)section model:(HKArticleCommentModel *)model;

@end

@interface HKArticleDetailCommentCell : UITableViewCell

@property (nonatomic, strong)HKArticleCommentModel *model;

@property(weak,nonatomic)id<HKArticleCommentCellDelegate> delegate;

@end
