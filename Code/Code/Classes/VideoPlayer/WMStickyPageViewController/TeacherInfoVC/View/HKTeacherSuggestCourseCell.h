//
//  HKTeacherSuggestCourseCell.h
//  Code
//
//  Created by Ivan li on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VideoModel,HKCoverBaseIV;

@interface HKTeacherSuggestCourseCell : TBCollectionHighLightedCell

@property (nonatomic,strong) VideoModel *model;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) HKCoverBaseIV *goodImageView;

@end




