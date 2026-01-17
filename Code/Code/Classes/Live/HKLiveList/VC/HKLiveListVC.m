//
//  HKLiveListVC.m
//  Code
//
//  Created by Ivan li on 2018/10/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLiveListVC.h"
#import "HKLiveListCell.h"
#import "HKLiveListModel.h"
#import "HKLiveCourseVC.h"
#import "HKLivingPlayVC2.h"
#import "HKUserInfoVC.h"

@interface HKLiveListVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray <HKLiveListModel*> *dataArray;

@property(nonatomic,assign)NSInteger page;

@end


@implementation HKLiveListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshUI];
    
    [MyNotification addObserver:self
                       selector:@selector(loginSuccessReLoadData)
                           name:HKLoginSuccessNotification
                         object:nil];
}


- (void)loginSuccessReLoadData {
    self.page = 1;
    [self listRequestWithPage:self.page];
}


- (void)loadView {
    [super loadView];
    self.title = @"直播";
    [self createLeftBarButton];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.hk_hideNavBarShadowImage = YES;
    
    
    if (self.isPlayBack) {
        [MobClick event:UM_RECORD_LIVES_LISTPAGE_HISTORY];
    } else {
        [MobClick event:UM_RECORD_LIVES_START];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray<HKLiveListModel*>*)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (UICollectionView*)collectionView {
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        layout.minimumLineSpacing = CGFLOAT_MIN;
        layout.itemSize = IS_IPAD? CGSizeMake(SCREEN_WIDTH * 0.5, 310) : CGSizeMake(SCREEN_WIDTH, 310);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, 0, 0);
        HKAdjustsScrollViewInsetNever(self, _collectionView);
        // 注册cell
        [_collectionView registerClass:[HKLiveListCell class] forCellWithReuseIdentifier:@"HKLiveListCell"];
        
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count? 1 : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HKLiveListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKLiveListCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.model = self.dataArray[indexPath.row];
    // 收藏功能
    WeakSelf;
    cell.enrolmentBlock = ^(NSIndexPath *indexPath, HKLiveListModel *model) {
        [weakSelf enrollLiveWithModel:model indexPath:indexPath];
    };
    cell.avatarClickBlock = ^(NSIndexPath *indexPath, HKLiveListModel *model) {
        HKUserInfoVC *userVC = [HKUserInfoVC new];
        userVC.userId = model.teacher_id;
        [weakSelf pushToOtherController:userVC];
    };
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKLiveListModel *model = self.dataArray[indexPath.row];
    WeakSelf;
    
    // 没有登录的
    if (![HKAccountTool shareAccount]) {
        HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
        VC.refreshBlock = ^(HKLiveListModel *model) {
            [weakSelf refreshCollectionViewEnroll:model];
        };
        VC.course_id = model.ID;
        [self pushToOtherController:VC];
    } else if (model.live_status == HKLiveStatusLiving || (model.live_status == HKLiveStatusNotStart && model.coutDownForLive < 0)) {

        if (model.isEnroll) {
            HKLivingPlayVC2 *vc = [[HKLivingPlayVC2 alloc] init];
            vc.live_id = model.ID;
            [self pushToOtherController:vc];
        } else if (model.price.doubleValue <= 0) {
            // 报名并且直接进入 直播间
            [self userEnrollToServer:model];
        }else {
            HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
            VC.course_id = model.ID;
            VC.refreshBlock = ^(HKLiveListModel *model) {
                [weakSelf refreshCollectionViewEnroll:model];
            };
            [self pushToOtherController:VC];
        }
        
    } else {
        HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
        VC.refreshBlock = ^(HKLiveListModel *model) {
            [weakSelf refreshCollectionViewEnroll:model];
        };
        VC.course_id = model.ID;
        [self pushToOtherController:VC];
    }
}

- (void)refreshCollectionViewEnroll:(HKLiveListModel *)model {
    
    if (!model || ![model isKindOfClass:[HKLiveListModel class]]) return;
    
    for (HKLiveListModel *modelTemp in self.dataArray) {
        if ([modelTemp.ID isEqualToString:model.ID]) {
            modelTemp.isEnroll = model.isEnroll;
            [self.collectionView reloadData];
            break;
        }
    }
}


- (void)userEnrollToServer:(HKLiveListModel *)model {
    
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    
    if (model.price.doubleValue > 0 && !model.isEnroll) {
        showTipDialog(@"请至网站付费报名哦~");
        return;
    }
    
    NSString *enRollString = model.isEnroll? @"0" : @"1";
    
    [HKHttpTool POST:@"live/enroll-or-un-enroll" parameters:@{@"op_type" : enRollString, @"live_course_id" : model.course_id} success:^(id responseObject) {
        
        if (HKReponseOK) {
            
            if (enRollString.intValue == 1) {
                showTipDialog(@"报名成功");
                HKLivingPlayVC2 *vc = [[HKLivingPlayVC2 alloc] init];
                vc.live_id = model.ID;
                [self pushToOtherController:vc];
            }
            // 更新数据
            model.isEnroll = enRollString.intValue == 1;
            [self.collectionView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 刷新
- (void)refreshUI {
    
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.collectionView completion:^{
        StrongSelf;
        strongSelf.page = 1;
        [strongSelf listRequestWithPage:strongSelf.page];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.collectionView completion:^{
        StrongSelf;
        [strongSelf listRequestWithPage:strongSelf.page];
    }];
    [self.collectionView.mj_header beginRefreshing];
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



#pragma mark - 直播列表
- (void)listRequestWithPage:(NSInteger)page {
    
    NSDictionary *param = param = @{@"page" : @(page), @"live_type" : self.isPlayBack? @"2" : @"1"}; // 播放状态 1 即将播放 2 精彩回放
    
    [HKHttpTool POST:LIVE_LIST parameters:param success:^(id responseObject) {
        [self tableHeaderEndRefreshing];
        if (HKReponseOK) {
            NSMutableArray *arr = [HKLiveListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            NSInteger totalPage = [responseObject[@"data"][@"totalPage"] intValue];
            if (0 == arr.count || page == totalPage) {
                [self tableFooterEndRefreshing];
            }else {
                [self tableFooterStopRefreshing];
            }
            if (1 == page) {
                self.dataArray = arr;
            }else{
                [self.dataArray addObjectsFromArray:arr];
            }
            self.page ++ ;
        } else {
            [self tableFooterStopRefreshing];
        }
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [self tableHeaderEndRefreshing];
        [self tableFooterStopRefreshing];
        [self.collectionView reloadData];
    }];
}



#pragma mark -直播报名
- (void)enrollLiveWithModel:(HKLiveListModel*)model indexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = @{@"live_course_id":model.course_id,@"op_type":@((model.isEnroll ? 0 :1))};
    [HKHttpTool POST:LIVE_ENROLL_OR_UN_ENROLL parameters:dict success:^(id responseObject) {
        if (HKReponseOK) {
            model.isEnroll = !model.isEnroll;
            
            HKLiveListCell *cell = (HKLiveListCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            cell.enrolmentBtn.selected = !cell.enrolmentBtn.selected;
            NSLog(@"----- %@", responseObject[@"data"][@"result"]);
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}

@end




