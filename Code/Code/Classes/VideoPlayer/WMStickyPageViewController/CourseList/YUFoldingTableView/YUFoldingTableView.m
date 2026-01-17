//
//  YUFoldingTableView.m
//  YUFoldingTableView
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 liufengting. All rights reserved.
//

#import "YUFoldingTableView.h"
#import "YUFoldingSectionFooter.h"

@interface YUFoldingTableView () <YUFoldingSectionHeaderDelegate>


@end

@implementation YUFoldingTableView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame withType:(UITableViewStyle)type{
    self = [super initWithFrame:frame style:type];
    if (self) {
        self.scrollViewDelegateTempValidate = YES;
        [self setupDelegateAndDataSource];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollViewDelegateTempValidate = YES;
        [self setupDelegateAndDataSource];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDelegateAndDataSource];
    }
    return self;
}

#pragma mark - 创建数据源和代理

- (void)setupDelegateAndDataSource
{
    // 适配iOS 11
#ifdef __IPHONE_11_0
    if ([self respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
#endif

    self.delegate = self;
    self.dataSource = self;
    if (self.style == UITableViewStylePlain) {
        self.tableFooterView = [[UIView alloc] init];
    }
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeStatusBarOrientationNotification:)  name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (NSMutableArray *)statusArray
{
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    
    if (!_foldingState) {
        _foldingState = YUFoldingSectionStateFlod;
    }
    
    if (_statusArray.count) {
        if (_statusArray.count > self.numberOfSections) {
            [_statusArray removeObjectsInRange:NSMakeRange(self.numberOfSections - 1, _statusArray.count - self.numberOfSections)];
        }else if (_statusArray.count < self.numberOfSections) {
            for (NSInteger i = self.numberOfSections - _statusArray.count; i < self.numberOfSections; i++) {
                [_statusArray addObject:[NSNumber numberWithInteger:_foldingState]];
            }
        }
    }else{
        for (NSInteger i = 0; i < self.numberOfSections; i++) {
            [_statusArray addObject:[NSNumber numberWithInteger:_foldingState]];
        }
    }
    return _statusArray;
}

- (void)onChangeStatusBarOrientationNotification:(NSNotification *)notification
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}

#pragma mark - UI Configration

- (YUFoldingSectionHeaderArrowPosition )perferedArrowPosition
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(perferedArrowPositionForYUFoldingTableView:)]) {
        return [_foldingDelegate perferedArrowPositionForYUFoldingTableView:self];
    }
    return YUFoldingSectionHeaderArrowPositionRight;
}
- (UIColor *)backgroundColorForSection:(NSInteger )section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:backgroundColorForHeaderInSection:)]) {
        return [_foldingDelegate yuFoldingTableView:self backgroundColorForHeaderInSection:section];
    }
//    return [UIColor colorWithRed:102/255.f green:102/255.f blue:255/255.f alpha:1.f];
    return [UIColor colorWithRed:255.0/255.f green:255.0/255.f blue:255.0/255.f alpha:1.f];
}
- (NSString *)titleForSection:(NSInteger )section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:titleForHeaderInSection:)]) {
        return [_foldingDelegate yuFoldingTableView:self titleForHeaderInSection:section];
    }
    return [NSString string];
}
- (UIFont *)titleFontForSection:(NSInteger )section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:fontForTitleInSection:)]) {
        return [_foldingDelegate yuFoldingTableView:self fontForTitleInSection:section];
    }
    return [UIFont boldSystemFontOfSize:16];
}
- (UIColor *)titleColorForSection:(NSInteger )section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:textColorForTitleInSection:)]) {
        return [_foldingDelegate yuFoldingTableView:self textColorForTitleInSection:section];
    }
    return [UIColor whiteColor];
}
- (NSString *)descriptionForSection:(NSInteger )section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:descriptionForHeaderInSection:)]) {
        return [_foldingDelegate yuFoldingTableView:self descriptionForHeaderInSection:section];
    }
    return [NSString string];
}
- (UIFont *)descriptionFontForSection:(NSInteger )section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:fontForDescriptionInSection:)]) {
        return [_foldingDelegate yuFoldingTableView:self fontForDescriptionInSection:section];
    }
    return [UIFont boldSystemFontOfSize:13];
}

- (UIColor *)descriptionColorForSection:(NSInteger )section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:textColorForDescriptionInSection:)]) {
        return [_foldingDelegate yuFoldingTableView:self textColorForDescriptionInSection:section];
    }
    return [UIColor whiteColor];
}

- (UIImage *)arrowImageForSection:(NSInteger )section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:arrowImageForSection:)]) {
        return [_foldingDelegate yuFoldingTableView:self arrowImageForSection:section];
    }
    return [UIImage imageNamed:@"Arrow"];
}


#pragma mark 19-06-11 section 标题 左边距
- (CGFloat )sectionTitleLeftMaginForSection:(NSInteger )section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:sectionTitleLeftMaginForSection:)]) {
        return [_foldingDelegate yuFoldingTableView:self sectionTitleLeftMaginForSection:section];
    }
    return 20;
}


- (CGFloat )sectionArrowRightMarginForSection:(NSInteger )section {
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:sectionArrowRightMarginForSection:)]) {
        return [_foldingDelegate yuFoldingTableView:self sectionArrowRightMarginForSection:section];
    }
    return 30;
}


- (BOOL)sectionTitleClick:(NSInteger)section {
    
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:sectionTitle:isClick:)]) {
        return [_foldingDelegate yuFoldingTableView:self sectionTitle:section isClick:YES];
    }
    return YES;
}

#pragma mark - section 点击 旋转动画
- (BOOL)sectionTitleShowAnimation:(NSInteger)section {
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:sectionTitleShowAnimation:)]) {
        return [_foldingDelegate yuFoldingTableView:self sectionTitleShowAnimation:section];
    }
    return YES;
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(numberOfSectionForYUFoldingTableView:)]) {
        return [_foldingDelegate numberOfSectionForYUFoldingTableView:self];
    }else{
        return self.numberOfSections;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (((NSNumber *)self.statusArray[section]).integerValue == YUFoldingSectionStateShow) {
        if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:numberOfRowsInSection:)]) {
            return [_foldingDelegate yuFoldingTableView:self numberOfRowsInSection:section];
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:heightForHeaderInSection:)]) {
        return [_foldingDelegate yuFoldingTableView:self heightForHeaderInSection:section];
    }else{
        return self.sectionHeaderHeight;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:heightForRowAtIndexPath:)]) {
        return [_foldingDelegate yuFoldingTableView:self heightForRowAtIndexPath:indexPath];
    }else{
        return self.rowHeight;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:heightForFooterInSection:)]) {
        CGFloat height = [_foldingDelegate yuFoldingTableView:self heightForFooterInSection:section];
        if (section == self.numberOfSections -1 ) {
            return 0;
        }
        return height;
    }else{
        if (self.style == UITableViewStylePlain) {
            return 0;
        }else{
            return 0.001;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == self.numberOfSections -1) {
        return nil;
    }
    
    YUFoldingSectionFooter *sectionFootView = (YUFoldingSectionFooter*) [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    if (!sectionFootView) {
        sectionFootView = [[YUFoldingSectionFooter alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,16) tag:section];
    }
    return sectionFootView;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YUFoldingSectionHeader *sectionHeaderView = (YUFoldingSectionHeader*) [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    
    if (!sectionHeaderView) {
        sectionHeaderView = [[YUFoldingSectionHeader alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [self tableView:self heightForHeaderInSection:section])  tag:section];
        
        sectionHeaderView.tapDelegate = self;
    }
    sectionHeaderView.sepertorLine.hidden = self.noShowLine;
    sectionHeaderView.tag = section;
    [sectionHeaderView setupWithBackgroundColor:[self backgroundColorForSection:section]
                                    titleString:[self titleForSection:section]
                                     titleColor:[self titleColorForSection:section]
                                      titleFont:[self titleFontForSection:section]
                              descriptionString:[self descriptionForSection:section]
                               descriptionColor:[self descriptionColorForSection:section]
                                descriptionFont:[self descriptionFontForSection:section]
                                     arrowImage:[self arrowImageForSection:section]
                                  arrowPosition:[self perferedArrowPosition]
                                   sectionState:((NSNumber *)self.statusArray[section]).integerValue
                          sectionTitleLeftMagin:[self sectionTitleLeftMaginForSection:section]
                               arrowRightMargin:[self sectionArrowRightMarginForSection:section]
                                isShowAnimation:[self sectionTitleShowAnimation:section]
     ];
    
    return sectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:cellForRowAtIndexPath:)]) {
        return [_foldingDelegate yuFoldingTableView:self cellForRowAtIndexPath:indexPath];
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCellIndentifier"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:didSelectRowAtIndexPath:)]) {
        [_foldingDelegate yuFoldingTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma  mark <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.scrollViewDelegateTempValidate && [_scrollViewDelegateTemp respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [_scrollViewDelegateTemp scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollViewDelegateTempValidate && [_scrollViewDelegateTemp respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_scrollViewDelegateTemp scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.scrollViewDelegateTempValidate && [_scrollViewDelegateTemp respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [_scrollViewDelegateTemp scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}


#pragma mark - YUFoldingSectionHeaderDelegate

- (void)yuFoldingSectionHeaderTappedAtIndex:(NSInteger)index {
    
//    if (DEBUG) {
        BOOL isClick = [self sectionTitleClick:index];
        if (!isClick) {
            if (_foldingDelegate && [_foldingDelegate respondsToSelector:@selector(yuFoldingTableView:sectionTitleClicked:)]) {
                // section 点击回调
                [_foldingDelegate yuFoldingTableView:self sectionTitleClicked:index];
            }
            return;
        }
//    }
    
    BOOL currentIsOpen = ((NSNumber *)self.statusArray[index]).boolValue;
    
    [self.statusArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!currentIsOpen]];
    
    NSInteger numberOfRow = [_foldingDelegate yuFoldingTableView:self numberOfRowsInSection:index];
    NSMutableArray *rowArray = [NSMutableArray array];
    if (numberOfRow) {
        for (NSInteger i = 0; i < numberOfRow; i++) {
            [rowArray addObject:[NSIndexPath indexPathForRow:i inSection:index]];
        }
    }
    if (rowArray.count) {
        if (currentIsOpen) {
            [self deleteRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
        }else{
            [self insertRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
    
    // 防止折叠起来后顶部出现大片空白bug
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.contentOffset.y < - 100.0) {
            [self setContentOffset:CGPointMake(self.contentOffset.x, 0.0)];
        }
    });
}


// 移除或者增加cell
- (void)tableViewAddOrRemoveCell:(NSArray<NSIndexPath *> *)array isExpand:(BOOL)isExpand {
    
    if (!isExpand) {
        [self deleteRowsAtIndexPaths:[NSArray arrayWithArray:array] withRowAnimation:UITableViewRowAnimationTop];
    }else{
        [self insertRowsAtIndexPaths:[NSArray arrayWithArray:array] withRowAnimation:UITableViewRowAnimationTop];
    }
}



@end
