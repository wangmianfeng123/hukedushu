//
//  HKArticleRelationHeaderView.h
//  Code
//
//  Created by hanchuangkeji on 2018/8/8.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKArticleRelationHeaderView : UIView

@property (nonatomic, copy)void(^likeBtnClickBlock)(UIButton *button);

- (void)setLikeBtn:(NSString *)count isLike:(BOOL)isLike;

@end

//
//// 上下排布的点赞按钮
//@interface HKArticleRelationHeaderViewButton : UIButton
//
//@end
