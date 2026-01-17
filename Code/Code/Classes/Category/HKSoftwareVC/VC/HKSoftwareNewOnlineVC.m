//
//  HKSoftwareNewOnlineVC.m
//  Code
//
//  Created by Ivan li on 2018/4/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKSoftwareNewOnlineVC.h"
#import "HKSoftwareCell.h"
#import "VideoPlayVC.h"
#import "HKJobPathVC.h"
#import "HKJobPathModel.h"
#import "HKBookModel.h"

@interface HKSoftwareNewOnlineVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger  page;

@property (nonatomic,weak)NSURLSessionDataTask *sessionTask;

@end

@implementation HKSoftwareNewOnlineVC



- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    [super loadView];
    [self createUI];
    self.hk_hideNavBarShadowImage = YES;
}


- (void)createUI {
    self.view.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_EFEFF6 dark:COLOR_333D48];
    [self.view addSubview:self.tableView];
     
    if (0 == self.type) {
        [MobClick event:UM_RECORD_VIP_RUANJIANRUMEN_HOME_HOT];
    }else{
        [MobClick event:UM_RECORD_VIP_RUANJIANRUMEN_HOME_NEW];
    }
    [self refreshUI];
}


- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.rowHeight = 85;
        //_tableView.separatorColor = COLOR_F8F9FA;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        if (IS_IPHONE5S) {
            [_tableView setContentInset:UIEdgeInsetsMake(0, 0, KTabBarHeight49+KNavBarHeight64+90, 0)];
        }else{
            [_tableView setContentInset:UIEdgeInsetsMake(0, 0, KTabBarHeight49+KNavBarHeight64+64, 0)];
        }
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _tableView;
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return  self.hotArr.count ? 1 :0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.hotArr.count ;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKSoftwareCell *cell = [HKSoftwareCell initCellWithTableView:tableView];
    if (0 == self.type) {
        VideoModel *model = self.hotArr[indexPath.row];
        model.index = indexPath.row;
        if (0 == indexPath.row) {
            model.tagImageName = @"gold_medal";
        }else if (1 == indexPath.row){
            model.tagImageName = @"silver_medal";
        }else if (2 == indexPath.row){
            model.tagImageName = @"bronze_medal";
        }
        [cell setModel:model type:self.type];
        
    }else{
        [cell setModel:self.hotArr[indexPath.row] type:self.type];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoModel *model = self.hotArr[indexPath.row];

    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
                                                videoName:model.name
                                         placeholderImage:nil
                                               lookStatus:LookStatusInternetVideo
                                                  videoId:model.video_id model:nil];
    [self pushToOtherController:VC];
    [MobClick event:um_ruanjianrumen_home_clicksoftware];
}



- (void)loadNewDataWithModel:(HKTagModel *)tagModel {
    _tagModel = tagModel;
    self.page = 1;
    [self getSoftwareList:self.page tagId:nil];
}


#pragma mark - 刷新
- (void)refreshUI {
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        strongSelf.page = 1;
        [strongSelf getSoftwareList:strongSelf.page tagId:nil];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf
        [strongSelf getSoftwareList:strongSelf.page tagId:nil];
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




#pragma mark - 分类列表
- (void)getSoftwareList:(NSInteger)page  tagId:(NSString*)tagId {
    
    //  1:最新 2:人工排序 其他:学习最多
    //NSDictionary *dict = @{@"sort":(0 == self.type) ?@"2" :@"1", @"page":@(page)};
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:@(page) forKey:@"page"];
    
    if (!isEmpty(self.tagModel.tagId)) {
        [dict setValue:self.tagModel.tagId forKey:@"tag_id"];
    }
    
    if (self.sessionTask) {
        if (self.sessionTask.state == NSURLSessionTaskStateRunning || self.sessionTask.state == NSURLSessionTaskStateSuspended ) {
            [self.sessionTask cancel];
        }
    }
    
    self.sessionTask =  [HKHttpTool hk_taskPost:VIDEO_SOFTWARE allUrl:nil isGet:NO parameters:dict success:^(id responseObject) {
        [self tableHeaderEndRefreshing];
        if (HKReponseOK) {
            
            NSMutableArray *hotArr = [VideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (1 == page) {
                self.hotArr = hotArr;
            }else{
                [self.hotArr addObjectsFromArray:hotArr];
            }
            
            HKJobPathPageInfoModel *pageModel = [HKJobPathPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (page >= pageModel.page_total) {
                [self tableFooterEndRefreshing];
            }else{
                [self tableFooterStopRefreshing];
            }
            [self.tableView reloadData];
            self.page ++;
        }
        
    } failure:^(NSError *error) {
        if (NSURLErrorCancelled != error.code) {
            [self tableHeaderEndRefreshing];
            [self tableFooterStopRefreshing];
        }
    }];
}


@end









@implementation HKSoftwareTitleView


- (void)createUI {
    [self.btnArr removeAllObjects];
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.titlesArr enumerateObjectsUsingBlock:^(HKTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *btn = [self button:obj.name index:idx];
        btn.selected = obj.isSelect;
        [self.btnArr addObject:btn];
    }];
    
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat countRow = 0;
    CGFloat countCol = 0;
    
    CGFloat margin_X = 6;
    CGFloat margin_Y = 8;
    
    CGFloat title_W = 80;
    CGFloat title_H = 26;
    
    if (NO == IS_IPAD) {
        title_W = floor((self.width - 3*margin_X)/4.0);
        if (title_W <80) {
            //一行显示 3个
            title_W = floor((self.width - 2*margin_X)/3.0);
        }
    }
    
    NSInteger count = self.btnArr.count;
    for (int i = 0; i < count; i++) {
        UIButton *subView = self.btnArr[i];
        subView.size = CGSizeMake(title_W, title_H);
        //if (subView.width > self.width) subView.width = self.width;
        if (currentX + subView.width + margin_X * countRow > self.width) {
            subView.x = 0;
            subView.y = (currentY += subView.height) + margin_Y * ++countCol;
            currentX = subView.width;
            countRow = 1;
        } else {
            subView.x = (currentX += subView.width) - subView.width + margin_X * countRow;
            subView.y = currentY + margin_Y * countCol;
            countRow ++;
        }
    }
}



- (void)setTitlesArr:(NSMutableArray<HKTagModel *> *)titlesArr {
    _titlesArr = titlesArr;
    [self removeAllSubviews];
    [self createUI];
}



- (NSMutableArray <UIButton*> *)btnArr {
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}


#pragma mark 重新 设置字体颜色 和背景
- (void)resetBtnNormalUI {
    for (UIButton *btn in self.btnArr) {
        [self setBtnTitleColor:btn];
        [self setBtnBgImage:btn];
    }
}


- (void)setBtnTitleColor:(UIButton*)btn {
    UIColor *titleColor = [UIColor hkdm_colorWithColorLight:COLOR_7B8196 dark:COLOR_27323F];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
}


- (void)setBtnBgImage:(UIButton*)btn {
    UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F8F9FA dark:COLOR_A8ABBE];
    [btn setBackgroundColor:bgColor forState:UIControlStateNormal];
}


- (UIButton*)button:(NSString*)title index:(NSInteger)index {
    
    UIColor *titleColor = [UIColor hkdm_colorWithColorLight:COLOR_7B8196 dark:COLOR_27323F];
    UIButton *btn = [UIButton buttonWithTitle:title titleColor:titleColor titleFont:@"12" imageName:nil];
    [btn setTitleColor:COLOR_FF7820 forState:UIControlStateSelected];
    
    UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F8F9FA dark:COLOR_A8ABBE];
    [btn setBackgroundColor:bgColor forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#FFF0E6"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 13;
    btn.height = 26;
    btn.tag = index;
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0,5, 0,5);
    [self addSubview:btn];
    return btn;
}


- (void)btnClick:(UIButton*)btn {
    
    HKTagModel *tagModel = self.titlesArr[btn.tag];
    if (tagModel.isSelect) {
        return;
    }
    
    [self.btnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected) {
            self.titlesArr[idx].isSelect = NO;
        }
        obj.selected = NO;
    }];
    
    tagModel.isSelect = !tagModel.isSelect;
    btn.selected = tagModel.isSelect;
    
    if (self.titleClickCallBack) {
        self.titleClickCallBack(btn.tag, self.titlesArr[btn.tag]);
    }
}

@end






