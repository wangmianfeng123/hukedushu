//
//  HKNextVideoCountDownView.h
//  Code
//
//  Created by Ivan li on 2017/12/12.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HKNextVideoCountDownViewDelegate <NSObject>

//iskillTime -- yes   只是关闭定时器。 NO --  关闭定时器 并 跳转
- (void)playNextVideo:(id)sender iskillTime:(BOOL)iskillTime;

@end

@class MZTimerLabel;

@interface HKNextVideoCountDownView : UIView

@property (nonatomic, strong)UIView *countdownBgView; //倒计时 背景

@property (nonatomic, strong)UILabel *tipLabel; //倒计时 文案提示

@property (nonatomic, strong)MZTimerLabel  *timeLabel; // 倒计时

@property (nonatomic, strong)UIButton *quitBtn; // 取消按钮

@property (nonatomic, weak)id <HKNextVideoCountDownViewDelegate> delegate;

@property (nonatomic, strong) DetailModel          *detailModel;


- (void)releaseTimeTipView;


@end
