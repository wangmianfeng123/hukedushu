//
//  HomeMyFollowVideoCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeMyFollowVideoModel;

@interface HomeMyFollowVideoV2Cell : TBCollectionHighLightedCell

@property (nonatomic, strong)HKUserModel *model;


@property (nonatomic, copy)void(^videoSelectedBlock)(VideoModel *model);

@property (nonatomic, copy)void(^followTeacherSelectedBlock)(NSIndexPath *indexPath, HKUserModel *teacherModel);

@end



@interface HomeMyFollowVideoModel : NSObject

@property (nonatomic, copy)NSString *img_cover_url_big;
@property (nonatomic, copy)NSString *video_title;

@end
