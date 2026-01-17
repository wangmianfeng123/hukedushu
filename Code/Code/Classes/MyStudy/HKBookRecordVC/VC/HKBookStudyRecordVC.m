//
//  HKBookRecordVC.m
//  Code
//
//  Created by Ivan li on 2019/8/20.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookStudyRecordVC.h"
#import "HKBookRecordCell.h"
#import "HKBookModel.h"
#import "HKListeningBookVC.h"
#import "HKJobPathModel.h"
#import "HKDeleteLearnRecordView.h"
#import "HKAllLearnedVC.h"


@interface HKBookStudyRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,assign)NSInteger page;


@property(nonatomic,assign)BOOL isEditing;
@property(nonatomic,strong)HKDeleteLearnRecordView *myBottomView;
@property(nonatomic,strong)NSMutableArray *selectVideoArr;
//@property(nonatomic,assign)BOOL isVip;
@property(nonatomic,strong)NSMutableArray <NSIndexPath*>*indexPathArr;
@end


@implementation HKBookStudyRecordVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self refreshUI];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    HKAllLearnedVC * vc = (HKAllLearnedVC *)self.parentViewController;
    vc.rightBarEditBtn.hidden = self.dataArr.count ? NO :YES;
    if (!self.dataArr.count) {
        vc.rightBarEditBtn.selected = NO;
        self.isEditing = YES;
        [self editLearnedCell];
    }
}

- (void)createUI {
    [self.view addSubview:self.tableView];
    //[self.view addSubview:self.myBottomView];
    [self.navigationController.view addSubview:self.myBottomView];
    //监听数组变化
    [self addObserver:self forKeyPath:@"dataArr" options:NSKeyValueObservingOptionNew context:NULL];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    [self hideOrShowBottomView];
}

- (void)resetEditLearnedCell{
    self.isEditing = YES;
    [self editLearnedCell];
}

/** 编辑 （更新cell 约束） */
- (void)editLearnedCell {
    
    self.isEditing = !self.isEditing;
    [self hideOrShowBottomView];
    
    NSDictionary *dict =  @{@"isEditing":self.isEditing ?@1 :@0};
    HK_NOTIFICATION_POST_DICT(@"HKBookStudyRecordVC", nil, dict);
    for (HKBookModel *model in self.dataArr) {
        model.isCellSelected = NO;
    }
    [self.tableView reloadData];
}

- (HKDeleteLearnRecordView *)myBottomView {
    WeakSelf;
    if (!_myBottomView) {
        
        CGFloat y = IS_IPHONE_ProMax ? 83 * Ratio : KTabBarHeight49;
        CGRect rect = CGRectMake(0, SCREEN_HEIGHT-PADDING_25*2- y, SCREEN_WIDTH, PADDING_25*2);
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
        showTipDialog(@"您还没选择书籍");
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

#pragma mark - 重置全选按钮状态
- (void)resetAllBtnState {
    
    NSInteger count = [self selectVideoCount];
    [self setDeleteBtnState:count];
    
    for (HKBookModel *model in self.dataArr) {
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
        for (HKBookModel *model in self.dataArr){
            model.isCellSelected = 1;
        }
    }else{
        for (HKBookModel *model in self.dataArr){
            model.isCellSelected = 0;
        }
    }
    //[self setDeleteBtnState:btn.selected];
}

#pragma mark - 隐藏,显示底部视图
- (void)hideOrShowBottomView {
    
    if (self.isEditing && self.dataArr) {
        _myBottomView.hidden = NO;
        _tableView.contentInset = UIEdgeInsetsMake(kHeight44, 0, KTabBarHeight49+100 + kHeight44, 0);
    }else{
        _myBottomView.hidden = YES;
        _tableView.contentInset = UIEdgeInsetsMake(kHeight44, 0, KTabBarHeight49+ 100, 0);

        [_tableView scrollsToTop];
    }
//    [self hideOrShowToolbarView];
}

#pragma mark - 删除学习记录
- (void)deleteSelectRecord {
    
    NSMutableArray *arr = [NSMutableArray array];
    NSString __block *strIDS = @"";
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HKBookModel *model  = (HKBookModel*)obj;
        if (1 == model.isCellSelected) {
            
            [arr addObject:model.book_id];
            strIDS = [NSString stringWithFormat:@"%@,%@", strIDS, model.book_id];
            [self.selectVideoArr addObject:model];
            NSIndexPath *indexP = [NSIndexPath indexPathForRow:idx inSection:0];
            [self.indexPathArr addObject:indexP];
        }
    }];
    
    
    // 减掉最后一个逗号
    strIDS = [strIDS substringFromIndex:1];

    NSDictionary *dict = @{@"book_ids" : strIDS};
    
    [HKHttpTool POST:@"/book/delete-study-record" parameters:dict success:^(id responseObject) {
        if (HKReponseOK) {
            [self deleteRows];
        }
    } failure:^(NSError *error) {

    }];
}

#pragma mark - 删除row
- (void)deleteRows {
    
    //在想要发出array变化的地方调用
    [self willChangeValueForKey:@"dataArr"];
    // 删除 model
    [self.dataArr removeObjectsInArray:self.selectVideoArr];
    [self didChangeValueForKey:@"dataArr"];
        
    [self.tableView reloadData];
    
    self.myBottomView.checkBoxBtn.selected = NO;
    
    NSInteger count = [self selectVideoCount];
    [self setDeleteBtnState:count];
    //  清空数组
    [self.indexPathArr removeAllObjects];
    [self.selectVideoArr removeAllObjects];
    HKAllLearnedVC * vc = (HKAllLearnedVC *)self.parentViewController;
    vc.rightBarEditBtn.hidden = self.dataArr.count ? NO :YES;
    if (!self.dataArr.count) {
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


- (NSMutableArray*)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


- (UITableView*)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.rowHeight = 127;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = COLOR_F6F6F6;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.contentInset = UIEdgeInsetsMake(kHeight44, 0, KTabBarHeight49 + 100, 0);
        [_tableView registerClass:[HKBookRecordCell class] forCellReuseIdentifier:NSStringFromClass([HKBookRecordCell class])];
        
        _tableView.separatorColor = [UIColor hkdm_colorWithColorLight:COLOR_F6F6F6 dark:COLOR_333D48];
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count ?1 :0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKBookRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKBookRecordCell class]) forIndexPath:indexPath];
    WeakSelf;
    cell.bookCellBlock = ^(HKBookModel * _Nonnull model) {
        [weakSelf resetAllBtnState];
    };
    
    cell.isEdit = self.isEditing;
    cell.model = self.dataArr[indexPath.row];

    return cell;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isEditing) {
        HKBookRecordCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell editSelectRow];
    }else{
        HKBookModel *model = self.dataArr[indexPath.row];
        if (!isEmpty(model.book_id)) {
            HKListeningBookVC *bookVC = [HKListeningBookVC new];
            bookVC.courseId = model.course_id;
            bookVC.bookId = model.book_id;
            [self pushToOtherController:bookVC];
        }
    }
}


#pragma mark - 刷新
- (void)refreshUI {
    
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        strongSelf.page = 1;
        [strongSelf loadNewData];
        
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        [strongSelf loadNewData];
    }];
    self.page = 1;
    [self.tableView.mj_header beginRefreshing];
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

- (void)loadNewData {
    
    @weakify(self);
    NSDictionary *dict = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page]};
    [HKHttpTool POST:BOOK_STUDIED_LIST parameters:dict success:^(id responseObject) {

        @strongify(self);
        [self tableHeaderEndRefreshing];
        if (HKReponseOK) {

            NSMutableArray *arr = [HKBookModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            HKJobPathPageInfoModel *pageModel = [HKJobPathPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (1 == self.page) {
                self.dataArr = arr;
            }else{
                [self.dataArr addObjectsFromArray:arr];
            }
            if (pageModel.current_page >= pageModel.page_total) {
                [self tableFooterEndRefreshing];
            }else{
                [self tableFooterStopRefreshing];
            }
            [self.tableView reloadData];
            self.page ++;
            HKAllLearnedVC * vc = (HKAllLearnedVC *)self.parentViewController;
            vc.rightBarEditBtn.hidden = self.dataArr.count ? NO :YES;
            if (!self.dataArr.count) {
                vc.rightBarEditBtn.selected = NO;
                self.isEditing = YES;
                [self editLearnedCell];
            }
        }
    } failure:^(NSError *error) {
        @strongify(self);
        [self tableHeaderEndRefreshing];
        [self tableFooterStopRefreshing];
    }];
}

#pragma mark - 计算所选的视频
- (NSInteger)selectVideoCount {
    
    NSInteger count = 0;
    for (HKBookModel *model in self.dataArr) {
        if (1 == model.isCellSelected) {
            count ++;
        }
    }
    return count;
}



- (void)setTableViewContentInset {
//    if (!self.isVip) {
//        // 普通用户
//        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64+55, 0, KTabBarHeight49, 0);
//    }else{
//    }
}








//[HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
//    [weakSelf clearAllBtnState];
//}];
@end
