//我的下载页面
//  MyDownloadVC.m
//  Code
//
//  Created by Ivan li on 2017/8/23.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "MyDownloadVC.h"
#import "UIBarButtonItem+Extension.h"
#import "ZFNormalPlayer.h"

#import "VideoPlayVC.h"
#import "VideoModel.h"

#import "DownloadCacher.h"
#import "DownloadManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
  
#import "MyDownloadIngCell.h"
#import "MyDownloadedCell.h"
#import "MyDownloadBottomView.h"

#import "MyLoadingVC.h"
#import "HKDownloadManager.h"
#import "HKShowDownloadCourseVC.h"
#import "HKBottomCapacityView.h"
#import "HKDownloadQABottomView.h"
#import "HtmlShowVC.h"
#import "HKOpenVipView.h"
#import "HKVIPCategoryVC.h"
#import "HKStudyNewVC.h"

@interface MyDownloadVC ()<UITableViewDataSource,UITableViewDelegate, TBSrollViewEmptyDelegate, HKDownloadManagerDelegate, HKDownloadQABottomViewDelegate>

@property (strong, nonatomic) UITableView  *tableView;

//@property (atomic, strong ) NSMutableArray *loadedArray;//已经下载   暂时看起来没什么用

@property (atomic, strong ) NSMutableArray *loadingArray;// 正在下载

@property (atomic, strong ) NSMutableArray *directoryArray;// 目录

@property (nonatomic, assign)BOOL isEditing; //是否编辑状态

@property (nonatomic, strong)UIButton * rightTopBtn;

@property (nonatomic, strong)MyDownloadBottomView * myBottomView;

@property (nonatomic, assign)NSInteger selectVideoCount;

@property (nonatomic, strong)HKBottomCapacityView *bottomCapacityView;

@property (nonatomic, strong)HKDownloadQABottomView *downloadQABottomView;

@property (nonatomic, assign)BOOL hasBuyVip;

@property (nonatomic , strong) HKOpenVipView * openvipV;
@property (nonatomic , assign) BOOL  isLoading;

@end

@implementation MyDownloadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self createUI];
        [self _addObserver];
        [self initData:YES];
    });
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.bottomCapacityView.hidden = isLogin() ? NO :YES;
        self.downloadQABottomView.hidden = isLogin() ? NO :YES;
        [self.navigationController.view bringSubviewToFront:self.bottomCapacityView];
    });
    
    [self loadHasBuyVip];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.bottomCapacityView.hidden = YES;
    self.downloadQABottomView.hidden = YES;
}

- (HKBottomCapacityView *)bottomCapacityView {
    if (_bottomCapacityView == nil) {
        //(0, SCREEN_HEIGHT-PADDING_25*2-KTabBarHeight49, SCREEN_WIDTH, PADDING_25*2)
        HKBottomCapacityView *bottomCapacityView = [HKBottomCapacityView viewFromXib];
        CGFloat y = IS_IPHONE_ProMax ? 83 * Ratio : KTabBarHeight49;
        bottomCapacityView.frame = CGRectMake(0, SCREEN_HEIGHT - y - 30, SCREEN_WIDTH, 30);
        _bottomCapacityView = bottomCapacityView;
        //_downloadQABottomView.backgroundColor = [UIColor brownColor];
    }
    return _bottomCapacityView;
}

- (HKDownloadQABottomView *)downloadQABottomView {
    if (_downloadQABottomView == nil) {
        CGFloat y = IS_IPHONE_ProMax ? 83 * Ratio : KTabBarHeight49;
        HKDownloadQABottomView *downloadQABottomView = [HKDownloadQABottomView viewFromXib];
        downloadQABottomView.frame = CGRectMake(0, SCREEN_HEIGHT - y - 30 - 27.5, SCREEN_WIDTH, 27.5);
        _downloadQABottomView = downloadQABottomView;
        //_downloadQABottomView.backgroundColor = [UIColor redColor];
        downloadQABottomView.delegate = self;
        
    }
    return _downloadQABottomView;
}

#pragma mark <HKDownloadQABottomViewDelegate>
- (void)questionBtnClick {
    NSString *urlString = @"/site/download-problem";
    
    NSUInteger location = [BaseUrl rangeOfString:@"/" options:NSBackwardsSearch].location;//从后向前查找“？”，并截取？之后部分内容，不包括？
    NSString *string = [BaseUrl substringToIndex:location];
    string = [NSString stringWithFormat:@"%@%@", string, urlString];
    HtmlShowVC *htmlVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:string];
    htmlVC.title = @"下载相关";
    [self pushToOtherController:htmlVC];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick event:UM_RECORD_PERSON_DOWNLOADED];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self changeFinishStates];
}

- (void)backAction{
    [MobClick event:UM_RECORD_DOWNLOAD_PAGE_BACK];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createUI {
    
    self.title = @"我的下载";
    [self createLeftBarButton];
    //[self setRightBarButtonItem];
    [self.view addSubview:self.tableView];
    //[self.view addSubview:self.myBottomView];
    self.view.backgroundColor = COLOR_F8F9FA_333D48;
    [self.navigationController.view addSubview:self.myBottomView];
    [self.navigationController.view addSubview:self.bottomCapacityView];
    [self.bottomCapacityView setSpace];
    [self.navigationController.view addSubview:self.downloadQABottomView];
    self.emptyText = @"您还没有下载的内容";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view addSubview:self.openvipV];
    });


    WeakSelf
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        [weakSelf clearAllBtnState];
    }];
    
    self.isEditing = NO;
    [self setRightBtnTitle:NO];
    _myBottomView.checkBoxBtn.selected = NO;
    _myBottomView.deleteBtn.selected = NO;
    [self hideOrShowBottomView];
}

#pragma mark 汤彬框架隐藏重试按钮
- (NSAttributedString *)tb_emptyButtonTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    return nil;
}


- (void)editBtnClicked {
    
    if (self.directoryArray.count<1) {
        return;
    }
    [MobClick event: @"C1703008"];
    self.isEditing = !self.isEditing;
    [self setRightBtnTitle:self.isEditing];
    
    NSDictionary *dict = nil;
    CGFloat h = self.hasBuyVip ? 0 : 70;
    if (self.isEditing) {
        self.tableView.contentInset = UIEdgeInsetsMake(44 + h, 0, 50, 0);

        dict =  @{@"edit": [NSString stringWithFormat:@"%d",1]};
    }else{
        self.tableView.contentInset = UIEdgeInsetsMake(44 + h, 0, 30 + 27.5, 0);

        dict =  @{@"edit": [NSString stringWithFormat:@"%d",0]};
        [self clearAllBtnState];
    }
    [self hideOrShowBottomView];
    [MyNotification postNotificationName:@"edit" object:nil userInfo:dict];
    self.bottomCapacityView.hidden = self.isEditing;
    self.downloadQABottomView.hidden = self.isEditing;
}

- (void)changeFinishStates{
    self.isEditing = NO;
    [self setRightBtnTitle:NO];
    
//    [self clearAllBtnState];
    
    _myBottomView.checkBoxBtn.selected = NO;
    _myBottomView.deleteBtn.selected = NO;
//    [self initData:NO];
    [self.tableView.mj_header endRefreshing];
    
    
    [self hideOrShowBottomView];
    CGFloat h = self.hasBuyVip ? 0 : 70;
    self.tableView.contentInset = UIEdgeInsetsMake(44 + h, 0, 30 + 27.5, 0);
    NSDictionary *dict =  @{@"edit": [NSString stringWithFormat:@"%d",0]};
    [MyNotification postNotificationName:@"edit" object:nil userInfo:dict];
    self.bottomCapacityView.hidden = YES;
    self.downloadQABottomView.hidden = YES;
}

#pragma mark - 设置编辑按钮标题
- (void)setRightBtnTitle:(BOOL)isEdit {
    [self.rightTopBtn setTitle:isEdit ? @"完成" :@"管理" forState:UIControlStateNormal];
}

- (MyDownloadBottomView *)myBottomView {
    WeakSelf;
    if (!_myBottomView) {
        CGFloat y = IS_IPHONE_ProMax ? 83 * Ratio : KTabBarHeight49;
        CGRect rect = CGRectMake(0, SCREEN_HEIGHT-PADDING_25*2-y, SCREEN_WIDTH, PADDING_25*2);
        _myBottomView = [[MyDownloadBottomView alloc]initWithFrame:rect];
        _myBottomView.hidden = YES;
        _myBottomView.allSelectBlock = ^(UIButton *btn){
            [weakSelf allSelectOrNever:btn];
            [MyNotification postNotificationName:@"allOrQuitSelect" object:nil userInfo:nil];
        };
        
        WeakSelf;
        _myBottomView.deleteBlock = ^(UIButton *btn) {
            
            [weakSelf calculationSelectVideo];
            if (weakSelf.selectVideoCount < 1) {
                showTipDialog(@"您还没选择视频");
                return ;
            }
                [LEEAlert alert].config
                .LeeAddTitle(^(UILabel *label) {
                    label.text = @"删除所选内容";
                    label.textColor = [UIColor blackColor];
                })
                .LeeAddContent(^(UILabel *label) {
                    label.text = @"确定删除所选视频吗?";
                    [label setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ? 16:15]];
                    label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
                })
                .LeeAddAction(^(LEEAction *action) {
                    
                    action.type = LEEActionTypeCancel;
                    action.title = @"取消";
                    action.titleColor = [UIColor colorWithHexString:@"#333333"];
                    action.backgroundColor = [UIColor whiteColor];
                })
                .LeeAddAction(^(LEEAction *action) {
                    
                    action.type = LEEActionTypeDefault;
                    action.title = @"确定";
                    action.titleColor = [UIColor colorWithHexString:@"#ff7c00"];
                    action.backgroundColor = [UIColor whiteColor];
                    action.clickBlock = ^{
                        [weakSelf deleteSelectVideo];
                    };
                })
                .LeeHeaderColor([UIColor whiteColor])
                .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
                .LeeShow();
        };
    }
    return _myBottomView;
}

#pragma mark - 隐藏,显示底部视图
- (void)hideOrShowBottomView {
    [_tableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_EH - kHeight44 - KTabBarHeight49)];
    if (self.isEditing) {
        _myBottomView.hidden = NO;
    }else{
        _myBottomView.hidden = YES;
    }
}



- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_EH - kHeight44 - KTabBarHeight49) style:UITableViewStylePlain];
        _tableView.rowHeight = 130;
        _tableView.separatorColor = COLOR_F8F9FA;
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        _tableView.tableFooterView = [UIView new];
        //_tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tb_EmptyDelegate = self;
        
        HKAdjustsScrollViewInsetNever(self, _tableView);
//        _tableView.contentInset = UIEdgeInsetsMake(44, 0, 30 + 27.5, 0);
        _tableView.separatorColor = COLOR_F8F9FA_333D48;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}


- (void)initData:(BOOL)needLoading {
    
    
    if (self.isLoading == NO) {
        self.isLoading = YES;
        if (needLoading) {
            UIViewController * vc = [CommonFunction topViewController];
            if ([vc isKindOfClass:[HKStudyNewVC class]]) {
                tb_showWaitingDialogWithStr(@"视频数据加载中...");
            }
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                closeWaitingDialog();
            });
        }
        NSLog(@"=================10 %@",[NSDate date]);
        // 子线程读数据主线程刷新
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[HKDownloadManager shareInstance] observerDownload:self array:^(NSMutableArray *notFinishArray, NSMutableArray *historyArray, NSMutableArray *directoryArray) {
                NSLog(@"=================11 %@",[NSDate date]);
                self.isLoading = NO;
                //self.loadedArray = historyArray;//已经下载 （已经下载过的所有的视频model，排除了文件夹目录model）
                self.loadingArray = notFinishArray;// 正在下载
                
                
                NSMutableArray * videoArray = [NSMutableArray array];
                NSMutableArray * liveArray = [NSMutableArray array];
                for (HKDownloadModel *model in directoryArray) {
                    if (self.downLoadType == 1) {
                        if (model.videoType != 999) {
                            [videoArray addObject:model];
                        }
                    }else{
                        if (model.videoType == 999) {
                            [liveArray addObject:model];
                        }
                    }
                }
                
                if (self.downLoadType == 1) {
                    self.directoryArray = videoArray; // 目录（排除了目录没有视频的model）
                }else{
                    self.directoryArray = liveArray; // 目录（排除了目录没有视频的model）
                }
                
                for (HKDownloadModel *model in self.loadingArray) {
                    model.cellClickState = 0;
                    model.row = 0;
                    model.section = 0;
                    model.indexState = 0;
                }
                
                for (HKDownloadModel *model in self.directoryArray) {
                    model.cellClickState = 0;
                    model.row = 0;
                    model.section = 0;
                    model.indexState = 0;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"=================12 %@",[NSDate date]);
                    closeWaitingDialog();
                    [self.tableView reloadData];
                });
            }];
        });
    }
}

#pragma mark <HKDownloadManagerDelegate>
// 尚未完成的下载视频，包括正在下载，等待下载，暂停下载
- (void)download:(HKDownloadModel *)model notFinishArray:(NSMutableArray<HKDownloadModel *> *)array {
    
    model.cellClickState = 0;
    model.row = 0;
    model.section = 0;
    model.indexState = 0;
    
    // model已经自动添加到array
    self.loadingArray = array; // 尚未完成的
    [self.tableView reloadData];
}

// 已经完成下载的视频
- (void)downloaded:(HKDownloadModel *)model historyArray:(NSMutableArray<HKDownloadModel *> *)array {
    
    model.cellClickState = 0;
    model.row = 0;
    model.section = 0;
    model.indexState = 0;
    
    // model已经自动添加到array
//    self.loadedArray = array; // 已完成的
    
    // 计算剩余的空间
    [self.bottomCapacityView setSpace];
    [self.tableView reloadData];
    if (!self.isEditing) {
        [self initData:NO];
    }
}

// 已经完成下载的视频目录
- (void)downloaded:(HKDownloadModel *)model directory:(NSMutableArray<HKDownloadModel *> *)array {
    
    model.cellClickState = 0;
    model.row = 0;
    model.section = 0;
    model.indexState = 0;
    
    // model已经自动添加到array
    self.directoryArray = array; // 已完成的
    [self.tableView reloadData];
    if (!self.isEditing) {
        [self initData:NO];
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_loadingArray.count<=0 &&self.directoryArray.count<=0) {
        return 0;
    }else if (_loadingArray.count>0 && self.directoryArray.count<1 ) {
        return 1;
    }else if (_loadingArray.count<=0 && self.directoryArray.count>0 ) {
        return 1;
    }else{
        return 2;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 39;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_loadingArray.count<1 &&self.directoryArray.count<1) {
        return 0;
    }
    else if (_loadingArray.count>0 && self.directoryArray.count<1 ) {
        return PADDING_35*2;
    }
    else if (_loadingArray.count<1 && self.directoryArray.count>0 ) {
        return 130;
    }else{
        if (indexPath.section == 0) {
            return PADDING_35*2;
        }else{
            return 130;
        }
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = COLOR_F8F9FA_333D48;
    header.height = PADDING_15*2;
    
    UILabel *label = [[UILabel alloc] init];
    //[label setTextColor:HKColorFromHex(0x7B8196, 1.0)];
    [label setTextColor:COLOR_7B8196_A8ABBE];
    label.font = [UIFont systemFontOfSize:15.0];
    [header addSubview:label];
    
    
    UIButton * rightTopBtn = [UIButton buttonWithTitle:@"管理" titleColor:COLOR_27323F_EFEFF6 titleFont:@"14" imageName:nil];
    [rightTopBtn addTarget:self action:@selector(editBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:rightTopBtn];

    NSString *title = nil;
    if (_loadingArray.count<1 &&self.directoryArray.count<1) {
        title = nil;
    }
    else if (_loadingArray.count>0 && self.directoryArray.count<1 ) {
        title =  @"正在下载";
        rightTopBtn.hidden = YES;
    }
    else if (_loadingArray.count<1 && self.directoryArray.count>0 ) {
        title = @"已完成";
        rightTopBtn.hidden = NO;
        self.rightTopBtn = rightTopBtn;
    }else{
        if (0 == section) {
            title =  @"正在下载";
            rightTopBtn.hidden = YES;
        }else{
            title =  @"已完成";
            rightTopBtn.hidden = NO;
            self.rightTopBtn = rightTopBtn;
        }
    }
    [label setText:title];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(header);
    }];
    
    [rightTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.equalTo(header);
        make.right.equalTo(header).offset(-10);
    }];
    self.rightTopBtn.hidden = self.directoryArray.count? NO : YES;
    return header;
}

//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    view.tintColor = [UIColor whiteColor];
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    header.contentView.backgroundColor = COLOR_F6F6F6;
//    header.textLabel.textAlignment=NSTextAlignmentLeft;
//    [header.textLabel setTextColor:COLOR_666666];
//    [header.textLabel setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ?16:15]];
//
//    NSString *title = nil;
//    if (_loadingArray.count<1 &&self.directoryArray.count<1) {
//        title = nil;
//    }
//    else if (_loadingArray.count>0 && self.directoryArray.count<1 ) {
//        title =  @"正在下载";
//    }
//    else if (_loadingArray.count<1 && self.directoryArray.count>0 ) {
//        title = @"已完成";
//    }else{
//        if (0 == section) {
//            title =  @"正在下载";
//        }else{
//            title =  @"已完成";
//        }
//    }
//    [header.textLabel setText:title];
//}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_loadingArray.count<1 &&self.directoryArray.count<1) {
        return 0;
    }
    else if (_loadingArray.count>0 && self.directoryArray.count<1 ) {
        return 1;
    }
    else if (_loadingArray.count<1 && self.directoryArray.count>0 ) {
        return self.directoryArray.count;
    }else{
        if (0 == section) {
            if (self.loadingArray.count>0) {
                return 1;
            }
            return 0;
        }else {
            return self.self.directoryArray.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    if (_loadingArray.count<1 &&self.directoryArray.count<1) {
        return nil;
    }else if (_loadingArray.count>0 && self.directoryArray.count<1 ) {
        
            MyDownloadIngCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDownloadIngCell"];
            if (!cell ) {
                cell = [[MyDownloadIngCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:@"MyDownloadIngCell"];
            }
        [cell setCount:_loadingArray.count];
        return cell;
                
    }else if (_loadingArray.count<1 && self.directoryArray.count>0 ) {
        
            MyDownloadedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDownloadedCell"];
            if (!cell ) {
                cell = [[MyDownloadedCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:@"MyDownloadedCell"];
            }
            [cell setAllModel:self.directoryArray[indexPath.row] isEdit:self.editing];
            cell.selectBlock = ^(BOOL value){
                [weakSelf resetAllBtnState:value];
                [weakSelf calculationSelectVideo];
            };
            return cell;
        
        }else{
            if (indexPath.section == 0) {
                MyDownloadIngCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDownloadIngCell"];
                if (!cell ) {
                    cell = [[MyDownloadIngCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:@"MyDownloadIngCell"];
                }
                [cell setCount:_loadingArray.count];
                return cell;
            }else {
                
                MyDownloadedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDownloadedCell"];
                if (!cell ) {
                    cell = [[MyDownloadedCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"MyDownloadedCell"];
                }
                if (self.directoryArray.count>0) {
                    [cell setAllModel:self.directoryArray[indexPath.row] isEdit:self.editing];
                }
                cell.selectBlock = ^(BOOL value){
                    [weakSelf resetAllBtnState:value];
                    [weakSelf calculationSelectVideo];
                };
                return cell;
            }
        }
    return [UITableViewCell new];
}

- (void)pushVideoVCOrDirectory:(HKDownloadModel *)fileInfo {
    
    UIViewController *vc = nil;
    
    // 有文件夹目录的视频
    if (fileInfo.isDirectory) {
        
        HKShowDownloadCourseVC *directVC = [[HKShowDownloadCourseVC alloc] init];
        directVC.directoryModel = fileInfo;
        vc = directVC;
    } else {//只有单节的普通视频
        
        // 普通视频
        VideoPlayVC *videoPlayVC = [[VideoPlayVC alloc] initWithNibName:nil bundle:nil fileUrl:fileInfo.url videoName:fileInfo.name placeholderImage:fileInfo.imageUrl
                                                   lookStatus:LookStatusLocalVideo videoId:fileInfo.videoId model:fileInfo];
        videoPlayVC.videoType = fileInfo.videoType;
        videoPlayVC.isFromDownload = YES;
        vc = videoPlayVC;
    }
    
    // 设置已经学习
    if (fileInfo.needStudyLocal) {
        fileInfo.needStudyLocal = NO;
        [[HKDownloadManager shareInstance] changeNeedStudyLocal:fileInfo];
        [self.tableView reloadData];
    }
    
    [self pushToOtherController:vc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_loadingArray.count<1 &&self.directoryArray.count<1) {
        
    }
    else if (_loadingArray.count>0 && self.directoryArray.count<1 ) {
        //进入正在下载列表
        MyLoadingVC *loadingVC = [MyLoadingVC new];
        [self pushToOtherController:loadingVC];
    } else if (_loadingArray.count<1 && self.directoryArray.count>0 ) {
        
        if (_isEditing) {
            [self btnActionForUserSetting:indexPath];
        }else{
            //点击已经下载的视频
            HKDownloadModel *fileInfo = self.directoryArray[indexPath.row];
            [MobClick event: @"C1703004"];
            [self pushVideoVCOrDirectory:fileInfo];
        }
    }else{
        if (0 ==  indexPath.section) {
            //进入正在下载列表
            MyLoadingVC *loadingVC = [MyLoadingVC new];
            [self pushToOtherController:loadingVC];
        }else {
            if (_isEditing) {
                [self btnActionForUserSetting:indexPath];
            }else{
                //点击已经下载的视频
                HKDownloadModel *fileInfo = self.directoryArray[indexPath.row];
                [MobClick event: @"C1703004"];
                [self pushVideoVCOrDirectory:fileInfo];
            }
        }
    }
}

#pragma mark - 当编辑状态 点击整行 选中
- (void)btnActionForUserSetting:(NSIndexPath*)indexPath {
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    MyDownloadedCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell clickAllRow:_isEditing];
}


#pragma mark - 重置全选按钮状态
- (void)resetAllBtnState:(BOOL)selected {
    
    
    if (self.directoryArray.count <= 0) {
        _myBottomView.checkBoxBtn.selected = NO;
        _myBottomView.deleteBtn.selected = NO;
        return;
    }
    
    BOOL isHaveSelected = NO;
    BOOL isAllSelected = YES;
    for (HKDownloadModel *model in self.directoryArray) {
        if (model.cellClickState == 0) {
            if (isAllSelected) {
                isAllSelected = NO;
            }
        }else{
            isHaveSelected = YES;
        }
    }
    _myBottomView.deleteBtn.selected = isHaveSelected;
    _myBottomView.checkBoxBtn.selected = isAllSelected;
}


#pragma mark - 清除所有按钮状态
- (void)clearAllBtnState {
    self.isEditing = NO;
    [self setRightBtnTitle:self.isEditing];
    _myBottomView.checkBoxBtn.selected = NO;
    _myBottomView.deleteBtn.selected = NO;
    [self hideOrShowBottomView];
    [self initData:NO];
    [self.tableView.mj_header endRefreshing];
}




#pragma mark - 全选按钮状态
- (void)allSelectOrNever:(UIButton *)btn{
    
    if (btn.selected) {
        for (HKDownloadModel *model in self.directoryArray){
            model.cellClickState = 1;
        }
    }else{
        for (HKDownloadModel *model in self.directoryArray){
            model.cellClickState = 0;
        }
    }
    [self calculationSelectVideo];
}



#pragma mark - 计算所选的视频
- (void)calculationSelectVideo {
    
    NSInteger count = 0;
    for (HKDownloadModel *model in self.directoryArray){
        if (1 == model.cellClickState) {
            count ++;
        }
    }
    self.selectVideoCount = count;
}


#pragma mark - 计算所选的视频
- (void)deleteSelectVideo {
    
    // 提示文字(删除时间可以根据实际优化)
    tb_showWaitingDialogWithStr(@"删除文件中...");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 2.0)), dispatch_get_main_queue(), ^{
        closeWaitingDialog();
    });
    
    [self.directoryArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HKDownloadModel *model = obj;
        if (1 == model.cellClickState) {
            [[HKDownloadManager shareInstance] deletedDownload:model delete:nil];
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        //[weakSelf.tableView reloadData];
        [self clearAllBtnState];
        
        if (self.editing) {
            self.downloadQABottomView.hidden = YES;
            self.bottomCapacityView.hidden = YES;
        } else {
            self.downloadQABottomView.hidden = NO;
            self.bottomCapacityView.hidden = NO;
        }
        [self.tableView reloadData];
    });
}



-(void)cleanDownloadFiles:(HKDownloadModel*)downloadModel {
    
    HKDownloadModel *model = downloadModel;
    NSString *temp = [CommonFunction getM3U8LocalUrlWithVideoUrl:model.url];
    NSString * playurl = [NSString stringWithFormat:@"%@/%@",kLibraryCache,temp];
    // 直接删除缓存的文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:playurl]) {
        NSError *removeError = nil;
        if ([fileManager removeItemAtPath:playurl error:&removeError]) {
            //NSLog(@"load删除缓存文件成功");
        }
        if (removeError)
        {
            //NSLog(@"load 删除文件 file=%@ 失败 err,err is %@",playurl,removeError);
        }
    }
}






#pragma mark - 下载完成
- (void)_finishDownload:(NSNotification *)noti {
    
    if (!self.isEditing) {
        [self initData:NO];
    }
}


- (void)_addObserver {
//    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, loginSuccess);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_finishDownload:) name:DownloadFinishNotification object:nil];
}

- (void)_removeObserver {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DownloadFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNetworkStatusNotification object:nil];
}


- (void)loadHasBuyVip{
    @weakify(self);
    [HKHttpTool POST:@"/user-vip/has-buy-vip" parameters:nil success:^(id responseObject) {
        @strongify(self);
        self.hasBuyVip  = YES;
        if (HKReponseOK) {
            self.hasBuyVip =[responseObject[@"data"][@"hasBuyVip"] boolValue];
            self.openvipV.hidden = self.hasBuyVip;
        }
        [self setTableViewContentInset:self.hasBuyVip];
        
    } failure:^(NSError *error) {
        self.hasBuyVip  = YES;
        self.openvipV.hidden = YES;
        [self setTableViewContentInset:YES];
    }];
}

- (void)setTableViewContentInset:(BOOL)hasBuyVip{
    CGFloat h = hasBuyVip ? 0 : 70;
    
    if (self.isEditing) {
        self.tableView.contentInset = UIEdgeInsetsMake(44 + h, 0, 50, 0);
    }else{
        self.tableView.contentInset = UIEdgeInsetsMake(44 + h, 0, 30 + 27.5, 0);
    }
}

-(HKOpenVipView *)openvipV{
    if (_openvipV == nil) {
        _openvipV = [HKOpenVipView viewFromXib];
        _openvipV.frame = CGRectMake(0, 44, SCREEN_WIDTH, 70);
        _openvipV.hidden = NO;
        WeakSelf
        _openvipV.didOpenVipBtnBlock = ^{
            //跳转全站通
            [MobClick event:UM_RECORD_STUDY_PLAYLIST_BUY_VIP];
            HKVIPCategoryVC *VC = [HKVIPCategoryVC new];
            VC.class_type = @"999";
            [weakSelf pushToOtherController:VC];
            [HKALIYunLogManage sharedInstance].button_id = @"18";
            [MobClick event:@"C090201"];
            
        };
    }
    return _openvipV;
}
@end
