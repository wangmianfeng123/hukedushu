//
//  HKNotesListModel.m
//  Code
//
//  Created by Ivan li on 2021/1/4.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKNotesListModel.h"

@implementation HKNotesListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"notes":[HKNotesModel class]
    };
}
@end


@implementation HKNotesModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"ID":@"id"
    };
}

-(CGFloat)imgH{
    if (_imgH == 0) {
        if (_screenshot.length) {
            _imgH = (SCREEN_WIDTH-50) * 365.0 / 650.0;
        }else{
            _imgH = 0.0;
        }
        return _imgH;
    }
    return _imgH;
}

- (CGFloat)contentHeight{
    if (_contentHeight == 0) {
        if (_notes.length) {
            NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc]initWithString:_notes];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyle setLineSpacing:5];
            [string1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,_notes.length)];
            NSInteger w = self.isPalyMenuNote ? 260 : SCREEN_WIDTH-40;
            CGFloat h = [self.notes boundingRectWithSize:CGSizeMake(w, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:paragraphStyle} context:nil].size.height + 5;
//            CGFloat h = [self.notes boundingRectWithSize:CGSizeMake(w, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size.height;
            return h;
        }else{
            return 0.0;
        }
    }
    return _contentHeight;
}

@end


@implementation HKNotesVideoModel

@end
