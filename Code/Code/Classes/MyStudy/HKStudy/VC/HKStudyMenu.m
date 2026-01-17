//
//  HKStudyMenu.m
//  Code
//
//  Created by Ivan li on 2019/3/22.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKStudyMenu.h"
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


@interface HKStudyMenu()<UICollectionViewDelegate,UICollectionViewDataSource,
HKDropMenuItemDelegate,HKDropMenuFilterItemDelegate,HKDropMenuFilterHeaderDelegate>

/** 装顶部菜单的数组 */
@property (nonatomic , strong) NSMutableArray *titles;
/** 弹出菜单内容数组 */
@property (nonatomic , strong) NSMutableArray *contents;
/** 弹出菜单选中index */
@property (nonatomic , assign) NSInteger currentIndex;
/** 筛选器 */
@property (nonatomic , strong) UICollectionView *filter;

@property (nonatomic , strong) UICollectionViewFlowLayout *filterFlowLayout;

@property (nonatomic , strong) NSIndexPath *currentIndexPath;

@property (nonatomic , copy) DropMenuTitleBlock dropMenuTitleBlock;

@property (nonatomic , copy) DropMenuTagArrayBlock dropMenuTagArrayBlock;

@property (nonatomic , assign) HKDropMenuShowType dropMenuShowType;

@property(nonatomic,strong)NSMutableArray <TagModel*> *tagArr; // 保存标签
/** 默认标签 */
@property(nonatomic,copy)NSArray <NSString*> *defalutTagArr;

@end


@implementation HKStudyMenu
#pragma mark - 初始化
+ (instancetype)creatDropFilterMenuWidthConfiguration: (HKDropMenuModel *)configuration
                                dropMenuTagArrayBlock: (DropMenuTagArrayBlock)dropMenuTagArrayBlock {
    HKStudyMenu *dropMenu = [[HKStudyMenu alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight)];
    dropMenu.dropMenuShowType = HKDropMenuShowTypeOnlyFilter;
    dropMenu.titles = configuration.titles.mutableCopy;
    dropMenu.dropMenuTagArrayBlock = dropMenuTagArrayBlock;
    [dropMenu setupFilterUI];
    return dropMenu;
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
}



- (void)setConfiguration:(HKDropMenuModel *)configuration {
    _configuration = configuration;
    self.titles = configuration.titles;
    
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
    
    self.currentIndex = 0;
}



#pragma mark - 弹出
- (void)show {
    
    HKDropMenuModel *dropMenuTitleModel = [self.titles by_ObjectAtIndex:self.currentIndex];
    if (dropMenuTitleModel.dropMenuType == HKDropMenuTypeFilter ) {
        //获取分类 tag
        [self getSortTagWithId:self.configuration.categoryId refreshFilter:YES];
    }
    
    [self.filter reloadData];
}


#pragma mark - 创建UI 添加控件

- (void)setupFilterUI {
    
    [kKeyWindow addSubview:self.filter];
}





/** 重置menu 状态 */
- (void)resetMenuStatus {
    for (HKDropMenuModel *dropMenuModel in self.titles) {
        dropMenuModel.titleSeleted = NO;
    }
    [self.filter reloadData];
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
    
    //    }else{
    //        // 选中的 tag （不能取消选中）
    //        dropMenuModel.tagSeleted = YES;
    //    }
    
}



#pragma mark - 选中tag  构造下一级数据
- (void)setSelectSectionModel:(HKDropMenuModel *)dropMenuModel {
    
    __block HKDropMenuModel *selectM = dropMenuModel;
    /** 第一层数组 */
    HKDropMenuModel *dropMenuTitleModel = [self.titles by_ObjectAtIndex: self.currentIndex];
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
    HKDropMenuModel *dropMenuTitleModel = [self.titles by_ObjectAtIndex: self.currentIndex];
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
            //[self dismiss];
        }
    }
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
    if (collectionView == self.filter) {
        
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
    HKDropMenuModel *dropMenuTitleModel = [self.titles by_ObjectAtIndex:self.currentIndex];
    if (self.filter == collectionView) {
        
        return dropMenuTitleModel.sections.count;
    }else {
        return 0;
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
   if (self.filter == collectionView) {
        
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
    
    if (collectionView == self.filter) {
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
    } else if (button.tag == HKDropMenuButtonTypeReset) {

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




- (UICollectionViewFlowLayout *)filterFlowLayout {
    if (_filterFlowLayout == nil) {
        _filterFlowLayout = [[UICollectionViewFlowLayout alloc]init];
        _filterFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _filterFlowLayout.minimumInteritemSpacing = 10.0f;
        _filterFlowLayout.minimumLineSpacing = 15.0f;
    }
    return _filterFlowLayout;
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
    
    
    [[VideoServiceMediator sharedInstance] getVideoTagList:categoryId  completion:^(FWServiceResponse *response) {
        
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
            NSData *data = [[response.data objectForKey:@"list"] mj_JSONData];
            self.tagArr =[TagModel mj_objectArrayWithKeyValuesArray:data];
            self.defalutTagArr = [self.configuration.defaultSelectedTag componentsSeparatedByString:@","];
            
            [self.tagArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(TagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (obj.children.count) {
                    //将每个 section 第一个 标记 选中
                    if (HKDropMenuFilterCellClickTypeQuit == self.configuration.filterClickType) {
                        
                    }else{
                        obj.children[0].isSelect = YES;
                    }
                    //查找默认选中的 tag
                    if (self.defalutTagArr.count) {
                        // 切割默认tag
                        NSString *defaultSelectedTag = self.defalutTagArr[0];
                        
                        BOOL isFind = NO;
                        for (ChildrenModel *tempM in obj.children) {
                            if ([tempM.ID isEqualToString:defaultSelectedTag]) {
                                tempM.isSelect = YES;
                                isFind = YES;
                                break;
                            }else{
                                tempM.isSelect = NO;
                            }
                        }
                        if (NO ==isFind) {
                            // 不存在选择 tag
                            if (HKDropMenuFilterCellClickTypeQuit == self.configuration.filterClickType) {
                                
                            }else{
                                obj.children[0].isSelect = YES;
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
                if (i >0) {
                    NSString *tagId = self.defalutTagArr[i];
                    for (HKDropMenuModel *childM in model.dataArray) {
                        if([tagId integerValue] == childM.tagId) {
                            defalutIndex += 1;
                            HKDropMenuModel *tempM = [self defalutMenuModel:childM];
                            if (tempM) {
                                [sections insertObject:tempM atIndex:defalutIndex];
                            }
                            model = tempM;
                            break;
                        }
                    }
                }
            }
        }
    }
    
    for (HKDropMenuModel *dropMenuModel in self.titles) {
        if (HKDropMenuTypeFilter == dropMenuModel.dropMenuType) {
            dropMenuModel.sections = sections;
        }
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




- (void)dealloc {
    NSLog(@"释放了");
}

@end

