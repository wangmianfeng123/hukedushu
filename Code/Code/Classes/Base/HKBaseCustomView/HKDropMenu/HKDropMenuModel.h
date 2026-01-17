//
//  HKDropMenuModel.h
//  Code
//
//  Created by Ivan li on 2019/1/7.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@class TagModel , AlbumSortTagListModel,ChildrenModel;


@interface HKDropMenuModel :NSObject //<NSCopying, NSMutableCopying>
/** 顶层数组 (yes) */
@property(nonatomic,assign)BOOL isTop;
/** 顶层数组 index ,区*/
@property(nonatomic,assign)NSInteger arrIndex;

@property(nonatomic,copy)NSString *parent_id;
/** 数组 层级 */
@property(nonatomic,assign)NSInteger level;

@property(nonatomic,strong)NSMutableArray<ChildrenModel*>*children;

/** 标题菜单是否记录用户菜单选择 默认是NO */
@property (nonatomic , assign) BOOL recordSeleted;
/** 筛选菜单类型 */
@property (nonatomic , assign) HKDropMenuFilterCellType filterCellType;
/** 筛选菜单选择类型 */
@property (nonatomic , assign) HKDropMenuFilterCellClickType filterClickType;

/** 是否是多选  NO 单选 YES 多选 */
@property (nonatomic , assign) BOOL isMultiple;
/** cell是否被选中 */
@property (nonatomic , assign) BOOL cellSeleted;
/** section是否被选中 */
@property (nonatomic , assign) BOOL sectionSeleted;
/** 存放tag section数组 */
@property (nonatomic , strong) NSMutableArray *sections;
/** sectionId id */
@property (nonatomic , assign) NSInteger sectionId;
/** tag id */
@property (nonatomic , assign) NSInteger tagId;

//搜索时所需要的参数
@property (nonatomic , copy) NSString * key;

/** tag 模型 */
@property (nonatomic , strong) HKDropMenuModel *dropMenuTagModel;
/** sectionHeaderTitle */
@property (nonatomic , copy) NSString *sectionHeaderTitle;
/** sectionHeaderDetails */
@property (nonatomic , copy) NSString *sectionHeaderDetails;
/** 标签名称 */
@property (nonatomic , copy) NSString *tagName;
/** 标签选中状态 */
@property (nonatomic , assign) BOOL tagSeleted;
/** 菜单类型 */
@property (nonatomic , assign) HKDropMenuType dropMenuType;
/** 标题 */
@property (nonatomic , copy) NSString *title;
/** menu title 序列 */
@property (nonatomic , assign) NSInteger menuIndex;
/** 选中的 cell row */
@property (nonatomic , assign) NSInteger cellRow;

@property (nonatomic , strong) UIFont *titleFont;

@property (nonatomic , strong) UIColor *titleColor;

@property (nonatomic , strong) UIColor *titleSelectColor;

@property (nonatomic , assign) CGFloat menuHeight;
/** 标题被选中 */
@property (nonatomic , assign) BOOL titleSeleted;
/** 标题数组 */
@property (nonatomic , strong) NSMutableArray *titles;
/** 数据源数组 */
@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic , assign) CGRect frame;
/** titleVie背景颜色 */
@property (nonatomic , strong) UIColor *titleViewBackGroundColor;
/** 记录indexPath */
@property (nonatomic , strong) NSIndexPath *indexPath;
/** menu 标题 隐藏 箭头 */
@property (nonatomic , assign) BOOL hiddenArrow;
/** menu 标题 居中  */
@property (nonatomic , assign) BOOL titleCenter;
/** menu 选中 icon  */
@property (nonatomic , copy) NSString *menuHighlightedImageName;
/** menu icon  */
@property (nonatomic , copy) NSString *menuImageName;
/** 默认选择的 tag  */
@property (nonatomic , copy) NSString *defaultSelectedTag;
/** 分类 ID  */
@property (nonatomic , copy) NSString *categoryId;
/** 存在被选中的 标签 */
@property (nonatomic , assign) BOOL isHaveSectionSeleted;

//计算标签的宽度
@property (nonatomic , assign) CGFloat menuWidth;
@property (nonatomic , assign) int originType; // 1 表示来自于搜索页


/** 构造筛选菜单数据 */
+ (NSMutableArray *)normalMenuArray:(nullable NSMutableArray <TagModel*> *)tagArr
                         videoCount:(NSInteger)videoCount;



/**
 搜索筛选
 
 @param tagArr tag
 @param sortArray 排序tag 数组
 @return
 */
+ (NSMutableArray *)searchMenuArray:(nullable NSMutableArray <TagModel*> *)tagArr
                          sortArray:(nullable NSMutableArray <TagModel*> *)sortArray;

/**
 专辑筛选
 
 @param tagArr 标签
 @param videoCount 视频数量
 @return
 */
+ (NSMutableArray *)albumMenuArray:(nullable NSMutableArray <AlbumSortTagListModel*> *)tagArr
                        videoCount:(NSInteger)videoCount;

@end

@interface HKFiltrateModel : NSObject
@property (nonatomic , strong) NSString * not_easy;
@property (nonatomic , strong) NSString * split_group;
@property (nonatomic , strong) NSString * has_pictext;

@end

NS_ASSUME_NONNULL_END
