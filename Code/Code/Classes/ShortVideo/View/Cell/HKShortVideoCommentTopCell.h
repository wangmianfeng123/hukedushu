//
//  HKShortVideoCommentCell.h
//  Code
//
//  Created by hanchuangkeji on 2019/5/13.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKShortVideoCommentModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface HKShortVideoCommentTopCell : UITableViewCell

@property (nonatomic, strong)HKShortVideoCommentModel *model;

@property (nonatomic, copy)void(^userTapActionBlock)(HKShortVideoCommentModel *model);

@end

NS_ASSUME_NONNULL_END
