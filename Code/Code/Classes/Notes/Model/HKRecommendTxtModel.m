//
//  HKRecommendTxtModel.m
//  Code
//
//  Created by Ivan li on 2021/4/6.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKRecommendTxtModel.h"



@implementation HKRecommendTxtModel

//-(NSString *)content{
//    _content = @"士大夫大丰收大幅度发个是的是的地方撒打算放发撒打算放是的方式打发顺丰是的舒服大声道f士大夫大丰收大幅度发个是的是的地方撒打算放发撒打算放是的方式打发顺丰是的舒服大声道f士大夫大丰收大幅度发个是的是的地方撒打算放发撒打算放是的方式打发顺丰是的舒服大声道f士大夫大丰收大幅度发个是的是的地方撒打算放发撒打算放是的方式打发顺丰是的舒服大声道f士大夫大丰收大幅度发个是的是的地方撒打算放发撒打算放是的方式打发顺丰是的舒服大声道f士大夫大丰收大幅度发个是的是的地方撒打算放发撒打算放是的方式打发顺丰是的舒服大声道f士大夫大丰收大幅度发个是的是的地方撒打算放发撒打算放是的方式打发顺丰是的舒服大声道f士大夫大丰收大幅度发个是的是的地方撒打算放发撒打算放是的方式打发顺丰是的舒服大声道f士大夫大丰收大幅度发个是的是的地方撒打算放发撒打算放是的方式打发顺丰是的舒服大声道f";
//    return _content;
//}

- (CGFloat)cellHeight{
    if (_cellHeight == 0) {
        CGFloat contentH = 0;
        if (_content.length) {
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:self.content];
            NSMutableParagraphStyle * para = [[NSMutableParagraphStyle alloc] init];
            [para setLineSpacing:3];
            [attr addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0, self.content.length)];
            CGFloat w = (SCREEN_WIDTH- 20) * 0.5 - 7 * 2 - 6 * 2;
            contentH = [self.content boundingRectWithSize:CGSizeMake(w, 200) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:para} context:nil].size.height;
            contentH = contentH > 120 ? 120 : contentH;
        }
        _cellHeight = (SCREEN_WIDTH- 20 -24) * 0.5 * 102.0 /167.0 + 10 + 20 + 2 + 15 + 10 + contentH + 10 + 20 + 5 + 12;
    }
    return _cellHeight;
}

@end
