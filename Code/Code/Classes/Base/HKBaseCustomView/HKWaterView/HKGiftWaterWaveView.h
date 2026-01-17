//
//  HKGiftWaterWaveView.h
//  Code
//
//  Created by Ivan li on 2018/8/3.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HKGiftWaterWaveView : UIView


- (id)initWithFrame:(CGRect)frame type:(waveType)type;
/**
 *  The speed of wave 波浪的快慢
 */
@property (nonatomic,assign)CGFloat waveSpeed;

/**
 *  The amplitude of wave 波浪的震荡幅度
 */
@property (nonatomic,assign)CGFloat waveAmplitude; // 波浪的震荡幅度

/**
 *  Start waving
 */
- (void)waveWithColor:(UIColor *)waveColor;

/**
 *  Stop waving
 */
- (void)stop;

@end






