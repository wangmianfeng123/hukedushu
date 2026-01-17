//
//  HKCategoryAlbumModel.h
//  Code
//
//  Created by Ivan li on 2017/12/4.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeriseCourseModel.h"

@class HKAlbumModel;



//-筛选标签
@interface AlbumSortTagModel : NSObject

@property(nonatomic,copy)NSString *name;
/** 专辑标签 ID */
//@property(nonatomic,copy)NSString *label_id;

@property(nonatomic,assign)BOOL isSelect;
/** 专辑标签 ID */
@property(nonatomic,copy)NSString *class_id;

@end



@interface AlbumSortTagListModel : NSObject

@property(nonatomic,copy)NSString *ID;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,strong)NSMutableArray<AlbumSortTagModel*>*children;

@property(nonatomic,copy)NSString *parent_id;

@end



@interface HKCategoryAlbumModel : NSObject

@property(nonatomic,strong)NSMutableArray<HKAlbumModel*> *album_list;

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

@property(nonatomic,strong)NSMutableArray <AlbumSortTagListModel*>*label_list;

@property(nonatomic,strong)NSMutableArray <AlbumSortTagModel*>*labels;



@end




