//
//  HKArticleInputTool.m
//  Code
//
//  Created by Ivan li on 2018/7/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKArticleInputTool.h"
#import "UIView+SNFoundation.h"
#import "HKTaskModel.h"

@interface HKArticleInputTool()

// 点赞按钮
@property (nonatomic, strong)UIButton *likeBtn;

// 收藏按钮
@property (nonatomic, strong)UIButton *collectBtn;

// 存储键盘收回的字符串
@property (nonatomic, copy)NSString *lastInputString;

@property (nonatomic, assign)CGFloat keyboardHeight;

@end


@implementation HKArticleInputTool


- (instancetype)init{
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        
        self.size = CGSizeMake(SCREEN_WIDTH, 50);
        self.backgroundColor = COLOR_FFFFFF_3D4752;
        [self addSubview:self.sendButton];
        [self addSubview:self.textView];
        [self addSubview:self.countBtn];
        [self addSubview:self.collectBtn];
        [self addSubview:self.likeBtn];
        [self.textView addSubview:self.placeholderLab];
        
        //[self addShadowWithColor:[COLOR_E1E7EB colorWithAlphaComponent:0.5] alpha:1 radius:1 offset:CGSizeMake(0, -2)];
        
        //KVO监听contentSize变化
        [self.textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
        [self.textView addObserver:self forKeyPath:@"firstResponder" options:NSKeyValueObservingOptionNew context:NULL];
        [self makeConstraints];
        [self setShadowColor];
        
    }
    return self;
}


- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    if (@available(iOS 13.0, *)) {
        // 主题模式 发生改变
        [self setShadowColor];
    }
}


- (void)setShadowColor {
    if (@available(iOS 13.0, *)) {
        UIColor *shadowColor = [UIColor hkdm_colorWithColorLight:[COLOR_E1E7EB colorWithAlphaComponent:0.5] dark:[UIColor clearColor]];
        ;
        [self addShadowWithColor:shadowColor alpha:1 radius:1 offset:CGSizeMake(0, -2)];
    }else{
        [self addShadowWithColor:[COLOR_E1E7EB colorWithAlphaComponent:0.5]  alpha:1 radius:1 offset:CGSizeMake(0, -2)];
    }
}



- (void)makeConstraints {
    [self.countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.top.equalTo(self);
        make.width.mas_equalTo(50);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.likeBtn.mas_left).offset(0);
        make.left.equalTo(self.countBtn.mas_right).offset(-10);
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
    
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.right.equalTo(self);
        make.width.mas_equalTo(50);
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.collectBtn);
        make.width.mas_equalTo(50);
        make.right.equalTo(self.collectBtn.mas_left);
    }];
}


- (void)dealloc {
    [self.textView removeObserver:self forKeyPath:@"contentSize"];
    [self.textView removeObserver:self forKeyPath:@"firstResponder"];
    HK_NOTIFICATION_REMOVE();
}


- (HKTaskCountBtn*)countBtn {
    if (!_countBtn) {
        _countBtn = [[HKTaskCountBtn alloc]init];
        UIImage *image = [UIImage hkdm_imageWithNameLight:@"ic_chat_v2_3" darkImageName:@"ic_chat_v2_3_dark"];
        [_countBtn setImage:image forState:UIControlStateNormal];
        [_countBtn setTitleColor:COLOR_7B8196 forState:UIControlStateNormal];
        [_countBtn addTarget:self action:@selector(publishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_countBtn setEnlargeEdgeWithTop:PADDING_15 right:PADDING_25 bottom:PADDING_25 left:PADDING_25];
        _countBtn.userInteractionEnabled = NO;
    }
    return _countBtn;
}

- (UIButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *normalImage = [UIImage hkdm_imageWithNameLight:@"ic_like_v2_3" darkImageName:@"ic_like_v2_3_dark"];
        [_collectBtn setImage:normalImage forState:UIControlStateNormal];
        [_collectBtn setImage:imageName(@"ic_like_pre_v2_3") forState:UIControlStateSelected];
        [_collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectBtn;
}

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *normalImage = [UIImage hkdm_imageWithNameLight:@"ic_goodblack_v2_3" darkImageName:@"ic_goodblack_v2_3_dark"];
        [_likeBtn setImage:normalImage forState:UIControlStateNormal];
        [_likeBtn setImage:imageName(@"ic_goodblack_pre_v2_3") forState:UIControlStateSelected];
        [_likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeBtn;
}


// 点赞按钮
- (void)likeBtnClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(likeBtnClick:model:)]) {
        [self.delegate likeBtnClick:button model:self.articleModel];
    }
}

// 收藏按钮
- (void)collectBtnClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(collectBtnClick:model:)]) {
        [self.delegate collectBtnClick:button model:self.articleModel];
    }
}



- (void)publishBtnClick:(UIButton*)btn {
    
    // 文章的代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendComment:tool:commentId:section:taskModel:)]) {
        
        NSString *commentId = isEmpty(self.commentId) ?nil :self.commentId;
        [self.delegate sendComment:self.textView.text tool:self commentId:commentId section:self.section taskModel:self.articleModel];
    }
    
    // 短视频的代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendShortVideoComment:tool:comment:)]) {
        [self.delegate sendShortVideoComment:self.commentModel tool:self comment:self.textView.text];
    }
    
    // 读书的代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendHKBookComment:tool:comment:)]) {
        [self.delegate sendHKBookComment:self.bookCommentModel tool:self comment:self.textView.text];
    }
    
    
    if (isEmpty(self.textView.text)) {
        showTipDialog(@"请输入评论内容");
    }
    self.textView.text = nil;
    self.lastInputString = nil;
    self.placeholderLab.hidden = NO;
    self.placeholderLab.text = @"写评论...";
    [self.textView resignFirstResponder];
}



- (UIButton*)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitleColor:COLOR_7B8196 forState:UIControlStateNormal];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = HK_FONT_SYSTEM(17);
        [_sendButton addTarget:self action:@selector(publishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}




- (UITextView*)textView {
    
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        
        _textView.font = HK_FONT_SYSTEM(14);
        _textView.clipsToBounds = YES;
        _textView.layer.cornerRadius = 15;
        _textView.textContainerInset = UIEdgeInsetsMake(6, 10, 6, 10);
        
        _textView.backgroundColor = COLOR_F8F9FA_333D48;
        [_textView setTintColor:COLOR_27323F_EFEFF6];//光标颜色
        _textView.delegate = self;
        //        _textView.inputAccessoryView = self;
    }
    return _textView;
}

- (void)setArticleModel:(HKArticleModel *)articleModel {
    _articleModel = articleModel;
    
    // 设置点赞与收藏样式
    self.collectBtn.selected = articleModel.is_collect;
    self.likeBtn.selected = articleModel.is_appreciate;
}


- (UILabel*)placeholderLab {
    if (!_placeholderLab) {
        _placeholderLab = [[UILabel alloc] init];
        _placeholderLab.font = _textView.font;
        _placeholderLab.text = @"写评论...";
        _placeholderLab.textColor = COLOR_7B8196_A8ABBE;
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
    
    
    if (self.lastInputString.length) {
        self.textView.text = self.lastInputString;
        self.placeholderLab.hidden = YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputToolBeginEdit)]) {
        [self.delegate inputToolBeginEdit];
    }
    self.sendButton.hidden = NO;
    self.countBtn.hidden = YES;
    self.collectBtn.hidden = YES;
    self.likeBtn.hidden = YES;
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-60);
        make.left.equalTo(self).offset(PADDING_15);
        make.bottom.equalTo(self).offset(-PADDING_10);
        make.top.equalTo(self).offset(PADDING_10);
    }];
    
    //[self.textView setBackgroundColor:HKColorFromHex(0xEFEFF6, 1.0)];
    [self.textView setBackgroundColor:COLOR_F8F9FA_333D48];
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (!isEmpty(self.model.comment_default)) {
        self.placeholderLab.text = self.model.comment_default;
    }
    
    //重置 评论 ID
    self.commentId = nil;
    self.section = 0;
    self.taskModel = nil;
    
    
    self.sendButton.hidden = YES;
    self.countBtn.hidden = NO;
    self.likeBtn.hidden = NO;
    self.collectBtn.hidden = NO;
    [self.sendButton setTitleColor:(textView.text.length) ?COLOR_3D8BFF :COLOR_7B8196 forState:UIControlStateNormal];
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.likeBtn.mas_left).offset(0);
        make.left.equalTo(self.countBtn.mas_right).offset(-10);
        make.bottom.equalTo(self).offset(-PADDING_10);
        make.top.equalTo(self).offset(PADDING_10);
    }];
    
    
    self.lastInputString = self.textView.text;
    if (self.textView.text.length) {
        //self.lastInputString = self.textView.text;
        self.textView.text = nil;
        _placeholderLab.hidden = (textView.text.length);
        _placeholderLab.text = @"写评论...";
    }
    
    //[self.textView setBackgroundColor:[UIColor whiteColor]];
    [self.textView setBackgroundColor:COLOR_F8F9FA_333D48];
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object == self.textView ){
        
        if ([keyPath isEqualToString:@"contentSize"]) {
            
            CGFloat height = self.textView.contentSize.height;
            if(height >= 30){
                if (height>100) { height = 100;}
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.35 animations:^{
                        //调整frame
                        self.height = height + 20;
                        self.bottom = !self.isShortVideoComment? SCREEN_HEIGHT : SCREEN_HEIGHT - self.keyboardHeight;
                    }];
                });
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.35 animations:^{
                        self.height = 50;//恢复到,键盘弹出时,视图初始位置
                        self.bottom = !self.isShortVideoComment? SCREEN_HEIGHT : SCREEN_HEIGHT - self.keyboardHeight;
                    }];
                });
                
            }
            
        } else if ([keyPath isEqualToString:@"firstResponder"]) {
            // 是否正在输入内容
            //            NSLog(@"firstResponder == %@  change == %@", keyPath, change);
            if ([self.delegate respondsToSelector:@selector(textView:isFirstResponder:)]) {
                [self.delegate textView:self.textView isFirstResponder:self.textView.isFirstResponder];
            }
        }
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)keyboardWillAppear:(NSNotification *)noti{
    NSDictionary *info = [noti userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = [value CGRectValue].size.height;
    self.keyboardHeight = keyboardHeight;
}


@end



