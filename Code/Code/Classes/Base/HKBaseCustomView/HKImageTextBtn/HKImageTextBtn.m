

//
//  HKImageTextBtn.m
//  Code
//
//  Created by Ivan li on 2018/7/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKImageTextBtn.h"

@implementation HKImageTextBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setConfig];
    }
    return self;
}


- (instancetype)init {
    if (self = [super init]) {
        [self setConfig];
    }
    return self;
}



- (void)setConfig {
    self.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONEMORE4_7INCH? 12.0 : 11.0];
    [self setBackgroundImage:imageName(@"hk_video_string_black") forState:UIControlStateNormal];
    [self setTitle:@"有图文" forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
