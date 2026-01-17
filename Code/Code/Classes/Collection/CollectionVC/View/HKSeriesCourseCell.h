//
//  HKSeriesCourseCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/10/31.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  DownloadModel;
@class VideoModel;

@interface HKSeriesCourseCell : UITableViewCell



@property(nonatomic,copy)VideoModel  *model;

@property(atomic,strong)DownloadModel *downloadModel;

@end
