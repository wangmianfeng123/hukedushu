//
//  ZFHKNormalPlayerNotification.m
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

#import "ZFHKNormalPlayerNotification.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import "LBLelinkKitManager.h"
//#import <CallKit/CXCallObserver.h>
//#import <CallKit/CXCall.h>

@interface ZFHKNormalPlayerNotification ()//<CXCallObserverDelegate>

@property (nonatomic, assign) ZFHKNormalPlayerBackgroundState backgroundState;
//@property(nonatomic, strong) CXCallObserver *callCenter;
@end

@implementation ZFHKNormalPlayerNotification

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioSessionRouteChangeNotification:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActiveNotification)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    //进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActiveNotification)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeDidChangeNotification:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioSessionInterruptionNotification:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:nil];
//    self.callCenter = [CXCallObserver new];
//    [self.callCenter setDelegate:self queue:dispatch_get_main_queue()];
    
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];
}

- (void)dealloc {
    [self removeNotification];
}

- (void)audioSessionRouteChangeNotification:(NSNotification*)notifi {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *interuptionDict = notifi.userInfo;
        NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
        switch (routeChangeReason) {
            case AVAudioSessionRouteChangeReasonNewDeviceAvailable: {
                if (self.newDeviceAvailable) self.newDeviceAvailable(self);
            }
                break;
            case AVAudioSessionRouteChangeReasonOldDeviceUnavailable: {
                if (self.oldDeviceUnavailable) self.oldDeviceUnavailable(self);
            }
                break;
            case AVAudioSessionRouteChangeReasonCategoryChange: {
                if (self.categoryChange) self.categoryChange(self);
            }
                break;
        }
    });
}

- (void)volumeDidChangeNotification:(NSNotification *)notification {
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    if (self.volumeChanged) self.volumeChanged(volume);
}

- (void)applicationWillResignActiveNotification {
    self.backgroundState = ZFHKNormalPlayerBackgroundStateBackground;
    
    if ([LBLelinkKitManager sharedManager].isAirPlay &&
        ![LBLelinkKitManager sharedManager].isMirroring) return;

    if (_willResignActive) _willResignActive(self);
}

- (void)applicationDidBecomeActiveNotification {
    self.backgroundState = ZFHKNormalPlayerBackgroundStateForeground;
    if ([LBLelinkKitManager sharedManager].isAirPlay &&
        ![LBLelinkKitManager sharedManager].isMirroring) return;
    if (_didBecomeActive) _didBecomeActive(self);
}

- (void)audioSessionInterruptionNotification:(NSNotification *)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    AVAudioSessionInterruptionType interruptionType = [[interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey] integerValue];
    if (self.audioInterruptionCallback) self.audioInterruptionCallback(interruptionType);
}

//MARK: CXCallObserverDelegate
//- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call {
//    NSLog(@"outgoing :%d  onHold :%d   hasConnected :%d   hasEnded :%d",call.outgoing,call.onHold,call.hasConnected,call.hasEnded);
//    if (call.outgoing == 0 && call.onHold == 0) {
//        self.backgroundState = ZFHKNormalPlayerBackgroundStateBackground;
//        if (_willResignActive) _willResignActive(self);
//    }
//
//    /*
//     拨打:  outgoing :1  onHold :0   hasConnected :0   hasEnded :0
//     拒绝:  outgoing :1  onHold :0   hasConnected :0   hasEnded :1
//     链接:  outgoing :1  onHold :0   hasConnected :1   hasEnded :0
//     挂断:  outgoing :1  onHold :0   hasConnected :1   hasEnded :1
//     对方未接听时挂断：  outgoing :1  onHold :0   hasConnected :0   hasEnded :1
//
//     新来电话:    outgoing :0  onHold :0   hasConnected :0   hasEnded :0
//     保留并接听:  outgoing :1  onHold :1   hasConnected :1   hasEnded :0
//     另一个挂掉:  outgoing :0  onHold :0   hasConnected :1   hasEnded :0
//     保持链接:    outgoing :1  onHold :0   hasConnected :1   hasEnded :1
//     对方挂掉:    outgoing :0  onHold :0   hasConnected :1   hasEnded :1
//     */
//}

@end
