//
//  HKDropMenu.m
//  Code
//
//  Created by Ivan li on 2019/1/7.
//  Copyright © 2019年 pg. All rights reserved.
//


#import "HKDropMenu.h"
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
#import "HKDropMenuData.h"
#import "HKDropMenuItemCell.h"
#import "HKDropMenuTypeCell.h"
#import "HKSearchSortView.h"
#import "HKDesignCategoryVC.h"
#import "WMMagicScrollView.h"
#import "DesignTableVC.h"
#import "HkDesignTableDropMenu.h"
#import "HKDropMenuTagCell.h"


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


@interface HKDropMenu()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate,
HKDropMenuItemDelegate,HKDropMenuFilterItemDelegate,HKDropMenuFilterHeaderDelegate,HKSearchSortViewDelegate>

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
 /** 默认标签 */
@property(nonatomic,copy)NSArray <NSString*> *defalutTagArr;

/// NO  保存筛选数据，便于还原（未点击确定和重置 按钮 筛选的数据）
@property (nonatomic,assign) BOOL isNeedReset;

@property (nonatomic, strong) HKSearchSortView * sortView;

@end


@implementation HKDropMenu
#pragma mark - 初始化
+ (instancetype)creatDropFilterMenuWidthConfiguration: (HKDropMenuModel *)configuration
                                dropMenuTagArrayBlock: (DropMenuTagArrayBlock)dropMenuTagArrayBlock {
    HKDropMenu *dropMenu = [[HKDropMenu alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight)];
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
    
    HKDropMenu *dropMenu = [[HKDropMenu alloc]initWithFrame:CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height)];
    
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
    if (self.configuration.titles.count > 1) {
        if (self.isCategory) {
            HKDropMenuModel *dropMenuTitleModel = self.configuration.titles[1];
            dropMenuTitleModel.title = title;
            [self.collectionView reloadData];
        }else if (self.configuration.titles.count == 3){
            HKDropMenuModel *dropMenuTitleModel = self.configuration.titles[0];
            dropMenuTitleModel.title = title;
            [self.collectionView reloadData];
        }
    }
}


- (void)setDataSource:(id<HKDropMenuDataSource>)dataSource {
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
    
    self.sortView.titles = self.titles;
    self.sortView.hidden = configuration.originType == 1? NO : YES;
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
        
        if (self.isCategory) {
            if ([dropMenuTitleModel.key isEqualToString:@"tag_id"] ||  [dropMenuTitleModel.key isEqualToString:@"software_tag_id"]) {
                [UIView animateWithDuration:self.durationTime animations:^{
                    if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeTitle ) {
                        /** 普通菜单 */
                        self.tableView.frame = CGRectMake(0, self.tableY , kScreenWidth, 0);
                        self.tagCollectionView.frame = CGRectMake(0, self.tableY , kScreenWidth, 0);
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
                    [self.tagCollectionView reloadData];
                    self.filterCover.hidden = YES;
                }];
            }else{
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
                    [self.tagCollectionView reloadData];
                    self.filterCover.hidden = YES;
                }];
            }
            
        }else{
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
                [self.tagCollectionView reloadData];
                self.filterCover.hidden = YES;
            }];
        }
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
    
    
    
    if (self.isCategory) {
        
        if ([dropMenuTitleModel.key isEqualToString:@"tag_id"] ||  [dropMenuTitleModel.key isEqualToString:@"software_tag_id"]) {
            [UIView animateWithDuration:self.durationTime animations:^{
                if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeTitle ) {
                    
                    int lines = ceil(dropMenuTitleModel.dataArray.count/3.0);
                    
                    /** 普通菜单 */
                    self.tagCollectionView.frame = CGRectMake(0, self.tableY, kScreenWidth,  lines > 5 ?  5 * KRowHeight : lines * KRowHeight );
                    self.tableView.frame = CGRectMake(0, self.tableY , kScreenWidth, 0);
                    self.titleCover.frame = CGRectMake(0, self.tableY, kScreenWidth, kScreenHeight - self.menuHeight - kGHSafeAreaTopHeight);
                    
                } else if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeFilter) {
                    /** 筛选菜单 */
                    self.tagCollectionView.frame = CGRectMake(0, self.tableY, kScreenWidth, 0);
                    self.tableView.frame = CGRectMake(0, self.tableY , kScreenWidth, 0);
                    self.titleCover.frame = CGRectMake(0, self.tableY, kScreenWidth, 0);
                    self.filterCover.hidden = NO;
                    self.filterCover.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
                }
                
            } completion:^(BOOL finished) {
                if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeFilter ) {
                    /** 筛选菜单 */
                    self.filterCover.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.3];
                    
                } else if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeTitle) {
                    self.titleCover.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.3];
                }
            }];
        }else{
            [UIView animateWithDuration:self.durationTime animations:^{
                if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeTitle ) {
                    /** 普通菜单 */
                    self.tableView.frame = CGRectMake(0, self.tableY, kScreenWidth, dropMenuTitleModel.dataArray.count * KRowHeight);
                    self.tagCollectionView.frame = CGRectMake(0, self.tableY, kScreenWidth, 0);

                    self.titleCover.frame = CGRectMake(0, self.tableY, kScreenWidth, kScreenHeight - self.menuHeight - kGHSafeAreaTopHeight);
                    
                    
                } else if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeFilter) {
                    /** 筛选菜单 */
                    self.tableView.frame = CGRectMake(0, self.tableY, kScreenWidth, 0);
                    self.tagCollectionView.frame = CGRectMake(0, self.tableY, kScreenWidth, 0);

                    self.titleCover.frame = CGRectMake(0, self.tableY, kScreenWidth, 0);
                    
                    self.filterCover.hidden = NO;
            
                    self.filterCover.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
                }
                
            } completion:^(BOOL finished) {
                if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeFilter ) {
                    /** 筛选菜单 */
                    self.filterCover.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.3];
                    
                } else if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeTitle) {
                    self.titleCover.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.3];
                }
            }];
        }
        
    }else{
        [UIView animateWithDuration:self.durationTime animations:^{
            if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeTitle ) {
                /** 普通菜单 */
                self.tableView.frame = CGRectMake(0, self.tableY, kScreenWidth, dropMenuTitleModel.dataArray.count * KRowHeight);
                self.tagCollectionView.frame = CGRectMake(0, self.tableY, kScreenWidth, 0);
                self.titleCover.frame = CGRectMake(0, self.tableY, kScreenWidth, kScreenHeight - self.menuHeight - kGHSafeAreaTopHeight);
                
            } else if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeFilter) {
                /** 筛选菜单 */
                self.tableView.frame = CGRectMake(0, self.tableY, kScreenWidth, 0);
                self.tagCollectionView.frame = CGRectMake(0, self.tableY, kScreenWidth, 0);
                self.titleCover.frame = CGRectMake(0, self.tableY, kScreenWidth, 0);
                
                self.filterCover.hidden = NO;
        
                self.filterCover.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            }
            
        } completion:^(BOOL finished) {
            if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeFilter ) {
                /** 筛选菜单 */
                self.filterCover.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.3];
                
            } else if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeTitle) {
                self.titleCover.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.3];
            }
        }];
    }
    
    
    [self.tagCollectionView reloadData];
    [self.tableView reloadData];
    [self.filter reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, self.menuHeight);
    self.topLine.frame = CGRectMake(0, 0, kScreenWidth, 1);
    self.bottomLine.frame = CGRectMake(0, self.menuHeight - 1, kScreenWidth, 1);
    self.sortView.frame = CGRectMake(0, 0, kScreenWidth, self.menuHeight);
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
    [self addSubview:self.sortView];
    

    
    self.filterCover.hidden = YES;
    [kKeyWindow addSubview:self.filterCover];
    
    [self.filterCover addSubview:self.filter];
    [self.filterCover addSubview:self.bottomView];
    [self.filterCover addSubview:self.sure];
    [self.filterCover addSubview:self.reset];
    
    [self addSubview:self.titleCover];
    [self addSubview:self.tableView];
    [self addSubview:self.tagCollectionView];
}


- (void)setupFilterUI {
    [kKeyWindow addSubview:self];
    [self addSubview:self.filterCover];
    [self.filterCover addSubview:self.filter];
    [self.filterCover addSubview:self.bottomView];
    [self.filterCover addSubview:self.sure];
    [self.filterCover addSubview:self.reset];
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *result = [super hitTest:point withEvent:event];
    if (result) {
        return result;
    }
    
    for (UIView *subview in self.subviews.reverseObjectEnumerator) {
        CGPoint subPoint = [subview convertPoint:point fromView:self];
        result = [subview hitTest:subPoint withEvent:event];
        if (result) {
            return result;
        }
    }
    return nil;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *view = [super hitTest:point withEvent:event];
//    CGPoint tempPoint = [self.tableView convertPoint:point fromView:self];
//    if ([self.tableView pointInside:tempPoint withEvent:event]) {
//        // 超出父控件范围 点击
//        return self.tableView;
//    }
//    
//    CGPoint tagPoint = [self.tagCollectionView convertPoint:point fromView:self];
//    if ([self.tagCollectionView pointInside:tagPoint withEvent:event]) {
//        // 超出父控件范围 点击
//        return self.tagCollectionView;
//    }
//    
//    CGPoint coverPoint = [self.titleCover  convertPoint:point fromView:self];
//    if ([self.titleCover pointInside:coverPoint withEvent:event]) {
//        // 超出父控件范围 点击
//        return self.titleCover;
//    }
//    return view;
//}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesMoved");
    [self resetMenuStatus];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesEnded");
    [self resetMenuStatus];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesCancelled");
    [self resetMenuStatus];
}



/** 重置menu 状态 */
- (void)resetMenuStatus {
    
    if (self.isNeedReset) {
        self.isNeedReset = NO;
        HKDropMenuModel *tempModel = [HKDropMenuData shareAccount];
        // 还原数据
        if (tempModel) {
            self.titles[self.currentIndex] = tempModel;
        }
    }
    
    for (HKDropMenuModel *dropMenuModel in self.titles) {
        
        if ([dropMenuModel.title isEqualToString:@"系列课"] || [dropMenuModel.title isEqualToString:@"图文教程"] || [dropMenuModel.title isEqualToString:@"进阶"]) {

        }else{
            dropMenuModel.titleSeleted = NO;
        }
        
        if (HKDropMenuTypeFilter == dropMenuModel.dropMenuType) {
            dropMenuModel.isHaveSectionSeleted = NO;
            
            BOOL isHave = NO;
            for (HKDropMenuModel *model in dropMenuModel.sections) {
                for (HKDropMenuModel *childM in model.dataArray) {
                    if (childM.tagSeleted) {
                        isHave = YES;
                        dropMenuModel.isHaveSectionSeleted = YES;
                        break;
                    }
                }
                if (isHave) {
                    break;
                }
            }
        }
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
    //self.titles 外面的筛选项数组，包括”筛选“
    HKDropMenuModel *dropMenuTitleModel = [self.titles by_ObjectAtIndex: self.currentIndex];
    
    if (!self.isNeedReset) {
        self.isNeedReset = YES;
        // 保存数据
        [HKDropMenuData saveOrUpdateDropMenuData:dropMenuTitleModel];
    }
    //dropMenuTitleModel为筛选菜单的总model，这里取出筛选菜单对应的区model
    //dropMenuTitleModel.sections为筛选菜单的总数组
    HKDropMenuModel *dropMenuSectionModel = [dropMenuTitleModel.sections by_ObjectAtIndex: dropMenuModel.indexPath.section];

    /** 处理多选 单选*/
    //处理点击的model和所在区数组的映射关系
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
 //将点击的model对应到对应的筛选区的model
    
    
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
    
    NSInteger section =  dropMenuModel.indexPath.section;
    switch (section) {
        case 0:
            [MobClick event:LIST_SCREEN_XILIEKE];
            break;
        case 1:
            [MobClick event:LIST_SCREEN_NEIRONG];
            break;
        default:
            break;
    }

    
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
        if (HKDropMenuFilterCellClickTypeQuit == dropMenuSectionModel.filterClickType) {
            [self setSelectSectionModel:dropMenuModel];
        }
}



#pragma mark - 选中tag  构造下一级数据
- (void)setSelectSectionModel:(HKDropMenuModel *)dropMenuModel {
    
    
    __block HKDropMenuModel *selectM = dropMenuModel;
    /** 第一层数组 */
    HKDropMenuModel *dropMenuTitleModel = nil;
    if (self.isCategory) {
        dropMenuTitleModel = [self.titles lastObject];
    }else{
        dropMenuTitleModel = [self.titles by_ObjectAtIndex: self.currentIndex];
    }
    // 逆向删除
    [dropMenuTitleModel.sections enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HKDropMenuModel *menuM = (HKDropMenuModel*)obj;
        if (menuM.arrIndex == selectM.arrIndex) {
            if (selectM.level < menuM.level) {
                // 选中的层级  将数组层级更高的 删除
                [dropMenuTitleModel.sections removeObjectAtIndex:idx];
            }
        }
    }];
    
    if (selectM.tagSeleted) {
        //选中 构造下一级数据
        [self setFilterSectionArray:selectM];
    }else{
        // 取消选中 无需构造
    }
}



- (void)setFilterSectionArray:(HKDropMenuModel *)selectM {
    
    HKDropMenuModel *menuModel = selectM;
    if (0 == menuModel.children.count) {
        return;
    }
    
    /** 构造选中的数据 */
    HKDropMenuModel *tempM = [[HKDropMenuModel alloc]init];
    tempM.sectionHeaderTitle = menuModel.tagName;
    tempM.tagId = menuModel.tagId;
    tempM.arrIndex = menuModel.arrIndex;
    
    tempM.filterCellType = HKDropMenuFilterCellTypeTag;
    tempM.filterClickType = HKDropMenuFilterCellClickTypeQuit;
    tempM.parent_id = [NSString stringWithFormat:@"%ld",(long)menuModel.tagId];
    
    NSMutableArray *childrenArr = [NSMutableArray array];
    for (ChildrenModel *model in menuModel.children) {
        
        HKDropMenuModel *childrenM = [[HKDropMenuModel alloc]init];
        childrenM.tagId = [model.ID integerValue];
        childrenM.sectionHeaderTitle = model.name;
        
        childrenM.filterCellType = HKDropMenuFilterCellTypeTag;
        childrenM.filterClickType = HKDropMenuFilterCellClickTypeQuit;
        
        childrenM.children = model.children;
        childrenM.level = model.level;
        
        childrenM.tagName = model.name;
        childrenM.arrIndex = tempM.arrIndex;
        
        [childrenArr addObject:childrenM];
        tempM.level = model.level;
    }
    
    tempM.dataArray = childrenArr;
    HKDropMenuModel *dropMenuTitleModel = nil;
    if (self.isCategory) {
        dropMenuTitleModel = [self.titles lastObject];
    }else{
        dropMenuTitleModel = [self.titles by_ObjectAtIndex: self.currentIndex];
    }
    if (dropMenuTitleModel.sections.count) {
        
        __block BOOL isFind = NO;
        [dropMenuTitleModel.sections enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HKDropMenuModel *childM = (HKDropMenuModel*)obj;
            if (childM.tagId == tempM.tagId) {
                isFind = YES;
            }else{
                
            }
        }];
        if (NO == isFind) {
            //插入sections 数据
            [dropMenuTitleModel.sections insertObject:tempM atIndex:menuModel.indexPath.section +1];
        }
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
        
        if ([self.delegate respondsToSelector:@selector(dropMenu:itemIndex:)]) {
            [self.delegate dropMenu:self itemIndex:self.currentIndex];
        }
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
    
//    if (self.isCategory) {
//        //选中的标签同步到侧滑菜单
//        if ([dropMenuModel.key isEqualToString:@"tag_id"] || [dropMenuModel.key isEqualToString:@"software_tag_id"]) {
//            HKDropMenuModel * filtMenuModel = [self.titles lastObject];
//            HKDropMenuModel * tempModel = nil;
//
//            for (int i = 0 ; i < filtMenuModel.sections.count; i++) {
//                HKDropMenuModel *dropMenuSectionModel = filtMenuModel.sections[i];
//                if ([dropMenuSectionModel.key isEqualToString: dropMenuModel.key]) {
//                    for (HKDropMenuModel * model in dropMenuSectionModel.dataArray) {
//                        model.tagSeleted = NO;
//                        if (model.tagId == contentModel.tagId) {
//                            model.tagSeleted = !model.tagSeleted;
//                            model.indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
//                            tempModel = model;
//                        }
//                    }
//                }
//            }
//            if (tempModel) {
//                [self setSelectSectionModel:tempModel];
//            }
//        }
//    }
    
    [self.tableView reloadData];
    
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
        
        if (self.isCategory) {
            
            HKDropMenuModel * model = [self.titles by_ObjectAtIndex:indexPath.row];
            if ([model.title isEqualToString:@"筛选"] && self.titles.count > 2) {
                CGFloat f = 0.0;
                for (int i = 2; i < self.titles.count; i++) {
                    HKDropMenuModel * model = [self.titles by_ObjectAtIndex:i];
                    if (![model.title isEqualToString:@"筛选"]) {
                        CGFloat contentW = [model.title boundingRectWithSize:CGSizeMake(200, 200) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil].size.width + 30;
                        f = f + contentW;
                    }
                }
                return CGSizeMake(SCREEN_WIDTH - 20 - 10 * (self.titles.count - 2) - f, (self.menuHeight-5)* 0.5);
            }else{
                switch (indexPath.row) {
                    case 0: case 1:
                    {
                        return CGSizeMake((SCREEN_WIDTH-32) /2.0, (self.menuHeight-5)* 0.5);
                    }
                        break;
                    case 2:{
                        return [self calculateItemSizeIndexPatch:indexPath];
                        break;
                    }
                    case 3: case 4:
                    {
                        return [self calculateItemSizeIndexPatch:indexPath];
                        break;
                    }
                    
                    default:
                        return [self calculateItemSizeIndexPatch:indexPath];

                        break;
                }
            }
            
            
        }else{
            switch (self.titles.count) {
                case 1: case 2:
                {
                    return CGSizeMake((kScreenWidth-32) /self.titles.count, self.menuHeight - 0.01f);
                }
                    break;
                case 3:
                {
                    if (0 == indexPath.row) {
                        return CGSizeMake(kScreenWidth - 200, self.menuHeight - 0.01f);
                    }else{
                        return CGSizeMake(80, self.menuHeight - 0.01f);
                    }
                }
                    break;
            }
        }
        
    } else if (collectionView == self.filter) {
        
        HKDropMenuModel *dropMenuModel = [self.titles by_ObjectAtIndex: self.currentIndex];
        HKDropMenuModel *dropMenuSectionModel = dropMenuModel.sections[indexPath.section];
        
        if (dropMenuSectionModel.filterCellType == HKDropMenuFilterCellTypeTag) {
            return CGSizeMake((kScreenWidth * 0.9 - 20 - 50) / 3.0f, 30.01f);
        }else {
            return CGSizeZero;
        }
    }else if (collectionView == self.tagCollectionView){
        return CGSizeMake((kScreenWidth - 10) / 3.0f, KRowHeight);
    }
    return CGSizeZero;
}

- (CGSize)calculateItemSizeIndexPatch:(NSIndexPath *)indexPath{
    HKDropMenuModel * model = [self.titles by_ObjectAtIndex:indexPath.row];
    
    CGFloat contentW = [model.title boundingRectWithSize:CGSizeMake(200, 200) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil].size.width;
    return CGSizeMake(contentW + 30, (self.menuHeight-5)* 0.5);

}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    HKDropMenuModel *dropMenuTitleModel = [self.titles by_ObjectAtIndex:self.currentIndex];
    if (self.filter == collectionView) {
        return dropMenuTitleModel.sections.count;
    } else if (collectionView == self.collectionView) {
        
        return 1;
    }else if (collectionView == self.tagCollectionView){
        
        return self.contents.count ? 1 : 0;
    }
    else {
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
    }else if (collectionView == self.tagCollectionView){
        
        return self.contents.count > 15 ? 15 : self.contents.count;
    } else {
        return 0;
    }
}


#pragma mark - - - 返回collectionView item
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionView) {
        if (self.isCategory) {
            HKDropMenuModel *dropMenuModel = [self.titles by_ObjectAtIndex: indexPath.row];
            if (indexPath.row == 0 || indexPath.row == 1) {
                //dropMenuModel.indexPath = indexPath;
                HKDropMenuItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKDropMenuItemCell class]) forIndexPath:indexPath];
                cell.titleLabel.text = dropMenuModel.title;
                cell.titleLabel.textColor = indexPath.row ? COLOR_A8ABBE_7B8196:COLOR_27323F_EFEFF6;
                cell.titleLabel.textAlignment = indexPath.row ? NSTextAlignmentRight : NSTextAlignmentLeft;
                cell.titleLabel.font = indexPath.row ? [UIFont systemFontOfSize:13]:[UIFont fontWithName:@"PingFangSC-Medium" size:14];
            
                return cell;
            }else{
                dropMenuModel.indexPath = indexPath;
                HKDropMenuTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKDropMenuTypeCell class]) forIndexPath:indexPath];
                cell.needAdjusted = [dropMenuModel.title isEqualToString:@"筛选"]? YES:NO;
                cell.dropMenuModel = dropMenuModel;
                if (indexPath.row == 6) {
                    cell.bgView.backgroundColor = [UIColor clearColor];
                }
                return cell;
            }
        }else{
            HKDropMenuModel *dropMenuModel = [self.titles by_ObjectAtIndex: indexPath.row];
            dropMenuModel.indexPath = indexPath;
            HKDropMenuItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKDropMenuItemID" forIndexPath:indexPath];
            cell.dropMenuModel = dropMenuModel;
            cell.delegate = self;
            return cell;
        }
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
    }else if (collectionView == self.tagCollectionView){
        NSIndexPath *seletedIndexPath = nil;
        for (HKDropMenuModel *dropMenuModel in self.titles) {
            if (dropMenuModel.titleSeleted) {
                seletedIndexPath = dropMenuModel.indexPath;
            }
        }
        
        HKDropMenuModel *dropMenuTitleModel = [self.titles by_ObjectAtIndex: seletedIndexPath.row];
        HKDropMenuTagCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKDropMenuTagCell class]) forIndexPath:indexPath];
        
        if (indexPath.row == 14 && dropMenuTitleModel.dataArray.count > 15) {
            cell.title.text = @"查看更多";
        }else{
            HKDropMenuModel *dropMenuModel = [dropMenuTitleModel.dataArray by_ObjectAtIndex: indexPath.row];
            cell.dropMenuModel = dropMenuModel;
        }
        return cell;
    } else {
        return [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionView) {
        if (indexPath.row == 3) {
            [MobClick event:list_advance_prime];
        }
        if (indexPath.row == 4) {
            [MobClick event:list_series_prime];
        }
        if (indexPath.row == 5) {
            [MobClick event:list_graphic_prime];
        }
        if (indexPath.row == 6) {
            [MobClick event:list_select_prime];

        }
        
        HKDropMenuModel *dropMenuModel = [self.titles by_ObjectAtIndex: indexPath.row];
        if (dropMenuModel.dropMenuType != HKDropMenuTypeEnableTitle) {
            
            if (dropMenuModel.dropMenuType == HKDropMenuTypeTitle || dropMenuModel.dropMenuType == HKDropMenuTypeFilter) {
                if (dropMenuModel.dropMenuType == HKDropMenuTypeTitle) {
                    for (HKDropMenuModel * model in self.titles) {
                        if (model.dropMenuType == HKDropMenuTypeTitle) {
                            if (model.menuIndex != dropMenuModel.menuIndex) {
                                model.titleSeleted = NO;
                                [self dismiss];
                            }
                        }
                    }
                }
                       
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.durationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    dropMenuModel.titleSeleted = !dropMenuModel.titleSeleted;
                    self.currentIndex = dropMenuModel.indexPath.row;
                    if (dropMenuModel.titleSeleted) {
                        /** 取出数组 展示*/
                        self.contents = dropMenuModel.dataArray.copy;
                        [self show];
                    } else {
                        [self dismiss];
                    }
                            
                    [self.collectionView reloadData];
                });
                
                
//                if (dropMenuModel.dropMenuType == HKDropMenuTypeTitle) {
//                    //调整表的滑动位置，自动置顶
//                    if ([self.delegate respondsToSelector:@selector(dropMenu:itemIndex:)]) {
//                        [self.delegate dropMenu:self itemIndex:self.currentIndex];
//                    }
//                }
                
            }
            
            
            if (dropMenuModel.dropMenuType == HKDropMenuTypeFilterBtn) {
                [self resetMenuStatus];
                [UIView animateWithDuration:self.durationTime animations:^{
                    /** 普通菜单 */
                    self.tableView.frame = CGRectMake(0, self.tableY , kScreenWidth, 0);
                    self.titleCover.frame = CGRectMake(0, self.tableY, kScreenWidth, 0);
                }];
                //同步数据到筛选菜单页
                [self synchronizationToFiltrateMenu];
            }
        }
    }else if (collectionView == self.tagCollectionView){
        if (indexPath.row == 14 && self.contents.count > 15) {
    
            [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:self.titles.count -1 inSection:0]];
        }else{
            NSIndexPath *seletedIndexPath = nil;
            for (HKDropMenuModel *dropMenuModel in self.titles) {
                if (dropMenuModel.titleSeleted) {
                    seletedIndexPath = dropMenuModel.indexPath;
                }
            }
            HKDropMenuModel *dropMenuModel = [self.titles by_ObjectAtIndex: seletedIndexPath.row];
            //处理取消选中
            HKDropMenuModel *contentModel = [dropMenuModel.dataArray by_ObjectAtIndex:indexPath.row];
            if (contentModel.cellSeleted == YES) {
                if (self.configuration.recordSeleted) {
                    if ([dropMenuModel.key isEqualToString:@"tag_id"]) {
                        dropMenuModel.title = @"内容";
                    }else if ([dropMenuModel.key isEqualToString:@"software_tag_id"]){
                        dropMenuModel.title = @"软件";
                    }
                }
                contentModel.cellSeleted = !contentModel.cellSeleted;
                
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(dropMenu:dropMenuTitleModel:)]) {
                    [self.delegate dropMenu:self dropMenuTitleModel:contentModel];
                }
            }else{
                for (HKDropMenuModel *dropMenuContentModel in dropMenuModel.dataArray) {
                    dropMenuContentModel.cellSeleted = NO;
                }
                if (self.configuration.recordSeleted) {
                    dropMenuModel.title = contentModel.title;
                }
                contentModel.cellSeleted = !contentModel.cellSeleted;
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(dropMenu:dropMenuTitleModel:)]) {
                    [self.delegate dropMenu:self dropMenuTitleModel:contentModel];
                }
            }
                        
            if (self.isCategory) {
                //选中的标签同步到侧滑菜单
                HKDropMenuModel * filtMenuModel = [self.titles lastObject];
                HKDropMenuModel * tempModel = nil;
                    
                for (int i = 0 ; i < filtMenuModel.sections.count; i++) {
                    HKDropMenuModel *dropMenuSectionModel = filtMenuModel.sections[i];
                    if ([dropMenuSectionModel.key isEqualToString: dropMenuModel.key]) {
                        for (HKDropMenuModel * model in dropMenuSectionModel.dataArray) {
                                model.tagSeleted = NO;
                                if (model.tagId == contentModel.tagId) {
                                    model.tagSeleted = contentModel.cellSeleted;
                                    model.indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
                                    tempModel = model;
                                }
                        }
                    }
                }
                if (tempModel) {
                    [self setSelectSectionModel:tempModel];
                    
                    
                    
                    HKDropMenuModel *dropMenuTitleModel = [self.titles lastObject];
                    HKDropMenuModel *dropMenuSectionModel = dropMenuTitleModel.sections[tempModel.indexPath.section];
                    //dropMenuTitleModel为筛选菜单的总model，这里取出筛选菜单对应的区model
                    //dropMenuTitleModel.sections为筛选菜单的总数组
//                    HKDropMenuModel *dropMenuSectionModel = [dropMenuTitleModel.sections by_ObjectAtIndex: dropMenuModel.indexPath.section];
                    /** 处理多选 单选*/
                    //处理点击的model和所在区数组的映射关系
                    [self actionSectionHeaderDetailsWithDropMenuModel:tempModel dropMenuSectionModel:dropMenuSectionModel];


                }
            }
            [self resetMenuStatus];
            [self.tagCollectionView reloadData];
        }
    }
}

- (void)synchronizationToFiltrateMenu{
    if (self.isCategory) {
        HKDropMenuModel *dropM = self.titles[self.currentIndex];
        HKDropMenuModel *dropMenuModel = self.titles[6];
        for (HKDropMenuModel * model in dropMenuModel.sections) {
            for (HKDropMenuModel * m in model.dataArray) {
                if ([m.tagName isEqualToString:dropM.title]) {
                    m.tagSeleted = dropM.titleSeleted;
                }
            }
        }
    }
}

//点击确定筛选菜单确定按钮
- (void)clickButton: (UIButton *)button {
    HKDropMenuModel *dropMenuTitleModel = [self.titles by_ObjectAtIndex:self.currentIndex];
    
    if (button.tag == HKDropMenuButtonTypeSure) {
        [MobClick event:list_save_prime];
        // 删除保存的数据
        [HKDropMenuData deleteAccount];
        self.isNeedReset = NO;
        
        [self resetMenuStatus];
        NSMutableArray *dataArray = [NSMutableArray array];
        for (HKDropMenuModel *dropMenuSectionModel in dropMenuTitleModel.sections) {            
            for (HKDropMenuModel *dropMenuTagModel in dropMenuSectionModel.dataArray) {
                if (dropMenuTagModel.tagSeleted) {
                    dropMenuTagModel.key =dropMenuSectionModel.key;
                    [dataArray addObject:dropMenuTagModel];
                }
            }
        }
        
//        BOOL haveSeris = NO;
//        for (HKDropMenuModel *dropMenuTagModel in dataArray) {
//            if ([dropMenuTagModel.tagName isEqualToString:@"系列课"]) {
//                haveSeris = YES;
//            }
//        }
//        if (self.titles.count >= 5) {
//            HKDropMenuModel *dropMenuTitleModel = self.titles[4];
//            dropMenuTitleModel.titleSeleted = haveSeris;
//        }
//
//        BOOL haveTuWen = NO;
//        for (HKDropMenuModel *dropMenuTagModel in dataArray) {
//            if ([dropMenuTagModel.tagName isEqualToString:@"图文教程"]) {
//                haveTuWen = YES;
//            }
//        }
//        if (self.titles.count >= 6) {
//            HKDropMenuModel *dropMenuTitleModel = self.titles[5];
//            dropMenuTitleModel.titleSeleted = haveTuWen;
//        }
        
        if (self.isCategory) {//分类页单独处理
            if (dataArray.count) {
                
                //外层没有标签相同的标签
                for (HKDropMenuModel * menuModel in self.titles) {
                    if ([menuModel.key isEqualToString:@"tag_id"] || [menuModel.key isEqualToString:@"software_tag_id"]) {
                        menuModel.title = [menuModel.key isEqualToString:@"tag_id"] ? @"内容" : @"软件";
                    }
                }
                
                for (HKDropMenuModel *dropMenuTagModel in dataArray) {
                    if ([dropMenuTagModel.key isEqualToString:@"tag_id"] || [dropMenuTagModel.key isEqualToString:@"software_tag_id"]) {
                        //外层有相同的标签
                        for (HKDropMenuModel * menuModel in self.titles) {
                            if ([menuModel.key isEqualToString:dropMenuTagModel.key]) {
                                for (HKDropMenuModel * model in menuModel.dataArray) {
                                    model.cellSeleted = NO;
                                    if (model.tagId == dropMenuTagModel.tagId) {
                                        model.cellSeleted = !model.cellSeleted;
                                        //model.title = dropMenuTagModel.tagName;
                                        menuModel.title = dropMenuTagModel.tagName;
                                    }
                                }
                            }
                        }
                    }
                    else{
//                        if (dropMenuTagModel.level == 3) return;
//                        //外层没有标签相同的标签
//                        for (HKDropMenuModel * menuModel in self.titles) {
//                            if ([menuModel.key isEqualToString:@"tag_id"] || [menuModel.key isEqualToString:@"software_tag_id"]) {
//                                for (HKDropMenuModel * model in menuModel.dataArray) {
//                                    model.cellSeleted = NO;
//                                    menuModel.title = [menuModel.key isEqualToString:@"tag_id"] ? @"内容" : @"软件";
//                                }
//                            }
//                        }
                    }
                }
            }else{
                //外层没有标签相同的标签
                for (HKDropMenuModel * menuModel in self.titles) {
                    if ([menuModel.key isEqualToString:@"tag_id"] || [menuModel.key isEqualToString:@"software_tag_id"]) {
                        for (HKDropMenuModel * model in menuModel.dataArray) {
                            model.cellSeleted = NO;
                            menuModel.title = [menuModel.key isEqualToString:@"tag_id"] ? @"内容" : @"软件";
                        }
                    }
                }
            }
        }
        
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dropMenu:tagArray:)]) {
            [self.delegate dropMenu:self tagArray:dataArray.copy];
        }
        if (self.dropMenuTagArrayBlock) {
            self.dropMenuTagArrayBlock(dataArray.copy);
        }
    } else if (button.tag == HKDropMenuButtonTypeReset) {
        
        // 删除保存的数据
        [HKDropMenuData deleteAccount];
        self.isNeedReset = NO;
        dropMenuTitleModel.isHaveSectionSeleted = NO;
        
        [dropMenuTitleModel.sections enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HKDropMenuModel *dropMenuSectionModel =  (HKDropMenuModel*)obj;
            dropMenuSectionModel.sectionHeaderDetails = @"";
            
            if (HKDropMenuFilterCellClickTypeQuit == dropMenuSectionModel.filterClickType) {
                if (NO == dropMenuSectionModel.isTop) {
                    [dropMenuTitleModel.sections removeObjectAtIndex:idx];
                }
                for (HKDropMenuModel *dropMenuTagModel in dropMenuSectionModel.dataArray) {
                    dropMenuTagModel.tagSeleted = NO;
                }
                
            }else{
                for (HKDropMenuModel *dropMenuTagModel in dropMenuSectionModel.dataArray) {
                    // 不能取消 选中
                    if (dropMenuTagModel.tagId) {
                        dropMenuTagModel.tagSeleted = NO;
                    }else{
                        // 第一个 tag (tagId == 0)
                        //dropMenuTagModel.tagSeleted = YES;
                    }
                }
            }
        }];
        [self.filter reloadData];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dropMenu:reset:)]) {
            [self.delegate dropMenu:self reset:YES];
        }
    }
}


- (void)clickControl {
    
    [self resetMenuStatus];
}


#pragma mark - 懒加载
- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = COLOR_FFFFFF_3D4752;
        _bottomView.frame = CGRectMake(self.filter.frame.origin.x, self.filter.frame.size.height + self.filter.frame.origin.y + kFilterButtonHeight,self.filter.frame.size.width , kGHSafeAreaBottomHeight);
    }
    return _bottomView;
}

- (UIControl *)titleCover {
    if (_titleCover == nil) {
        _titleCover = [[UIControl alloc]init];
        _titleCover.frame = CGRectMake(0, self.frame.size.height + kGHSafeAreaTopHeight, kScreenWidth, 0);
        [_titleCover addTarget:self action:@selector(clickControl) forControlEvents:UIControlEventTouchUpInside];
        
//        [_titleCover addTarget:self action:@selector(clickControl) forControlEvents:UIControlEventTouchDown];
//        [_titleCover addTarget:self action:@selector(clickControl) forControlEvents:UIControlEventTouchCancel];
//        [_titleCover addTarget:self action:@selector(clickControl) forControlEvents:UIControlEventTouchUpOutside];
//        [_titleCover addTarget:self action:@selector(clickControl) forControlEvents:UIControlEventTouchDragInside];
        
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
        _reset.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_ffffff dark:COLOR_3D4752];
        //[UIColor whiteColor];
        [_reset setTitle:@"重置" forState:UIControlStateNormal];
        
        [_reset setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
        [_reset setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_reset addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        _reset.tag = HKDropMenuButtonTypeReset;
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = COLOR_F8F9FA_333D48;
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

-(UICollectionView *)tagCollectionView{
    if (_tagCollectionView == nil) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 0.01f;
        layout.minimumLineSpacing = 0.01f;
        
        _tagCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.tableY, SCREEN_WIDTH, 0) collectionViewLayout:layout];
        _tagCollectionView.delegate = self;
        _tagCollectionView.dataSource = self;
        //_tagCollectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _tagCollectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        [_tagCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKDropMenuTagCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKDropMenuTagCell class])];
    }
    return _tagCollectionView;
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
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumLineSpacing = 0.01f;
        _flowLayout.minimumInteritemSpacing = 10.0f;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return _flowLayout;
}


- (UICollectionView *)filter {
    if (_filter == nil) {
        _filter = [[UICollectionView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.1, 0, kScreenWidth * 0.9, kScreenHeight - kFilterButtonHeight - kGHSafeAreaBottomHeight) collectionViewLayout:self.filterFlowLayout];
        _filter.delegate = self;
        _filter.dataSource = self;
        _filter.contentInset = UIEdgeInsetsMake(32, 25, 0, 25);
        _filter.backgroundColor = COLOR_FFFFFF_3D4752;
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
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKDropMenuItemCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKDropMenuItemCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKDropMenuTypeCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKDropMenuTypeCell class])];
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
    }
    return _collectionView;
}


- (HKSearchSortView *)sortView{
    if (_sortView  == nil) {
        _sortView = [HKSearchSortView viewFromXib];
        _sortView.frame = CGRectMake(0, 0, kScreenWidth, self.menuHeight);
        //_sortView.backgroundColor = [UIColor blackColor];
        _sortView.delegate = self;
    }
    return _sortView;
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
        //_bottomLine.backgroundColor = COLOR_F8F9FA_333D48;
        _bottomLine.backgroundColor = [UIColor clearColor];

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


- (NSArray <NSString*>* )defalutTagArr {
    if (_defalutTagArr == nil) {
        _defalutTagArr = [NSArray array];
    }
    return _defalutTagArr;
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
    //if (isEmpty(categoryId)) return;
    
    
    [[VideoServiceMediator sharedInstance] getVideoTagList:categoryId  completion:^(FWServiceResponse *response) {
        
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
            NSData *data = [[response.data objectForKey:@"list"] mj_JSONData];
            self.tagArr =[TagModel mj_objectArrayWithKeyValuesArray:data];
            self.defalutTagArr = [self.configuration.defaultSelectedTag componentsSeparatedByString:@","];
            
            [self.tagArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(TagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TagModel *tagModel = obj;
                if (tagModel.children.count) {
                    //将每个 section 第一个 标记 选中
                    if (HKDropMenuFilterCellClickTypeQuit == self.configuration.filterClickType) {
                        
                    }else{
                        tagModel.children[0].isSelect = YES;
                    }
                    //查找默认选中的 tag
                    if (self.defalutTagArr.count) {
                        // 切割默认tag
                       __block BOOL isFind = NO;
                        
                        for (ChildrenModel *tempM in tagModel.children) {
                            
                            [self.defalutTagArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                NSString *defaultSelectedTag = obj;
                                if ([tempM.ID isEqualToString:defaultSelectedTag]) {
                                    tempM.isSelect = YES;
                                    isFind = YES;
                                    *stop = YES;
                                }else{
                                    tempM.isSelect = NO;
                                }
                            }];
                        }
                        
                        if (NO ==isFind) {
                            // 不存在选择 tag
                            if (HKDropMenuFilterCellClickTypeQuit == self.configuration.filterClickType) {
                                
                            }else{
                                tagModel.children[0].isSelect = YES;
                            }
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
    if (self.isCategory) {
        self.currentIndex = self.titles.count-1;
    }
    /** 设置构造右侧弹出筛选菜单每行的标题 */
    NSMutableArray *sections = [NSMutableArray array];
    HKDropMenuModel *defalutSelectM = nil;
    NSInteger defalutIndex = -1;
    
    for (NSInteger index = 0; index < self.tagArr.count; index++) {
        TagModel *tagM = self.tagArr[index];
        
        HKDropMenuModel *dropMenuModel = [[HKDropMenuModel alloc]init];
        dropMenuModel.sectionHeaderTitle = tagM.name;
        dropMenuModel.filterCellType = HKDropMenuFilterCellTypeTag;
        if (HKDropMenuFilterCellClickTypeQuit == self.configuration.filterClickType) {
            dropMenuModel.filterClickType = HKDropMenuFilterCellClickTypeQuit;
        }
        dropMenuModel.level = tagM.level;
        dropMenuModel.tagId = [tagM.ID integerValue];
        dropMenuModel.key = tagM.keyWord;
        dropMenuModel.arrIndex = index;
        dropMenuModel.isTop = YES;
        
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSInteger index = 0 ; index < tagM.children.count; index++) {
            
            ChildrenModel *childM = tagM.children[index];
            
            HKDropMenuModel *children = [[HKDropMenuModel alloc]init];
            
            children.tagSeleted = childM.isSelect;
            children.tagId = [childM.ID integerValue];
            children.tagName = childM.name;
            children.children = childM.children;
            children.level = childM.level;
            children.parent_id = childM.parent_id;
            
            children.arrIndex = dropMenuModel.arrIndex;
            
            if (HKDropMenuFilterCellClickTypeQuit == self.configuration.filterClickType) {
                children.filterClickType = HKDropMenuFilterCellClickTypeQuit;
            }
            
            if (children.tagSeleted) {
                // section 标题
                dropMenuModel.sectionHeaderDetails = children.tagName;
                defalutSelectM = children;
                defalutIndex = dropMenuModel.arrIndex +1;
            }
            [tempArr addObject:children];
        }
        
        dropMenuModel.dataArray = tempArr;
        [sections addObject:dropMenuModel];
    }
    
    if (HKDropMenuFilterCellClickTypeQuit == self.configuration.filterClickType) {
        
        // 插入默认 选中的tag model
        HKDropMenuModel *model = [self defalutMenuModel:defalutSelectM];
        if (model) {
            // 第一个默认tag
            [sections insertObject:model atIndex:defalutIndex];
            // 默认tag
            for (int i = 0 ; i < self.defalutTagArr.count; i++) {
                //if (i >0) {
                    NSString *tagId = self.defalutTagArr[i];
                    for (HKDropMenuModel *childM in model.dataArray) {
                        if([tagId integerValue] == childM.tagId) {
                            model.sectionHeaderDetails = childM.tagName;
                            defalutIndex += 1;
                            HKDropMenuModel *tempM = [self defalutMenuModel:childM];
                            if (tempM) {
                                [sections insertObject:tempM atIndex:defalutIndex];
                            }
                            //model = tempM;
                            break;
                        }
                    }
                //}
            }
        }
    }
    
    for (HKDropMenuModel *dropMenuModel in self.titles) {
        if (HKDropMenuTypeFilter == dropMenuModel.dropMenuType) {
            dropMenuModel.sections = sections;
            dropMenuModel.isHaveSectionSeleted = NO;
            
            BOOL isHave = NO;
            for (HKDropMenuModel *model in dropMenuModel.sections) {
                for (HKDropMenuModel *childM in model.dataArray) {
                    if (childM.tagSeleted) {
                        isHave = YES;
                        dropMenuModel.isHaveSectionSeleted = YES;
                        break;
                    }
                    if (isHave) {
                        break;
                    }
                }
            }
        }
    }
    
        if (self.isCategory) {
            if (self.defalutTagArr.count && [self.defalutTagArr containsObject:@"100000"] && self.titles.count != 0) {
                
                for (int i = 0; i <self.titles.count; i++) {
                    HKDropMenuModel *dropMenuTitleModel = [self.titles by_ObjectAtIndex: i];
                    if ([dropMenuTitleModel.title isEqualToString:@"筛选"] && dropMenuTitleModel.sections.count) {
                        HKDropMenuModel *dropMenuSectionModel = [dropMenuTitleModel.sections by_ObjectAtIndex: 0];
                        if (dropMenuSectionModel.dataArray.count) {
                            HKDropMenuModel * itemModel = dropMenuSectionModel.dataArray[0];
                            itemModel.tagSeleted = YES;
                        }
                    }
                }
            }
            
            
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIButton * btn = [UIButton new];
            btn.tag = 1;
            [self clickButton:btn];
        });
    }
}





- (HKDropMenuModel *)defalutMenuModel:(HKDropMenuModel *)selectM {
    
    HKDropMenuModel *menuModel = selectM;
    menuModel.tagSeleted = YES;
    
    if (nil == menuModel) {
        return nil;
    }
    
    if (0 == menuModel.children.count) {
        return nil;
    }
    
    /** 构造选中的数据 */
    HKDropMenuModel *tempM = [[HKDropMenuModel alloc]init];
    tempM.sectionHeaderTitle = menuModel.tagName;
    tempM.tagId = menuModel.tagId;
    tempM.arrIndex = menuModel.arrIndex;
    
    tempM.filterCellType = HKDropMenuFilterCellTypeTag;
    tempM.filterClickType = HKDropMenuFilterCellClickTypeQuit;
    tempM.parent_id = [NSString stringWithFormat:@"%ld",(long)menuModel.tagId];
    
    NSMutableArray *childrenArr = [NSMutableArray array];
    for (ChildrenModel *model in menuModel.children) {
        
        HKDropMenuModel *childrenM = [[HKDropMenuModel alloc]init];
        childrenM.tagId = [model.ID integerValue];
        childrenM.sectionHeaderTitle = model.name;
        
        childrenM.filterCellType = HKDropMenuFilterCellTypeTag;
        childrenM.filterClickType = HKDropMenuFilterCellClickTypeQuit;
        
        childrenM.children = model.children;
        childrenM.level = model.level;
        
        childrenM.tagName = model.name;
        childrenM.arrIndex = tempM.arrIndex;
        
        [childrenArr addObject:childrenM];
        tempM.level = model.level;
    }
    
    tempM.dataArray = childrenArr;
    return tempM;
}

-(void)searchSortViewDidfiltrateBtn:(HKDropMenuModel *)dropMenuModel{
    //  HKDropMenuTypeEnableTitle 禁止点击
    if (dropMenuModel.dropMenuType != HKDropMenuTypeEnableTitle) {
        dropMenuModel.titleSeleted = !dropMenuModel.titleSeleted;
        self.currentIndex = 1;
        
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
        
        if ([self.delegate respondsToSelector:@selector(dropMenu:itemIndex:)]) {
            [self.delegate dropMenu:self itemIndex:self.currentIndex];
        }
    }
}

- (void)searchSortViewDidSortBtn:(HKDropMenuModel *)dropModel{
    HKDropMenuModel *dropMenuModel = nil;
    HKDropMenuModel *contentModel = dropModel;
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


- (void)dealloc {
    NSLog(@"释放了");
}

@end


