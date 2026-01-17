//
//  HKAlbumModel.h
//  Code
//
//  Created by Ivan li on 2017/12/3.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VideoModel;

@interface HKAlbumListModel : NSObject

@property(nonatomic,copy)NSString *album_id;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *cover;

@property(nonatomic,copy)NSString *introduce;

@property(nonatomic,copy)NSString *collect_num;

@property(nonatomic,copy)NSString *video_num;

@property(nonatomic,copy)NSString *username;

@property(nonatomic,copy)NSString *avator;

@property(nonatomic,copy)NSString *is_collect; //is_collect：0-未收藏 1-已收藏

@property(nonatomic,copy)NSString *page;

@property(nonatomic,copy)NSString *total_page;

@property(nonatomic,strong)NSMutableArray<VideoModel*> *video_list;

@end


