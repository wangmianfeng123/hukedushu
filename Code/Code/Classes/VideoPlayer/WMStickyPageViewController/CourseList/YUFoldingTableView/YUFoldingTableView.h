//
//  YUFoldingTableView.h
//  YUFoldingTableView
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 liufengting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YUFoldingSectionHeader.h"

@class YUFoldingTableView;

@protocol YUFoldingTableViewDelegate <NSObject>

@required
/**
 *  箭头的位置
 */
- (YUFoldingSectionHeaderArrowPosition)perferedArrowPositionForYUFoldingTableView:(YUFoldingTableView *)yuTableView;
/**
 *  返回section的个数
 */
- (NSInteger )numberOfSectionForYUFoldingTableView:(YUFoldingTableView *)yuTableView;
/**
 *  cell的个数
 */
- (NSInteger )yuFoldingTableView:(YUFoldingTableView *)yuTableView numberOfRowsInSection:(NSInteger )section;
/**
 *  header的高度
 */
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForHeaderInSection:(NSInteger )section;
/**
 *  cell的高度
 */
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  header的标题
 */
- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger )section;
/**
 *  返回cell
 */
- (UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  点击cell
 */
- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

/**
 *  箭头图片
 */
- (UIImage *)yuFoldingTableView:(YUFoldingTableView *)yuTableView arrowImageForSection:(NSInteger )section;

// 下面是一些属性的设置

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView descriptionForHeaderInSection:(NSInteger )section;

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView backgroundColorForHeaderInSection:(NSInteger )section;

- (UIFont *)yuFoldingTableView:(YUFoldingTableView *)yuTableView fontForTitleInSection:(NSInteger )section;

- (UIFont *)yuFoldingTableView:(YUFoldingTableView *)yuTableView fontForDescriptionInSection:(NSInteger )section;

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView textColorForTitleInSection:(NSInteger )section;

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView textColorForDescriptionInSection:(NSInteger )section;

#pragma mark 19-06-11 section 标题 左边距
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView sectionTitleLeftMaginForSection:(NSInteger )section;

- (BOOL )yuFoldingTableView:(YUFoldingTableView *)yuTableView sectionTitle:(NSInteger)section isClick:(BOOL)isClick;
/**  section 点击 */
- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView sectionTitleClicked:(NSInteger)section;
/**  fooer的高度 */
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForFooterInSection:(NSInteger )section;

- (BOOL)yuFoldingTableView:(YUFoldingTableView *)yuTableView sectionTitleShowAnimation:(NSInteger)section;

- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView sectionArrowRightMarginForSection:(NSInteger )section;

@end

@interface YUFoldingTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id<YUFoldingTableViewDelegate> foldingDelegate;

/**
 用于解决使用WMHhomeViewController 占用delegate的方案
 */
@property (nonatomic, weak) id<UIScrollViewDelegate> scrollViewDelegateTemp;
@property (nonatomic, assign) BOOL scrollViewDelegateTempValidate;
@property (nonatomic, assign) YUFoldingSectionState foldingState;
@property (nonatomic, strong) NSMutableArray *statusArray;
@property (nonatomic , assign) BOOL noShowLine ;

// 移除或者增加cell
- (void)tableViewAddOrRemoveCell:(NSArray<NSIndexPath *> *)array isExpand:(BOOL)isExpand;

- (instancetype)initWithFrame:(CGRect)frame withType:(UITableViewStyle)type;
@end
