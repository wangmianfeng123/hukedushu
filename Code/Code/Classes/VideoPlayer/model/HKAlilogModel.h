//
//  HKAlilogModel.h
//  Code
//
//  Created by Ivan li on 2019/8/14.
//  Copyright © 2019 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 阿里云 统计 Model
 */
@interface HKAlilogModel : NSObject

@property(nonatomic,copy)NSString *shortVideoToVideoCollectFlag; //3.通过短视频推荐视频跳转视频详情页的视频收藏

@property(nonatomic,copy)NSString *shortVideoToVideoPlayFlag; //4.通过短视频推荐视频跳转视频详情页的视频播放

@end

NS_ASSUME_NONNULL_END
