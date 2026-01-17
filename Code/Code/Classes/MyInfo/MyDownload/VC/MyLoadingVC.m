//
//  MyLoadingVC.m
//  Code
//
//  Created by Ivan li on 2017/8/28.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "MyLoadingVC.h"
#import "UIBarButtonItem+Extension.h"
#import "ZFNormalPlayer.h"

#import "VideoPlayVC.h"
#import "VideoModel.h"
#import "DownloadCacher.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
  
#import "Reachability.h"
#import "MyLoadingCell.h"
#import "MyDownloadBottomView.h"
#import "DownloadCacher.h"
#import "DownloadManager.h"
#import "HKDownloadManager.h"
#import "DownloadCacher+M3U8.h"
#import "HKBottomCapacityView.h"

@interface MyLoadingVC ()<UITableViewDataSource,UITableViewDelegate, TBSrollViewEmptyDelegate, HKDownloadManagerDelegate>

@property (strong, nonatomic) UITableView  *tableView;

@property (atomic, strong) NSMutableArray *loadingArray;

@property (atomic, strong) NSMutableArray *loadingArrayTemp;

@property (nonatomic, assign)BOOL isEditing;

@property (nonatomic, strong)UIButton * rightTopBtn;

@property (nonatomic, strong)MyDownloadBottomView * myBottomView;

@property (nonatomic, assign)NSInteger selectVideoCount;

@property (nonatomic, weak)UIButton *controlAllStateBtn;

@property (nonatomic, strong)HKBottomCapacityView *bottomCapacityView;

@property (nonatomic, strong)UIView *headerControl;

@property (nonatomic, assign)BOOL startAllOrPause;

@property (nonatomic, assign)NSInteger internetStatus;
@property (nonatomic, assign) BOOL isAllSelect;
@end

@implementation MyLoadingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    [self createUI];
    [self initData];

    
    if (self.internetStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        //手机流量
        showTipDialog(Mobile_Network);
    }
    self.emptyText = EMPETY_NO_DOWNLOAD;
    
    // wifi自动下载下一个
    [self autoDownloadNext];
}

- (NSInteger)internetStatus {
    
    return [HkNetworkManageCenter shareInstance].networkStatus;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)dealloc{
    
    HK_NOTIFICATION_REMOVE();
}

- (HKBottomCapacityView *)bottomCapacityView {
    if (_bottomCapacityView == nil) {
        HKBottomCapacityView *bottomCapacityView = [HKBottomCapacityView viewFromXib];
        bottomCapacityView.frame = CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40);
        _bottomCapacityView = bottomCapacityView;
    }
    return _bottomCapacityView;
}


- (void)createUI {
    self.title = @"正在下载";
    [self createLeftBarButton];
    [self setRightBarButtonItem];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.myBottomView];
    self.view.backgroundColor = COLOR_F8F9FA_333D48;
    [self setupHeaderView];
    [self.view addSubview:self.bottomCapacityView];
    [self.bottomCapacityView setSpace];
}


- (NSAttributedString *)tb_emptyButtonTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    return nil;
}


- (void)backAction {
    [MobClick event:UM_RECORD_DOWNLOAD_PAGE_BACK];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setRightBarButtonItem {
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setTitle:@"管理" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(editBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.rightTopBtn = btn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}


- (void)editBtnClicked {
    
    if (_loadingArray.count<1) {
        return;
    }
    self.isEditing = !self.isEditing;
    [self setRightBtnTitle:self.isEditing];
    
    NSDictionary *dict = nil;
    if (self.isEditing) {
        dict =  @{@"loadingedit": [NSString stringWithFormat:@"%d",1]};
    }else{
        dict =  @{@"loadingedit": [NSString stringWithFormat:@"%d",0]};
        [self clearAllBtnState];
    }
    [self hideOrShowBottomView];
    [MyNotification postNotificationName:@"loadingedit" object:nil userInfo:dict];
    
    // 设置header 开始/暂停
    if (self.isEditing) {
        self.tableView.tableHeaderView = nil;
    } else {
        self.tableView.tableHeaderView = self.headerControl;
    }
    [self.tableView reloadData];
}


#pragma mark - 隐藏,显示底部视图
- (void)hideOrShowBottomView {
    
    if (self.isEditing) {
        _myBottomView.hidden = NO;
        [_tableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-PADDING_25*2)];
    }else{
        [_tableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _myBottomView.hidden = YES;
    }
}



#pragma mark - 设置编辑按钮标题
- (void)setRightBtnTitle:(BOOL)isEdit {
    [self.rightTopBtn setTitle:isEdit ? @"完成" :@"管理" forState:UIControlStateNormal];
    self.bottomCapacityView.hidden = isEdit;
}




- (MyDownloadBottomView *)myBottomView {
    
    @weakify(self);
    if (!_myBottomView) {
        
        CGRect rect = IS_IPHONE_X ? CGRectMake(0, SCREEN_HEIGHT-PADDING_25*3, SCREEN_WIDTH, PADDING_25*3): CGRectMake(0, SCREEN_HEIGHT-PADDING_25*2, SCREEN_WIDTH, PADDING_25*2);
        
        //_myBottomView = [[MyDownloadBottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-PADDING_25*2, SCREEN_WIDTH, PADDING_25*2)];
        _myBottomView = [[MyDownloadBottomView alloc]initWithFrame:rect];
        _myBottomView.hidden = YES;
        _myBottomView.allSelectBlock = ^(UIButton *btn){
            @strongify(self);
            self.isAllSelect = btn.selected;
            [self allSelectOrNever:btn];
            [self.tableView reloadData];
        };
        
        _myBottomView.deleteBlock = ^(UIButton *btn) {
            @strongify(self);
            
            [self calculationSelectVideo];
            if (self.selectVideoCount <= 0) {
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
                    [self deleteSelectVideo];
                    self.isEditing = !self.isEditing;
                    [self hideOrShowBottomView];
                    
                    [self setRightBtnTitle:self.isEditing];
                };
            })
            .LeeHeaderColor([UIColor whiteColor])
            .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
            .LeeShow();
        };
    }
    return _myBottomView;
}



- (UITableView*)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.rowHeight = 130;
        //_tableView.separatorColor = RGB(240, 240, 240, 1);
        //_tableView.backgroundColor = COLOR_F6F6F6;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tb_EmptyDelegate = self;
        _tableView.estimatedSectionFooterHeight = 0.0;
        _tableView.estimatedSectionHeaderHeight = 0.0;
        _tableView.estimatedRowHeight = 0.0;
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_F8F9FA_3D4752;
        _tableView.separatorColor = COLOR_F8F9FA_333D48;
    }
    return _tableView;
}

- (void)setupHeaderView {
    UIView *header = [[UIView alloc] init];
    //header.backgroundColor = [UIColor whiteColor];
    header.backgroundColor = COLOR_FFFFFF_3D4752;
    header.height = 40;
    self.headerControl = header;
    self.tableView.tableHeaderView = header;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.backgroundColor =HKColorFromHex(0XF3F5F7, 1.0);
    button.backgroundColor = [UIColor hkdm_colorWithColorLight:HKColorFromHex(0XF3F5F7, 1.0) dark:COLOR_A8ABBE];
    button.frame = CGRectMake(10, 10, 213.85/2.0, 30);
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 30 * 0.5;
    [header addSubview:button];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 9, 0, 0)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 4)];
    //[button setTitleColor:HKColorFromHex(0X333333, 1.0) forState:UIControlStateNormal];
    UIColor *titleColor = [UIColor hkdm_colorWithColorLight:COLOR_333333 dark:COLOR_27323F];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitle:@"全部开始" forState:UIControlStateNormal];
    
    UIImage *normalImage = [UIImage hkdm_imageWithNameLight:@"start_download_btn" darkImageName:@"start_download_btn_dark"];
    [button setImage:normalImage forState:UIControlStateNormal];
    
    UIImage *selectImage = [UIImage hkdm_imageWithNameLight:@"pause_download_btn" darkImageName:@"pause_download_btn_dark"];
    [button setTitle:@"全部暂停" forState:UIControlStateSelected];
    [button setImage:selectImage forState:UIControlStateSelected];
    self.controlAllStateBtn = button;
    button.selected = self.startAllOrPause;
    [button addTarget:self action:@selector(startAllClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startAllClick:(UIButton *)button {
    [MobClick event:UM_RECORD_DOWN_ALLSTART];
    // 暂停全部
    if (button.selected) {
        NSLog(@"暂停全部");
        tb_showWaitingDialogWithStr(@"操作中,请稍后...");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[HKDownloadManager shareInstance] pauseAllTask];
        });
        
    } else {
        
        WeakSelf;
        NSInteger status =  weakSelf.internetStatus;
        if (status == AFNetworkReachabilityStatusNotReachable){
            showTipDialog(NETWORK_NOT_POWER_TRY);
            return ;
        }
        if(status != AFNetworkReachabilityStatusReachableViaWiFi){
            
            [LEEAlert alert].config
            .LeeAddTitle(^(UILabel *label) {
                label.text = @"流量提醒";
                label.textColor = [UIColor blackColor];
            })
            .LeeAddContent(^(UILabel *label) {
                label.text = Use_Mobile_Traffic;
                label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeCancel;
                action.title = @"稍后下载";
                action.titleColor = [UIColor colorWithHexString:@"#ff7c00"];
                action.backgroundColor = [UIColor whiteColor];
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeDefault;
                action.title = @"继续下载";
                action.titleColor = [UIColor colorWithHexString:@"#333333"];
                action.backgroundColor = [UIColor whiteColor];
                action.clickBlock = ^{
                    tb_showWaitingDialogWithStr(@"操作中,请稍后...");
                    button.selected = !button.selected;
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[HKDownloadManager shareInstance] startAllTask];
                    });
                };
            })
            .LeeHeaderColor([UIColor whiteColor])
            .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
            .LeeShow();
        }else{
            
            tb_showWaitingDialogWithStr(@"操作中,请稍后...");
            button.selected = !button.selected;
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[HKDownloadManager shareInstance] startAllTask];
            });
            
        }
        NSLog(@"开始全部");
    }
}



- (void)initData {
    
    @weakify(self);
    [[HKDownloadManager shareInstance] observerDownload:self array:^(NSMutableArray *notFinishArray, NSMutableArray *historyArray, NSMutableArray *directoryArray) {
     
        @strongify(self);
        //self.loadingArray = [notFinishArray mutableCopy]; // 正在下载，防止遍历的时候被修改
        // 排序
        self.loadingArray = [[notFinishArray reverseObjectEnumerator] allObjects].mutableCopy;
        
        self.tableView.tableHeaderView.hidden = self.loadingArray.count <= 0;
        BOOL hasDownloading = NO;
        for (HKDownloadModel *modelTemp in self.loadingArray) {
            if (modelTemp.status == HKDownloading || modelTemp.status == HKDownloadWaiting) {
                hasDownloading = YES;
                break;
            }
        }
        self.controlAllStateBtn.selected = self.startAllOrPause = hasDownloading;
        
        for (HKDownloadModel *model in self.loadingArray) {
            model.cellClickState = 0;
            model.row = 0;
            model.section = 0;
            model.indexState = 0;
        }
        
        
//        self.rightTopBtn.hidden = self.loadingArray.count ? NO : YES;
//        self.tableView.tableHeaderView.hidden = self.loadingArray.count ? NO : YES;
        // 移除头部开始/暂停按钮
        self.tableView.tableHeaderView.hidden = self.loadingArray.count <= 0;
        
        
        if (self.isEditing == YES) {
            if (self.isAllSelect) {
                for (HKDownloadModel *model in _loadingArray){
                    model.cellClickState = 1;
                }
            }else{
                for (HKDownloadModel *model in _loadingArray){
                    model.cellClickState = 0;
                }
            }
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }];
}

- (void)autoDownloadNext {
    
    // WIFI状态下 开启一个下载
    if (self.internetStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
        [[HKDownloadManager shareInstance] startAllFailedTask];
    }
}

#pragma mark <HKDownloadManagerDelegate>
- (void)download:(HKDownloadModel *)model notFinishArray:(NSMutableArray<HKDownloadModel *> *)array {
    
    // 清楚选中的属性
    model.cellClickState = 0;
    model.row = 0;
    model.section = 0;
    model.indexState = 0;
    
    //self.loadingArray = [array mutableCopy];
    // 排序
    self.loadingArray = [[array reverseObjectEnumerator] allObjects].mutableCopy;
    
    // 移除头部开始/暂停按钮
    self.tableView.tableHeaderView.hidden = self.loadingArray.count <= 0;
    BOOL hasDownloading = NO;
    for (HKDownloadModel *modelTemp in self.loadingArray) {
        if (modelTemp.status == HKDownloading || modelTemp.status == HKDownloadWaiting) {
            hasDownloading = YES;
            break;
        }
    }
    self.controlAllStateBtn.selected = self.startAllOrPause = hasDownloading;
    [self.bottomCapacityView setSpace];
    
    [self.tableView reloadData];
}

- (void)waitingDownload:(HKDownloadModel *)model {
    closeWaitingDialog();
    [self initData];
}

- (void)didFailedDownload:(HKDownloadModel *)model {
    closeWaitingDialog();
    [self initData];
}

- (void)beginDownload:(HKDownloadModel *)model {
    closeWaitingDialog();
    [self initData];
}

- (void)didPausedDownload:(HKDownloadModel *)model {
    closeWaitingDialog();
    [self initData];
}

- (void)download:(HKDownloadModel *)model progress:(NSProgress *)progress index:(NSString *)index {
    [self _updateDownload:model];
}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_loadingArray.count<=0) {
        return 0;
    }else {
        return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.loadingArrayTemp = [self.loadingArray mutableCopy];
    return self.loadingArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    MyLoadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyLoadingCell"];
    if (!cell ) {
        cell = [[MyLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:@"MyLoadingCell"];
    }
    [cell setAllModel:self.loadingArrayTemp[indexPath.row] isEdit:self.editing];
    
    cell.selectBlock = ^(BOOL value,HKDownloadModel *model){
        [weakSelf setOnlyRowStatus:value loadmodel:model];
        [weakSelf resetAllBtnState];
        [weakSelf calculationSelectVideo];
    };
    
    cell.btnClickBlock = ^(HKDownloadModel *model){
        
        NSInteger status =  weakSelf.internetStatus;
        if (status == AFNetworkReachabilityStatusNotReachable){
            showTipDialog(NETWORK_NOT_POWER_TRY);
            return ;
        }
        if(status == AFNetworkReachabilityStatusReachableViaWWAN && (model.status == HKDownloadPause || model.status == HKDownloadFailed) ){
            
            [LEEAlert alert].config
            .LeeAddTitle(^(UILabel *label) {
                label.text = @"流量提醒";
                label.textColor = [UIColor blackColor];
            })
            .LeeAddContent(^(UILabel *label) {
                label.text = Use_Mobile_Traffic;
                label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeCancel;
                action.title = @"稍后下载";
                action.titleColor = [UIColor colorWithHexString:@"#ff7c00"];
                action.backgroundColor = [UIColor whiteColor];
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeDefault;
                action.title = @"继续下载";
                action.titleColor = [UIColor colorWithHexString:@"#333333"];
                action.backgroundColor = [UIColor whiteColor];
                action.clickBlock = ^{
                    tb_showWaitingDialogWithStr(@"操作中,请稍后...");
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[HKDownloadManager shareInstance] downloadModel:model withDelegate:nil];
                        [weakSelf initData];

                    });
                };
            })
            .LeeHeaderColor([UIColor whiteColor])
            .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
            .LeeShow();
        }else{
            
            if (model.status == HKDownloadPause || model.status == HKDownloadFailed || model.status == HKDownloadWaiting) {
                // 开启
                tb_showWaitingDialogWithStr(@"操作中,请稍后...");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[HKDownloadManager shareInstance] downloadModel:model withDelegate:nil];
                });
            } else {
                // 暂停
                //dispatch_async(dispatch_get_global_queue(1, 1), ^{
                tb_showWaitingDialogWithStr(@"操作中,请稍后...");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[HKDownloadManager shareInstance] pauseTask:model openNext:YES completeBlock:nil];
                });
                //});
            }
            
            [weakSelf initData];
        }
    };
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_isEditing) {
        [self btnActionForUserSetting:indexPath];
    }else{
        MyLoadingCell *cell = (MyLoadingCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (cell.downloadModel) {
            [self changeDownStatus:cell.downloadModel];
        }
    }
}


- (void)changeDownStatus:(HKDownloadModel*)model {
    NSInteger status =  self.internetStatus;
    if (status == AFNetworkReachabilityStatusNotReachable){
        showTipDialog(NETWORK_NOT_POWER_TRY);
        return ;
    }
    if(status == AFNetworkReachabilityStatusReachableViaWWAN && (model.status == HKDownloadPause || model.status == HKDownloadFailed) ){
        
        @weakify(self);
        [LEEAlert alert].config
        .LeeAddTitle(^(UILabel *label) {
            label.text = @"流量提醒";
            label.textColor = [UIColor blackColor];
        })
        .LeeAddContent(^(UILabel *label) {
            label.text = Use_Mobile_Traffic;
            label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
        })
        .LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeCancel;
            action.title = @"稍后下载";
            action.titleColor = [UIColor colorWithHexString:@"#ff7c00"];
            action.backgroundColor = [UIColor whiteColor];
        })
        .LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeDefault;
            action.title = @"继续下载";
            action.titleColor = [UIColor colorWithHexString:@"#333333"];
            action.backgroundColor = [UIColor whiteColor];
            action.clickBlock = ^{
                tb_showWaitingDialogWithStr(@"操作中,请稍后...");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[HKDownloadManager shareInstance] downloadModel:model withDelegate:nil];
                });
                @strongify(self);
                [self initData];
            };
        })
        .LeeHeaderColor([UIColor whiteColor])
        .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
        .LeeShow();
    }else{
        
        //if (model.status == HKDownloadPause || model.status == HKDownloadFailed || model.status == HKDownloadWaiting) {
        if (model.status == HKDownloadPause || model.status == HKDownloadFailed) {
            // 开启
            tb_showWaitingDialogWithStr(@"操作中,请稍后...");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[HKDownloadManager shareInstance] downloadModel:model withDelegate:nil];
            });
        } else {
            // 暂停
            tb_showWaitingDialogWithStr(@"操作中,请稍后...");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[HKDownloadManager shareInstance] pauseTask:model openNext:YES completeBlock:nil];
            });
        }
        [self initData];
    }
}




#pragma mark - 当编辑状态 点击整行 选中
- (void)btnActionForUserSetting:(NSIndexPath*)indexPath {
    
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    MyLoadingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell clickAllRow:_isEditing];
}



#pragma mark - 删除选中视频
- (void)deleteSelectVideo {
    WeakSelf;
    // 提示文字(删除时间可以根据实际优化)
    tb_showWaitingDialogWithStr(@"删除文件中...");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 2.0)), dispatch_get_main_queue(), ^{
        closeWaitingDialog();
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray <HKDownloadModel*> *deleteArr = [NSMutableArray array];
        NSMutableArray *array = [NSMutableArray array];
        for (HKDownloadModel *model in self.loadingArray) {
            HKDownloadModel *modelTemp = [HKDownloadModel mj_objectWithKeyValues:model.mj_JSONString];
            [array addObject:modelTemp];
        }
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HKDownloadModel *model = obj;
            
            if (1 == model.cellClickState) {
                //[[HKDownloadManager shareInstance] deletedDownload:model delete:nil];
                [deleteArr addObject:model];
            }
        }];
        
        [[HKDownloadManager shareInstance] deletedDownloadArr:deleteArr];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 1.5)), dispatch_get_main_queue(), ^{
            if (self.editing) {
                self.tableView.tableHeaderView = nil;
            } else if (self.loadingArray.count > 0){
                self.tableView.tableHeaderView = self.headerControl;
            }
            [self.tableView reloadData];
        });
    });
}


#pragma mark - 清除所有按钮状态
- (void)clearAllBtnState {
    
    self.isEditing = NO;
    [self setRightBtnTitle:self.isEditing];
    _myBottomView.checkBoxBtn.selected = NO;
    [self hideOrShowBottomView];
    [self initData];
}



#pragma mark - 全选按钮状态
- (void)allSelectOrNever:(UIButton *)btn{
    
    if (btn.selected) {
        for (HKDownloadModel *model in _loadingArray){
            model.cellClickState = 1;
        }
    }else{
        for (HKDownloadModel *model in _loadingArray){
            model.cellClickState = 0;
        }
    }
}



#pragma mark - 修改单行 的选中。取消
- (void)setOnlyRowStatus:(BOOL)value loadmodel:(HKDownloadModel*)loadmodel {
    WeakSelf;
    if (value) {
        [_loadingArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HKDownloadModel *model = obj;
            if ([model.url isEqual:loadmodel.url]) {
                model.cellClickState = 1;
                [weakSelf.loadingArray replaceObjectAtIndex:idx withObject:model];
                *stop = YES;
            }
        }];
        
    }else{
        [_loadingArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            HKDownloadModel *model = obj;
            if ([model.url isEqual:loadmodel.url]) {
                model.cellClickState = 0;
                [weakSelf.loadingArray replaceObjectAtIndex:idx withObject:model];
                *stop = YES;
            }
        }];
    }
}


#pragma mark - 计算所选的视频
- (void)calculationSelectVideo {
    
    NSInteger count = 0;
    for (HKDownloadModel *model in _loadingArray){
        if (1 == model.cellClickState) {
            count ++;
        }
    }
    self.selectVideoCount = count;
}



#pragma mark - 重置全选按钮状态
- (void)resetAllBtnState {
    
    if (_loadingArray.count <= 0) {
        _myBottomView.checkBoxBtn.selected = NO;
        return;
    }
    for (HKDownloadModel *model in _loadingArray) {
        if (model.cellClickState == 0) {
            _myBottomView.checkBoxBtn.selected = NO;
            return;
        }
    }
    _myBottomView.checkBoxBtn.selected = YES;
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
            // NSLog(@"loading删除缓存文件成功");
        }
        if (removeError)
        {
            //NSLog(@"loading 删除文件 file=%@ 失败 err,err is %@",playurl,removeError);
        }
    }
}



#pragma mark - 下载通知
- (void)_updateDownload:(HKDownloadModel *)downloadingMode
{
    // 修复旧版本下载通知bug
    if (![downloadingMode isMemberOfClass:[HKDownloadModel class]]) return;
    if (self.isEditing == NO) {
    }
    MyLoadingCell *cell = [self _findCellWithModel:downloadingMode];
    [cell updateDownloadModel:downloadingMode];
}

#pragma mark - 下载失败
- (void)_failedDownload:(NSNotification *)noti {
    if (self.isEditing == NO) {
        [self initData];
    }
}

#pragma mark - 下载开始
//- (void)_beginDownload:(NSNotification *)noti
//{
//    if (self.isEditing == NO) {
//        HKDownloadModel *tempModel = noti.object;
//        MyLoadingCell *cell = [self _findCellWithModel:tempModel];
//        [cell updateDownloadModel:tempModel];
//    }
//}

#pragma mark - 下载完成
//- (void)_finishDownload:(NSNotification *)noti {
//    if (self.isEditing == NO) {
//        [self initData];
//    }
//}


#pragma mark - 查找下载的cell 只有唯一个下载 cell
- (MyLoadingCell *)_findCellWithModel:(HKDownloadModel *)tempModel
{
    int index = 0;
    for (HKDownloadModel *model in self.loadingArray)
    {
        if ([model.videoId isEqual:tempModel.videoId])
        {
            break;
        }
        index++;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    MyLoadingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

@end


