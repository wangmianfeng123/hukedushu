//
//  CommentFootView.h
//  Code
//
//  Created by Ivan li on 2017/10/30.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewCommentModel,mainCommentModel,HKCommentModel;

@protocol CommentFootViewDelegate <NSObject>

@optional
//点赞
- (void)praiseAction:(NSInteger)section model:(NewCommentModel*)model;
//评论
- (void)commentAction:(NSInteger)section model:(NewCommentModel*)model;
//举报
- (void)complainAction:(NSInteger)section model:(NewCommentModel*)model sender:(id)sender;
//删除评论
- (void)deleteCommentAction:(NSInteger)section model:(NewCommentModel*)model;
@end


@interface CommentFootView : UITableViewHeaderFooterView

@property(weak,nonatomic)id<CommentFootViewDelegate> delegate;

@property(strong,nonatomic)NewCommentModel *model;
@property (nonatomic , strong) HKCommentModel * mainCommentModel; //动态的评论


@property(assign,nonatomic)NSInteger section;
//隐藏底部横线
@property(assign,nonatomic)BOOL  isHiddenLine;

@property (nonatomic , assign) BOOL isHiddenMore ;

@end
