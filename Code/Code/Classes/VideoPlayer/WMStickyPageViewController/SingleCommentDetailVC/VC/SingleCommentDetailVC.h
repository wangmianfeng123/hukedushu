//
//  SingleCommentDetailVC.h
//  Code
//
//  Created by Ivan li on 2017/10/31.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@class NewCommentModel,HKCommentModel,DetailModel,HKMomentDetailModel;
@interface SingleCommentDetailVC : HKBaseVC

//- (instancetype)initWithModel:(NewCommentModel *)commentModel andDetailModel:(DetailModel*)detailModel;
- (instancetype)initWithModel:(NewCommentModel *)commentModel;

@property(nonatomic,copy)void(^praiseBlock)(NSInteger section,NewCommentModel *commentModel); //点赞

@property(nonatomic,copy)void(^deleteCommentBlock)(NSInteger section,NewCommentModel *commentModel); //删除评论

//@property (nonatomic , strong) HKMomentDetailModel * detailM;
//@property (nonatomic , strong) NSString * replyID;
@property (nonatomic , strong) NSString * comment_id;
@property (nonatomic , strong) NSString * connect_type;
@property (nonatomic , strong) NSString * topic_id;



@property (nonatomic , strong) NSString * videoComment_id;

@end
