//
//  HKMomentDetailVC.h
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class HKMomentDetailModel;

@interface HKMomentDetailVC : HKBaseVC

@property (nonatomic, copy)NSString * topic_id;  //
@property (nonatomic, copy)NSString * connect_type;  //
@property (nonatomic , strong) void(^didAttentionBlock)(HKMomentDetailModel * model);
@property (nonatomic , strong) void(^didLikeBlock)(HKMomentDetailModel * model);
@property (nonatomic , strong) void(^didDeleteBlock)(HKMomentDetailModel * model);

@end

NS_ASSUME_NONNULL_END
