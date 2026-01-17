//
//  HKTrainItemModel.m
//  Code
//
//  Created by hanchuangkeji on 2019/1/21.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKTrainItemModel.h"

@implementation HKTrainItemModel

@end


@implementation HKTrainItemMyWorkModel

@end


@implementation HKTrainItemTodayCourseModel

@end


@implementation HKTrainItemtTaskRecordsModel

+(NSDictionary *)mj_objectClassInArray {
    
    return @{@"list" : [HKTrainItemtTaskRecordsItemModel class]};
}



@end


@implementation HKTrainItemtTaskRecordsItemModel

//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{@"id" : @"ID"};
//}22333444

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}


- (UIImageView *)imageViewTemp {
    if (_imageViewTemp == nil) {
        _imageViewTemp = [[UIImageView alloc] init];
    }
    return _imageViewTemp;
}

- (CGFloat)imageWidth {
    
    if (_imageWidth == 0) {
        return 110;
    } else {
        return _imageWidth;
    }
}

- (CGFloat)imageHeight {
    if (_imageHeight == 0) {
        return 110;
    } else {
        return _imageHeight;
    }
}

- (CGFloat)taskDescHeight {
    if (_taskDescHeight == 0) {
        CGFloat height = [self.task_desc boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15 - 15 - 10 - 40 , CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil].size.height + 0.5;
        _taskDescHeight = height;
    }
    return _taskDescHeight;
}

@end
