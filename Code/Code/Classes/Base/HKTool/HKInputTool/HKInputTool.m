//
//  HKInputTool.m
//  Code
//
//  Created by Ivan li on 2018/7/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKInputTool.h"
#import "UIView+SNFoundation.h"
#import "HKTaskModel.h"


@implementation HKInputTool


- (instancetype)init{
    if (self = [super init]) {
        
        self.size = CGSizeMake(SCREEN_WIDTH, 50);
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.countBtn];
        [self addSubview:self.sendButton];
        [self addSubview:self.textView];
        [self.textView addSubview:self.placeholderLab];

        [self addShadowWithColor:[COLOR_E1E7EB colorWithAlphaComponent:0.5] alpha:1 radius:1 offset:CGSizeMake(0, -2)];
        
        //KVO监听contentSize变化
        [self.textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
        [self makeConstraints];
    }
    return self;
}


- (void)makeConstraints {
    [self.countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(PADDING_15);
        make.bottom.equalTo(self).offset(-PADDING_15);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countBtn.mas_right).offset(PADDING_15);
        make.right.equalTo(self).offset(-PADDING_15);
        make.bottom.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(10);
    }];
    
    [self.placeholderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.right.top.equalTo(self.textView);
        //make.height.mas_equalTo(30);
        //make.centerY.equalTo(self.textView);
        make.top.equalTo(self.textView).offset(6);;
        make.left.equalTo(self.textView).offset(PADDING_20);
        make.width.lessThanOrEqualTo(self.textView).offset(30);
    }];
    
    self.sendButton.hidden = !self.sendButton.hidden;
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-PADDING_15);
        make.bottom.equalTo(self).offset(-PADDING_10);
    }];
}


- (void)dealloc {
    [self.textView removeObserver:self forKeyPath:@"contentSize"];
}


- (HKTaskCountBtn*)countBtn {
    if (!_countBtn) {
        _countBtn = [[HKTaskCountBtn alloc]init];
        _countBtn.tag = 100;
        [_countBtn setImage:imageName(@"task_comment_bubble") forState:UIControlStateNormal];
        [_countBtn setTitleColor:COLOR_7B8196 forState:UIControlStateNormal];
        [_countBtn addTarget:self action:@selector(publishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_countBtn setEnlargeEdgeWithTop:PADDING_15 right:PADDING_25 bottom:PADDING_25 left:PADDING_25];
    }
    return _countBtn;
}



- (UIButton*)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.tag = 102;
        [_sendButton setTitleColor:COLOR_7B8196 forState:UIControlStateNormal];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = HK_FONT_SYSTEM(17);
        [_sendButton addTarget:self action:@selector(publishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}



- (void)publishBtnClick:(UIButton*)btn {
    NSInteger tag = btn.tag;
    if (100 == tag) {
        //评论数量
    }else if (102 == tag){
        //发送评论
        if (isEmpty(self.textView.text)) {
            showTipDialog(@"请输入评论内容");
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendComment:tool:commentId:section:taskModel:)]) {
            
            NSString *commentId = isEmpty(self.commentId) ?nil :self.commentId;
            [self.delegate sendComment:self.textView.text tool:self commentId:commentId section:self.section taskModel:self.taskModel];
        }
        self.textView.text = nil;
        [self.textView resignFirstResponder];
    }
}




- (UITextView*)textView {
    
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        
        _textView.font = HK_FONT_SYSTEM(14);
        _textView.clipsToBounds = YES;
        _textView.layer.cornerRadius = 15;
        _textView.textContainerInset = UIEdgeInsetsMake(6, 15, 6, 15);
        
        _textView.backgroundColor = COLOR_EFEFF6;
        [_textView setTintColor:COLOR_27323F];//光标颜色
        _textView.delegate = self;
//        _textView.inputAccessoryView = self;
    }
    return _textView;
}
    



- (UILabel*)placeholderLab {
    if (!_placeholderLab) {
        _placeholderLab = [[UILabel alloc] init];
        _placeholderLab.font = _textView.font;
        _placeholderLab.text = @"请输入评论内容...";
        _placeholderLab.textColor = COLOR_A8ABBE;
    }
    return _placeholderLab;
}



- (void)setModel:(HKTaskDetailModel *)model {
    _model = model;
    self.countBtn.count = [NSString stringWithFormat:@"%ld",model.comment_total];
    self.placeholderLab.text = model.comment_default;
}



- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    if (!isEmpty(placeholder)) {
        self.placeholderLab.text = placeholder;
    }
}


#pragma mark - 显示评论框
- (void)showInputTool:(NSString*)placeholder commentId:(NSString*)commentId section:(NSInteger)section taskModel:(HKTaskModel *)taskModel {
    
    self.commentId = commentId;
    self.section = section;
    self.taskModel = taskModel;
    
    _placeholder = placeholder;
    if (!isEmpty(placeholder)) {
        self.placeholderLab.text = placeholder;
    }
    [self.textView becomeFirstResponder];
}




#pragma mark -- UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    
    _placeholderLab.hidden = (textView.text.length);
    [self.sendButton setTitleColor:(textView.text.length) ?COLOR_3D8BFF :COLOR_7B8196 forState:UIControlStateNormal];
    
    if(textView.text.length >= 200){
        textView.text = [textView.text substringToIndex:200];
    }
}




- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputToolBeginEdit)]) {
        [self.delegate inputToolBeginEdit];
    }
    self.sendButton.hidden = NO;
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-60);
        make.left.equalTo(self.countBtn.mas_right).offset(PADDING_15);
        make.bottom.equalTo(self).offset(-PADDING_10);
        make.top.equalTo(self).offset(PADDING_10);
    }];
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (!isEmpty(self.model.comment_default)) {
        self.placeholderLab.text = self.model.comment_default;
    }
    
    //重置 评论 ID
    self.commentId = nil;
    self.section = 0;
    self.taskModel = nil;
    
    _placeholderLab.hidden = (textView.text.length);
    self.sendButton.hidden = YES;
    [self.sendButton setTitleColor:(textView.text.length) ?COLOR_3D8BFF :COLOR_7B8196 forState:UIControlStateNormal];
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-PADDING_15);
        make.left.equalTo(self.countBtn.mas_right).offset(PADDING_15);
        make.bottom.equalTo(self).offset(-PADDING_10);
        make.top.equalTo(self).offset(PADDING_10);
    }];
}



#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object == self.textView ){
        
        if ([keyPath isEqualToString:@"contentSize"]) {
            
            CGFloat height = self.textView.contentSize.height;
            if(height >= 30){
                if (height>100) { height = 100;}
                [UIView animateWithDuration:0.2 animations:^{
                    //调整frame
                    self.height = height + 20;
                    self.bottom = SCREEN_HEIGHT;
                }];
            }else{
                [UIView animateWithDuration:0.2 animations:^{
                    self.height = 50;//恢复到,键盘弹出时,视图初始位置
                    self.bottom = SCREEN_HEIGHT;
                }];
            }
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end



