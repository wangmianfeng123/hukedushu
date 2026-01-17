//
//  HKAudioListCell.h
//  Code
//
//  Created by Ivan li on 2018/3/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoModel;

@interface HKAudioListCell : UITableViewCell

+ (instancetype)initCellWithTableView:(UITableView *)tableview;

@property(nonatomic,strong)VideoModel *model;

@end
