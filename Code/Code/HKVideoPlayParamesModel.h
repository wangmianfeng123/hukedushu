//
//  HKVideoPlayParamesModel.h
//  Code
//
//  Created by eon Z on 2022/8/10.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKDataParamesModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKVideoPlayParamesModel : HKDataParamesModel

@property (nonatomic , copy)NSString * video_id;
@property (nonatomic , copy)NSString * video_random_id;
@property (nonatomic , assign)int video_all_segment;
@property (nonatomic , assign)int video_watch_seq;
@property (nonatomic , assign)int video_length;
@property (nonatomic , copy)NSString * video_author_id;
@property (nonatomic , copy)NSString * start_play_time;
@property (nonatomic , assign)int current_play_time;
@property (nonatomic , assign)int real_played_time;
@property (nonatomic , copy)NSString * video_cid;
@property (nonatomic , assign)int video_play_at;
@property (nonatomic , assign)int video_play_is_trial;
@end

NS_ASSUME_NONNULL_END
