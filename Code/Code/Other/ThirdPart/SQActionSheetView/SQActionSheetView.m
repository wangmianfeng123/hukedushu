
//
//  SQActionSheetView.m
//  Code
//
//  Created by Ivan li on 2017/10/9.
//  Copyright © 2017年 yangsq. All rights reserved.
//


#import "SQActionSheetView.h"

#define Margin  3
#define ButtonHeight  45
#define TitleHeight   30
#define LineHeight    0.5


@interface SQActionSheetView ()

@property (nonatomic, strong) UIToolbar *containerToolBar;
@property (nonatomic, assign) CGFloat toolbarH;
@end

@implementation SQActionSheetView

- (id)initWithTitle:(NSString *)title buttons:(NSArray<NSString *> *)buttons buttonClick:(void (^)(SQActionSheetView *, NSInteger))block{
    
    if (self = [super init]) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _toolbarH = buttons.count *(ButtonHeight+LineHeight) + (buttons.count>1? Margin: 0) + (title.length? TitleHeight: 0);
        
        _containerToolBar = [[UIToolbar alloc]initWithFrame:(CGRect){0,CGRectGetHeight(self.frame),CGRectGetWidth(self.frame),_toolbarH}];
        _containerToolBar.clipsToBounds = YES;
        
        
        CGFloat buttonMinY = 0;
        
        if (title.length) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), TitleHeight)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = COLOR_666666;
            label.text = title;
            [_containerToolBar addSubview:label];
            buttonMinY = TitleHeight;
        }
        
        [buttons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
            [button setTitle:obj forState:UIControlStateNormal];
            [button setTitleColor:COLOR_666666 forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ?17:15]];
            button.tag = 101+idx;
            [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
            if (idx==buttons.count-1 && buttons.count>1) {
                button.frame = (CGRect){0,buttonMinY+(ButtonHeight+LineHeight)*idx+Margin,CGRectGetWidth(self.frame),ButtonHeight};
                //button.frame = (CGRect){0,buttonMinY+(ButtonHeight+LineHeight)*idx,CGRectGetWidth(self.frame),ButtonHeight};
            }else{
                button.frame = (CGRect){0,buttonMinY+(ButtonHeight+LineHeight)*idx,CGRectGetWidth(self.frame),ButtonHeight};
            }
            [_containerToolBar addSubview:button];
            
            if (idx<buttons.count-2) {
                UIView *view= [UIView new];
                view.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5];
                [_containerToolBar addSubview:view];
                view.frame = CGRectMake(0, CGRectGetMaxY(button.frame), CGRectGetWidth(self.frame), LineHeight);
            }
        }];
        
        self.buttonClick = block;
    }
    return self;
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissView];
}

- (void)buttonTouch:(UIButton *)button{
    if (self.buttonClick) {
        self.buttonClick(self, button.tag-101);
    }
    [self dismissView];
}


- (void)showView{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow addSubview:self.containerToolBar];
    

    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _containerToolBar.transform = CGAffineTransformMakeTranslation(0, -_toolbarH);
        self.alpha = 1;

    } completion:^(BOOL finished) {
        
    }];
    //[self.containerToolBar layoutIfNeeded];
}

- (void)dismissView{
    [UIView animateWithDuration:0.3 animations:^{
        _containerToolBar.transform = CGAffineTransformIdentity;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        TTVIEW_RELEASE_SAFELY(_containerToolBar);
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
