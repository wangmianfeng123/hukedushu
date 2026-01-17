//
//  HKArticleModel.h
//  Code
//
//  Created by hanchuangkeji on 2018/8/3.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKArticleCommentModel : NSObject

@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *avator;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *comment_id;
@property (nonatomic, copy)NSString *vipType;
@property (nonatomic, copy)NSString *timeString;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *article_id;

@property (nonatomic, copy)NSString *uid;

// 计算cell高度
@property (nonatomic, assign)CGFloat cellHeight;

@end


@interface HKArticleRelactionModel : NSObject

@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *avator;
@property (nonatomic, copy)NSString *title;

@property (nonatomic, copy)NSString *user_header;
@property (nonatomic, copy)NSString *user_name;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, assign)BOOL isExclusive; // 独家

@property (nonatomic, copy)NSString *readCount;
@property (nonatomic, copy)NSString *likeCount;

@end
