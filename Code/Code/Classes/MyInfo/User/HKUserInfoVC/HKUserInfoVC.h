//
//  HKUserInfoVC.h
//  Code
//
//  Created by Ivan li on 2018/5/16.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "WMStickyPageControllerTool.h"


@interface HKUserInfoVC : WMStickyPageControllerTool<WMStickyPageControllerDelegate>

@property (nonatomic, copy)NSString *userId;


@property (nonatomic, copy)void(^userVCDeallocBlock)();


@end
