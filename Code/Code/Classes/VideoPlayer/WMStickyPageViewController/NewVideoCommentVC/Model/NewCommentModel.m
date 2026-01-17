//
//  NewCommentModel.m
//  Code
//
//  Created by Ivan li on 2017/10/30.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "NewCommentModel.h"
#import "NSString+MD5.h"


@implementation CommentChildModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"commentId" : @"id"};
}


@end



@implementation NewCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"commentId" : @"id"};
}


+ (NSDictionary *)mj_objectClassInArray {
    return @{@"children" : [CommentChildModel class],
             @"reply_list" : [CommentChildModel class]
    };
}




- (NSInteger)childrenCount {
    _childrenCount = self.children.count;
    return _childrenCount;
}




- (CGFloat)headViewHeight {
    
    if (_headViewHeight == 0) {
        CGFloat height = 0;
        height += 65;// 文本之上的距离
        _contentLBHeigth = [NSString heightWithStr:self.content spacing:PADDING_5 titleFont:HK_FONT_SYSTEM(14) width:(IS_IPAD ? iPadContentWidth : SCREEN_WIDTH) - 80];
        height += _contentLBHeigth;
        
        CGFloat margin = self.children.count ? PADDING_10 : 0;
        //CGFloat imgW = 0.8 * (SCREEN_WIDTH - PADDING_15 - 40 - 10 - 15 - 15) * 0.5;
        
        CGFloat imgW = 0.8 * ((IS_IPAD ? iPadContentWidth : SCREEN_WIDTH) - PADDING_15 - 40 - 10 - 15 - 15) * 0.5;

        height += self.pictures.count ?  imgW+PADDING_10 + margin : margin;
        _headViewHeight = height;
    }
    return _headViewHeight;
}

/*
NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
[paragraphStyle setLineSpacing:PADDING_5];
_contentLBHeigth = [self.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 80, CGFLOAT_MAX) options:1
                                           attributes:@{NSFontAttributeName : HK_FONT_SYSTEM(14),NSParagraphStyleAttributeName:paragraphStyle} context:nil].size.height;
 */


@end




@implementation NewCommentHeadModel

@end





