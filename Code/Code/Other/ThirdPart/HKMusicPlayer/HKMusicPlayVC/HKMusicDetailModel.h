//
//  HKMusicDetailModel.h
//  Code
//
//  Created by Ivan li on 2018/3/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VideoModel;

@class HKUserModel;


@interface HKMusicDetailModel : NSObject

@property(nonatomic,strong)VideoModel *audio_info;

@property(nonatomic,strong)HKUserModel *teacher_info;

@end
