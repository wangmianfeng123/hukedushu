//
//  HKPresentHeader21.h
//  Code
//
//  Created by hanchuangkeji on 2018/6/14.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKPresentHeaderModel.h"


@protocol HKPresentHeader21Delegate<NSObject>

@optional
- (void)finishPresenBtnClcik:(HKPresentHeaderModel *)model;

@end

@interface HKPresentHeader21 : UIView

@property (weak, nonatomic) IBOutlet UIButton *hkStoreBtn;

@property (nonatomic, strong)HKPresentHeaderModel *model;

@property (nonatomic, weak)id<HKPresentHeader21Delegate> delegate;

@property (nonatomic, copy)void(^btnStoreClickBlock)();

@property (nonatomic, copy)void(^switchClickBlock)(BOOL isOn);

@property (nonatomic, copy)void(^setBtnBlock)(void);

@property (nonatomic, copy)void(^continueDaysViewTapBlock)();

@property (nonatomic, copy)void(^medalBtnClickBlock)();


@end
