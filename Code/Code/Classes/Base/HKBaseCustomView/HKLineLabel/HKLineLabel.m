//
//  HKLineLabel.m
//  Code
//
//  Created by Ivan li on 2017/12/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKLineLabel.h"
#import "NSString+MD5.h"

@implementation HKLineLabel


- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (CGSize)intrinsicContentSize{
    
    CGSize size = [super intrinsicContentSize];
    
    size.width  += fabs(self.edgeInsets.left) + fabs(self.edgeInsets.right);
    size.height += fabs(self.edgeInsets.top) + fabs(self.edgeInsets.bottom);
    return size;
    
}
- (void)drawRect:(CGRect)rect {
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
    
    CGSize textSize = [[self text] heightWithFont:[self font] MaxWidth:SCREEN_WIDTH];
    //CGFloat strikeWidth = textSize.width;
    CGFloat strikeWidth = rect.size.width;
    
    CGRect lineRect;
    CGFloat lineHeight = (self.lineHeight>0.0)? self.lineHeight :0.8;
    
    
    if ([self textAlignment] == NSTextAlignmentRight){
        // 画线居中
        lineRect = CGRectMake(rect.size.width - strikeWidth, rect.size.height/2, strikeWidth, lineHeight);
        // 画线居下
        if (self.isBottom) {
            lineRect = CGRectMake(rect.size.width - strikeWidth, rect.size.height/2 + textSize.height/2, strikeWidth, lineHeight);
        }
    }
    else if ([self textAlignment] == NSTextAlignmentCenter){
        // 居中
        lineRect = CGRectMake(rect.size.width/2 - strikeWidth/2, rect.size.height/2, strikeWidth, lineHeight);
        // 居下
        if (self.isBottom) {
            lineRect = CGRectMake(rect.size.width/2 - strikeWidth/2, rect.size.height/2 + textSize.height/2, strikeWidth, lineHeight);
        }

    }else{
        // 居中
        lineRect = CGRectMake(0, rect.size.height/2, strikeWidth, lineHeight);
        // 居下
        if (self.isBottom) {
            lineRect = CGRectMake(0, rect.size.height/2 + textSize.height/2, strikeWidth, lineHeight);
        }
    }
    
    if (self.strikeThroughEnabled){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [self strikeThroughColor].CGColor);
        CGContextFillRect(context, lineRect);
    }
    
}


@end
