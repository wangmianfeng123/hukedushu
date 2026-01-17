// 设计教程
//  HKCategoryDesignVC.m
//  Code
//
//  Created by ivan on 2020/6/15.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKCategoryDesignVC.h"
#import "HKCategorySoftwareCell.h"
#import "HKCategoryRightView.h"
#import "HKInternetSchoolCell.h"
#import "HKCategoryTreeModel.h"
#import "HKLiveListModel.h"
#import "HKLiveCourseVC.h"
#import "HKCategoryDesignCell.h"
#import "DesignTableVC.h"
#import "SeriseCourseVC.h"
#import "HKCategoryAlbumVC.h"
#import "HKSoftwareVC.h"
#import "HKDesignCategoryVC.h"


@interface HKCategoryDesignVC ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)HKcategoryModel *categorymodel;

@end


@implementation HKCategoryDesignVC



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
}





- (void)loadData {
    //1-软件入门 2-设计教程 3-职业发展 4-虎课读书
    NSDictionary *param = @{@"id" : [NSNumber numberWithInt:self.ID]};
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
         
        [_collectionView registerClass:[HKCategoryDesignCell class] forCellWithReuseIdentifier:NSStringFromClass([HKCategoryDesignCell class])];
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
    count += self.categorymodel.class_1.count;
//    count += self.categorymodel.class_b.count;
//    count += self.categorymodel.class_c.count;
//    count += self.categorymodel.class_d.count;
    return count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [self numberOfSection];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return  self.categorymodel.class_1[section].list.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    HKcategoryChilderenModel *model = self.categorymodel.class_1[section].list[row];
    HKCategoryDesignCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKCategoryDesignCell class]) forIndexPath:indexPath];
    cell.childerenModel = model;
    [cell showBottomLine:row];
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
            
        };
        
        HKcategoryModel *model = self.categorymodel;
        headerView.arrowBtn.hidden = YES;
        headerView.categoryModel = model;
        headerView.listModel = model.class_1[indexPath.section];
        
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
    if (IS_IPHONE5S) {
        return  CGSizeMake((collectionView.width - 30), 125/2);
    }
    CGFloat w = (collectionView.width - 30 -7.5)/2;
    return  CGSizeMake(floor(w), 125/2);
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(PADDING_5, 15, PADDING_5, 15);
}


#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 7.5;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10 ;
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
    HKcategoryChilderenModel *childrenModel  = self.categorymodel.class_1[section].list[row];
    
    //1-普通分类 2-软件入门 3-系列课
    id tempVC = nil;
    if (childrenModel.class_type == 1) {
        
        [self umClickWithCategoryModel:childrenModel];
        
//        DesignTableVC *VC =  [[DesignTableVC alloc]initWithNibName:nil bundle:nil
//                                                          category:[NSString stringWithFormat:@"%@",childrenModel.class_id]
//                                                              name:[NSString stringWithFormat:@"%@",childrenModel.name]];
        HKDesignCategoryVC * VC = [[HKDesignCategoryVC alloc] init];
        VC.category = [NSString stringWithFormat:@"%@",childrenModel.class_id];
        tempVC = VC;
        
    }else if (childrenModel.class_type == 2) {
        HKSoftwareVC *VC = [HKSoftwareVC new];
        tempVC = VC;
    }else if (childrenModel.class_type == 3) {
        SeriseCourseVC *VC = [[SeriseCourseVC alloc]initWithModel:childrenModel];
        tempVC = VC;
    }else if (childrenModel.class_type == 4) {
        HKCategoryAlbumVC *VC = [[HKCategoryAlbumVC alloc]initWithNibName:nil bundle:nil category:[NSString stringWithFormat:@"%@",childrenModel.name]];
        tempVC = VC;
    }
    [self pushToOtherController:tempVC];
}



/** 友盟点击统计 **/
- (void)umClickWithCategoryModel:(HKcategoryChilderenModel *)childrenModel {
    
    NSInteger type = childrenModel.class_type;
    NSString *class_id = childrenModel.class_id;
    
    if (1 == type) {
        switch ([class_id integerValue]) {
            case 1:
                // 字体
                [MobClick event:CATEGORYPAGE_SHEJIJIAOCHENG_ZITI];
                break;
                
            case 3:
                // 海报
                [MobClick event:CATEGORYPAGE_SHEJIJIAOCHENG_HAIBAO];
                break;
                
            case 4:
                //产品精修
                [MobClick event:CATEGORYPAGE_SHEJIJIAOCHENG_CHANPIN];
                break;
                
            case 5:
                //综合教程
                [MobClick event:CATEGORYPAGE_SHEJIJIAOCHENG_ZONGHE];
                break;
                
            case 6:
                //c4d
                [MobClick event:CATEGORYPAGE_SHEJIJIAOCHENG_C4D];
                break;
                
            case 7:
                // 图像合成
                [MobClick event:CATEGORYPAGE_SHEJIJIAOCHENG_TUXIANG];
                break;
                
            case 9:
                // 摄影艺术
                [MobClick event:CATEGORYPAGE_SHEJIJIAOCHENG_SHEYING];
                break;
                
            case 10:
                // 影视动画
                [MobClick event:CATEGORYPAGE_SHEJIJIAOCHENG_YINGSHI];
                break;
                
            case 14:
                // 人像精修
                [MobClick event:CATEGORYPAGE_SHEJIJIAOCHENG_RENXIANG];
                break;
                
            case 15:
                //绘画插画
                [MobClick event:CATEGORYPAGE_SHEJIJIAOCHENG_HUIHUA];
                break;
                
            case 16:
                //店铺装修
                [MobClick event:CATEGORYPAGE_SHEJIJIAOCHENG_DIANPU];
                break;
                
            case 18:
                //室内设计
                [MobClick event:CATEGORYPAGE_SHEJIJIAOCHENG_SHINEI];
                break;

            case 19:
                // 海外教程
                [MobClick event:CATEGORYPAGE_SHEJIJIAOCHENG_HAIWAI];
                break;
                
            case 20:
                // 品牌设计
                [MobClick event:CATEGORYPAGE_SHEJIJIAOCHENG_PINPAI];
                break;
                
            case 21:
                // UI设计
                [MobClick event:CATEGORYPAGE_SHEJIJIAOCHENG_UI];
                break;
                
            case 23:
                // 办公软件
                [MobClick event:CATEGORYPAGE_SHEJIJIAOCHENG_BANGONG];
                break;
                
            default:
                break;
        }
    }
}




@end
