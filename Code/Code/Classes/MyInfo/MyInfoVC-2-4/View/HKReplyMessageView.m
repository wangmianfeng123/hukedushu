//
//  HKReplyMessageView.m
//  Code
//
//  Created by yxma on 2020/9/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKReplyMessageView.h"

@interface HKReplyMessageView ()

@end

@implementation HKReplyMessageView
//+ (HKReplyMessageView *)createViewFrame:(CGRect)frame
+ (HKReplyMessageView *)createView{
    HKReplyMessageView * replyView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    //replyView.frame = frame;
    replyView.size = CGSizeMake(80, 40);
    return replyView;
}

@end
