//
//  HKCommentScoreView.h
//  Code
//
//  Created by Ivan li on 2018/5/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NewCommentHeadModel;

typedef void(^CommentScoreViewBlock)(id sender);

@interface HKCommentScoreView : UIView

@property(nonatomic,copy)CommentScoreViewBlock commentScoreViewBlock;

//@property(nonatomic,strong)NewCommentHeadModel *model;

@property (nonatomic , strong) NSNumber * score;

@property (nonatomic, copy)NSString * diff;
@end
