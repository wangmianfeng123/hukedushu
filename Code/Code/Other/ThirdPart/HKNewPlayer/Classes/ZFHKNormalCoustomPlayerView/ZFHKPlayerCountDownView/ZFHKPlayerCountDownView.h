//
//  ZFHKPlayerCountDownView.h
//  Code
//
//  Created by Ivan li on 2019/3/17.
//  Copyright © 2019年 pg. All rights reserved.
//


#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ZFHKPlayerCountDownViewType) {
    ZFHKPlayerCountDownViewType_Next = 0, // 播放下一节
    ZFHKPlayerCountDownViewType_End ,// 目录播完最后一节
};


@class ZFHKPlayerCountDownView,MZTimerLabel,ZFHKPlayerEndView;

@protocol ZFHKPlayerCountDownViewDelegate <NSObject>

//iskillTime -- yes   只是关闭定时器。 NO --  关闭定时器 并 跳转
- (void)playNextVideo:(id)sender iskillTime:(BOOL)iskillTime;

- (void)playNextVideo:(ZFHKPlayerCountDownView*)countDownView repeatBtn:(UIButton*)repeatBtn;

@end


@interface ZFHKPlayerCountDownView : UIView 

@property (nonatomic, strong)UIView *countdownBgView; //倒计时 背景

@property (nonatomic, strong)MZTimerLabel  *timeLabel; // 倒计时

@property (nonatomic, weak)id <ZFHKPlayerCountDownViewDelegate> delegate;

@property (nonatomic, strong) DetailModel          *detailModel;
/** 返回 */
@property (nonatomic, strong)UIButton *backBtn;
/** 重播 */
@property (nonatomic, strong)UIButton *repeatBtn;
/** 标题 */
@property (nonatomic,strong) UILabel *titleLabel;
/** 封面 */
@property (nonatomic,strong) UIImageView *iconImageView;
/** 立即观看 */
@property (nonatomic,strong) UIButton *lookNowBtn;
/** 下一节 */
@property (nonatomic,strong) UILabel *nextLabel;

@property(nonatomic,assign)ZFHKPlayerCountDownViewType viewType;

@property(nonatomic,copy)void(^backActionBlock)();

@property(nonatomic,assign) BOOL isFullScreen;

- (void)releaseTimeTipView;

///关闭 定时器
- (void)killTimer;

@end







@interface ZFHKPlayerEndView : UIView

@property (nonatomic, strong)UIView *countdownBgView; //倒计时 背景

//@property (nonatomic, weak)id <ZFHKPlayerEndViewDelegate> delegate;

@property (nonatomic, strong) DetailModel          *detailModel;
/** 返回 */
@property (nonatomic, strong)UIButton *backBtn;
/** 重播 */
@property (nonatomic, strong)UIButton *repeatBtn;
/** 标题 */
@property (nonatomic,strong) UILabel *titleLabel;
/** 封面 */
@property (nonatomic,strong) UIImageView *iconImageView;

@property (nonatomic,copy)void(^backActionBlock)();

@property (nonatomic,copy)void(^repeatActionBlock)(UIView *view);

@end
