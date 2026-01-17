//
//  HKDetailRecommandView.h
//  Code
//
//  Created by Ivan li on 2021/5/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKDetailRecommandView : UIView
//@property (nonatomic , strong) NSArray * dataArray;

@property (nonatomic , strong) void(^moreClickBlock)(void);

@property (nonatomic , strong) void(^cellClickBlock)(HKCourseModel * model);
@property (nonatomic,strong)DetailModel *detaiModel;
//@property (nonatomic, strong)NSMutableArray<HKCourseModel *> *dataSource;//目录数组
@property (nonatomic , strong) NSMutableArray * dataArray;

@end

NS_ASSUME_NONNULL_END
