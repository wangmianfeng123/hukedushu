//
//  HKAttentionRefreshCell.m
//  Code
//
//  Created by Ivan li on 2021/1/29.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKAttentionRefreshCell.h"

@implementation HKAttentionRefreshCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.refreshBtn setTitleColor:COLOR_A8ABBE_7B8196 forState:UIControlStateNormal];
    [self.refreshBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:5];
}
@end
