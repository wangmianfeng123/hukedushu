//
//  HKTaskModel.h
//  Code
//
//  Created by Ivan li on 2018/7/12.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShareModel;


@interface HKTaskCommentModel : NSObject


@property(nonatomic,copy)NSString *username;

@property(nonatomic,copy)NSString *content;

@property(nonatomic,copy)NSString *task_id;

@property(nonatomic,copy)NSString *uid;

/********************* 作品详情 ***********************/
/** 头像*/
@property(nonatomic,copy)NSString *avator;

@property(nonatomic,copy)NSString *comment_id;

@property(nonatomic,copy)NSString *parent_id;

@property(nonatomic,assign)CGFloat headViewHeight;

@end




@interface HKTaskModel : NSObject

/** 头像*/
@property(nonatomic,copy)NSString *avator;
/** 评论数*/
@property(nonatomic,copy)NSString *comment_total;
/** 封面图*/
@property(nonatomic,copy)NSString *cover;
/** 时间*/
@property(nonatomic,copy)NSString *created_at;

/**作品描述*/
@property(nonatomic,copy)NSString *describle;

/** 教师评价 */
@property(nonatomic,copy)NSString *evaluate;
/** yes - 已点赞 */
@property(nonatomic,assign)BOOL is_like;

@property(nonatomic,copy)NSString *study_num;

@property(nonatomic,copy)NSString *task_id;

//@property(nonatomic,copy)NSString *thumbs;

@property(nonatomic,assign)NSInteger thumbs;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *uid;

@property(nonatomic,copy)NSString *username;

@property(nonatomic,copy)NSString *vip_class;

@property(nonatomic, strong)NSMutableArray <HKTaskCommentModel *> *comment;


/********************* 作品详情 ***********************/
@property(nonatomic,copy)NSString *comment_id;

@property(nonatomic,copy)NSString *picture_url;

@property(nonatomic,copy)NSString *content;

@property(nonatomic,copy)NSString *ID;
/** 评论回复列表 */
@property(nonatomic, strong)NSMutableArray <HKTaskCommentModel *> *reply_list;

@property(nonatomic,assign)CGFloat replyListHeight;

@property(nonatomic,assign)NSInteger secton;


/*********************  个人主页 作品 ***********************/

@property(nonatomic,assign)NSInteger count;

@property(nonatomic,assign)NSInteger gold;

@property(nonatomic,assign)NSInteger is_self;

@property(nonatomic,copy)NSString *study_video_total;

@property(nonatomic,assign)NSInteger total_page;

@property(nonatomic, strong)NSMutableArray <HKTaskModel *> *list;


@end







@interface HKTaskDetailModel : NSObject

/**作品详情 标题 */
@property(nonatomic,copy)NSString *title;

@property(nonatomic,assign)NSInteger comment_total;

/** 评论框默认文本 */
@property(nonatomic,copy)NSString *comment_default;

@property(nonatomic,copy)NSString *created_at;

@property(nonatomic,copy)NSString *describle;

@property(nonatomic,copy)NSString *evaluate;

@property(nonatomic,assign)BOOL is_like;

@property(nonatomic,copy)NSString *modify_picture_url;

@property(nonatomic,copy)NSString *picture;

@property(nonatomic,strong)ShareModel *share_data;

@property(nonatomic,assign)NSInteger thumbs;


@property(nonatomic,copy)NSString *vip_class;

@property(nonatomic,assign)NSInteger total_page;

@property(nonatomic,copy)NSString *uid;

@property(nonatomic,copy)NSString *username;

@property(nonatomic,copy)NSString *avator;

@property(nonatomic, strong)NSMutableArray <HKTaskModel *> *comment_list;

@property(nonatomic,assign)CGFloat imageH;

@property(nonatomic,assign)CGFloat modifyH;

@end














