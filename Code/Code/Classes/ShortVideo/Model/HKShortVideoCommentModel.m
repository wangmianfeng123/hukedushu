//
//  HKShortVideoCommentModel.m
//  Code
//
//  Created by hanchuangkeji on 2019/5/13.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKShortVideoCommentModel.h"
#import <YYText/YYText.h>

@implementation HKShortVideoCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"newComment" : [HKShortVideoCommentModel class], @"comment" : [HKShortVideoCommentModel class]};
}

- (NSMutableArray<HKShortVideoCommentModel *> *)newComment {
    if (_newComment == nil) {
        _newComment = [NSMutableArray array];
    }
    return _newComment;
}

- (NSString *)created_at_string {
    
    if (_created_at_string == nil) {
        //获取系统当前时间
        NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:self.created_at.intValue];
        //用于格式化NSDate对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设置格式
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        //NSDate转NSString
        NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
        _created_at_string = currentDateString;
    }
    return _created_at_string;
}

- (BOOL)is_reply {
    BOOL reply = NO;
    if (self.root_id.intValue > 0 || self.parent_id.intValue > 0) {
        reply = YES;
    }
    return reply;
}

- (CGFloat)cellHeight {
    if (_cellHeight == 0) {
        
        // 富文本content
        NSString *replyOrCommentString = self.is_reply? @"回复" : @"评论";
        NSString *replyOrCommentName = self.is_reply? self.commentUser.username : self.parentCommentUser.username;
        NSString *contentString = [NSString stringWithFormat:@"%@%@你：\n%@", replyOrCommentName, replyOrCommentString, self.content];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setParagraphSpacing:8];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0x7B8196, 1.0) range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
        
        [attrString addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0x27323F, 1.0) range:NSMakeRange(0, contentString.length - _content.length)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, contentString.length - self.content.length)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 weight:UIFontWeightBold] range:NSMakeRange(0, replyOrCommentName.length)];
        
        CGSize size = CGSizeMake(UIScreenWidth - 12 - 8 - 4 - 45 - 15 - 92, CGFLOAT_MAX);
        
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:attrString];
        
        _contentLBHeigth = layout.textBoundingSize.height + 0.5 + 8;
        _cellHeight = 15 + _contentLBHeigth + 10 + 12 + 13;
        CGFloat minHeight =  15 + 45 + 12 + 13;
        _cellHeight = _cellHeight > minHeight ? _cellHeight : minHeight;
    }
    return _cellHeight;
}



@end
