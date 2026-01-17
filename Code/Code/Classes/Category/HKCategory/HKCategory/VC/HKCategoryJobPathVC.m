//  职业路径
//  HKCategoryJobPathVC.m
//  Code
//
//  Created by ivan on 2020/6/16.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKCategoryJobPathVC.h"
#import "HKCategoryRightView.h"
#import "HKCategoryTreeModel.h"
#import "HKLiveListModel.h"
#import "HKLiveCourseVC.h"
#import "HKCategoryJobPathCell.h"
#import "HKJobPathVC.h"
#import "HKCategoryJobPathModel.h"
#import "HKJobPathModel.h"
#import "HKCategoryJobPathFootView.h"
#import "UIImage+Extension.h"


@interface HKCategoryJobPathVC ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)HKcategoryModel *categorymodel;

@property(nonatomic,strong)NSMutableArray <HKCategoryJobPathModel*>*dataArr;

@property(nonatomic,assign)NSInteger page;

@end


@implementation HKCategoryJobPathVC



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



- (NSMutableArray <HKCategoryJobPathModel*>*)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return  _dataArr;
}



- (void)refreshUI {
    @weakify(self);
    [HKRefreshTools headerRefreshWithTableView:self.collectionView completion:^{
        @strongify(self);
        [self loadData];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.collectionView completion:^{
        @strongify(self);
        [self loadMoreData];
    }];
}



- (void)loadData {
    self.page = 1;
    //NSDictionary *param =  @{@"page" : @(self.page)};
    NSDictionary *param = @{@"id" : [NSNumber numberWithInt:self.ID],@"page" : @(self.page)};
    [HKHttpTool POST:HK_CategoryRightTypeMenu_URL parameters:param success:^(id responseObject) {
        [self.collectionView.mj_footer resetNoMoreData];
        [self.collectionView.mj_header endRefreshing];
        if (HKReponseOK) {
            // 广告信息
            HKMapModel *adsModel = [HKMapModel mj_objectWithKeyValues:responseObject[@"data"][@"bannerInfo"]];
            HKcategoryModel *model = [[HKcategoryModel alloc] init];
            model.banner_url = adsModel.image_url;
            model.bannerInfo = adsModel;
            
            self.categorymodel = model;
            NSMutableArray *arr = [HKCategoryJobPathModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"class_4"]];
            self.dataArr = arr;
            
            // 分页信息
            HKJobPathPageInfoModel *pageModel = [HKJobPathPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            
            if (self.page >= pageModel.page_total) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
    }];
}



- (void)loadMoreData {
    self.page = (1 == self.page) ?2 :self.page;
    NSDictionary *param = @{@"id" : [NSNumber numberWithInt:self.ID],@"page" : @(self.page)};
    [HKHttpTool POST:HK_CategoryRightTypeMenu_URL parameters:param success:^(id responseObject) {
        [self.collectionView.mj_footer endRefreshing];
        if (HKReponseOK) {
            
            NSMutableArray *arr  = [HKCategoryJobPathModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            [self.dataArr addObjectsFromArray:arr];
            
            HKJobPathPageInfoModel *pageModel = [HKJobPathPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (self.page >= pageModel.page_total) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            self.page++;
            [self.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
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
         
        [_collectionView registerClass:[HKCategoryJobPathCell class] forCellWithReuseIdentifier:NSStringFromClass([HKCategoryJobPathCell class])];
        //head
        [_collectionView registerClass:[HKCategoryRightHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKCategoryRightHeaderView"];
        [_collectionView registerClass:[HKCategoryJobPathFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([HKCategoryJobPathFootView class])];
        _collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        HKAdjustsScrollViewInsetNever(self, _collectionView);
    }
    return _collectionView;
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger count = self.dataArr.count;
    return count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKCategoryJobPathModel *model = self.dataArr[indexPath.section];
    HKCategoryJobPathCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKCategoryJobPathCell class])forIndexPath:indexPath];
    cell.model = model;
    
    //is_night  1为夜间模式 0为非夜间模式
    BOOL is_night ;
    if (@available(iOS 13.0, *)) {
           DMUserInterfaceStyle mode = DMTraitCollection.currentTraitCollection.userInterfaceStyle;
           is_night = (DMUserInterfaceStyleDark == mode) ? YES :NO;
       }
    cell.bgIV.image = [UIImage resizableImageWithName:(is_night ? @"bg_careerlist_v2_13_dark" : @"bg_careerlist_v2_13")];
    return cell;
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        @weakify(self);
        HKCategoryRightHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKCategoryRightHeaderView" forIndexPath:indexPath];
        
        headerView.categoryRightHeaderViewBlock = ^(HKcategoryListModel *model, HKcategoryModel *categoryModel) {
            @strongify(self);
            [HKH5PushToNative runtimePush:categoryModel.bannerInfo.redirect_package.class_name arr:categoryModel.bannerInfo.redirect_package.list currectVC:self];
        };
        headerView.categoryRightHeaderBtnClickBlock = ^(HKcategoryListModel *model, HKMapModel *mapModel) {
            @strongify(self);
            [MobClick event:fenleiye_zhiyelujing_more];
            [self pushToOtherController:[HKJobPathVC new]];
        };
        
        HKcategoryModel *model = self.categorymodel;
        headerView.arrowBtn.hidden = NO;
        headerView.categoryModel = model;
        [headerView setcategoryLabelText:@"热门职业"];
        
        [headerView hiddenBottomLine:YES];
        if (0 == indexPath.section) {
            headerView.headermageView.hidden = !self.categorymodel.bannerInfo.is_show;
        }else{
            headerView.headermageView.hidden = YES;
        }
        return headerView;
        
    } else {
        HKCategoryJobPathFootView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([HKCategoryJobPathFootView class]) forIndexPath:indexPath];
        return footView;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionView.width-10, 130);
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 0, 5);
}


#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
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
    return  CGSizeMake(collectionView.width, 0);
}

/** foot */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {

    NSInteger count = self.dataArr.count;
    return  CGSizeMake(collectionView.width, (section == (count -1)) ?0 :10);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [MobClick event:fenleiye_zhiyelujing_zhiye];
    HKCategoryJobPathModel *model = self.dataArr[indexPath.section];
    if (!isEmpty(model.career_id)) {
        [HKH5PushToNative runtimePush:model.redirect_package.class_name arr:model.redirect_package.list currectVC:self];
    }
}

//// 夜间模式主题模式 发生改变
- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    if (@available(iOS 13.0, *)) {
        [self.collectionView reloadData];
    }
}
@end
