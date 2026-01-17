//
//  HKLiveAddGroupAlertVC.h
//  Code
//
//  Created by Ivan li on 2018/12/10.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@interface HKLiveAddGroupAlertVC : HKBaseVC


@property(nonatomic,copy)void(^liveAddGroupAlertVCBlock)(HKLiveAddGroupAlertVC *sender);

/** 销毁 控制器 */
- (void)closeView;

@end


