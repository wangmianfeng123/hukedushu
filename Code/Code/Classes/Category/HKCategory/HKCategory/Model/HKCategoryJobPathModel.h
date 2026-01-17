//
//  HKCategoryJobPathModel.h
//  Code
//
//  Created by ivan on 2020/6/28.
//  Copyright © 2020 pg. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface HKCategoryJobPathModel : NSObject

@property(nonatomic,copy)NSString   *career_id;

@property(nonatomic,assign)NSInteger   chapter_number;

@property(nonatomic,assign)NSInteger   course_number;


@property(nonatomic,copy)NSString   *cover;

@property(nonatomic,copy)NSString   *descr;

@property(nonatomic,copy)NSString   *first_chapter_id;

@property(nonatomic,copy)NSString   *first_section_id;


@property(nonatomic,copy)NSString   *first_video_id;

@property(nonatomic,copy)NSString   *study_number;

@property(nonatomic,copy)NSString   *title;

@property (nonatomic,strong) HKMapModel *redirect_package;
@property (nonatomic, copy) NSString * description;


@end

NS_ASSUME_NONNULL_END
