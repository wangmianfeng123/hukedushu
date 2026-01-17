//
//  HKInputTool.h
//  Code
//
//  Created by Ivan li on 2018/7/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKPlaceholderTextView.h"
#import "HKTaskCountBtn.h"


@class HKTaskModel, HKTaskDetailModel,HKInputTool;

@protocol HKInputToolDelegate <NSObject>

@optional
- (void)sendComment:(NSString*)comment tool:(HKInputTool*)tool commentId:(NSString*)commentId
            section:(NSInteger)section taskModel:(HKTaskModel*)taskModel;

- (void)inputToolBeginEdit;

@end

@interface HKInputTool : UIView<UITextViewDelegate>

@property (nonatomic,weak)id <HKInputToolDelegate> delegate;

@property (nonatomic,strong) HKTaskCountBtn *countBtn;

@property (nonatomic,strong) UIButton *sendButton;

@property (nonatomic,strong) UILabel *countLB;

@property (nonatomic,strong) HKTaskDetailModel *model;

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) UILabel *placeholderLab;

@property (nonatomic,copy) NSString *placeholder;

@property (nonatomic,copy) NSString *commentId;

@property (nonatomic,assign) NSInteger section;

@property (nonatomic,strong) HKTaskModel *taskModel;

- (void)showInputTool:(NSString*)placeholder commentId:(NSString*)commentId section:(NSInteger)section taskModel:(HKTaskModel *)taskModel;

@end
