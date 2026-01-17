//
//  ZFNormalPlayerControlView.h
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "ASValueTrackingSlider.h"
#import "ZFNormalPlayer.h"
#import <MZTimerLabel/MZTimerLabel.h>
#import "HKDownloadModel.h"

@class DetailModel,HKPlayerBuyVipView;



@interface ZFNormalPlayerControlView : UIView

/** 全屏按钮 */
@property (nonatomic, strong) UIButton              *fullScreenBtn;
/** 开始播放按钮 */
@property (nonatomic, strong) UIButton              *startBtn;
// add 0903
@property (nonatomic, strong) UILabel               *lookCountTipLabel; //提示无会员。观看一个视频

@property (nonatomic, strong) UIButton              *bottomVipBtn;

@property (nonatomic, strong) HKPlayerBuyVipView        *buyVipBgView;

@property (nonatomic, copy) NSString              *videoId; //视频 ID

@property (nonatomic, assign) int                 videoType; //视频type

@property (nonatomic, copy) NSString              *videoUrl; //视频 URL

@property (nonatomic, strong) MZTimerLabel         *watchLabel; //计时器

@property (nonatomic, strong) DetailModel          *detailModel;

@property (atomic, assign)HKDownloadStatus videoStatus; //视频下载状态
/** 图文按钮 */
@property (nonatomic, strong) UIButton             *centerGraphicBtn;
/** 顶部 图文按钮 */
@property (nonatomic, strong) UIButton             *topGraphicBtn;




#pragma mark - 移除 lookCountTipLabel
- (void)hiddenLookCountTipLabel;

#pragma mark - 移除购买VIP
- (void)removeBuyVipView;

- (void)playBtnClick:(UIButton *)sender;

- (void)fullScreenBtnClick:(UIButton *)sender;

- (void)zf_playerShowTopGraphicBtn;
/** 创建 无观看权限 提示购买VIP 视图 */
- (void)setBuyVipView;

@end
