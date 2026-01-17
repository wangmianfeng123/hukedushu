//
//  ACActionSheet.m
//  ACActionSheetDemo
//
//  Created by Zhangziyun on 16/5/3.
//  Copyright © 2016年 章子云. All rights reserved.
//
//  GitHub:     https://github.com/GardenerYun

#import "ACActionSheet.h"

#define ACScreenWidth   [UIScreen mainScreen].bounds.size.width
#define ACScreenHeight  [UIScreen mainScreen].bounds.size.height
#define ACRGB(r,g,b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define ACTitleFont     [UIFont systemFontOfSize:17.0f]

#define ACTitleHeight 60.0f
#define ACButtonHeight  49.0f

#define ACDarkShadowViewAlpha 0.35f

#define ACShowAnimateDuration 0.3f
#define ACHideAnimateDuration 0.2f

@interface ACActionSheet () {
    
    NSString *_cancelButtonTitle;
    NSString *_destructiveButtonTitle;
    NSArray *_otherButtonTitles;
    NSArray *_buttonImgs;

    NSArray<UIColor*> *_buttonTitleColors;
    
    UIColor *_cancelTitleColor;
    
    UIView *_buttonBackgroundView;
    UIView *_darkShadowView;
}


@property (nonatomic, copy) ACActionSheetBlock actionSheetBlock;

@end

@implementation ACActionSheet

- (instancetype)initWithTitle:(NSString *)title delegate:(id<ACActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {

    self = [super init];
    if(self) {
        _title = title;
        _delegate = delegate;
        _cancelButtonTitle = cancelButtonTitle.length>0 ? cancelButtonTitle : @"取消";
        _destructiveButtonTitle = destructiveButtonTitle;
        
        NSMutableArray *args = [NSMutableArray array];
        
        if(_destructiveButtonTitle.length) {
            [args addObject:_destructiveButtonTitle];
        }
        
        [args addObject:otherButtonTitles];
        
        if (otherButtonTitles) {
            va_list params;
            va_start(params, otherButtonTitles);
            id buttonTitle;
            while ((buttonTitle = va_arg(params, id))) {
                if (buttonTitle) {
                    [args addObject:buttonTitle];
                }
            }
            va_end(params);
        }
        
        _otherButtonTitles = [NSArray arrayWithArray:args];
     
        [self _initSubViews];
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelTitleColor:(UIColor *)cancelTitleColor destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles otherButtonImgs:(NSArray *)buttonImgs buttonTitleColors:(NSArray<UIColor*> *)buttonTitleColors actionSheetBlock:(ACActionSheetBlock) actionSheetBlock{
    
    self = [super init];
    if(self) {
        _title = title;
        
        _cancelButtonTitle = cancelButtonTitle;
        
        _cancelTitleColor = cancelTitleColor;
        _buttonImgs = buttonImgs;
        // 汤彬修改注释************************
//        _cancelButtonTitle = cancelButtonTitle.length>0 ? cancelButtonTitle : @"取消";
        // *********************************
        
        _destructiveButtonTitle = destructiveButtonTitle;
        
        NSMutableArray *titleArray = [NSMutableArray array];
        if (_destructiveButtonTitle.length) {
            [titleArray addObject:_destructiveButtonTitle];
        }
        [titleArray addObjectsFromArray:otherButtonTitles];
        _otherButtonTitles = [NSArray arrayWithArray:titleArray];
        self.actionSheetBlock = actionSheetBlock;
        
        if (buttonTitleColors) {
            _buttonTitleColors = [NSArray arrayWithArray:buttonTitleColors];
        }
        
        [self _initSubViews];
    }
    
    return self;
    
    
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelTitleColor:(UIColor *)cancelTitleColor destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles buttonTitleColors:(NSArray<UIColor*> *)buttonTitleColors actionSheetBlock:(ACActionSheetBlock) actionSheetBlock {
    
    self = [super init];
    if(self) {
        _title = title;
        
        _cancelButtonTitle = cancelButtonTitle;
        
        _cancelTitleColor = cancelTitleColor;
        
        // 汤彬修改注释************************
//        _cancelButtonTitle = cancelButtonTitle.length>0 ? cancelButtonTitle : @"取消";
        // *********************************
        
        _destructiveButtonTitle = destructiveButtonTitle;
        
        NSMutableArray *titleArray = [NSMutableArray array];
        if (_destructiveButtonTitle.length) {
            [titleArray addObject:_destructiveButtonTitle];
        }
        [titleArray addObjectsFromArray:otherButtonTitles];
        _otherButtonTitles = [NSArray arrayWithArray:titleArray];
        self.actionSheetBlock = actionSheetBlock;
        
        if (buttonTitleColors) {
            _buttonTitleColors = [NSArray arrayWithArray:buttonTitleColors];
        }
        
        [self _initSubViews];
    }
    
    return self;
    
}


- (void)_initSubViews {

    self.frame = CGRectMake(0, 0, ACScreenWidth, ACScreenHeight);
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    
    _darkShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ACScreenWidth, ACScreenHeight)];
    _darkShadowView.backgroundColor = ACRGB(20, 20, 20);
    _darkShadowView.alpha = 0.0f;
    [self addSubview:_darkShadowView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismissView:)];
    [_darkShadowView addGestureRecognizer:tap];
    
    
    _buttonBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    UIColor *bgColor = [UIColor hkdm_colorWithColorLight:ACRGB(220, 220, 220) dark:COLOR_333D48];
    _buttonBackgroundView.backgroundColor = bgColor;
    [self addSubview:_buttonBackgroundView];
    
    if (self.title.length) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ACButtonHeight-ACTitleHeight, ACScreenWidth, ACTitleHeight)];
        titleLabel.text = _title;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = ACRGB(125, 125, 125);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.backgroundColor = [UIColor whiteColor];
        [_buttonBackgroundView addSubview:titleLabel];
    }
    
    
    for (int i = 0; i < _otherButtonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:_otherButtonTitles[i] forState:UIControlStateNormal];
        button.backgroundColor = COLOR_FFFFFF_3D4752;//[UIColor whiteColor];
        button.titleLabel.font = ACTitleFont;
        //[button.titleLabel setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ?17:15]];
        if (_buttonTitleColors && _buttonTitleColors.count>= i) {
            [button setTitleColor:_buttonTitleColors[i] forState:UIControlStateNormal];
        }else{
            UIColor *textColor = COLOR_27323F_EFEFF6;
            [button setTitleColor:textColor forState:UIControlStateNormal];
        }
        if (i==0 && _destructiveButtonTitle.length) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        
        if (i<_buttonImgs.count && _buttonImgs.count) {
            UIImage *image = [UIImage imageNamed:_buttonImgs[i]];
            [button setImage:image forState:UIControlStateNormal];
        }
        [button layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        //[button setBackgroundImage:image forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(_didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonY = ACButtonHeight * (i + (_title.length>0?1:0));
        button.frame = CGRectMake(0, buttonY, ACScreenWidth, ACButtonHeight);
        [_buttonBackgroundView addSubview:button];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        UIColor *bgColor = [UIColor hkdm_colorWithColorLight:ACRGB(210, 210, 210) dark:COLOR_333D48];
        line.backgroundColor = bgColor;
        line.frame = CGRectMake(0, buttonY, ACScreenWidth, 0.5);
        [_buttonBackgroundView addSubview:line];
    }
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.tag = _otherButtonTitles.count;
    [cancelButton setTitle:_cancelButtonTitle forState:UIControlStateNormal];
    cancelButton.backgroundColor = COLOR_FFFFFF_3D4752;
    cancelButton.titleLabel.font = ACTitleFont;
    [cancelButton setTitleColor:(_cancelTitleColor == nil) ?[UIColor blackColor] :_cancelTitleColor forState:UIControlStateNormal];
    
    UIImage *image = [UIImage imageNamed:@"ACActionSheet.bundle/actionSheetHighLighted.png"];
    [cancelButton setBackgroundImage:image forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(_didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat buttonY = ACButtonHeight * (_otherButtonTitles.count + (_title.length>0?1:0)) + 5;
    cancelButton.frame = CGRectMake(0, buttonY, ACScreenWidth, ACButtonHeight);
    
    // 汤彬修改 去除取消按钮
    cancelButton.hidden = _cancelButtonTitle.length <= 0;
    cancelButton.height = _cancelButtonTitle.length > 0? ACButtonHeight : 0;
    
    [_buttonBackgroundView addSubview:cancelButton];
    
    CGFloat height = ACButtonHeight * (_otherButtonTitles.count+1 + (_title.length>0?1:0)) + 5;
    
    // 汤彬修改 去除取消按钮
    if (_cancelButtonTitle.length <= 0) {
        height = ACButtonHeight * (_otherButtonTitles.count + (_title.length>0?1:0)) + 0;
    }
    
    
    _buttonBackgroundView.frame = CGRectMake(0, ACScreenHeight, ACScreenWidth, height);
    
}

- (void)_didClickButton:(UIButton *)button {

    if (_delegate && [_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
        [_delegate actionSheet:self didClickedButtonAtIndex:button.tag];
    }
    
    if (self.actionSheetBlock) {
        self.actionSheetBlock(button.tag);
    }
    
    [self _hide];
}

- (void)_dismissView:(UITapGestureRecognizer *)tap {

    if (_delegate && [_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
        [_delegate actionSheet:self didClickedButtonAtIndex:_otherButtonTitles.count];
    }
    
    if (self.actionSheetBlock) {
        self.actionSheetBlock(_otherButtonTitles.count);
    }
    [self _hide];
}

- (void)show {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    self.hidden = NO;
    
    [UIView animateWithDuration:ACShowAnimateDuration animations:^{
        _darkShadowView.alpha = ACDarkShadowViewAlpha;
        _buttonBackgroundView.transform = CGAffineTransformMakeTranslation(0, -_buttonBackgroundView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)_hide {
    
    [UIView animateWithDuration:ACHideAnimateDuration animations:^{
        _darkShadowView.alpha = 0;
        _buttonBackgroundView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
