//
//  HKDropMenu.h
//  Code
//
//  Created by Ivan li on 2019/1/7.
//  Copyright © 2019年 pg. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKDropMenu,HKDropMenuModel,HKFiltrateModel;

@protocol HKDropMenuDataSource <NSObject>
@required

/** 配置筛选菜单标题 */
- (NSArray *)columnTitlesInMeun:(HKDropMenu *)menu;
/** 配置筛选菜单标题选项 */
- (NSArray *)menu:(HKDropMenu *)menu numberOfColumns:(NSInteger)columns;

@optional
- (NSArray *)titlesColorInMeun:(HKDropMenu *)menu;

- (NSArray *)titlesFontInMeun:(HKDropMenu *)menu;

@end


@protocol HKDropMenuDelegate <NSObject>
@optional
/**
 代理回调

 @param dropMenu dropMenu本身
 @param dropMenuTitleModel 标题弹出筛选结果
 */
- (void)dropMenu: (HKDropMenu *)dropMenu dropMenuTitleModel: (nullable HKDropMenuModel *)dropMenuTitleModel;

/**
 代理回调
 
 @param dropMenu dropMenu本身
 @param tagArray 侧边弹出筛选结果
 */
- (void)dropMenu: (HKDropMenu *)dropMenu tagArray: (nullable NSArray <HKDropMenuModel*>*)tagArray;

- (void)dropMenu: (HKDropMenu *)dropMenu distance: (CGFloat)distance;
/** 重置筛选 */
- (void)dropMenu: (HKDropMenu *)dropMenu reset:(BOOL)reset;
/** menu 点击 */
- (void)dropMenu:(HKDropMenu *)dropMenu itemIndex:(NSInteger)itemIndex;


//进阶 系列课 图文教程筛选
//- (void)dropMenu:(HKDropMenu *)dropMenu withParam:(HKFiltrateModel *)dic;

@end

typedef void(^DropMenuTitleBlock)(HKDropMenuModel *dropMenuModel);
typedef void(^DropMenuTagArrayBlock)(NSArray *tagArray);

@interface HKDropMenu : UIView
/**
 构造GHDropMenu

 @param configuration 配置模型
 @param frame 设置约束
 @param dropMenuTitleBlock 顶部菜单选择回调
 @param dropMenuTagArrayBlock 右侧筛选菜单回调
 */

+ (instancetype)creatDropMenuWithConfiguration: (nullable HKDropMenuModel *)configuration
                                         frame: (CGRect)frame
                            dropMenuTitleBlock: (DropMenuTitleBlock)dropMenuTitleBlock
                         dropMenuTagArrayBlock: (DropMenuTagArrayBlock)dropMenuTagArrayBlock;


/**
 构造GHDropFilterMenu
 @param configuration 配置模型
 @param dropMenuTagArrayBlock 右侧筛选菜单回调
 */
+ (instancetype)creatDropFilterMenuWidthConfiguration: (HKDropMenuModel *)configuration
         dropMenuTagArrayBlock: (DropMenuTagArrayBlock)dropMenuTagArrayBlock;

/** set方法 */
@property (nonatomic , strong) HKDropMenuModel *configuration;

@property (nonatomic , strong) UIColor *titleViewBackGroundColor;

@property (nonatomic , weak) id <HKDropMenuDelegate> delegate;

@property (nonatomic , weak) id <HKDropMenuDataSource> dataSource;

@property (nonatomic , assign) CGFloat tableY;

/** 动画时间 等于0 不开启动画 默认是0 */
@property (nonatomic , assign) NSTimeInterval durationTime;
///** 弹出菜单 */
//@property (nonatomic , strong,readonly) UITableView *tableView;

@property (nonatomic , strong) UICollectionView * tagCollectionView;

@property (nonatomic , strong,readonly) UIControl *titleCover;

@property (nonatomic , assign) BOOL isCategory;

/** 重置所有状态 */
- (void)resetMenuStatus;

- (void)show;

- (void)dismiss;

/** 重置 第一个 menu标题 */
- (void)resetFirstMenuTitleWithTitle:(NSString*)title;
- (void)clickButton: (UIButton *)button;
@end

NS_ASSUME_NONNULL_END




