//
//  LearnedVC.m
//  Code
//
//  Created by Ivan li on 2017/7/20.
//  Copyright © 2017年 pg. All rights reserved.
//／

#import "HKLiveLearnedVC.h"
#import "VideoModel.h"
#import "LearnedCell.h"
#import "VideoPlayVC.h"
#import "UIBarButtonItem+Extension.h"
#import "HKLiveNotLearnedMiddleCell.h"
#import "UIBarButtonItem+Badge.h"
#import "HKLiveCourseVC.h"
#import "HKCollectionTagView.h"
#import "SeriseCourseModel.h"
#import "HKLearnToolbarView.h"
#import "HKDeleteLearnRecordView.h"
#import "HKVIPCategoryVC.h"
#import "HKLiveListModel.h"
#import "HKMyLiveCell.h"


@interface HKLiveLearnedVC ()<UITableViewDelegate,UITableViewDataSource, TBSrollViewEmptyDelegate,HKCollectionTagViewDelegate>

@property(nonatomic,strong)UITableView    *tableView;
@property(nonatomic,strong)NSMutableArray  *dataArray;
@property(nonatomic,strong)NSMutableArray  *notStartLives;
@property(nonatomic,strong)HKCollectionTagView  *tabHeaderView;
@property(nonatomic,strong)NSMutableArray <SeriseTagModel*>*tagArr;
@property(nonatomic,strong)SeriseTagModel *tagModel;

/** 1- 普通视频 2-PGC (默认值-1) */
@property(nonatomic,copy)NSString *videoType;

@property(nonatomic,strong)HKLearnToolbarView *toolbarView;

@property(nonatomic,strong)HKDeleteLearnRecordView *myBottomView;

@property(nonatomic,assign)BOOL isEditing;

@property(nonatomic,strong)NSMutableArray *selectVideoArr;

@property(nonatomic,strong)NSMutableArray <NSIndexPath*>*indexPathArr;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isVip;

@end


@implementation HKLiveLearnedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self refreshUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [MobClick event:UM_RECORD__PERSON_PLAYLIST];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
    if ([self observationInfo]) {
        [self removeObserver:self forKeyPath:@"dataArray"];
    }
}


- (void)createUI {
    self.title = @"已学视频";
    self.videoType = @"1";
    //空视图
    self.emptyText = @"您还没有已学习的课程，前往首页挑选课程吧~";
    // 空视图 图片竖直 偏移距离
    self.verticalOffset =  -KNavBarHeight64 + PADDING_25;
    [self createLeftBarButton];
    
    self.view.backgroundColor = COLOR_F8F9FA_3D4752;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.myBottomView];
    //监听数组变化
    [self addObserver:self forKeyPath:@"dataArray" options:NSKeyValueObservingOptionNew context:NULL];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    [self hideOrShowBottomView];
}



/** 编辑 （更新cell 约束） */
- (void)editLearnedCell {
    
    self.isEditing = !self.isEditing;
    [self hideOrShowBottomView];
    
    NSDictionary *dict =  @{@"isEditing":self.isEditing ?@1 :@0};
    HK_NOTIFICATION_POST_DICT(@"LearnedVC", nil, dict);
}



- (HKLearnToolbarView*)toolbarView {
    
    if (!_toolbarView) {
        WeakSelf;
        _toolbarView = [[HKLearnToolbarView alloc]init];
        _toolbarView.tag = 200;
        _toolbarView.frame = CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH,55);
        _toolbarView.hKLearnToolbarViewBlock = ^(id sender) {
            //跳转全站通
//            [MobClick event:UM_RECORD_STUDY_PLAYLIST_BUY_VIP];
            HKVIPCategoryVC *VC = [HKVIPCategoryVC new];
            VC.class_type = @"999";
            [weakSelf pushToOtherController:VC];
        };
    }
    return _toolbarView;
}




- (HKDeleteLearnRecordView *)myBottomView {
    WeakSelf;
    if (!_myBottomView) {
        CGFloat y = IS_IPHONE_ProMax ? 83 * Ratio : KTabBarHeight49;
        CGRect rect = IS_IPHONE_X ? CGRectMake(0, SCREEN_HEIGHT-PADDING_25*3-44, SCREEN_WIDTH, PADDING_25*3): CGRectMake(0, SCREEN_HEIGHT-PADDING_25*2-44, SCREEN_WIDTH, PADDING_25*2);
        _myBottomView = [[HKDeleteLearnRecordView alloc]initWithFrame:rect];
        _myBottomView.hidden = YES;
        _myBottomView.checkTitlSelectedColor = COLOR_7B8196;
        _myBottomView.checkTitlNormalColor = COLOR_7B8196;
        
        _myBottomView.allSelectBlock = ^(UIButton *btn){
            [weakSelf allSelectOrNever:btn];
            [weakSelf.tableView reloadData];
        };
        
        _myBottomView.deleteBlock = ^(UIButton *btn) {
            [weakSelf setDeleteVideoAlert];
        };
    }
    return _myBottomView;
}



- (void)setDeleteVideoAlert {
    
    WeakSelf;
    NSInteger count = [self selectVideoCount];
    if (count <= 0) {
        showTipDialog(@"您还没选择视频");
        return ;
    }
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = @"确认删除提示";
        label.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightSemibold);
        label.textColor = COLOR_030303;
    })
    .LeeAddContent(^(UILabel *label) {
        label.text = @"确认删除该已学记录吗？";
        label.font = HK_FONT_SYSTEM(15);
        label.textColor = COLOR_030303;
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"取消";
        action.titleColor = [UIColor colorWithHexString:@"#555555"];
        action.backgroundColor = [UIColor whiteColor];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        action.title = @"确定";
        action.titleColor = [UIColor colorWithHexString:@"#0076FF"];
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            
            // 直播无删除功能
//            [weakSelf deleteSelectRecord];
        };
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}



#pragma mark - 删除按钮 选中状态
- (void)setDeleteBtnState:(NSInteger)count {
    _myBottomView.deleteBtn.selected = count ?YES :NO;
}


#pragma mark - 计算所选的视频
- (NSInteger)selectVideoCount {
    
    NSInteger count = 0;
    for (VideoModel *model in self.dataArray) {
        if (1 == model.isCellSelected) {
            count ++;
        }
    }
    return count;
}


#pragma mark - 重置全选按钮状态
- (void)resetAllBtnState {
    
    NSInteger count = [self selectVideoCount];
    [self setDeleteBtnState:count];
    
    for (VideoModel *model in self.dataArray) {
        if (0 == model.isCellSelected) {
            _myBottomView.checkBoxBtn.selected = NO;
            return;
        }
    }
    _myBottomView.checkBoxBtn.selected = YES;
}



#pragma mark - 全选按钮状态
- (void)allSelectOrNever:(UIButton *)btn{
    
    if (btn.selected) {
        for (VideoModel *model in self.dataArray){
            model.isCellSelected = 1;
        }
    }else{
        for (VideoModel *model in self.dataArray){
            model.isCellSelected = 0;
        }
    }
    //[self setDeleteBtnState:btn.selected];
}


#pragma mark - 隐藏,显示底部视图
- (void)hideOrShowBottomView {
    
    if (self.isEditing && self.dataCount) {
        _myBottomView.hidden = NO;
        _tableView.contentInset = UIEdgeInsetsMake(kHeight44, 0, 100, 0);
    }else{
        _myBottomView.hidden = YES;
        [self setTableViewContentInset];
        [_tableView scrollsToTop];
    }
//    [self hideOrShowToolbarView];
}



#pragma mark - 隐藏,显示 跳转到 VIP 工具栏
//- (void)hideOrShowToolbarView {
//
//    if (!self.isVip) {
//        // 普通用户
//        if (self.isEditing && self.dataCount) {
//            _toolbarView.hidden = YES;
//        }else{
//            _toolbarView.hidden = NO;
//        }
//    }
//}

#pragma mark - 删除row
- (void)deleteRows {
    
    //在想要发出array变化的地方调用
    [self willChangeValueForKey:@"dataArray"];
    // 删除 model
    [self.dataArray removeObjectsInArray:self.selectVideoArr];
    [self didChangeValueForKey:@"dataArray"];
    
    NSInteger dataCount = self.dataArray.count;
    self.dataCount = dataCount;
    
    if (dataCount) {
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:self.indexPathArr] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }else{
        [self.tableView reloadData];
        //加载
        [self getLearnedListWithPage:@"1"];
    }
    
    self.myBottomView.checkBoxBtn.selected = NO;
    
    NSInteger count = [self selectVideoCount];
    [self setDeleteBtnState:count];
    //  清空数组
    [self.indexPathArr removeAllObjects];
    [self.selectVideoArr removeAllObjects];
}



- (NSMutableArray<NSIndexPath*> *)indexPathArr {
    if (!_indexPathArr) {
        _indexPathArr = [[NSMutableArray alloc]init];
    }
    return _indexPathArr;
}


- (NSMutableArray *)selectVideoArr {
    if (!_selectVideoArr) {
        _selectVideoArr = [[NSMutableArray alloc]init];
    }
    return _selectVideoArr;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kHeight40, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_EH - KTabBarHeight49 ) style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        [self setTableViewContentInset];
        
        // 注册cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKLiveNotLearnedMiddleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKLiveNotLearnedMiddleCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKMyLiveCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKMyLiveCell class])];
        _tableView.separatorColor = COLOR_F8F9FA_333D48;
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _tableView;
}


- (void)setTableViewContentInset {
//    if (!self.isVip) {
//        // 普通用户
//        _tableView.contentInset = UIEdgeInsetsMake(kHeight44+55, 0, 10, 0);
//    }else{
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
//    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataArray.count == 0 && self.notStartLives.count == 0) {
        return 0;
    }else{
        return 2;
    }
    
    
//    if (self.dataArray.count && self.notStartLives.count) {
//        return 2;
//    } else if (self.dataArray.count || self.notStartLives.count) {
//        return 1;
//    } else {
//        return 0;
//    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rowCount = 0;
    if (section == 0) {
        rowCount = self.notStartLives.count;
    } else {
        rowCount = self.dataArray.count;
    }
    return rowCount;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor = COLOR_FFFFFF_3D4752;
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = COLOR_7B8196_A8ABBE;
    label.frame = CGRectMake(15, 5, 200, 35);
    label.textAlignment = NSTextAlignmentLeft;
    [myView addSubview:label];
    label.text = section ? @"更早之前:":@"今天:";
    //[label sizeToFit];
    return myView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.notStartLives.count ? 40 : 0.0;
    }else{
        return self.dataArray.count ? 40 : 0.0;
    }
    
    //return (section == 1 || !self.notStartLives.count)? 25 : 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}


static NSString * const cellIdentifier = @"learnedCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    if (indexPath.section == 0 && self.notStartLives.count) { // 未开始的
//        HKLiveNotLearnedMiddleCell *notStratCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKLiveNotLearnedMiddleCell class])];
//        notStratCell.videoSelectedBlock = ^(NSIndexPath *indexPath, VideoModel *videoNodel) {
//
//            // 未开始的点击
//            VideoModel *model = weakSelf.notStartLives[indexPath.row];
//            HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
//            VC.refreshBlock = ^(HKLiveListModel *model) {
//
//            };
//            VC.course_id = model.live_small_id;
//            [weakSelf pushToOtherController:VC];
//        };
//        notStratCell.videos = self.notStartLives;
        
        HKMyLiveCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKMyLiveCell class])];
        cell.videoModel = self.notStartLives[indexPath.row];
        
        return cell;
    } else { // 已经结束的
//        LearnedCell *learnedCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if (!learnedCell ) {
//            learnedCell = [[LearnedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        }
//        WeakSelf;
//        learnedCell.learnedCellBlock = ^(VideoModel *model) {
//            //[weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
//            [weakSelf resetAllBtnState];
//        };
//
//        learnedCell.isEdit = self.isEditing;
//        id model = self.dataArray[indexPath.row];
//        if ([model isKindOfClass: [VideoModel class]]) {
//            ((VideoModel*)model).videoType = ([self.videoType integerValue] == 2) ?HKVideoType_PGC :HKVideoType_Ordinary;
//            learnedCell.model = model;
//        }
//        return learnedCell;
        
        HKMyLiveCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKMyLiveCell class])];
        cell.videoModel = self.dataArray[indexPath.row];
        return cell;
    }
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MobClick event: study_intoplaylist_livetab_liveclass];
    VideoModel *model = nil;
    if (self.notStartLives.count && indexPath.section == 0) {
        //return; // 未开始的点击
        model = self.notStartLives[indexPath.row];
    }else{
        model = self.dataArray[indexPath.row];
    }
    HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
    
    VC.course_id = model.live_small_catalog_id;
    VC.refreshBlock = ^(HKLiveListModel *model) {
        
    };
    [self pushToOtherController:VC];
}



#pragma mark - 刷新
- (void)refreshUI {
    
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        strongSelf.page = 1;
        [strongSelf getLearnedListWithPage:[NSString stringWithFormat:@"%lu",strongSelf.page]];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf
        [strongSelf getLearnedListWithPage:[NSString stringWithFormat:@"%lu",strongSelf.page]];
    }];
    self.page = 1;
    [self getLearnedListWithPage:[NSString stringWithFormat:@"%lu",self.page]];
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
- (void)getLearnedListWithPage:(NSString*)page {
    
    WeakSelf;
    //NSDictionary *param = @{@"page" : page, @"page_size" : @"8"};
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setSafeObject:page forKey:@"page"];
    [param setSafeObject:@"20" forKey:@"page_size"];
    [param setSafeObject:self.payType forKey:@"pay_type"];
    
    //@"user/subscript-live-list"
    [HKHttpTool POST:@"live/study-list" parameters:param success:^(id responseObject) {
        
        StrongSelf;
        [strongSelf tableHeaderEndRefreshing];
        if (HKReponseOK) {
            
            // 尚未开始的
            //NSMutableArray *notStartLivesArrayTemp = [VideoModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"notStartLives"]];
            NSMutableArray *notStartLivesArrayTemp = [VideoModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"todayStudy"]];
            
            
            self.notStartLives = page.intValue == 1? notStartLivesArrayTemp : self.notStartLives;
            
            // 已经结束的
//            NSString *vip =  [NSString stringWithFormat:@"%@",[responseObject[@"data"] objectForKey:@"is_vip"]];
//            strongSelf.isVip = [vip intValue];
            strongSelf.isVip = YES; // 后台接口暂时不返回了
            
            NSInteger totalPage = [responseObject[@"data"][@"page_info"][@"page_total"] intValue];
            
            //NSMutableArray *array = [VideoModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"endedLiveList"]];
            NSMutableArray *array = [VideoModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"beforeTodayStudy"]];
            //NSMutableArray *array = [VideoModel mj_objectArrayWithKeyValuesArray:[response.data objectForKey:@"list"]];
            if (0 == array.count ||([page intValue] >= totalPage)) {
                [strongSelf tableFooterEndRefreshing];
            }else {
                [strongSelf tableFooterStopRefreshing];
            }
            
            //在想要发出array变化的地方调用
            [self willChangeValueForKey:@"dataArray"];
            if (1 == [page intValue]) {
                strongSelf.dataArray = array;
//                if (!self.isVip) {
//                    UIView *view = [self.view viewWithTag:200];
//                    if (nil == view) {
//                        [self.view addSubview:self.toolbarView];
//                    }
//                }
            }else{
                [strongSelf.dataArray addObjectsFromArray:array];
            }
            [self didChangeValueForKey:@"dataArray"];
            self.page ++ ;
            strongSelf.dataCount = strongSelf.dataArray.count;
            
        } else {
            [strongSelf tableFooterStopRefreshing];
        }
        
        [strongSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        StrongSelf;
        [strongSelf tableHeaderEndRefreshing];
        [strongSelf tableFooterStopRefreshing];
        [strongSelf.tableView reloadData];
        
    }];
    
    //    [[FWNetWorkServiceMediator sharedInstance] getStudyVideoListWithToken:nil pageNum:page videoType:self.videoType completion:^(FWServiceResponse *response) {
    //        StrongSelf;
    //        [strongSelf tableHeaderEndRefreshing];
    //        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
    //
    //            NSString *vip =  [NSString stringWithFormat:@"%@",[response.data objectForKey:@"is_vip"]];
    //            strongSelf.isVip = [vip intValue];
    //
    //            NSInteger totalPage = [response.data[@"totalPage"] intValue];
    //
    //            NSMutableArray *array = [VideoModel mj_objectArrayWithKeyValuesArray:[response.data objectForKey:@"record"]];
    //            //NSMutableArray *array = [VideoModel mj_objectArrayWithKeyValuesArray:[response.data objectForKey:@"list"]];
    //            if (0 == array.count ||([page intValue] == totalPage)) {
    //                [strongSelf tableFooterEndRefreshing];
    //            }else {
    //                [strongSelf tableFooterStopRefreshing];
    //            }
    //
    //            //在想要发出array变化的地方调用
    //            [self willChangeValueForKey:@"dataArray"];
    //            if (1 == [page intValue]) {
    //                strongSelf.dataArray = array;
    //                if (!self.isVip) {
    //                    UIView *view = [self.view viewWithTag:200];
    //                    if (nil == view) {
    //                        [self.view addSubview:self.toolbarView];
    //                    }
    //                }
    //            }else{
    //                [strongSelf.dataArray addObjectsFromArray:array];
    //            }
    //            [self didChangeValueForKey:@"dataArray"];
    //            self.page ++ ;
    //            strongSelf.dataCount = strongSelf.dataArray.count;
    //
    //        } else {
    //            [strongSelf tableFooterStopRefreshing];
    //        }
    //
    //        [strongSelf.tableView reloadData];
    //    } failBlock:^(NSError *error) {
    //        StrongSelf;
    //        [strongSelf tableHeaderEndRefreshing];
    //        [strongSelf tableFooterStopRefreshing];
    //        [strongSelf.tableView reloadData];
    //    }];
}



@end







