//
//  HKBookDirectoryVC.m
//  Code
//
//  Created by Ivan li on 2019/7/16.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookDirectoryVC.h"
#import "HKPracticeModel.h"
#import "BaseVideoViewController.h"
#import "VideoPlayVC.h"
#import "HKBookDirectoryCell.h"
#import "HKBookModel.h"
  
#import "HKALIYunLogManage.h"



@interface HKBookDirectoryVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)UIView *bgView;

@property (nonatomic, strong)NSMutableArray <NSURLSessionDataTask *> *sessionTaskArray;

@end

@implementation HKBookDirectoryVC

- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)loadView {
    [super loadView];
    [self createUI];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 解决当前表格的滚动的Bug
    if ([self.parentViewController isKindOfClass:[BaseVideoViewController class]]) {
        UIScrollView *scrollView =  (UIScrollView *)self.parentViewController.view;
        scrollView.scrollEnabled = NO;
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // 解决当前表格的滚动的Bug
    if ([self.parentViewController isKindOfClass:[BaseVideoViewController class]]) {
        UIScrollView *scrollView =  (UIScrollView *)self.parentViewController.view;
        scrollView.scrollEnabled = YES;
    }
}


- (void)createUI {
    
    self.zf_prefersNavigationBarHidden = YES;
    [self addBgview];
    [self.view addSubview:self.tableView];
    [self setupHeaderView];
    //[self loadNewData];
    
    self.view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
    [self.bgView addGestureRecognizer:tapGesture];
}


- (void)addBgview {
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}


- (void)setBgViewBackGroundColor {
    _bgView.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.4];
    
    _tableView.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.y = SCREEN_HEIGHT/2;
    } completion:^(BOOL finished) {
    }];
}



- (void)tapGestureClick {
    [self closeBtnClick];
}



- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2) style:UITableViewStylePlain];
        [_tableView registerClass:[HKBookDirectoryCell class] forCellReuseIdentifier:NSStringFromClass([HKBookDirectoryCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, KTabBarHeight49, 0);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        _tableView.rowHeight = 50;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}



- (void)setupHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.height = 50;
    self.tableView.tableHeaderView = headerView;
    
    // title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightSemibold);
    titleLabel.textColor = COLOR_27323F_EFEFF6;
    titleLabel.text = @"目录";
    [titleLabel sizeToFit];
    titleLabel.x = 15;
    titleLabel.centerY = headerView.height * 0.5;
    [headerView addSubview:titleLabel];
    
    // 关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:imageName(@"ic_pulldown_v2_14") forState:UIControlStateNormal];
    [closeBtn setImage:imageName(@"ic_pulldown_v2_14") forState:UIControlStateSelected];
    closeBtn.width = 35;
    closeBtn.height = headerView.height;
    closeBtn.x = self.view.width - closeBtn.width;
    closeBtn.centerY = headerView.height * 0.5;
    [headerView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setHKEnlargeEdge:20];
    
    // 分割线
    UIView *separator = [[UIView alloc] init];
    separator.frame = CGRectMake(0, headerView.height - 1, self.view.width, 1);
    separator.backgroundColor = COLOR_F8F9FA_333D48;
    [headerView addSubview:separator];
     
    
}




- (void)closeBtnClick {
    [self removeCurrentVC];
}


- (void)removeCurrentVC {
    
    _bgView.backgroundColor = [UIColor clearColor];
    TTVIEW_RELEASE_SAFELY(_bgView);
    TTVIEW_RELEASE_SAFELY(_tableView);
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKBookModel *model = self.dataSource[indexPath.row];
    HKBookDirectoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKBookDirectoryCell class]) forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

#pragma mark <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HKBookModel *model = self.dataSource[indexPath.row];
    if (NO == model.is_playing) {
        // 1-选中未播放 需要切换     2- 正在播放的 只需关闭当前VC
        if (self.bookDirectoryCellClick) {
            self.bookDirectoryCellClick(model,indexPath.row);
        }
    }
    [self closeBtnClick];
}




- (void)setBookModel:(HKBookModel *)bookModel {
    if (NO == [bookModel.book_id isEqualToString:_bookModel.book_id]) {
        _bookModel = bookModel;
        [self loadNewData:bookModel];
    }else{
        _bookModel = bookModel;
        if (self.dataSource.count) {
            __block NSUInteger  index = 0;
            [self.dataSource enumerateObjectsUsingBlock:^(HKBookModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.is_playing = NO;
                if ([obj.course_id isEqualToString:bookModel.course_id]) {
                //if ([obj.book_course_id isEqualToString:bookModel.course_id]) {
                    obj.is_playing = YES;
                    index = idx;
                }
            }];
            [self.tableView reloadData];
            // 将正在播放的那行 滚动到顶部
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
        }else{
            [self loadNewData:bookModel];
        }
    }
}


- (void)setDataSource:(NSMutableArray<HKBookModel *> *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
    
    [dataSource enumerateObjectsUsingBlock:^(HKBookModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.is_playing) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            *stop = YES;
        }
    }];
}


- (void)resetData:(NSMutableArray<HKBookModel *> *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}




//#pragma mark <Server>
- (void)loadNewData:(HKBookModel*)bookModel{

    NSString *bookId = bookModel.book_id;
    if (isEmpty(bookId)) {
        return;
    }
    
    [self removeSessionTask];
    [[HKALIYunLogManage sharedInstance]hkBookClickLogWithFlag:@"1" bookId:bookId courseId:bookId];
    @weakify(self);
    NSDictionary *dict = @{@"book_id":bookId};
    
    NSURLSessionDataTask *sessionTask = [HKHttpTool hk_taskPost:BOOK_GET_CATALOG_LIST allUrl:nil isGet:NO parameters:dict success:^(id responseObject) {
    //[HKHttpTool POST:BOOK_GET_CATALOG_LIST parameters:dict success:^(id responseObject) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        if (HKReponseOK) {
            self.dataSource = [HKBookModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"catalogList"]];
            [self.dataSource enumerateObjectsUsingBlock:^(HKBookModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.is_playing = NO;
                //obj.book_id = bookModel.book_id;
                //if ([obj.book_course_id isEqualToString:bookModel.course_id]) {
                if ([obj.course_id isEqualToString:bookModel.course_id]) {
                    obj.is_playing = YES;
                }
            }];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
    
    [self.sessionTaskArray removeAllObjects];
    [self.sessionTaskArray addObject:sessionTask];
}



- (NSMutableArray <NSURLSessionDataTask *> *)sessionTaskArray{
    if (!_sessionTaskArray) {
        _sessionTaskArray = [NSMutableArray array];
    }
    return _sessionTaskArray;
}
                                         
 /// 取消网络请求
 - (void)removeSessionTask  {
     [self.sessionTaskArray enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if (obj.state == NSURLSessionTaskStateRunning || obj.state == NSURLSessionTaskStateSuspended ) {
             [obj cancel];
         }
     }];
 }

@end

