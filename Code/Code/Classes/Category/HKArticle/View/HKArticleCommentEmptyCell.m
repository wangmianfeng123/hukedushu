//
//  HKArticleCommentEmptyCell.m
//  Code
//
//  Created by hanchuangkeji on 2018/8/10.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKArticleCommentEmptyCell.h"

@implementation HKArticleCommentEmptyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
