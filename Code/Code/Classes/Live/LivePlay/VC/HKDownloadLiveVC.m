//
//  HKDownloadLiveVC.m
//  Code
//
//  Created by eon Z on 2021/12/14.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKDownloadLiveVC.h"
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
#import "HKLiveDonwloadCell.h"

@interface HKDownloadLiveVC ()<YUFoldingTableViewDelegate>
@property (nonatomic, weak) YUFoldingTableView *foldingTableView;

@property (nonatomic, strong)NSMutableArray<HKCourseModel *> *dataSource;//[@"data"][@"dir_list"]

@property (nonatomic, strong)HKDownloadBottomView * myBottomView;

@property (nonatomic, strong)NSMutableArray<HKCourseModel *> *courseDoloadArray;//需要下载的model数组

@property (nonatomic, strong)HKDownloadModel *downloadDirectoryModel;// 下载完成后的总目录  [@"data"][@"dir_data"]
// 移到指定位置
@property (nonatomic, strong)NSIndexPath *moveCurrentIndexPath;

@property (nonatomic, assign)int cacheCountFile;

@property (nonatomic, strong)HKBottomCapacityView *bottomCapacityView;
//@property (nonatomic, strong)NSMutableArray *liveDoloadArray;
@property (nonatomic, strong) UIButton  *rightBarBtn;

@end

@implementation HKDownloadLiveVC

- (NSMutableArray<HKCourseModel *> *)courseDoloadArray {
    if (_courseDoloadArray == nil) {
        _courseDoloadArray = [NSMutableArray array];
    }
    return _courseDoloadArray;
}

- (HKBottomCapacityView *)bottomCapacityView {
    if (_bottomCapacityView == nil) {
        HKBottomCapacityView *bottomCapacityView = [HKBottomCapacityView viewFromXib];
        bottomCapacityView.frame = CGRectMake(0, SCREEN_HEIGHT - PADDING_30 * 3 - TAR_BAR_XH, SCREEN_WIDTH, 30);
        _bottomCapacityView = bottomCapacityView;
    }
    return _bottomCapacityView;
}


- (YUFoldingTableView *)foldingTableView {
    if (_foldingTableView == nil) {
        YUFoldingTableView *foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0,KNavBarHeight64, SCREEN_WIDTH, SCREEN_HEIGHT-KNavBarHeight64-PADDING_30 * 3 - TAR_BAR_XH)];
        _foldingTableView = foldingTableView;
        HKAdjustsScrollViewInsetNever(self, foldingTableView);
        foldingTableView.backgroundColor = COLOR_F6F6F6_3D4752;
        //foldingTableView.backgroundColor = [UIColor lightGrayColor];
        foldingTableView.separatorColor = COLOR_F6F6F6_3D4752;
        [self.view addSubview:foldingTableView];
        if (@available(iOS 15.0, *)) {
            _foldingTableView.sectionHeaderTopPadding = 0;
        }
    }
    return _foldingTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",NSHomeDirectory());
    [self createLeftBarButton];
    self.title = @"批量下载";
    
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    self.hk_hideNavBarShadowImage = YES;
    [self setupFoldingTableView];
    // 底部批量操作
    [self.view addSubview:self.myBottomView];
    
    [self loadNewData];
    [self.view addSubview:self.bottomCapacityView];
    //[self.bottomCapacityView setSpace];
    [self obtainingDiskSpace];
    [self setRightBarBtn];
}


#pragma mark <Server>
- (void)loadNewData {
    WeakSelf;
    if (isEmpty(self.ID)) {
        return;
    }
    
    [HKHttpTool POST:@"/live/batch-download" parameters:@{@"id" : self.ID} success:^(id responseObject) {
        HKCourseModel *courseSelectedModel = nil;
        if (HKReponseOK) {
            NSString * str = [HKHttpTool jsonStringWithDict:responseObject];
//            NSLog(@"%@",str);
            
            // 下载视频的总目录
            self.downloadDirectoryModel = [HKDownloadModel mj_objectWithKeyValues:responseObject[@"data"][@"dir_data"]];
            self.downloadDirectoryModel.video_type = 999;
            self.downloadDirectoryModel.isDirectory = YES;
            

            NSMutableArray *array = [HKCourseModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"dir_list"]];
            
            //通过模型转字典，将responseObject中的video_type等字段，替换掉
            //修改数据源中的videoType，并存储为Nsdata
            for (HKCourseModel * model in array) {
                for (HKCourseModel *childCourseDetial in model.children) {
                    childCourseDetial.videoType = 999;
                    childCourseDetial.name = childCourseDetial.title;
                    childCourseDetial.img_cover_url = childCourseDetial.surface_url;
                    childCourseDetial.image_url = childCourseDetial.surface_url;
                }
            }
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            //将模型转成字典
            NSMutableDictionary * dir_dataDic = [self.downloadDirectoryModel mj_keyValues];
            //通过模型数组来创建一个字典数组
            NSMutableArray * dir_listDic = [HKCourseModel mj_keyValuesArrayWithObjectArray:array];
            [dic setObject:dir_dataDic forKey:@"dir_data"];
            [dic setObject:dir_listDic forKey:@"dir_list"];

            NSMutableDictionary * responseDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"data":dic}];
            self.downloadDirectoryModel.responseDicData = [NSKeyedArchiver archivedDataWithRootObject:responseDic]; // 转化二进制

        
        
            
            
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
                    if ([childCourseDetial.video_id isEqualToString:self.currentVideoID] && ![self.currentVideoID isEqualToString:@"0"] && self.currentVideoID.length != 0 ) {
                        childCourseDetial.currentWatching = YES;
                        courseSelectedModel = childCourseDetial;
                        moveCurrentIndexPath = [NSIndexPath indexPathForRow:currentRow inSection:i];
                    }

                    // 查找缓存
                    HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:childCourseDetial.mj_JSONData];
                    // type
                    //dowmloadModel.videoType = childCourseDetial.videoType;
                    dowmloadModel.videoId = childCourseDetial.videoId;
                    dowmloadModel.videoType = 999;
                    //遍历标记，是否本地已经下载完成
                    childCourseDetial.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadModel] != HKDownloadNotExist;

                    // 缓存文件总数
                    if (childCourseDetial.islocalCache || [childCourseDetial.can_download intValue] == 0) {
                        self.cacheCountFile++;
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
        }else{
            showTipDialog(responseObject[@"msg"]);
        }
        
    } failure:^(NSError *error) {
        //showTipDialog(@"网络出错");
    }];
}


// 创建tableView
- (void)setupFoldingTableView {
    self.foldingTableView.foldingDelegate = self;
    // 默认展开
    self.foldingTableView.foldingState = YUFoldingSectionStateShow;
    

    // 注册Cell
    [self.foldingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKCourseDonwloadCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKCourseDonwloadCell class])];
    [self.foldingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKLiveDonwloadCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKLiveDonwloadCell class])];
    
    self.foldingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (HKDownloadBottomView *)myBottomView {
    WeakSelf;
    if (!_myBottomView) {
        
        _myBottomView = [[HKDownloadBottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-PADDING_30*2 - TAR_BAR_XH, SCREEN_WIDTH, PADDING_30*2) viewType:HKDownloadBottomViewType_loading];
        
        //_myBottomView = [[HKDownloadBottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-PADDING_25*2 - 30, SCREEN_WIDTH, PADDING_25*2)];
        _myBottomView.allSelectBlock = ^(UIButton *btn){
            
        };
        
        _myBottomView.confirmBlock = ^(){
            
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
        };
    }
    return _myBottomView;
}

- (void)dealloc {
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
    // 软件入门 职业路径
    for (int i = 0; i < self.dataSource.count; i++) {
        HKCourseModel *courseDetial = self.dataSource[i];
        
        for (int j = 0; j < courseDetial.children.count; j++) {
            HKCourseModel *childCourseDetial = courseDetial.children[j];
            if (!childCourseDetial.islocalCache &&
                ![self.courseDoloadArray containsObject:childCourseDetial] &&
                [childCourseDetial.can_download intValue] == 1) {
                [self.courseDoloadArray addObject:childCourseDetial];
                childCourseDetial.isSelectedForDownload = YES;
            }
        }
    }
    
    [self obtainingDiskSpace];

    [self.foldingTableView reloadData];
}



/// 取消选中全部
- (void)quitSelectCourse {
    
    for (HKCourseModel *model in self.courseDoloadArray) {
        model.isSelectedForDownload = NO;
    }
    [self.courseDoloadArray removeAllObjects];
    [self.foldingTableView reloadData];
    [self obtainingDiskSpace];

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

    return self.dataSource.count;
}



- (NSInteger )yuFoldingTableView:(YUFoldingTableView *)yuTableView numberOfRowsInSection:(NSInteger )section
{
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
    HKLiveDonwloadCell * cell = [yuTableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKLiveDonwloadCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BOOL notHideSeparator = YES;
    notHideSeparator = [self getCountWithPractice:indexPath.section] - 1 == indexPath.row;
    HKCourseModel *model = [self getModelWithBlock:indexPath];
    [cell setLiveModel:model hiddenSpeparator:notHideSeparator];
    return cell;

    
    
//    HKCourseDonwloadCell* cell = [yuTableView  dequeueReusableCellWithIdentifier:NSStringFromClass([HKCourseDonwloadCell class])];
//    cell.isHKDownloadCourseVC = YES;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//    // 设置属性
//    BOOL notHideSeparator = YES;
//    notHideSeparator = [self getCountWithPractice:indexPath.section] - 1 == indexPath.row;
//    HKCourseModel *model = [self getModelWithBlock:indexPath];
//        // 二级目录
//    [cell setModel:model hiddenSpeparator:!notHideSeparator videoType:HKVideoType_LearnPath];
//    return cell;
}

- (HKCourseModel *)getModelWithBlock:(NSIndexPath *)indexPath{
    HKCourseModel *catModel = self.dataSource[indexPath.section];
    HKCourseModel *courseModel = catModel.children[indexPath.row];
    return courseModel;
}


- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForHeaderInSection:(NSInteger )section{
    // 软件入门
    return 50;
}

- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger)section
{
    
    return self.dataSource[section].title;
}

- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [yuTableView deselectRowAtIndexPath:indexPath animated:YES];

    HKCourseModel *courseModel  = [self getModelWithBlock:indexPath];


    // 如果已经下载了, 直接返回
    if (courseModel.islocalCache || [courseModel.can_download intValue] == 0) return;
    
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
    [self obtainingDiskSpace];
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


#pragma mark 批量保存
- (void)patchSave {
    
    // 判断储存剩余储存空间 150M
    [CommonFunction freeDiskSpaceInBytes:^(unsigned long long space) {        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat spaceLeft = space / 1024.0 / 1024.0;
            CGFloat totalSpace = 0;
            for (HKCourseModel * model in self.courseDoloadArray) {
                totalSpace = totalSpace + [model.video_size floatValue];
            }
            
            CGFloat marginSpace = spaceLeft  - totalSpace;
            if (marginSpace < 200) {
                showTipDialog(@"存储空间不足");

            }else{
                [self downLoadVideo];
            }
        });
    }];
}

- (void)downLoadVideo{
    WeakSelf;
    // 先保存封面
    //封面和视频存在在同一个表中，存储有耳机目录的视频，先存储文件夹信息，然后在存储目录视频信息
    [[HKDownloadManager shareInstance] saveDirectoryModel:weakSelf.downloadDirectoryModel];
    
    // 设置参数
    NSMutableArray *downloadArray = [NSMutableArray array];
    for (HKCourseModel *courseModel in weakSelf.courseDoloadArray) {
        HKDownloadModel *downloadModel = [HKDownloadModel mj_objectWithKeyValues:courseModel.mj_JSONData];
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
    [weakSelf.courseDoloadArray removeAllObjects];
    
    [weakSelf.navigationController popViewControllerAnimated:YES];
    showTipDialog(DownLoading_Tip);
}


- (void)obtainingDiskSpace {
    // 判断储存剩余储存空间 150M
    [CommonFunction freeDiskSpaceInBytes:^(unsigned long long space) {
        //CGFloat spaceLeft = space / 1024.0 / 1024.0 / 1024.0; //单位G
        CGFloat spaceLeft = space / 1024.0 / 1024.0;  //单位M
        CGFloat totalSpace = 0;
        for (HKCourseModel * model in self.courseDoloadArray) {
            totalSpace = totalSpace + [model.video_size floatValue];
        }
        
        CGFloat marginSpace = spaceLeft  - totalSpace;
        if (marginSpace < 100) {
            dispatch_async(dispatch_get_main_queue(), ^{
                showTipDialog(@"存储空间不足");
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bottomCapacityView setCapacity:spaceLeft totalNeed:totalSpace];
        });
        
    }];
}



@end
