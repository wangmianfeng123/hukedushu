//
//  HKTestDownloadCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/12/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKDownloadModel.h"

@interface HKTestDownloadCell : UITableViewCell

@property (nonatomic, copy)void(^startBlock)(NSIndexPath *index);

@property (nonatomic, copy)void(^pauseBlock)(NSIndexPath *index);

@property (nonatomic, copy)void(^deleteBlock)(NSIndexPath *index);



- (void)setDownloadModel:(HKDownloadModel *)downloadModel index:(NSIndexPath *)indexPath;

- (void)setProgress:(NSString *)string;

@end
