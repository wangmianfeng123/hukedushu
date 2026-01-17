//
//  HKStudyMedalCell.h
//  Code
//
//  Created by Ivan li on 2018/9/3.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKCustomMarginLabel,HKMyLearningCenterModel;


@interface HKStudyBtn : UIButton

@property (strong, nonatomic)  HKCustomMarginLabel *tagLB;

@property(nonatomic,copy)  NSString *tagText;

@end




@interface HKStudyMedalCell : UITableViewCell

@property (strong, nonatomic)  HKStudyBtn *leftBtn;

@property (strong, nonatomic)  HKStudyBtn *rightBtn;

@property (nonatomic,copy) void(^hkStudyMedalCellBlock)(NSInteger btnTag);

@property (strong, nonatomic)HKMyLearningCenterModel *model;

+ (instancetype)initCellWithTableView:(UITableView *)tableView;


@end

