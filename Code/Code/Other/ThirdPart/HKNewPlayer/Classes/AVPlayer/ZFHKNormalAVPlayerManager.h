//
//  ZFHKNormalAVPlayerManager.h
//  ZFHKNormalPlayer
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

#import <Foundation/Foundation.h>
#import "ZFHKNormalPlayerMediaPlayback.h"

@interface ZFHKNormalAVPlayerManager : NSObject <ZFHKNormalPlayerMediaPlayback>

/** Yes GPRS 流量播放 受限 (普通会员视频)   */
@property (nonatomic,assign)BOOL  isNoGPRSPlayVideo;

/** Yes GPRS 流量播放 受限  (短视频)  */
@property (nonatomic,assign)BOOL  isNoGPRSPlayShortVideo;

/** Yes 播放开始暂停 读书，NO 不暂停  */
@property (nonatomic,assign)BOOL  isPauseHkAudio;

@property (nonatomic, assign) NSTimeInterval timeRefreshInterval;
//- (UIImage *)thumbnailImageAtCurrentTime;
@end


