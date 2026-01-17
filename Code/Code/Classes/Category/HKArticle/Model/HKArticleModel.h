//
//  HKArticleModel.h
//  Code
//
//  Created by hanchuangkeji on 2018/8/3.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKArticleModel : NSObject

//@property (nonatomic, copy)NSString *title;
//@property (nonatomic, copy)NSString *avator;
//
//@property (nonatomic, copy)NSString *userHeader;
//@property (nonatomic, copy)NSString *userName;
//@property (nonatomic, copy)NSString *readCount;
//@property (nonatomic, copy)NSString *likeCount;

//@property (nonatomic, assign)BOOL isExclusive;
// 收藏
//@property (nonatomic, assign)BOOL isCollection;
//
//// 点赞
//@property (nonatomic, assign)BOOL isLike;



/***************************************************/

@property (nonatomic, copy)NSString *h5_url;

@property (nonatomic, copy)NSString *abstract;

/** 作者头像 */
@property (nonatomic, copy)NSString *avator;

@property (nonatomic, assign)NSInteger be_collected_num;

@property (nonatomic, copy)NSString *comment_num;

/** 点赞数 */
@property (nonatomic, copy)NSString *appreciate_num;
/** 封面 */
@property (nonatomic, copy)NSString *cover_pic;

@property (nonatomic, assign)BOOL is_collect;

@property (nonatomic, assign)BOOL is_appreciate;

@property (nonatomic, copy)NSString *ID;//id

/** yes - 独家 */
@property (nonatomic, assign)BOOL is_exclusive;
/** yes - 作者名 */
@property (nonatomic, copy)NSString *name;

@property (nonatomic, copy)NSString *open_time;

@property (nonatomic, assign)NSInteger share_num;
/** 观看数 */
@property (nonatomic, assign)NSInteger show_num;

@property (nonatomic, copy)NSString *teacher_uid;

@property (nonatomic, copy)NSString *title;


@end



