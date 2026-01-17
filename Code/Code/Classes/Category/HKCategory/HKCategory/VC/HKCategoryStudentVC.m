// 学生专区
//  HKCategoryStudentVC.m
//  Code
//
//  Created by ivan on 2020/6/15.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKCategoryStudentVC.h"
#import "HKCategorySoftwareCell.h"
#import "HKCategoryRightView.h"
#import "HKInternetSchoolCell.h"
#import "HKCategoryTreeModel.h"
#import "HKLiveListModel.h"
#import "HKLiveCourseVC.h"
#import "HkCategoryStudentCell.h"
#import "DesignTableVC.h"
#import "HKDesignCategoryVC.h"

@interface HKCategoryStudentVC ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)HKcategoryModel *categorymodel;

@end


@implementation HKCategoryStudentVC



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
    //1-软件入门 2-设计教程 3-职业发展 4-学生专区
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
         
        [_collectionView registerClass:[HkCategoryStudentCell class] forCellWithReuseIdentifier:NSStringFromClass([HkCategoryStudentCell class])];
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
    count += self.categorymodel.class_3.count;
//    count += self.categorymodel.class_b.count;
//    count += self.categorymodel.class_c.count;
//    count += self.categorymodel.class_d.count;
    return count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [self numberOfSection];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    HKcategoryListModel *listModel = self.categorymodel.class_3[section];
    NSInteger count = listModel.list.count;
    if(NO == IS_IPAD) {
        if (count > 6) {
            // 手机 超过6个 显示更多
          count = listModel.isExpan ?count :6;
        }
    }
    return count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
   
    HKcategoryListModel *listModel = self.categorymodel.class_3[section];
    HKcategoryChilderenModel *model = listModel.list[row];
    HkCategoryStudentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HkCategoryStudentCell class])forIndexPath:indexPath];
    // 展开后 不显示更多（ 否则显示更多）
    if (row == 5) {
        model.is_more = !listModel.isExpan;
    }
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
            [MobClick endEvent:um_fenleiye_xuesheng_banner];
            [HKH5PushToNative runtimePush:categoryModel.bannerInfo.redirect_package.class_name arr:categoryModel.bannerInfo.redirect_package.list currectVC:self];
        };
        headerView.categoryRightHeaderBtnClickBlock = ^(HKcategoryListModel *model, HKMapModel *mapModel) {
            
        };
        
        HKcategoryModel *model = self.categorymodel;
        headerView.arrowBtn.hidden = YES;
        headerView.categoryModel = model;
        headerView.listModel = model.class_3[indexPath.section];
        
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
    CGFloat W = (collectionView.width - 30 -20)/3.0;
    CGFloat width = floor(W);
    return CGSizeMake(IS_IPAD ?100 :width, 50);
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, PADDING_15, 15, PADDING_15);
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
    HKcategoryChilderenModel *model  = self.categorymodel.class_3[section].list[row];
    
    
    if(NO == IS_IPAD) {
        HKcategoryListModel *listModel = self.categorymodel.class_3[section];
        NSInteger count = listModel.list.count;
        if (count > 6) {
            if (5 == row && !listModel.isExpan) {
                // 手机 超过6个 显示更多
                listModel.isExpan = YES;
                [collectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];
                [collectionView performBatchUpdates:^{
                    
                } completion:^(BOOL finished) {
                    
                }];
                //更多 统计
                [self umStudentClickWithIndexPath:indexPath childerenModel:model isMore:YES];
                return;
            }
        }
    }
    [self umStudentClickWithIndexPath:indexPath childerenModel:model isMore:NO];
    
//    // 学生专区ID 25
//    DesignTableVC *VC = [[DesignTableVC alloc]initWithNibName:nil bundle:nil
//                                                      category:[NSString stringWithFormat:@"%@",@"25"]
//                                                          name:[NSString stringWithFormat:@"%@",@"学生专区"]];
    
    HKDesignCategoryVC * VC = [[HKDesignCategoryVC alloc] init];
    VC.category = [NSString stringWithFormat:@"%@",@"25"];
    VC.defaultSelectedTag = model.tag1;
    [self pushToOtherController:VC];
}



/// 学生专区 统计
- (void)umStudentClickWithIndexPath:(NSIndexPath *)indexPath  childerenModel:(HKcategoryChilderenModel *)childerenModel isMore:(BOOL)isMore {
    switch (indexPath.section) {
        case 0:
            [MobClick event: isMore ?um_fenleiye_xuesheng_morebiaoqianyi :um_fenleiye_xuesheng_biaoqianyi];
            break;
            
        case 1:
            [MobClick event:isMore ?um_fenleiye_xuesheng_morebiaoqianer :um_fenleiye_xuesheng_biaoqianer];
            break;
        
        case 2:
            [MobClick event:isMore ? um_fenleiye_xuesheng_morebiaoqiansan :um_fenleiye_xuesheng_biaoqiansan];
            break;
        
        case 3:
            [MobClick event:isMore ?um_fenleiye_xuesheng_morebiaoqiansi :um_fenleiye_xuesheng_biaoqiansi];
            break;
        
        case 4:
            [MobClick event:isMore ?um_fenleiye_xuesheng_morebiaoqianwu :um_fenleiye_xuesheng_biaoqianwu];
            break;
            
        case 5:
            [MobClick event:isMore ?um_fenleiye_xuesheng_morebiaoqianliu :um_fenleiye_xuesheng_biaoqianliu];
            break;
            
        default:
            break;
    }
}

@end
