//
//  HKMusicPlayVC.h
//  GKAudioPlayerDemo
//
//  Created by Ivan li on 2018/3/18.
//  Copyright © 2018年 pg. All rights reserved.
//




typedef NS_ENUM(NSUInteger, HKPlayerPlayStyle) {
    HKPlayerPlayStyleLoop,        // 循环播放
    HKPlayerPlayStyleOne,         // 单曲播放
    HKPlayerPlayStyleRandom       // 随机播放
};


#import "HKBaseVC.h"

#define HKPlayerVC         [HKMusicPlayVC sharedInstance]

@interface HKMusicPlayVC : HKBaseVC

@property (nonatomic, copy) NSString *currentMusicId;
/** 是否正在播放 */
@property (nonatomic, assign) BOOL isPlaying;

+ (instancetype)sharedInstance;


/**
 数组原始播放列表
 
 @param list 原始播放列表
 */
- (void)setupMusicList:(NSArray *)list;

/**
 根据索引及列表播放音乐
 
 @param index 列表中的索引
 @param list 列表
 */
- (void)playMusicWithIndex:(NSInteger)index list:(NSArray *)list;

/**
 加载音乐列表，不播放
 
 @param index 列表中的索引
 @param list 列表
 */
- (void)loadMusicWithIndex:(NSInteger)index list:(NSArray *)list;

- (void)playMusic;

- (void)pauseMusic;

- (void)stopMusic;

- (void)playNextMusic;

- (void)playPrevMusic;

@end

