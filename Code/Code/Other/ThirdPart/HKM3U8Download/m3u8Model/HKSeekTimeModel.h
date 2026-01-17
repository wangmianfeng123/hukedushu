//
//  HKSeekTimeModel.h
//  Code
//
//  Created by hanchuangkeji on 2018/4/27.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKSeekTimeModel : NSObject

// 记忆播放视频id
@property (nonatomic, copy)NSString *videoId;

// 记忆播放视频type
@property (nonatomic, assign)int videoType;

// 记忆播放更新时间
@property (nonatomic, assign)NSInteger seekTime;

// 记忆播放更新时间的时间
@property (nonatomic, copy)NSString *seekTimeUpdate;

// 记忆播放使用者
@property (nonatomic, copy)NSString *userId;

@end
