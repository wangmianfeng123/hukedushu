//
//  HKTaskModel.m
//  Code
//
//  Created by Ivan li on 2018/7/12.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTaskModel.h"



@implementation HKTaskCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"comment_id" : @"id"};
}

//
//- (void)setContent:(NSString *)content {
//    _content = content;
//    [self headViewHeight];
//}
//
//- (CGFloat)headViewHeight {
//    
//    if (_headViewHeight == 0) {
//        CGFloat height = 0;
//        
//        NSString *contentString = [NSString stringWithFormat:@"%@: %@", self.username, self.content];
//        
//        height = [CommonFunction getTextHeight:contentString font:HK_FONT_SYSTEM(14) lineSpacing:3 width:SCREEN_WIDTH -65-45];
//        if (height>0) {
//            height += 8;
//        }
//        _headViewHeight = height;
//    }
//    return _headViewHeight;
//}

@end




@implementation HKTaskModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"comment" : [HKTaskCommentModel class],   @"reply_list" : [HKTaskCommentModel class], @"list" : [HKTaskModel class]};
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end



@implementation HKTaskDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"comment_list" : [HKTaskModel class]};
}

@end






