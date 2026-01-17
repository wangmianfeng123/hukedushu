//
//  HKTaskDetailUserCommentFootView.h
//  Code
//
//  Created by Ivan li on 2018/7/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HKTaskModel;

@protocol HKTaskDetailUserCommentFootViewDelegate <NSObject>

@optional
//点赞
- (void)praiseAction:(NSInteger)section model:(HKTaskModel*)model;
//评论
- (void)commentAction:(NSInteger)section model:(HKTaskModel*)model;
//举报
- (void)complainAction:(NSInteger)section model:(HKTaskModel*)model sender:(id)sender;
//删除评论
- (void)deleteCommentAction:(NSInteger)section model:(HKTaskModel*)model;
@end


@interface HKTaskDetailUserCommentFootView : UITableViewHeaderFooterView

@property(weak,nonatomic) id<HKTaskDetailUserCommentFootViewDelegate> delegate;

@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,assign)NSInteger section;

@property(nonatomic,strong) HKTaskModel *model;

@end





