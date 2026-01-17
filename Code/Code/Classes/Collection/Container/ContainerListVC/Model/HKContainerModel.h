//
//  HKContainerModel.h
//  Code
//
//  Created by Ivan li on 2017/11/27.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface HKAlbumModel : NSObject

@property(nonatomic,copy)NSString *album_id;

@property(nonatomic,copy)NSString *name; //合集名

@property(nonatomic,copy)NSString *cover; //图片

@property(nonatomic,copy)NSString *collect_num; //收藏人数

@property(nonatomic,copy)NSString *video_num; //练写数

@property(nonatomic,copy)NSString *username; //用户名
/** 用户头像 */
@property(nonatomic,copy)NSString *avator;
/** 简介 */
@property(nonatomic,copy)NSString *introduce;

@property(nonatomic,copy)NSString *gaussian_blur_url;
/** yes - 已存在专辑 */
@property(nonatomic,assign)BOOL is_exist;

@property (nonatomic , strong) NSArray * video;
@end












@interface HKContainerModel : NSObject

//@property(nonatomic,copy)NSString *url;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *album_count;

@property(nonatomic,copy)NSString *page;

@property(nonatomic,copy)NSString *total_page;

@property(nonatomic,strong)NSMutableArray<HKAlbumModel*> *album_list;

@end
