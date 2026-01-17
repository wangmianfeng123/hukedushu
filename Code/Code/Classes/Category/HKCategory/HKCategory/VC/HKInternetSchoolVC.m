// 虎课网校
//  HKInternetSchoolVC.m
//  Code
//
//  Created by ivan on 2020/5/18.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKInternetSchoolVC.h"
#import "HKCategorySoftwareCell.h"
#import "HKCategoryRightView.h"
#import "HKInternetSchoolCell.h"
#import "HKCategoryTreeModel.h"
#import "HKLiveListModel.h"
#import "HKLiveCourseVC.h"
#import "HKInternetRcommandCell.h"
#import "HKLiveRcommandCell.h"
#import "AppDelegate.h"

@interface HKInternetSchoolVC ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;

//@property(nonatomic,strong)HKcategoryOnlineSchoolModel *schoolModel;
@property(nonatomic,strong)HKcategoryModel *categorymodel;

@property(nonatomic,assign) int mod;
@end


@implementation HKInternetSchoolVC



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


//- (NSMutableArray<HKcategoryOnlineSchoolListModel*>*)dataArr {
//    if (!_dataArr) {
//        _dataArr = [NSMutableArray new];
//    }
//    return _dataArr;
//}


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
        [self getSeverData];
    }];
}


- (void)endRefreshing {
    [self.collectionView.mj_header endRefreshing];
}


- (void)getSeverData {
    NSDictionary *param = @{@"id" : [NSNumber numberWithInt:self.ID]};
    [HKHttpTool POST:HK_CategoryRightTypeMenu_URL parameters:param success:^(id responseObject) {
        [self endRefreshing];
        if (HKReponseOK) {
            HKcategoryModel *model = [HKcategoryModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.categorymodel = model;
            
            
//            HKcategoryOnlineSchoolListModel * listM = self.categorymodel.class_6[1];
//            NSMutableArray * tempArray = [NSMutableArray array];
//            [tempArray addObjectsFromArray:listM.list];
//            int liveCount = 6;
//            while (tempArray.count < liveCount) {
//                [tempArray addObjectsFromArray:listM.list];
//            }
//            listM.list = tempArray;
            
            [self.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        [self endRefreshing];
        [self.collectionView reloadData];
    }];
}



- (void)refreshData {
    if (0 == self.collectionView.numberOfSections) {
        [self getSeverData];
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
         
        [_collectionView registerClass:[HKInternetSchoolCell class] forCellWithReuseIdentifier:NSStringFromClass([HKInternetSchoolCell class])];
        //head
        [_collectionView registerClass:[HKCategoryRightHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKCategoryRightHeaderView"];
        [_collectionView registerClass:[HKCategoryRightFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HKCategoryRightFooterView"];
        [_collectionView registerClass:[HKInternetRcommandCell class] forCellWithReuseIdentifier:NSStringFromClass([HKInternetRcommandCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKLiveRcommandCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKLiveRcommandCell class])];
        _collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        HKAdjustsScrollViewInsetNever(self, _collectionView);
    }
    return _collectionView;
}




- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //return self.categorymodel.class_6.count;
    return self.categorymodel.class_6.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    HKcategoryOnlineSchoolListModel * model = self.categorymodel.class_6[section];
        
    if (model.list.count) {
        return 1;
    }
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKcategoryOnlineSchoolListModel *model = self.categorymodel.class_6[indexPath.section];
    if (model.klass == -1) {
        HKInternetRcommandCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKInternetRcommandCell class]) forIndexPath:indexPath];
        HKcategoryOnlineSchoolListModel *model = self.categorymodel.class_6[indexPath.section];
        cell.model = model;
        cell.didCellBlock = ^(HKLiveListModel * _Nonnull model, BOOL isTrain) {
            if (isTrain) {
                [HKH5PushToNative runtimePush:model.redirect.className arr:model.redirect.list currectVC:self];
            }else{
                //HKcategoryOnlineSchoolListModel *schoolModel = self.categorymodel.class_6[indexPath.section];
                //HKLiveListModel *model = schoolModel.list[indexPath.row];
                [self liveListpushToVC:model];
            }
        };
        return cell;
    }else if (model.klass == 0){
        HKLiveRcommandCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKLiveRcommandCell class]) forIndexPath:indexPath];
        HKcategoryOnlineSchoolListModel *model = self.categorymodel.class_6[indexPath.section];
        cell.model = model;
        cell.moreBtnBlock = ^{
            
            [MobClick event:fenleiye_hukewangxiao_more];
            [HKH5PushToNative runtimePush:model.redirect_package.class_name arr:model.redirect_package.list currectVC:self];
        };
        
        cell.tapClickBlock = ^(HKLiveListModel * _Nonnull model) {
            //专门统计上面那个免费直播课推荐卡片的点击计数
            [MobClick event:fenleiye_hukewangxiao_livestudio];
            [self liveListpushToVC:model];
        };
        return cell;
    }else{
        HKInternetSchoolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKInternetSchoolCell class]) forIndexPath:indexPath];
        HKcategoryOnlineSchoolListModel *model = self.categorymodel.class_6[indexPath.section];
        cell.model = model.list[indexPath.row];
        return cell;
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        @weakify(self);
        HKCategoryRightHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKCategoryRightHeaderView" forIndexPath:indexPath];
        
        headerView.categoryRightHeaderViewBlock = ^(HKcategoryListModel *model, HKcategoryModel *categoryModel) {
            @strongify(self);
            [HKH5PushToNative runtimePush:self.categorymodel.bannerInfo.redirect_package.class_name arr:self.categorymodel.bannerInfo.redirect_package.list currectVC:self];
        };
        headerView.categoryRightHeaderBtnClickBlock = ^(HKcategoryListModel *model, HKMapModel *mapModel) {
            
        };
        headerView.internetSchoolRightHeaderBtnClickBlock = ^(HKMapModel *mapModel, HKcategoryOnlineSchoolListModel *schoolListModel) {
            @strongify(self);
            if (schoolListModel.klass == 0) {
                [MobClick event:fenleiye_hukewangxiao_more];
            }           
            [HKH5PushToNative runtimePush:mapModel.class_name arr:mapModel.list currectVC:self];
            
        };
        if (0 == indexPath.section) {
            headerView.mapModel = self.categorymodel.bannerInfo;
            headerView.headermageView.hidden = !headerView.mapModel.is_show;
            [headerView hiddenBottomLine:YES];
        }else{
            headerView.headermageView.hidden = YES;
            [headerView hiddenBottomLine:YES];
        }
        
        
        HKcategoryOnlineSchoolListModel *model = self.categorymodel.class_6[indexPath.section];
        headerView.schoolListModel = model;
        if (model.klass == -1) {
            headerView.categoryLabel.hidden = NO;
            headerView.arrowBtn.hidden = NO;
            [headerView setarrowBtnText:@"更多训练营"];
        }else if (model.klass == 0){
            headerView.categoryLabel.hidden = YES;
            headerView.arrowBtn.hidden = YES;
            [headerView setarrowBtnText:@""];
        }else{
            headerView.categoryLabel.hidden = NO;
            headerView.arrowBtn.hidden = NO;
            [headerView setarrowBtnText:@"更多"];
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
    HKcategoryOnlineSchoolListModel *model = self.categorymodel.class_6[indexPath.section];
    if (model.klass == -1) {
        return CGSizeMake(collectionView.width, 180);
    }else if (model.klass == 0){
        //collectionView高度为370
        //标题高度 46  ，card高度82 底部指示条 26  阴影边距10
        //82* 4 = 328
        if (model.list.count > 0) {
            if(model.list.count >= 4 ){
                return  CGSizeMake(collectionView.width, 384);;
            }else{
                self.mod = model.list.count % 4;
                if(self.mod ==0){
                    return  CGSizeMake(collectionView.width, 384);;
                }else{
                    return  CGSizeMake(collectionView.width, 46 + 10 + (82 * self.mod));
                }
            }
            return  CGSizeMake(collectionView.width, 410);
        }
        return CGSizeZero;
        
    }else{
        return CGSizeMake(collectionView.width, 230);
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    return edgeInsets;
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
    HKcategoryOnlineSchoolListModel *model = self.categorymodel.class_6[section];

    if (0 == section) {
        CGFloat H = self.categorymodel.bannerInfo.is_show ?80*Ratio+55 : 45;
        return CGSizeMake(collectionView.width, H);
    }else if (model.klass == 0){
        if (model.list.count) {
            return CGSizeMake(collectionView.width, 10);
        }
        return CGSizeZero;
    }else{
        return  CGSizeMake(collectionView.width, 45);
    }
    return CGSizeZero;
}

/** foot */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {

    return  CGSizeZero;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKcategoryOnlineSchoolListModel *schoolModel = self.categorymodel.class_6[indexPath.section];
    if (schoolModel.klass != 0 && schoolModel.klass != -1) {
        //分类页_虎课网校_其它直播课推荐点击
        [MobClick event:@"C0813005"];
        HKLiveListModel *model = schoolModel.list[indexPath.row];
        [self liveListpushToVC:model];
    }
    
}


// 直播列表 的跳转
- (void)liveListpushToVC:(HKLiveListModel*)model {
    switch (model.live_status) {
        case HKLiveStatusNotStart:
        case HKLiveStatusEnd:
        {
            [self pushToLiveCourseVC:model];
        }
        break;
        
        case HKLiveStatusLiving:
        {// 直播中
            if (model.isEnroll) {
                [self pushToLivingPlayVC:model];
            }else{
                [self pushToLiveCourseVC:model];
            }
        }
        break;
        
        default:
            [self pushToLiveCourseVC:model];
            break;
    }
}


// 进入直播
- (void)pushToLivingPlayVC:(HKLiveListModel*)model {
    HKLivingPlayVC2 *VC = [[HKLivingPlayVC2 alloc] init];
    VC.live_id = model.ID;
    [self pushToOtherController:VC];
}

// 进入直播详情
- (void)pushToLiveCourseVC:(HKLiveListModel*)model {
    HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
    VC.course_id = model.ID;
    [self pushToOtherController:VC];
}

@end
