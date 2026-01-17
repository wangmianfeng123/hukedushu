//
//  HKRankVC.h
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class HKMonmentTagModel,HKSubjectInfoModel;

@interface HKRankVC : HKBaseVC
//@property (nonatomic , strong) HKMonmentTagModel * tagModel;//排序的model
//@property (nonatomic , strong) HKMonmentTagModel * topicModel;//话题的model
//@property (nonatomic , strong) void(^topicDataBlock)(HKSubjectInfoModel * info);
@property (nonatomic , strong) HKSubjectInfoModel * InfoModel;

@property (nonatomic , strong) void(^pushPostBlock)(void);
@property (nonatomic, copy) NSString * subjectId;  //话题ID
@property (nonatomic, copy)NSString *  orderById;  //排序ID
@end

NS_ASSUME_NONNULL_END
