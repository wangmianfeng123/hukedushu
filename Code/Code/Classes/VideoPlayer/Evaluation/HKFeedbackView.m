//
//  HKFeedbackView.m
//  Code
//
//  Created by Ivan li on 2019/3/11.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKFeedbackView.h"


#define  KCommentPlaceholder  @"课程怎么样？说说你的学习心得吧（至少5个字）"

#define  KBookCommentPlaceholder @"被评为精选书评，可以获得本书纸质书籍哦~" //@"说说你对这本书的看法吧~（至少要5个字哦）"



@implementation HKFeedbackView


- (id)init {
    
    if (self = [super init]) {
        [self createUI];
        _longestLenth = 200;
    }
    return self;
}

-(void)setLongestLenth:(NSInteger)longestLenth{
    _longestLenth = longestLenth;
}

- (void)createUI {
    self.backgroundColor = COLOR_FFFFFF_333D48;
    [self addSubview:self.feedbackView];
    [self addSubview:self.pointLabel];
    [self makeConstraints];
    [self setFeedbackViewBorderColor];
}


- (void)makeConstraints {
    
    [self.feedbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(PADDING_10, PADDING_15, PADDING_15, PADDING_15));
    }];
    
    [self.pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedbackView.mas_top).offset(10);
        make.left.equalTo(self.feedbackView.mas_left).offset(PADDING_15);
        make.right.equalTo(self.feedbackView.mas_right).offset(-PADDING_15);
    }];
}



- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    
    if (@available(iOS 13.0, *)) {
        // 主题模式 发生改变
        [self setFeedbackViewBorderColor];
    }
}


- (void)setFeedbackViewBorderColor {
    self.feedbackView.layer.borderColor = [UIColor hkdm_colorWithColorLight:COLOR_EFEFF6 dark:COLOR_27323F].CGColor;
}


- (UITextView*)feedbackView {
    
    if (!_feedbackView) {
        
        _feedbackView = [UITextView new];
        _feedbackView.delegate = self;
        _feedbackView.font = [UIFont systemFontOfSize:(IS_IPHONE6PLUS ? 16:14)];
        _feedbackView.keyboardType = UIKeyboardTypeDefault;
        _feedbackView.textAlignment = NSTextAlignmentLeft;
        _feedbackView.clipsToBounds = YES;
        _feedbackView.layer.cornerRadius = 5;
        _feedbackView.layer.borderColor = COLOR_EFEFF6.CGColor;
        _feedbackView.layer.borderWidth = 1.5;
        _feedbackView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _feedbackView.textColor = COLOR_27323F_EFEFF6;
        _feedbackView.tintColor = COLOR_27323F_EFEFF6;
        _feedbackView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _feedbackView;
}



- (UILabel*)pointLabel{
    
    if (!_pointLabel) {
        _pointLabel = [UILabel new];
        _pointLabel.font = [UIFont systemFontOfSize:(IS_IPHONE6PLUS ? 16:14)];
        _pointLabel.text = KCommentPlaceholder;
        _pointLabel.numberOfLines = 0;
        _pointLabel.textColor = COLOR_A8ABBE_7B8196;
        _pointLabel.backgroundColor = [UIColor clearColor];
        [_pointLabel sizeToFit];
    }
    return _pointLabel;
}




#pragma mark - textView delegate
-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.pointLabel.text = KCommentPlaceholder;
    }else{
        self.pointLabel.text=nil;
    }
    
    if (self.commentType == HKCommentType_BookComment) {
        if(textView.text.length >= self.longestLenth){
            textView.text = [textView.text substringToIndex:self.longestLenth];
        }
    }
    
    if ([self.deletate respondsToSelector:@selector(textlength:)]) {
        [self.deletate textlength:textView.text.length];
    }
}



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}




- (void)setCommentType:(HKCommentType)commentType {
    _commentType = commentType;
    
    switch (commentType) {
        case HKCommentType_VideoComment:
        {
            self.pointLabel.text = KCommentPlaceholder;
        }
            break;
        case HKCommentType_BookComment:
        {
            self.pointLabel.text = KBookCommentPlaceholder;
        }
            break;
        default:
            break;
    }
}






@end



