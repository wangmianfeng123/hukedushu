//
//  HKSoftwareRecommenVC.m
//  Code
//
//  Created by Ivan li on 2018/4/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKSoftwareRecommenVC.h"
#import "HKSoftwareRecommenCell.h"
#import "HKSoftwareRecommenHeadView.h"

@interface HKSoftwareRecommenVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,HKSoftwareRecommenHeadViewDelegate>

@property (strong,nonatomic)UICollectionView *collectionView;

@property (strong,nonatomic)HKSoftwareRecommenHeadView *headView;

@end

@implementation HKSoftwareRecommenVC




- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    // 隐藏导航栏
//    [self.navigationController setNavigationBarHidden:YES];
//}
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    // 显示导航栏
//    //[self.navigationController setNavigationBarHidden:NO];
//}


- (void)loadView {
    [super loadView];
    [self createUI];
}

- (void)createUI {
    
    self.view.backgroundColor =  [COLOR_000000 colorWithAlphaComponent:0.8];
    
    [self.view addSubview:self.headView];
    [self.view addSubview:self.collectionView];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(Ratio*224/2 + 385/2);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headView.mas_bottom);
    }];
}



- (HKSoftwareRecommenHeadView*)headView {
    if (!_headView) {
        _headView = [[HKSoftwareRecommenHeadView alloc]initWithFrame:CGRectZero];
        _headView.delegate = self;
    }
    return _headView;
}

/**  HKSoftwareRecommenHeadView delegate */
- (void)hkSoftwareHeadViewCloseBtnClick:(id)sender {
    //self.removeVCBlcok ?self.removeVCBlcok() :nil;
    [self removeVc];
    
}

/** 销毁 */
- (void)removeVc {
    [UIView animateWithDuration:0.5 animations:^{
        self.view.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}




//- (NSMutableArray*)dataArray {
//    if (!_dataArray) {
//        _dataArray = [NSMutableArray array];
//    }
//    return _dataArray;
//}


- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
}


- (void)setSoftwareName:(NSString *)softwareName {
    self.headView.softwareName = softwareName;
}


/*************************  UICollectionView **************************/

- (UICollectionView*)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 15;
        
        CGFloat width = (SCREEN_WIDTH - 15 - 15 - 15) * 0.5;
        CGFloat height = 250/2;
        layout.itemSize = CGSizeMake(width, height);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, KTabBarHeight49, 0);
        _collectionView.backgroundColor = [UIColor clearColor];//[COLOR_000000 colorWithAlphaComponent:0.8];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[HKSoftwareRecommenCell class] forCellWithReuseIdentifier:NSStringFromClass([HKSoftwareRecommenCell class])];
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
    //return 1;
    return self.dataArray.count ? 1 :0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return 4;
    return self.dataArray.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(PADDING_10, PADDING_15, PADDING_10, PADDING_15);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    //NSInteger row = indexPath.row;
    HKSoftwareRecommenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSoftwareRecommenCell class]) forIndexPath:indexPath];
    
    VideoModel *model = self.dataArray[indexPath.row];
    model.name = model.video_titel;
    model.avatar = model.img_cover_url; //@"https://pic.huke88.com/product-make/cover/2018-03-22/8886F08F-6CD7-9D13-F0DA-42242135896B.jpg!/fw/432/format/webp";
    cell.model = model;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [MobClick event:UM_RECORD_DETAIL_PAGE_SOFTWARE_RECOMMED];
    
    self.removeVCBlcok ?self.removeVCBlcok(self.dataArray[indexPath.row]) :nil;
    [self removeVc];
}
@end





