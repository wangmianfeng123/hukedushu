//
//  HKCategoryDropMenu.m
//  Code
//
//  Created by Ivan li on 2019/2/22.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKCategoryDropMenu.h"
#import "NSArray+Bounds.h"
#import "NSString+Size.h"
#import "UIView+Extension.h"
#import "HKDropMenuModel.h"
#import "HKDropMenuCell.h"
#import "HKDropMenuFilterHeader.h"
#import "HKDropMenuFilterItem.h"
#import "HKDropMenuTitle.h"
#import "HKDropMenuItem.h"
#import "TagModel.h"
#import "VideoServiceMediator.h"


#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kKeyWindow [UIApplication sharedApplication].keyWindow

#define kGHSafeAreaTopHeight ( (IS_IPHONE_X) ? 88.f : 64.f)

#define kGHSafeAreaBottomHeight ((IS_IPHONE_X) ?34 : 0)

#define kFilterButtonHeight 44

#define KRowHeight 40

#define KDefaultMenuHeight 40



/** 按钮类型 */
typedef NS_ENUM (NSUInteger,HKDropMenuButtonType ) {
    /** 确定 */
    HKDropMenuButtonTypeSure = 1,
    /** 重置 */
    HKDropMenuButtonTypeReset,
};

typedef NS_ENUM (NSUInteger,HKDropMenuShowType ) {
    HKDropMenuShowTypeCommon = 1,
    HKDropMenuShowTypeOnlyFilter,
};


@interface HKCategoryDropMenu()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate,
HKDropMenuItemDelegate,HKDropMenuFilterItemDelegate,HKDropMenuFilterHeaderDelegate>

/** 装顶部菜单的数组 */
@property (nonatomic , strong) NSMutableArray *titles;
/** 顶部菜单 */
@property (nonatomic , strong) UICollectionView *collectionView;
/** 顶部菜单布局 */
@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
/** 弹出菜单 */
@property (nonatomic , strong) UITableView *tableView;
/** 弹出菜单内容数组 */
@property (nonatomic , strong) NSMutableArray *contents;
/** 菜单的高度 */
@property (nonatomic , assign) CGFloat menuHeight;

@property (nonatomic , strong) UIView *topLine;

@property (nonatomic , strong) UIView *bottomLine;

@property (nonatomic , strong) UIView *bottomView;
/** 弹出菜单选中index */
@property (nonatomic , assign) NSInteger currentIndex;
/** 筛选器 */
@property (nonatomic , strong) UICollectionView *filter;

@property (nonatomic , strong) UICollectionViewFlowLayout *filterFlowLayout;
/** 重置 */
@property (nonatomic , strong) UIButton *reset;
/** 确定 */
@property (nonatomic , strong) UIButton *sure;
/** 遮罩 */
@property (nonatomic , strong) UIControl *filterCover;

@property (nonatomic , strong) NSIndexPath *currentIndexPath;

@property (nonatomic , strong) UIControl *titleCover;

@property (nonatomic , copy) DropMenuTitleBlock dropMenuTitleBlock;

@property (nonatomic , copy) DropMenuTagArrayBlock dropMenuTagArrayBlock;

@property (nonatomic , assign) HKDropMenuShowType dropMenuShowType;

@property(nonatomic,strong)NSMutableArray <TagModel*> *tagArr; // 保存标签

@end


@implementation HKCategoryDropMenu
#pragma mark - 初始化
+ (instancetype)creatDropFilterMenuWidthConfiguration: (HKDropMenuModel *)configuration
                                dropMenuTagArrayBlock: (DropMenuTagArrayBlock)dropMenuTagArrayBlock {
    HKCategoryDropMenu *dropMenu = [[HKCategoryDropMenu alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight)];
    dropMenu.dropMenuShowType = HKDropMenuShowTypeOnlyFilter;
    dropMenu.titles = configuration.titles.mutableCopy;
    dropMenu.dropMenuTagArrayBlock = dropMenuTagArrayBlock;
    [dropMenu setupFilterUI];
    return dropMenu;
}


#pragma mark - 初始化
+ (instancetype)creatDropMenuWithConfiguration: (nullable HKDropMenuModel *)configuration
                                         frame: (CGRect)frame
                            dropMenuTitleBlock: (DropMenuTitleBlock)dropMenuTitleBlock
                         dropMenuTagArrayBlock: (DropMenuTagArrayBlock)dropMenuTagArrayBlock
{
    
    HKCategoryDropMenu *dropMenu = [[HKCategoryDropMenu alloc]initWithFrame:CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height)];
    
    dropMenu.configuration = configuration;
    dropMenu.menuHeight = frame.size.height;
    //dropMenu.tableY = frame.origin.y + frame.size.height;
    dropMenu.tableY = frame.size.height;
    dropMenu.dropMenuTitleBlock = dropMenuTitleBlock;
    dropMenu.dropMenuTagArrayBlock = dropMenuTagArrayBlock;
    dropMenu.dropMenuShowType = HKDropMenuShowTypeCommon;
    [dropMenu setupUI];
    return dropMenu;
}


#pragma mark - 重置 第一个 menu标题
- (void)resetFirstMenuTitleWithTitle:(NSString*)title {
    if (self.configuration.titles.count) {
        HKDropMenuModel *dropMenuTitleModel = self.configuration.titles[0];
        dropMenuTitleModel.title = title;
        [self.collectionView reloadData];
    }
}


- (void)setDataSource:(id<HKCategoryDropMenuDataSource>)dataSource {
    _dataSource = dataSource;
    if (dataSource == nil) {
        return;
    }
    NSArray *tempArray = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(columnTitlesInMeun:)]) {
        tempArray = [self.dataSource columnTitlesInMeun:self];
    }
    NSMutableArray *titles = [NSMutableArray array];
    for (NSInteger index = 0; index < tempArray.count; index++) {
        HKDropMenuModel *dropMenuModel = [[HKDropMenuModel alloc]init];
        dropMenuModel.title = [tempArray by_ObjectAtIndex:index];
        dropMenuModel.dropMenuType = HKDropMenuTypeTitle;
        [titles addObject:dropMenuModel];
    }
    self.titles = titles.copy;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:numberOfColumns:)]) {
        for (NSInteger index = 0; index < titles.count; index++) {
            HKDropMenuModel *dropMenuTitleModel = [titles by_ObjectAtIndex:index];
            NSArray *temp = [self.dataSource menu:self numberOfColumns:index];
            
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSInteger j = 0; j < temp.count; j++) {
                HKDropMenuModel *dropMenuModel = [[HKDropMenuModel alloc]init];
                dropMenuModel.title = [temp by_ObjectAtIndex:j];
                [dataArray addObject: dropMenuModel];
            }
            dropMenuTitleModel.dataArray = dataArray;
        }
    }
    [self.collectionView reloadData];
}




- (void)setTitleViewBackGroundColor:(UIColor *)titleViewBackGroundColor {
    self.collectionView.backgroundColor = titleViewBackGroundColor;
}



- (void)setConfiguration:(HKDropMenuModel *)configuration {
    _configuration = configuration;
    self.titles = configuration.titles;
    
    if (configuration.menuHeight) {
        self.collectionView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, configuration.menuHeight);
        
        [UIView animateWithDuration:0.0 animations:^{
            self.topLine.frame = CGRectMake(0, 0, kScreenWidth, 1);
            self.bottomLine.frame = CGRectMake(0, configuration.menuHeight - 1, kScreenWidth, 1);
        } completion:^(BOOL finished) {
            
        }];
        self.menuHeight = configuration.menuHeight;
    }
    
    [self resetMenuStatus];
    [self getSortTagWithId:configuration.categoryId refreshFilter:NO];
}



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self defaultConfiguration];
    }
    return self;
}


- (void)defaultConfiguration {
    self.menuHeight = KDefaultMenuHeight;
    self.currentIndex = 0;
}


#pragma mark - 消失
- (void)dismiss {
    
    if (self.titles.count) {
        HKDropMenuModel *dropMenuTitleModel = [self.titles by_ObjectAtIndex:self.currentIndex];
        self.filterCover.backgroundColor = [UIColor clearColor];
        self.titleCover.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:self.durationTime animations:^{
            if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeTitle ) {
                /** 普通菜单 */
                self.tableView.frame = CGRectMake(0, self.tableY , kScreenWidth, 0);
                self.titleCover.frame = CGRectMake(0, self.tableY, kScreenWidth, 0);
            } else if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeFilter ) {
                /** 筛选菜单 */
                self.filterCover.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
            }
            
        } completion:^(BOOL finished) {
            if (self.dropMenuShowType == HKDropMenuShowTypeOnlyFilter) {
                [self.layer setOpacity:0.0];
            }
            [self.tableView reloadData];
        }];
    }
}


#pragma mark - 弹出
- (void)show {
    
    if (self.dropMenuShowType == HKDropMenuShowTypeOnlyFilter) {
        [self.layer setOpacity:1];
    }
    
    HKDropMenuModel *dropMenuTitleModel = [self.titles by_ObjectAtIndex:self.currentIndex];
    if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeFilter ) {
        /** 筛选菜单 */
        self.titleCover.backgroundColor = [UIColor clearColor];
        //获取分类 tag
        [self getSortTagWithId:self.configuration.categoryId refreshFilter:YES];
    }
    
    [UIView animateWithDuration:self.durationTime animations:^{
        if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeTitle ) {
            /** 普通菜单 */
            self.tableView.frame = CGRectMake(0, self.tableY, kScreenWidth, dropMenuTitleModel.dataArray.count * KRowHeight);
            self.titleCover.frame = CGRectMake(0, self.tableY, kScreenWidth, kScreenHeight - self.menuHeight - kGHSafeAreaTopHeight);
            
        } else if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeFilter) {
            /** 筛选菜单 */
            self.tableView.frame = CGRectMake(0, self.tableY, kScreenWidth, 0);
            self.titleCover.frame = CGRectMake(0, self.tableY, kScreenWidth, 0);
            self.filterCover.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeFilter ) {
                /** 筛选菜单 */
                self.filterCover.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.3];
                
            } else if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeTitle) {
                self.titleCover.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.3];
            }
        } completion:^(BOOL finished) {
        }];
    }];
    
    [self.tableView reloadData];
    [self.filter reloadData];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, self.menuHeight);
    self.topLine.frame = CGRectMake(0, 0, kScreenWidth, 1);
    self.bottomLine.frame = CGRectMake(0, self.menuHeight - 1, kScreenWidth, 1);
}



- (void)setTableY:(CGFloat)tableY {
    _tableY = tableY;
    self.tableView.y = tableY;
    self.titleCover.y = self.tableView.y;
}


#pragma mark - 创建UI 添加控件
- (void)setupUI {
    
    [self addSubview:self.collectionView];
    [self.collectionView addSubview:self.bottomLine];
    
    [kKeyWindow addSubview:self.filterCover];
    [self.filterCover addSubview:self.filter];
    [self.filterCover addSubview:self.bottomView];
    [self.filterCover addSubview:self.sure];
    [self.filterCover addSubview:self.reset];
    
    [self addSubview:self.titleCover];
    [self addSubview:self.tableView];
}


- (void)setupFilterUI {
    [kKeyWindow addSubview:self];
    [self addSubview:self.filterCover];
    [self.filterCover addSubview:self.filter];
    [self.filterCover addSubview:self.bottomView];
    [self.filterCover addSubview:self.sure];
    [self.filterCover addSubview:self.reset];
}


#pragma mark - 扩展父控件的点击范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // 默认为真直接返回
    BOOL inside = [super pointInside:point withEvent:event];
    if (inside) {
        return inside;
    }
    // 遍历所有子控件
    for (UIView *subView in self.subviews) {
        // 转换point坐标系
        CGPoint subViewPoint = [subView convertPoint:point fromView:self];
        // 如果点击区域落在子控件上
        if ([subView pointInside:subViewPoint withEvent:event]) {
            return YES;
        }
    }
    return NO;
}



/** 重置menu 状态 */
- (void)resetMenuStatus {
    for (HKDropMenuModel *dropMenuModel in self.titles) {
        dropMenuModel.titleSeleted = NO;
    }
    [self.filter reloadData];
    [self.collectionView reloadData];
    [self dismiss];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resetMenuStatus];
}



#pragma mark - tag标签点击方法
- (void)dropMenuFilterItem: (HKDropMenuFilterItem *)item dropMenuModel:(HKDropMenuModel *)dropMenuModel {
    HKDropMenuModel *dropMenuTitleModel = [self.titles by_ObjectAtIndex: self.currentIndex];
    HKDropMenuModel *dropMenuSectionModel = [dropMenuTitleModel.sections by_ObjectAtIndex: dropMenuModel.indexPath.section];
    /** 处理多选 单选*/
    [self actionMultipleWithDropMenuModel:dropMenuModel dropMenuSectionModel:dropMenuSectionModel];
    /** 处理sectionDetails */
    [self actionSectionHeaderDetailsWithDropMenuModel:dropMenuModel dropMenuSectionModel:dropMenuSectionModel];
    [self.filter reloadData];
}


#pragma mark - 处理sectionHeaderDetails
- (void)actionSectionHeaderDetailsWithDropMenuModel: (HKDropMenuModel *)dropMenuModel dropMenuSectionModel: (HKDropMenuModel *)dropMenuSectionModel {
    
    NSMutableString *details = [NSMutableString string];
    for (HKDropMenuModel *dropMenuTagModel in dropMenuSectionModel.dataArray) {
        if (dropMenuTagModel.tagSeleted) {
            [details appendFormat:@"%@,", dropMenuTagModel.tagName];
        }
    }
    if (details.length) {
        [details deleteCharactersInRange:NSMakeRange(details.length - 1, 1)];
    }
    dropMenuSectionModel.sectionHeaderDetails = details;
}


#pragma mark - 处理单选 多选
- (void)actionMultipleWithDropMenuModel: (HKDropMenuModel *)dropMenuModel dropMenuSectionModel: (HKDropMenuModel *)dropMenuSectionModel {
    
    /** 处理单选 */
    NSInteger seletedTag = -1;
    if (dropMenuSectionModel.isMultiple) {
        
    } else {
        // 全部置为未选择
        for (HKDropMenuModel *dropMenuTagModel in dropMenuSectionModel.dataArray) {
            if (dropMenuTagModel.tagSeleted) {
                seletedTag = dropMenuTagModel.tagId;
            }
            dropMenuTagModel.tagSeleted = NO;
        }
    }
    
    if (HKDropMenuFilterCellClickTypeQuit == dropMenuSectionModel.filterClickType) {
        // tag 可以取消选中
        if (self.currentIndexPath != dropMenuModel.indexPath /** 不是第一次选中 */) {
            if (seletedTag == dropMenuModel.tagId) {
                dropMenuModel.tagSeleted = NO;
            } else {
                dropMenuModel.tagSeleted = !dropMenuModel.tagSeleted;
            }
            self.currentIndexPath = dropMenuModel.indexPath;
        } else {
            if (seletedTag == dropMenuModel.tagId) {
                if (dropMenuSectionModel.isMultiple) {
                    
                } else {
                    dropMenuModel.tagSeleted = NO;
                }
            } else {
                dropMenuModel.tagSeleted = !dropMenuModel.tagSeleted;
            }
            self.currentIndexPath = nil;
        }
    }else{
        // 选中的 tag （不能取消选中）
        dropMenuModel.tagSeleted = YES;
    }
}



#pragma mark - 点击顶部titleView 代理回调
- (void)dropMenuItem:(HKDropMenuItem *)item dropMenuModel:(HKDropMenuModel *)dropMenuModel {
    
    //  HKDropMenuTypeEnableTitle 禁止点击
    if (dropMenuModel.dropMenuType != HKDropMenuTypeEnableTitle) {
        dropMenuModel.titleSeleted = !dropMenuModel.titleSeleted;
        self.currentIndex = dropMenuModel.indexPath.row;
        
        if (dropMenuModel.titleSeleted) {
            /** 取出数组 展示*/
            self.contents = dropMenuModel.dataArray.copy;
            for (HKDropMenuModel *model in self.titles) {
                if (model.menuIndex != dropMenuModel.menuIndex) {
                    model.titleSeleted = NO;
                }
            }
            [self show];
        } else {
            [self dismiss];
        }
        [self.collectionView reloadData];
    }
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contents.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *seletedIndexPath = nil;
    
    for (HKDropMenuModel *dropMenuModel in self.titles) {
        if (dropMenuModel.titleSeleted) {
            seletedIndexPath = dropMenuModel.indexPath;
        }
    }
    
    HKDropMenuModel *dropMenuTitleModel = [self.titles by_ObjectAtIndex: seletedIndexPath.row];
    
    HKDropMenuModel *dropMenuModel = [dropMenuTitleModel.dataArray by_ObjectAtIndex: indexPath.row];
    HKDropMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKDropMenuCellID"];
    cell.dropMenuModel = dropMenuModel;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath *seletedIndexPath = nil;
    
    for (HKDropMenuModel *dropMenuModel in self.titles) {
        if (dropMenuModel.titleSeleted) {
            seletedIndexPath = dropMenuModel.indexPath;
        }
    }
    
    HKDropMenuModel *dropMenuModel = [self.titles by_ObjectAtIndex: seletedIndexPath.row];
    for (HKDropMenuModel *dropMenuContentModel in dropMenuModel.dataArray) {
        dropMenuContentModel.cellSeleted = NO;
    }
    
    HKDropMenuModel *contentModel = [dropMenuModel.dataArray by_ObjectAtIndex:indexPath.row];
    if (self.configuration.recordSeleted) {
        dropMenuModel.title = contentModel.title;
    }
    
    contentModel.cellSeleted = !contentModel.cellSeleted;
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropMenu:dropMenuTitleModel:)]) {
        [self.delegate dropMenu:self dropMenuTitleModel:contentModel];
    }
    
    if (self.dropMenuTitleBlock) {
        self.dropMenuTitleBlock(contentModel);
    }
    [self resetMenuStatus];
}


#pragma mark - collectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section  {
    if (self.filter == collectionView) {
        return CGSizeMake(kScreenWidth * 0.8, 10);
    } else {
        return CGSizeZero;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.filter == collectionView) {
        return CGSizeMake(kScreenWidth * 0.8, 44);
    } else {
        return CGSizeZero;
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    HKDropMenuModel *dropMenuTitleModel = [self.titles by_ObjectAtIndex:self.currentIndex];
    HKDropMenuModel *dropMenuSectionModel = [dropMenuTitleModel.sections by_ObjectAtIndex:indexPath.section];
    dropMenuSectionModel.indexPath = indexPath;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && self.filter == collectionView) {
        HKDropMenuFilterHeader *header  = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HKDropMenuFilterHeaderID" forIndexPath:indexPath];
        header.dropMenuModel = dropMenuSectionModel;
        header.delegate = self;
        return header;
        
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter] && self.filter == collectionView) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableViewID" forIndexPath:indexPath];
    } else {
        return [UICollectionReusableView new];
    }
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.collectionView) {
        
        switch (self.titles.count) {
            case 1: case 2:
            {
                return CGSizeMake(kScreenWidth /self.titles.count, self.menuHeight - 0.01f);
            }
                break;
            case 3:
            {
                if (0 == indexPath.row) {
                    return CGSizeMake(kScreenWidth - 160, self.menuHeight - 0.01f);
                }else{
                    return CGSizeMake(80, self.menuHeight - 0.01f);
                }
                //                if (0 == indexPath.row) {
                //                    return CGSizeMake(kScreenWidth /2, self.menuHeight - 0.01f);
                //                }else{
                //                    return CGSizeMake(kScreenWidth /4, self.menuHeight - 0.01f);
                //                }
            }
                break;
        }
        
    } else if (collectionView == self.filter) {
        
        HKDropMenuModel *dropMenuModel = [self.titles by_ObjectAtIndex: self.currentIndex];
        HKDropMenuModel *dropMenuSectionModel = dropMenuModel.sections[indexPath.section];
        
        if (dropMenuSectionModel.filterCellType == HKDropMenuFilterCellTypeTag) {
            return CGSizeMake((kScreenWidth * 0.9 - 20 - 50) / 3.0f, 30.01f);
        }else {
            return CGSizeZero;
        }
    }
    return CGSizeZero;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    HKDropMenuModel *dropMenuTitleModel = [self.titles by_ObjectAtIndex: self.currentIndex];
    if (self.filter == collectionView) {
        
        return dropMenuTitleModel.sections.count;
    } else if (collectionView == self.collectionView) {
        
        return 1;
    } else {
        return 0;
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.collectionView == collectionView) {
        return self.titles.count;
    } else if (self.filter == collectionView) {
        
        HKDropMenuModel *dropMenuModel = [self.titles by_ObjectAtIndex: self.currentIndex];
        HKDropMenuModel *dropMenuSectionModel = [dropMenuModel.sections by_ObjectAtIndex: section];
        
        if (dropMenuSectionModel.filterCellType == HKDropMenuFilterCellTypeTag) {
            return dropMenuSectionModel.dataArray.count;
        }else {
            return 0;
        }
    } else {
        return 0;
    }
}


#pragma mark - - - 返回collectionView item
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionView) {
        HKDropMenuModel *dropMenuModel = [self.titles by_ObjectAtIndex: indexPath.row];
        dropMenuModel.indexPath = indexPath;
        HKDropMenuItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKDropMenuItemID" forIndexPath:indexPath];
        cell.dropMenuModel = dropMenuModel;
        cell.delegate = self;
        return cell;
        
    } else if (collectionView == self.filter) {
        NSString *identifier = [NSString stringWithFormat:@"HKDropMenuFilterItemID"];
        [self.filter registerClass:[HKDropMenuFilterItem class] forCellWithReuseIdentifier:identifier];
        
        HKDropMenuModel *dropMenuTitleModel = [self.titles by_ObjectAtIndex: self.currentIndex];
        HKDropMenuModel *dropMenuSectionModel = [dropMenuTitleModel.sections by_ObjectAtIndex: indexPath.section];
        
        HKDropMenuModel *dropMenuTagModel = [dropMenuSectionModel.dataArray by_ObjectAtIndex: indexPath.row];
        dropMenuTagModel.indexPath = indexPath;
        
        if (dropMenuSectionModel.filterCellType == HKDropMenuFilterCellTypeTag) {
            HKDropMenuFilterItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            cell.dropMenuModel = dropMenuTagModel;
            cell.delegate = self;
            return cell;
        } else  {
            return [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
        }
    } else {
        return [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
    }
}



- (void)clickButton: (UIButton *)button {
    HKDropMenuModel *dropMenuTitleModel = [self.titles by_ObjectAtIndex:self.currentIndex];
    
    if (button.tag == HKDropMenuButtonTypeSure) {
        [self resetMenuStatus];
        NSMutableArray *dataArray = [NSMutableArray array];
        for (HKDropMenuModel *dropMenuSectionModel in dropMenuTitleModel.sections) {
            for (HKDropMenuModel *dropMenuTagModel in dropMenuSectionModel.dataArray) {
                if (dropMenuTagModel.tagSeleted) {
                    [dataArray addObject:dropMenuTagModel];
                }
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(dropMenu:tagArray:)]) {
            [self.delegate dropMenu:self tagArray:dataArray.copy];
        }
        if (self.dropMenuTagArrayBlock) {
            self.dropMenuTagArrayBlock(dataArray.copy);
        }
    } else if (button.tag == HKDropMenuButtonTypeReset){
        for (HKDropMenuModel *dropMenuSectionModel in dropMenuTitleModel.sections) {
            dropMenuSectionModel.sectionHeaderDetails = @"";
            for (HKDropMenuModel *dropMenuTagModel in dropMenuSectionModel.dataArray) {
                if (dropMenuTagModel.tagId) {
                    dropMenuTagModel.tagSeleted = NO;
                }else{
                    // 第一个 tag
                    dropMenuTagModel.tagSeleted = YES;
                }
            }
        }
        [self.filter reloadData];
    }
}


- (void)clickControl {
    
    [self resetMenuStatus];
}


#pragma mark - 懒加载
- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.frame = CGRectMake(self.filter.frame.origin.x, self.filter.frame.size.height + self.filter.frame.origin.y + kFilterButtonHeight,self.filter.frame.size.width , kGHSafeAreaBottomHeight);
    }
    return _bottomView;
}

- (UIControl *)titleCover {
    if (_titleCover == nil) {
        _titleCover = [[UIControl alloc]init];
        _titleCover.frame = CGRectMake(0, self.frame.size.height + kGHSafeAreaTopHeight, kScreenWidth, 0);
        [_titleCover addTarget:self action:@selector(clickControl) forControlEvents:UIControlEventTouchUpInside];
        _titleCover.backgroundColor = [UIColor clearColor];
    }
    return _titleCover;
}




- (UIControl *)filterCover {
    if (_filterCover == nil) {
        _filterCover = [[UIControl alloc]init];
        _filterCover.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
        [_filterCover addTarget:self action:@selector(clickControl) forControlEvents:UIControlEventTouchUpInside];
        _filterCover.backgroundColor = [UIColor clearColor];
    }
    return _filterCover;
}


- (UIButton *)reset {
    if (_reset == nil) {
        _reset = [[UIButton alloc]init];
        _reset.frame = CGRectMake(self.filter.frame.origin.x, self.filter.frame.size.height, self.filter.frame.size.width * 0.5, kFilterButtonHeight);
        _reset.backgroundColor = [UIColor whiteColor];
        [_reset setTitle:@"重置" forState:UIControlStateNormal];
        
        [_reset setTitleColor:COLOR_27323F forState:UIControlStateNormal];
        [_reset setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_reset addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        _reset.tag = HKDropMenuButtonTypeReset;
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = COLOR_F8F9FA;
        line.frame = CGRectMake(0, 0, _reset.frame.size.width, 1);
        [_reset addSubview:line];
    }
    return _reset;
}



- (UIButton *)sure {
    if (_sure == nil) {
        _sure = [[UIButton alloc]init];
        _sure.frame = CGRectMake(kScreenWidth - self.filter.frame.size.width * 0.5, self.filter.frame.size.height, self.filter.frame.size.width * 0.5, kFilterButtonHeight);
        
        _sure.tag = HKDropMenuButtonTypeSure;
        [_sure setTitle:@"确定" forState:UIControlStateNormal];
        [_sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sure setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        [_sure addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_sure setBackgroundImage:imageName(@"pullMenu_okBtn_bg") forState:UIControlStateNormal];
        [_sure setBackgroundImage:imageName(@"pullMenu_okBtn_bg") forState:UIControlStateHighlighted];
    }
    return _sure;
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.tableY, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight= KRowHeight;
        [_tableView registerClass:[HKDropMenuCell class] forCellReuseIdentifier:@"HKDropMenuCellID"];
    }
    return _tableView;
}


- (UICollectionViewFlowLayout *)filterFlowLayout {
    if (_filterFlowLayout == nil) {
        _filterFlowLayout = [[UICollectionViewFlowLayout alloc]init];
        _filterFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _filterFlowLayout.minimumInteritemSpacing = 10.0f;
        _filterFlowLayout.minimumLineSpacing = 15.0f;
    }
    return _filterFlowLayout;
}


- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 0.01f;
        _flowLayout.minimumInteritemSpacing = 0.01f;
    }
    return _flowLayout;
}


- (UICollectionView *)filter {
    if (_filter == nil) {
        _filter = [[UICollectionView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.1, 0, kScreenWidth * 0.9, kScreenHeight - kFilterButtonHeight - kGHSafeAreaBottomHeight) collectionViewLayout:self.filterFlowLayout];
        _filter.delegate = self;
        _filter.dataSource = self;
        _filter.contentInset = UIEdgeInsetsMake(32, 25, 0, 25);
        _filter.backgroundColor = [UIColor whiteColor];
        [_filter registerClass:[HKDropMenuFilterItem class] forCellWithReuseIdentifier:@"HKDropMenuFilterItemID"];
        [_filter registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
        [_filter registerClass:[HKDropMenuFilterHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKDropMenuFilterHeaderID"];
        [_filter registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableViewID"];
    }
    return _filter;
}


- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, self.menuHeight) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.layer.borderColor = [UIColor clearColor].CGColor;
        [_collectionView registerClass:[HKDropMenuItem class] forCellWithReuseIdentifier:@"HKDropMenuItemID"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
    }
    return _collectionView;
}


- (NSMutableArray *)contents {
    if (_contents == nil) {
        _contents = [NSMutableArray array];
    }
    return _contents;
}


- (NSMutableArray *)titles {
    if (_titles == nil) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = COLOR_F8F9FA;
    }
    return _bottomLine;
}


- (UIView *)topLine {
    if (_topLine == nil) {
        _topLine = [[UIView alloc]init];
        _topLine.backgroundColor = [UIColor clearColor];
    }
    return _topLine;
}



/**
 获取分类标签
 
 @param categoryId  分类ID
 @param refreshFilter  Yes 刷新 filter
 */
- (void)getSortTagWithId:(NSString*)categoryId  refreshFilter:(BOOL)refreshFilter {
    
    if (isEmpty(categoryId) || self.tagArr.count) {
        return;
    }
    
    [[VideoServiceMediator sharedInstance] getVideoTagList:categoryId  completion:^(FWServiceResponse *response) {
        
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
            NSData *data = [[response.data objectForKey:@"list"] mj_JSONData];
            self.tagArr =[TagModel mj_objectArrayWithKeyValuesArray:data];
            
            [self.tagArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(TagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (obj.children.count) {
                    //将每个 section 第一个 标记 选中
                    obj.children[0].isSelect = YES;
                    //查找默认选中的 tag
                    if (NO == isEmpty(self.configuration.defaultSelectedTag)) {
                        BOOL isFind = NO;
                        for (ChildrenModel *tempM in obj.children) {
                            if ([tempM.ID isEqualToString:self.configuration.defaultSelectedTag]) {
                                tempM.isSelect = YES;
                                isFind = YES;
                                break;
                            }else{
                                tempM.isSelect = NO;
                            }
                        }
                        if (NO ==isFind) {
                            // 不存在选择 tag
                            obj.children[0].isSelect = YES;
                        }
                    }
                }
            }];
            
            [self setFilterSection];
            if (refreshFilter) {
                [self.filter reloadData];
            }
        }
    } failBlock:^(NSError *error) {
        
    }];
}


- (void)setFilterSection {
    /** 设置构造右侧弹出筛选菜单每行的标题 */
    NSMutableArray *sections = [NSMutableArray array];
    
    for (NSInteger index = 0; index < self.tagArr.count; index++) {
        TagModel *tagM = self.tagArr[index];
        
        HKDropMenuModel *dropMenuModel = [[HKDropMenuModel alloc]init];
        dropMenuModel.sectionHeaderTitle = tagM.name;
        dropMenuModel.filterCellType = HKDropMenuFilterCellTypeTag;
        dropMenuModel.filterClickType = HKDropMenuFilterCellClickTypeQuit;
        
        
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSInteger index = 0 ; index < tagM.children.count; index++) {
            
            HKDropMenuModel *children = [[HKDropMenuModel alloc]init];
            children.tagSeleted = tagM.children[index].isSelect;
            children.tagId = [tagM.children[index].ID integerValue];
            children.tagName = tagM.children[index].name;
            
            if (children.tagSeleted) {
                // section 标题
                dropMenuModel.sectionHeaderDetails = children.tagName;
            }
            [tempArr addObject:children];
        }
        dropMenuModel.dataArray = tempArr;
        [sections addObject:dropMenuModel];
    }
    
    for (HKDropMenuModel *dropMenuModel in self.titles) {
        if (HKDropMenuTypeFilter == dropMenuModel.dropMenuType) {
            dropMenuModel.sections = sections;
        }
    }
}



- (void)dealloc {
    NSLog(@"释放了");
}

@end

