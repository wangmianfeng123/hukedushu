//
//  HKCourseListVC.m
//  YUFoldingTableViewDemo
//
//  Created by administrator on 16/8/25.
//  Copyright © 2016年 xuanYuLin. All rights reserved.
//

#import "HKCourseListVC.h"
#import "HKCourseModel.h"
#import "HKCourseListCell.h"
#import "DetailModel.h"
#import "VideoPlayVC.h"
#import "HKDownloadManager.h"
#import "HKDownloadModel.h"
#import "HKCourseExercisesCell.h"
#import "HKCustomMarginLabel.h"
#import "HKJobPathModel.h"
#import "NSString+MD5.h"


@interface HKCourseListVC ()<YUFoldingTableViewDelegate, HKDownloadManagerDelegate>

@property (nonatomic, weak) YUFoldingTableView *foldingTableView;

@property (nonatomic, strong)NSMutableArray<HKCourseModel *> *dataSource;

@property (nonatomic, strong)DetailModel *videlDetailModel;

@property(nonatomic,copy)NSString *selectVideoId;

@property (nonatomic,strong) HKCustomMarginLabel *chapterLB;


@end



@implementation HKCourseListVC


- (YUFoldingTableView *)foldingTableView {
    if (nil == _foldingTableView) {
    
        CGFloat height ;
        if (IS_IPAD) {
            height = SCREEN_HEIGHT - (IS_IPAD ? SCREEN_HEIGHT * 0.5 : SCREEN_WIDTH*9/16) -44 - (IS_IPHONE_X ?60 :0);
        }else{
            height = SCREEN_H - (IS_IPAD ? SCREEN_H * 0.5 : SCREEN_W*9/16) -44 - (IS_IPHONE_X ?60 :0);

        }
        
        BOOL isBuy = [self.videlDetailModel.course_data.is_buy isEqualToString:@"0"]; // 1-已购买课程 0-未购买课程
        if ([self.videlDetailModel.video_type integerValue] == HKVideoType_PGC && isBuy) {
            height = (IS_IPAD ? SCREEN_HEIGHT:SCREEN_H)*2/3-44-55;
        }
        
        YUFoldingTableView *foldingTableView = nil;
        if (IS_IPAD) {
            foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.25, 0, SCREEN_WIDTH * 0.5, height)];

        }else{
            foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, height)];

        }
        _foldingTableView = foldingTableView;

        if (@available(iOS 15.0, *)) {
            _foldingTableView.sectionHeaderTopPadding = 0;
        }
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, foldingTableView);
        [self.view addSubview:foldingTableView];
        
    }
    return _foldingTableView;
}



- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  videoId:(NSString*)videoId  detailModel:(DetailModel*)model {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.videlDetailModel = model;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:UM_RECORD_DETAIL_LIST_TAB];
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    [self setupFoldingTableView];
    [self setupRefresh];
    
    // 根据视频类型加载  1，软件入门  2，系列课，3上中下的课 4- pgc
    NSInteger type = [self.videlDetailModel.video_type integerValue];
    if (HKVideoType_LearnPath == type ||  HKVideoType_Practice == type) {//软件入门 练习题
        [self loadNewData:NO];
    } else if ( HKVideoType_JobPath == type || HKVideoType_JobPath_Practice == type) {//职业路径 职业路径练习题
        [self loadJobPathNewData];
    } else if ( HKVideoType_Series == type ||  HKVideoType_UpDownCourse == type ||  HKVideoType_PGC == type) {//系列课 有上下集的pgc
        [self loadNewDataSeries];
    }else if (self.videlDetailModel.is_series){
        [self loadNewData:YES];
    }
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
    [self.foldingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKCourseListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKCourseListCell class])];
    [self.foldingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKCourseExercisesCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKCourseExercisesCell class])];
    
    self.foldingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.foldingTableView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.foldingTableView.separatorColor = COLOR_FFFFFF_3D4752;
    
}


/**
 设置表格刷新
 */
- (void)setupRefresh {
    MJRefreshNormalHeader *mj_header = nil;
    NSInteger type = [self.videlDetailModel.video_type integerValue];
    
    if (type == HKVideoType_LearnPath || type == HKVideoType_Practice) {
        mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    } else if (type == HKVideoType_JobPath || type == HKVideoType_JobPath_Practice) {
        mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadJobPathNewData)];
    } else if (type == HKVideoType_Series || type == HKVideoType_UpDownCourse || type == HKVideoType_PGC) {
        mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataSeries)];
    }
    mj_header.automaticallyChangeAlpha = YES;
    self.foldingTableView.mj_header = mj_header;
}


#pragma mark - YUFoldingTableViewDelegate / required（必须实现的代理）
// 返回箭头的位置
- (YUFoldingSectionHeaderArrowPosition)perferedArrowPositionForYUFoldingTableView:(YUFoldingTableView *)yuTableView {
    // 默认箭头在左
    return YUFoldingSectionHeaderArrowPositionRight;
}


- (NSInteger )numberOfSectionForYUFoldingTableView:(YUFoldingTableView *)yuTableView {
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
    if (HKVideoType_Series  == type || HKVideoType_UpDownCourse == type|| HKVideoType_PGC == type) {
        return self.dataSource.count;
    }
    
    return [self rowsInSectionWithExercises:section];
}


- (UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeakSelf;
    HKCourseListCell* cell = [yuTableView  dequeueReusableCellWithIdentifier:NSStringFromClass([HKCourseListCell class])];
    
    // 系列课
    NSInteger type = [self.videlDetailModel.video_type integerValue];
    if (type == HKVideoType_Series || type == HKVideoType_UpDownCourse || type == HKVideoType_PGC) {
        
        HKCourseModel *seriesCourseModel = self.dataSource[indexPath.row];
        //[cell setModel:seriesCourseModel hiddenSpeparator:YES isSeriesCourse:YES];
        [cell setModel:seriesCourseModel hiddenSpeparator:YES videoType:type];
    }else {// 软件入门，职业路径
        
        HKCourseModel *modelTemp = [self getModelSectionWithExercises:indexPath];
        
        // 练习题的cell
        if (modelTemp.isExcercises) {
            HKCourseExercisesCell *exercisesCell = [yuTableView  dequeueReusableCellWithIdentifier:NSStringFromClass([HKCourseExercisesCell class])];
            exercisesCell.model = modelTemp;
            return exercisesCell;
            
        } else {
            // 普通学习路径的课程cell
            // 设置属性
            BOOL notHideSeparator = YES;
            HKCourseModel *superCourseModel = self.dataSource[indexPath.section];
            notHideSeparator = superCourseModel.children.count - 1 == indexPath.row;
            int videoType = !modelTemp.isJobPath? modelTemp.videoType : HKVideoType_LearnPath;
            [cell setModel:modelTemp hiddenSpeparator:!notHideSeparator videoType:videoType];
            
            
            // 展开更多的cell
            __weak YUFoldingTableView  *tableView = yuTableView;
            [cell setExpandExerciseBlock:^(HKCourseModel *model) {
                model.expandExcercises = !model.expandExcercises;
                
                [MobClick event:DETAILPAGE_LISTTAB_EXERCISE];
                
                // 查找真正的indexPath，因为增删过程会改变indexPath
                NSArray *cellArray = [tableView visibleCells];
                NSIndexPath *realIndexPath = nil;
                for (UITableViewCell *cellTemp in cellArray) {
                    
                    if ([cellTemp isKindOfClass:[HKCourseListCell class]] && ((HKCourseListCell *)cellTemp).model == model) {
                        realIndexPath = [tableView indexPathForCell:cellTemp];
                        break;
                    }
                }
                
                if (realIndexPath) {
                    NSArray<NSIndexPath *> *array = [weakSelf addOrRemoveArray:model isExpand:model.expandExcercises indexPath:realIndexPath];
                    [tableView tableViewAddOrRemoveCell:array isExpand:model.expandExcercises];
                }
            }];
        }
    }
    return cell;
}



- (HKCourseModel *)getModel:(NSIndexPath *)indexPath{
    HKCourseModel *catModel = self.dataSource[indexPath.section];
    HKCourseModel *subModel = catModel.children[indexPath.row];
    return subModel;
}



- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForHeaderInSection:(NSInteger )section
{
    // 系列课
    NSInteger type = [self.videlDetailModel.video_type integerValue];
    if (HKVideoType_Series == type ||HKVideoType_UpDownCourse == type ||HKVideoType_PGC == type) {
        return 0;
    }
    // 软件入门
    return 50;
}


- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 系列课
    NSInteger type = [self.videlDetailModel.video_type integerValue];
    if (HKVideoType_Series == type || HKVideoType_UpDownCourse == type ||HKVideoType_PGC == type) {
        return 50;
    } else {
        // 软件入门
        return 40;
    }
}



- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger)section {
    // 系列课
    NSInteger type = [self.videlDetailModel.video_type integerValue];
    if (HKVideoType_Series == type || HKVideoType_UpDownCourse == type ||HKVideoType_PGC == type) {
        return nil;
    }
    return self.dataSource[section].title;
}



- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [yuTableView deselectRowAtIndexPath:indexPath animated:YES];
    // 系列课
    NSInteger videoType = [self.videlDetailModel.video_type integerValue];
    if (videoType == HKVideoType_Series || videoType == HKVideoType_UpDownCourse || videoType == HKVideoType_PGC ) {
        
        [MobClick event:UM_RECORD_DETAIL_LIST_TAB_PLAY];
        HKCourseModel *courseModel = self.dataSource[indexPath.row];
        
        NSString *videoId = self.videlDetailModel.video_id;
        if ([courseModel.video_id isEqualToString:videoId]) {
            //当前选中的视频 不能点击跳转
            return;
        }
        [self selectClickVideo:courseModel.video_id isScroll:NO];
        if ([self.courseListDelegate respondsToSelector:@selector(courseListVC:changeCourseId:sectionId:frontCourseId:)]) {
            [self.courseListDelegate courseListVC:self changeCourseId:courseModel.video_id sectionId:courseModel.section_id frontCourseId:videoId];
        }
        
    }else {
        [MobClick event:UM_RECORD_DETAIL_LIST_TAB_PLAY];
        HKCourseModel *childCourseModel = [self getModelSectionWithExercises:indexPath];
        
        NSString *videoId = self.videlDetailModel.video_id;
        if ([childCourseModel.videoId isEqualToString:videoId]) {
            //当前选中的视频 不能点击跳转
            return;
        }
        
        [self selectClickVideo:childCourseModel.videoId isScroll:NO];
        if ([self.courseListDelegate respondsToSelector:@selector(courseListVC:changeCourseId:sectionId:frontCourseId:)]) {
            [self.courseListDelegate courseListVC:self changeCourseId:childCourseModel.video_id sectionId:childCourseModel.section_id frontCourseId:videoId];
        }
    }
}

#pragma mark - YUFoldingTableViewDelegate / optional （可选择实现的）

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView descriptionForHeaderInSection:(NSInteger )section {
    return @"";
}



- (UIImage *)yuFoldingTableView:(YUFoldingTableView *)yuTableView arrowImageForSection:(NSInteger)section {
    
    return [UIImage hkdm_imageWithNameLight:@"more_course_list_arrow_right" darkImageName:@"more_course_list_arrow_right_dark"];
}


- (UIFont *)yuFoldingTableView:(YUFoldingTableView *)yuTableView fontForTitleInSection:(NSInteger )section {
    return [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
}


- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView textColorForTitleInSection:(NSInteger )section{
    return COLOR_27323F_EFEFF6; HKColorFromHex(0x27323F, 1.0);
}

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView backgroundColorForHeaderInSection:(NSInteger )section {
    return COLOR_FFFFFF_3D4752;
}



#pragma mark 更新缓存状态
- (void)loadNewCacheStatus:(NSArray *)array {
    
    // 循环查找标记缓存
    for (HKCourseModel *selectedCourseTemp in array) {
        for (HKCourseModel *dir in self.dataSource) {
            
            if (dir.videoId.length && [dir.videoId isEqualToString:selectedCourseTemp.videoId] && dir.videoType == selectedCourseTemp.videoType) {
                if (dir.videoType != HKVideoType_JobPath) {
                    // 职业路径不需要执行（职业路径 的 section 数据里有videoID）
                    dir.islocalCache = YES;
                    break;
                }
            } else {
                
                for (HKCourseModel *child in dir.children) {
                    
                    if (selectedCourseTemp.videoType == HKVideoType_Practice && child.children) { // 练习题
                        
                        for (HKCourseModel *exercises in child.children) {
                            if ([exercises.video_id isEqualToString:selectedCourseTemp.video_id] && exercises.videoType == selectedCourseTemp.videoType) {
                                exercises.islocalCache = YES;
                                break;
                            }
                        }
                    }else if (selectedCourseTemp.videoType == HKVideoType_JobPath || selectedCourseTemp.videoType == HKVideoType_JobPath_Practice ) {
                        //职业路径
                        if ([child.video_id isEqualToString:selectedCourseTemp.video_id] && child.videoType == selectedCourseTemp.videoType) {
                            child.islocalCache = YES;
                            //break;
                        }
                        // 练习题
                        for (HKCourseModel *exercises in child.children) {
                            if ([exercises.video_id isEqualToString:selectedCourseTemp.video_id] && exercises.videoType == selectedCourseTemp.videoType) {
                                exercises.islocalCache = YES;
                                break;
                            }
                        }
                    }
                    else if ([child.video_id isEqualToString:selectedCourseTemp.video_id] && child.videoType == selectedCourseTemp.videoType) {
                        child.islocalCache = YES;
                        break;
                    }
                }
            }
        }
    }
    [self.foldingTableView reloadData];
}


#pragma mark <展开或者收缩数组>
- (NSArray<NSIndexPath *> *)addOrRemoveArray:(HKCourseModel *)model isExpand:(BOOL)isExpand indexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray<NSIndexPath *> *array = [NSMutableArray array];
    for (NSInteger i = 1; i <= model.children.count; i++) {
        [array addObject:[NSIndexPath indexPathForRow:indexPath.row + i inSection:indexPath.section]];
    }
    return array;
}



#pragma mark <软件入门剂3级目录数量>
- (NSInteger)rowsInSectionWithExercises:(NSInteger )section{
    
    NSInteger count = 0;
    // 课程
    for (HKCourseModel *course in self.dataSource[section].children) {
        count++;
        NSInteger tempCount = course.children.count;
        // 练习题
        for (int i = 0; i < tempCount && course.expandExcercises; i++) {
            count++;
        }
    }
    return count;
}


#pragma mark <软件入门剂3级目录返回数据对象>
- (HKCourseModel *)getModelSectionWithExercises:(NSIndexPath *)indexPath{
    
    NSInteger count = 0;
    HKCourseModel *modelTarget = nil;
    // 课程
    for (HKCourseModel *course in self.dataSource[indexPath.section].children) {
        
        if (indexPath.row == count++) {
            return modelTarget = course;
        }
        
        for (int i = 0; i < course.children.count && course.expandExcercises; i++) {
            if (indexPath.row == count++) {
                return modelTarget = course.children[i];
            }
        }
    }
    return modelTarget;
}


#pragma mark <Server>

- (void)loadJobPathNewData {
    @weakify(self);
    self.foldingTableView.scrollViewDelegateTempValidate = NO;
    
    NSDictionary *param = @{@"chapter_id" : self.videlDetailModel.chapterId, @"section_id" : self.videlDetailModel.sectionId, @"video_id" : self.videlDetailModel.video_id};
    
    [HKHttpTool POST:JOBPATH_DETAIL parameters:param success:^(id responseObject) {
        if (HKReponseOK) {
            @strongify(self);
            if (![responseObject[@"data"] isKindOfClass:[NSDictionary class]]) return;
            NSMutableArray *array = [HKCourseModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"chapterPath"]];
            self.dataSource = array;
            
            
            // 顶部章节
            HKJobPathModel *model = [HKJobPathModel mj_objectWithKeyValues:responseObject[@"data"][@"chapterInfo"]];
            NSString *text = [NSString stringWithFormat:@"%@ %@",model.chapter_sort,model.title];
            [self setChapterViewWithTitle:text];
            
            NSIndexPath *indexPath = nil;
            
            // 遍历找出正在播放的视频
            for (int i = 0; i < array.count; i++) {
                HKCourseModel *courseDetial = array[i];
                courseDetial.isJobPath = YES;
                //courseDetial.videoType = HKVideoType_JobPath;
                courseDetial.title = [NSString stringWithFormat:@"%@",courseDetial.title];
                
                for (int j = 0; j < courseDetial.children.count; j++) {
                    HKCourseModel *childCourseDetial = courseDetial.children[j];
                    //childCourseDetial.videoType = HKVideoType_JobPath;
                    childCourseDetial.isJobPath = YES;
                    // 添加序列
                    childCourseDetial.praticeNO = [NSString stringWithFormat:@"%d-%d",i+1, j+1];
                    
                    // 当前观看的视频
                    if ([childCourseDetial.videoId isEqualToString:self.videlDetailModel.video_id]) {
                        childCourseDetial.currentWatching = YES;
                        indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                    }
                    
                    // 查找课程缓存状态
                    HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:childCourseDetial.mj_JSONData];
                    // type
                    dowmloadModel.videoType = childCourseDetial.videoType;
                    childCourseDetial.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadModel] != HKDownloadNotExist;
                    
                    // 练习题
                    for (int k = 0; k < childCourseDetial.slaves.count; k++) {
                        HKCourseModel *exercise = childCourseDetial.slaves[k];
                        exercise.isJobPath = YES;
                        exercise.isExcercises = YES;// 练习题标识符
                        //exercise.videoType = HKVideoType_JobPath;
                        
                        // 查找练习题缓存状态
                        HKDownloadModel *dowmloadExerciseModel = [HKDownloadModel mj_objectWithKeyValues:exercise.mj_JSONData];
                        // type
                        dowmloadExerciseModel.videoType = exercise.videoType;
                        exercise.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadExerciseModel] != HKDownloadNotExist;
                        
                        // 当前观看的视频
                        if ([exercise.videoId isEqualToString:self.videlDetailModel.video_id]) {
                            exercise.currentWatching = YES; // 当前正在观看的练习题
                            childCourseDetial.expandExcercises = YES; // 展开的课程
                            childCourseDetial.isPlayingExpandExcercises = YES; // 子练习题正在播放
                            indexPath = [NSIndexPath indexPathForRow:(j + k) inSection:i]; // 移动到第几个
                        }
                    }
                }
            }
            
            // 刷新和空处理
            [self.foldingTableView.mj_header endRefreshing];
            [self.foldingTableView reloadData];
            if (self.callBackSourceBlock && self.dataSource.count) {
                self.callBackSourceBlock(self.dataSource,indexPath);
            }
            
            // 移动到相应位置
            if (indexPath && [self numberOfSectionForYUFoldingTableView:self.foldingTableView] > indexPath.section && [self yuFoldingTableView:self.foldingTableView numberOfRowsInSection:indexPath.section] > indexPath.row) {
                UITableViewCell *cell = [self.foldingTableView cellForRowAtIndexPath:indexPath];
                if (cell) {
                    [self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }
            
            self.foldingTableView.scrollViewDelegateTempValidate = YES;
        }
    } failure:^(NSError *error) {
        @strongify(self);
        self.foldingTableView.scrollViewDelegateTempValidate = YES;
    }];

}


- (void)loadNewData:(BOOL)isSeries {
    
    @weakify(self);
    self.foldingTableView.scrollViewDelegateTempValidate = NO;
    
    [[FWNetWorkServiceMediator sharedInstance] solfwareStartToken:nil videoId:self.videlDetailModel.video_id
                                                        is_Series:isSeries
                                                       completion:^(FWServiceResponse *response) {
                                                           
                                                           if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
                                                               @strongify(self);
                                                               if (![response.data isKindOfClass:[NSDictionary class]]) return;
                                                               NSMutableArray *array = [HKCourseModel mj_objectArrayWithKeyValuesArray:response.data[@"path_list"]];
                                                               
                                                               self.dataSource = array;
                                                               NSIndexPath *indexPath = nil;
                                                               
                                                               // 遍历找出正在播放的视频
                                                               for (int i = 0; i < array.count; i++) {
                                                                   HKCourseModel *courseDetial = array[i];
                                                                   NSString *chatString = [NSString stringWithFormat:@"%d", i+1];
                                                                   courseDetial.title = [NSString stringWithFormat:@"第%@章 %@", [NSString translation:chatString],courseDetial.title];
                                                                   
                                                                   for (int j = 0; j < courseDetial.children.count; j++) {
                                                                       HKCourseModel *childCourseDetial = courseDetial.children[j];
                                                                       
                                                                       // 添加序列
                                                                       childCourseDetial.praticeNO = [NSString stringWithFormat:@"%d-%d",i+1, j+1];
                                                                       
                                                                       // 当前观看的视频
                                                                       if ([childCourseDetial.videoId isEqualToString:self.videlDetailModel.video_id]) {
                                                                           childCourseDetial.currentWatching = YES;
                                                                           indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                                                                       }
                                                                       
                                                                       
                                                                       // 查找课程缓存状态
                                                                       HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:childCourseDetial.mj_JSONData];
                                                                       // type
                                                                       dowmloadModel.videoType = childCourseDetial.videoType;
                                                                       childCourseDetial.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadModel] != HKDownloadNotExist;
                                                                       
                                                                       // 练习题
                                                                       for (int k = 0; k < childCourseDetial.children.count; k++) {
                                                                           HKCourseModel *exercise = childCourseDetial.children[k];
                                                                           exercise.isExcercises = YES;// 练习题标识符
                                                                           exercise.videoType = HKVideoType_Practice;
                                                                           // 查找练习题缓存状态
                                                                           HKDownloadModel *dowmloadExerciseModel = [HKDownloadModel mj_objectWithKeyValues:exercise.mj_JSONData];
                                                                           // type
                                                                           dowmloadExerciseModel.videoType = exercise.videoType;
                                                                           exercise.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadExerciseModel] != HKDownloadNotExist;
                                                                           
                                                                           // 当前观看的视频
                                                                           if ([exercise.videoId isEqualToString:self.videlDetailModel.video_id]) {
                                                                               exercise.currentWatching = YES; // 当前正在观看的练习题
                                                                               childCourseDetial.expandExcercises = YES; // 展开的课程
                                                                               childCourseDetial.isPlayingExpandExcercises = YES; // 子练习题正在播放
                                                                               indexPath = [NSIndexPath indexPathForRow:(j + k) inSection:i]; // 移动到第几个
                                                                           }
                                                                           
                                                                       }
                                                                       
                                                                   }
                                                               }
                                                               
                                                               // 刷新和空处理
                                                               [self.foldingTableView.mj_header endRefreshing];
                                                               [self.foldingTableView reloadData];
                                                               if (self.callBackSourceBlock && self.dataSource.count) {
                                                                   self.callBackSourceBlock(self.dataSource,indexPath);
                                                               }
                                                               
                                                               // 移动到相应位置
                                                               if (indexPath && [self numberOfSectionForYUFoldingTableView:self.foldingTableView] > indexPath.section && [self yuFoldingTableView:self.foldingTableView numberOfRowsInSection:indexPath.section] > indexPath.row) {
                                                                   UITableViewCell *cell = [self.foldingTableView cellForRowAtIndexPath:indexPath];
                                                                   if (cell) {
                                                                       [self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                                                                   }
                                                               }
                                                               
                                                               self.foldingTableView.scrollViewDelegateTempValidate = YES;
                                                           }
                                                           
                                                       } failBlock:^(NSError *error) {
                                                           @strongify(self);
                                                           self.foldingTableView.scrollViewDelegateTempValidate = YES;
                                                       }];
}


- (void)loadNewDataSeries {
    
    @weakify(self);
    self.foldingTableView.scrollViewDelegateTempValidate = NO;
    if ([self.videlDetailModel.video_type integerValue] == HKVideoType_PGC) {
        self.dataSource = self.videlDetailModel.dir_list;
        __block int i = 0;
        __block NSIndexPath *indexPath = nil;
        [self.dataSource enumerateObjectsUsingBlock:^(HKCourseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.praticeNO = @"";
            
            // 当前正在观看
            if ([obj.video_id isEqualToString:self.videlDetailModel.video_id]) {
                obj.currentWatching = YES;
                indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            }
            
            // 查找缓存
            HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:obj.mj_JSONData];
            // type
            dowmloadModel.videoType = obj.videoType;
            dowmloadModel.videoId = dowmloadModel.videoId.length? dowmloadModel.videoId : obj.video_id;
            obj.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadModel] != HKDownloadNotExist;
            
            i++;
            
        }];
        [self.foldingTableView reloadData];
        if (self.callBackSourceBlock && self.dataSource.count) {
            self.callBackSourceBlock(self.dataSource,indexPath);
        }
        
        
        if (indexPath) {
           UITableViewCell *cell = [self.foldingTableView cellForRowAtIndexPath:indexPath];
           if (cell) {
               [self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
           }
       }
        
        self.foldingTableView.scrollViewDelegateTempValidate = YES;
        
    }else{
        [[FWNetWorkServiceMediator sharedInstance] seriesCourseToken:nil videoId:self.videlDetailModel.video_id
                                                           videoType:self.videlDetailModel.video_type
                                                          completion:^(FWServiceResponse *response) {
                                                              
                                                              if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
                                                                  @strongify(self);
                                                                  NSMutableArray *array = [HKCourseModel mj_objectArrayWithKeyValuesArray:response.data];
                                                                  
                                                                  self.dataSource = array;
                                                                  NSIndexPath *indexPath = nil;
                                                                  // 遍历找出正在播放的视频
                                                                  for (int i = 0; i < array.count; i++) {
                                                                      HKCourseModel *courseDetial = array[i];
                                                                      // 添加序列
                                                                      //                NSString *chatString = [NSString stringWithFormat:@"%d", i+1];
                                                                      //                courseDetial.praticeNO = [NSString stringWithFormat:@"第%@节", [self translation:chatString]];
                                                                      courseDetial.praticeNO = @"";
                                                                      
                                                                      // 正在观看的系列课
                                                                      if ([courseDetial.video_id isEqualToString:self.videlDetailModel.video_id]) {
                                                                          courseDetial.currentWatching = YES;
                                                                          indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                                                                      }
                                                                      // 查找缓存
                                                                      HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:courseDetial.mj_JSONData];
                                                                      // type
                                                                      dowmloadModel.videoType = courseDetial.videoType;
                                                                      dowmloadModel.videoId = dowmloadModel.videoId.length? dowmloadModel.videoId : courseDetial.video_id;
                                                                      courseDetial.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadModel] != HKDownloadNotExist;
                                                                      
                                                                  }
                                                                  // 刷新和空处理
                                                                  [self.foldingTableView.mj_header endRefreshing];
                                                                  [self.foldingTableView reloadData];
                                                                  if (self.callBackSourceBlock && self.dataSource.count) {
                                                                      self.callBackSourceBlock(self.dataSource,indexPath);
                                                                  }
                                                                  if (indexPath) {
                                                                     UITableViewCell *cell = [self.foldingTableView cellForRowAtIndexPath:indexPath];
                                                                     if (cell) {
                                                                         [self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                                                                     }
                                                                 }

                                                                  self.foldingTableView.scrollViewDelegateTempValidate = YES;
                                                              }
                                                          } failBlock:^(NSError *error) {
                                                              @strongify(self);
                                                              self.foldingTableView.scrollViewDelegateTempValidate = YES;
                                                          }];
    }
    
}



/**
 选中点击的cell   找出正在观看的视频

 @param videoId 视频ID
 @param isScroll Yes - 需要滚动将 选中的cell 移动到顶部
 */
- (void)selectClickVideo:(NSString *)videoId  isScroll:(BOOL)isScroll {
    self.selectVideoId = videoId;
    [self selectRowWithVideoId:videoId isScroll:isScroll];
}



#pragma mark - 找出前一个 选中 cell 的 index
- (NSIndexPath*)frontIndexPath {
    
    NSIndexPath *indexPath = nil;
    NSInteger type = [self.videlDetailModel.video_type integerValue];
    
    // 软件入门，职业路径
    if ((HKVideoType_LearnPath == type) || (HKVideoType_Practice == type) || (HKVideoType_JobPath == type) || (HKVideoType_JobPath_Practice == type) || self.videlDetailModel.is_series == YES) {
        
        // 遍历找出正在播放的视频
        for (int i = 0; i < self.dataSource.count; i++) {
            HKCourseModel *courseDetial = self.dataSource[i];
            for (int j = 0; j < courseDetial.children.count; j++) {
                HKCourseModel *childCourseDetial = courseDetial.children[j];
                // 当前观看的视频
                if ([childCourseDetial.videoId isEqualToString:self.videlDetailModel.video_id]) {
                    childCourseDetial.currentWatching = NO;
                    indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                }
                
                // 将前一个观看过的 视频 标记为已学状态
                if ([childCourseDetial.videoId isEqualToString:self.frontCourseId]) {
                    childCourseDetial.is_study = YES;
                }
                
                // 软件入门练习题
                for (int k = 0; k < childCourseDetial.children.count; k++) {
                    HKCourseModel *exercise = childCourseDetial.children[k];
                    // 当前观看的视频
                    if ([exercise.videoId isEqualToString:self.videlDetailModel.video_id]) {
                        exercise.currentWatching = NO; // 当前正在观看的练习题
                        childCourseDetial.isPlayingExpandExcercises = NO; // 子练习题正在播放
                        indexPath = [NSIndexPath indexPathForRow:(j + k) inSection:i]; // 移动到第几个
                    }
                    
                    if ([exercise.video_id isEqualToString:self.frontCourseId]) {
                        exercise.is_study = YES;
                    }
                }
            }
        }
        
    }else if ( HKVideoType_Series == type || HKVideoType_UpDownCourse == type || HKVideoType_PGC == type) {
        
        if ( HKVideoType_PGC == type ) {
            self.dataSource = self.videlDetailModel.dir_list;
            [self.dataSource enumerateObjectsUsingBlock:^(HKCourseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                // 当前正在观看
                if ([obj.video_id isEqualToString:self.videlDetailModel.video_id]) {
                    obj.currentWatching = NO;
                }
                
                if ([obj.video_id isEqualToString:self.frontCourseId]) {
                    obj.is_study = YES;
                }
            }];
            
        }else{
            
            for (int i = 0; i < self.dataSource.count; i++) {
                HKCourseModel *courseDetial = self.dataSource[i];
                // 正在观看的系列课
                if ([courseDetial.video_id isEqualToString:self.videlDetailModel.video_id]) {
                    courseDetial.currentWatching = NO;
                    indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                }
                // 将前一个观看过的 视频 标记为已学状态
                if ([courseDetial.video_id isEqualToString:self.frontCourseId]) {
                    courseDetial.is_study = YES;
                }
            }
        }
    }
    return indexPath;
}


#pragma mark - 滚动到 选中视频
- (void)selectRowWithVideoId:(NSString*)videoId  isScroll:(BOOL)isScroll {
    
    NSIndexPath *frontIndexPath = [self frontIndexPath];
    
    self.videlDetailModel.video_id = videoId;
    NSInteger type = [self.videlDetailModel.video_type integerValue];
    
    //  软件入门，职业路径
    if ((HKVideoType_LearnPath == type) || (HKVideoType_Practice == type ) || (HKVideoType_JobPath == type) || (HKVideoType_JobPath_Practice == type )|| self.videlDetailModel.is_series == YES) {
        
        NSIndexPath *indexPath = nil;
        // 遍历找出正在播放的视频
        for (int i = 0; i < self.dataSource.count; i++) {
            HKCourseModel *courseDetial = self.dataSource[i];
            
            for (int j = 0; j < courseDetial.children.count; j++) {
                HKCourseModel *childCourseDetial = courseDetial.children[j];
                // 当前观看的视频
                if ([childCourseDetial.videoId isEqualToString:self.videlDetailModel.video_id]) {
                    childCourseDetial.currentWatching = YES;
                    indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                }
                
                // 软件入门练习题
                for (int k = 0; k < childCourseDetial.children.count; k++) {
                    HKCourseModel *exercise = childCourseDetial.children[k];
                    // 当前观看的视频
                    if ([exercise.videoId isEqualToString:self.videlDetailModel.video_id]) {
                        exercise.currentWatching = YES; // 当前正在观看的练习题
                        childCourseDetial.isPlayingExpandExcercises = YES; // 子练习题正在播放
                        indexPath = [NSIndexPath indexPathForRow:(j + k) inSection:i]; // 移动到第几个
                    }
                }
            }
        }
        // 移动到相应位置
        if (indexPath && [self numberOfSectionForYUFoldingTableView:self.foldingTableView] > indexPath.section && [self yuFoldingTableView:self.foldingTableView numberOfRowsInSection:indexPath.section] > indexPath.row) {
            //[self.foldingTableView reloadRowsAtIndexPaths:@[frontIndexPath,indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.foldingTableView  reloadData];
            if (indexPath && isScroll) {
                UITableViewCell *cell = [self.foldingTableView cellForRowAtIndexPath:indexPath];
                if (cell) {
                    [self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }
        }
        
    }else if ( HKVideoType_Series == type || HKVideoType_UpDownCourse == type || HKVideoType_PGC == type) {
        
        if ( HKVideoType_PGC == type ) {
            self.dataSource = self.videlDetailModel.dir_list;
            [self.dataSource enumerateObjectsUsingBlock:^(HKCourseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                // 当前正在观看
                if ([obj.video_id isEqualToString:self.videlDetailModel.video_id]) {
                    obj.currentWatching = YES;
                }
            }];
            [self.foldingTableView reloadData];
            if (self.callBackSourceBlock && self.dataSource.count) {
                self.callBackSourceBlock(self.dataSource,nil);
            }
            
        }else{
            NSIndexPath *indexPath = nil;
            for (int i = 0; i < self.dataSource.count; i++) {
                HKCourseModel *courseDetial = self.dataSource[i];
                // 正在观看的系列课
                if ([courseDetial.video_id isEqualToString:self.videlDetailModel.video_id]) {
                    courseDetial.currentWatching = YES;
                    indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                }
            }
            [self.foldingTableView reloadData];
            
            if (indexPath && isScroll) {
                UITableViewCell *cell = [self.foldingTableView cellForRowAtIndexPath:indexPath];
                if (cell) {
                    [self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }
        }
    }
}




- (NSMutableArray<HKCourseModel *>*)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}





- (HKCustomMarginLabel *)chapterLB {
    if (!_chapterLB) {
        _chapterLB = [[HKCustomMarginLabel alloc]init];
        _chapterLB.textAlignment = NSTextAlignmentLeft;
        _chapterLB.font = HK_FONT_SYSTEM(14);
        _chapterLB.textInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _chapterLB.textColor = COLOR_27323F_EFEFF6;
        _chapterLB.backgroundColor = COLOR_F8F9FA_333D48;
        _chapterLB.tag = 1010;
    }
    return _chapterLB;
}


/** 设置章节 view */
- (void)setChapterViewWithTitle:(NSString *)title {
    
    if (HKVideoType_JobPath == [self.videlDetailModel.video_type integerValue]) {
        UIView *view = [self.view viewWithTag:1010];
        if (nil == view) {
            [self.view addSubview:self.chapterLB];
            self.chapterLB.text = title;//@"章节一 基础入门";
            self.chapterLB.frame = CGRectMake(0, 0, self.view.width, 40);
        }
        self.foldingTableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    }
}



@end




