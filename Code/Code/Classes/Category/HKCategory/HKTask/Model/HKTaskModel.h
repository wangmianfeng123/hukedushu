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

/** */
@property(nonatomic,copy)NSString *evaluate;

@property(nonatomic,assign)BOOL is_like;

@property(nonatomic,copy)NSString *study_num;

@property(nonatomic,copy)NSString *task_id;

@property(nonatomic,copy)NSString *thumbs;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *uid;

@property(nonatomic,copy)NSString *username;

@property(nonatomic,copy)NSString *vip_class;

@property(nonatomic, strong)NSMutableArray <HKTaskCommentModel *> *comment;


/********************* 作品详情 ***********************/
@property(nonatomic,copy)NSString *comment_id;

@property(nonatomic,copy)NSString *content;

@property(nonatomic,copy)NSString *ID;
/** 评论回复列表 */
@property(nonatomic, strong)NSMutableArray <HKTaskCommentModel *> *reply_list;

@property(nonatomic,assign)CGFloat replyListHeight;

@end







@interface HKTaskDetailModel : NSObject

@property(nonatomic,assign)NSInteger comment_total;

@property(nonatomic,copy)NSString *created_at;

@property(nonatomic,copy)NSString *describle;

@property(nonatomic,copy)NSString *evaluate;

@property(nonatomic,assign)BOOL is_like;

@property(nonatomic,copy)NSString *modify_picture_url;

@property(nonatomic,copy)NSString *picture;

@property(nonatomic,strong)ShareModel *share_data;

@property(nonatomic,copy)NSString *thumbs;


@property(nonatomic,copy)NSString *vip_class;

@property(nonatomic,assign)NSInteger total_page;

@property(nonatomic,copy)NSString *uid;

@property(nonatomic,copy)NSString *username;

@property(nonatomic,copy)NSString *avator;

@property(nonatomic, strong)NSMutableArray <HKTaskModel *> *comment_list;

@property(nonatomic,assign)CGFloat imageH;

@property(nonatomic,assign)CGFloat modifyH;

@end













