//
//  HKClickParamesModel.h
//  Code
//
//  Created by eon Z on 2022/8/10.
//  Copyright © 2022 pg. All rights reserved.
//

#import "HKDataParamesModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKClickParamesModel : HKDataParamesModel

@property (nonatomic , copy)NSString * route;
@property (nonatomic , copy)NSString * position;
@property (nonatomic , copy)NSString * module;
@property (nonatomic , copy)NSString * uuid;
@property (nonatomic , copy)NSString * click_envent_play_video_class;
@property (nonatomic , copy)NSString * source_id;
@property (nonatomic , copy)NSString * class_index;
@property (nonatomic , copy)NSString * class_id;
@property (nonatomic , copy)NSString * viptype;

- (instancetype)initWithRoute:(NSString *)route module:(NSString *)module position:(NSString *)position;

@end

NS_ASSUME_NONNULL_END
