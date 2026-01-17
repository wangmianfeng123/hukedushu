//
//  commentBottomView.h
//  Code
//
//  Created by Ivan li on 2017/10/10.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class commentBottomView;
@protocol commentBottomViewDelegate <NSObject>

@optional
/** 跳转评论 VC */
- (void)commentBottomView:(commentBottomView*)view  comment:(id)comment;
@end


@interface commentBottomView : UIView

@property(nonatomic,strong)UILabel *lineLabel;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIView *circleLine;

@property(nonatomic,weak)id <commentBottomViewDelegate> delegate;
/** Yes - 已经添加到父类上 */
@property(nonatomic,assign)BOOL isLoaded;

@end




