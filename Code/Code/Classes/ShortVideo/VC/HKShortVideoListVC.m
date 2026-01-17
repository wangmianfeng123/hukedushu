//
//  HKShortVideoListVC.m
//  Code
//
//  Created by hanchuangkeji on 2017/10/26.
//  Copyright © 2017年 pg. All rights reserved.11
//

#import "HKShortVideoListVC.h"
#import "HKWaterflowLayout.h"
#import "HKShortVideoListCell.h"
#import "UIBarButtonItem+Extension.h"
#import "HKTeacherCourseVC.h"
#import "HKShortVideoMainVC.h"
#import "HKShortVideoModel.h"
#import "VideoPlayVC.h"


@interface HKShortVideoListVC ()<UICollectionViewDelegate, UICollectionViewDataSource, HKWaterflowLayoutDelegate, TBSrollViewEmptyDelegate>

@property (nonatomic, weak)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *dataSource;

@end


@implementation HKShortVideoListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HKColorFromHex(0x1A222B, 1.0);
    
    [self setupCollectionView];
    
    [self setRefresh];
    
    [self loadNewData];
    
    self.emptyText = @"暂无任何短视频哦~";
    
    self.view.backgroundColor = COLOR_1A222B;
    self.zf_prefersNavigationBarHidden = YES;
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
    collectionView.backgroundColor = COLOR_1A222B;
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    // 注册Cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKShortVideoListCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKShortVideoListCell class])];
    
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, KTabBarHeight49+KNavBarHeight64, 0);
    collectionView.tb_EmptyDelegate = self;
    
    HKAdjustsScrollViewInsetNever(self, self.collectionView);
    
}

- (void)setRefresh {
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.collectionView completion:^{
        StrongSelf;
        [strongSelf loadNewData];
    }];
    MJRefreshNormalHeader *headerR = (MJRefreshNormalHeader *)self.collectionView.mj_header;
    headerR.stateLabel.textColor = COLOR_7B8196;
    
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.collectionView completion:^{
        StrongSelf
        [strongSelf loadMoreData];
    }];
    MJRefreshAutoNormalFooter *footerR = (MJRefreshAutoNormalFooter *)self.collectionView.mj_footer;
    footerR.stateLabel.textColor = COLOR_7B8196;
    [self.collectionView.mj_header beginRefreshing];
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKShortVideoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKShortVideoListCell class]) forIndexPath:indexPath];
    cell.shortVideoModel = self.dataSource[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark <UICollectionDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    HKShortVideoModel *model = self.dataSource[indexPath.row];
    if (!isEmpty(model.video_id)) {
        HKShortVideoMainVC *VC = [HKShortVideoMainVC new];
        VC.shortVideoWholeVideoClickCallBack = ^(HKShortVideoModel * _Nonnull model) {
            [weakSelf pushVideoPlayWithModel:model];
        };
        VC.showBackBtn = YES;
        VC.videoId = model.video_id;
        
        // 分类的参数
        VC.tag_model = model;
        VC.dataSourceTemp = self.dataSource; // 不直接赋值，解决闪烁的问题
        VC.deallocBlock = ^{
            [weakSelf.collectionView reloadData];
        };
        VC.shortVideoType = HKShortVideoType_category;
        [self pushToOtherController:VC];
    }
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




#pragma mark <HKWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(HKWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    CGFloat realHigh = SCREEN_WIDTH * 293.5 / 375.0;
    return realHigh;
}

- (CGFloat)columnCountInWaterflowLayout:(HKWaterflowLayout *)waterflowLayout {
    return 2.0;
}

- (CGFloat)columnMarginInWaterflowLayout:(HKWaterflowLayout *)waterflowLayout {
    
//    CGFloat realWidth = SCREEN_WIDTH * 167.0 / 375.0;
//    CGFloat columnCount = [self columnCountInWaterflowLayout:nil];
//    CGFloat margin = (SCREEN_WIDTH - realWidth * columnCount - 2.0 * 14.0) / (columnCount - 1.0);
    return 12.0;
}

- (CGFloat)rowMarginInWaterflowLayout:(HKWaterflowLayout *)waterflowLayout {
    return 12.0;
}



- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(HKWaterflowLayout *)waterflowLayout {
    return UIEdgeInsetsMake(12.0, 15.0, 0, 15.0);;
}


#pragma mark <Server>
- (void)loadNewData {
    
    WeakSelf;
    self.collectionView.mj_footer.hidden = YES;
    
    // is_clear 清空历史数据
    NSDictionary *params = @{@"tag_id" : self.tag_id, @"is_clear" : @"1", HKneedNoLoginCallBack : @"1"};
    NSString *url = SHORT_VIDEO_TAG_INDEX;
    
    [HKHttpTool POST:url parameters:params success:^(id responseObject) {
        
        [self.collectionView.mj_header endRefreshing];

        if (HKReponseOK) {
            
            if (![responseObject[@"data"] isKindOfClass:[NSDictionary class]]) return ;
            
            NSMutableArray *array = [HKShortVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lists"]];
            self.dataSource = array;
            
            if (self.dataSource.count == 0) {
                self.collectionView.mj_footer.hidden = YES;
            }else {
                self.collectionView.mj_footer.hidden = NO;
            }
            
            // 无更多数据集
            if (!array.count) {
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
    
    NSDictionary *params = @{@"tag_id" : self.tag_id};
    NSString *url = SHORT_VIDEO_TAG_INDEX;
    
    [HKHttpTool POST:url parameters:params success:^(id responseObject) {
        
        [self.collectionView.mj_footer endRefreshing];
        if (HKReponseOK) {
            
            NSMutableArray *array = [HKShortVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lists"]];
            [self.dataSource addObjectsFromArray:array];
            
            // 无更多数据集
            if (!array.count) {
                self.collectionView.mj_footer.hidden = YES;
            }
            // 刷新和空处理
            [self.collectionView reloadData];
            
        }
    } failure:^(NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
    }];
}

- (void)dealloc {
    
}


@end

