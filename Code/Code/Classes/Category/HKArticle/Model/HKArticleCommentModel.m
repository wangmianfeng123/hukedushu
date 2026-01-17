//
//  HKArticleModel.m
//  Code
//
//  Created by hanchuangkeji on 2018/8/3.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKArticleCommentModel.h"

@implementation HKArticleCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID" : @"id", @"name" : @"username", @"timeString" : @"created_at",  @"vipType" : @"user.vip_type"};
    
}

- (NSString *)ID {
    if (!_ID.length) {
        _ID = _comment_id;
    }
    return _ID;
}

- (NSString *)comment_id {
    if (!_comment_id.length) {
        _comment_id = _ID;
    }
    return _comment_id;
}


- (CGFloat)cellHeight {
    
    if (_cellHeight == 0) {
        CGFloat cellHeightTemp = 50.0 + 45.0;
        CGFloat contentHeight = [self.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 68 - 15, CGFLOAT_MAX) options:1 attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil].size.height + 0.5;
        cellHeightTemp += contentHeight;
        _cellHeight = cellHeightTemp;
    }
    return _cellHeight;
}

@end


@implementation HKArticleRelactionModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID" : @"id", @"user_header" : @"avator", @"avator" : @"cover_pic",  @"isExclusive" : @"is_exclusive",  @"likeCount" : @"appreciate_num",  @"readCount" : @"show_num", @"user_name" : @"name"};
    
}

@end
