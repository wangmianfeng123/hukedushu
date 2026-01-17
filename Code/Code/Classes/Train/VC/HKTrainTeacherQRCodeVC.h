//
//  HKTrainTeacherQRCodeVC.h
//  Code
//
//  Created by hanchuangkeji on 2019/1/23.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@class HKTrainDetailInfoModel;

@interface HKTrainTeacherQRCodeVC : HKBaseVC

@property (nonatomic, copy)NSString *qrCodeURL;
@property (nonatomic, copy)NSString *teacher_weixin;

@property (nonatomic, strong)HKTrainDetailInfoModel *infoModel;



@end

NS_ASSUME_NONNULL_END
