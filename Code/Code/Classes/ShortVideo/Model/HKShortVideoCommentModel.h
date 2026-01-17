//
//  HKShortVideoCommentModel.h
//  Code
//
//  Created by hanchuangkeji on 2019/5/13.
//  Copyright © 2019 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKShortVideoCommentModel : NSObject

@property (nonatomic, copy)NSString *ID;

@property (nonatomic, copy)NSString *root_id;

@property (nonatomic, copy)NSString *parent_id;

@property (nonatomic, copy)NSString *video_id;

@property (nonatomic, copy)NSString *parent_uid;

@property (nonatomic, copy)NSString *uid;

@property (nonatomic, copy)NSString *tid;

@property (nonatomic, copy)NSString *content;

@property (nonatomic, copy)NSString *created_at;

@property (nonatomic, copy)NSString *updated_at;

@property (nonatomic, copy)NSString *thumbs;

@property (nonatomic, assign)BOOL is_teacher;

@property (nonatomic, copy)NSString *reply_tid;

@property (nonatomic, copy)NSString *time_desc;

@property (nonatomic, copy)NSString *sub_count; // 自评论数量

@property (nonatomic, strong)HKUserModel *commentUser; // 本人

@property (nonatomic, assign)BOOL isNewComment; // 自己的子评论

@property (nonatomic, strong)HKUserModel *parentCommentUser; // 他人，可能为空

@property (nonatomic, strong)NSMutableArray<HKShortVideoCommentModel *> *comment;

@property (nonatomic, strong)NSMutableArray<HKShortVideoCommentModel *> *newComment; // 自己评论的最新子评论

@property (nonatomic, assign)int subPage; // 子评论刷新到第几页

@property (nonatomic, assign)int pageCount; // 子评论一共多少页

@property (nonatomic, assign)BOOL is_read;

@property (nonatomic, assign)BOOL is_reply;

@property (nonatomic, copy)NSString *created_at_string;

@property (nonatomic, copy)NSString *cover_url;

@property (nonatomic, assign)CGFloat cellHeight;

@property (nonatomic, assign)CGFloat contentLBHeigth;

@end

NS_ASSUME_NONNULL_END
