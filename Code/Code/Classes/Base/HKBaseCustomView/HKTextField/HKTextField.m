//
//  HKTextField.m
//  Code
//
//  Created by Ivan li on 2018/3/7.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTextField.h"

@implementation HKTextField

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}


- (void)setUp {
    
    self.tintColor = COLOR_27323F_EFEFF6;// 光标颜色
    if (self.cornerRadius >0) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.cornerRadius;
    }
}


/**UITextField 文字与输入框的距离*/
- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 23, 0);
}


/**控制文本的位置*/
- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 23, 0);
}


- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 26, 0);
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
