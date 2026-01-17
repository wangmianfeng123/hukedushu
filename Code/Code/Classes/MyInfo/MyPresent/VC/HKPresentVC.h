//
//  HKPresentVC.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/8.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@interface HKPresentVC : HKBaseVC

//签到回调
@property(nonatomic,copy)void (^hkPresentResultCallback)(BOOL isSign);

@end


@interface HMMallDataModel : NSObject
@property (nonatomic, assign)BOOL is_show;
@property (nonatomic, copy)NSString *url;
@end
