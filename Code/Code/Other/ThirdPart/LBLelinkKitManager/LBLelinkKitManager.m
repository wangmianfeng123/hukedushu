//
//  LBLelinkKitManager.m
//  LBLelinkKitSample
//
//  Created by 刘明星 on 2018/8/21.
//  Copyright © 2018 深圳乐播科技有限公司. All rights reserved.
//

#import "LBLelinkKitManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>


/** 服务变化通知 */
NSString * const LBLelinkKitManagerServiceDidChangeNotification = @"LBLelinkKitManagerServiceDidChangeNotification";

/** 连接和断开连接通知 */
NSString * const LBLelinkKitManagerConnectionDidConnectedNotification = @"LBLelinkKitManagerConnectionDidConnectedNotification";
NSString * const LBLelinkKitManagerConnectionDisConnectedNotification = @"LBLelinkKitManagerConnectionDisConnectedNotification";

/** 播放状态相关通知 */
NSString * const LBLelinkKitManagerPlayerStatusNotification = @"LBLelinkKitManagerPlayerStatusNotification";
NSString * const LBLelinkKitManagerPlayerProgressNotification = @"LBLelinkKitManagerPlayerProgressNotification";
NSString * const LBLelinkKitManagerPlayerErrorNotification = @"LBLelinkKitManagerPlayerErrorNotification";

@interface LBLelinkKitManager ()<LBLelinkBrowserDelegate, LBLelinkConnectionDelegate, LBLelinkPlayerDelegate>

@property (nonatomic, strong) LBLelinkBrowser *lelinkBrowser;

@property (nonatomic, assign) LBLelinkPlayStatus currentPlayStatus;


@end

@implementation LBLelinkKitManager


+ (instancetype)sharedManager {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        [_sharedInstance addNotification];
    });
    return _sharedInstance;
}


#pragma mark - API
- (void)addNotification {
    // 网络监测
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkNotification:)
                                                 name:KNetworkStatusNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeViewWirelessRouteActiveDidChangeNotification:)
                                                 name:MPVolumeViewWirelessRouteActiveDidChangeNotification
                                               object:nil];
}

- (void)networkNotification:(NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    switch ([HkNetworkManageCenter shareInstance].networkStatus) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable :
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {   // 无网络
            
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:{
            
        }
            break;
            
        default:
            break;
    }
}


- (void)volumeViewWirelessRouteActiveDidChangeNotification:(NSNotification*)noti {
    // 连接投屏设备
    BOOL show = self.volumView.isWirelessRouteActive;
    if (show) {
        NSString *airName = [self audioSessionUsingAirplayOutputRoute];
        if (!isEmpty(airName)) {
            //连接了AirPlay
            [self setConnectDeviceName:airName];
        }else{
            // 蓝牙
            [self setConnectDeviceName:nil];
        }
    }else{
        [self setConnectDeviceName:nil];
    }
}




- (BOOL)isAirPlay {
    BOOL show = self.volumView.isWirelessRouteActive;
    if (NO == show) {
        return NO;
    }
    NSString *airName = [self audioSessionUsingAirplayOutputRoute];
    if (!isEmpty(airName)) {
        //l连接了AirPlay
        
        
        if ([[UIScreen screens] count] < 2) {
               //连接了AirPlay
            self.isMirroring = NO;
            return YES;
        }else {
               //镜像
            self.isMirroring = YES;
            return YES;
        }
        
    }else{
        // 蓝牙
        return NO;
    }
}



- (NSString*)audioSessionUsingAirplayOutputRoute {
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    AVAudioSessionRouteDescription* currentRoute = audioSession.currentRoute;
    for (AVAudioSessionPortDescription* outputPort in currentRoute.outputs) {
        if ([outputPort.portType isEqualToString:AVAudioSessionPortAirPlay])
            return outputPort.portName;
    }
    return @" ";
}



- (void)setConnectDeviceName:(NSString *)connectDeviceName {
    _connectDeviceName = connectDeviceName;
}



- (BOOL)isConnected {
    if (self.isAirPlay || self.isLBlink ) {
        return YES;
    }
    return NO;
}



- (void)search {
    [self.lelinkBrowser searchForLelinkService];
}

- (BOOL)searchFromQRCodeValue:(NSString *)value onError:(NSError **)errPtr {
    return [self.lelinkBrowser searchForLelinkServiceFormQRCode:value onError:errPtr];
}

- (void)stopSearch {
    [self.lelinkBrowser stop];
}



#pragma mark - LBLelinkBrowserDelegate
- (void)lelinkBrowser:(LBLelinkBrowser *)browser onError:(NSError *)error {
    NSLog(@"搜索错误 %@", error);
    /**
     注意：如有需要，通知更新UI
     */
}

- (void)lelinkBrowser:(LBLelinkBrowser *)browser didFindLelinkServices:(NSArray<LBLelinkService *> *)services {
    NSLog(@"发现设备 %lu",(unsigned long)services.count);
    if (services == nil) {
        return;
    }
    
    /**
     遍历services，使用services中的lelinkService创建lelinkConnection，并添加到self.lelinkConnections中
     注意去重，如果有，则不重复创建
     */
    for (LBLelinkService * lelinkService in services) {
        if (self.lelinkConnections.count > 0) {
            BOOL containThisService = NO;
            for (LBLelinkConnection * lelinkConnection in self.lelinkConnections) {
                if ([lelinkService isEqual:lelinkConnection.lelinkService]) {
                    containThisService = YES;
                    NSLog(@"包含 %@ %@ %@",lelinkService.lelinkServiceName, lelinkService,lelinkConnection.lelinkService);
                    break;
                }
            }
            if (!containThisService) {
                LBLelinkConnection * lelinkConnection = [[LBLelinkConnection alloc] initWithLelinkService:lelinkService delegate:self];
                [self.lelinkConnections addObject:lelinkConnection];
            }
        }else{
            LBLelinkConnection * lelinkConnection = [[LBLelinkConnection alloc] initWithLelinkService:lelinkService delegate:self];
            [self.lelinkConnections addObject:lelinkConnection];
        }
    }
    NSLog(@"%lu", self.lelinkConnections.count);
    
    /**
     遍历self.lelinkConnections，如果其中的lelinkConnection.lelinkService不包含在services中，并且lelinkConnection的处于未连接状态，则将lelinkConnection从self.lelinkConnections中移除
     */
    NSMutableArray * tempArr = [NSMutableArray array];
    for (LBLelinkConnection * lelinkConnection in self.lelinkConnections) {
        if (services.count == 0) {
            if (!lelinkConnection.isConnected) {
                [tempArr addObject:lelinkConnection];
            }
        }else{
            BOOL has = NO;
            for (LBLelinkService * lelinkService in services) {
                if ([lelinkService isEqualToLelinkService:lelinkConnection.lelinkService]) {
                    has = YES;
                    break;
                }
            }
            if (!has && !lelinkConnection.isConnected) {
                [tempArr addObject:lelinkConnection];
            }
        }
    }
    for (LBLelinkConnection * connection in tempArr) {
        [self.lelinkConnections removeObject:connection];
    }
    
    NSLog(@"%lu", self.lelinkConnections.count);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LBLelinkKitManagerServiceDidChangeNotification object:nil];

}

#pragma mark - LBLelinkConnectionDelegate
- (void)lelinkConnection:(LBLelinkConnection *)connection onError:(NSError *)error {
    /**注意：如有需要，则通知更新UI */
    NSLog(@"连接错误 %@",error);
    self.isLBlink = YES;
}

- (void)lelinkConnection:(LBLelinkConnection *)connection didConnectToService:(LBLelinkService *)service {
    NSLog(@"连接到设备 %@",service.lelinkServiceName);
    [self setConnectDeviceName:service.lelinkServiceName];
    self.isLBlink = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LBLelinkKitManagerConnectionDidConnectedNotification object:nil userInfo:@{@"connection":connection,@"lbVideoUrl":self.videoUrl}];
    if ([self.delegate respondsToSelector:@selector(lBLelinkKitManager:isConnect:)]) {
        [self.delegate lBLelinkKitManager:self isConnect:YES];
    }
}

- (void)lelinkConnection:(LBLelinkConnection *)connection disConnectToService:(LBLelinkService *)service {
    NSLog(@"%@ 断开连接",service.lelinkServiceName);
    [self setConnectDeviceName:nil];
    self.isLBlink = NO;
    
    if ([self.delegate respondsToSelector:@selector(lBLelinkKitManager:isConnect:)]) {
        [self.delegate lBLelinkKitManager:self isConnect:NO];
    }
    
    

    
    /**
     断开连接，需要判断，service是否在self.lelinkBrowser.lelinkServices中，
     如果不在，则需要将connection从self.lelinkConnections中移除
     注意：如有需要，则通知更新UI
     */
    if (![self.lelinkBrowser.lelinkServices containsObject:service]) {
        if ([self.lelinkConnections containsObject:connection]) {
            [self.lelinkConnections removeObject:connection];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:LBLelinkKitManagerConnectionDisConnectedNotification object:nil userInfo:@{@"connection":connection,@"lbVideoUrl":self.videoUrl}];
    self.videoUrl = nil;
}

#pragma mark - LBLelinkPlayerDelegate

- (void)lelinkPlayer:(LBLelinkPlayer *)player onError:(NSError *)error {
    NSLog(@"播放错误 %@",error);
    [[NSNotificationCenter defaultCenter] postNotificationName:LBLelinkKitManagerPlayerErrorNotification object:nil userInfo:@{@"error":error}];
}

- (void)lelinkPlayer:(LBLelinkPlayer *)player playStatus:(LBLelinkPlayStatus)playStatus {
    NSLog(@"播放状态 %lu", (unsigned long)playStatus);
    self.currentPlayStatus = playStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:LBLelinkKitManagerPlayerStatusNotification object:nil userInfo:@{@"playStatus":[NSNumber numberWithInteger:playStatus],@"lbVideoUrl":self.videoUrl}];
}

- (void)lelinkPlayer:(LBLelinkPlayer *)player progressInfo:(LBLelinkProgressInfo *)progressInfo {
    NSLog(@"播放进度 总时长：%ld, 当前播放位置：%ld",(long)progressInfo.duration, (long)progressInfo.currentTime);
    [[NSNotificationCenter defaultCenter] postNotificationName:LBLelinkKitManagerPlayerProgressNotification object:nil userInfo:@{@"progressInfo":progressInfo}];
}

#pragma mark - method
- (void)reportSerivesListViewDisappear {
    [self.lelinkBrowser reportServiceListDisappear];
}

#pragma mark - setter & getter

- (LBLelinkBrowser *)lelinkBrowser{
    if (_lelinkBrowser == nil) {
        _lelinkBrowser = [[LBLelinkBrowser alloc] init];
        _lelinkBrowser.delegate = self;
        
    }
    return _lelinkBrowser;
}

- (void)setCurrentConnection:(LBLelinkConnection *)currentConnection {
    _currentConnection = currentConnection;
    /** 在重设currentConnection时一定要重新设置lelinkPlayer的lelinkConnection属性 */
    self.lelinkPlayer.lelinkConnection = currentConnection;
}

- (LBLelinkPlayer *)lelinkPlayer{
    if (_lelinkPlayer == nil) {
        _lelinkPlayer = [[LBLelinkPlayer alloc] initWithConnection:self.currentConnection];
        _lelinkPlayer.delegate = self;
    }
    return _lelinkPlayer;
}

- (NSMutableArray *)lelinkConnections{
    if (_lelinkConnections == nil) {
        _lelinkConnections = [NSMutableArray array];
    }
    return _lelinkConnections;
}



- (void)setVideoUrl:(NSString *)videoUrl {
    _videoUrl = videoUrl;
}


/** 乐播播放视频 */
- (void)playLBLinkWithVideoUrl:(NSString*)videoUrl startTime:(NSTimeInterval)startTime {
    
    self.videoUrl = videoUrl;
    
    if (!isEmpty(videoUrl)) {
        LBLelinkPlayerItem * item = [[LBLelinkPlayerItem alloc] init];
        item.mediaType = LBLelinkMediaTypeVideoOnline;
        
        item.mediaURLString = videoUrl;
        if (startTime >0 ) {
            item.startPosition = startTime;
        }
        /** 注意，为了适配接收端的bug，播放之前先stop，否则当先推送音乐再推送视频的时候会导致连接被断开 */
        [[LBLelinkKitManager sharedManager].lelinkPlayer stop];
        [[LBLelinkKitManager sharedManager].lelinkPlayer playWithItem:item];
    }else{
        NSLog(@"乐播 videoUrl is empty");
    }
}


- (void)stopLelinkPlayer {
    [[LBLelinkKitManager sharedManager].lelinkPlayer stop];
}

@end
