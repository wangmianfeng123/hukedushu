//  虎课读书
//  HKCategoryReadBookVC.m
//  Code
//
//  Created by ivan on 2020/6/15.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKCategoryReadBookVC.h"
#import "HKCategorySoftwareCell.h"
#import "HKCategoryRightView.h"
#import "HKInternetSchoolCell.h"
#import "HKCategoryTreeModel.h"
#import "HKLiveListModel.h"
#import "HKLiveCourseVC.h"
#import "HKCategoryBookNewCell.h"
#import "HKJobPathModel.h"
#import "HKListeningBookVC.h"
#import "HKBookTabMainVC.h"

@interface HKCategoryReadBookVC ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)HKcategoryModel *categorymodel;

@property(nonatomic,assign)NSInteger page;

@end


@implementation HKCategoryReadBookVC


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
        [self loadData];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.collectionView completion:^{
        @strongify(self);
        [self loadMoreBook];
    }];
}



- (void)loadData {
    self.page = 1;
    NSDictionary *param = @{@"id" : [NSNumber numberWithInt:self.ID],@"page" : @(self.page)};
    [HKHttpTool POST:HK_CategoryRightTypeMenu_URL parameters:param success:^(id responseObject) {
        [self.collectionView.mj_footer resetNoMoreData];
        [self.collectionView.mj_header endRefreshing];
        if (HKReponseOK) {
            // 广告信息
            HKMapModel *adsModel = [HKMapModel mj_objectWithKeyValues:responseObject[@"data"][@"bannerInfo"]];
            
            HKcategoryModel *model = [[HKcategoryModel alloc] init];
            model.banner_url = adsModel.image_url;
            HKcategoryListModel *categoryListModel = [[HKcategoryListModel alloc] init];
            NSMutableArray *bookList = [HKBookModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"class_5"]];
            categoryListModel.bookList = bookList;
            model.class_5 = @[categoryListModel];
            model.bannerInfo = adsModel;
            
            // 分页信息
            HKJobPathPageInfoModel *pageModel = [HKJobPathPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            
            if (self.page >= pageModel.page_total) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            self.categorymodel = model;
            [self.collectionView reloadData];
            self.page++ ;
        }
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
    }];
}



- (void)loadMoreBook {
    NSDictionary *param = @{@"id" : [NSNumber numberWithInt:self.ID],@"page" : @(self.page)};
    [HKHttpTool POST:HK_CategoryRightTypeMenu_URL parameters:param success:^(id responseObject) {
        [self.collectionView.mj_footer endRefreshing];
        if (HKReponseOK) {
            HKcategoryListModel *categoryListModel = self.categorymodel.class_5.firstObject;
            NSArray *bookList = [HKBookModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"class_5"]];
            [categoryListModel.bookList addObjectsFromArray:bookList];
            
            HKJobPathPageInfoModel *pageModel = [HKJobPathPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (self.page >= pageModel.page_total) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.collectionView reloadData];
            self.page++;
        }
    } failure:^(NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
    }];
}


- (void)refreshData {
    if(0 == self.collectionView.numberOfSections) {
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
         
        [_collectionView registerClass:[HKCategoryBookNewCell class] forCellWithReuseIdentifier:NSStringFromClass([HKCategoryBookNewCell class])];
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
    count += self.categorymodel.class_5.count;
//    count += self.categorymodel.class_b.count;
//    count += self.categorymodel.class_c.count;
//    count += self.categorymodel.class_d.count;
    return count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [self numberOfSection];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return  self.categorymodel.class_5[section].bookList.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    HKCategoryBookNewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKCategoryBookNewCell class]) forIndexPath:indexPath];
    cell.model = self.categorymodel.class_5[section].bookList[indexPath.row];
    return cell;
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        @weakify(self);
        HKCategoryRightHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKCategoryRightHeaderView" forIndexPath:indexPath];
        
        headerView.categoryRightHeaderViewBlock = ^(HKcategoryListModel *model, HKcategoryModel *categoryModel) {
            @strongify(self);
            
            [MobClick event:fenleiye_hukedushu_banner];
            [HKH5PushToNative runtimePush:categoryModel.bannerInfo.redirect_package.class_name arr:categoryModel.bannerInfo.redirect_package.list currectVC:self];
        };
        headerView.categoryRightHeaderBtnClickBlock = ^(HKcategoryListModel *model, HKMapModel *mapModel) {
            
        };
        headerView.internetSchoolRightHeaderBtnClickBlock = ^(HKMapModel *mapModel, HKcategoryOnlineSchoolListModel *schoolListModel) {
            @strongify(self);
            [MobClick event:fenleiye_hukedushu_more];
            HKBookTabMainVC * VC=  [HKBookTabMainVC new];
            [self pushToOtherController:VC];
        };
        
        HKcategoryModel *model = self.categorymodel;
        headerView.arrowBtn.hidden = NO;
        headerView.categoryModel = model;
        [headerView setarrowBtnText:@"查看全部"];
        headerView.listModel = model.class_5[indexPath.section];
        headerView.categoryLabel.text = @"热门书籍";
        //[headerView.arrowBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        //[headerView.arrowBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateNormal];
        //[headerView.arrowBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateHighlighted];

        
        [headerView hiddenBottomLine:YES];
        if (0 == indexPath.section) {
            headerView.headermageView.hidden = !self.categorymodel.bannerInfo.is_show;
        }else{
            headerView.headermageView.hidden = YES;
        }
        return headerView;
        
    } else {
        
        HKCategoryRightFooterView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HKCategoryRightFooterView" forIndexPath:indexPath];
        footView.categoryRightFooterViewBlock = ^(id model) {
        };
        return footView;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return  CGSizeMake(collectionView.width, 129);
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}


#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


/** head */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (self.categorymodel.bannerInfo.is_show) {
        return  CGSizeMake(collectionView.width, 55 +80*Ratio - 20.0 + 20);
    }else{
        return  CGSizeMake(collectionView.width, 55 - 20.0 + 20);
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
    HKBookModel *bookModel  = self.categorymodel.class_5[section].bookList[row];
    [MobClick event:fenleiye_hukedushu_play];
    if (!isEmpty(bookModel.book_id)) {
        HKListeningBookVC *bookVC = [HKListeningBookVC new];
        bookVC.courseId = bookModel.course_id;
        bookVC.bookId = bookModel.book_id;
        [self pushToOtherController:bookVC];
        // 统计
        [[HKALIYunLogManage sharedInstance]hkBookClickLogWithFlag:@"2" bookId:bookVC.bookId courseId:bookVC.courseId];
    }
}


@end
