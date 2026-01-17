//
//  HKLiveCoverIV.h
//  Code
//
//  Created by Ivan li on 2018/12/6.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCoverBaseLiveIV.h"

@class HKImageTextIV;

@interface HKLiveCoverIV : HKCoverBaseLiveIV

@property (nonatomic, strong) HKImageTextIV *animationIV;
/** 直播状态 说明 */
@property(nonatomic,copy)NSString *status;
/** 直播状态 */
@property(nonatomic,assign)HKLiveType liveType;

@end
