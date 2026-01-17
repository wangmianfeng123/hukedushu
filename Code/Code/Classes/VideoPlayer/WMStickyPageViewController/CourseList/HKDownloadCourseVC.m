//
//  HKCourseListVC.m
//  YUFoldingTableViewDemo
//
//  Created by administrator on 16/8/25.
//  Copyright © 2016年 xuanYuLin. All rights reserved.
//

#import "HKDownloadCourseVC.h"
#import "HKCourseModel.h"
#import "HKCourseDonwloadCell.h"
#import "DetailModel.h"
#import "VideoPlayVC.h"
#import "HKDownloadBottomView.h"
  
#import "HKDownloadModel.h"
#import "HKDownloadManager.h"
#import "HKBottomCapacityView.h"
#import "YUFoldingTableView.h"
#import "NSString+MD5.h"
#import "UIView+HKLayer.h"

@interface HKDownloadCourseVC ()<YUFoldingTableViewDelegate>

@property (nonatomic, weak) YUFoldingTableView *foldingTableView;

@property (nonatomic, strong)NSMutableArray<HKCourseModel *> *dataSource;//[@"data"][@"dir_list"]

@property (nonatomic, strong)HKDownloadBottomView * myBottomView;

@property (nonatomic, strong)NSMutableArray<HKCourseModel *> *courseDoloadArray;//需要下载的model数组

@property (nonatomic, strong)HKDownloadModel *downloadDirectoryModel;// 下载完成后的总目录  [@"data"][@"dir_data"]

// 移到指定位置
@property (nonatomic, strong)NSIndexPath *moveCurrentIndexPath;

@property (nonatomic, assign)int cacheCountFile;

@property (nonatomic, strong)HKBottomCapacityView *bottomCapacityView;

@property (nonatomic, assign) YUFoldingSectionHeaderArrowPosition arrowPosition;

@property (nonatomic, strong) UIButton  *rightBarBtn;

@property (nonatomic , strong) UILabel * tipLabel;
@property (nonatomic , strong) UIButton * urlBtn;
@property (nonatomic , strong) UIView * bgView ;
@end



@implementation HKDownloadCourseVC

- (HKBottomCapacityView *)bottomCapacityView {
    if (_bottomCapacityView == nil) {
        HKBottomCapacityView *bottomCapacityView = [HKBottomCapacityView viewFromXib];
        bottomCapacityView.frame = CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 30);
        _bottomCapacityView = bottomCapacityView;
    }
    return _bottomCapacityView;
}

- (NSMutableArray<HKCourseModel *> *)courseDoloadArray {
    if (_courseDoloadArray == nil) {
        _courseDoloadArray = [NSMutableArray array];
    }
    return _courseDoloadArray;
}

-(UILabel *)tipLabel{
    if (_tipLabel == nil) {
        _tipLabel = [UILabel labelWithTitle:CGRectZero title:@"素材及文件需要开通会员后在电脑端下载" titleColor:[UIColor colorWithHexString:@"#FF8A00"] titleFont:@"13" titleAligment:NSTextAlignmentLeft];
        _tipLabel.backgroundColor = [UIColor colorWithHexString:@"#FFF0E6"];
    }
    return _tipLabel;
}

-(UIButton *)urlBtn{
    if (_urlBtn == nil) {
        _urlBtn = [UIButton buttonWithTitle:@"复制链接" titleColor:[UIColor colorWithHexString:@"#FF8A00"] titleFont:@"11" imageName:nil];
        [_urlBtn addCornerRadius:9 addBoderWithColor:[UIColor colorWithHexString:@"#FF8A00"]];
        [_urlBtn setBackgroundColor:[UIColor colorWithHexString:@"#FFF0E6"]];
        [_urlBtn addTarget:self action:@selector(urlBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _urlBtn;
}

- (HKDownloadBottomView *)myBottomView {
    WeakSelf;
    if (!_myBottomView) {
        
        _myBottomView = [[HKDownloadBottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-PADDING_30*2 - 30, SCREEN_WIDTH, PADDING_30*2) viewType:HKDownloadBottomViewType_loading];
        
        _myBottomView.allSelectBlock = ^(UIButton *btn){
            
            // 选中全部
            if (btn.selected) {
                
                // 学习路径
                if (weakSelf.videlDetailModel.video_type.intValue == HKVideoType_LearnPath || weakSelf.videlDetailModel.video_type.intValue == HKVideoType_Practice) {
                    
                    for (int i = 0; i < weakSelf.dataSource.count; i++) {
                        HKCourseModel *courseDetial = weakSelf.dataSource[i];
                        
                        for (int j = 0; j < courseDetial.children.count; j++) {
                            HKCourseModel *childCourseDetial = courseDetial.children[j];
                            if (!childCourseDetial.islocalCache && ![weakSelf.courseDoloadArray containsObject:childCourseDetial]) {
                                [weakSelf.courseDoloadArray addObject:childCourseDetial];
                                childCourseDetial.isSelectedForDownload = YES;
                            }
                            
                            // 三级目录练习题
                            for (int k = 0; k < childCourseDetial.children.count; k++) {
                                HKCourseModel *practice = childCourseDetial.children[k];
                                if (!practice.islocalCache && ![weakSelf.courseDoloadArray containsObject:practice]) {
                                    [weakSelf.courseDoloadArray addObject:practice];
                                    practice.isSelectedForDownload = YES;
                                }
                            }
                        }
                    }
                } else {
                    // 系列课等其他
                    for (int j = 0; j < weakSelf.dataSource.count; j++) {
                        HKCourseModel *mdoel = weakSelf.dataSource[j];
                        if (!mdoel.islocalCache && ![weakSelf.courseDoloadArray containsObject:mdoel]) {
                            [weakSelf.courseDoloadArray addObject:mdoel];
                            mdoel.isSelectedForDownload = YES;
                        }
                    }
                }
                
                [weakSelf.foldingTableView reloadData];
            } else {
                
                // 取消选中全部
                for (HKCourseModel *model in weakSelf.courseDoloadArray) {
                    model.isSelectedForDownload = NO;
                }
                [weakSelf.courseDoloadArray removeAllObjects];
                [weakSelf.foldingTableView reloadData];
            }
        };
        
        _myBottomView.confirmBlock = ^(){
            
                if (weakSelf.videlDetailModel.can_download == NO) {
                    
                    [HKALIYunLogManage sharedInstance].button_id = @"8";
                    //没有下载权限
                    [HKH5PushToNative runtimePush:weakSelf.videlDetailModel.vipRedirect.redirect_package.className arr:weakSelf.videlDetailModel.vipRedirect.redirect_package.list currectVC:weakSelf];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        showTipDialog(@"仅付费vip可下载视频");
                    });

                }else{
                    // 确认下载
                    if (weakSelf.courseDoloadArray.count <= 0) {
                        showTipDialog(@"您还没选择视频");
                        return;
                    }
                    NSInteger status = [HkNetworkManageCenter shareInstance].networkStatus;
                    //NSInteger status = [weakSelf networkStatus];
                    if (status == AFNetworkReachabilityStatusNotReachable){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            showTipDialog(NETWORK_NOT_POWER_TRY);
                        });
                        return;
                    }
                    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                        // 批量下载
                        [weakSelf patchSave];
                        
                    }else if(status == AFNetworkReachabilityStatusReachableViaWWAN){
                        
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
                            action.titleColor = COLOR_ff7c00;
                            action.backgroundColor = [UIColor whiteColor];
                        })
                        .LeeAddAction(^(LEEAction *action) {
                            
                            action.type = LEEActionTypeDefault;
                            action.title = @"继续下载";
                            action.titleColor = COLOR_333333;
                            action.backgroundColor = [UIColor whiteColor];
                            action.clickBlock = ^{
                                
                                // 批量下载
                                [weakSelf patchSave];
                            };
                        })
                        .LeeHeaderColor([UIColor whiteColor])
                        .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
                        .LeeShow();
                }
            }
        };
    }
    return _myBottomView;
}




#pragma mark 批量保存
- (void)patchSave {
    
    WeakSelf;
    // 先保存封面
    //封面和视频存在在同一个表中，存储有耳机目录的视频，先存储文件夹信息，然后在存储目录视频信息
    [[HKDownloadManager shareInstance] saveDirectoryModel:weakSelf.downloadDirectoryModel];
    
    // 设置参数
    NSMutableArray *downloadArray = [NSMutableArray array];
    for (HKCourseModel *courseModel in weakSelf.courseDoloadArray) {
        HKDownloadModel *downloadModel = [HKDownloadModel mj_objectWithKeyValues:courseModel.mj_JSONData];
        
        downloadModel.videoType = courseModel.videoType;
        downloadModel.videoId = downloadModel.videoId.length? downloadModel.videoId : downloadModel.videoId;
        
        // 添加目录id
        downloadModel.parent_direct_id = weakSelf.downloadDirectoryModel.dir_id;
        downloadModel.parent_direct_type = weakSelf.downloadDirectoryModel.videoType;
        downloadModel.status = HKDownloadWaiting;
        // 设置缓存标识符
        courseModel.islocalCache = YES;
        [downloadArray addObject:downloadModel];
    }
    
    [[HKDownloadManager shareInstance] saveArrayParseLater:downloadArray block:nil];
    
    [weakSelf.foldingTableView reloadData];
    !weakSelf.selectedBlock? : weakSelf.selectedBlock(weakSelf.courseDoloadArray);
    [weakSelf.courseDoloadArray removeAllObjects];
    
    [weakSelf.navigationController popViewControllerAnimated:YES];
    showTipDialog(DownLoading_Tip);
}


- (YUFoldingTableView *)foldingTableView {
    if (_foldingTableView == nil) {
        CGFloat height = SCREEN_HEIGHT*2/3-44;
        BOOL isBuy = [self.videlDetailModel.course_data.is_buy isEqualToString:@"0"]; // 1-已购买课程 0-未购买课程
        if ([self.videlDetailModel.video_type integerValue] == HKVideoType_PGC && isBuy) {
            height = SCREEN_HEIGHT*2/3-44-55;
        }
        YUFoldingTableView *foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0,[self.videlDetailModel.is_show_tips isEqualToString:@"1"]? KNavBarHeight64 + 45:KNavBarHeight64, SCREEN_WIDTH, SCREEN_HEIGHT-45-KNavBarHeight64-PADDING_30 * 2 - 30)];
        _foldingTableView = foldingTableView;
        if (@available(iOS 15.0, *)) {
            _foldingTableView.sectionHeaderTopPadding = 0;
        }
        HKAdjustsScrollViewInsetNever(self, foldingTableView);
        //[foldingTableView setContentInset:UIEdgeInsetsMake(KNavBarHeight64, 0, PADDING_25 * 2 + 30, 0)];
        //[foldingTableView setContentInset:UIEdgeInsetsMake(KNavBarHeight64, 0, PADDING_30 * 2 + 30, 0)];
        foldingTableView.backgroundColor = COLOR_F6F6F6_3D4752;
        foldingTableView.separatorColor = COLOR_F6F6F6_3D4752;
        [self.view addSubview:foldingTableView];
    }
    return _foldingTableView;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  videoId:(NSString*)videoId  detailModel:(DetailModel*)model {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _videlDetailModel = model;
    }
    return self;
}

-(void)setVidelDetailModel:(DetailModel *)videlDetailModel{
    _videlDetailModel = videlDetailModel;
    [self traverseDataArray];
    [self.myBottomView.confirmBtn setTitle: self.videlDetailModel.can_download == NO ? @"开通VIP解锁下载权限":@"确认下载" forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",NSHomeDirectory());
    [self createLeftBarButton];
    self.title = @"批量下载";
    
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    
    if ([self.videlDetailModel.is_show_tips intValue] == 1) {
        UIView * bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#FFF0E6"];
        self.bgView = bgView;
        [self.view addSubview:self.bgView];
        [self.view addSubview:self.tipLabel];
        [self.view addSubview:self.urlBtn];
    }
    
    
    [self setupFoldingTableView];
    
    // 底部批量操作
    [self.view addSubview:self.myBottomView];
    
    if (self.videlDetailModel.can_download == NO) {
        [self.myBottomView.confirmBtn setTitle:@"开通VIP解锁下载权限" forState:UIControlStateNormal];
    }
    
    
    WeakSelf
    // 根据视频类型加载  1，软件入门  2，系列课，3上中下的课 4- pgc
    NSInteger videoType = [self.videlDetailModel.video_type integerValue];
    if (HKVideoType_LearnPath == videoType || HKVideoType_Practice == videoType) {
        
        [self loadNewData:^{
            //VIP权限判断
            [weakSelf traverseDataArray];
        }];
    } else if (HKVideoType_JobPath == videoType || HKVideoType_JobPath_Practice == videoType) {
        [self loadJobPathNewData:^{
            [weakSelf traverseDataArray];
        }];
    }else if (HKVideoType_Series == videoType || HKVideoType_UpDownCourse == videoType || HKVideoType_PGC == videoType) {
        //2，系列课 3上中下的课 4- pgc
        [self loadNewDataSeries:^{
            [weakSelf traverseDataArray];
        }];
    }
    [self.view addSubview:self.bottomCapacityView];
    [self.bottomCapacityView setSpace];
    
    [self setRightBarBtn];
    
    if ([self.videlDetailModel.is_show_tips intValue] == 1) {
        
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.top.equalTo(self.view).offset(KNavBarHeight64);
            make.height.mas_equalTo(45);
        }];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view).offset(0);
            make.top.equalTo(self.view).offset(KNavBarHeight64);
            make.height.mas_equalTo(45);
        }];
        
        [self.urlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-15);
            make.centerY.equalTo(_tipLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(60, 18));
        }];
    }
    
    [self createObserver];
}

#pragma mark - 通知
- (void)createObserver {
    
    //HK_NOTIFICATION_ADD(HKLoginSuccessNotification, loginSucessNotification:);
    HK_NOTIFICATION_ADD(HKBuyVIPSuccessNotification,buyVIPSuccessNotification:);
}

///** 登录 成功 */
//- (void)loginSucessNotification:(NSNotification *)noti {
//}


/** 购买VIP 成功 */
- (void)buyVIPSuccessNotification:(NSNotification *)noti {
    //if (nil != _playerView) {[_playerView zf_controlRemoveBuyVipView];}
//    [self getVideoDetailInfoWithId:self.videoId type:self.videoType isChangeVideo:NO isNextAutoPlay:NO isScrollCourseList:NO];
}


- (void)traverseDataArray{
    NSInteger type = self.videlDetailModel.video_type.intValue;
    if (HKVideoType_LearnPath == type || HKVideoType_Practice == type || HKVideoType_JobPath == type) {
        // 软件入门 职业路径
        for (int i = 0; i < self.dataSource.count; i++) {
            HKCourseModel *courseDetial = self.dataSource[i];
            
            for (int j = 0; j < courseDetial.children.count; j++) {
                HKCourseModel *childCourseDetial = courseDetial.children[j];
                childCourseDetial.canNotDown = !self.videlDetailModel.can_download;
                
                // 三级目录练习题
                for (int k = 0; k < childCourseDetial.children.count; k++) {
                    HKCourseModel *practice = childCourseDetial.children[k];
                    practice.canNotDown = !self.videlDetailModel.can_download;
                }
            }
        }
    } else {
        // 系列课等其他
        for (int j = 0; j < self.dataSource.count; j++) {
            HKCourseModel *mdoel = self.dataSource[j];
            mdoel.canNotDown = !self.videlDetailModel.can_download;
        }
    }
    [self.foldingTableView reloadData];
}

- (void)urlBtnClick{
    if (self.videlDetailModel.pc_url.length) {
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        pab.string = self.videlDetailModel.pc_url;
        showTipDialog(@"链接已复制，请在电脑浏览器打开");
        [MobClick event: downloadpage_copylink];
    }
}


- (void)dealloc {
    NSLog(@"销毁了");

    HK_NOTIFICATION_REMOVE();
}


/** 创建 baritem */
- (void)setRightBarBtn {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarBtn];
}


- (UIButton*)rightBarBtn {
    if (!_rightBarBtn) {
        _rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBarBtn.frame = CGRectMake(0, 0, 35, 40);
        _rightBarBtn.titleLabel.font = HK_FONT_SYSTEM(16);
        [_rightBarBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_rightBarBtn setTitle:@"取消全选" forState:UIControlStateSelected];
        [_rightBarBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
        [_rightBarBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateSelected];
        [_rightBarBtn setTitleColor:[COLOR_27323F_EFEFF6 colorWithAlphaComponent:0.4] forState:UIControlStateHighlighted];
        [_rightBarBtn addTarget:self action:@selector(rightBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightBarBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightBarBtn;
}


- (void)rightBarBtnClick:(UIButton*)btn {
    
    
    if (self.videlDetailModel.can_download == NO) {
        showTipDialog(@"请开通VIP解锁下载权限");
        return;
    }
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self allSelectCourse];
        btn.frame = CGRectMake(0, 0, 70, 40);
    } else {
        [self quitSelectCourse];
        btn.frame = CGRectMake(0, 0, 35, 40);
    }
}


///  选中全部
- (void)allSelectCourse {
    NSInteger type = self.videlDetailModel.video_type.intValue;
    if (HKVideoType_LearnPath == type || HKVideoType_Practice == type || HKVideoType_JobPath == type) {
        // 软件入门 职业路径
        for (int i = 0; i < self.dataSource.count; i++) {
            HKCourseModel *courseDetial = self.dataSource[i];
            
            for (int j = 0; j < courseDetial.children.count; j++) {
                HKCourseModel *childCourseDetial = courseDetial.children[j];
                if (!childCourseDetial.islocalCache && ![self.courseDoloadArray containsObject:childCourseDetial]) {
                    [self.courseDoloadArray addObject:childCourseDetial];
                    childCourseDetial.isSelectedForDownload = YES;
                }
                
                // 三级目录练习题
                for (int k = 0; k < childCourseDetial.children.count; k++) {
                    HKCourseModel *practice = childCourseDetial.children[k];
                    if (!practice.islocalCache && ![self.courseDoloadArray containsObject:practice]) {
                        [self.courseDoloadArray addObject:practice];
                        practice.isSelectedForDownload = YES;
                    }
                }
            }
        }
    } else {
        // 系列课等其他
        for (int j = 0; j < self.dataSource.count; j++) {
            HKCourseModel *mdoel = self.dataSource[j];
            if (!mdoel.islocalCache && ![self.courseDoloadArray containsObject:mdoel]) {
                [self.courseDoloadArray addObject:mdoel];
                mdoel.isSelectedForDownload = YES;
            }
        }
    }
    [self.foldingTableView reloadData];
}



/// 取消选中全部
- (void)quitSelectCourse {
    
    for (HKCourseModel *model in self.courseDoloadArray) {
        model.isSelectedForDownload = NO;
    }
    [self.courseDoloadArray removeAllObjects];
    [self.foldingTableView reloadData];
}




// 创建tableView
- (void)setupFoldingTableView {
    self.foldingTableView.foldingDelegate = self;
    // 默认展开
    self.foldingTableView.foldingState = YUFoldingSectionStateShow;
    
    // 注册Cell
    [self.foldingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKCourseDonwloadCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKCourseDonwloadCell class])];
    
    self.foldingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

/**
 设置表格刷新
 */
- (void)setupRefresh {
    MJRefreshNormalHeader *mj_header = nil;
    switch ([self.videlDetailModel.video_type integerValue]) {
        case HKVideoType_LearnPath: {
            mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        }
        break;
            
        case HKVideoType_JobPath: case HKVideoType_JobPath_Practice: {
            mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadJobPathNewData)];
        }
        break;
            
        case HKVideoType_Series: case HKVideoType_UpDownCourse: case HKVideoType_PGC: {
            mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataSeries)];
        }
        break;
            
        default:
            break;
    }
    mj_header.automaticallyChangeAlpha = YES;
    self.foldingTableView.mj_header = mj_header;
}

#pragma mark - YUFoldingTableViewDelegate / required（必须实现的代理）
// 返回箭头的位置
- (YUFoldingSectionHeaderArrowPosition)perferedArrowPositionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
{
    // 默认箭头在左
    return YUFoldingSectionHeaderArrowPositionRight;
}


- (NSInteger )numberOfSectionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
{
    // 系列课
    NSInteger type = [self.videlDetailModel.video_type integerValue];
    if (HKVideoType_Series == type || HKVideoType_UpDownCourse == type || HKVideoType_PGC == type){
        return 1;
    }
    return self.dataSource.count;
}



- (NSInteger )yuFoldingTableView:(YUFoldingTableView *)yuTableView numberOfRowsInSection:(NSInteger )section
{
    // 系列课
    NSInteger type = [self.videlDetailModel.video_type integerValue];
    if (HKVideoType_Series == type || HKVideoType_UpDownCourse == type ||HKVideoType_PGC == type) {
        return self.dataSource.count;
    }

    return [self getCountWithPractice:section];
}



- (NSInteger)getCountWithPractice:(NSInteger)section {
    NSInteger count = 0;
    
    NSArray<HKCourseModel *> *courseArray = self.dataSource[section].children;
    count += courseArray.count;
    for (int i = 0; i < courseArray.count; i++) {
        count += courseArray[i].children.count;
    }
    return count;
}

- (UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HKCourseDonwloadCell* cell = [yuTableView  dequeueReusableCellWithIdentifier:NSStringFromClass([HKCourseDonwloadCell class])];
    cell.isHKDownloadCourseVC = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 系列课
    NSInteger type = [self.videlDetailModel.video_type integerValue];
    if (type == HKVideoType_Series || type == HKVideoType_UpDownCourse || type == HKVideoType_PGC) {
        
        HKCourseModel *seriesCourseModel = self.dataSource[indexPath.row];
        //[cell setModel:seriesCourseModel hiddenSpeparator:YES isSeriesCourse:YES];
        [cell setModel:seriesCourseModel hiddenSpeparator:YES videoType:type];
    }else {// 软件入门
        // 设置属性
        BOOL notHideSeparator = YES;
        notHideSeparator = [self getCountWithPractice:indexPath.section] - 1 == indexPath.row;
        HKCourseModel *model = [self getModelWithBlock:indexPath];
            // 二级目录
        [cell setModel:model hiddenSpeparator:!notHideSeparator videoType:model.videoType];
    }
    return cell;
}

- (HKCourseModel *)getModelWithBlock:(NSIndexPath *)indexPath{
    int count = -1;
    HKCourseModel *catModel = self.dataSource[indexPath.section];
    
    // 2级目录
    for (int i = 0; i < catModel.children.count; i++) {
        HKCourseModel *courseModel = catModel.children[i];
        count++;
        if (count == indexPath.row) {
            return courseModel;
        } else {
            
            // 3级目录 练习题
            for (int j = 0; j < courseModel.children.count; j++) {
                HKCourseModel *practice = courseModel.children[j];
                count++;
                if (count == indexPath.row) {
                    return practice;
                }
            }
        }
    }
    return nil;
}


- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForHeaderInSection:(NSInteger )section
{
    // 系列课
    NSInteger type = [self.videlDetailModel.video_type integerValue];
    if (HKVideoType_Series == type || HKVideoType_UpDownCourse == type || HKVideoType_PGC == type) {
        return 0;
    }
    // 软件入门
    return 50;
}

- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger)section
{
    // 系列课
    NSInteger type = [self.videlDetailModel.video_type integerValue];
    if (HKVideoType_Series == type || HKVideoType_UpDownCourse == type || HKVideoType_PGC == type) {
        return nil;
    }
    
    return self.dataSource[section].title;
}

- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [yuTableView deselectRowAtIndexPath:indexPath animated:YES];
    HKCourseModel *courseModel = nil;
    
    // 软件入门和练习题
    NSInteger videoType = self.videlDetailModel.video_type.integerValue;
    if (videoType == HKVideoType_LearnPath || videoType == HKVideoType_Practice) {
        courseModel = [self getModelWithBlock:indexPath];
    }
    else if (videoType == HKVideoType_JobPath || videoType == HKVideoType_JobPath_Practice) {
        courseModel = [self getModelWithBlock:indexPath];
    }
    else {
        courseModel = self.dataSource[indexPath.row];
    }

    if (courseModel.canNotDown) return;
    // 如果已经下载了, 直接返回
    if (courseModel.islocalCache) return;
    
    // 修改选中状态
    if (courseModel.isSelectedForDownload) {
        [self.courseDoloadArray removeObject:courseModel];
    } else {
        [self.courseDoloadArray addObject:courseModel];
    }
    courseModel.isSelectedForDownload = !courseModel.isSelectedForDownload;
    
    // 选中全部
    NSInteger totalCount = 0;
    for (NSInteger section = 0; section < self.foldingTableView.numberOfSections; section++ ) {
        totalCount += [self.foldingTableView numberOfRowsInSection:section];
    }
    
    // 选中全部与否
    self.rightBarBtn.selected = (totalCount - self.cacheCountFile) == self.courseDoloadArray.count;
    if (self.rightBarBtn.selected) {
        self.rightBarBtn.frame = CGRectMake(0, 0, 70, 40);
    } else {
        self.rightBarBtn.frame = CGRectMake(0, 0, 35, 40);
    }
    self.myBottomView.checkBoxBtn.selected = (totalCount - self.cacheCountFile) == self.courseDoloadArray.count;
    
    self.myBottomView.confirmBtn.selected = self.courseDoloadArray.count >= 1;
    
    [self.foldingTableView reloadData];
}

#pragma mark - YUFoldingTableViewDelegate / optional （可选择实现的）

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView descriptionForHeaderInSection:(NSInteger )section
{
    return @"";
}

- (UIImage *)yuFoldingTableView:(YUFoldingTableView *)yuTableView arrowImageForSection:(NSInteger)section {
    return [UIImage hkdm_imageWithNameLight:@"more_course_list_arrow_right" darkImageName:@"more_course_list_arrow_right_dark"];
}

- (UIFont *)yuFoldingTableView:(YUFoldingTableView *)yuTableView fontForTitleInSection:(NSInteger )section {
    return [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
}

//- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView textColorForTitleInSection:(NSInteger )section{
//    return HKColorFromHex(0x333333, 1.0);
//}

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView textColorForTitleInSection:(NSInteger )section{
    return COLOR_27323F_EFEFF6;
}

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView backgroundColorForHeaderInSection:(NSInteger )section {
    return COLOR_FFFFFF_3D4752;
}



#pragma mark <Server>
- (void)loadNewData:(void(^)(void))resultBlock {
    WeakSelf;
    
    NSString *videoId = self.videlDetailModel.video_id;
    if (isEmpty(videoId)) {
        return;
    }
    
    [HKHttpTool POST:@"/video/route-batch-download" parameters:@{@"video_id" : self.videlDetailModel.video_id, @"video_type" : self.videlDetailModel.video_type} success:^(id responseObject) {
        HKCourseModel *courseSelectedModel = nil;
        if ([CommonFunction detalResponse:responseObject]) {
            // 下载视频的总目录
            self.downloadDirectoryModel = [HKDownloadModel mj_objectWithKeyValues:responseObject[@"data"][@"dir_data"]];
            
            self.downloadDirectoryModel.isDirectory = YES;
            self.downloadDirectoryModel.responseDicData = [NSKeyedArchiver archivedDataWithRootObject:responseObject]; // 转化二进制
            
            NSMutableArray *array = [HKCourseModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"dir_list"]];
            
            self.dataSource = array;
            
            // 自动移动indexPath
            NSIndexPath *moveCurrentIndexPath = nil;
            self.moveCurrentIndexPath = moveCurrentIndexPath;
            
            // 遍历找出正在播放的视频 一级目录章
            for (int i = 0; i < array.count; i++) {
                HKCourseModel *courseDetial = array[i];
                NSString *chatString = [NSString stringWithFormat:@"%d", i+1];
                courseDetial.title = [NSString stringWithFormat:@"第%@章 %@", [NSString translation:chatString],courseDetial.title];
                
                int currentRow = -1;
                // 二级目录 节
                for (int j = 0; j < courseDetial.children.count; j++) {
                    HKCourseModel *childCourseDetial = courseDetial.children[j];
                    currentRow++;
                    // 添加序列
                    childCourseDetial.praticeNO = [NSString stringWithFormat:@"%d-%d",i+1, j+1];
                    
                    // 当前观看的视频
                    if ([childCourseDetial.videoId isEqualToString:self.videlDetailModel.video_id]) {
                        childCourseDetial.currentWatching = YES;
                        courseSelectedModel = childCourseDetial;
                        moveCurrentIndexPath = [NSIndexPath indexPathForRow:currentRow inSection:i];
                    }
                    
                    // 查找缓存
                    HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:childCourseDetial.mj_JSONData];
                    // type
                    dowmloadModel.videoType = childCourseDetial.videoType;
                    dowmloadModel.videoId = childCourseDetial.videoId;
                    //遍历标记，是否本地已经下载完成
                    childCourseDetial.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadModel] != HKDownloadNotExist;
                    
                    // 缓存文件总数
                    if (childCourseDetial.islocalCache) {
                        self.cacheCountFile++;
                    }
                    
                    // 三级目录的练习题
                    for (int t = 0; t < childCourseDetial.children.count; t++) {
                        HKCourseModel *praticeModel = childCourseDetial.children[t];
                        currentRow++;
                        // 当前观看的视频
                        if ([praticeModel.videoId isEqualToString:self.videlDetailModel.video_id]) {
                            praticeModel.currentWatching = YES;
                            courseSelectedModel = praticeModel;
                            moveCurrentIndexPath = [NSIndexPath indexPathForRow:currentRow inSection:i];
                        }
                        
                        // 查找缓存
                        HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:praticeModel.mj_JSONData];
                        // type
                        dowmloadModel.videoType = praticeModel.videoType;
                        dowmloadModel.videoId = praticeModel.videoId;
                        
                        praticeModel.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadModel] != HKDownloadNotExist;
                        
                        // 缓存文件总数
                        if (praticeModel.islocalCache) {
                            self.cacheCountFile++;
                        }
                        
                    }
                }
            }
            
            // 刷新和空处理
            [weakSelf.foldingTableView.mj_header endRefreshing];
            [weakSelf.foldingTableView reloadData];
            
            // 移到指定位置 并且选中
            if (moveCurrentIndexPath) {
                [weakSelf.foldingTableView scrollToRowAtIndexPath:moveCurrentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                
                // 默认选中
                if (!courseSelectedModel.islocalCache) {
                    [weakSelf yuFoldingTableView:weakSelf.foldingTableView didSelectRowAtIndexPath:moveCurrentIndexPath];
                }
            }
            if (resultBlock) {
                resultBlock();
            }
        }else{
            showTipDialog(responseObject[@"data"][@"business_message"]);
        }
        
    } failure:^(NSError *error) {
        //showTipDialog(@"网络出错");
    }];
}



- (void)loadNewDataSeries:(void(^)(void))resultBlock {
    
    @weakify(self);
    if ([self.videlDetailModel.video_type integerValue] == HKVideoType_PGC) {
        
        [HKHttpTool POST:@"/video/series-batch-download" parameters:@{@"video_id" : self.videlDetailModel.video_id, @"video_type" : self.videlDetailModel.video_type} success:^(id responseObject) {
            @strongify(self);
            __block HKCourseModel *courseSelectedModel = nil;
            if ([CommonFunction detalResponse:responseObject]) {
                
                // 下载视频的总目录
                self.downloadDirectoryModel = [HKDownloadModel mj_objectWithKeyValues:responseObject[@"data"][@"dir_data"]];
                self.downloadDirectoryModel.isDirectory = YES;
                self.downloadDirectoryModel.responseDicData = [NSKeyedArchiver archivedDataWithRootObject:responseObject]; // 转化二进制
                
                // 自动移动indexPath
                __block NSIndexPath *moveCurrentIndexPath = nil;
                self.moveCurrentIndexPath = moveCurrentIndexPath;
                
                self.dataSource = [HKCourseModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"dir_list"]];
                __block int current = -1;
                [self.dataSource enumerateObjectsUsingBlock:^(HKCourseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.praticeNO = @"";
                    current++;
                    
                    // 当前正在观看的视频
                    if ([obj.video_id isEqualToString:self.videlDetailModel.video_id]) {
                        obj.currentWatching = YES;
                        courseSelectedModel = obj;
                        moveCurrentIndexPath = [NSIndexPath indexPathForRow:current inSection:0];
                        self.moveCurrentIndexPath = [NSIndexPath indexPathForRow:current inSection:0];
                    }
                    
                    // 查找缓存
                    HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:obj.mj_JSONData];
                    // type
                    dowmloadModel.videoType = obj.videoType;
                    dowmloadModel.videoId = dowmloadModel.videoId.length? dowmloadModel.videoId : obj.video_id;
                    obj.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadModel] != HKDownloadNotExist;
                    
                    // 缓存文件总数
                    if (obj.islocalCache) {
                        self.cacheCountFile++;
                    }
                }];
                [self.foldingTableView.mj_header endRefreshing];
                [self.foldingTableView reloadData];
                
                // 移到指定位置
                if (moveCurrentIndexPath) {
                    [self.foldingTableView scrollToRowAtIndexPath:moveCurrentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    
                    // 默认选中
                    if (!courseSelectedModel.islocalCache) {
                        [self yuFoldingTableView:self.foldingTableView didSelectRowAtIndexPath:moveCurrentIndexPath];
                    }
                }
                
                if (resultBlock) {
                    resultBlock();
                }
            }else{
                showTipDialog(responseObject[@"data"][@"business_message"]);
            }
        } failure:^(NSError *error) {
            //showTipDialog(@"网络出错");
        }];
    }else{
        
        [HKHttpTool POST:VIDEO_SERIES_BATCH_DOWNLOAD parameters:@{@"video_id" : self.videlDetailModel.video_id, @"video_type" : self.videlDetailModel.video_type} success:^(id responseObject) {
            @strongify(self);
            HKCourseModel *courseSelectedModel = nil;
            if (HKReponseOK) {
                
                // 自动移动indexPath
                NSIndexPath *moveCurrentIndexPath = nil;
                self.moveCurrentIndexPath = moveCurrentIndexPath;
                
                // 下载视频的总目录
                self.downloadDirectoryModel = [HKDownloadModel mj_objectWithKeyValues:responseObject[@"data"][@"dir_data"]];
                self.downloadDirectoryModel.isDirectory = YES;
                self.downloadDirectoryModel.responseDicData = [NSKeyedArchiver archivedDataWithRootObject:responseObject]; // 转化二进制
                
                NSMutableArray *array = [HKCourseModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"dir_list"]];
                
                self.dataSource = array;
                // 遍历找出正在播放的视频
                for (int i = 0; i < array.count; i++) {
                    HKCourseModel *courseDetial = array[i];
                    courseDetial.praticeNO = @"";
                    
                    // 正在观看的系列课
                    if ([courseDetial.video_id isEqualToString:self.videlDetailModel.video_id]) {
                        moveCurrentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        courseDetial.currentWatching = YES;
                        courseSelectedModel = courseDetial;
                    }
                    
                    // 查找缓存
                    HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:courseDetial.mj_JSONData];
                    // type
                    dowmloadModel.videoType = courseDetial.videoType;
                    dowmloadModel.videoId = dowmloadModel.videoId.length? dowmloadModel.videoId : courseDetial.video_id;
                    courseDetial.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadModel] != HKDownloadNotExist;
                    
                    // 缓存文件总数
                    if (courseDetial.islocalCache) {
                        self.cacheCountFile++;
                    }
                }
                // 刷新和空处理
                [self.foldingTableView.mj_header endRefreshing];
                [self.foldingTableView reloadData];
                
                // 移到指定位置
                if (moveCurrentIndexPath) {
                    [self.foldingTableView scrollToRowAtIndexPath:moveCurrentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    
                    // 默认选中
                    if (!courseSelectedModel.islocalCache) {
                        [self yuFoldingTableView:self.foldingTableView didSelectRowAtIndexPath:moveCurrentIndexPath];
                    }
                }
                if (resultBlock) {
                    resultBlock();
                }
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
}



- (void)loadJobPathNewData:(void(^)(void))resultBlock {
    
    @weakify(self);
    NSString *chapterId = self.videlDetailModel.chapterId;
    if (isEmpty(chapterId)) {
        return;
    }
    
    [HKHttpTool POST:CAREER_VIDEO_FETCH_DOWNLOAD_ROUTE parameters:@{@"chapter_id" : chapterId} success:^(id responseObject) {
        HKCourseModel *courseSelectedModel = nil;
        if ([CommonFunction detalResponse:responseObject]) {
            @strongify(self);
            // 下载视频的总目录
            self.downloadDirectoryModel = [HKDownloadModel mj_objectWithKeyValues:responseObject[@"data"][@"dir_data"]];
            self.downloadDirectoryModel.isDirectory = YES;
            self.downloadDirectoryModel.responseDicData = [NSKeyedArchiver archivedDataWithRootObject:responseObject]; // 转化二进制
            
            NSMutableArray *array = [HKCourseModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"dir_list"]];
            self.dataSource = array;
            
            // 自动移动indexPath
            NSIndexPath *moveCurrentIndexPath = nil;
            
            // 遍历找出正在播放的视频 一级目录章
            for (int i = 0; i < array.count; i++) {
                HKCourseModel *courseDetial = array[i];
                
                int currentRow = -1;
                // 二级目录 节
                for (int j = 0; j < courseDetial.children.count; j++) {
                    HKCourseModel *childCourseDetial = courseDetial.children[j];

                    // 将职业路径ID信息 赋给目录课程
                    childCourseDetial.career_id = courseDetial.ID;
                    childCourseDetial.chapter_id = courseDetial.chapter_id;
                    
                    currentRow++;
                    // 添加序列
                    childCourseDetial.praticeNO = [NSString stringWithFormat:@"%d-%d",i+1, j+1];
                    
                    // 当前观看的视频
                    if ([childCourseDetial.videoId isEqualToString:self.videlDetailModel.video_id]) {
                        childCourseDetial.currentWatching = YES;
                        courseSelectedModel = childCourseDetial;
                        moveCurrentIndexPath = [NSIndexPath indexPathForRow:currentRow inSection:i];
                    }
                    
                    // 查找缓存
                    HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:childCourseDetial.mj_JSONData];
                    // type
                    dowmloadModel.videoType = childCourseDetial.videoType;
                    dowmloadModel.videoId = childCourseDetial.videoId;
                    childCourseDetial.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadModel] != HKDownloadNotExist;
                    
                    // 缓存文件总数
                    if (childCourseDetial.islocalCache) {
                        self.cacheCountFile++;
                    }
                    
                    // 三级目录的练习题
                    for (int t = 0; t < childCourseDetial.children.count; t++) {
                        HKCourseModel *praticeModel = childCourseDetial.children[t];
                        //职业路径 ID
                        praticeModel.career_id = childCourseDetial.career_id;
                        //praticeModel.chapter_id = childCourseDetial.chapter_id;
                        
                        praticeModel.isExcercises = YES;
                        currentRow++;
                        // 当前观看的视频
                        if ([praticeModel.videoId isEqualToString:self.videlDetailModel.video_id]) {
                            praticeModel.currentWatching = YES;
                            courseSelectedModel = praticeModel;
                            moveCurrentIndexPath = [NSIndexPath indexPathForRow:currentRow inSection:i];
                        }
                        
                        // 查找缓存
                        HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:praticeModel.mj_JSONData];
                        // type
                        dowmloadModel.videoType = praticeModel.videoType;
                        dowmloadModel.videoId = praticeModel.videoId;
                        
                        praticeModel.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadModel] != HKDownloadNotExist;
                        
                        // 缓存文件总数
                        if (praticeModel.islocalCache) {
                            self.cacheCountFile++;
                        }
                    }
                }
            }
            
            self.moveCurrentIndexPath = moveCurrentIndexPath;
            // 刷新和空处理
            [self.foldingTableView.mj_header endRefreshing];
            [self.foldingTableView reloadData];
            
            // 移到指定位置 并且选中
            if (moveCurrentIndexPath) {
                [self.foldingTableView scrollToRowAtIndexPath:moveCurrentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                // 默认选中
                if (!courseSelectedModel.islocalCache) {
                    [self yuFoldingTableView:self.foldingTableView didSelectRowAtIndexPath:moveCurrentIndexPath];
                }
            }
            if (resultBlock) {
                resultBlock();
            }
        }else{
            showTipDialog(responseObject[@"data"][@"business_message"]);
        }
    } failure:^(NSError *error) {
        
    }];
}




@end
