//
//  HKMyFollowVC.m
//  Code
//
//  Created by hanchuangkeji on 2017/10/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKMyFollowVC.h"
#import "HKWaterflowLayout.h"
#import "HKHomeFollowCell.h"
#import "UIBarButtonItem+Extension.h"
#import "AFNetworkTool.h"
#import "HKTeacherCourseVC.h"
#import "VideoPlayVC.h"
#import "HKUserInfoVC.h"


@interface HKMyFollowVC ()<UICollectionViewDelegate, UICollectionViewDataSource, HKWaterflowLayoutDelegate, TBSrollViewEmptyDelegate>

@property (nonatomic, weak)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)int page;

@end


@implementation HKMyFollowVC

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    [self setupNav];
    
    [self setupCollectionView];
    
    [self setRefresh];
    
    [self loadNewData];
    [MobClick event:UM_RECORD_PERSON_CENTEE_FOCUS];
    
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    self.collectionView.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_F6F6F6 dark:COLOR_333D48];
}

- (void)setupNav {
    self.title = @"我的关注";
    [self createLeftBarButton];
    self.emptyText = @"您还没有关注任何讲师哦~";
}

#pragma mark TBSrollViewEmptyDelegate
- (void)tb_emptyButtonClick:(UIButton *)btn network:(TBNetworkStatus)status {
    [self.collectionView.mj_header beginRefreshing];
}


- (void)setupCollectionView {
    
    // 设置流水布局
    HKWaterflowLayout *layout = [[HKWaterflowLayout alloc] init];
    layout.delegate = self;
    
    // 创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    //collectionView.frame = self.view.bounds;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = HKColorFromHex(0xf6f6f6, 1.0);
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    // 注册Cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKHomeFollowCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKHomeFollowCell class])];
    
    collectionView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, 0, 0);
    collectionView.tb_EmptyDelegate = self;
    // 兼容iOS11
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setRefresh {
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.collectionView.mj_header = mj_header;
    mj_header.automaticallyChangeAlpha = YES;
    
    MJRefreshAutoNormalFooter *mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.collectionView.mj_footer = mj_footer;
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    HKHomeFollowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKHomeFollowCell class]) forIndexPath:indexPath];
    HKUserModel *teacher_info = self.dataSource[[indexPath row]];
    [cell setTeacher_info:teacher_info hiddenSeparator:YES index:indexPath];
    
    // 关注按钮
    cell.followTeacherSelectedBlock = ^(NSIndexPath *indexPath, HKUserModel *teacherModel) {
        [weakSelf followTeacherToServer:teacher_info.teacher_id index:indexPath];
    };
    
    // 嵌套cell的点击
    cell.homeMyFollowVideoSelectedBlock = ^(NSIndexPath *indexPath, VideoModel *model) {
        VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:model.video_url
                                                    videoName:model.video_titel
                                             placeholderImage:model.img_cover_url
                                                   lookStatus:LookStatusInternetVideo videoId:model.video_id model:model];
        [weakSelf pushToOtherController:VC];
    };
    return cell;
}

#pragma mark <UICollectionDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    HKUserModel *userModel = self.dataSource[indexPath.row];
    HKTeacherCourseVC *vc = [[HKTeacherCourseVC alloc] init];
    vc.teacher_id = userModel.teacher_id.length? userModel.teacher_id : userModel.ID;
    vc.followBlock = ^(BOOL is_follow, NSString *teacher_id) {

        // 遍历并且更新
        for (HKUserModel *user in weakSelf.dataSource) {
            if ([user.teacher_id isEqualToString:teacher_id]) {
                user.is_follow = is_follow;
                [weakSelf.collectionView reloadData];
                break;
            }
        }
    };
    [self pushToOtherController:vc];
}




#pragma mark <HKWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(HKWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    
    HKUserModel *model = self.dataSource[index];
    return (model.video_list.count >0) ?232.5 :70; // 无课程 则只显示头像一栏
    //return 232.5;
}

- (CGFloat)columnCountInWaterflowLayout:(HKWaterflowLayout *)waterflowLayout {
    return 1;
}

- (CGFloat)columnMarginInWaterflowLayout:(HKWaterflowLayout *)waterflowLayout {
    return 0;
}

- (CGFloat)rowMarginInWaterflowLayout:(HKWaterflowLayout *)waterflowLayout {
    return 0.5;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(HKWaterflowLayout *)waterflowLayout {
    return UIEdgeInsetsZero;
}


#pragma mark <Server>
- (void)loadNewData {
    
    WeakSelf;
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    self.page = 1;
    self.collectionView.mj_footer.hidden = YES;
    [mange userFollowsWithToken:[CommonFunction getUserToken] page:[NSString stringWithFormat:@"%d", self.page] completion:^(FWServiceResponse *response) {
        [self.collectionView.mj_header endRefreshing];
        
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            NSMutableArray *array = [HKUserModel mj_objectArrayWithKeyValuesArray:response.data[@"list"]];
            
            self.dataSource = array;
            
            // 默认所有的都是关注
            for (HKUserModel *teacher in array) {
                teacher.is_follow = YES;
            }
            
            if (self.dataSource.count == 0) {
                self.collectionView.mj_footer.hidden = YES;
            }else {
                self.collectionView.mj_footer.hidden = NO;
            }
            [weakSelf.collectionView.mj_footer resetNoMoreData];
            
            // 无更多数据集
            NSString *countString = [NSString stringWithFormat:@"%@", response.data[@"count"]];
            if (array.count >= countString.intValue) {
                self.collectionView.mj_footer.hidden = YES;
            }else {
                self.collectionView.mj_footer.hidden = NO;
            }
            
            // 刷新和空处理
            [weakSelf.collectionView reloadData];
        }
        
    } failBlock:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        // 刷新和空处理
        [weakSelf.collectionView reloadData];
    }];
}


- (void)loadMoreData {
    
    WeakSelf;
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    self.page = (self.page == 1) ? 2 :self.page;
    [mange userFollowsWithToken:nil page:[NSString stringWithFormat:@"%d", self.page] completion:^(FWServiceResponse *response) {
        [self.collectionView.mj_footer endRefreshing];
        
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
            self.page++;
            NSMutableArray *array = [HKUserModel mj_objectArrayWithKeyValuesArray:response.data[@"list"]];
            [self.collectionView.mj_footer endRefreshing];
            [self.dataSource addObjectsFromArray:array];
            
            // 默认所有的都是关注
            for (HKUserModel *teacher in array) {
                teacher.is_follow = YES;
            }
            
            if (array.count == 0) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            
            // 刷新和空处理
            [self.collectionView reloadData];
        }
        
    } failBlock:^(NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
    }];
}


- (void)followTeacherToServer:(NSString *)teacherId index:(NSIndexPath *)indexPath {
    
    WeakSelf;
    if (!isLogin()) {
        [weakSelf setLoginVC];
        return;
    }
    HKUserModel *userModel = weakSelf.dataSource[indexPath.row];
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    //type ---当前的关注状态, 1已关注，0未关注
    [mange followTeacherVideoWithToken:nil teacherId:teacherId type:((userModel.is_follow)? @"1":@"0")   completion:^(FWServiceResponse *response) {
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            HKUserModel *user = weakSelf.dataSource[indexPath.row];
            user.is_follow = !user.is_follow;
            showTipDialog(user.is_follow ? @"关注成功" : @"取消关注");
            [weakSelf.collectionView reloadData];
        }
    } failBlock:^(NSError *error) {
        
    }];    
}





@end
