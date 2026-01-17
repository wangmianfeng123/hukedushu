//  软件入门
//  HKCategorySoftwareVC.m
//  Code
//
//  Created by ivan on 2020/6/15.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKCategorySoftwareVC.h"
#import "HKCategorySoftwareCell.h"
#import "HKCategoryRightView.h"
#import "HKInternetSchoolCell.h"
#import "HKCategoryTreeModel.h"
#import "HKLiveListModel.h"
#import "HKLiveCourseVC.h"
#import "HKSoftwareVC.h"
#import "HKCategoryVC.h"

@interface HKCategorySoftwareVC ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)HKcategoryModel *categorymodel;

@end


@implementation HKCategorySoftwareVC



- (instancetype)initWitFrame:(CGRect)rect {
    self = [super init];
    if (self) {
        self.view.frame = rect;
        [self createUI];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createUI {
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
    [self refreshUI];
}


- (void)refreshUI {
    @weakify(self);
    [HKRefreshTools headerRefreshWithTableView:self.collectionView completion:^{
        @strongify(self);
        HKCategoryVC * vc = (HKCategoryVC *)self.parentViewController;
        if (!vc.leftModelArr.count) {
            [vc loadCatagoryData];
        }
        
        [self loadData];
    }];
}

- (void)loadData {
    //1-软件入门 2-设计教程 3-职业发展 4-虎课读书
    NSDictionary *param = @{@"id" : [NSNumber numberWithInt:_ID]};
    [HKHttpTool POST:HK_CategoryRightTypeMenu_URL parameters:param success:^(id responseObject) {
        [self.collectionView.mj_header endRefreshing];
        if (HKReponseOK) {
            HKcategoryModel *model = [HKcategoryModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.categorymodel = model;
            [self.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
    }];
}




- (void)refreshData {
    if (0 == self.collectionView.numberOfSections) {
        [self loadData];
    }
}


- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
        _collectionView.alwaysBounceVertical = YES;
         
        [_collectionView registerClass:[HKCategorySoftwareCell class] forCellWithReuseIdentifier:NSStringFromClass([HKCategorySoftwareCell class])];
        //head
        [_collectionView registerClass:[HKCategoryRightHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKCategoryRightHeaderView"];
        [_collectionView registerClass:[HKCategoryRightFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HKCategoryRightFooterView"];
        _collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        HKAdjustsScrollViewInsetNever(self, _collectionView);
    }
    return _collectionView;
}



- (NSInteger)numberOfSection {
    
    NSInteger count = 0;
    count += self.categorymodel.class_0.count;
//    count += self.categorymodel.class_b.count;
//    count += self.categorymodel.class_c.count;
//    count += self.categorymodel.class_d.count;
    return count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [self numberOfSection];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    
    HKcategoryListModel * model = self.categorymodel.class_0[section];
    
    return  model.list.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    HKcategoryChilderenModel *model = self.categorymodel.class_0[section].list[row];
    HKCategorySoftwareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKCategorySoftwareCell class]) forIndexPath:indexPath];
    cell.childerenModel = model;
    [cell showBottomLine:row];
    return cell;
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    @weakify(self);
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        HKCategoryRightHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKCategoryRightHeaderView" forIndexPath:indexPath];
        
        headerView.categoryRightHeaderViewBlock = ^(HKcategoryListModel *model, HKcategoryModel *categoryModel) {
            @strongify(self);
            [MobClick endEvent:um_fenleiye_ruanjian_banner];
            [HKH5PushToNative runtimePush:categoryModel.bannerInfo.redirect_package.class_name arr:categoryModel.bannerInfo.redirect_package.list currectVC:self];
        };
        headerView.categoryRightHeaderBtnClickBlock = ^(HKcategoryListModel *model, HKMapModel *mapModel) {
            
        };
        
        HKcategoryModel *model = self.categorymodel;
        headerView.arrowBtn.hidden = YES;
        headerView.categoryModel = model;
        headerView.listModel = model.class_0[indexPath.section];
        if (0 == indexPath.section) {
            [headerView hiddenBottomLine:YES];
            headerView.headermageView.hidden = !self.categorymodel.bannerInfo.is_show;
        }else{
            [headerView hiddenBottomLine:NO];
            headerView.headermageView.hidden = YES;
        }
        return headerView;
        
    } else {
        
        HKCategoryRightFooterView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HKCategoryRightFooterView" forIndexPath:indexPath];
        footView.categoryRightFooterViewBlock = ^(id model) {
            @strongify(self);
            HKSoftwareVC *VC = [HKSoftwareVC new];
            [self pushToOtherController:VC];
        };
        return footView;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IPAD) {
        return CGSizeMake(100, 85);
    }else{
        CGFloat width = floor((collectionView.width - 15 -20)/3);
        return  CGSizeMake(width, 85);
    }
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 0, 0, 0);
}


#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}


/** head */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        if (self.categorymodel.bannerInfo.is_show) {
            return  CGSizeMake(collectionView.width, 55+80*Ratio);
        }else{
            return  CGSizeMake(collectionView.width, 55);
        }
    }
    return  CGSizeMake(collectionView.width, 44);
}

/** foot */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {

    return  CGSizeZero;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    HKcategoryChilderenModel *model  = self.categorymodel.class_0[section].list[row];
    [self umSoftwareClickWithIndexPath:indexPath childerenModel:model];
    
    [HKH5PushToNative runtimePush:model.redirect.class_name arr:model.redirect.list currectVC:self];
}


/// 软件入门 统计
- (void)umSoftwareClickWithIndexPath:(NSIndexPath *)indexPath  childerenModel:(HKcategoryChilderenModel *)childerenModel {
    
    switch (indexPath.section) {
        case 0:
            [MobClick event: childerenModel.is_more ?um_fenleiye_ruanjian_morebiaoqianyi :um_fenleiye_ruanjian_biaoqianyi];
            break;
            
        case 1:
            [MobClick event:childerenModel.is_more ?um_fenleiye_ruanjian_morebiaoqianer :um_fenleiye_ruanjian_biaoqianer];
            break;
        
        case 2:
            [MobClick event:childerenModel.is_more ? um_fenleiye_ruanjian_morebiaoqiansan :um_fenleiye_ruanjian_biaoqiansan];
            break;
        
        case 3:
            [MobClick event:childerenModel.is_more ?um_fenleiye_ruanjian_morebiaoqiansi :um_fenleiye_ruanjian_biaoqiansi];
            break;
        
        case 4:
            [MobClick event:childerenModel.is_more ?um_fenleiye_ruanjian_morebiaoqianwu :um_fenleiye_ruanjian_biaoqianwu];
            break;
            
        case 5:
            [MobClick event:childerenModel.is_more ?um_fenleiye_ruanjian_morebiaoqianliu :um_fenleiye_ruanjian_biaoqianliu];
            break;
        
        case 6:
            [MobClick event:childerenModel.is_more ?um_fenleiye_ruanjian_morebiaoqianqi :um_fenleiye_ruanjian_biaoqianqi];
            break;
        
        case 7:
            [MobClick event:childerenModel.is_more ?um_fenleiye_ruanjian_morebiaoqianba :um_fenleiye_ruanjian_biaoqianba];
            break;
        
        case 8:
            [MobClick event:childerenModel.is_more ?um_fenleiye_ruanjian_morebiaoqianjiu :um_fenleiye_ruanjian_biaoqianjiu];
            break;
            
        default:
            break;
    }
}



@end
