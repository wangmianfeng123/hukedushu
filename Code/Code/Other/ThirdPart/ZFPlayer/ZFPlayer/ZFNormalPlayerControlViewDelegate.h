//
//  ZFNormalPlayerControlViewDelegate.h
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

#ifndef ZFNormalPlayerControlViewDelegate_h
#define ZFNormalPlayerControlViewDelegate_h


#endif /* ZFNormalPlayerControlViewDelegate_h */

@protocol ZFNormalPlayerControlViewDelagate <NSObject>

@optional
/** 返回按钮事件 */
- (void)zf_controlView:(UIView *)controlView backAction:(UIButton *)sender;
/** cell播放中小屏状态 关闭按钮事件 */
- (void)zf_controlView:(UIView *)controlView closeAction:(UIButton *)sender;
/** 播放按钮事件 */
- (void)zf_controlView:(UIView *)controlView playAction:(UIButton *)sender;
/** 全屏按钮事件 */
- (void)zf_controlView:(UIView *)controlView fullScreenAction:(UIButton *)sender;
/** 锁定屏幕方向按钮时间 */
- (void)zf_controlView:(UIView *)controlView lockScreenAction:(UIButton *)sender;
/** 重播按钮事件 */
- (void)zf_controlView:(UIView *)controlView repeatPlayAction:(UIButton *)sender;
/** 中间播放按钮事件 */
- (void)zf_controlView:(UIView *)controlView cneterPlayAction:(UIButton *)sender;
/** 加载失败按钮事件 */
- (void)zf_controlView:(UIView *)controlView failAction:(UIButton *)sender;
/** 下载按钮事件 */
- (void)zf_controlView:(UIView *)controlView downloadVideoAction:(UIButton *)sender;
/** 切换分辨率按钮事件 */
- (void)zf_controlView:(UIView *)controlView resolutionAction:(UIButton *)sender;
/** slider的点击事件（点击slider控制进度） */
- (void)zf_controlView:(UIView *)controlView progressSliderTap:(CGFloat)value;
/** 开始触摸slider */
- (void)zf_controlView:(UIView *)controlView progressSliderTouchBegan:(UISlider *)slider;
/** slider触摸中 */
- (void)zf_controlView:(UIView *)controlView progressSliderValueChanged:(UISlider *)slider;
/** slider触摸结束 */
- (void)zf_controlView:(UIView *)controlView progressSliderTouchEnded:(UISlider *)slider;
/** 控制层即将显示 */
- (void)zf_controlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen;
/** 控制层即将隐藏 */
- (void)zf_controlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen;


//------------ add ------------//

/** 购买VIP 跳转 */
- (void)zf_controlView:(UIView *)controlView buyVipAction:(UIButton *)sender;
/** 登录过期 登录提醒 */
- (void)zf_controlView:(UIView *)controlView loginAction:(UIButton *)sender;
/** 跳转下一视频 */
- (void)zf_controlView:(UIView *)controlView nextVideoAction:(id)sender;
/* 传值 --- 权限数据*/
- (void)zf_controlView:(UIView *)controlView permission:(id)sender;
/** 分享解锁视频 */
- (void)zf_controlView:(UIView *)controlView shareVideoAction:(id)sender;
/** 播放时间提示 下一节课程跳转 */
- (void)zf_controlView:(UIView *)controlView playTimeTipAction:(ZFNormalPlayerModel *)model;

/** 中心的图文按钮 */
- (void)zf_controlView:(UIView *)controlView picUrl:(NSString*)picUrl centerGraphicBtnClick:(UIButton *)sender;
/** 顶部触摸结束 */
- (void)zf_controlView:(UIView *)controlView picUrl:(NSString*)picUrl topGraphicBtnClick:(UIButton *)sender;

/** 举报视频 */
- (void)zf_controlView:(UIView *)controlView feedBack:(NSString*)feedBack;

@end
