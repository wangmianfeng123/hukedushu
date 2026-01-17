//
//  ZFHKNormalPlayerCourseListView.m
//  Code
//
//  Created by Ivan li on 2021/4/1.
//  Copyright © 2021 pg. All rights reserved.
//

#import "ZFHKNormalPlayerCourseListView.h"
#import "HKCourseModel.h"
#import "YUFoldingTableView.h"
#import "HKCourseListCell.h"
#import "DetailModel.h"
#import "VideoPlayVC.h"
#import "HKDownloadManager.h"
#import "HKDownloadModel.h"
#import "HKCourseExercisesCell.h"
#import "HKCustomMarginLabel.h"
#import "HKJobPathModel.h"
#import "NSString+MD5.h"

@interface ZFHKNormalPlayerCourseListView ()<YUFoldingTableViewDelegate>
@property (nonatomic, strong) YUFoldingTableView *foldingTableView;
@property(nonatomic,copy)NSString *selectVideoId;
@property(nonatomic,copy)NSString *frontCourseId;

@end

@implementation ZFHKNormalPlayerCourseListView

-(void)setDataSource:(NSMutableArray<HKCourseModel *> *)dataSource{
    _dataSource = dataSource;
    //[self.foldingTableView reloadData];
    //[self refreshData];
}


- (void)refreshData{
    if (self.dataSource.count == 0) return;
    [self resetCourseStatus];
    NSInteger type = [self.videlDetailModel.video_type integerValue];
    
    //  软件入门，职业路径
    if ((HKVideoType_LearnPath == type) || (HKVideoType_Practice == type ) || (HKVideoType_JobPath == type) || (HKVideoType_JobPath_Practice == type )) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
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
        [self.foldingTableView reloadData];
        //存在崩溃
        if (indexPath) {
            UITableViewCell *cell = [self.foldingTableView cellForRowAtIndexPath:indexPath];
            if (cell) {
                [self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
            
        }else{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            for (int i = 0; i < self.dataSource.count; i++) {
                HKCourseModel *courseDetial = self.dataSource[i];
                // 正在观看的系列课
                if ([courseDetial.video_id isEqualToString:self.videlDetailModel.video_id]) {
                    courseDetial.currentWatching = YES;
                    indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                }
            }
            [self.foldingTableView reloadData];
            
            //存在崩溃
            if (indexPath) {
                UITableViewCell *cell = [self.foldingTableView cellForRowAtIndexPath:indexPath];
                if (cell) {
                    [self.foldingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }
            
        }
    }
}

- (instancetype)init{
    if ([super init]) {
        [self createUI];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self refreshData];
    self.foldingTableView.frame = CGRectMake(0, 0, self.width, self.height);
    
}

- (void)createUI{
    self.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
    [self setupFoldingTableView];
}

// 创建tableView
- (void)setupFoldingTableView {
    //self.foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
    self.foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) withType:UITableViewStyleGrouped];
    self.foldingTableView.foldingDelegate = self;
    // 默认展开
    self.foldingTableView.foldingState = YUFoldingSectionStateShow;
    
    // 注册Cell
    [self.foldingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKCourseListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKCourseListCell class])];
    [self.foldingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKCourseExercisesCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKCourseExercisesCell class])];
    
    self.foldingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.foldingTableView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.foldingTableView.separatorColor = [UIColor clearColor];
    self.foldingTableView.backgroundColor = [UIColor clearColor];
    self.foldingTableView.noShowLine = YES;
    [self addSubview:self.foldingTableView];
    if (@available(iOS 15.0, *)) {
        _foldingTableView.sectionHeaderTopPadding = 0;
    }
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
//        return 5;
    }
    
    return [self rowsInSectionWithExercises:section];
}


- (UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeakSelf;
    HKCourseListCell* cell = [yuTableView  dequeueReusableCellWithIdentifier:NSStringFromClass([HKCourseListCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isFromLandScape = YES;
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
            exercisesCell.isLandScape = YES;
            exercisesCell.backgroundColor = [UIColor clearColor];
            exercisesCell.model = modelTemp;
            //exercisesCell.titleLB.textColor = [UIColor whiteColor];
            exercisesCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [MobClick event:videodetailpage_fulllplayer_series];
//    [self resetCourseStatus];
    
    // 系列课
    NSInteger videoType = [self.videlDetailModel.video_type integerValue];
    if (videoType == HKVideoType_Series || videoType == HKVideoType_UpDownCourse || videoType == HKVideoType_PGC) {

        HKCourseModel *courseModel = self.dataSource[indexPath.row];

        NSString *videoId = self.videlDetailModel.video_id;
        if ([courseModel.video_id isEqualToString:videoId]) {
            //当前选中的视频 不能点击跳转
            return;
        }
        [self selectClickVideo:courseModel.video_id isScroll:NO];
        if (self.didCourseBlock) {
            self.didCourseBlock(courseModel.video_id, courseModel.section_id, videoId);
        }
    }else {
        HKCourseModel *childCourseModel = [self getModelSectionWithExercises:indexPath];

        NSString *videoId = self.videlDetailModel.video_id;
        if ([childCourseModel.videoId isEqualToString:videoId]) {
            //当前选中的视频 不能点击跳转
            return;
        }

        [self selectClickVideo:childCourseModel.videoId isScroll:NO];
        if (self.didCourseBlock) {
            self.didCourseBlock(childCourseModel.video_id, childCourseModel.section_id, videoId);
        }
    }
}

//#pragma mark - YUFoldingTableViewDelegate / optional （可选择实现的）
- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView descriptionForHeaderInSection:(NSInteger )section {
    return @"";
}

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView backgroundColorForHeaderInSection:(NSInteger )section{
    return [UIColor clearColor];
}

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView textColorForTitleInSection:(NSInteger )section{
    return [UIColor whiteColor];
}

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView textColorForDescriptionInSection:(NSInteger )section{
    return [UIColor whiteColor];
}

- (UIImage *)yuFoldingTableView:(YUFoldingTableView *)yuTableView arrowImageForSection:(NSInteger)section {

    return [[UIImage alloc] init];
}

- (UIFont *)yuFoldingTableView:(YUFoldingTableView *)yuTableView fontForTitleInSection:(NSInteger )section {
    return [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
}

- (BOOL )yuFoldingTableView:(YUFoldingTableView *)yuTableView sectionTitle:(NSInteger)section isClick:(BOOL)isClick{
    return NO;
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

/**
 选中点击的cell   找出正在观看的视频

 @param videoId 视频ID
 @param isScroll Yes - 需要滚动将 选中的cell 移动到顶部
 */
- (void)selectClickVideo:(NSString *)videoId  isScroll:(BOOL)isScroll {
    self.selectVideoId = videoId;
    [self selectRowWithVideoId:videoId isScroll:isScroll];
}

#pragma mark - 滚动到 选中视频
- (void)selectRowWithVideoId:(NSString*)videoId  isScroll:(BOOL)isScroll {
    
    NSIndexPath *frontIndexPath = [self frontIndexPath];
    
    self.videlDetailModel.video_id = videoId;
    NSInteger type = [self.videlDetailModel.video_type integerValue];
    
    //  软件入门，职业路径
    if ((HKVideoType_LearnPath == type) || (HKVideoType_Practice == type ) || (HKVideoType_JobPath == type) || (HKVideoType_JobPath_Practice == type )) {
        
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

#pragma mark - 找出前一个 选中 cell 的 index
- (NSIndexPath*)frontIndexPath {
    
    NSIndexPath *indexPath = nil;
    NSInteger type = [self.videlDetailModel.video_type integerValue];
    
    // 软件入门，职业路径
    if ((HKVideoType_LearnPath == type) || (HKVideoType_Practice == type) || (HKVideoType_JobPath == type) || (HKVideoType_JobPath_Practice == type)) {
        
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


- (void)resetCourseStatus{
    NSInteger type = [self.videlDetailModel.video_type integerValue];
        
    //  软件入门，职业路径
    if ((HKVideoType_LearnPath == type) || (HKVideoType_Practice == type ) || (HKVideoType_JobPath == type) || (HKVideoType_JobPath_Practice == type )) {
        // 遍历找出正在播放的视频
        for (int i = 0; i < self.dataSource.count; i++) {
            HKCourseModel *courseDetial = self.dataSource[i];
            for (int j = 0; j < courseDetial.children.count; j++) {
                HKCourseModel *childCourseDetial = courseDetial.children[j];
                // 当前观看的视频
                childCourseDetial.currentWatching = NO;
                
                // 软件入门练习题
                for (int k = 0; k < childCourseDetial.children.count; k++) {
                    HKCourseModel *exercise = childCourseDetial.children[k];
                    exercise.currentWatching = NO; // 当前正在观看的练习题
                }
            }
        }
    }else if ( HKVideoType_Series == type || HKVideoType_UpDownCourse == type || HKVideoType_PGC == type) {
        if ( HKVideoType_PGC == type ) {
            [self.dataSource enumerateObjectsUsingBlock:^(HKCourseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                // 当前正在观看
                if ([obj.video_id isEqualToString:self.videlDetailModel.video_id]) {
                    obj.currentWatching = NO;
                }
            }];
        }else{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            for (int i = 0; i < self.dataSource.count; i++) {
                HKCourseModel *courseDetial = self.dataSource[i];
                // 正在观看的系列课
                if ([courseDetial.video_id isEqualToString:self.videlDetailModel.video_id]) {
                    courseDetial.currentWatching = NO;
                    indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                }
            }
        }
    }
}

@end
