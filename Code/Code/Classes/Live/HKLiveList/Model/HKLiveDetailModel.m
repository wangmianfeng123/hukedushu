//
//  HKLiveDetailModel.m
//  Code
//
//  Created by Ivan li on 2018/10/15.
//  Copyright © 2018年 pg. All rights reserved.1
//

#import "HKLiveDetailModel.h"
#import "HKGroupModel.h"
#import <YYText/YYText.h>


@implementation HKContentModel

+(NSDictionary*) mj_replacedKeyFromPropertyName {
    return @{@"content_id" : @"id"};
}


@end



@implementation HKLiveTeacherModel

+(NSDictionary*) mj_replacedKeyFromPropertyName {
    return @{@"teacher_id" : @"id"};
}


+ (NSDictionary *)mj_objectClassInArray {
    return @{@"im_group" : [HKGroupModel class]};
}


- (CGFloat)contentHeight {
    
    if (_contentHeight == 0) {
        
        CGSize size = CGSizeMake(SCREEN_WIDTH - 15 * 2.0, CGFLOAT_MAX);
       CGFloat height = [self.content boundingRectWithSize:size options:1 attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil].size.height + 0.5;
        _contentHeight = height;
    }
    return _contentHeight;
}

- (CGFloat)organization_name_height {
    
    if (_organization_name_height == 0) {
        
        CGSize size = CGSizeMake(SCREEN_WIDTH - 165, CGFLOAT_MAX);
        CGFloat height = [self.organization_name boundingRectWithSize:size options:1 attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0]} context:nil].size.height + 0.5;
       
        // 额外的高度
        if (height > 17) {
            height = height - 17;
        } else {
            height = 0.0;
        }
        _organization_name_height = height;
    }
    return _organization_name_height;
}

@end


@implementation HKLiveDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"series_courses" : [HKLiveCategoryModel class]};
}

- (CGFloat )courseNameHeight {
    
    if (_courseNameHeight == 0) {
        
        CGSize size = CGSizeMake(SCREEN_WIDTH - 15 * 2.0, CGFLOAT_MAX);
        
        // 空格前面为直播按钮
        NSString *practiceString = self.course.name;
        practiceString = [NSString stringWithFormat:@"          %@", practiceString];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:practiceString];;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:8];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium] range:NSMakeRange(0, practiceString.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0x27323F, 1.0) range:NSMakeRange(0, practiceString.length)];
        _courseNameHeight = [attributedString boundingRectWithSize:size options:1 context:nil].size.height + 0.5;
    }
    
    return _courseNameHeight;
}

@end

@implementation HKLiveCategoryModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"child" : [HKLiveDetailModel class]};
}


@end


@implementation HKLivedepositModel

@end



//
//

