//
//  HKCommentEmptyView.h
//  Code
//
//  Created by Ivan li on 2018/5/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommentEmptyViewBlock)(id sender);

@interface HKCommentEmptyView : UIView

@property(nonatomic,copy)CommentEmptyViewBlock commentEmptyViewBlock;

@end
