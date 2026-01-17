//
//  ZFHKNormalPlayerMoreSettingView.h
//  Code
//
//  Created by Ivan li on 2019/3/13.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZFHKNormalPlayerMoreSettingView;

@protocol ZFHKNormalPlayerMoreSettingViewDelegate <NSObject>

@optional

/** 播放速率 */
- (void)zfHKNormalPlayerMoreSettingView:(ZFHKNormalPlayerMoreSettingView*)view state:(NSInteger)state;
/** 举报视频 */
- (void)zfHKNormalPlayerMoreSettingView:(ZFHKNormalPlayerMoreSettingView*)view feedBack:(NSString*)feedBack;
/** 七牛线路 */
- (void)zfHKNormalPlayerMoreSettingView:(ZFHKNormalPlayerMoreSettingView*)view qiniuLineBtn:(UIButton*)qiniuLineBtn;
/** 腾讯线路 */
- (void)zfHKNormalPlayerMoreSettingView:(ZFHKNormalPlayerMoreSettingView*)view txLineBtn:(UIButton*)txLineBtn;

@end



@interface ZFHKNormalPlayerMoreSettingView : UIView

@property(nonatomic,weak)id <ZFHKNormalPlayerMoreSettingViewDelegate> delegate;

/** 销毁 */
- (void)removeSubviews;

/// 隐藏线路
- (void)hiddenChangeLine;

@end


NS_ASSUME_NONNULL_END


