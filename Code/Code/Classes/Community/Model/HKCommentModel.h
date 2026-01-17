//
//  HKCommentModel.h
//  Code
//
//  Created by Ivan li on 2021/1/26.
//  Copyright © 2021 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKCommentModel : NSObject


@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *commentId;
@property(nonatomic,copy)NSString *uid; //userId
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,strong)NSNumber *likes_count;
@property(nonatomic,copy)NSString *created_at;
@property(nonatomic,assign)BOOL isLiked;
@property(nonatomic,strong)NSNumber *reply_count;
@property(nonatomic,strong)NSMutableArray <HKCommentModel *> *subs;
@property(nonatomic,assign)BOOL canDelete;


@property(nonatomic,copy)NSString *topic_id;
@property(nonatomic,copy)NSString *reply_to_uid;
@property(nonatomic,copy)NSString *reply_to_username;
@property(nonatomic,copy)NSString *reply_to_avatar;
@property(nonatomic,copy)NSString *reply_to_main_id;

@property (nonatomic , assign) CGFloat headViewHeight ;
@property(nonatomic,assign)CGFloat contentLBHeigth;
@property (nonatomic , assign) BOOL is_top ;
@property (nonatomic , assign) BOOL isTeacher ;
//@property (nonatomic , assign) int replayLevel ; //回复级别  2回复次级评论
@end

NS_ASSUME_NONNULL_END
