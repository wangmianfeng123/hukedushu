//
//  HKCourseListVC.m
//  YUFoldingTableViewDemo
//
//  Created by administrator on 16/8/25.
//  Copyright © 2016年 xuanYuLin. All rights reserved.
//

#import "HKShowDownloadCourseVC.h"
#import "HKCourseModel.h"
#import "HKCourseDonwloadCell.h"
#import "AFNetworkTool.h"
#import "HKDownloadModel.h"
#import "VideoPlayVC.h"
#import "HKDownloadBottomView.h"
  
#import "HKDownloadModel.h"
#import "HKDownloadManager.h"
#import "HKBottomCapacityView.h"
#import "NSString+MD5.h"
#import "HKLiveCourseVC.h"

@interface HKShowDownloadCourseVC ()<YUFoldingTableViewDelegate>

@property (nonatomic, weak) YUFoldingTableView *foldingTableView;

@property (nonatomic, strong)NSMutableArray<HKCourseModel *> *dataSource;

@property (nonatomic, strong)HKDownloadBottomView * myBottomView;

@property (nonatomic, strong)NSMutableArray<HKCourseModel *> *courseDeleteArray;

@property (nonatomic, strong)HKDownloadModel *downloadDirectoryModel;// 下载完成后的总目录

@property (nonatomic, strong)UIButton * rightTopBtn;

// 移到指定位置
@property (nonatomic, strong)NSIndexPath *moveCurrentIndexPath;

@property (nonatomic, strong)HKBottomCapacityView *bottomCapacityView;

@end

@implementation HKShowDownloadCourseVC

- (HKBottomCapacityView *)bottomCapacityView {
    if (_bottomCapacityView == nil) {
        HKBottomCapacityView *bottomCapacityView = [HKBottomCapacityView viewFromXib];
        bottomCapacityView.frame = CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 30);
        _bottomCapacityView = bottomCapacityView;
    }
    return _bottomCapacityView;
}


- (NSMutableArray<HKCourseModel *> *)courseDeleteArray {
    if (_courseDeleteArray == nil) {
        _courseDeleteArray = [NSMutableArray array];
    }
    return _courseDeleteArray;
}

- (HKDownloadBottomView *)myBottomView {
    
    @weakify(self);
    if (!_myBottomView) {
        
        CGRect rect = IS_IPHONE_X ? CGRectMake(0, SCREEN_HEIGHT-PADDING_25*3, SCREEN_WIDTH, PADDING_25*3): CGRectMake(0, SCREEN_HEIGHT-PADDING_25*2, SCREEN_WIDTH, PADDING_25*2);
        
        _myBottomView = [[HKDownloadBottomView alloc]initWithFrame:rect];
        // 默认先隐藏
        _myBottomView.hidden = YES;
        [_myBottomView setupconfirmTitle:@"删除"];
        [_myBottomView setupconfirmTextColor:COLOR_FF3221 selectColor:COLOR_FF3221];
        
        _myBottomView.allSelectBlock = ^(UIButton *btn){
            @strongify(self);
            
            int videoType = self.directoryModel.video_type;
            // 选中全部
            if (btn.selected) {
                
                // 学习路径
                if (HKVideoType_LearnPath == videoType || HKVideoType_Practice == videoType) {
                    
                    for (int i = 0; i < self.dataSource.count; i++) {
                        HKCourseModel *courseDetial = self.dataSource[i];
                        for (int j = 0; j < courseDetial.children.count; j++) {
                            HKCourseModel *childCourseDetial = courseDetial.children[j];
                            if (![self.courseDeleteArray containsObject:childCourseDetial]) {
                                [self.courseDeleteArray addObject:childCourseDetial];
                                childCourseDetial.isSelectedForDelete = YES;
                            }
                        }
                    }
                }else if (HKVideoType_JobPath == videoType || HKVideoType_JobPath_Practice == videoType) {
                    
                    for (int i = 0; i < self.dataSource.count; i++) {
                        HKCourseModel *courseDetial = self.dataSource[i];
                        for (int j = 0; j < courseDetial.children.count; j++) {
                            HKCourseModel *childCourseDetial = courseDetial.children[j];
                            if (![self.courseDeleteArray containsObject:childCourseDetial]) {
                                [self.courseDeleteArray addObject:childCourseDetial];
                                childCourseDetial.isSelectedForDelete = YES;
                            }
                        }
                    }
                }else if (videoType == 999){
                    for (int i = 0; i < self.dataSource.count; i++) {
                        HKCourseModel *courseDetial = self.dataSource[i];
                        for (int j = 0; j < courseDetial.children.count; j++) {
                            HKCourseModel *childCourseDetial = courseDetial.children[j];
                            if (![self.courseDeleteArray containsObject:childCourseDetial]) {
                                [self.courseDeleteArray addObject:childCourseDetial];
                                childCourseDetial.isSelectedForDelete = YES;
                            }
                        }
                    }
                }else {
                    // 系列课等其他
                    for (int j = 0; j < self.dataSource.count; j++) {
                        HKCourseModel *mdoel = self.dataSource[j];
                        if (![self.courseDeleteArray containsObject:mdoel]) {
                            [self.courseDeleteArray addObject:mdoel];
                            mdoel.isSelectedForDelete = YES;
                        }
                    }
                }
                [self.foldingTableView reloadData];
            } else {
                
                // 取消选中全部
                for (HKCourseModel *model in self.courseDeleteArray) {
                    model.isSelectedForDelete = NO;
                }
                [self.courseDeleteArray removeAllObjects];
                [self.foldingTableView reloadData];
            }
        };
        
        _myBottomView.confirmBlock = ^(){
            @strongify(self);
            
            if (self.courseDeleteArray.count <= 0) {
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
                    
                    // 删除
                    [self deleteSelectedArrayVideo];
                };
            })
            .LeeHeaderColor([UIColor whiteColor])
            .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
            .LeeShow();
        };
    }
    return _myBottomView;
}

#pragma mark 删除选中的视频
- (void)deleteSelectedArrayVideo {
    
    // 提示文字(删除时间可以根据实际优化)
    tb_showWaitingDialogWithStr(@"删除文件中...");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 2.0)), dispatch_get_main_queue(), ^{
        closeWaitingDialog();
    });
        
    [self.courseDeleteArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HKCourseModel *courseModel = obj;
        HKDownloadModel *downloadModel = [HKDownloadModel mj_objectWithKeyValues:courseModel.mj_JSONData];
        [[HKDownloadManager shareInstance] deletedDownload:downloadModel delete:nil];
    }];
    
    // 清空所有的
    [self.courseDeleteArray removeAllObjects];
    
    // 从新加载所有的
    [self loadTableViewData];
    
    // 改为完成
    [self changeEditBtnState];
}

- (YUFoldingTableView *)foldingTableView {
    if (_foldingTableView == nil) {
        CGFloat height = SCREEN_HEIGHT*2/3-44;
        BOOL isBuy = YES; // 1-已购买课程 0-未购买课程
        if (self.directoryModel.video_type == HKVideoType_PGC && isBuy) {
            height = SCREEN_HEIGHT*2/3-44-55;
        }
        YUFoldingTableView *foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _foldingTableView = foldingTableView;
        if (@available(iOS 15.0, *)) {
            _foldingTableView.sectionHeaderTopPadding = 0;
        }
        HKAdjustsScrollViewInsetNever(self, foldingTableView);
        [foldingTableView setContentInset:UIEdgeInsetsMake(KNavBarHeight64, 0, PADDING_25 * 2, 0)];
        foldingTableView.backgroundColor = COLOR_F6F6F6_3D4752;
        foldingTableView.separatorColor = COLOR_F6F6F6_3D4752;
        [self.view addSubview:foldingTableView];
    }
    return _foldingTableView;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  videoId:(NSString*)videoId  detailModel:(HKDownloadModel*)model {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.directoryModel = model;
//        [self getVideoCommentWithToken:[CommonFunction getUserToken] videoId:self.videoId page:@"1"];
    }
    return self;
}


- (void)loadTableViewData {
    
    int videoType = self.directoryModel.video_type;
    switch (videoType) {
        case HKVideoType_LearnPath: case HKVideoType_Practice:
        {
            [self loadNewData];
        }
            break;
            
        case HKVideoType_Series: case HKVideoType_UpDownCourse: case HKVideoType_PGC:
        {
            [self loadNewDataSeries];
        }
            break;
            
        case HKVideoType_JobPath: case HKVideoType_JobPath_Practice:
        {
            [self loadNewData];
        }
            break;
        case 999:{
            [self setDownLoadLiveData];
        }
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createLeftBarButton];
    self.title = self.directoryModel.title;
    
//    [MobClick event:UM_RECORD_DETAIL_LIST_TAB];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupFoldingTableView];
    
    // 底部批量操作
    [self.view addSubview:self.myBottomView];
    
    // 根据视频类型加载  1，软件入门  2，系列课，3上中下的课 4- pgc
    [self loadTableViewData];
    
    // 右侧管理
    [self setRightBarButtonItem];
    
    [self.view addSubview:self.bottomCapacityView];
    [self.bottomCapacityView setSpace];
}

- (void)setRightBarButtonItem {
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setTitle:@"管理" forState:UIControlStateNormal];
    [btn setTitle:@"完成" forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(editBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.rightTopBtn = btn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)editBtnClicked{
    if (self.dataSource.count < 1) {
        return;
    }else{
        [self changeEditBtnState];
    }
}

- (void)changeEditBtnState {
    [self.foldingTableView reloadData];
    self.rightTopBtn.selected = !self.rightTopBtn.selected;
    self.myBottomView.hidden = !self.rightTopBtn.selected;
    self.bottomCapacityView.hidden = !self.myBottomView.hidden;
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
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
    int type = self.directoryModel.video_type;
    if ( HKVideoType_Series == type || HKVideoType_UpDownCourse == type || HKVideoType_PGC == type){
        return 1;
    }
    return self.dataSource.count;
}

- (NSInteger )yuFoldingTableView:(YUFoldingTableView *)yuTableView numberOfRowsInSection:(NSInteger )section
{
    // 系列课
    int type = self.directoryModel.video_type;
    if ( HKVideoType_Series == type || HKVideoType_UpDownCourse == type || HKVideoType_PGC == type) {
        return self.dataSource.count;
    }
    return self.dataSource[section].children.count;
}

// 添加删除
- (void)addOrRemoveCourse:(HKCourseModel *)model{
    if (![self.courseDeleteArray containsObject:model]) {
        model.isSelectedForDelete = YES;
        [self.courseDeleteArray addObject:model];
    } else if ([self.courseDeleteArray containsObject:model]) {
        model.isSelectedForDelete = NO;
        [self.courseDeleteArray removeObject:model];
    }
    
    // 选中全部
    NSInteger totalCount = 0;
    for (NSInteger section = 0; section < self.foldingTableView.numberOfSections; section++ ) {
        totalCount += [self.foldingTableView numberOfRowsInSection:section];
    }
    
    // 选中全部与否
    NSInteger selectCount = self.courseDeleteArray.count;
    self.myBottomView.checkBoxBtn.selected = (totalCount == selectCount);
    
    self.myBottomView.confirmBtn.selected = selectCount;
    
    [self.foldingTableView reloadData];
}

- (UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HKCourseDonwloadCell* cell = [yuTableView  dequeueReusableCellWithIdentifier:NSStringFromClass([HKCourseDonwloadCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 系列课
    @weakify(self);
    NSInteger type = self.directoryModel.video_type;
    if (type == HKVideoType_Series || type == HKVideoType_UpDownCourse || type == HKVideoType_PGC) {
        
        HKCourseModel *seriesCourseModel = self.dataSource[indexPath.row];
        [cell showCompeletModel:seriesCourseModel hiddenSpeparator:YES videoType:type edit:self.rightTopBtn.selected block:^(HKCourseModel *model) {
            @strongify(self);
            // 添加删除
            [self addOrRemoveCourse:model];
        }];
    }else {// 软件入门
        // 设置属性
        BOOL notHideSeparator = YES;
        notHideSeparator = self.dataSource[indexPath.section].children.count - 1 == indexPath.row;
        HKCourseModel *model = self.dataSource[indexPath.section].children[indexPath.row];
            // 二级目录
        [cell setModel:model hiddenSpeparator:!notHideSeparator videoType:model.videoType];
        
        [cell showCompeletModel:model hiddenSpeparator:!notHideSeparator videoType:model.videoType edit:self.rightTopBtn.selected block:^(HKCourseModel *model) {
            @strongify(self);
            // 添加删除
            [self addOrRemoveCourse:model];
        }];
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
    int type = self.directoryModel.video_type;
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
    int type = self.directoryModel.video_type;
    if (HKVideoType_Series == type || HKVideoType_UpDownCourse == type || HKVideoType_PGC == type) {
        return nil;
    }
    
    return self.dataSource[section].title;
}

- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [yuTableView deselectRowAtIndexPath:indexPath animated:YES];
    HKCourseModel *courseModel = nil;
    
    // 软件入门和练习题
    int type = self.directoryModel.video_type;
    if (HKVideoType_LearnPath == type || HKVideoType_Practice == type) {
        courseModel = self.dataSource[indexPath.section].children[indexPath.row];
    }
    else if (HKVideoType_JobPath == type || HKVideoType_JobPath_Practice == type) {
        NSInteger row = indexPath.row;
        NSInteger section = indexPath.section;
        
        HKCourseModel *model = self.dataSource[section];
        if (model.children.count > row) {
            courseModel = model.children[row];
        }
        courseModel.chapter_id = model.chapter_id;
        courseModel.ID = model.ID;
    }else if (type == 999){
        courseModel = self.dataSource[indexPath.section].children[indexPath.row];
    }
    else {
        courseModel = self.dataSource[indexPath.row];
    }
    
    // 普通状态
    if (!self.rightTopBtn.selected) {
        
        if (courseModel.live_id.length) {
            HKLiveCourseVC *vc = [[HKLiveCourseVC alloc] init];
            vc.course_id = courseModel.live_id; //18750
            vc.isLocalVideo = YES;
            vc.live_id = courseModel.video_id;
            // 设置已经观看
            if (courseModel.needStudyLocal) {
                courseModel.needStudyLocal = NO;
                [self.foldingTableView reloadData];
                HKDownloadModel *downloadModel = [HKDownloadModel mj_objectWithKeyValues:courseModel.mj_JSONData];
                [[HKDownloadManager shareInstance] changeNeedStudyLocal:downloadModel];
            }
            [self pushToOtherController:vc];
        }else{
            // 转到相应的VideoPlayVC
            VideoPlayVC *videoPlayVC = [[VideoPlayVC alloc] initWithNibName:nil bundle:nil fileUrl:courseModel.video_url videoName:courseModel.title placeholderImage:courseModel.image_url
                                                                 lookStatus:LookStatusLocalVideo videoId:courseModel.videoId model:courseModel];
            videoPlayVC.videoType = courseModel.videoType;
            videoPlayVC.isFromDownload = YES;
            
            // 设置已经观看
            if (courseModel.needStudyLocal) {
                courseModel.needStudyLocal = NO;
                [self.foldingTableView reloadData];
                HKDownloadModel *downloadModel = [HKDownloadModel mj_objectWithKeyValues:courseModel.mj_JSONData];
                [[HKDownloadManager shareInstance] changeNeedStudyLocal:downloadModel];
            }
            [self pushToOtherController:videoPlayVC];
        }
        
    } else {
        
        // 编辑状态
        [self addOrRemoveCourse:courseModel];
    }

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
- (void)loadNewData {
    
    NSDictionary *responseObject = [NSKeyedUnarchiver unarchiveObjectWithData:self.directoryModel.responseDicData];
    
    // 下载视频的总目录2
    self.downloadDirectoryModel = [HKDownloadModel mj_objectWithKeyValues:responseObject[@"data"][@"dir_data"]];
    self.downloadDirectoryModel.isDirectory = YES;
    self.downloadDirectoryModel.responseDicData = [NSKeyedArchiver archivedDataWithRootObject:responseObject]; // 转化二进制
    
    NSMutableArray *array = [HKCourseModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"dir_list"]];
    self.dataSource = array;
    
    int videoType = self.directoryModel.video_type;
    switch (videoType) {
        case HKVideoType_LearnPath: case HKVideoType_Practice:
        {
            [self setSoftWareData];
        }
            break;
            
        case HKVideoType_JobPath: case HKVideoType_JobPath_Practice:
        {
            [self setJobPathData];
        }
            break;
        default:
            break;
    }
    
    // 清空title 的children为空
    NSMutableArray *arrayTempty = [NSMutableArray array];
    for (HKDownloadModel *titleModel in self.dataSource) {
        if (titleModel.children.count > 0) {
            [arrayTempty addObject:titleModel];
        }
    }
    self.dataSource = arrayTempty;
    
    // 刷新和空处理
    [self.foldingTableView.mj_header endRefreshing];
    [self.foldingTableView reloadData];
    
    // 移到指定位置
    if (self.moveCurrentIndexPath) {
        [self.foldingTableView scrollToRowAtIndexPath:self.moveCurrentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}

//获取直播回看数据
- (void)setDownLoadLiveData{
    
    NSDictionary *responseObject = [NSKeyedUnarchiver unarchiveObjectWithData:self.directoryModel.responseDicData];
    
    // 下载视频的总目录2
    self.downloadDirectoryModel = [HKDownloadModel mj_objectWithKeyValues:responseObject[@"data"][@"dir_data"]];
    self.downloadDirectoryModel.isDirectory = YES;
    self.downloadDirectoryModel.responseDicData = [NSKeyedArchiver archivedDataWithRootObject:responseObject]; // 转化二进制
    
    NSMutableArray *dataArray = [HKCourseModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"dir_list"]];
    self.dataSource = dataArray;
    
    NSMutableArray *array = [NSMutableArray array];
    array = self.dataSource;
    // 自动移动indexPath
    NSIndexPath *moveCurrentIndexPath = nil;
    self.moveCurrentIndexPath = moveCurrentIndexPath;
    
    // 遍历找出正在播放的视频 一级目录章
    for (int i = 0; i < array.count; i++) {
        HKCourseModel *courseDetial = array[i];
        NSString *chatString = [NSString stringWithFormat:@"%d", i+1];
        courseDetial.title = [NSString stringWithFormat:@"第%@章 %@", [NSString translation:chatString],courseDetial.title];
        // 下载完成的
        NSMutableArray *finishArray = [NSMutableArray array];
        
        int currentRow = -1;
        // 二级目录 节
        for (int j = 0; j < courseDetial.children.count; j++) {
            HKCourseModel *childCourseDetial = courseDetial.children[j];
            
            currentRow++;
            // 添加序列
            childCourseDetial.praticeNO = [NSString stringWithFormat:@"%d-%d",i+1, j+1];
            // 查找缓存
            HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:childCourseDetial.mj_JSONData];
            // type
            dowmloadModel.videoType = self.directoryModel.video_type;
            dowmloadModel.videoId = childCourseDetial.videoId;
            dowmloadModel = [[HKDownloadManager shareInstance] queryWidthID:dowmloadModel.videoId videoType:dowmloadModel.videoType];
            childCourseDetial.islocalCache = dowmloadModel.isFinish;
            childCourseDetial.needStudyLocal = dowmloadModel.needStudyLocal;
            childCourseDetial.videoType = self.directoryModel.video_type;
            // 已经完成
            if (childCourseDetial.islocalCache) {
                [finishArray addObject:childCourseDetial];
            }
        }
        courseDetial.children = finishArray;
    }
    
    
    
    
    // 清空title 的children为空
    NSMutableArray *arrayTempty = [NSMutableArray array];
    for (HKDownloadModel *titleModel in self.dataSource) {
        if (titleModel.children.count > 0) {
            [arrayTempty addObject:titleModel];
        }
    }
    self.dataSource = arrayTempty;
    
    // 刷新和空处理
    [self.foldingTableView.mj_header endRefreshing];
    [self.foldingTableView reloadData];
    
    // 移到指定位置
    if (self.moveCurrentIndexPath) {
        [self.foldingTableView scrollToRowAtIndexPath:self.moveCurrentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        
    }
}
#pragma mark - 拼装软件入门 和练习题数据
- (void )setSoftWareData {
    NSMutableArray *array = [NSMutableArray array];
    array = self.dataSource;
    // 自动移动indexPath
    NSIndexPath *moveCurrentIndexPath = nil;
    self.moveCurrentIndexPath = moveCurrentIndexPath;
    
    // 遍历找出正在播放的视频 一级目录章
    for (int i = 0; i < array.count; i++) {
        HKCourseModel *courseDetial = array[i];
        NSString *chatString = [NSString stringWithFormat:@"%d", i+1];
        courseDetial.title = [NSString stringWithFormat:@"第%@章 %@", [NSString translation:chatString],courseDetial.title];
        
        // 下载完成的
        NSMutableArray *finishArray = [NSMutableArray array];
        
        int currentRow = -1;
        // 二级目录 节
        for (int j = 0; j < courseDetial.children.count; j++) {
            HKCourseModel *childCourseDetial = courseDetial.children[j];
            
            currentRow++;
            // 添加序列
            childCourseDetial.praticeNO = [NSString stringWithFormat:@"%d-%d",i+1, j+1];
            // 当前观看的视频
            if ([childCourseDetial.videoId isEqualToString:self.directoryModel.video_id]) {

            }
            
            // 查找缓存
            HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:childCourseDetial.mj_JSONData];
            // type
            dowmloadModel.videoType = childCourseDetial.videoType;
            dowmloadModel.videoId = childCourseDetial.videoId;
            dowmloadModel = [[HKDownloadManager shareInstance] queryWidthID:dowmloadModel.videoId videoType:dowmloadModel.videoType];
            childCourseDetial.islocalCache = dowmloadModel.isFinish;
            childCourseDetial.needStudyLocal = dowmloadModel.needStudyLocal;
            // 已经完成
            if (childCourseDetial.islocalCache) {
                [finishArray addObject:childCourseDetial];
            }
            
            // 三级目录的练习题
            for (int t = 0; t < childCourseDetial.children.count; t++) {
                HKCourseModel *praticeModel = childCourseDetial.children[t];
                currentRow++;
                // 当前观看的视频
                if ([praticeModel.videoId isEqualToString:self.directoryModel.video_id]) {
                    
                }
                // 查找缓存
                HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:praticeModel.mj_JSONData];
                // type
                dowmloadModel.videoType = praticeModel.videoType;
                dowmloadModel.videoId = praticeModel.videoId;
                dowmloadModel = [[HKDownloadManager shareInstance] queryWidthID:dowmloadModel.videoId videoType:dowmloadModel.videoType];
                praticeModel.islocalCache = dowmloadModel.isFinish;
                praticeModel.needStudyLocal = dowmloadModel.needStudyLocal;
                // 已经完成
                if (praticeModel.islocalCache) {
                    [finishArray addObject:praticeModel];
                }
            }
        }
        courseDetial.children = finishArray;
    }
}



#pragma mark - 拼装职业路径 数据
- (void )setJobPathData {
    NSMutableArray *array = [NSMutableArray array];
    array = self.dataSource;
    // 自动移动indexPath
    NSIndexPath *moveCurrentIndexPath = nil;
    self.moveCurrentIndexPath = moveCurrentIndexPath;
    
    // 遍历找出正在播放的视频 一级目录章
    for (int i = 0; i < array.count; i++) {
        HKCourseModel *courseDetial = array[i];
        // 下载完成的
        NSMutableArray *finishArray = [NSMutableArray array];
        int currentRow = -1;
        // 二级目录 节
        for (int j = 0; j < courseDetial.children.count; j++) {
            HKCourseModel *childCourseDetial = courseDetial.children[j];
            currentRow++;
            // 添加序列
            childCourseDetial.praticeNO = [NSString stringWithFormat:@"%d-%d",i+1, j+1];
            
            // 查找缓存
            HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:childCourseDetial.mj_JSONData];
            // type
            dowmloadModel.videoType = childCourseDetial.videoType;
            dowmloadModel.videoId = childCourseDetial.videoId;
            dowmloadModel = [[HKDownloadManager shareInstance] queryWidthID:dowmloadModel.videoId videoType:dowmloadModel.videoType];
            childCourseDetial.islocalCache = dowmloadModel.isFinish;
            childCourseDetial.needStudyLocal = dowmloadModel.needStudyLocal;
            // 已经完成
            if (childCourseDetial.islocalCache) {
                [finishArray addObject:childCourseDetial];
            }
            
            // 三级目录的练习题
            for (int t = 0; t < childCourseDetial.children.count; t++) {
                HKCourseModel *praticeModel = childCourseDetial.children[t];
                praticeModel.isExcercises = YES;
                currentRow++;
                // 查找缓存
                HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:praticeModel.mj_JSONData];
                // type
                dowmloadModel.videoType = praticeModel.videoType;
                dowmloadModel.videoId = praticeModel.videoId;
                dowmloadModel = [[HKDownloadManager shareInstance] queryWidthID:dowmloadModel.videoId videoType:dowmloadModel.videoType];
                praticeModel.islocalCache = dowmloadModel.isFinish;
                praticeModel.needStudyLocal = dowmloadModel.needStudyLocal;
                // 已经完成
                if (praticeModel.islocalCache) {
                    [finishArray addObject:praticeModel];
                }
            }
        }
        courseDetial.children = finishArray;
    }
}





- (void)loadNewDataSeries {
    
    if (self.directoryModel.video_type == HKVideoType_PGC) {
        
        NSDictionary *responseObject = [NSKeyedUnarchiver unarchiveObjectWithData:self.directoryModel.responseDicData];
        
        // 下载视频的总目录
        self.downloadDirectoryModel = [HKDownloadModel mj_objectWithKeyValues:responseObject[@"data"][@"dir_data"]];
        self.downloadDirectoryModel.isDirectory = YES;
        self.downloadDirectoryModel.responseDicData = [NSKeyedArchiver archivedDataWithRootObject:responseObject]; // 转化二进制
        
        // 自动移动indexPath
        NSIndexPath *moveCurrentIndexPath = nil;
        self.moveCurrentIndexPath = moveCurrentIndexPath;
        
        self.dataSource = [HKCourseModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"dir_list"]];
        __block int current = -1;
        
        // 下载完成的
        NSMutableArray *finishArray = [NSMutableArray array];
        
        [self.dataSource enumerateObjectsUsingBlock:^(HKCourseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.praticeNO = @"";
            current++;
            
            // 当前正在观看的视频
            if ([obj.video_id isEqualToString:self.directoryModel.video_id]) {
//                obj.currentWatching = YES;
//                self.moveCurrentIndexPath = [NSIndexPath indexPathForRow:current inSection:0];
            }
            
            // 查找缓存
            HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:obj.mj_JSONData];
            // type
            dowmloadModel.videoType = obj.videoType;
            dowmloadModel.videoId = dowmloadModel.videoId.length? dowmloadModel.videoId : obj.video_id;
            
            dowmloadModel = [[HKDownloadManager shareInstance] queryWidthID:dowmloadModel.videoId videoType:dowmloadModel.videoType];
            obj.islocalCache = dowmloadModel.isFinish;
            
            if (obj.islocalCache) {
                [finishArray addObject:obj];
            }
        }];
        
        self.dataSource = finishArray;
        [self.foldingTableView reloadData];
        
        // 移到指定位置
        if (moveCurrentIndexPath) {
            [self.foldingTableView scrollToRowAtIndexPath:moveCurrentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }

    }else{
        
        NSDictionary *responseObject = [NSKeyedUnarchiver unarchiveObjectWithData:self.directoryModel.responseDicData];
        
        // 自动移动indexPath
        NSIndexPath *moveCurrentIndexPath = nil;
        self.moveCurrentIndexPath = moveCurrentIndexPath;
        
        // 下载视频的总目录
        self.downloadDirectoryModel = [HKDownloadModel mj_objectWithKeyValues:responseObject[@"data"][@"dir_data"]];
        self.downloadDirectoryModel.isDirectory = YES;
        self.downloadDirectoryModel.responseDicData = [NSKeyedArchiver archivedDataWithRootObject:responseObject]; // 转化二进制
        
        NSMutableArray *array = [HKCourseModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"dir_list"]];
        self.dataSource = array;
        
        // 下载完成的
        NSMutableArray *finishArray = [NSMutableArray array];
        // 遍历找出正在播放的视频
        for (int i = 0; i < array.count; i++) {
            HKCourseModel *courseDetial = array[i];
            courseDetial.praticeNO = @"";
            
            // 查找缓存
            HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:courseDetial.mj_JSONData];
            // type
            dowmloadModel.videoType = courseDetial.videoType;
            dowmloadModel.videoId = dowmloadModel.videoId.length? dowmloadModel.videoId : courseDetial.video_id;
            dowmloadModel = [[HKDownloadManager shareInstance] queryWidthID:dowmloadModel.videoId videoType:dowmloadModel.videoType];
            courseDetial.islocalCache = dowmloadModel.isFinish;
            courseDetial.needStudyLocal = dowmloadModel.needStudyLocal;
            
            if (courseDetial.islocalCache) {
                /// 2.17 版本 以前下载的 上下节不带目录  所以去除之前的上下节 课程
                if (HKVideoType_UpDownCourse == dowmloadModel.videoType) {
                    // 无目录 ID 的 是v 2.17 之前下载的课程
                    if (NO == isEmpty(dowmloadModel.parent_direct_id)) {
                        [finishArray addObject:courseDetial];
                    }
                }else{
                    [finishArray addObject:courseDetial];
                }
            }
        }
        
        self.dataSource = finishArray;
        // 刷新和空处理
        [self.foldingTableView.mj_header endRefreshing];
        [self.foldingTableView reloadData];
        
        // 移到指定位置
        if (moveCurrentIndexPath) {
            [self.foldingTableView scrollToRowAtIndexPath:moveCurrentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }
}



@end

