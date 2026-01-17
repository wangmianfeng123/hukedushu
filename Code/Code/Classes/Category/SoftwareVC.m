
//
//  SoftwareVC.m
//  Code
//
//  Created by Ivan li on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "SoftwareVC.h"
#import "SoftwareCell.h"
#import "SoftwareModel.h"
#import "CategoryServiceMediator.h"
#import "CategoryModel.h"
#import "SoftwareHeadCell.h"
#import "VideoPlayVC.h"
#import "HKSoftwareHopeCell.h"


@interface SoftwareVC ()<TBSrollViewEmptyDelegate, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView  *collectionView;
@property(nonatomic,strong)NSMutableArray<SoftwareModel*> *dataArr;
@property(nonatomic,strong)CategoryModel  *model;

@end

@implementation SoftwareVC



- (instancetype)initWithModel:(CategoryModel*)model {
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createUI {
    
    [self createLeftBarButton];
    self.title = self.model.name;
    
    [self.view addSubview:self.collectionView];
    [self refreshUI];
    [self getCategoryList];
}


- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        self.edgesForExtendedLayout=UIRectEdgeNone;// headview 遮盖一部分
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kHeight64) collectionViewLayout:layout];
        
        [_collectionView registerClass:[SoftwareCell class] forCellWithReuseIdentifier:@"SoftwareCell"];
        [_collectionView registerClass:[SoftwareHeadCell class] forCellWithReuseIdentifier:@"SoftwareHeadCell"];
        [_collectionView registerClass:[HKSoftwareHopeCell class] forCellWithReuseIdentifier:@"HKSoftwareHopeCell"];
        _collectionView.backgroundColor = COLOR_F6F6F6;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.tb_EmptyDelegate = self;
        
    }
    return _collectionView;
}



- (NSMutableArray*)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return  _dataArr;
}



#pragma mark - CollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_dataArr.count>0) {
        return 2;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (0 ==section) {
        return CGSizeZero;
    }else{
        return CGSizeMake(SCREEN_WIDTH, PADDING_15);
    }
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (0 ==section) {
        return 1;
    }else{
        return _dataArr.count + 1;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        return  CGSizeMake(SCREEN_WIDTH,115*Ratio);
    }else{
        return  CGSizeMake(SCREEN_WIDTH/3-1, (IS_IPHONE5S ? 135: 125));
    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    if (0 == section) {
        return 0;
    }
    return 1.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (0 == section) {
        return 0;
    }
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (0 == indexPath.section) {
        SoftwareHeadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SoftwareHeadCell" forIndexPath:indexPath];
        cell.model = _dataArr[0];
        return cell;
    }else{
        NSInteger row = indexPath.row;
        SoftwareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SoftwareCell" forIndexPath:indexPath];
        if (row == _dataArr.count) {
            HKSoftwareHopeCell *hopeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKSoftwareHopeCell" forIndexPath:indexPath];
            return  hopeCell;
        }else{
            cell.model = _dataArr[row];
        }
        return cell;
    }
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (0 == indexPath.section) {

    }else{
        NSInteger row = indexPath.row;
        if (row == _dataArr.count) {
            return;
        }
        SoftwareModel* model = _dataArr[row];
        VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
                                                    videoName:model.name
                                             placeholderImage:nil
                                                   lookStatus:LookStatusInternetVideo
                                                      videoId:model.anchor_video_id model:nil];
        [self pushToOtherController:VC];
    }
}



#pragma mark - 刷新
- (void)refreshUI {
    
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.collectionView completion:^{
        StrongSelf;
        [strongSelf getCategoryList];
    }];
}

- (void)tableHeaderEndRefreshing {
    [_collectionView.mj_header endRefreshing];
}

- (void)tableFooterEndRefreshing {
    [_collectionView.mj_footer endRefreshingWithNoMoreData];
}

- (void)tableFooterStopRefreshing {
    [_collectionView.mj_footer endRefreshing];
}



#pragma mark - 分类列表
- (void)getCategoryList{
    WeakSelf;
    [[CategoryServiceMediator sharedInstance] softwareList:^(FWServiceResponse *response) {
        
        [weakSelf tableHeaderEndRefreshing];
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            NSMutableArray *array = [SoftwareModel mj_objectArrayWithKeyValuesArray:response.data];
            weakSelf.dataArr = array;
        }else{
            showTipDialog(NETWORK_NOT_POWER);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
        });
    } failBlock:^(NSError *error) {
        [weakSelf tableHeaderEndRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.dataArr.count<1) {
                [weakSelf.collectionView reloadData];
            }else{
                showTipDialog(NETWORK_NOT_POWER);
            }
        });
    }];
}


@end
