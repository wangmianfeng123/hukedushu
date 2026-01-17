//
//  HKPlayerAutoPlayConfigView.h
//  Code
//
//  Created by Ivan li on 2018/9/6.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKPlayerAutoPlayConfigView;


@protocol HKPlayerAutoPlayConfigViewDelegate <NSObject>

@optional
- (void)removePlayerAutoPlayConfigView:(HKPlayerAutoPlayConfigView *)view;

- (void)playerRateConfigView:(HKPlayerAutoPlayConfigView *)view state:(NSInteger)state;

/** 举报视频 */
- (void)playerRateConfigView:(HKPlayerAutoPlayConfigView *)view feedBack:(NSString*)feedBack;

@end


@interface HKPlayerAutoPlayConfigView : UIView

@property(nonatomic,weak)id <HKPlayerAutoPlayConfigViewDelegate> delegate;

/** 销毁 */
- (void)removeView;

@end
