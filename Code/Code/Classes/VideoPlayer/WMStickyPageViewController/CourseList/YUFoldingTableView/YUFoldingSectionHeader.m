//
//  YUFoldingSectionHeader.m
//  YUFoldingTableView
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 liufengting. All rights reserved.
//

#import "YUFoldingSectionHeader.h"
#import "UIView+SNFoundation.h"

#define YUFoldingSepertorLineWidth       1.0f
#define YUFoldingMargin                  20.0f
#define YUFoldingIconSize                24.0f

@interface YUFoldingSectionHeader ()

@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *descriptionLabel;
@property (nonatomic, strong) UIImageView  *arrowImageView;
@property (nonatomic, assign) YUFoldingSectionHeaderArrowPosition  arrowPosition;
@property (nonatomic, assign) YUFoldingSectionState  sectionState;
@property (nonatomic, strong) UITapGestureRecognizer  *tapGesture;

@property (nonatomic, assign) CGFloat leftMargin;
/** section 点击 箭头旋转动画 默认 Yes */
@property (nonatomic, assign) BOOL isShowAnimation;

@property (nonatomic, assign) CGFloat arrowRightMargin;

@property (nonatomic, copy)NSString * descriptionString;  //保存区头descriptionString
@end

@implementation YUFoldingSectionHeader

- (instancetype)initWithFrame:(CGRect)frame tag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = tag;
        self.isShowAnimation = YES;
        //[self setupSubviewsWithArrowPosition:YUFoldingSectionHeaderArrowPositionRight];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.isShowAnimation = YES;
    //[self setupSubviewsWithArrowPosition:YUFoldingSectionHeaderArrowPositionRight];
    
}

- (void)setupWithBackgroundColor:(UIColor *)backgroundColor
                     titleString:(NSString *)titleString
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont
               descriptionString:(NSString *)descriptionString
                descriptionColor:(UIColor *)descriptionColor
                 descriptionFont:(UIFont *)descriptionFont
                      arrowImage:(UIImage *)arrowImage
                   arrowPosition:(YUFoldingSectionHeaderArrowPosition)arrowPosition
                    sectionState:(YUFoldingSectionState)sectionState
           sectionTitleLeftMagin:(CGFloat)sectionTitleLeftMagin
                arrowRightMargin:(CGFloat)arrowRightMargin
                 isShowAnimation:(BOOL)isShowAnimation
{
    
    [self setBackgroundColor:backgroundColor];
    
    self.titleLabel.text = titleString;
    self.titleLabel.textColor = titleColor;
    self.titleLabel.font = titleFont;
    
    self.descriptionLabel.text = descriptionString;
    self.descriptionString = descriptionString;
    self.descriptionLabel.textColor = descriptionColor;
    self.descriptionLabel.font = descriptionFont;
    
    self.arrowImageView.image = arrowImage;
    self.arrowPosition = arrowPosition;
    self.sectionState = sectionState;
    
    /// add 19-06-11
    self.isShowAnimation = isShowAnimation;
    self.arrowRightMargin = arrowRightMargin;
    self.leftMargin = (sectionTitleLeftMagin >0 ) ?sectionTitleLeftMagin :YUFoldingMargin;
    [self setupSubviewsWithArrowPosition:arrowPosition];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateText:) name:@"sectionNoteCount" object:nil];
    ////
    
    if (self.isShowAnimation) {
        if (sectionState == YUFoldingSectionStateShow) {
            if (self.arrowPosition == YUFoldingSectionHeaderArrowPositionRight) {
                self.arrowImageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
            }else{
                self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
            }
        } else {
            if (self.arrowPosition == YUFoldingSectionHeaderArrowPositionRight) {
                _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
            }else{
                self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
            }
        }
    }
}

- (void)updateText:(NSNotification *)noti{

    NSInteger sec = [noti.userInfo[@"section"] integerValue];
    if (self.tag == sec) {
        self.descriptionLabel.text = noti.userInfo[@"text"];
    }
}


- (CGFloat)leftMargin {
    return (_leftMargin >0 ) ?_leftMargin :YUFoldingMargin;
}


- (CGFloat)arrowRightMargin {
    return (_arrowRightMargin > 0) ?_arrowRightMargin :30;
}


- (void)setupSubviewsWithArrowPosition:(YUFoldingSectionHeaderArrowPosition)arrowPosition {
    CGFloat labelWidth = (self.frame.size.width - self.leftMargin*2 - YUFoldingIconSize)/2;
    CGFloat labelHeight = self.frame.size.height;
    CGRect arrowRect = CGRectMake(0, (self.frame.size.height - YUFoldingIconSize)/2, YUFoldingIconSize, YUFoldingIconSize);
    CGRect titleRect = CGRectMake(self.leftMargin + YUFoldingIconSize, 0, labelWidth, labelHeight);
    CGRect descriptionRect = CGRectMake(self.leftMargin + YUFoldingIconSize + labelWidth,  0, labelWidth, labelHeight);
    if (arrowPosition == YUFoldingSectionHeaderArrowPositionRight) {
        //        arrowRect.origin.x = YUFoldingMargin*2 + labelWidth*2;
        arrowRect.origin.x = SCREEN_WIDTH - arrowRect.size.width - 10;
        titleRect.origin.x = self.leftMargin;
        titleRect.size.width = self.frame.size.width - arrowRect.size.width - 100;
        descriptionRect.origin.x = self.leftMargin + labelWidth;
    }
    
    [self.titleLabel setFrame:titleRect];
    [self.descriptionLabel setFrame:descriptionRect];
    
    if (arrowPosition == YUFoldingSectionHeaderArrowPositionRight) {
        self.arrowImageView.right = self.width - self.arrowRightMargin;
        self.arrowImageView.centerY = self.centerY;
    }else{
        [self.arrowImageView setFrame:arrowRect];
    }
    
    [self.sepertorLine setPath:[self getSepertorPath].CGPath];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.descriptionLabel];
    [self addSubview:self.arrowImageView];
    [self addGestureRecognizer:self.tapGesture];
//    [self.layer addSublayer:self.sepertorLine];
}




- (void)shouldExpand:(BOOL)shouldExpand {
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         if (shouldExpand) {
                             if (self.arrowPosition == YUFoldingSectionHeaderArrowPositionRight) {
                                 self.arrowImageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
                             }else{
                                 self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
                             }
                         } else {
                             if (self.arrowPosition == YUFoldingSectionHeaderArrowPositionRight) {
                                 _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
                             }else{
                                 self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
                             }
                         }
                     } completion:^(BOOL finished) {
                         if (finished == YES) {
                             self.sepertorLine.hidden = shouldExpand;
                             self.sepertorLine.hidden = self.noShowLine;
                         }
                     }];
}


- (void)onTapped:(UITapGestureRecognizer *)gesture
{
    if (self.isShowAnimation) {
        [self shouldExpand:![NSNumber numberWithInteger:self.sectionState].boolValue];
    }
    if (_tapDelegate && [_tapDelegate respondsToSelector:@selector(yuFoldingSectionHeaderTappedAtIndex:)]) {
        self.sectionState = [NSNumber numberWithBool:(![NSNumber numberWithInteger:self.sectionState].boolValue)].integerValue;
        
//        if (self.sectionState == YUFoldingSectionStateShow) {//打开
//            self.descriptionLabel.text = @"收起";
//        }else{//折叠
//            self.descriptionLabel.text = self.descriptionString;
//        }
        [_tapDelegate yuFoldingSectionHeaderTappedAtIndex:self.tag];
    }
}

// MARK: -----------------------  getter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
- (UILabel *)descriptionLabel
{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.textAlignment = NSTextAlignmentRight;
    }
    return _descriptionLabel;
}
- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _arrowImageView.backgroundColor = [UIColor clearColor];
        _arrowImageView.contentMode = UIViewContentModeCenter;
    }
    return _arrowImageView;
}
- (CAShapeLayer *)sepertorLine
{
    if (!_sepertorLine) {
        _sepertorLine = [CAShapeLayer layer];
        _sepertorLine.strokeColor = COLOR_F8F9FA_333D48.CGColor; //[UIColor whiteColor].CGColor;
        _sepertorLine.lineWidth = YUFoldingSepertorLineWidth;
        //_sepertorLine.strokeColor = [UIColor redColor].CGColor; //[UIColor whiteColor].CGColor;
        //_sepertorLine.lineWidth = 2;

    }
    return _sepertorLine;
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapped:)];
    }
    return _tapGesture;
}

- (UIBezierPath *)getSepertorPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.frame.size.height - YUFoldingSepertorLineWidth)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - YUFoldingSepertorLineWidth)];
    return path;
}

@end
