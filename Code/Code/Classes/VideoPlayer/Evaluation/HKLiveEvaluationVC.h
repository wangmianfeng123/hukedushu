//
//  HKLiveEvaluationVC.h
//  Code
//
//  Created by eon Z on 2021/9/2.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HKLiveEvaluationVCDelegate <NSObject>

@optional
- (void)liveEvaluationSucess;
@end

@interface HKLiveEvaluationVC : HKBaseVC
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  videoId:(NSString*)videoId;

@property(nonatomic,weak)id <HKLiveEvaluationVCDelegate>delegate;
@property (nonatomic , strong) void(^refreshDataBlock)(void);
@end

NS_ASSUME_NONNULL_END
