//
//  HKJobPathCourseListVC.m
//  Code
//
//  Created by Ivan li on 2019/6/10.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKJobPathCourseListVC.h"
#import "HKCourseModel.h"

#import "DetailModel.h"
#import "VideoPlayVC.h"
#import "HKCourseExercisesCell.h"

#import "HKJobPathCourseListCell.h"
#import "HKJobPathCourseListBottomView.h"
#import "AppDelegate.h"
#import "HKJobPathModel.h"




@interface HKJobPathCourseListVC ()<YUFoldingTableViewDelegate>

@property (nonatomic, strong) YUFoldingTableView *foldingTableView;

@property (nonatomic, strong)NSMutableArray<HKCourseModel *> *dataSource;

@property (nonatomic,copy) NSString *jobCourseId;

@property (nonatomic, strong) HKJobPathCourseListBottomView * bottomView;

@property (nonatomic,assign) HKJobPathCourseListBottomViewType bottomViewType;

@property (nonatomic, strong)HKJobPathStudyedModel *studyedModel;

@property (nonatomic, weak)HKJobPathModel *jobModel;

@property (nonatomic,assign)BOOL  showBottomView;
/** 用于 职业路径 后台统计 */
@property (nonatomic,copy) NSString *sourceId;

@end


@implementation HKJobPathCourseListVC


- (instancetype)initWitVideoId:(NSString*)videoId {
    
    self = [super init];
    if (self) {
        self.jobCourseId = videoId;
        
    }
    return self;
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNewData];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    TTVIEW_RELEASE_SAFELY(self.bottomView);
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setBottomView];
}



- (void)loadView {
    [super loadView];
    [self createUI];
}


- (void)createUI {
    self.view.clipsToBounds = YES;
    self.view.layer.cornerRadius = 15;
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    [self setupRefresh];
}


- (void)setJobCourseId:(NSString *)jobCourseId {
    _jobCourseId = jobCourseId;
}


- (void)setSourceId:(NSString *)sourceId {
    _sourceId = sourceId;
}




- (YUFoldingTableView *)foldingTableView {
    if (_foldingTableView == nil) {

        CGFloat height = self.view.height - 50;
        _foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        [_foldingTableView setContentInset:UIEdgeInsetsMake(0, 0, KTabBarHeight49+50, 0)];
        
        _foldingTableView.foldingDelegate = self;
        // 默认展开
        _foldingTableView.foldingState = YUFoldingSectionStateShow;
        // 注册Cell
        [_foldingTableView registerClass:[HKJobPathCourseListCell class] forCellReuseIdentifier:NSStringFromClass([HKJobPathCourseListCell class])];
        
        [_foldingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKCourseExercisesCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKCourseExercisesCell class])];
        
        _foldingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_foldingTableView];
        _foldingTableView.backgroundColor = COLOR_FFFFFF_3D4752;
        if (@available(iOS 15.0, *)) {
            //区头间距
            _foldingTableView.sectionHeaderTopPadding = 0;
        }
    }
    return _foldingTableView;
}



/**
 设置表格刷新
 */
- (void)setupRefresh {
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.foldingTableView completion:^{
        [weakSelf loadNewData];
    }];
}


#pragma mark - YUFoldingTableViewDelegate / required（必须实现的代理）

// 返回箭头的位置
- (YUFoldingSectionHeaderArrowPosition)perferedArrowPositionForYUFoldingTableView:(YUFoldingTableView *)yuTableView {
    // 默认箭头在左
    return YUFoldingSectionHeaderArrowPositionRight;
}


- (NSInteger )numberOfSectionForYUFoldingTableView:(YUFoldingTableView *)yuTableView {

    return self.dataSource.count;
}


- (NSInteger )yuFoldingTableView:(YUFoldingTableView *)yuTableView numberOfRowsInSection:(NSInteger )section {

    return [self rowsInSectionWithExercises:section];
}


- (UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeakSelf;
    HKJobPathCourseListCell* cell = [yuTableView  dequeueReusableCellWithIdentifier:NSStringFromClass([HKJobPathCourseListCell class])];
    
    // 软件入门
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
        cell.model = modelTemp;
        
        // 展开更多的cell
        __weak YUFoldingTableView *weakTableView = yuTableView;
        [cell setExpandExerciseBlock:^(HKCourseModel *model) {
            model.expandExcercises = !model.expandExcercises;
            
            // 查找真正的indexPath，因为增删过程会改变indexPath
            NSArray *cellArray = [weakTableView visibleCells];
            NSIndexPath *realIndexPath = nil;
            for (UITableViewCell *cellTemp in cellArray) {
                
                if ([cellTemp isKindOfClass:[HKJobPathCourseListCell class]] && ((HKJobPathCourseListCell *)cellTemp).model == model) {
                    realIndexPath = [weakTableView indexPathForCell:cellTemp];
                    break;
                }
            }
            if (realIndexPath) {
                NSArray<NSIndexPath *> *array = [weakSelf addOrRemoveArray:model isExpand:model.expandExcercises indexPath:realIndexPath];
                [weakTableView tableViewAddOrRemoveCell:array isExpand:model.expandExcercises];
            }
        }];
    }
    return cell;
}


- (HKCourseModel *)getModel:(NSIndexPath *)indexPath {
    HKCourseModel *catModel = self.dataSource[indexPath.section];
    HKCourseModel *subModel = catModel.children[indexPath.row];
    return subModel;
}


- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForFooterInSection:(NSInteger )section {
    
    return 16;
}

- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForHeaderInSection:(NSInteger )section {
    // 软件入门
    return 50;
}

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView backgroundColorForHeaderInSection:(NSInteger )section {
    return  COLOR_FFFFFF_3D4752;
}



- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger)section {

    return self.dataSource[section].title;
}


- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [yuTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HKCourseModel *courseModel = self.dataSource[indexPath.section];
    NSInteger count = courseModel.children.count ;
    if ((count > indexPath.row) && (count>0)) {
        HKCourseModel *model = courseModel.children[indexPath.row];
        model.career_id = self.jobCourseId;
        if (isEmpty(model.video_id) || isEmpty(model.chapter_id)) {
            return;
        }
        VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:model.video_title placeholderImage:model.img_cover_url lookStatus:LookStatusInternetVideo videoId:model.video_id model:model];
        VC.videoType = HKVideoType_JobPath;
        [self pushToOtherController:VC];
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
    return [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
}

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView textColorForTitleInSection:(NSInteger )section{
    return COLOR_27323F_EFEFF6;
}

#pragma mark  标题 左边距
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView sectionTitleLeftMaginForSection:(NSInteger )section {
    return 30;
}

- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView sectionArrowRightMarginForSection:(NSInteger )section {
    return 30;
}

- (BOOL )yuFoldingTableView:(YUFoldingTableView *)yuTableView sectionTitle:(NSInteger)section isClick:(BOOL)isClick {
    return NO;
}


- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView sectionTitleClicked:(NSInteger)section {

    HKCourseModel *courseModel = self.dataSource[section];
    if (courseModel.children.count) {
        HKCourseModel *model = courseModel.children[0];
        model.career_id = self.jobCourseId;
        if (isEmpty(model.video_id) || isEmpty(model.chapter_id)) {
            return;
        }
        VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:model.video_title placeholderImage:model.img_cover_url lookStatus:LookStatusInternetVideo videoId:model.video_id model:model];
        VC.videoType = HKVideoType_JobPath;
        [self pushToOtherController:VC];
    }
}


- (BOOL)yuFoldingTableView:(YUFoldingTableView *)yuTableView sectionTitleShowAnimation:(NSInteger)section {
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
- (NSInteger) rowsInSectionWithExercises:(NSInteger )section{
    
    NSInteger count = 0;
    // 课程
    for (HKCourseModel *course in self.dataSource[section].children) {
        count++;
        // 练习题
        for (int i = 0; i < course.children.count && course.expandExcercises; i++) {
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
        // 练习题
        for (int i = 0; i < course.children.count && course.expandExcercises; i++) {
            if (indexPath.row == count++) {
                return modelTarget = course.children[i];
            }
        }
    }
    return modelTarget;
}


#pragma mark <Server>
- (void)loadNewData {
    
    if (self.dataSource.count) {
        return;
    }
    @weakify(self);
    self.foldingTableView.scrollViewDelegateTempValidate = NO;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (!isEmpty(self.jobCourseId)) {
        dict[@"career_id"] = self.jobCourseId;
    }
    
    if (!isEmpty(self.sourceId)) {
        dict[@"source"] = self.sourceId;
    }
    
    [HKHttpTool POST:CAREER_DETAIL parameters:dict success:^(id responseObject) {
        if (HKReponseOK) {
            @strongify(self);
            if (![responseObject[@"data"] isKindOfClass:[NSDictionary class]]) return;
            
            NSMutableArray *array = [HKCourseModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"pathInfo"]];
            self.dataSource = array;
            
            // 遍历找出正在播放的视频
            for (int i = 0; i < array.count; i++) {
                HKCourseModel *courseDetial = array[i];
                //NSString *chatString = [NSString stringWithFormat:@"%d", i+1];
                //courseDetial.title = [NSString stringWithFormat:@"章节%@ %@", [self translation:chatString],courseDetial.title];
                courseDetial.title = [NSString stringWithFormat:@"%@",courseDetial.title];
                
                for (int j = 0; j < courseDetial.children.count; j++) {
                    HKCourseModel *childCourseDetial = courseDetial.children[j];
                    // 添加序列
                    childCourseDetial.praticeNO = [NSString stringWithFormat:@"%d、", j+1];
                }
            }
            // 刷新和空处理
            [self.foldingTableView.mj_header endRefreshing];
            [self.foldingTableView reloadData];
            self.foldingTableView.scrollViewDelegateTempValidate = YES;
            
            HKJobPathModel *jobModel = [HKJobPathModel mj_objectWithKeyValues:responseObject[@"data"][@"careerInfo"]];
            self.jobModel = jobModel;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(hkJobPathCourseListVC:jobModel:)]) {
                [self.delegate hkJobPathCourseListVC:self jobModel:jobModel];
            }
            
            ShareModel *shareModel = [ShareModel mj_objectWithKeyValues:responseObject[@"data"][@"shareInfo"]];
            if (self.delegate && [self.delegate respondsToSelector:@selector(hkJobPathCourseListVC:shareModel:)]) {
                [self.delegate hkJobPathCourseListVC:self shareModel:shareModel];
            }
            
            self.studyedModel = [HKJobPathStudyedModel mj_objectWithKeyValues:responseObject[@"data"][@"studiedBeforeInfo"]];
            self.studyedModel.total_count = jobModel.course_count; // 课程数量
                        
            if (self.delegate && [self.delegate respondsToSelector:@selector(hkJobPathCourseListVC:showBottomView:)]) {
                
                self.showBottomView = YES;
                [self.delegate hkJobPathCourseListVC:self showBottomView:YES];
                [self setBottomView];
            }
            
            self.headGuideModel = [HKJobPathHeadGuideModel mj_objectWithKeyValues:responseObject[@"data"][@"headGuide"]];
            if (self.delegate && [self.delegate respondsToSelector:@selector(hkJobPathCourseListVC:headGuideModel:)]) {
                [self.delegate hkJobPathCourseListVC:self headGuideModel:self.headGuideModel];
            }
        }
    } failure:^(NSError *error) {
        @strongify(self);
        if (0 == self.dataSource.count) {
            [self.foldingTableView reloadData];
        }
        [self.foldingTableView.mj_header endRefreshing];
        self.foldingTableView.scrollViewDelegateTempValidate = YES;
    }];
}




- (void)setBottomView {
    
    if (self.showBottomView) {
        self.bottomViewType = self.studyedModel.studiedCount ?HKJobPathCourseListBottomViewType_Record : HKJobPathCourseListBottomViewType_Study;
        
        if (self.bottomViewType != HKJobPathCourseListBottomViewType_None) {
            [[AppDelegate sharedAppDelegate].window addSubview:self.bottomView];
            self.bottomView.viewType = self.bottomViewType;
            
            [self.bottomView createUI];
            
            if (self.studyedModel.studiedCount) {
                self.bottomView.model = self.studyedModel;
            }else{
                HKJobPathStudyedModel *model = [HKJobPathStudyedModel new];
                model.lastStudied = [HKJobPathModel new];
                model.lastStudied.chapter_id = self.jobModel.first_chapter_info.chapter_id;
                model.lastStudied.section_id = self.jobModel.first_chapter_info.first_section_id;
                model.lastStudied.video_id = self.jobModel.first_chapter_info.first_video_id;
                model.lastStudied.career_id = self.jobCourseId;
                
                self.bottomView.model = model;
            }
            
            CGFloat height = (HKJobPathCourseListBottomViewType_Study == self.bottomView.viewType) ?50 :115/2;
            self.bottomView.frame = CGRectMake(0, IS_IPHONE_X ?(SCREEN_HEIGHT- height - 15) :SCREEN_HEIGHT- height, SCREEN_WIDTH, IS_IPHONE_X ? height+15 :height);
            
        }
    }
}


- (HKJobPathCourseListBottomView*)bottomView {
    if (!_bottomView) {
        @weakify(self);
        _bottomView = [HKJobPathCourseListBottomView new];
        _bottomView.studyBtnClickBlock = ^(HKJobPathStudyedModel * _Nonnull model) {
            @strongify(self);
            model.lastStudied.source = @"study_now";
            [self pushToVideoPlayVC:model];
        };
        
        _bottomView.goOnBtnClickBlock = ^(HKJobPathStudyedModel * _Nonnull model) {
            @strongify(self);
            model.lastStudied.source = @"continue_study";
            [self pushToVideoPlayVC:model];
        };
    }
    return _bottomView;
}



- (void)pushToVideoPlayVC:(HKJobPathStudyedModel *)model {
    HKCourseModel *courseModel = [HKCourseModel new];
    courseModel.career_id = model.lastStudied.career_id;
    courseModel.chapter_id = model.lastStudied.chapter_id;
    courseModel.ID = model.lastStudied.section_id;
    courseModel.video_id = model.lastStudied.video_id;
    courseModel.sourceId = model.lastStudied.source;
    
    if (!isEmpty(courseModel.video_id) && !isEmpty(courseModel.chapter_id)) {
        VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:courseModel.video_title
                                             placeholderImage:courseModel.img_cover_url lookStatus:LookStatusInternetVideo
                                                      videoId:courseModel.video_id model:courseModel];
        
        VC.videoType = HKVideoType_JobPath;
        [self pushToOtherController:VC];
    }
}






- (NSMutableArray<HKCourseModel *>*)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}




@end






