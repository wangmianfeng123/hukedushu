//
//  LearnedVC.m
//  Code
//
//  Created by Ivan li on 2017/7/20.
//  Copyright © 2017年 pg. All rights reserved.
//／

#import "LearnedVC.h"
#import "VideoModel.h"
#import "LearnedCell.h"
#import "VideoPlayVC.h"
#import "UIBarButtonItem+Extension.h"
#import "HKJobPathCourseVC.h"
#import "UIBarButtonItem+Badge.h"

#import "HKCollectionTagView.h"
#import "SeriseCourseModel.h"
#import "HKLearnToolbarView.h"
#import "HKDeleteLearnRecordView.h"
#import "HKVIPCategoryVC.h"
#import "HKAllLearnedVC.h"

@interface LearnedVC ()<UITableViewDelegate,UITableViewDataSource, TBSrollViewEmptyDelegate,HKCollectionTagViewDelegate>

@property(nonatomic,strong)UITableView    *tableView;
@property(nonatomic,strong)NSMutableArray  *dataArray;
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


@implementation LearnedVC



- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self refreshUI];
    //HK_NOTIFICATION_ADD(HKLoginSuccessNotification, loginSuccess);

}

//- (void)loginSuccess{
//    [self.tableView.mj_header beginRefreshing];
//}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self editLearnedCell];

}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick event:UM_RECORD__PERSON_PLAYLIST];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    HKAllLearnedVC * vc = (HKAllLearnedVC *)self.parentViewController;
    vc.rightBarEditBtn.hidden = self.dataArray.count ? NO :YES;
    if (!self.dataArray.count) {
        vc.rightBarEditBtn.selected = NO;
        self.isEditing = YES;
        [self editLearnedCell];
    }
}

- (void)resetEditLearnedCell{
    self.isEditing = YES;
    [self editLearnedCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
    [self removeObserver:self forKeyPath:@"dataArray"];
}


- (void)createUI {
    self.title = @"已学视频";
    self.videoType = @"1";
    //空视图
    self.emptyText = @"您还没有已学习的课程，前往首页挑选课程吧~";
    // 空视图 图片竖直 偏移距离
    self.verticalOffset =  -KNavBarHeight64 + PADDING_25;
    //[self createLeftBarButton];
    
    self.view.backgroundColor = COLOR_F8F9FA;
    
    [self.view addSubview:self.tableView];
    [self.navigationController.view addSubview:self.myBottomView];
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
    
    for (VideoModel * model in self.dataArray) {
        model.isCellSelected = NO;
    }
    [self.tableView reloadData];
}



- (HKLearnToolbarView*)toolbarView {
    
    if (!_toolbarView) {
        WeakSelf;
        _toolbarView = [[HKLearnToolbarView alloc]init];
        _toolbarView.tag = 200;
        _toolbarView.frame = CGRectMake(0, kHeight40, SCREEN_WIDTH,55);
        _toolbarView.hKLearnToolbarViewBlock = ^(id sender) {
            //跳转全站通
            [MobClick event:UM_RECORD_STUDY_PLAYLIST_BUY_VIP];
            HKVIPCategoryVC *VC = [HKVIPCategoryVC new];
            VC.class_type = @"999";
            [weakSelf pushToOtherController:VC];
            [HKALIYunLogManage sharedInstance].button_id = @"18";
        };
    }
    return _toolbarView;
}




- (HKDeleteLearnRecordView *)myBottomView {
    WeakSelf;
    if (!_myBottomView) {//self.view.height - kHeight44 - PADDING_25*3
        CGFloat y = IS_IPHONE_ProMax ? 83 * Ratio : KTabBarHeight49;
        CGRect rect = CGRectMake(0, SCREEN_HEIGHT-PADDING_25*2-y, SCREEN_WIDTH, PADDING_25*2);
        _myBottomView = [[HKDeleteLearnRecordView alloc]initWithFrame:rect];
        _myBottomView.hidden = YES;
        _myBottomView.checkTitlSelectedColor = COLOR_7B8196;
        _myBottomView.checkTitlNormalColor = COLOR_7B8196;
        
//        _myBottomView.allSelectBlock = ^(UIButton *btn){
//            [weakSelf allSelectOrNever:btn];
//            [weakSelf.tableView reloadData];
//        };
        
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
        action.titleColor = COLOR_555555;
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        action.title = @"确定";
        action.titleColor = [UIColor colorWithHexString:@"#0076FF"];
        action.clickBlock = ^{
            [weakSelf deleteSelectRecord];
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
    [self.tableView reloadData];
}



//#pragma mark - 全选按钮状态
//- (void)allSelectOrNever:(UIButton *)btn{
//
//    if (btn.selected) {
//        for (VideoModel *model in self.dataArray){
//            model.isCellSelected = 1;
//        }
//    }else{
//        for (VideoModel *model in self.dataArray){
//            model.isCellSelected = 0;
//        }
//    }
//    //[self setDeleteBtnState:btn.selected];
//}


#pragma mark - 隐藏,显示底部视图
- (void)hideOrShowBottomView {
    
    if (self.isEditing && self.dataCount) {
        _myBottomView.hidden = NO;
        _tableView.contentInset = UIEdgeInsetsMake(kHeight44, 0, 55 + 10, 0);
    }else{
        _myBottomView.hidden = YES;
        [self setTableViewContentInset];
        
    }
    [self hideOrShowToolbarView];
}



#pragma mark - 隐藏,显示 跳转到 VIP 工具栏
- (void)hideOrShowToolbarView {
    
    if (!self.isVip) {
        // 普通用户
        if (self.isEditing) {
            _toolbarView.hidden = YES;
        }else{
            _toolbarView.hidden = NO;
        }
    }
}



#pragma mark - 删除学习记录
- (void)deleteSelectRecord {
    
    NSMutableArray *arr = [NSMutableArray array];
    NSString __block *strIDS = @"";
    NSString __block *root_typeS = @"";
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VideoModel *model  = (VideoModel*)obj;
        if (1 == model.isCellSelected) {
            
            [arr addObject:model.root_id];
            strIDS = [NSString stringWithFormat:@"%@,%@", strIDS, model.root_id];
            root_typeS = [NSString stringWithFormat:@"%@,%@", root_typeS, model.root_type];
            [self.selectVideoArr addObject:model];
            NSIndexPath *indexP = [NSIndexPath indexPathForRow:idx inSection:0];
            [self.indexPathArr addObject:indexP];
        }
    }];
    
    if (strIDS.length) {
        // 减掉最后一个逗号
        strIDS = [strIDS substringFromIndex:1];
        root_typeS = [root_typeS substringFromIndex:1];;

        NSDictionary *dict = @{@"root_ids" : strIDS, @"root_types" : root_typeS};
        
        [HKHttpTool POST:USRR_DELETE_STUDY_RECORD parameters:dict success:^(id responseObject) {
            if (HKReponseOK) {
                [self deleteRows];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}


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
    
    HKAllLearnedVC * vc = (HKAllLearnedVC *)self.parentViewController;
    vc.rightBarEditBtn.hidden = self.dataArray.count ? NO :YES;
    if (!self.dataArray.count) {
        vc.rightBarEditBtn.selected = NO;
        self.isEditing = YES;
        [self editLearnedCell];
    }
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_EH - 40 - KTabBarHeight49 ) style:UITableViewStylePlain];
        _tableView.rowHeight = IS_IPHONE5S ? 120 :130;
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        [self setTableViewContentInset];
        _tableView.separatorColor = COLOR_F8F9FA_333D48;
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _tableView;
}


- (void)setTableViewContentInset {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.isVip) {
            // 普通用户
            _tableView.contentInset = UIEdgeInsetsMake(kHeight44 + 55, 0, 10, 0);
            [_tableView setContentOffset:CGPointMake(0, -kHeight44 -55)];
        }else{
            _tableView.contentInset = UIEdgeInsetsMake(kHeight44, 0, 10, 0);
        }
        [_tableView scrollsToTop];
    });
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count ? 1 :0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}


static NSString * const cellIdentifier = @"learnedCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LearnedCell *learnedCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!learnedCell ) {
        learnedCell = [[LearnedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    WeakSelf;
    learnedCell.learnedCellBlock = ^(VideoModel *model) {
        [weakSelf resetAllBtnState];
    };
    
    learnedCell.isEdit = self.isEditing;
    id model = self.dataArray[indexPath.row];
    if ([model isKindOfClass: [VideoModel class]]) {
        ((VideoModel*)model).videoType = ([self.videoType integerValue] == 2) ?HKVideoType_PGC :HKVideoType_Ordinary;
        learnedCell.model = model;
    }
    return learnedCell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoModel *model = self.dataArray[[indexPath row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isEditing) {
        LearnedCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell editSelectRow];
        
    }else if (model.root_type.intValue == 4) {
        // 职业路径
        HKJobPathCourseVC *VC = [HKJobPathCourseVC new];
        VC.courseId = model.root_id;
        [self pushToOtherController:VC];
        [MobClick event: @"C1704003"];
    } else {
        VideoPlayVC *VC = nil;
        
        if ([model isKindOfClass: [VideoModel class]]) {
            
            VideoModel  *tempModel = (VideoModel*)model;
            VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil
                                             fileUrl:tempModel.video_url
                                           videoName:tempModel.video_titel
                                    placeholderImage:tempModel.img_cover_url
                                          lookStatus:LookStatusInternetVideo videoId:tempModel.video_id model:tempModel];
            VC.videoType = ([self.videoType integerValue] == 2) ?HKVideoType_PGC :HKVideoType_Ordinary;
            VC.videoIdBlock = ^(NSString *video_id) {
                if (video_id.length) {
                    tempModel.video_id = video_id;
                }
            };
        }
        [self pushToOtherController:VC];
        [MobClick event: @"C1704003"];
    }
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
    
    @weakify(self);
    NSDictionary *param = @{@"page" : page, @"page_size" : @"8"};
    [HKHttpTool POST:@"user/already-study" parameters:param success:^(id responseObject) {
     
        @strongify(self);
        [self tableHeaderEndRefreshing];
        if (HKReponseOK) {
            
            NSString *vip =  [NSString stringWithFormat:@"%@",[responseObject[@"data"] objectForKey:@"is_vip"]];
            self.isVip = [vip intValue];
            
            NSInteger totalPage = [responseObject[@"data"][@"pageInfo"][@"page_total"] intValue];
            
            NSMutableArray *array = nil;
            // 兼容新老接口
            if (responseObject[@"data"][@"flag"] && [NSString stringWithFormat:@"%@", responseObject[@"data"][@"flag"]].intValue == 1) {
                array = [VideoModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"record"]];
                
                // 标识已学旧接口
                for (VideoModel *model in array) {
                    model.isOldAccess = YES;
                }
            } else {
                array = [VideoModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"list"]];
            }
            
            if (0 == array.count ||([page intValue] >= totalPage)) {
                [self tableFooterEndRefreshing];
            }else {
                [self tableFooterStopRefreshing];
            }
            
            //在想要发出array变化的地方调用
            [self willChangeValueForKey:@"dataArray"];
            if (1 == [page intValue]) {
                self.dataArray = array;
                if (!self.isVip) {
                    UIView *view = [self.view viewWithTag:200];
                    if (nil == view) {
                        [self.view addSubview:self.toolbarView];
                    }
                }else{
                    [self.toolbarView removeFromSuperview];
                }
            }else{
                [self.dataArray addObjectsFromArray:array];
            }
            [self didChangeValueForKey:@"dataArray"];
            self.page ++ ;
            self.dataCount = self.dataArray.count;
            HKAllLearnedVC * vc = (HKAllLearnedVC *)self.parentViewController;
            vc.rightBarEditBtn.hidden = self.dataArray.count ? NO :YES;
            if (!self.dataArray.count) {
                vc.rightBarEditBtn.selected = NO;
                self.isEditing = YES;
                [self editLearnedCell];
            }
            
        } else {
            [self tableFooterStopRefreshing];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
        @strongify(self);
        [self tableHeaderEndRefreshing];
        [self tableFooterStopRefreshing];
        [self.tableView reloadData];
    }];
    
}



@end







