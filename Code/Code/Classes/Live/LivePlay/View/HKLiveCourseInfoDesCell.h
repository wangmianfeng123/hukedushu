//
//  HKLiveCourseInfoDesCell.h
//  Code
//
//  Created by hanchuangkeji on 2018/10/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKLiveListModel.h"
#import "HKLiveDetailModel.h"

typedef void(^HtmlHeightBlock)(float height);

NS_ASSUME_NONNULL_BEGIN

@interface HKLiveCourseInfoDesCell : UITableViewCell

@property(nonatomic, copy)HtmlHeightBlock htmlHeightBlock;

@property (nonatomic , copy) void(^loginBlock)(HomeAdvertModel *adsModel);

@property (nonatomic, strong)HKLiveDetailModel *model;

@property (nonatomic, strong)NSString * h5_url;
@property (weak, nonatomic) IBOutlet UILabel *themeLb;

@end

NS_ASSUME_NONNULL_END
