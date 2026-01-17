//
//  NewVideoCommentVC.h
//  Code
//
//  Created by Ivan li on 2017/10/30.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"
@class NewCommentHeadModel;

typedef void(^CommentCountChangeBlock)(NSString *count);


typedef NS_ENUM(NSInteger,InteractionType){
    InteractionTypeAll,
    InteractionTypeWorks,
    InteractionTypeComment
};


@interface NewVideoCommentVC : HKBaseVC

/** 更新评论数量 */
@property(nonatomic,copy)CommentCountChangeBlock commentCountChangeBlock;
//@property(nonatomic,strong)void(^gradeBlock)(NewCommentHeadModel *headModel);
@property(nonatomic,copy)NSString *videoId;
@property (nonatomic , assign) InteractionType type;
@property (nonatomic , copy) NSString * pc_url;

- (instancetype)initWithDetailModel:(DetailModel*)model;

- (void)setCommentWithModel:(DetailModel*)model;

@end



