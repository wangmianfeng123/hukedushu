//
//  HKCourseListVC.h
//  YUFoldingTableViewDemo
//
//  Created by administrator on 16/8/25.
//  Copyright © 2016年 xuanYuLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YUFoldingTableView.h"
#import "HKBaseVC.h"


@class HKCourseListVC;

@protocol HKCourseListVCDelegate <NSObject>

@optional



/// 切换课程
/// @param VC
/// @param changeCourseId 将切换到 该课程
/// @param sectionId 职业路径 sectionId
/// @param frontCourseId 前一课程
- (void)courseListVC:(HKCourseListVC*)VC changeCourseId:(NSString*)changeCourseId sectionId:(NSString*)sectionId frontCourseId:(NSString*)frontCourseId;

@end


@interface HKCourseListVC : HKBaseVC

@property (nonatomic, assign) YUFoldingSectionHeaderArrowPosition arrowPosition;

@property(nonatomic,weak)id <HKCourseListVCDelegate> courseListDelegate;

@property (nonatomic , strong) void(^callBackSourceBlock)(NSMutableArray * dataArray,NSIndexPath *indexPath);

@property(nonatomic,copy)NSString *frontCourseId;


// 查询更新缓存
- (void)loadNewCacheStatus:(NSArray *)array;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  videoId:(NSString*)videoId  detailModel:(DetailModel*)model;

/**
 选中 点击的 或者 自动跳转的视频
 
 @param videoId 点击的 或者 需要跳转的视频 ID
 */
- (void)selectClickVideo:(NSString *)videoId  isScroll:(BOOL)isScroll;

@end


//
////
////  HKCourseListVC.m
////  YUFoldingTableViewDemo
////
////  Created by administrator on 16/8/25.
////  Copyright © 2016年 xuanYuLin. All rights reserved.
////
//
//#import "HKCourseListVC.h"
//#import "HKCourseModel.h"
//#import "HKCourseListCell.h"
//#import "AFNetworkTool.h"
//#import "DetailModel.h"
//#import "VideoPlayVC.h"
//#import "HKDownloadManager.h"
//#import "HKDownloadModel.h"
//#import "HKCourseExercisesCell.h"
//#import "HKCustomMarginLabel.h"
//#import "HKJobPathModel.h"
//
//
//
//@interface HKCourseListVC ()<YUFoldingTableViewDelegate, HKDownloadManagerDelegate>
//
//@property (nonatomic, weak) YUFoldingTableView *foldingTableView;
//
//@property (nonatomic, strong)NSMutableArray<HKCourseModel *> *dataSource;
//
//@property (nonatomic, strong)DetailModel *videlDetailModel;
//
//@property(nonatomic,copy)NSString *selectVideoId;
//
//@property (nonatomic,strong) HKCustomMarginLabel *chapterLB;
//
//
//@end
//
//
//
//@implementation HKCourseListVC
//
//
//- (YUFoldingTableView *)foldingTableView {
//    if (nil == _foldingTableView) {
//
//        CGFloat height = SCREEN_HEIGHT - SCREEN_WIDTH*9/16 -44 - (IS_IPHONE_X ?60 :0);
//
//        BOOL isBuy = [self.videlDetailModel.course_data.is_buy isEqualToString:@"0"]; // 1-已购买课程 0-未购买课程
//        if ([self.videlDetailModel.video_type integerValue] == HKVideoType_PGC && isBuy) {
//            height = SCREEN_HEIGHT*2/3-44-55;
//        }
//        YUFoldingTableView *foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
//        _foldingTableView = foldingTableView;
//
//        // 兼容iOS11
//        HKAdjustsScrollViewInsetNever(self, foldingTableView);
//        [self.view addSubview:foldingTableView];
//
//    }
//    return _foldingTableView;
//}
//
//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  videoId:(NSString*)videoId  detailModel:(DetailModel*)model {
//
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.videlDetailModel = model;
//        //        [self getVideoCommentWithToken:[CommonFunction getUserToken] videoId:self.videoId page:@"1"];
//    }
//    return self;
//}
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [MobClick event:UM_RECORD_DETAIL_LIST_TAB];
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self setupFoldingTableView];
//    [self setupRefresh];
//
//    // 根据视频类型加载  1，软件入门  2，系列课，3上中下的课 4- pgc
//    if ([self.videlDetailModel.video_type integerValue] == HKVideoType_LearnPath || [self.videlDetailModel.video_type integerValue] == HKVideoType_Practice) {
//        [self loadNewData];
//    } else if ([self.videlDetailModel.video_type integerValue] == HKVideoType_JobPath) {
//        [self loadJobPathNewData];
//    } else if ([self.videlDetailModel.video_type integerValue] == HKVideoType_Series ||
//               [self.videlDetailModel.video_type integerValue] == HKVideoType_UpDownCourse ||
//               [self.videlDetailModel.video_type integerValue] == HKVideoType_PGC) {
//        [self loadNewDataSeries];
//    }
//}
//
//- (void)dealloc {
//    HK_NOTIFICATION_REMOVE();
//}
//
//
//// 创建tableView
//- (void)setupFoldingTableView {
//    self.foldingTableView.foldingDelegate = self;
//    // 默认展开
//    self.foldingTableView.foldingState = YUFoldingSectionStateShow;
//
//    // 注册Cell
//    [self.foldingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKCourseListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKCourseListCell class])];
//    [self.foldingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKCourseExercisesCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKCourseExercisesCell class])];
//
//    self.foldingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    //    if ([self.videlDetailModel.video_type integerValue] == HKVideoType_PGC) {
//    //        self.foldingTableView.contentInset = UIEdgeInsetsMake(0, 0, PADDING_30*2, 0);
//    //    }
//}
//
///**
// 设置表格刷新
// */
//- (void)setupRefresh {
//    MJRefreshNormalHeader *mj_header = nil;
//    NSInteger type = [self.videlDetailModel.video_type integerValue];
//
//    if (type == HKVideoType_LearnPath || type == HKVideoType_Practice) {
//        mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    } else if (type == HKVideoType_JobPath) {
//        mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadJobPathNewData)];
//    } else if (type == HKVideoType_Series || type == HKVideoType_UpDownCourse || type == HKVideoType_PGC) {
//        mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataSeries)];
//    }
//    mj_header.automaticallyChangeAlpha = YES;
//    self.foldingTableView.mj_header = mj_header;
//}
//
//
//#pragma mark - YUFoldingTableViewDelegate / required（必须实现的代理）
//// 返回箭头的位置
//- (YUFoldingSectionHeaderArrowPosition)perferedArrowPositionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
//{
//    // 默认箭头在左
//    return YUFoldingSectionHeaderArrowPositionRight;
//}
//- (NSInteger )numberOfSectionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
//{
//    // 系列课
//    if ([self.videlDetailModel.video_type integerValue] == HKVideoType_Series ||
//        [self.videlDetailModel.video_type integerValue] == HKVideoType_UpDownCourse ||
//        [self.videlDetailModel.video_type integerValue] == HKVideoType_PGC){
//        return 1;
//    }
//    return self.dataSource.count;
//}
//
//- (NSInteger )yuFoldingTableView:(YUFoldingTableView *)yuTableView numberOfRowsInSection:(NSInteger )section
//{
//    // 系列课
//    if ([self.videlDetailModel.video_type integerValue] == HKVideoType_Series ||
//        [self.videlDetailModel.video_type integerValue] == HKVideoType_UpDownCourse ||
//        [self.videlDetailModel.video_type integerValue] == HKVideoType_PGC) {
//        return self.dataSource.count;
//    }
//
//    return [self rowsInSectionWithExercises:section];
//    //    return self.dataSource[section].children.count;
//}
//
//- (UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    WeakSelf;
//
//    HKCourseListCell* cell = [yuTableView  dequeueReusableCellWithIdentifier:NSStringFromClass([HKCourseListCell class])];
//
//    // 系列课
//    NSInteger type = [self.videlDetailModel.video_type integerValue];
//    if (type == HKVideoType_Series || type == HKVideoType_UpDownCourse || type == HKVideoType_PGC) {
//
//        HKCourseModel *seriesCourseModel = self.dataSource[indexPath.row];
//        //[cell setModel:seriesCourseModel hiddenSpeparator:YES isSeriesCourse:YES];
//        [cell setModel:seriesCourseModel hiddenSpeparator:YES videoType:type];
//    }else {// 软件入门，职业路径
//
//        HKCourseModel *modelTemp = [self getModelSectionWithExercises:indexPath];
//
//        // 练习题的cell
//        if (modelTemp.isExcercises) {
//            HKCourseExercisesCell *exercisesCell = [yuTableView  dequeueReusableCellWithIdentifier:NSStringFromClass([HKCourseExercisesCell class])];
//            exercisesCell.model = modelTemp;
//            return exercisesCell;
//
//        } else {
//            // 普通学习路径的课程cell
//            // 设置属性
//            BOOL notHideSeparator = YES;
//            HKCourseModel *superCourseModel = self.dataSource[indexPath.section];
//            notHideSeparator = superCourseModel.children.count - 1 == indexPath.row;
//            int videoType = !modelTemp.isJobPath? modelTemp.videoType : HKVideoType_LearnPath;
//            [cell setModel:modelTemp hiddenSpeparator:!notHideSeparator videoType:videoType];
//
//
//            // 展开更多的cell
//            [cell setExpandExerciseBlock:^(HKCourseModel *model) {
//                model.expandExcercises = !model.expandExcercises;
//
//                [MobClick event:DETAILPAGE_LISTTAB_EXERCISE];
//
//                // 查找真正的indexPath，因为增删过程会改变indexPath
//                NSArray *cellArray = [yuTableView visibleCells];
//                NSIndexPath *realIndexPath = nil;
//                for (UITableViewCell *cellTemp in cellArray) {
//
//                    if ([cellTemp isKindOfClass:[HKCourseListCell class]] && ((HKCourseListCell *)cellTemp).model == model) {
//                        realIndexPath = [yuTableView indexPathForCell:cellTemp];
//                        break;
//                    }
//                }
//
//                if (realIndexPath) {
//                    NSArray<NSIndexPath *> *array = [weakSelf addOrRemoveArray:model isExpand:model.expandExcercises indexPath:realIndexPath];
//                    [yuTableView tableViewAddOrRemoveCell:array isExpand:model.expandExcercises];
//                }
//            }];
//        }
//    }
//
//    return cell;
//}
//
//- (HKCourseModel *)getModel:(NSIndexPath *)indexPath{
//    HKCourseModel *catModel = self.dataSource[indexPath.section];
//    HKCourseModel *subModel = catModel.children[indexPath.row];
//    return subModel;
//}
//
//- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForHeaderInSection:(NSInteger )section
//{
//    // 系列课
//    if ([self.videlDetailModel.video_type integerValue] == HKVideoType_Series ||
//        [self.videlDetailModel.video_type integerValue] == HKVideoType_UpDownCourse ||
//        [self.videlDetailModel.video_type integerValue] == HKVideoType_PGC) {
//
//        return 0;
//    }
//
//    // 软件入门
//    return 50;
//}
//- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    // 系列课
//    if ([self.videlDetailModel.video_type integerValue] == HKVideoType_Series ||
//        [self.videlDetailModel.video_type integerValue] == HKVideoType_UpDownCourse ||
//        [self.videlDetailModel.video_type integerValue] == HKVideoType_PGC) {
//        return 50;
//    } else {
//
//        // 软件入门
//        return 40;
//    }
//
//
//}
//- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger)section
//{
//    // 系列课
//    if ([self.videlDetailModel.video_type integerValue] == HKVideoType_Series ||
//        [self.videlDetailModel.video_type integerValue] == HKVideoType_UpDownCourse ||
//        [self.videlDetailModel.video_type integerValue] == HKVideoType_PGC) {
//
//        return nil;
//    }
//
//    return self.dataSource[section].title;
//}
//
//- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    [yuTableView deselectRowAtIndexPath:indexPath animated:YES];
//    // 系列课
//    NSInteger videoType = [self.videlDetailModel.video_type integerValue];
//    if (videoType == HKVideoType_Series || videoType == HKVideoType_UpDownCourse || videoType == HKVideoType_PGC) {
//        //if ([self.videlDetailModel.video_type integerValue] ==HKVideoType_Series || [self.videlDetailModel.video_type integerValue] == HKVideoType_UpDownCourse) {
//
//        [MobClick event:UM_RECORD_DETAIL_LIST_TAB_PLAY];
//        HKCourseModel *courseModel = self.dataSource[indexPath.row];
//        //当前选中的视频 不能点击跳转
//        if ([courseModel.video_id isEqualToString: self.videlDetailModel.video_id]) {
//            return;
//        }
//
//        [self selectClickVideo:courseModel.video_id isScroll:NO];
//        if ([self.courseListDelegate respondsToSelector:@selector(courseListVC:changeCourseId:)]) {
//            [self.courseListDelegate courseListVC:self changeCourseId:courseModel.video_id];
//        }
//
//        //[self selectClickVideo:courseModel.video_id isScroll:NO];
//
//    }else {
//        [MobClick event:UM_RECORD_DETAIL_LIST_TAB_PLAY];
//
//        HKCourseModel *childCourseModel = [self getModelSectionWithExercises:indexPath];
//
//        //        HKCourseModel *courseModel = self.dataSource[indexPath.section];
//        //        HKCourseModel *childCourseModel = courseModel.children[indexPath.row];
//        //当前选中的视频 不能点击跳转
//        if ([childCourseModel.videoId isEqualToString: self.videlDetailModel.video_id]) {
//            return;
//        }
//
//        [self selectClickVideo:childCourseModel.videoId isScroll:NO];
//        if ([self.courseListDelegate respondsToSelector:@selector(courseListVC:changeCourseId:)]) {
//            [self.courseListDelegate courseListVC:self changeCourseId:childCourseModel.video_id];
//        }
//
//        //[self selectClickVideo:childCourseModel.videoId isScroll:NO];
//    }
//}
//
//#pragma mark - YUFoldingTableViewDelegate / optional （可选择实现的）
//
//- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView descriptionForHeaderInSection:(NSInteger )section
//{
//    return @"";
//}
//
//- (UIImage *)yuFoldingTableView:(YUFoldingTableView *)yuTableView arrowImageForSection:(NSInteger)section {
//    return imageName(@"more_course_list_arrow_right");
//}
//
//- (UIFont *)yuFoldingTableView:(YUFoldingTableView *)yuTableView fontForTitleInSection:(NSInteger )section {
//    return [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
//}
//
//- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView textColorForTitleInSection:(NSInteger )section{
//    return HKColorFromHex(0x27323F, 1.0);
//}
//
////#pragma mark - WMStickyPageViewControllerDelegate
////- (UIScrollView *)streachScrollView {
////    return self.foldingTableView;
////}
//
//#pragma mark 更新缓存状态
//- (void)loadNewCacheStatus:(NSArray *)array {
//
//    // 循环查找标记缓存
//    for (HKCourseModel *selectedCourseTemp in array) {
//        for (HKCourseModel *dir in self.dataSource) {
//            if (dir.videoId.length && [dir.videoId isEqualToString:selectedCourseTemp.videoId] && dir.videoType == selectedCourseTemp.videoType) {
//                dir.islocalCache = YES;
//                break;
//            } else {
//
//                for (HKCourseModel *child in dir.children) {
//
//                    if (selectedCourseTemp.videoType == HKVideoType_Practice && child.children) { // 练习题
//
//                        for (HKCourseModel *exercises in child.children) {
//                            if ([exercises.video_id isEqualToString:selectedCourseTemp.video_id] && exercises.videoType == selectedCourseTemp.videoType) {
//                                exercises.islocalCache = YES;
//                                break;
//                            }
//                        }
//                    } else if ([child.video_id isEqualToString:selectedCourseTemp.video_id] && child.videoType == selectedCourseTemp.videoType) {
//                        child.islocalCache = YES;
//                        break;
//                    }
//                }
//            }
//        }
//    }
//    [self.foldingTableView reloadData];
//}
//
//#pragma mark <展开或者收缩数组>
//- (NSArray<NSIndexPath *> *)addOrRemoveArray:(HKCourseModel *)model isExpand:(BOOL)isExpand indexPath:(NSIndexPath *)indexPath {
//
//    NSMutableArray<NSIndexPath *> *array = [NSMutableArray array];
//    for (NSInteger i = 1; i <= model.children.count; i++) {
//        [array addObject:[NSIndexPath indexPathForRow:indexPath.row + i inSection:indexPath.section]];
//    }
//    return array;
//}
//
//#pragma mark <软件入门剂3级目录数量>
//- (NSInteger)rowsInSectionWithExercises:(NSInteger )section{
//
//    NSInteger count = 0;
//    // 课程
//    for (HKCourseModel *course in self.dataSource[section].children) {
//        count++;
//        NSInteger tempCount = course.children.count;
//        // 练习题
//        for (int i = 0; i < tempCount && course.expandExcercises; i++) {
//            count++;
//        }
//    }
//    return count;
//}
//
//
//#pragma mark <软件入门剂3级目录返回数据对象>
//- (HKCourseModel *)getModelSectionWithExercises:(NSIndexPath *)indexPath{
//
//    NSInteger count = 0;
//    HKCourseModel *modelTarget = nil;
//    // 课程
//    for (HKCourseModel *course in self.dataSource[indexPath.section].children) {
//
//        if (indexPath.row == count++) {
//            return modelTarget = course;
//        }
//
//        for (int i = 0; i < course.children.count && course.expandExcercises; i++) {
//            if (indexPath.row == count++) {
//                return modelTarget = course.children[i];
//            }
//        }
//    }
//    return modelTarget;
//}
//
//
//#pragma mark <Server>
//
//- (void)loadJobPathNewData {
//    @weakify(self);
//    self.foldingTableView.scrollViewDelegateTempValidate = NO;
//
//    NSDictionary *param = @{@"chapter_id" : self.videlDetailModel.chapterId, @"section_id" : self.videlDetailModel.sectionId, @"video_id" : self.videlDetailModel.video_id};
//
//    [HKHttpTool POST:JOBPATH_DETAIL parameters:param success:^(id responseObject) {
//        if (HKReponseOK) {
//            @strongify(self);
//            if (![responseObject[@"data"] isKindOfClass:[NSDictionary class]]) return;
//            NSMutableArray *array = [HKCourseModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"chapterPath"]];
//            self.dataSource = array;
//
//            // 顶部章节
//            HKJobPathModel *model = [HKJobPathModel mj_objectWithKeyValues:responseObject[@"data"][@"chapterInfo"]];
//            NSString *text = [NSString stringWithFormat:@"%@ %@",model.chapter_sort,model.title];
//            [self setChapterViewWithTitle:text];
//
//            NSIndexPath *indexPath = nil;
//
//            // 遍历找出正在播放的视频
//            for (int i = 0; i < array.count; i++) {
//                HKCourseModel *courseDetial = array[i];
//                courseDetial.isJobPath = YES;
//                //courseDetial.videoTypeJobPath = HKVideoType_JobPath;
//                //NSString *chatString = [NSString stringWithFormat:@"%d", i+1];
//                //courseDetial.title = [NSString stringWithFormat:@"第%@章 %@", [self translation:chatString],courseDetial.title];
//                courseDetial.title = [NSString stringWithFormat:@"%@",courseDetial.title];
//
//                for (int j = 0; j < courseDetial.children.count; j++) {
//                    HKCourseModel *childCourseDetial = courseDetial.children[j];
//                    childCourseDetial.isJobPath = YES;
//                    // 添加序列
//                    childCourseDetial.praticeNO = [NSString stringWithFormat:@"%d-%d",i+1, j+1];
//
//                    // 当前观看的视频
//                    if ([childCourseDetial.videoId isEqualToString:self.videlDetailModel.video_id]) {
//                        childCourseDetial.currentWatching = YES;
//                        indexPath = [NSIndexPath indexPathForRow:j inSection:i];
//                    }
//                    // 练习题
//                    for (int k = 0; k < childCourseDetial.slaves.count; k++) {
//                        HKCourseModel *exercise = childCourseDetial.slaves[k];
//                        exercise.isJobPath = YES;
//                        exercise.isExcercises = YES;// 练习题标识符
//                        exercise.videoType = HKVideoType_Practice;
//
//                        // 当前观看的视频
//                        if ([exercise.videoId isEqualToString:self.videlDetailModel.video_id]) {
//                            exercise.currentWatching = YES; // 当前正在观看的练习题
//                            childCourseDetial.expandExcercises = YES; // 展开的课程
//                            childCourseDetial.isPlayingExpandExcercises = YES; // 子练习题正在播放
//                            indexPath = [NSIndexPath indexPathForRow:(j + k) inSection:i]; // 移动到第几个
//                        }
//                    }
//                }
//            }
//
//            // 刷新和空处理
//            [self.foldingTableView.mj_header endRefreshing];
//            [self.foldingTableView reloadData];
//
//            // 移动到相应位置
//            if (indexPath && [self numberOfSectionForYUFoldingTableView:self.foldingTableView] > indexPath.section && [self yuFoldingTableView:self.foldingTableView numberOfRowsInSection:indexPath.section] > indexPath.row) {
//                [self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//            }
//
//            self.foldingTableView.scrollViewDelegateTempValidate = YES;
//        }
//    } failure:^(NSError *error) {
//        @strongify(self);
//        self.foldingTableView.scrollViewDelegateTempValidate = YES;
//    }];
//
//}
//
//
//- (void)loadNewData {
//
//    @weakify(self);
//    self.foldingTableView.scrollViewDelegateTempValidate = NO;
//
//    [[FWNetWorkServiceMediator sharedInstance] solfwareStartToken:nil videoId:self.videlDetailModel.video_id
//                                                       completion:^(FWServiceResponse *response) {
//
//                                                           if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
//                                                               @strongify(self);
//                                                               if (![response.data isKindOfClass:[NSDictionary class]]) return;
//                                                               NSMutableArray *array = [HKCourseModel mj_objectArrayWithKeyValuesArray:response.data[@"path_list"]];
//
//                                                               self.dataSource = array;
//
//                                                               NSIndexPath *indexPath = nil;
//
//                                                               // 遍历找出正在播放的视频
//                                                               for (int i = 0; i < array.count; i++) {
//                                                                   HKCourseModel *courseDetial = array[i];
//                                                                   NSString *chatString = [NSString stringWithFormat:@"%d", i+1];
//                                                                   courseDetial.title = [NSString stringWithFormat:@"第%@章 %@", [self translation:chatString],courseDetial.title];
//
//                                                                   for (int j = 0; j < courseDetial.children.count; j++) {
//                                                                       HKCourseModel *childCourseDetial = courseDetial.children[j];
//
//                                                                       // 添加序列
//                                                                       childCourseDetial.praticeNO = [NSString stringWithFormat:@"%d-%d",i+1, j+1];
//
//                                                                       // 当前观看的视频
//                                                                       if ([childCourseDetial.videoId isEqualToString:self.videlDetailModel.video_id]) {
//                                                                           childCourseDetial.currentWatching = YES;
//                                                                           indexPath = [NSIndexPath indexPathForRow:j inSection:i];
//                                                                       }
//
//
//                                                                       // 查找课程缓存状态
//                                                                       HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:childCourseDetial.mj_JSONData];
//                                                                       // type
//                                                                       dowmloadModel.videoType = childCourseDetial.videoType;
//                                                                       childCourseDetial.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadModel] != HKDownloadNotExist;
//
//                                                                       // 练习题
//                                                                       for (int k = 0; k < childCourseDetial.children.count; k++) {
//                                                                           HKCourseModel *exercise = childCourseDetial.children[k];
//                                                                           exercise.isExcercises = YES;// 练习题标识符
//                                                                           exercise.videoType = HKVideoType_Practice;
//                                                                           // 查找练习题缓存状态
//                                                                           HKDownloadModel *dowmloadExerciseModel = [HKDownloadModel mj_objectWithKeyValues:exercise.mj_JSONData];
//                                                                           // type
//                                                                           dowmloadExerciseModel.videoType = exercise.videoType;
//                                                                           exercise.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadExerciseModel] != HKDownloadNotExist;
//
//                                                                           // 当前观看的视频
//                                                                           if ([exercise.videoId isEqualToString:self.videlDetailModel.video_id]) {
//                                                                               exercise.currentWatching = YES; // 当前正在观看的练习题
//                                                                               childCourseDetial.expandExcercises = YES; // 展开的课程
//                                                                               childCourseDetial.isPlayingExpandExcercises = YES; // 子练习题正在播放
//                                                                               indexPath = [NSIndexPath indexPathForRow:(j + k) inSection:i]; // 移动到第几个
//                                                                           }
//
//                                                                       }
//
//                                                                   }
//                                                               }
//
//                                                               // 刷新和空处理
//                                                               [self.foldingTableView.mj_header endRefreshing];
//                                                               [self.foldingTableView reloadData];
//
//                                                               // 移动到相应位置
//                                                               if (indexPath && [self numberOfSectionForYUFoldingTableView:self.foldingTableView] > indexPath.section && [self yuFoldingTableView:self.foldingTableView numberOfRowsInSection:indexPath.section] > indexPath.row) {
//                                                                   [self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//                                                               }
//
//                                                               self.foldingTableView.scrollViewDelegateTempValidate = YES;
//                                                           }
//
//                                                       } failBlock:^(NSError *error) {
//                                                           @strongify(self);
//                                                           self.foldingTableView.scrollViewDelegateTempValidate = YES;
//                                                       }];
//}
//
//- (void)loadNewDataSeries {
//
//    @weakify(self);
//    self.foldingTableView.scrollViewDelegateTempValidate = NO;
//    if ([self.videlDetailModel.video_type integerValue] == HKVideoType_PGC) {
//        self.dataSource = self.videlDetailModel.dir_list;
//        __block int i = 0;
//        __block NSIndexPath *indexPath = nil;
//        [self.dataSource enumerateObjectsUsingBlock:^(HKCourseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            obj.praticeNO = @"";
//
//            // 当前正在观看
//            if ([obj.video_id isEqualToString:self.videlDetailModel.video_id]) {
//                obj.currentWatching = YES;
//                indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            }
//
//            // 查找缓存
//            HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:obj.mj_JSONData];
//            // type
//            dowmloadModel.videoType = obj.videoType;
//            dowmloadModel.videoId = dowmloadModel.videoId.length? dowmloadModel.videoId : obj.video_id;
//            obj.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadModel] != HKDownloadNotExist;
//
//            i++;
//
//        }];
//        [self.foldingTableView reloadData];
//
//        if (indexPath) {
//            [self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//        }
//        self.foldingTableView.scrollViewDelegateTempValidate = YES;
//
//    }else{
//        [[FWNetWorkServiceMediator sharedInstance] seriesCourseToken:nil videoId:self.videlDetailModel.video_id
//                                                           videoType:self.videlDetailModel.video_type
//                                                          completion:^(FWServiceResponse *response) {
//
//                                                              if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
//                                                                  @strongify(self);
//                                                                  NSMutableArray *array = [HKCourseModel mj_objectArrayWithKeyValuesArray:response.data];
//
//                                                                  self.dataSource = array;
//                                                                  NSIndexPath *indexPath = nil;
//                                                                  // 遍历找出正在播放的视频
//                                                                  for (int i = 0; i < array.count; i++) {
//                                                                      HKCourseModel *courseDetial = array[i];
//                                                                      // 添加序列
//                                                                      //                NSString *chatString = [NSString stringWithFormat:@"%d", i+1];
//                                                                      //                courseDetial.praticeNO = [NSString stringWithFormat:@"第%@节", [self translation:chatString]];
//                                                                      courseDetial.praticeNO = @"";
//
//                                                                      // 正在观看的系列课
//                                                                      if ([courseDetial.video_id isEqualToString:self.videlDetailModel.video_id]) {
//                                                                          courseDetial.currentWatching = YES;
//                                                                          indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                                                                      }
//                                                                      // 查找缓存
//                                                                      HKDownloadModel *dowmloadModel = [HKDownloadModel mj_objectWithKeyValues:courseDetial.mj_JSONData];
//                                                                      // type
//                                                                      dowmloadModel.videoType = courseDetial.videoType;
//                                                                      dowmloadModel.videoId = dowmloadModel.videoId.length? dowmloadModel.videoId : courseDetial.video_id;
//                                                                      courseDetial.islocalCache = [[HKDownloadManager shareInstance] queryStatus:dowmloadModel] != HKDownloadNotExist;
//
//                                                                  }
//                                                                  // 刷新和空处理
//                                                                  [self.foldingTableView.mj_header endRefreshing];
//                                                                  [self.foldingTableView reloadData];
//
//                                                                  if (indexPath) {
//                                                                      [self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//                                                                  }
//                                                                  self.foldingTableView.scrollViewDelegateTempValidate = YES;
//                                                              }
//                                                          } failBlock:^(NSError *error) {
//                                                              @strongify(self);
//                                                              self.foldingTableView.scrollViewDelegateTempValidate = YES;
//                                                          }];
//    }
//
//}
//
//
//
///**
// 选中点击的cell   找出正在观看的视频
//
// @param videoId 视频ID
// @param isScroll Yes - 需要滚动将 选中的cell 移动到顶部
// */
//- (void)selectClickVideo:(NSString *)videoId  isScroll:(BOOL)isScroll {
//    self.selectVideoId = videoId;
//    [self selectRowWithVideoId:videoId isScroll:isScroll];
//}
//
//
//
//#pragma mark - 找出前一个 选中 cell 的 index
//- (NSIndexPath*)frontIndexPath {
//
//    NSIndexPath *indexPath = nil;
//    NSInteger type = [self.videlDetailModel.video_type integerValue];
//
//    // 软件入门，职业路径
//    if ((HKVideoType_LearnPath == type) || (HKVideoType_Practice == type) || (HKVideoType_JobPath == type) || (HKVideoType_JobPath_Practice == type)) {
//
//        // 遍历找出正在播放的视频
//        for (int i = 0; i < self.dataSource.count; i++) {
//            HKCourseModel *courseDetial = self.dataSource[i];
//            for (int j = 0; j < courseDetial.children.count; j++) {
//                HKCourseModel *childCourseDetial = courseDetial.children[j];
//                // 当前观看的视频
//                if ([childCourseDetial.videoId isEqualToString:self.videlDetailModel.video_id]) {
//                    childCourseDetial.currentWatching = NO;
//                    indexPath = [NSIndexPath indexPathForRow:j inSection:i];
//                }
//
//                // 软件入门练习题
//                for (int k = 0; k < childCourseDetial.children.count; k++) {
//                    HKCourseModel *exercise = childCourseDetial.children[k];
//                    // 当前观看的视频
//                    if ([exercise.videoId isEqualToString:self.videlDetailModel.video_id]) {
//                        exercise.currentWatching = NO; // 当前正在观看的练习题
//                        childCourseDetial.isPlayingExpandExcercises = NO; // 子练习题正在播放
//                        indexPath = [NSIndexPath indexPathForRow:(j + k) inSection:i]; // 移动到第几个
//                    }
//                }
//            }
//        }
//
//    }else if ( HKVideoType_Series == type || HKVideoType_UpDownCourse == type || HKVideoType_PGC == type) {
//
//        if ( HKVideoType_PGC == type ) {
//            self.dataSource = self.videlDetailModel.dir_list;
//            [self.dataSource enumerateObjectsUsingBlock:^(HKCourseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                // 当前正在观看
//                if ([obj.video_id isEqualToString:self.videlDetailModel.video_id]) {
//                    obj.currentWatching = NO;
//                }
//            }];
//
//        }else{
//
//            for (int i = 0; i < self.dataSource.count; i++) {
//                HKCourseModel *courseDetial = self.dataSource[i];
//                // 正在观看的系列课
//                if ([courseDetial.video_id isEqualToString:self.videlDetailModel.video_id]) {
//                    courseDetial.currentWatching = NO;
//                    indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                }
//            }
//        }
//    }
//    return indexPath;
//}
//
//
//#pragma mark - 滚动到 选中视频
//- (void)selectRowWithVideoId:(NSString*)videoId  isScroll:(BOOL)isScroll {
//
//    NSIndexPath *frontIndexPath = [self frontIndexPath];
//
//    self.videlDetailModel.video_id = videoId;
//    NSInteger type = [self.videlDetailModel.video_type integerValue];
//
//    //  软件入门，职业路径
//    if ((HKVideoType_LearnPath == type) || (HKVideoType_Practice == type ) || (HKVideoType_JobPath == type) || (HKVideoType_JobPath_Practice == type )) {
//
//        NSIndexPath *indexPath = nil;
//        // 遍历找出正在播放的视频
//        for (int i = 0; i < self.dataSource.count; i++) {
//            HKCourseModel *courseDetial = self.dataSource[i];
//
//            for (int j = 0; j < courseDetial.children.count; j++) {
//                HKCourseModel *childCourseDetial = courseDetial.children[j];
//                // 当前观看的视频
//                if ([childCourseDetial.videoId isEqualToString:self.videlDetailModel.video_id]) {
//                    childCourseDetial.currentWatching = YES;
//                    indexPath = [NSIndexPath indexPathForRow:j inSection:i];
//                }
//
//                // 软件入门练习题
//                for (int k = 0; k < childCourseDetial.children.count; k++) {
//                    HKCourseModel *exercise = childCourseDetial.children[k];
//                    // 当前观看的视频
//                    if ([exercise.videoId isEqualToString:self.videlDetailModel.video_id]) {
//                        exercise.currentWatching = YES; // 当前正在观看的练习题
//                        childCourseDetial.isPlayingExpandExcercises = YES; // 子练习题正在播放
//                        indexPath = [NSIndexPath indexPathForRow:(j + k) inSection:i]; // 移动到第几个
//                    }
//                }
//            }
//        }
//        // 移动到相应位置
//        if (indexPath && [self numberOfSectionForYUFoldingTableView:self.foldingTableView] > indexPath.section && [self yuFoldingTableView:self.foldingTableView numberOfRowsInSection:indexPath.section] > indexPath.row) {
//            //[self.foldingTableView reloadRowsAtIndexPaths:@[frontIndexPath,indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            [self.foldingTableView  reloadData];
//            if (indexPath && isScroll) {
//                [UIView animateWithDuration:0.02 animations:^{
//
//                } completion:^(BOOL finished) {
//                    [self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//                }];
//                //[self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//            }
//        }
//
//    }else if ( HKVideoType_Series == type || HKVideoType_UpDownCourse == type || HKVideoType_PGC == type) {
//
//        if ( HKVideoType_PGC == type ) {
//            self.dataSource = self.videlDetailModel.dir_list;
//            [self.dataSource enumerateObjectsUsingBlock:^(HKCourseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                // 当前正在观看
//                if ([obj.video_id isEqualToString:self.videlDetailModel.video_id]) {
//                    obj.currentWatching = YES;
//                }
//            }];
//            [self.foldingTableView reloadData];
//
//        }else{
//            NSIndexPath *indexPath = nil;
//            for (int i = 0; i < self.dataSource.count; i++) {
//                HKCourseModel *courseDetial = self.dataSource[i];
//                // 正在观看的系列课
//                if ([courseDetial.video_id isEqualToString:self.videlDetailModel.video_id]) {
//                    courseDetial.currentWatching = YES;
//                    indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                }
//            }
//            [self.foldingTableView reloadData];
//            if (indexPath && isScroll) {
//                [self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//            }
//        }
//    }
//}
//
//
//// 阿拉伯转汉字
//- (NSString *)translation:(NSString *)arebic
//
//{   NSString *str = arebic;
//    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
//    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
//    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
//    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
//
//    NSMutableArray *sums = [NSMutableArray array];
//    for (int i = 0; i < str.length; i ++) {
//        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
//        NSString *a = [dictionary objectForKey:substr];
//        NSString *b = digits[str.length -i-1];
//        NSString *sum = [a stringByAppendingString:b];
//        if ([a isEqualToString:chinese_numerals[9]])
//        {
//            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
//            {
//                sum = b;
//                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
//                {
//                    [sums removeLastObject];
//                }
//            }else
//            {
//                sum = chinese_numerals[9];
//            }
//
//            if ([[sums lastObject] isEqualToString:sum])
//            {
//                continue;
//            }
//        }
//
//        [sums addObject:sum];
//    }
//
//    NSString *sumStr = [sums  componentsJoinedByString:@""];
//    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
//    //NSLog(@"str %@",str);
//    //NSLog(@"chinese %@",chinese);
//    return chinese;
//}
//
//
//
//- (NSMutableArray<HKCourseModel *>*)dataSource {
//    if (!_dataSource) {
//        _dataSource = [NSMutableArray array];
//    }
//    return _dataSource;
//}
//
//
//
//
//
//- (HKCustomMarginLabel *)chapterLB {
//    if (!_chapterLB) {
//        _chapterLB = [[HKCustomMarginLabel alloc]init];
//        _chapterLB.textAlignment = NSTextAlignmentLeft;
//        _chapterLB.font = HK_FONT_SYSTEM(14);
//        _chapterLB.textInsets = UIEdgeInsetsMake(0, 20, 0, 0);
//        _chapterLB.textColor = COLOR_27323F;
//        _chapterLB.backgroundColor = COLOR_F8F9FA;
//        _chapterLB.tag = 1010;
//    }
//    return _chapterLB;
//}
//
//
///** 设置章节 view */
//- (void)setChapterViewWithTitle:(NSString *)title {
//
//    if (HKVideoType_JobPath == [self.videlDetailModel.video_type integerValue]) {
//        UIView *view = [self.view viewWithTag:1010];
//        if (nil == view) {
//            [self.view addSubview:self.chapterLB];
//            self.chapterLB.text = title;//@"章节一 基础入门";
//            self.chapterLB.frame = CGRectMake(0, 0, self.view.width, 40);
//        }
//        self.foldingTableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
//    }
//}
//
//
//
//@end
//
//
//
