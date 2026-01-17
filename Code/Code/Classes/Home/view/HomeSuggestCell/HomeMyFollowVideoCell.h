//
//  HomeMyFollowVideoCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeMyFollowVideoModel;

@interface HomeMyFollowVideoCell : TBCollectionHighLightedCell

@property (nonatomic, strong)VideoModel *model;

@end



@interface HomeMyFollowVideoModel : NSObject

@property (nonatomic, copy)NSString *img_cover_url_big;
@property (nonatomic, copy)NSString *video_title;

@end
