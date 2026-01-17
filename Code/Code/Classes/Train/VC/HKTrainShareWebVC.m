//
//  HKTrainShareWebVC.m
//  Code
//
//  Created by hanchuangkeji on 2019/1/23.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKTrainShareWebVC.h"
#import "UMpopView.h"

@interface HKTrainShareWebVC () <UMpopViewDelegate>

@end

@implementation HKTrainShareWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 右上角的分享
    [self createShareButtonItem];
    [self setLeftBarButtonItems];
}

- (void)setLeftBarButtonItems {
    [self createLeftBarButton];
}

- (void)shareBtnItemAction {
    
    if (self.shareData) {
        [self shareWithUI:self.shareData];
    }
}


/** 友盟分享 */
- (void)shareWithUI:(ShareModel *)model {
    UMpopView *popView = [UMpopView sharedInstance];
    popView.delegate = self;
    [popView createUIWithModel:model];
}

@end
