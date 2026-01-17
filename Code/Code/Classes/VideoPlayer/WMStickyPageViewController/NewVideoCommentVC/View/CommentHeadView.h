//
//  CommentHeadView.h
//  Code
//
//  Created by Ivan li on 2017/10/30.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewCommentModel,HKCommentModel;

@protocol CommentHeadViewDelegate <NSObject>
@optional
//评论
- (void)headViewCommentAction:(NSInteger)section model:(NewCommentModel*)model;
//头像
- (void)headViewuserImageViewClick:(NSInteger)section model:(NewCommentModel*)model;
- (void)headViewuserImageViewCommentModel:(HKCommentModel*)model;

//评论图片
- (void)headViewCommentImageViewClick:(NSInteger)section model:(NewCommentModel*)model index:(NSInteger)index;

@end


@interface CommentHeadView : UITableViewHeaderFooterView

- (void)setVideoCommentModel:(NewCommentModel *)videoCommentModel hidden:(BOOL)hidden;

@property(nonatomic,strong)NewCommentModel *videoCommentModel;

@property(weak,nonatomic)id<CommentHeadViewDelegate> delegate;

@property(assign,nonatomic)NSInteger section;

@property (nonatomic , strong) HKCommentModel * mainCommentModel; //动态的评论


@end
