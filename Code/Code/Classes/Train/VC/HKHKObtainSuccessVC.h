//
//  HKHKObtainSuccessVC.h
//  Code
//
//  Created by yxma on 2020/11/10.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKBaseVC.h"
#import "DetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKHKObtainSuccessVC : HKBaseVC

@property (nonatomic, copy)NSString * teacher_qrcode;
@property (nonatomic, copy)NSString * start;
@property (nonatomic , strong) ShareModel * shareM;
@end

NS_ASSUME_NONNULL_END
