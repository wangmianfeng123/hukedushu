

//
//  HKUserLearnedVC.m
//  Code
//
//  Created by Ivan li on 2018/5/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKUserLearnedVC.h"
#import "VideoModel.h"
#import "VideoPlayVC.h"
#import "HKUserLearnedCell.h"


@interface HKUserLearnedVC ()<UITableViewDelegate,UITableViewDataSource,UITableViewDataSource,TBSrollViewEmptyDelegate>

@property(nonatomic,strong)UITableView    *tableView;

@property(nonatomic,strong)NSMutableArray  *dataArray;
/** 1- 普通视频 2-PGC (默认值-1) */
@property(nonatomic,copy)NSString *videoType;

@property(nonatomic,assign)NSInteger page;

@property (nonatomic , assign)BOOL is_set_privacy;
@end


@implementation HKUserLearnedVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self refreshUI];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)createUI {
    self.title = @"已学视频";
    self.videoType = @"1";
    //空视图
    self.emptyText = [[HKAccountTool shareAccount].ID isEqualToString:self.userModel.ID]? @"您暂无已学视频" : @"暂无已学视频";
    // 空视图 图片竖直 偏移距离
    self.verticalOffset =  -KNavBarHeight64 + PADDING_25;
    
    [self.view addSubview:self.tableView];
    [self createLeftBarButton];
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    self.page = 1;
    [self getLearnedList:nil page:@"1"];
}



- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.rowHeight = 125;
        _tableView.separatorColor = COLOR_F8F9FA_333D48;
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 兼容iOS11
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, KNavBarHeight64, 0);
        _tableView.tb_EmptyDelegate = self;
        
    }
    return _tableView;
}




- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_dataArray.count) {
        return self.is_set_privacy ? 0 : 1;
    }else{
        return 0;
    }
    
//    return _dataArray.count ? 1 :0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


static NSString * const cellIdentifier = @"HKUserLearnedCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKUserLearnedCell *_learnedCell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!_learnedCell ) {
        _learnedCell = [[HKUserLearnedCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier];
    }
    id model = self.dataArray[[indexPath row]];
    if ([model isKindOfClass: [VideoModel class]]) {
        ((VideoModel*)model).videoType = ([self.videoType integerValue] == 2) ?HKVideoType_PGC :HKVideoType_Ordinary;
        _learnedCell.model = model;
    }
    return _learnedCell;
}

#pragma mark <TBEmpty>
- (CGPoint)tb_emptyViewOffset:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    return CGPointMake(0, -80);
}

- (UIView *)tb_emptyView:(UIScrollView *)scrollView network:(TBNetworkStatus)status{
//    self.is_set_privacy = YES;
    if (self.is_set_privacy) {
        
        CGFloat h = SCREEN_HEIGHT - 518/2 - 55;
//        CGFloat viewH = self.view.height;
        
        UIView * bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height)];
        bgV.backgroundColor = [UIColor purpleColor];
        bgV.backgroundColor = COLOR_FFFFFF_3D4752;
        UILabel * centerLabel= [UILabel labelWithTitle:CGRectMake(0, 0, SCREEN_WIDTH, 44) title:@"由于该用户隐私设置，学习记录不可见。" titleColor:COLOR_A8ABBE_7B8196 titleFont:@"15" titleAligment:NSTextAlignmentCenter];
        centerLabel.centerY = (SCREEN_HEIGHT - 518/2 - 44) * 0.5;
        [bgV addSubview:centerLabel];
        
        UILabel * bottomLabel= [UILabel labelWithTitle:CGRectMake(0, h, SCREEN_WIDTH, 55) title:@"（您可至PC虎课网，个人中心-设置-隐私设置进行更改）" titleColor:COLOR_A8ABBE_7B8196 titleFont:@"13" titleAligment:NSTextAlignmentCenter];
        bottomLabel.numberOfLines = 2;
        [bgV addSubview:bottomLabel];
        //[_tableView tb_setCustomEmptyView:bgV];
        return bgV;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:@selector(deleselect) withObject:nil afterDelay:0.5f];
    id model = self.dataArray[[indexPath row]];
    VideoPlayVC *VC = nil;
    
    if ([model isKindOfClass: [VideoModel class]]) {
        
        VideoModel  *tempModel = (VideoModel*)model;
        VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil
                                         fileUrl:tempModel.video_url
                                       videoName:tempModel.video_titel
                                placeholderImage:tempModel.img_cover_url
                                      lookStatus:LookStatusInternetVideo videoId:tempModel.video_id model:tempModel];
        VC.videoType = ([self.videoType integerValue] == 2) ?HKVideoType_PGC :HKVideoType_Ordinary;
    }
    [self pushToOtherController:VC];
}


- (void) deleselect {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


#pragma mark - 刷新
- (void)refreshUI {
    
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        strongSelf.page = 1;
        [strongSelf getLearnedList:nil page:@"1"];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf
        NSString  *pageNum = [NSString stringWithFormat:@"%lu",strongSelf.page];
        [strongSelf getLearnedList:nil page:pageNum];
    }];
}


- (void)tableHeaderEndRefreshing {
    [_tableView.mj_header endRefreshing];
}

- (void)tableFooterEndRefreshing {
    [_tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)tableFooterStopRefreshing {
    [_tableView.mj_footer endRefreshing];
}


#pragma mark - 获取视频列表
- (void)getLearnedList:(NSString*)token page:(NSString*)page {
    
    //type *1-已学课程 2-收藏课程
    WeakSelf;
    NSDictionary *dict = @{@"page":page,@"uid":self.userModel.ID ,@"type":self.type};
    
    [HKHttpTool POST:USER_HOME baseUrl:BaseUrl parameters:dict success:^(id responseObject) {
        StrongSelf;
        [strongSelf tableHeaderEndRefreshing];
        if (HKReponseOK) {
            NSMutableArray *array = [VideoModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"]objectForKey:@"video_list"]];
            NSString *total = responseObject[@"data"][@"totalPage"];
            strongSelf.is_set_privacy = [responseObject[@"data"][@"is_set_privacy"] boolValue];
            if ([page isEqualToString:@"1"]) {
                strongSelf.dataArray = array;
            }else{
                [strongSelf.dataArray addObjectsFromArray:array];
            }
            if (strongSelf.page >= [total intValue]){
                [strongSelf tableFooterEndRefreshing];
            }else{
                strongSelf.page++;
                [strongSelf tableFooterStopRefreshing];
            }
            
        } else {
            [strongSelf tableFooterStopRefreshing];
        }
        [strongSelf.tableView reloadData];
    } failure:^(NSError *error) {
        StrongSelf;
        [strongSelf tableHeaderEndRefreshing];
        [strongSelf tableFooterStopRefreshing];
    }];
}








@end


