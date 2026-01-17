//
//  HKGuideCommentVC.h
//  Code
//
//  Created by Ivan li on 2018/1/24.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HKGuideCommentView : UIView

typedef void(^PariseBlock)(id sender);

typedef void(^CommentBlock)(id sender);

/** 点赞*/
@property(nonatomic,copy)PariseBlock pariseBlock;

/** 评论*/
@property(nonatomic,copy)CommentBlock commentBlock;


@end


