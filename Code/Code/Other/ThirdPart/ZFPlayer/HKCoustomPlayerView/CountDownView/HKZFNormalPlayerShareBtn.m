//
//  HKZFNormalPlayerShareBtn.m
//  Code
//
//  Created by Ivan li on 2018/1/3.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKZFNormalPlayerShareBtn.h"

@implementation HKZFNormalPlayerShareBtn




- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}


- (void)setUp {
    //self.clipsToBounds = YES;
    //self.layer.cornerRadius = PADDING_15;
    //self.backgroundColor = [UIColor colorWithHexString:@"#dfc575"];
    [self setTitle:@"分享群解锁观看" forState:UIControlStateNormal];
    [self setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
    [self setTitleColor:COLOR_ffffff forState:UIControlStateHighlighted];
    self.titleLabel.font = HK_FONT_SYSTEM(13);
    //hkplayer_share  limit_see_bg
    [self setImage:imageName(@"hkplayer_share") forState:UIControlStateNormal];
    [self setImage:imageName(@"hkplayer_share") forState:UIControlStateHighlighted];
    [self addTarget:self action:@selector(shareVideoClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.titleLabel setNumberOfLines:0];
//    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
//
//    NSString *title = @"收藏视频\n不丢失学习记录";
//    NSMutableAttributedString *attrDisable = [[NSMutableAttributedString alloc] initWithString:title];
//    [attrDisable addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
//    [attrDisable addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, title.length)];
//
//    [attrDisable addAttribute:NSForegroundColorAttributeName value:[[UIColor whiteColor]colorWithAlphaComponent:0.7] range:NSMakeRange(5, 7)];
//    [attrDisable addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(5, 7)];
//    [self setAttributedTitle:attrDisable forState:UIControlStateNormal];
}


- (void)shareVideoClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(hKZFNormalPlayerShareAction:)]) {
        [self.delegate hKZFNormalPlayerShareAction:sender];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
