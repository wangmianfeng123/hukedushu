//
//  HKNewTaskModel.h
//  Code
//
//  Created by Ivan li on 2020/11/18.
//  Copyright © 2020 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKNewTaskModel : NSObject

@property (nonatomic, copy)NSString * desc;
@property(nonatomic,assign)int is_show;
@property (nonatomic, assign)int end_time;
@property (nonatomic, assign)int hour;
@property (nonatomic, assign)int status;  //0:未注册 1:完成 2:已注册 3:已播放 4:已领vip 5:老用户

@end

NS_ASSUME_NONNULL_END
