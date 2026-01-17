//
//  HKSoftwareAchieveVC.h
//  Code
//
//  Created by Ivan li on 2018/4/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"


typedef void(^RemoveVCAndPushOtherVCBlcok)(NSMutableArray* array, NSString *softwareName);

@interface HKSoftwareAchieveVC : HKBaseVC
/** 销毁 VC 跳转 新VC */
@property(nonatomic,copy)RemoveVCAndPushOtherVCBlcok removeVCBlcok;

@property(nonatomic,strong)DetailModel  *model;

@property(nonatomic,strong)NSMutableArray *dataArr;

@end







