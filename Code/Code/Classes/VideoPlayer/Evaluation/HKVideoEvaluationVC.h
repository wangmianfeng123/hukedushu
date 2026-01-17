//
//  HKVideoEvaluationVC.h
//  Code
//
//  Created by eon Z on 2021/9/2.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HKVideoEvaluationVCDelegate <NSObject>

@optional
- (void)videoEvaluationSucess;

@end

@interface HKVideoEvaluationVC : HKBaseVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  videoId:(NSString*)videoId;
@property(nonatomic,weak)id <HKVideoEvaluationVCDelegate>delegate;
//@property (nonatomic , assign) BOOL isFromLiveVC ;
@property (nonatomic , strong) void(^refreshDataBlock)(void);

@end

NS_ASSUME_NONNULL_END
