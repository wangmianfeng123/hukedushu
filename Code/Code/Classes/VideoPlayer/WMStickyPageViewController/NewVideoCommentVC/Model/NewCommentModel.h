//
//  NewCommentModel.h
//  Code
//
//  Created by Ivan li on 2017/10/30.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentChildModel : NSObject

@property(nonatomic,copy)NSString *commentId;

@property(nonatomic,copy)NSString *username;

@property(nonatomic,copy)NSString *avator;//头像

@property(nonatomic,copy)NSString *score;//评分 score-星级评价，数值即星级数

@property(nonatomic,copy)NSString *difficult;//  difficult：教程难度，1太简单，2简单，3难度适中，4有点难，5太难了

@property(nonatomic,copy)NSString *content;

@property(nonatomic,copy)NSString *image;

@property(nonatomic,copy)NSString *created_at;

@property(nonatomic,copy)NSString *reply_username;  //reply_username:被回复人的用户名

@property(nonatomic,assign)CGFloat cellHeight;

@property(nonatomic,copy)NSString *partentId;
/**点赞数*/
@property(nonatomic,copy)NSString *thumbs;


/************ 新增***************/
@property(nonatomic,copy)NSString *comment_id;

@property(nonatomic,copy)NSString *owner_avator;

@property(nonatomic,copy)NSString *owner_uid;

@property(nonatomic,copy)NSString *owner_username;

@property(nonatomic,copy)NSString *parent_id;

@property(nonatomic,copy)NSString *taget_username;

@property(nonatomic,copy)NSString *target_uid;

@end





//字段说明：score：综合评分；diff：综合难度；
//vip_type：3-终身全站通 2-全站通VIP 1-分类VIP 0-非VIP；
//thumbs：点赞数；score：星级评价，
//数值即星级数 difficult：课程难度，1太简单，2简单，3难度适中，4有点难，5太难了
//is_like:1-已点赞 0-未点赞
//reply_username:被回复人的用户名；
//stick_mark：0不置顶，1置顶


@interface NewCommentModel : NSObject

@property(nonatomic,copy)NSString *commentId;

@property(nonatomic,copy)NSString *uid; //userId

@property(nonatomic,copy)NSString *username;

@property(nonatomic,copy)NSString *avator;//头像

@property(nonatomic,copy)NSString *score;//评分 score-星级评价，数值即星级数

@property(nonatomic,copy)NSString *difficult;//  difficult：教程难度，1太简单，2简单，3难度适中，4有点难，5太难了

@property(nonatomic,copy)NSString *content;//文本

//@property(nonatomic,copy)NSString *image;

@property(nonatomic,copy)NSArray *pictures;

@property(nonatomic,copy)NSString *created_at;// 时间

@property(nonatomic,copy)NSString *is_like;//is_like:1-已点赞 0-未点赞

@property(nonatomic,strong)NSMutableArray <CommentChildModel*>*children;//子评价
@property(nonatomic,strong)NSMutableArray <CommentChildModel*>*reply_list;//子评价

/**子评价个数 */
@property(nonatomic,assign)NSInteger childrenCount;

@property(nonatomic,assign)CGFloat contentLBHeigth;

@property(nonatomic,assign)CGFloat headViewHeight;

@property(nonatomic,assign)CGSize imageSize;


@property(nonatomic,copy)NSString *stick_mark;//0不置顶，1置顶

/**点赞数*/
@property(nonatomic,copy)NSString *thumbs;

/** 2.1弃用 */
//@property(nonatomic,copy)NSString *vip_type;
/** vip 类型 */
@property(nonatomic,copy)NSString *vip_class;

@end




@interface NewCommentHeadModel : NSObject

/**评论数*/
@property(nonatomic,copy)NSString *count;

/**评论分数*/
@property(nonatomic,copy)NSString *score;

/**困难程度*/
@property(nonatomic,copy)NSString *diff;

@end







