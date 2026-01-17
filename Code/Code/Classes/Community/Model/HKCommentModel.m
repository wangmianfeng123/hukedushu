//
//  HKCommentModel.m
//  Code
//
//  Created by Ivan li on 2021/1/26.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKCommentModel.h"
#import "NSString+MD5.h"

@implementation HKCommentModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"subs":[HKCommentModel class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}


- (CGFloat)headViewHeight {
    
    if (_headViewHeight == 0) {
        CGFloat height = 0;
        height += 65;// 文本之上的距离
        _contentLBHeigth = [NSString heightWithStr:self.content spacing:PADDING_5 titleFont:HK_FONT_SYSTEM(14) width:SCREEN_WIDTH - 80];
        
//        _contentLBHeigth = [CommonFunction getTextHeight:self.content font:HK_FONT_SYSTEM(14) lineSpacing:PADDING_5 width:SCREEN_WIDTH - 80];

        height += _contentLBHeigth;
        height += PADDING_10;
        _headViewHeight = height;
    }
    return _headViewHeight;
}

@end
