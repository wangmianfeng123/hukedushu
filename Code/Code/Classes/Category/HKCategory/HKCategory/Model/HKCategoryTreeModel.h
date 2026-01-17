//
//  HKCategoryTreeModel.h
//  Code
//
//  Created by Ivan li on 2018/4/13.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKBookModel.h"

@class HKLiveListModel,HKJobPathPageInfoModel,HKcategoryOnlineSchoolListModel;


@interface HKCategoryTreeModel : NSObject

@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, assign) BOOL isNew;
/// 分类类别
@property (nonatomic, assign) HKCategoryType categoryType;

@end




@interface TSModel : NSObject

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *avatar;


@end


@interface HKcategoryChilderenModel : NSObject

/******************** 分类 软件入门 ************************/

@property (nonatomic,copy)NSString *img_url;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *string_1;

@property (nonatomic,copy)NSString *string_2;
/** 视频ID */
@property (nonatomic,copy)NSString *video_id;


/******************** 分类 设计课程 ************************/
/** 分类 ID  */
@property (nonatomic,copy)NSString *category_id;
/** 分类 ID v2.18 */
@property (nonatomic,copy)NSString * class_id;

@property (nonatomic,assign)int class_type;

@property (nonatomic,copy)NSString *video_title;

@property (nonatomic,copy)NSString *corner_word;


/******************** 分类 名师机构 ************************/
/** 讲师头像 */
@property (nonatomic,copy)NSString *avator;

@property (nonatomic,copy)NSString *teacher_id;
/// VC跳转
@property(nonatomic, strong)HKMapModel *redirect;

@property(nonatomic,assign)BOOL is_more;
/// 用于跳转 分类列表 选中标签
@property (nonatomic,copy)NSString *tag1;
@end




@class HKBookModel;
@interface HKcategoryListModel : NSObject

@property(nonatomic,copy)NSString *title;
/** 筛选标签 */
@property(nonatomic,copy)NSString *tag1;
/** 筛选标签 */
@property(nonatomic,copy)NSString *class_id;
/** 默认筛选标签 */
@property(nonatomic,copy)NSString *parent_tags;

@property(nonatomic,copy)NSArray<HKcategoryChilderenModel*> *list;

@property(nonatomic, strong)NSMutableArray<HKBookModel *> *bookList;
// 是否展开
@property(nonatomic,assign)BOOL isExpan;

@end



@interface HKcategoryModel : NSObject

//@property(nonatomic,copy)NSString *avatar;

//@property(nonatomic,copy)NSString *title;

//@property(nonatomic,copy)NSArray<VideoModel*>*children;

/** 顶部 图片 */
@property(nonatomic,copy)NSString *banner_url;
/** 热门软件 */
@property(nonatomic,copy)NSArray<HKcategoryListModel *> *class_a;
/** 热门课程 */
@property(nonatomic,copy)NSArray<HKcategoryListModel *> *class_b;
/** 名师大咖 */
@property(nonatomic,copy)NSArray<HKcategoryListModel *> *class_c;
/** 虎课读书 */
@property(nonatomic,copy)NSArray<HKcategoryListModel *> *class_d;

@property(nonatomic,copy)NSArray <HKcategoryListModel *> * class_0;
@property(nonatomic,copy)NSArray <HKcategoryListModel *>* class_1;
@property(nonatomic,copy)NSArray <HKcategoryListModel *>* class_2;

@property(nonatomic,copy)NSArray <HKcategoryListModel *>* class_3;

//@property(nonatomic,copy)NSArray <HKcategoryChilderenModel *>* class_4; //职业路径
@property(nonatomic,copy)NSArray <HKcategoryListModel *>* class_5;
@property(nonatomic,copy)NSArray <HKcategoryOnlineSchoolListModel*>* class_6;


@property (nonatomic, strong) HKJobPathPageInfoModel * pageInfo;

@property(nonatomic,strong)HKMapModel * bannerInfo;

@end






@interface HKcategoryOnlineSchoolListModel : NSObject

@property(nonatomic,copy)NSString *title;
/** 筛选标签 */
@property(nonatomic,assign)int klass; //-1 训练营推荐  0：免费公开课

@property(nonatomic,copy)NSArray<HKLiveListModel*> *list;

@property(nonatomic,strong)HKMapModel *redirect_package;

@end



@interface HKcategoryOnlineSchoolModel : NSObject
/** 虎课读书 */
@property(nonatomic,copy)NSArray<HKcategoryOnlineSchoolListModel*> *list;

@property(nonatomic,strong)HKMapModel *bannerInfo;

@end










