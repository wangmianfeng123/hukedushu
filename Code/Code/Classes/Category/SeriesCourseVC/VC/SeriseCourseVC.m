
//
//  SeriseCourseVC.m
//  Code
//
//  Created by Ivan li on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "SeriseCourseVC.h"
#import "CategoryModel.h"
#import "SeriseCourseCell.h"
#import "SeriseCourseHeaderView.h"
#import "CategoryServiceMediator.h"
#import "SeriseCourseModel.h"
#import "SeriesCourseTagVC.h"
#import "VideoPlayVC.h"

@interface SeriseCourseVC ()<UITableViewDelegate,UITableViewDataSource, TBSrollViewEmptyDelegate,
                        SeriseCourseHeaderViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)CategoryModel *model;
@property(nonatomic,strong)SeriseCourseHeaderView *tabHeaderView;
@property(nonatomic,strong)NSMutableArray <SeriseTagModel*>*tagArr;
@property(nonatomic,strong)NSMutableArray <SeriseCourseModel*>*courseArr;
@property(nonatomic,strong)SeriseTagModel *tagModel;
@property(nonatomic,copy)NSString *classId;//分类ID

@end

@implementation SeriseCourseVC



- (instancetype)initWithModel:(CategoryModel*)model {
    if (self = [super init]) {
        self.model = model;
        //self.classId = model.className;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    //[MobClick event:UM_RECORD_CATEGORY_SERIES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"classId" context:nil];
}

- (void)createUI {
    [self createLeftBarButton];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"系列课";
    [self.view addSubview:self.tableView];
    [self getSeriseCourseListById:self.classId];
    [self refreshUI];
    [self tagModelObserver];
}


- (SeriseCourseHeaderView*)tabHeaderView {
    
    if (!_tabHeaderView) {
        _tabHeaderView = [[SeriseCourseHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 115*Ratio+70)];
        _tabHeaderView.delegate = self;
    }
    return _tabHeaderView;
}

#pragma mark - SeriseCourseHeaderView 代理
- (void)allCourserAction:(id)sender {
    WeakSelf;
    if (_tagArr.count) {
        if (weakSelf.tagModel) {
            [_tagArr enumerateObjectsUsingBlock:^(SeriseTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (weakSelf.tagModel.ID == obj.ID) {
                    [_tagArr replaceObjectAtIndex:idx withObject:weakSelf.tagModel];
                    *stop = YES;
                }
            }];
        }
        SeriesCourseTagVC *tagVC = [[SeriesCourseTagVC alloc]initWithModelArray:_tagArr];
        tagVC.tagSelectBlock = ^(NSIndexPath *indexPath, SeriseTagModel *model) {
            //设置选中标题 改变classId
            [weakSelf.tabHeaderView setCourseBtnByTitle:model.name];
            weakSelf.tagModel = model;
            weakSelf.classId = model.ID;
        };
        [self pushToOtherController:tagVC];
    }
}


#pragma mark - tagModel 变化观察
- (void)tagModelObserver {
    [self addObserver:self forKeyPath:@"classId" options:NSKeyValueObservingOptionNew context:nil];
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"classId"]) {
        [self getSeriseCourseListById:self.classId];
    }
}



- (UITableView*)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [self tabHeaderView];
        
        _tableView.sectionHeaderHeight = 0.0001;
        _tableView.tableFooterView = [UIView new];
        _tableView.sectionFooterHeight = 0.01;
        _tableView.separatorColor = [UIColor clearColor];
        
        // 兼容iOS11
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, 0, 0);
        _tableView.tb_EmptyDelegate = self;
    }
    return _tableView;
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _courseArr.count>0 ? 1:0;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat  height = 180*Ratio +85 +(IS_IPHONE6PLUS ?6 :0);
    return height;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _courseArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    SeriseCourseCell *cell = [SeriseCourseCell initCellWithTableView:tableView];
    cell.model = _courseArr[indexPath.row];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSInteger section = [indexPath section];
    SeriseCourseModel *model = _courseArr[indexPath.row];
    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
                                                videoName:model.title
                                         placeholderImage:nil
                                               lookStatus:LookStatusInternetVideo
                                                  videoId:model.video_id model:nil];
    [self pushToOtherController:VC];
    [self performSelector:@selector(deleselect) withObject:nil afterDelay:0.2f];
}


- (void) deleselect {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}



#pragma mark - 刷新
- (void)refreshUI {

    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        [strongSelf getSeriseCourseListById:weakSelf.classId];
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

#pragma mark - 系列课列表
- (void)getSeriseCourseListById:(NSString*)classId {
    WeakSelf;
    [[CategoryServiceMediator sharedInstance] seriseCourseListWithClassId:classId completion:^(FWServiceResponse *response) {
        [weakSelf tableHeaderEndRefreshing];
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            SeriseListModel *model = [SeriseListModel mj_objectWithKeyValues:response.data];
            //筛选标签
            NSMutableArray *tempArr = model.lesson_class;
            //数组逆序
            if (0 == weakSelf.tagArr.count && tempArr.count) {
                weakSelf.tagArr = tempArr;
                weakSelf.tagArr[0].isSelected = YES;
            }
            weakSelf.courseArr = model.lesson_list;
        }else{
            showTipDialog(NETWORK_NOT_POWER);
        }
        [weakSelf.tableView reloadData];
    } failBlock:^(NSError *error) {
        [weakSelf tableHeaderEndRefreshing];
        if (weakSelf.courseArr.count<1) {
            [weakSelf.tableView reloadData];
        }
    }];
}



@end
