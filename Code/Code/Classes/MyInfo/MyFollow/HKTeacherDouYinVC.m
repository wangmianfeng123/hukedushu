//
//  HKTeacherDouYinVC.m
//  Code
//
//  Created by hanchuangkeji on 2017/10/26.
//  Copyright © 2017年 pg. All rights reserved.11
//

#import "HKTeacherDouYinVC.h"
#import "HKWaterflowLayout.h"
#import "HKTeacherDouYinCell.h"
#import "UIBarButtonItem+Extension.h"
#import "HKTeacherCourseVC.h"
#import "HKShortVideoMainVC.h"
#import "HKShortVideoModel.h"
#import "VideoPlayVC.h"

#define  HKshortVideoPraiseKey  @"HKshortVideoPraiseKey"



@interface HKTeacherDouYinVC ()<UICollectionViewDelegate, UICollectionViewDataSource, HKWaterflowLayoutDelegate, TBSrollViewEmptyDelegate>

@property (nonatomic, weak)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)int page;

@property (nonatomic, strong)HKShortVideoModel *cancelLikeModel; // 点赞取消model

@end


@implementation HKTeacherDouYinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    [self setupCollectionView];
    
    [self setRefresh];
    
    [self loadNewData];
    
    self.emptyText = @"暂无任何短视频哦~";
    
    // 点赞通知
    HK_NOTIFICATION_ADD(HKShortVideoPraiseNotification, shortVideoPraiseNotification:);
    // 播放通知2
    HK_NOTIFICATION_ADD(HKShortVideoStartPlayNotification, shortVideoPlayNotification:);
    
    [self hkDarkMoldel];
}


- (void)hkDarkMoldel {
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    self.collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
}


#pragma mark - 播放数量加1
- (void)shortVideoPlayNotification:(NSNotification*)noti {
    
    if(NO ==  [[noti.userInfo allKeys] containsObject:HKshortVideoPraiseKey]) {
        return;
    }
    
    HKShortVideoModel *model = noti.userInfo[HKshortVideoPraiseKey];
    // 遍历寻找播放次数+1视频
    for (HKShortVideoModel *modelTemp in self.dataSource) {
        if ([modelTemp.video_id isEqualToString:model.video_id]) {
            //modelTemp.playCount++;
            modelTemp.playCount = [NSString stringWithFormat:@"%d",modelTemp.playCount.intValue + 1];
            break;
        }
    }
    
//    // 遍历寻找播放次数+1视频
//    for (VideoModel *modelTemp in self.dataSource) {
//        if ([modelTemp.ID isEqualToString:model.video_id]) {
//            modelTemp.playCount++;
//            break;
//        }
//    }
    [self.collectionView reloadData];
}

#pragma mark - 取消点赞
- (void)shortVideoPraiseNotification:(NSNotification*)noti {
    
    // 不是自己的VC，不用移除
    BOOL isMySelf = [[HKAccountTool shareAccount].ID isEqualToString:self.user.ID];
    if(NO ==  [[noti.userInfo allKeys] containsObject:HKshortVideoPraiseKey] || !isMySelf) {
        return;
    }
    
    HKShortVideoModel *model = noti.userInfo[HKshortVideoPraiseKey];
    
    // 遍历寻找取消点赞视频
    HKShortVideoModel *modelTarget = nil;
    for (HKShortVideoModel *modelTemp in self.dataSource) {
        if ([modelTemp.video_id isEqualToString:model.video_id]) {
            modelTarget = modelTemp;
            self.cancelLikeModel = modelTarget;
            break;
        }
    }
    
    if (modelTarget) {
        // 取消点赞
        [self.dataSource removeObject:modelTarget];
    } else if (self.cancelLikeModel) {
        // 添加之前的点赞model
        [self.dataSource insertObject:self.cancelLikeModel atIndex:0];
        self.cancelLikeModel = nil;
    }
    [self.collectionView reloadData];
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
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    // 注册Cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKTeacherDouYinCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKTeacherDouYinCell class])];
    
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, KNavBarHeight64 + 45, 0);
    collectionView.tb_EmptyDelegate = self;
    // 兼容iOS11
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 我的学习中心入口
    if (self.isFromMyStudy) {
        collectionView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KNavBarHeight64 + 45, 0);
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
    HKTeacherDouYinCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKTeacherDouYinCell class]) forIndexPath:indexPath];
    cell.videoModel = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark <UICollectionDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKShortVideoModel *model = self.dataSource[indexPath.row];
    
    if (isEmpty(model.video_id)) {
        return;
    }
    @weakify(self);
    HKShortVideoMainVC *VC = [HKShortVideoMainVC new];
    VC.shortVideoWholeVideoClickCallBack = ^(HKShortVideoModel * _Nonnull model) {
        @strongify(self);
        [self pushVideoPlayWithModel:model];
    };
    VC.showBackBtn = YES;
    
    // 分类的参数
    VC.tag_model = model;
    VC.dataSourceTemp = self.dataSource.mutableCopy; // 不直接赋值，解决闪烁的问题
    VC.deallocBlock = ^{
        [collectionView reloadData];
    };
    VC.user = self.user;
    VC.teacher = self.teacher;
    VC.page = self.page +1;
    
    VC.shortVideoType = self.teacher ?HKShortVideoType_teacher :HKShortVideoType_my_praise;
    [self pushToOtherController:VC];
}


#pragma mark 跳转到 普通视频详情
- (void)pushVideoPlayWithModel:(HKShortVideoModel *)model {
    NSString *videoId = model.relation_video_id;
    
    if (isEmpty(videoId) || ([videoId integerValue] == 0)) {
        return ;
    }
    //2:相关视频按钮点击
    HKAlilogModel *aliLogModel = [HKAlilogModel new];
    if ([model.relation_type isEqualToString:@"2"]) {
        aliLogModel.shortVideoToVideoCollectFlag = @"3";
        aliLogModel.shortVideoToVideoPlayFlag = @"4";
    }
    
    if ([model.relation_type isEqualToString:@"1"]) {
        aliLogModel.shortVideoToVideoCollectFlag = @"5";
        aliLogModel.shortVideoToVideoPlayFlag = @"6";
    }
    
    VideoPlayVC *playVC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:nil placeholderImage:nil lookStatus:LookStatusInternetVideo videoId:videoId model:nil];
    playVC.alilogModel = aliLogModel;
    [self pushToOtherController:playVC];
}

#pragma mark <TBEmpty>
- (CGPoint)tb_emptyViewOffset:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    return CGPointMake(0, -80);
}

//- (UIView *)tb_emptyView:(UIScrollView *)scrollView network:(TBNetworkStatus)status{
//    UIView * bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
//    bgV.backgroundColor = [UIColor purpleColor];
//    //[_tableView tb_setCustomEmptyView:bgV];
//    return bgV;
//}


#pragma mark <HKWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(HKWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    CGFloat realHigh = SCREEN_WIDTH * 196.0 / 375.0;
    return realHigh;
}

- (CGFloat)columnCountInWaterflowLayout:(HKWaterflowLayout *)waterflowLayout {
    return 3;
}

- (CGFloat)columnMarginInWaterflowLayout:(HKWaterflowLayout *)waterflowLayout {
    
    CGFloat realWidth = SCREEN_WIDTH * 110.0 / 375.0;
    CGFloat columnCount = [self columnCountInWaterflowLayout:nil];
    CGFloat margin = (SCREEN_WIDTH - realWidth * columnCount - 2.0 * 15.0) / (columnCount - 1.0);
    return margin;
}

- (CGFloat)rowMarginInWaterflowLayout:(HKWaterflowLayout *)waterflowLayout {
    return 12.0;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(HKWaterflowLayout *)waterflowLayout {
    return UIEdgeInsetsMake(13.0, 15.0, 0, 15.0);;
}


#pragma mark <Server>
- (void)loadNewData {
    
    self.page = 1;
    self.collectionView.mj_footer.hidden = YES;
    NSDictionary *params = self.teacher? @{@"teacher_id" : self.teacher.teacher_id, @"page" : @(self.page)} : @{@"user_id" : self.user.ID, @"page" : @(self.page)};
    NSString *url = self.teacher? TEACHER_SHORT_COURSE : SHORT_VIDEO_LIKES;
    
    [HKHttpTool POST:url parameters:params success:^(id responseObject) {
        
        [self.collectionView.mj_header endRefreshing];

        if (HKReponseOK) {
            
            self.dataSource = [HKShortVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lists"]];
            
            if (self.dataSource.count == 0) {
                self.collectionView.mj_footer.hidden = YES;
            }else {
                self.collectionView.mj_footer.hidden = NO;
            }
            // 无更多数据集
            NSString *pageCount = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"pageCount"]];
            
            if (self.page >= pageCount.intValue) {
                self.collectionView.mj_footer.hidden = YES;
            }else{
                self.collectionView.mj_footer.hidden = NO;
            }
            // 刷新和空处理
            [self.collectionView reloadData];
        }
        
    } failure:^(NSError *error) {
        
        [self.collectionView.mj_header endRefreshing];
        // 刷新和空处理
        [self.collectionView reloadData];
        
    }];
}


- (void)loadMoreData {
    
    self.page = (self.page == 1) ? 2 :self.page;
    
    NSDictionary *params = self.teacher? @{@"teacher_id" : self.teacher.teacher_id, @"page" : @(self.page)} : @{@"user_id" : self.user.ID, @"page" : @(self.page)};
    NSString *url = self.teacher? TEACHER_SHORT_COURSE : SHORT_VIDEO_LIKES;
    
    [HKHttpTool POST:url parameters:params success:^(id responseObject) {
        
        [self.collectionView.mj_footer endRefreshing];
        if (HKReponseOK) {
            
            NSMutableArray *array = [HKShortVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lists"]];
            [self.dataSource addObjectsFromArray:array];
            

            // 无更多数据集
            NSString *pageCount = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"pageCount"]];
            if (self.page >= pageCount.intValue) {
                self.collectionView.mj_footer.hidden = YES;
            }
            // 刷新和空处理
            [self.collectionView reloadData];
            self.page++;
        }
    } failure:^(NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
    }];
}

- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


@end
