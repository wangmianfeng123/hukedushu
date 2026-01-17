////
////  WMMenuItem.m
////  WMPageController
////
////  Created by Mark on 15/4/26.
////  Copyright (c) 2015年 yq. All rights reserved.
////
//
//#import "WMMenuItem.h"
//
//@implementation WMMenuItem {
//    CGFloat _selectedRed, _selectedGreen, _selectedBlue, _selectedAlpha;
//    CGFloat _normalRed, _normalGreen, _normalBlue, _normalAlpha;
//    int     _sign;
//    CGFloat _gap;
//    CGFloat _step;
//    __weak CADisplayLink *_link;
//}
//
//#pragma mark - Public Methods
//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        self.normalColor   = [UIColor blackColor];
//        self.selectedColor = [UIColor blackColor];
//        self.normalSize    = 15;
//        self.selectedSize  = 18;
//        self.numberOfLines = 0;
//
//        [self setupGestureRecognizer];
//    }
//    return self;
//}
//
//- (CGFloat)speedFactor {
//    if (_speedFactor <= 0) {
//        _speedFactor = 15.0;
//    }
//    return _speedFactor;
//}
//
//- (void)setupGestureRecognizer {
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpInside:)];
//    [self addGestureRecognizer:tap];
//}
//
//- (void)setSelected:(BOOL)selected withAnimation:(BOOL)animation {
//    _selected = selected;
//
//    // add 0308 选中字体加粗
//    if (selected) {
//        self.font = [UIFont systemFontOfSize:self.selectedSize weight:UIFontWeightMedium];
//        //self.isSelectedBold ? [UIFont boldSystemFontOfSize:self.selectedSize] :[UIFont systemFontOfSize:self.selectedSize];
//    }else {
//        self.font = [UIFont systemFontOfSize:self.normalSize];
//    }
//
//    if (!animation) {
//        self.rate = selected ? 1.0 : 0.0;
//        return;
//    }
//    _sign = (selected == YES) ? 1 : -1;
//    _gap  = (selected == YES) ? (1.0 - self.rate) : (self.rate - 0.0);
//    _step = _gap / self.speedFactor;
//    if (_link) {
//        [_link invalidate];
//    }
//    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rateChange)];
//    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
//    _link = link;
//}
//
//- (void)rateChange {
//    if (_gap > 0.000001) {
//        _gap -= _step;
//        if (_gap < 0.0) {
//            self.rate = (int)(self.rate + _sign * _step + 0.5);
//            return;
//        }
//        self.rate += _sign * _step;
//    } else {
//        self.rate = (int)(self.rate + 0.5);
//        [_link invalidate];
//        _link = nil;
//    }
//}
//
//// 设置rate,并刷新标题状态
//- (void)setRate:(CGFloat)rate {
//    if (rate < 0.0 || rate > 1.0) { return; }
//    _rate = rate;
//    CGFloat r = _normalRed + (_selectedRed - _normalRed) * rate;
//    CGFloat g = _normalGreen + (_selectedGreen - _normalGreen) * rate;
//    CGFloat b = _normalBlue + (_selectedBlue - _normalBlue) * rate;
//    CGFloat a = _normalAlpha + (_selectedAlpha - _normalAlpha) * rate;
//    self.textColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
//    CGFloat minScale = self.normalSize / self.selectedSize;
//    CGFloat trueScale = minScale + (1 - minScale)*rate;
//    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
//}
//
//- (void)setSelectedColor:(UIColor *)selectedColor {
//    _selectedColor = selectedColor;
//    [selectedColor getRed:&_selectedRed green:&_selectedGreen blue:&_selectedBlue alpha:&_selectedAlpha];
//}
//
//- (void)setNormalColor:(UIColor *)normalColor {
//    _normalColor = normalColor;
//    [normalColor getRed:&_normalRed green:&_normalGreen blue:&_normalBlue alpha:&_normalAlpha];
//}
//
//- (void)touchUpInside:(id)sender {
//    if ([self.delegate respondsToSelector:@selector(didPressedMenuItem:)]) {
//        [self.delegate didPressedMenuItem:self];
//    }
//}
//
//
//
//@end







//
//  WMMenuItem.m
//  WMPageController
//
//  Created by Mark on 15/4/26.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "WMMenuItem.h"
#import "Masonry.h"


@implementation WMMenuItem {
    CGFloat _selectedRed, _selectedGreen, _selectedBlue, _selectedAlpha;
    CGFloat _normalRed, _normalGreen, _normalBlue, _normalAlpha;
    int     _sign;
    CGFloat _gap;
    CGFloat _step;
    __weak CADisplayLink *_link;
}

#pragma mark - Public Methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.normalColor   = [UIColor blackColor];
        self.selectedColor = [UIColor blackColor];
        self.normalSize    = 15;
        self.selectedSize  = 18;
        //self.numberOfLines = 0;
        
        [self setupGestureRecognizer];
        
        [self addSubview:self.titleLB];
        [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-7);
        }];
    }
    return self;
}

- (CGFloat)speedFactor {
    if (_speedFactor <= 0) {
        _speedFactor = 15.0;
    }
    return _speedFactor;
}

- (void)setupGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpInside:)];
    [self addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected withAnimation:(BOOL)animation {
    _selected = selected;
    
    // add 0308 选中字体加粗
    if (selected) {
        self.font = [UIFont systemFontOfSize:self.selectedSize weight:UIFontWeightMedium];
        //self.isSelectedBold ? [UIFont boldSystemFontOfSize:self.selectedSize] :[UIFont systemFontOfSize:self.selectedSize];
    }else {
        if (self.isAllItemBold) {
            self.font = [UIFont systemFontOfSize:self.normalSize weight:UIFontWeightMedium];
        }else{
            self.font = [UIFont systemFontOfSize:self.normalSize];
        }
    }
    
    if (!animation) {
        self.rate = selected ? 1.0 : 0.0;
        return;
    }
    _sign = (selected == YES) ? 1 : -1;
    _gap  = (selected == YES) ? (1.0 - self.rate) : (self.rate - 0.0);
    _step = _gap / self.speedFactor;
    if (_link) {
        [_link invalidate];
    }
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rateChange)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _link = link;
}

- (void)rateChange {
    if (_gap > 0.000001) {
        _gap -= _step;
        if (_gap < 0.0) {
            self.rate = (int)(self.rate + _sign * _step + 0.5);
            return;
        }
        self.rate += _sign * _step;
    } else {
        self.rate = (int)(self.rate + 0.5);
        [_link invalidate];
        _link = nil;
    }
}

// 设置rate,并刷新标题状态
- (void)setRate:(CGFloat)rate {
    if (rate < 0.0 || rate > 1.0) { return; }
    _rate = rate;
    CGFloat r = _normalRed + (_selectedRed - _normalRed) * rate;
    CGFloat g = _normalGreen + (_selectedGreen - _normalGreen) * rate;
    CGFloat b = _normalBlue + (_selectedBlue - _normalBlue) * rate;
    CGFloat a = _normalAlpha + (_selectedAlpha - _normalAlpha) * rate;
    self.textColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
    CGFloat minScale = self.normalSize / self.selectedSize;
    CGFloat trueScale = minScale + (1 - minScale)*rate;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [selectedColor getRed:&_selectedRed green:&_selectedGreen blue:&_selectedBlue alpha:&_selectedAlpha];
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [normalColor getRed:&_normalRed green:&_normalGreen blue:&_normalBlue alpha:&_normalAlpha];
}

- (void)touchUpInside:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didPressedMenuItem:)]) {
        [self.delegate didPressedMenuItem:self];
    }
}



- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel new];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.userInteractionEnabled = YES;
        _titleLB.numberOfLines = 0;
        _titleLB.backgroundColor = [UIColor whiteColor];
        _titleLB.hidden = YES;
    }
    return _titleLB;
}



@end
