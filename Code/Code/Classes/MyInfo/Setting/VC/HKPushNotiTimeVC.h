//
//  HKPushNotiTimeVC.h
//  Code
//
//  Created by eon Z on 2022/2/10.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKBaseVC.h"
#import "HKPushNotiCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKPushNotiTimeVC : HKBaseVC
@property (nonatomic ,copy) NSString * key;
@property (nonatomic, strong)NSNumber * j_push_hour;
@property (nonatomic, strong)NSNumber * j_push_hour_type;
@property (nonatomic, strong)NSNumber * j_push_type;




@end

NS_ASSUME_NONNULL_END
