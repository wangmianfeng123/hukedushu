
//
//  HKAudioHotVC.m
//  Code
//
//  Created by Ivan li on 2018/4/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKAudioHotVC.h"
#import "VideoModel.h"
#import "VideoPlayVC.h"

#import "TagModel.h"
#import "HKAudioListCell.h"
#import "HKMusicPlayVC.h"
#import "UIBarButtonItem+Extension.h"

@interface HKAudioHotVC ()<TBSrollViewEmptyDelegate, UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,copy)NSString *category;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *color;

@property(nonatomic,strong)UITableView   *tableView;

@property(nonatomic,copy)NSString  *videoCount; //记录筛选视频数

/** 接口数据 页码 */
@property(nonatomic,assign)NSInteger page;

@end


@implementation HKAudioHotVC


- (instancetype)initWithCategory:(NSString*)category name:(NSString*)name {

    if (self = [super init]) {
        self.category = category;
        self.name = name;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self refreshUI];
    //[self sortVideoByPage:@"1"];
}

- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)creatUI {

    [self createLeftBarButton];
    self.title = self.name;
    UIColor *bgColor = COLOR_F6F6F6_3D4752;
    self.view.backgroundColor = bgColor;
    [self.view addSubview:self.tableView];
}


- (UITableView*)tableView {

    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_F8F9FA_3D4752;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        _tableView.sectionHeaderHeight = 0.005;
        _tableView.sectionFooterHeight = 0.005;
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);

        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.tb_EmptyDelegate = self;
    }
    return _tableView;
}




#pragma mark <UITablViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count>0 ?1 :0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKAudioListCell *cell = [HKAudioListCell initCellWithTableView:tableView];
    
    cell.model = self.dataArray[[indexPath row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self performSelector:@selector(deleselect) withObject:nil afterDelay:0.4f];
    VideoModel *musicModel = self.dataArray[indexPath.row];

    //musicModel.audio_id = @"12";
    //musicModel.title = @"基金";
    //musicModel.music_artist = @"磨的";
    //musicModel.cover_url = @"https://pic.huke88.com/video/cover/2018-03-07/E7A099CF-8359-DDE1-190F-724E94B173BF.jpg!/fw/432/format/webp";

    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:musicModel];
    
    HKMusicPlayVC *VC = [[HKMusicPlayVC alloc]init];
    [VC playMusicWithIndex:0 list:arr];
    [self pushToOtherController:VC];
}


- (void) deleselect {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}



#pragma mark - 刷新
- (void)refreshUI {

    self.page = 1;
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        [strongSelf sortVideoByPage:@"1"];
    }];

    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf
        NSString  *pageNum = [NSString stringWithFormat:@"%lu",strongSelf.page];
        [strongSelf sortVideoByPage:pageNum];
    }];
    [self.tableView.mj_header beginRefreshing];
}


- (void)tableHeaderEndRefreshing {
    [self.tableView.mj_header endRefreshing];
}


- (void)tableFooterEndRefreshing {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}


- (void)tableFooterStopRefreshing {
    [self.tableView.mj_footer endRefreshing];
}


//#pragma mark - 按所选tag值  筛选视频
- (void)sortVideoByPage:(NSString*)page {
    
    [self filterVideoListWithClassName:nil sort:self.category page:page];
}


#pragma mark - 筛选音频
- (void)filterVideoListWithClassName:(NSString*)className  sort:(NSString*)sort page:(NSString*)page {
    WeakSelf;
    NSMutableDictionary  *parameters = [NSMutableDictionary new];
    [parameters setValue:className forKey:@"class_id"];
    [parameters setValue:sort forKey:@"sort"];
    [parameters setValue:page forKey:@"page"];

//    if (!isEmpty(tag1)) {
//        [parameters setValue:tag1 forKey:@"class_id"];
//    }

    [HKHttpTool POST:AUDIO_INDEX parameters:parameters success:^(id responseObject) {
        [weakSelf tableHeaderEndRefreshing];
        if (HKReponseOK) {
            NSInteger totalPage = [responseObject[@"data"][@"total_page"] intValue];
            NSString *count =  responseObject[@"data"][@"audio_count"];

            NSMutableArray *array = [VideoModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"audio_list"]];
            if ([page isEqualToString:@"1"]) {
                weakSelf.dataArray = array;
            }else{
                [weakSelf.dataArray addObjectsFromArray:array];
            }

            if ([page intValue] == totalPage) {
                 [weakSelf tableFooterEndRefreshing];
                 weakSelf.tableView.mj_footer.hidden = YES;
            }else{
                 [weakSelf tableFooterStopRefreshing];
                 weakSelf.page = [page intValue];
                 weakSelf.page++;
                 weakSelf.tableView.mj_footer.hidden = NO;
            }
        }else{
            [weakSelf tableFooterStopRefreshing];
        }
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {

        [weakSelf tableHeaderEndRefreshing];
        [weakSelf tableFooterStopRefreshing];
        if (weakSelf.dataArray.count<1) {
            [weakSelf.tableView reloadData];
        }
    }];
}




@end


