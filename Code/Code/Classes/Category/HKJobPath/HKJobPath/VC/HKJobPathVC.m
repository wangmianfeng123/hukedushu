//
//  HKJobPathVC.m
//  Code
//
//  Created by Ivan li on 2019/6/4.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKJobPathVC.h"
#import "HKJobPathLearnedCell.h"
#import "HKJobPathLearnedCourseCell.h"
#import "HKJobPathHotHeaderView.h"
#import "HKJobPathHotCell.h"
#import "HKJobPathCourseVC.h"
#import "HKJobPathModel.h"
#import "HKJobPathSectionView.h"
#import "HKBookModel.h"
#import "HKVIPCategoryVC.h"

@interface HKJobPathVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic)UICollectionView *contentCollectionView;

@property (nonatomic,strong)NSMutableArray *studyArr;

@property (nonatomic,strong)NSMutableArray *hotArr;
/** 敬请期待 */
@property (nonatomic,strong)UILabel *tipLabel;

@property(nonatomic,assign)NSInteger page;
@property (nonatomic, copy) NSString * isTabModule;  //如果是tab上需要隐藏按钮
@property (nonatomic,strong) NSMutableArray <HKTagModel*>*titlesArr;
@property (nonatomic , assign)CGRect titleViewR ;
@property (nonatomic , strong) HKTagModel * selectedTagModel;
@property (nonatomic , assign) BOOL showAllVip;
@end

@implementation HKJobPathVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
}


- (NSMutableArray*)studyArr {
    if (!_studyArr) {
        _studyArr = [NSMutableArray new];
    }
    return _studyArr;
}


- (NSMutableArray*)hotArr {
    if (!_hotArr) {
        _hotArr = [NSMutableArray new];
    }
    return _hotArr;
}

- (NSMutableArray<HKTagModel *> *)titlesArr{
    if (_titlesArr == nil) {
        _titlesArr = [NSMutableArray array];
    }
    return _titlesArr;
}


- (void)loadView {
    [super loadView];
        
//    [self loadTagArrayData];
    
    self.hk_hideNavBarShadowImage = YES;
    self.title = @"职业路径";
    if (!self.isTabModule.length || ![self.isTabModule isEqualToString:@"1"]) {
        [self createLeftBarButton];
    }
    [self.view addSubview:self.contentCollectionView];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    [self refreshUI];
}

- (void)loadTagArrayData{
    [HKHttpTool POST:@"/career/header-data" parameters:nil success:^(id responseObject) {
        [self.contentCollectionView.mj_header endRefreshing];
        if (HKReponseOK) {
            self.titlesArr = [HKTagModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"tagList"]];
            self.showAllVip = [responseObject[@"data"][@"showAllVip"] boolValue];
            //self.showAllVip = YES;
            //测试数据
            //            for (int i = 0; i< 20; i++) {
            //                HKTagModel * model = [[HKTagModel alloc] init];
            //                model.name = @"测试";
            //                [self.titlesArr addObject:model];
            //            }
            
            
            if (_titlesArr.count >= 16) {
                self.titlesArr = [self.titlesArr subarrayWithRange:NSMakeRange(0, 16)];
            }
            
            if (self.titlesArr.count) {
                self.selectedTagModel = self.titlesArr[0];
            }
            self.studyArr = [HKJobPathModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"studyingList"]];
            
            if (self.titlesArr.count) {
                
                __block BOOL isFind = NO;
                [self.titlesArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(HKTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.tagId isEqualToString:self.selectedTagModel.tagId]) {
                        obj.isSelect = YES;
                        isFind = YES;
                        *stop = YES;
                    }
                }];
                if (NO == isFind) {
                    // 将全部标记为选中
                    self.titlesArr[0].isSelect = YES;
                }
            }

            if (_titlesArr.count) {
                self.titleViewR = [self titleViewRect];
                [self.contentCollectionView reloadData];
            }
            [self loadData];
        }
        
    } failure:^(NSError *error) {
        [self.contentCollectionView.mj_header endRefreshing];
        [self.contentCollectionView.mj_footer endRefreshing];
    }];
}

- (UICollectionView*)contentCollectionView {
    if (!_contentCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing =0;
        layout.sectionHeadersPinToVisibleBounds = NO;
        
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _contentCollectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        
        [_contentCollectionView registerClass:[HKJobPathLearnedCell class] forCellWithReuseIdentifier:NSStringFromClass([HKJobPathLearnedCell class])];
        
        [_contentCollectionView registerClass:[HKJobPathHotCell class] forCellWithReuseIdentifier:NSStringFromClass([HKJobPathHotCell class])];
        
//        [_contentCollectionView registerClass:[HKJobPathHotHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HKJobPathHotHeaderView class])];
        [_contentCollectionView registerClass:[HKJobPathSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HKJobPathSectionView class])];
        
        HKAdjustsScrollViewInsetNever(self, _contentCollectionView);
        _contentCollectionView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
    }
    return _contentCollectionView;
}




#pragma mark <UICollectionViewDelegate>

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return (0 == section)? 0 :0;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return  (0 == section) ?UIEdgeInsetsZero : UIEdgeInsetsMake(0, 5, 0, 5);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.studyArr.count || self.showAllVip) {
            return 1;
        }
        return 0;
    }else{
        return self.hotArr.count;
    }
    
    
    return (0 == section) ? (self.studyArr.count ? 1 :0) :self.hotArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        @weakify(self);
        HKJobPathLearnedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKJobPathLearnedCell class]) forIndexPath:indexPath];
        cell.seriesArr = self.studyArr;
        cell.showAllVip = self.showAllVip;
        cell.videoSelectedBlock = ^(NSIndexPath * _Nonnull indexPath, HKJobPathModel * _Nonnull jobPathModel) {
            @strongify(self);
            HKJobPathCourseVC *VC = [HKJobPathCourseVC new];
            jobPathModel.source = @"recently_studied";
            [VC setJobPathModel:jobPathModel];
            [self pushToOtherController:VC];
            
            [MobClick event:UM_RECORD_CAREERPATH_RECENTSTUDY];
        };
        
        cell.vipClickBlock = ^{
            HKVIPCategoryVC *VC = [HKVIPCategoryVC new];
            //VC.class_type = @"999";
            [self pushToOtherController:VC];
            [HKALIYunLogManage sharedInstance].button_id = @"17";
            [MobClick event:@"C3105001"];

        };
        return cell;
        
    }else{
        HKJobPathHotCell *hotCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKJobPathHotCell class]) forIndexPath:indexPath];
        hotCell.model = self.hotArr[indexPath.row];
        return hotCell;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (1 == indexPath.section) {
        
        [MobClick event:UM_RECORD_CAREERPATH_HOT];
        HKJobPathModel *model = self.hotArr[indexPath.row];
        if (!isEmpty(model.career_id)) {
            HKJobPathCourseVC *VC = [HKJobPathCourseVC new];
            [VC setJobPathModel:model];
            [self pushToOtherController:VC];
        }
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        
        if (self.showAllVip) {
            if (self.studyArr.count) {
                return  CGSizeMake(self.view.width,140 + 80);
            }else{
                return  CGSizeMake(self.view.width,80);
            }
        }else{
            return  CGSizeMake(self.view.width,140);
        }
        
    }else{
        return  CGSizeMake(self.view.width - 10, 130);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
//    return (0 == section) ?CGSizeZero :CGSizeMake(collectionView.width, (self.hotArr.count ?44 : 0));
    return (0 == section) ?CGSizeZero :CGSizeMake(collectionView.width, self.titleViewR.size.height + 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 1){
//        HKJobPathHotHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HKJobPathHotHeaderView class]) forIndexPath:indexPath];
        HKJobPathSectionView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HKJobPathSectionView class]) forIndexPath:indexPath];
        //view.backgroundColor = [UIColor redColor];
        view.titlesArr = self.titlesArr;
        view.titleViewFrame = self.titleViewR;
        WeakSelf
        view.didTagBlock = ^(HKTagModel * _Nonnull tagModel) {
            [MobClick event: careerpath_labeltab];
            weakSelf.selectedTagModel = tagModel;
            [weakSelf loadData];
        };
        return view;
    }
    return [UICollectionReusableView new];
}




- (UILabel*)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel labelWithTitle:CGRectZero title:@"更多职业正在筹备中 敬请期待" titleColor:COLOR_A8ABBE_7B8196 titleFont:@"12" titleAligment:NSTextAlignmentCenter];
        _tipLabel.backgroundColor = COLOR_FFFFFF_3D4752;
        _tipLabel.tag = 200;
    }
    return _tipLabel;
}



- (void)setBottomView {
    
    UIView *view = [self.view viewWithTag:200];
    if (!view) {
        [self.view addSubview:self.tipLabel];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.height.mas_equalTo(46);
        }];
    }
}



- (void)refreshUI {
    
    @weakify(self);
    [HKRefreshTools headerRefreshWithTableView:self.contentCollectionView completion:^{
        @strongify(self);
        
        [self loadTagArrayData];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.contentCollectionView completion:^{
        @strongify(self);
        [self loadMoreData];
    }];
    
    [self.contentCollectionView.mj_header beginRefreshing];
}



- (void)loadData {
    self.page = 1;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setSafeObject:[NSString stringWithFormat:@"%ld",(long)self.page] forKey:@"page"];
    if (self.selectedTagModel.tagId.length) {
        [dict setSafeObject:self.selectedTagModel.tagId forKey:@"tag_id"];
    }
    
    [HKHttpTool POST:CAREER_LIST parameters:dict success:^(id responseObject) {
        [self.contentCollectionView.mj_header endRefreshing];
        if (HKReponseOK) {
            NSMutableArray *arr = [HKJobPathModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"fullList"][@"list"]];
            self.hotArr = arr;
            
            HKJobPathPageInfoModel *pageModel = [HKJobPathPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"fullList"][@"pageInfo"]];
            
            if (pageModel.page_total == pageModel.current_page) {
                [self.contentCollectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.contentCollectionView.mj_footer endRefreshing];
            }
            [self.contentCollectionView reloadData];
            
            self.page ++;
            
            [self setBottomView];
        }
        
    } failure:^(NSError *error) {
        [self.contentCollectionView.mj_header endRefreshing];
        [self.contentCollectionView.mj_footer endRefreshing];
        if (0 == self.studyArr.count) {
            [self.contentCollectionView reloadData];
        }
    }];
}



- (void)loadMoreData {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setSafeObject:[NSString stringWithFormat:@"%ld",(long)self.page] forKey:@"page"];
    if (self.selectedTagModel.tagId.length) {
        [dict setSafeObject:self.selectedTagModel.tagId forKey:@"tag_id"];
    }
    
    [HKHttpTool POST:CAREER_LIST parameters:dict success:^(id responseObject) {
        [self.contentCollectionView.mj_header endRefreshing];
        if (HKReponseOK) {
            
            //NSMutableArray *arr_1 = [HKJobPathModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"studyingList"]];
            //[self.studyArr addObjectsFromArray:arr_1];
            
            NSMutableArray *arr = [HKJobPathModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"fullList"][@"list"]];
            [self.hotArr addObjectsFromArray:arr];
            
//            HKJobPathPageInfoModel *pageModel = [HKJobPathPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            HKJobPathPageInfoModel *pageModel = [HKJobPathPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"fullList"][@"pageInfo"]];
            if (pageModel.page_total <= pageModel.current_page) {
                [self.contentCollectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.contentCollectionView.mj_footer endRefreshing];
            }
            [self.contentCollectionView reloadData];
            
            self.page++;
        }
        
    } failure:^(NSError *error) {
        [self.contentCollectionView.mj_header endRefreshing];
        [self.contentCollectionView.mj_footer endRefreshing];
    }];
}



- (CGRect)titleViewRect {
    
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat countRow = 0;
    CGFloat countCol = 0;
    
    CGFloat margin_X = 6;
    CGFloat margin_Y = 8;
    
    NSInteger count = self.titlesArr.count;
    
    CGFloat title_W = 80;
    CGFloat title_H = 26;
    
    CGFloat content_W = SCREEN_WIDTH - 30;
    CGFloat leftMagin = 15;
    if (NO == IS_IPAD) {
        //一行显示 4个
//        leftMagin = (self.view.width - 4*80 -3*margin_X)/2.0;
//        if (leftMagin <0) {
//            //一行显示 3个
//            leftMagin = (self.view.width - 3*80 -2*margin_X)/2.0;
//        }
        //content_W = self.view.width - 2*(leftMagin>0 ?leftMagin :30);
        
        title_W = floor((content_W - 3*margin_X)/4.0);
        if (title_W <80) {
            //一行显示 3个
            title_W = floor((content_W - 2*margin_X)/3.0);
        }
    }
    
    
    for (int i = 0; i < count; i++) {
        if (currentX + title_W + margin_X * countRow > content_W) {
            CGFloat x = 0;
            CGFloat y = (currentY += title_H) + margin_Y * ++countCol;
            currentX = title_W;
            countRow = 1;
        } else {
            CGFloat x = (currentX += title_W) - title_W + margin_X * countRow;
            CGFloat y = currentY + margin_Y * countCol;
            countRow ++;
        }
    }
    
    CGFloat H = title_H*(countCol+1) + countCol*margin_Y;
    
    CGFloat W = content_W;
    CGRect frame = CGRectMake(leftMagin, 15, W, H);
    return frame;
}

@end
