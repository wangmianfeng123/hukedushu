//
//  ZFHKNormalPlayerCourseListView.h
//  Code
//
//  Created by Ivan li on 2021/4/1.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFHKNormalPlayerCourseListView : UIView
@property (nonatomic, strong)NSMutableArray<HKCourseModel *> *dataSource;
@property (nonatomic , strong) NSIndexPath * index;
@property (nonatomic , strong)DetailModel * videlDetailModel;
@property (nonatomic , strong) void(^didCourseBlock)(NSString * changeCourseId,NSString * sectionId,NSString * frontCourseId);

@end

NS_ASSUME_NONNULL_END
