
//
//  PlaceholderTextView.m
//  Code
//
//  Created by Ivan li on 2017/12/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKPlaceholderTextView.h"

#define MAX_TEXT_COUNT  200 //最大字符数

#define MAX_COUNT  10000000 //无限输入

@interface HKPlaceholderTextView()<UITextViewDelegate>

@property(strong,nonatomic) UIColor *placeholder_color;

@property(strong,nonatomic) UIFont * placeholder_font;
//Placeholder
@property(strong,nonatomic) UILabel *placeholderLabel;

@property(assign,nonatomic) float placeholdeWidth;

@property(copy,nonatomic) id eventBlock;

@property(copy,nonatomic) id BeginBlock;

@property(copy,nonatomic) id EndBlock;

@property(strong,nonatomic)UILabel *countLabel;
//最大长度设置
@property(assign,nonatomic)NSInteger maxTextLength;

@end


@implementation HKPlaceholderTextView


- (instancetype)initWithMaxTextLenght:(NSInteger)textLenght isShowLimitCount:(BOOL)isShowLimitCount{
    
    if ((self = [super init])) {
        self.isShowLimitCount = isShowLimitCount;
        if (isShowLimitCount) {
            self.maxTextLength = (textLenght <= 0)? MAX_TEXT_COUNT :textLenght; // 默认 200;
        }else{
            self.maxTextLength = MAX_COUNT;
        }
        [self createUI];
    }
    return self;
}


- (void)dealloc{
    TTVIEW_RELEASE_SAFELY(_placeholderLabel);
    HK_NOTIFICATION_REMOVE();
}


- (void)createUI {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewBeginNoti:) name:UITextViewTextDidBeginEditingNotification object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEndNoti:) name:UITextViewTextDidEndEditingNotification object:self];
    
    [self addSubview:self.placeholderLabel];
    [self addSubview:self.countLabel];
    
    [self defaultConfig];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat offsetLeft = self.textContainerInset.left + self.textContainer.lineFragmentPadding;
    CGFloat offsetRight = self.textContainerInset.right + self.textContainer.lineFragmentPadding;
    CGFloat offsetTop = self.textContainerInset.top;
    CGFloat offsetBottom = self.textContainerInset.bottom;
    
    CGSize expectedSize = [_placeholderLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame) - offsetLeft, CGRectGetHeight(self.frame)-offsetTop-offsetBottom)];
    _placeholderLabel.frame = CGRectMake(offsetLeft, offsetTop, expectedSize.width, expectedSize.height);
    //[_placeholderLabel sizeToFit];
    _countLabel.frame = CGRectMake(self.width - self.textContainerInset.right - 40, self.height-offsetBottom - PADDING_15, PADDING_20*2, PADDING_15);
//    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(PADDING_20*2, PADDING_15));
//        make.right.equalTo(self.mas_right).offset(-(self.textContainerInset.right - 40));
//        make.bottom.equalTo(self.mas_bottom).offset(-PADDING_15);
//    }];
}



#pragma mark - System Delegate
#pragma mark - custom Delegate
#pragma mark - Event response


- (void)defaultConfig {
    
    self.placeholder_color = COLOR_A8ABBE;
    self.placeholder_font  = [UIFont systemFontOfSize:14];
    //self.layoutManager.allowsNonContiguousLayout = NO;
}

- (void)addMaxTextLengthWithMaxLength:(NSInteger)maxLength andEvent:(void (^)(HKPlaceholderTextView *text))limit {
    
    if (maxLength > 0) {
        _maxTextLength = maxLength;
    }
    if (limit) {
        _eventBlock = limit;
    }
}

- (void)addTextViewBeginEvent:(void (^)(HKPlaceholderTextView *))begin{
    _BeginBlock = begin;
}

- (void)addTextViewEndEvent:(void (^)(HKPlaceholderTextView *))End{
    _EndBlock = End;
}

- (void)setUpdateHeight:(float)updateHeight{
    
    CGRect frame = self.frame;
    frame.size.height = updateHeight;
    self.frame = frame;
    _updateHeight = updateHeight;
}


// Placeholder 设置
- (void)setPlaceholderFont:(UIFont *)font {
    self.placeholder_font = font;
}

- (void)setPlaceholderColor:(UIColor *)color {
    self.placeholder_color = color;
}

- (void)setPlaceholderOpacity:(float)opacity {
    if (opacity<0) {
        opacity=1;
    }
    self.placeholderLabel.layer.opacity = opacity;
}


#pragma mark - Noti Event

- (void)textViewBeginNoti:(NSNotification*)noti{
    
    if (_BeginBlock) {
        void(^begin)(HKPlaceholderTextView*text) = _BeginBlock;
        begin(self);
    }
}

- (void)textViewEndNoti:(NSNotification*)noti{
    if (_EndBlock) {
        void(^end)(HKPlaceholderTextView*text) = _EndBlock;
        end(self);
    }
}

- (void)textDidChange:(NSNotification*)noti{
    
    if (self.placeholder.length == 0 || isEmpty(self.placeholder)) {
        _placeholderLabel.hidden = YES;
    }
    if (self.text.length > 0) {
        _placeholderLabel.hidden = YES;
    }
    else{
        _placeholderLabel.hidden = NO;
    }
    
    NSString *lang = [[self.nextResponder textInputMode] primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (self.text.length > self.maxTextLength) {
                self.text = [self.text substringToIndex:self.maxTextLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (self.text.length > self.maxTextLength) {
             self.text = [ self.text substringToIndex:self.maxTextLength];
        }
    }
    if (_eventBlock && self.text.length > self.maxTextLength) {
        
        void (^limint)(HKPlaceholderTextView*text) = _eventBlock;
        limint(self);
    }
    _countLabel.text = [NSString stringWithFormat:@"%ld",(self.maxTextLength - self.text.length)];
}

#pragma mark - private method

+ (float)boundingRectWithSize:(CGSize)size withLabel:(NSString *)label withFont:(UIFont *)font{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    // CGSize retSize;
    CGSize retSize = [label boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil].size;
    
    return retSize.height;
    
}

#pragma mark - getters and Setters

- (void)setText:(NSString *)tex{
    if (tex.length>0) {
        _placeholderLabel.hidden=YES;
    }
    [super setText:tex];
}

- (void)setPlaceholder:(NSString *)placeholder{
    
    if (placeholder.length == 0 || isEmpty(placeholder)) {
        _placeholderLabel.hidden = YES;
    }else{
        _placeholderLabel.text = placeholder;
        _placeholder = placeholder;
//        float  height=  [HKPlaceholderTextView boundingRectWithSize:CGSizeMake(_placeholdeWidth, MAXFLOAT) withLabel:_placeholder withFont:_placeholderLabel.font];
//        if (height>CGRectGetHeight(_placeholderLabel.frame) && height< CGRectGetHeight(self.frame)) {
//            
//            CGRect frame=_placeholderLabel.frame;
//            frame.size.height=height;
//            _placeholderLabel.frame=frame;
//            
//        }
    }
}


- (void)setPlaceholder_font:(UIFont *)placeholder_font {
    
    _placeholder_font = placeholder_font;
    _placeholderLabel.font = placeholder_font;
}

- (void)setPlaceholder_color:(UIColor *)placeholder_color {
    _placeholder_color = placeholder_color;
    _placeholderLabel.textColor = placeholder_color;
}


- (UILabel*)placeholderLabel {
    
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _placeholderLabel.font = self.font;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.lineBreakMode = NSLineBreakByCharWrapping|NSLineBreakByWordWrapping;
    }
    return _placeholderLabel;
}


- (UILabel*)countLabel {
    if (!_countLabel && self.isShowLimitCount) {
        NSString *temp = [NSString stringWithFormat:@"%ld",self.maxTextLength];
        _countLabel = [UILabel labelWithTitle:CGRectZero title:temp titleColor:COLOR_A8ABBE titleFont:@"12" titleAligment:NSTextAlignmentRight];
        _countLabel.backgroundColor = [UIColor clearColor];
    }
    return _countLabel;
}





@end










