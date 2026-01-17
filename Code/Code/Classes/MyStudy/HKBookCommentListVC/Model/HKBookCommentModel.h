//
//  HKBookCommentModel.h
//  Code
//
//  Created by Ivan li on 2019/8/27.
//  Copyright © 2019 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit/IGListDiffable.h>

NS_ASSUME_NONNULL_BEGIN


@interface HKBookCommentModel : NSObject <IGListDiffable>

@property(nonatomic,copy)NSString *cover;

@property(nonatomic,copy)NSString *course_id;

@property(nonatomic,copy)NSString *book_id;

@property(nonatomic,copy)NSString *comment_id;

@property(nonatomic,copy)NSString *uid;

@property(nonatomic,copy)NSString *username;

@property(nonatomic,copy)NSString *avatar;

@property(nonatomic,copy)NSString *content;

@property(nonatomic,copy)NSString *score;

@property(nonatomic,copy)NSString *created_at;

@property(nonatomic,copy)NSString *user_vip;

@property(nonatomic,copy)NSString *image_url;

@property (nonatomic,strong) NSMutableArray <HKBookCommentModel*>*children;

/////// 子评论
/// 回复评论ID
@property(nonatomic,copy)NSString *reply_id;
/// 被评论用户ID
@property(nonatomic,copy)NSString *reply_to_uid;
/// 被评论用户名
@property(nonatomic,copy)NSString *reply_to_username;
/// YES -  消息已读
@property(nonatomic,assign)BOOL is_read;
/// 消息文本 高度
@property (nonatomic, assign)CGFloat contentLBHeigth;
/// 消息cell 高度
@property (nonatomic, assign)CGFloat cellMyNotiHeight;

/// 评论cell 高度
@property (nonatomic, assign)CGFloat cellHeight;

@property (nonatomic, assign)CGFloat cellInfoHeight;
/// 是否展开
@property (nonatomic, assign) BOOL expanded;
/// 是否隐藏 下划线
@property (nonatomic, assign) BOOL isHiddenBottomLine;
/// 1：优质评论 0：普通评论
@property (nonatomic, assign) BOOL is_excellent;

@end



@interface HKBookTopModel : NSObject <IGListDiffable>

@property (nonatomic,strong) HKBookCommentModel *model;

@end


@interface HKBookMidCommentModel : NSObject <IGListDiffable>

@property (nonatomic,strong) HKBookCommentModel *model;

@end


@interface HKBookBottomModel : NSObject <IGListDiffable>

@property (nonatomic,strong) HKBookCommentModel *model;

@end


@interface HKBookActionModel : NSObject <IGListDiffable>

@property (nonatomic,strong) HKBookCommentModel *model;

@end



@interface HKBookMidCommentTopModel : NSObject <IGListDiffable>

@property (nonatomic,strong) HKBookCommentModel *model;

@end


@interface HKBookMidCommentBottomModel : NSObject <IGListDiffable>

@property (nonatomic,strong) HKBookCommentModel *model;

@end



NS_ASSUME_NONNULL_END
