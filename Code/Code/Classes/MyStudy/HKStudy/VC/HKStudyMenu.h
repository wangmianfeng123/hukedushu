//
//  HKStudyMenu.h
//  Code
//
//  Created by Ivan li on 2019/3/22.
//  Copyright © 2019年 pg. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKStudyMenu,HKDropMenuModel;

@protocol HKDropMenuDataSource <NSObject>
@required

/** 配置筛选菜单标题 */
- (NSArray *)columnTitlesInMeun:(HKStudyMenu *)menu;
/** 配置筛选菜单标题选项 */
- (NSArray *)menu:(HKStudyMenu *)menu numberOfColumns:(NSInteger)columns;

@optional
- (NSArray *)titlesColorInMeun:(HKStudyMenu *)menu;

- (NSArray *)titlesFontInMeun:(HKStudyMenu *)menu;

@end


@protocol HKDropMenuDelegate <NSObject>
@optional
/**
 代理回调
 
 @param dropMenu dropMenu本身
 @param dropMenuTitleModel 标题弹出筛选结果
 */
- (void)dropMenu: (HKStudyMenu *)dropMenu dropMenuTitleModel: (nullable HKDropMenuModel *)dropMenuTitleModel;

/**
 代理回调
 
 @param dropMenu dropMenu本身
 @param tagArray 侧边弹出筛选结果
 */
- (void)dropMenu: (HKStudyMenu *)dropMenu tagArray: (nullable NSArray <HKDropMenuModel*>*)tagArray;

- (void)dropMenu: (HKStudyMenu *)dropMenu distance: (CGFloat)distance;
/** 重置筛选 */
- (void)dropMenu: (HKStudyMenu *)dropMenu reset:(BOOL)reset;

@end

typedef void(^DropMenuTitleBlock)(HKDropMenuModel *dropMenuModel);
typedef void(^DropMenuTagArrayBlock)(NSArray *tagArray);

@interface HKStudyMenu : UIView
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

@property (nonatomic , weak) id <HKDropMenuDelegate> delegate;

@property (nonatomic , weak) id <HKDropMenuDataSource> dataSource;

@property (nonatomic , assign) CGFloat tableY;

/** 动画时间 等于0 不开启动画 默认是0 */
@property (nonatomic , assign) NSTimeInterval durationTime;

- (void)show;

- (void)dismiss;


@end

NS_ASSUME_NONNULL_END
