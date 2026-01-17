//
//  iCommentView.m
//  Code
//
//  Created by Ivan li on 2020/12/11.
//  Copyright © 2020 pg. All rights reserved.
//

#import "iCommentView.h"



@implementation iCommentView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.tipImgV addGestureRecognizer:tap];
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.iconImgV addGestureRecognizer:tap1];
}

- (void)tapClick{
    NSLog(@"====");
    [MobClick event: detailpage_watchedcomment];
    if (self.didTapBlock) {
        self.didTapBlock();
    }
}

-(void)setShowCommentIcon{
    BOOL showCommentIcon = [[NSUserDefaults standardUserDefaults] boolForKey:@"showCommentIcon"];
    if (showCommentIcon) {
        self.tipImgV.hidden = YES;
    }else{
        self.tipImgV.hidden = NO;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showCommentIcon"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
