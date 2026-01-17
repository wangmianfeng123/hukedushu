//
//  ReplyCommentVC.h
//  Code
//
//  Created by Ivan li on 2017/10/31.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@class NewCommentModel,HKCommentModel,CommentChildModel,HKMomentDetailModel;

@interface ReplyCommentVC : HKBaseVC

//- (instancetype)initWithModel:(NewCommentModel *)commentModel;
- (instancetype)initWithModel:(id)commentModel;

@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,assign)NSInteger section;

@property(nonatomic,copy)void(^commentBlock)(NSString *comment,NSInteger section,NSMutableArray <CommentChildModel*> *modelArr);


@property (nonatomic , strong) HKCommentModel * mainComment;//主评论
@property (nonatomic , strong) HKCommentModel * replyModel; //次级评论
//@property (nonatomic , strong) HKMomentDetailModel * detailM;//动态Model

//@property (nonatomic , strong) NSString * comment_id;
@property (nonatomic , strong) NSString * connect_type;
@property (nonatomic , strong) NSString * topic_id;


@end
