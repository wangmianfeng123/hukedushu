//
//  HKArticleInputTool.h
//  Code
//
//  Created by Ivan li on 2018/7/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKPlaceholderTextView.h"
#import "HKTaskCountBtn.h"
#import "HKArticleModel.h"
#import "HKShortVideoCommentModel.h"
#import "HKBookCommentModel.h"


@class HKTaskModel, HKTaskDetailModel,HKArticleInputTool;

@protocol HKArticleInputToolDelegate <NSObject>

@optional
- (void)sendComment:(NSString*)comment tool:(HKArticleInputTool*)tool commentId:(NSString*)commentId
            section:(NSInteger)section taskModel:(HKArticleModel *)articleModel;

- (void)sendShortVideoComment:(HKShortVideoCommentModel *)model tool:(HKArticleInputTool *)tool comment:(NSString *)comment;
//  读书评论
- (void)sendHKBookComment:(HKBookCommentModel *)model tool:(HKArticleInputTool *)tool comment:(NSString *)comment;

- (void)inputToolBeginEdit;

- (void)likeBtnClick:(UIButton *)button model:(HKArticleModel *)model;

- (void)collectBtnClick:(UIButton *)button model:(HKArticleModel *)model;

- (void)textView:(UITextView *)textView isFirstResponder:(BOOL )isFirstResponder;


@end

@interface HKArticleInputTool : UIView<UITextViewDelegate>

@property (nonatomic,weak)id <HKArticleInputToolDelegate> delegate;

@property (nonatomic,strong) HKTaskCountBtn *countBtn;

@property (nonatomic,strong) UIButton *sendButton;

@property (nonatomic,strong) UILabel *countLB;

@property (nonatomic,strong) HKTaskDetailModel *model;

@property (nonatomic,strong) HKShortVideoCommentModel *commentModel; // 短视频的评论

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) UILabel *placeholderLab;

@property (nonatomic,copy) NSString *placeholder;

@property (nonatomic,copy) NSString *commentId;

@property (nonatomic,assign) NSInteger section;

@property (nonatomic,strong) HKTaskModel *taskModel;

@property (nonatomic, assign)BOOL isShortVideoComment; // 默认为文章评论，否则为短视频评论

// 设置点赞与收藏样式
@property (nonatomic, strong)HKArticleModel *articleModel;

// 读书评论
@property (nonatomic,strong) HKBookCommentModel *bookCommentModel;
// 读书父评论
@property (nonatomic,strong)HKBookCommentModel  *mainCommentModel;
/// YES 回复主评论
@property (nonatomic,assign) BOOL isMainComment;


- (void)showInputTool:(NSString*)placeholder commentId:(NSString*)commentId section:(NSInteger)section taskModel:(HKTaskModel *)taskModel;

@end
