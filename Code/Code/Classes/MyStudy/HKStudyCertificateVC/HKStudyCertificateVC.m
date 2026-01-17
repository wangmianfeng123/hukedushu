//
//  HKStudyCertificateVC.m
//  Code
//
//  Created by Ivan li on 2018/4/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKStudyCertificateVC.h"
#import "HKStudyCertificateCell.h"
#import "HKStudyCertificateDetailVC.h"
#import "StudyCertificateModel.h"

@interface HKStudyCertificateVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic)UICollectionView *collectionView;

@property (strong,nonatomic)NSMutableArray *dataArr;

@end

@implementation HKStudyCertificateVC

- (void)loadView {
    [super loadView];
    [self createUI];
}

- (void)createUI {
    self.title = @"学习成就";
    [self createLeftBarButton];
    self.view.backgroundColor = COLOR_F8F9FA;
    [self.view addSubview:self.collectionView];
    [self requestCertificate];
    [self refreshUI];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray*)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


#pragma mark - 刷新
- (void)refreshUI {
    
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.collectionView completion:^{
        StrongSelf;
        [strongSelf requestCertificate];

    }];
}


- (void)tableHeaderEndRefreshing {
    [self.collectionView.mj_header endRefreshing];
}

- (void)tableFooterEndRefreshing {
    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
}

- (void)tableFooterStopRefreshing {
    [self.collectionView.mj_footer endRefreshing];
}


- (void)requestCertificate {
    WeakSelf;
    [HKHttpTool POST:USER_DIPLOMA_LIST parameters:nil success:^(id responseObject) {
        StrongSelf;
        [strongSelf tableHeaderEndRefreshing];
        if (HKReponseOK) {
            strongSelf.dataArr = [StudyCertificateModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [strongSelf.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        StrongSelf;
        [strongSelf tableHeaderEndRefreshing];
    }];
}





/*************************  UICollectionView **************************/

- (UICollectionView*)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 15;
        
        CGFloat width = (SCREEN_WIDTH - 15 - 15 - 15) * 0.5;
        CGFloat height = 350/2;
        layout.itemSize = CGSizeMake(width, height);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
        _collectionView.backgroundColor = COLOR_F8F9FA;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[HKStudyCertificateCell class] forCellWithReuseIdentifier:NSStringFromClass([HKStudyCertificateCell class])];
        // 兼容iOS11
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _collectionView;
}




#pragma mark <UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArr ? 1 :0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.dataArr.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(13, 15, PADDING_10, 15);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKStudyCertificateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKStudyCertificateCell class]) forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StudyCertificateModel *model  = self.dataArr[indexPath.row];
    HKStudyCertificateDetailVC *VC = [HKStudyCertificateDetailVC new];
    VC.certificateId = model.ID;
    [self pushToOtherController:VC];
}



@end





