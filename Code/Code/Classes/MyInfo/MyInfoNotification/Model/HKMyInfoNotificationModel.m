//
//  HKMyInfoNotificationModel.m
//  Code
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKMyInfoNotificationModel.h"
#import <YYText/YYText.h>

@implementation HKMyInfoNotificationModel

- (CGFloat)cellHeight {
    if (_cellHeight == 0) {
        
        // 富文本content
        NSString *contentString = [NSString stringWithFormat:@"%@回复你：\n%@", _username, _content];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setParagraphSpacing:8];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0x7B8196, 1.0) range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrString.length)];
        
        [attrString addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0x27323F, 1.0) range:NSMakeRange(0, contentString.length - _content.length)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, contentString.length - _content.length)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 weight:UIFontWeightBold] range:NSMakeRange(0, _username.length)];
        
        CGSize size = CGSizeMake(UIScreenWidth - 12 - 8 - 4 - 45 - 15 - 92, CGFLOAT_MAX);
        
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:attrString];

        _contentLBHeigth = layout.textBoundingSize.height + 0.5 + 8;
        _cellHeight = 15 + _contentLBHeigth + 10 + 12 + 13;
        CGFloat minHeight =  15 + 45 + 12 + 13;
        _cellHeight = _cellHeight > minHeight ? _cellHeight : minHeight;
    }
    return _cellHeight;
}



- (NSString *)created_at_string {
    
    if (_created_at_string == nil) {
        //获取系统当前时间
        NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:self.created_at];
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



@end
