

//
//  HKUserLearnedVC.m
//  Code
//
//  Created by Ivan li on 2018/5/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTrainItemVC.h"
#import "HKTainItemDetailCell.h"
#import "HKTrainItemModel.h"
#import "UMpopView.h"
#import "VideoPlayVC.h"
#import "HKTrainTeacherQRCodeVC.h"
#import "HKTrainShareWebVC.h"
#import "HKUserInfoVC.h"
#import "HKPunchCardCell.h"
#import "HKTrainAddwxCell.h"
#import "HKTrainSectionHeaderView.h"
#import "MyTool.h"
#import "HKPunchClockModel.h"
#import "HKDayTaskVC.h"
//#import "HKEmptyDataCell.h"
#import "UIView+HKLayer.h"
#import "HKTrainDetailVC.h"

@interface HKTrainItemVC () <UITableViewDelegate,UITableViewDataSource, UMpopViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) HKTrainDetailModel * detailModel;
@property (nonatomic, copy) NSString * typeString;  //all: 全部 my:我的 black：小黑屋
@property (nonatomic, assign) int pages;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger tag;
@end


@implementation HKTrainItemVC

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigData];
    [self createUI];
    
    if (self.taskCalendarModel.is_start == 1) {
        @weakify(self);
        [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
            @strongify(self);
            self.tableView.footer.automaticallyHidden = YES;
            [self loadListData];
            
        }];
        
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.taskCalendarModel.is_start == 1) {
        [self getNewData];
        [self loadNewListData];
    }

    // 解决当前表格的滚动的Bug
    if ([self.parentViewController isKindOfClass:[HKTrainDetailVC class]]) {
        UIScrollView *scrollView =  (UIScrollView *)self.parentViewController.view;
        scrollView.scrollEnabled = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // 解决当前表格的滚动的Bug
    if ([self.parentViewController isKindOfClass:[HKTrainDetailVC class]]) {
        UIScrollView *scrollView =  (UIScrollView *)self.parentViewController.view;
        scrollView.scrollEnabled = YES;
    }
    
}

- (void)initConfigData{
    self.pages = 1;
    self.tag = 1;
    self.typeString = @"all";
}

- (void)createUI {
    [self.view addSubview:self.tableView];
    [self createLeftBarButton];
    self.view.backgroundColor = COLOR_F8F9FA_3D4752;
}

- (UITableView*)tableView {
    if (!_tableView) {//138 * Ratio + KNavBarHeight64
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -138 * Ratio - KNavBarHeight64) style:UITableViewStylePlain];
        _tableView.y = 0.5; // 分割线
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        self.extendedLayoutIncludesOpaqueBars = YES;
        if(@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
        } else{
            self.automaticallyAdjustsScrollViewInsets = false;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 10* Ratio, 0);
        _tableView.tb_EmptyDelegate = self;
        
        // 注册cell
        //任务项cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKPunchCardCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKPunchCardCell class])];
        //添加微信cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKTrainAddwxCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKTrainAddwxCell class])];
        //评论区cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKTainItemDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKTainItemDetailCell class])];
//        //评论区空数据cell
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKEmptyDataCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKEmptyDataCell class])];

        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 400;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}


#pragma mark - Table view data source
// 自定义空视图就
- (UIView *)tb_emptyView:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    
    UIView *myView = [[UIView alloc] init];
//    myView.backgroundColor = [UIColor orangeColor];
    myView.frame = CGRectMake(0, 0, self.view.width, 300);
    
    // 锁的图标
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = imageName(@"pic_key_v2_9");
    imageView.size = CGSizeMake(110, 110);
    imageView.centerX = myView.width * 0.5;
    imageView.y = 25;
    imageView.contentMode = UIViewContentModeCenter;
    [myView addSubview:imageView];
    
    // 暂未开始
    UILabel *notStartLB = [[UILabel alloc] init];
    notStartLB.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    notStartLB.textColor = HKColorFromHex(0x27323F, 1.0);
    notStartLB.text = @"暂未开始";
    [notStartLB sizeToFit];
    notStartLB.centerX = imageView.centerX;
    notStartLB.y = CGRectGetMaxY(imageView.frame) + 6.0;
    [myView addSubview:notStartLB];
    
    // 开课当天即可解锁该课程
    UILabel *notStartDesLB = [[UILabel alloc] init];
    notStartDesLB.font = [UIFont systemFontOfSize:15.0];
    notStartDesLB.textColor = HKColorFromHex(0x7B8196, 1.0);
    notStartDesLB.text = @"开课当天即可解锁该课程";
    [notStartDesLB sizeToFit];
    notStartDesLB.centerX = imageView.centerX;
    notStartDesLB.y = CGRectGetMaxY(notStartLB.frame) + 10.0;
    [myView addSubview:notStartDesLB];
    
    
    UIButton * addWxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addWxBtn.size = CGSizeMake(159, 38);
    addWxBtn.center = CGPointMake(notStartDesLB.centerX, notStartDesLB.centerY + 60* Ratio);
    [addWxBtn addCornerRadius:19 addBoderWithColor:[UIColor colorWithHexString:@"#FF7820"]];
    [addWxBtn setTitleColor:[UIColor colorWithHexString:@"#FF7820"] forState:UIControlStateNormal];
    [addWxBtn setTitle:@"添加班主任微信" forState:UIControlStateNormal];
    addWxBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [myView addSubview:addWxBtn];
    [addWxBtn addTarget:self action:@selector(addWxClick) forControlEvents:UIControlEventTouchUpInside];
    
    return myView;
}

- (void)addWxClick{
    self.showWeChatCodeBlock();
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.taskCalendarModel.is_start ? 2 : 0 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return self.dataArray.count ? self.dataArray.count : 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 第一组
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HKPunchCardCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKPunchCardCell class])];
            cell.detailModel = self.detailModel;
            WeakSelf
            cell.punchViewClickBlock = ^(HKAllTrainTaskModel * _Nonnull allModel, HKTrainTaskModel * _Nonnull taskModel) {
                if (allModel) {
                    HKDayTaskVC * vc = [HKDayTaskVC new];
                    vc.date = self.date;
                    vc.trainingId = self.trainingId;
                    [weakSelf pushToViewController:vc animated:YES];
                };
                if (taskModel) {
                    if (taskModel.live_status == 1) {
                        HKLivingPlayVC2 *vc = [[HKLivingPlayVC2 alloc] init];
                        vc.live_id = taskModel.sp_task_value;
                        [self pushToOtherController:vc];
                    }else if (taskModel.live_status == 0){
                        showTipDialog(@"课程未开始");
                    }else{
                        showTipDialog(@"课程已结束");
                    }
                }
            };
            return cell;
        }else {
            HKTrainAddwxCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKTrainAddwxCell class]) forIndexPath:indexPath];
            WeakSelf
            cell.addWxBlock = ^{
                weakSelf.showWeChatCodeBlock();
            };
            cell.thumbsLikeBlock = ^{
                if (self.detailModel.task_list.is_clock) {
                    HtmlShowVC * vc = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:self.detailModel.task_list.share_url];
                    [self pushToOtherController:vc];
                }else{
                    showTipDialog(@"你还没有作品可以展示哦");
                }
            };
            return cell;
        }
    } else {
//        if (self.dataArray.count == 0) {
//            HKEmptyDataCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKEmptyDataCell class])];
//            return cell;
//        }
        
        // 学员的作品
        HKTainItemDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKTainItemDetailCell class]) forIndexPath:indexPath];
        HKPunchClockModel * model = self.dataArray[indexPath.row];
        cell.punchClockModel = model;
        WeakSelf
        cell.coverIVTapBlock = ^(HKPunchClockModel * _Nonnull model) {
            [weakSelf watchHeightQualityImage:model];
        };
        cell.userHeaderIVTapBlock = ^(HKPunchClockModel * _Nonnull model) {
            HKUserInfoVC *vc = [[HKUserInfoVC alloc] init];
            vc.userId = model.uid;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        cell.deleteBlock = ^(HKPunchClockModel * model){
            [MyTool presentAlertController:@"确定删除作品吗" withMessage:@"删除后可重新提交作品" withViewController:self withCancelTxt:@"否" withSureTitle:@"是" withSureBlcok:^{
                [self detelProductData:model];
            }];
            
        };
        cell.likeBlock = ^(HKPunchClockModel * model) {
            [weakSelf postLike:model];
        };
        cell.typeString = self.typeString;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        HKPunchCardCell * cell =(HKPunchCardCell *) [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKPunchCardCell class])];
        cell.detailModel = self.detailModel;
        return [cell cellHight];
    }
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        @weakify(self);
        HKTrainSectionHeaderView * secView = [HKTrainSectionHeaderView createViewByFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) byDelegate:self];
        [secView clickBtnIndex:self.tag];
        secView.btnClickBlock = ^(NSInteger tag) {
            @strongify(self);
            self.tag = tag;
            if (tag == 1) {
                self.typeString = @"all"; ////all: 全部 my:我的 black：小黑屋
            }else if (tag == 2){
                self.typeString = @"my";
            }else{
                self.typeString = @"black";
            }
            [self loadNewListData];
        };
        return secView;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 1 ? 50:0.01;
}

#pragma mark <TBEmpty>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        // 观看视频作品
////        VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
////                                                    videoName:self.model.todayCourse.video_titel
////                                             placeholderImage:self.model.todayCourse.img_cover_url_big
////                                                   lookStatus:LookStatusInternetVideo videoId:self.model.todayCourse.video_id model:nil];
////        [self pushToOtherController:VC];
//
//        VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil placeholderImage:self.model.todayCourse.img_cover_url_big lookStatus:LookStatusInternetVideo videoId:self.model.todayCourse.video_id fromTrainCourse:YES];
//        [self pushToOtherController:VC];
//
//    } else if (indexPath.section == 0 && indexPath.row == 1 && self.model.todayCompleted) {
        // 分享作品
//        HKTrainShareWebVC *vc = [[HKTrainShareWebVC alloc] initWithNibName:nil bundle:nil url:self.model.myWork.myWorkH5Url];
//        vc.shareData = self.model.myWork.shareData;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}


#pragma mark <浏览大图>
- (void)watchHeightQualityImage:(HKPunchClockModel *)model {
    
    if (model.image_url.length) {
        [HKPhotoBrowserTool initPhotoBrowserWithUrl:model.image_url];
    }
}

//static int testDataCount = 10;
#pragma mark - 获取数据
#pragma mark <Server>
- (void)getNewData {
    @weakify(self);
    NSDictionary *param = @{@"date" : self.date, @"training_id" : self.trainingId};

    [HKHttpTool POST:HK_TrainingDatail_URL parameters:param success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            self.detailModel = [HKTrainDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self.tableView reloadData];
            //[self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadNewListData{
    self.pages = 1;
    [self loadListData];
}

- (void)loadListData{
    @weakify(self);
    NSDictionary *param = @{@"date" : self.date, @"training_id" : self.trainingId,@"type":self.typeString,@"pages":[NSNumber numberWithInt:self.pages]};

    [HKHttpTool POST:HK_TrainingWorkList_URL parameters:param success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            NSArray * data = [HKPunchClockModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (self.pages == 1) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:data];
            }else{
                [self.dataArray addObjectsFromArray:data];
            }
            if (data.count) {
                self.pages++;
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)postLike:(HKPunchClockModel *)model{
    NSString * type = model.like ? @"2":@"1";
    NSDictionary *param = @{@"task_id" : model.ID,@"type":type};

    [HKHttpTool POST:HK_TrainingWorkLike_URL parameters:param success:^(id responseObject) {
        if (HKReponseOK) {
            if (model.like) {
                model.like = 0;
                model.thumbs_up = [NSString stringWithFormat:@"%d",[model.thumbs_up intValue]-1];
            }else{
                model.like = 1;
                model.thumbs_up = [NSString stringWithFormat:@"%d",[model.thumbs_up intValue]+1];
            }
        }
    } failure:^(NSError *error) {
    }];
}


- (void)detelProductData:(HKPunchClockModel * )model{
    @weakify(self);
    NSDictionary *param = @{@"id" : model.ID};

    [HKHttpTool POST:HK_TrainingDeleWork_URL parameters:param success:^(id responseObject) {
        @strongify(self);
        if ([CommonFunction detalResponse:responseObject]) {
            [self getNewData];
            [self loadNewListData];
        }
        showTipDialog(responseObject[@"msg"]);
    } failure:^(NSError *error) {

    }];
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}



@end


