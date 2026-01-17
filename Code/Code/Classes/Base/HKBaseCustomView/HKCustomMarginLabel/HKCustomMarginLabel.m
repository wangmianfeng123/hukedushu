//
//  HKCustomMarginLabel.m
//  Code
//
//  Created by Ivan li on 2017/12/21.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKCustomMarginLabel.h"

@implementation HKCustomMarginLabel


- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    _textInsets = UIEdgeInsetsZero;
}


- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect,_textInsets)];
}


// 修改绘制文字的区域，edgeInsets增加bounds
-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    /*调用父类该方法   注意传入的UIEdgeInsetsInsetRect(bounds, self.edgeInsets),bounds是真正的绘图区域 */

    if (isEmpty(self.text)) {
        CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds,UIEdgeInsetsZero) limitedToNumberOfLines:numberOfLines];;
        return rect;
    }
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds,self.textInsets) limitedToNumberOfLines:numberOfLines];
    //根据edgeInsets，修改绘制文字的bounds
    rect.origin.x -= self.textInsets.left;
    rect.origin.y -= self.textInsets.top;
    rect.size.width += self.textInsets.left + self.textInsets.right;
    rect.size.height += self.textInsets.top + self.textInsets.bottom;
//    NSLog(@"%f",self.textInsets.left);
//    NSLog(@"rect.origin.x -- %f",rect.origin.x);
    return rect;
}

- (void)setTextInsets:(UIEdgeInsets)textInsets {
    _textInsets = textInsets;
}

@end
