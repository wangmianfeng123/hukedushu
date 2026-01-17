//
//  HNewbieTaskView.h
//  Code
//
//  Created by yxma on 2020/11/10.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HNewbieTaskView : UIView
+ (HNewbieTaskView *)createView;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UIView *centerContentView;
@property (weak, nonatomic) IBOutlet UILabel *centerTxtLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (nonatomic, copy) void(^finishBtnBlock)(void);
@property (nonatomic, assign) int alertType; //1.新手任务第一步 5.新手任务第二步 6.新手任务第三步

@end

NS_ASSUME_NONNULL_END
