//
//  HKShortVideoCommentSubCell.h
//  Code
//
//  Created by hanchuangkeji on 2019/5/13.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKShortVideoCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKShortVideoCommentBotMoreCell : UITableViewCell

@property (nonatomic, strong)HKShortVideoCommentModel *model;

@property (nonatomic, copy)void(^loadMoreBlock)(BOOL isExpand, HKShortVideoCommentModel *model);

@property (nonatomic, assign)BOOL isLastCell; // 最后一个cell，裁剪一个分割线

@end

NS_ASSUME_NONNULL_END
