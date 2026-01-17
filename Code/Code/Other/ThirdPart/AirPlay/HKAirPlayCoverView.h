//
//  HKAirPlayCoverView.h
//  Code
//
//  Created by Ivan li on 2019/4/28.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKAirPlayCoverView;

@protocol HKAirPlayCoverViewDelegate <NSObject>

- (void)hKAirPlayCoverView:(HKAirPlayCoverView*)airPlayCoverView quitBtn:(UIButton*)quitBtn;

- (void)hKAirPlayCoverView:(HKAirPlayCoverView*)airPlayCoverView changeDeviceBtn:(UIButton*)changeDeviceBtn;

- (void)hKAirPlayCoverView:(HKAirPlayCoverView*)airPlayCoverView backBtn:(UIButton*)backBtn;

- (void)hKAirPlayCoverView:(HKAirPlayCoverView*)airPlayCoverView repeatBtn:(UIButton*)repeatBtn;

@end



@interface HKAirPlayCoverView : UIView

@property(nonatomic,weak)id <HKAirPlayCoverViewDelegate> delegate;

@property(nonatomic,assign)BOOL isFullScreen;

@property(nonatomic,assign)BOOL isPickSucess;

@property(nonatomic,assign)BOOL isDownFinish;

@property (nonatomic,strong) UIButton *quitBtn;

@property (nonatomic,strong) UIButton *changeDeviceBtn;

/**
 改变连接状态文本

 @param text
 */
- (void)changeStateWithText:(NSString*)text;


/**
  连接的设备名称

 @param text
 */
- (void)setPortNameWithText:(NSString*)text;



/**
 设置标题

 @param text 标题
 */
- (void)setTitleWithText:(NSString*)text;

@end

NS_ASSUME_NONNULL_END
