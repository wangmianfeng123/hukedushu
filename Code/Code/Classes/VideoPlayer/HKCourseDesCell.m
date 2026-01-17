//
//  HKCourseDesCell.m
//  Code
//
//  Created by hanchuangkeji on 2017/10/31.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKCourseDesCell.h"


@interface HKCourseDesCell()

@property (weak, nonatomic) IBOutlet UILabel *courseDesContentLB;// 简介

@property (weak, nonatomic) IBOutlet UILabel *applicationLB;// 应用方向
@property (weak, nonatomic) IBOutlet UILabel *applicationContentLB;// 应用方向的内容
@property (weak, nonatomic) IBOutlet UILabel *forGroupLB;// 适合人群
@property (weak, nonatomic) IBOutlet UILabel *forGroupContentLB;// 适合人群的内容

@end

@implementation HKCourseDesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setVideoDetailModel:(DetailModel *)videoDetailModel {
    _videoDetailModel = videoDetailModel;
    HKCourseModel *courseModel = videoDetailModel.lessons_data;
    self.courseDesContentLB.text = courseModel.summary;
    self.applicationContentLB.text = courseModel.application_direction;
    self.forGroupContentLB.text = courseModel.suitable_for_groups;
}


- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 200;
    totalHeight += [self.courseDesContentLB sizeThatFits:CGSizeMake(size.width - 15 * 2, 0)].height;
    totalHeight += [self.applicationLB sizeThatFits:size].height;
    totalHeight += [self.applicationContentLB sizeThatFits:CGSizeMake(size.width - 15 * 2, 0)].height;
    totalHeight += [self.forGroupLB sizeThatFits:size].height;
    totalHeight += [self.forGroupContentLB sizeThatFits:CGSizeMake(size.width - 15 * 2, 0)].height;
    
    return CGSizeMake(size.width, totalHeight);
}


@end
