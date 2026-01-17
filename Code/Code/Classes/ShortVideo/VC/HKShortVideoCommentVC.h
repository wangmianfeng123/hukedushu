//
//  HKShortVideoCommentVC.h
//  Code
//
//  Created by hanchuangkeji on 2019/5/10.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBaseVC.h"
#import "HKShortVideoModel.h"
#import "HKShortVideoCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKShortVideoCommentVC : HKBaseVC

@property (nonatomic, strong)HKShortVideoModel *shortVideoModel;

@property (nonatomic, copy)NSString *video_id;

@property (nonatomic, copy)void(^userTapActionBlock)(HKShortVideoCommentModel *model);

@property (nonatomic, copy)void(^shortVideoCommentAddOne)();



@end

NS_ASSUME_NONNULL_END
