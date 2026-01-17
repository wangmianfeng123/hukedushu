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


@class HKLiveDetailModel;

@interface HKLiveCourseListVC : HKBaseVC

@property (nonatomic, copy)void(^didselectCourse)(HKLiveDetailModel *model);

// 查询更新缓存
@property (nonatomic, strong)HKLiveDetailModel *model;


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
//#import "HKLiveCourseListVC.h"
//#import "HKCourseModel.h"
//#import "HKLiveCourseCategoryCell.h"
//#import "DetailModel.h"
//#import "VideoPlayVC.h"
//#import "HKDownloadManager.h"
//#import "HKDownloadModel.h"
//#import "HKLiveListModel.h"
//#import "HKLiveDetailModel.h"
//#import "HKLiveCourseNewCategoryCell.h"
//
//
//@interface HKLiveCourseListVC ()<YUFoldingTableViewDelegate, HKDownloadManagerDelegate>
//
//@property (nonatomic, weak) YUFoldingTableView *foldingTableView;
//
//@property (nonatomic, strong)NSArray<HKLiveCategoryModel *> *dataSource;
//
//@property (nonatomic, strong)DetailModel *videlDetailModel;
//@end
//
//@implementation HKLiveCourseListVC
//
//
//- (YUFoldingTableView *)foldingTableView {
//    if (_foldingTableView == nil) {
//        //CGFloat height = SCREEN_HEIGHT*2/3-44;
//        CGFloat height = SCREEN_HEIGHT - SCREEN_WIDTH*9/16 -44 - (IS_IPHONE_X ?60 :0);
//        BOOL isBuy = [self.videlDetailModel.course_data.is_buy isEqualToString:@"0"]; // 1-已购买课程 0-未购买课程
//        if ([self.videlDetailModel.video_type integerValue] == HKVideoType_PGC && isBuy) {
//            //height = SCREEN_HEIGHT*2/3-44-55;
//        }
//        YUFoldingTableView *foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
//        _foldingTableView = foldingTableView;
//        foldingTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
//        foldingTableView.backgroundColor = COLOR_FFFFFF_3D4752;
//        foldingTableView.separatorColor = COLOR_FFFFFF_3D4752;
//        [self.view addSubview:foldingTableView];
//    }
//    return _foldingTableView;
//}
//
//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  videoId:(NSString*)videoId  detailModel:(DetailModel*)model {
//
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.videlDetailModel = model;
//    }
//    return self;
//}
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [MobClick event:UM_RECORD_DETAIL_LIST_TAB];
//    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
//    [self setupFoldingTableView];
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
//    [self.foldingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKLiveCourseCategoryCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKLiveCourseCategoryCell class])];
//
//    self.foldingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//}
//
//
//#pragma mark <UITableViewDatasource>
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
//    return self.dataSource.count;
//}
//
//- (NSInteger )yuFoldingTableView:(YUFoldingTableView *)yuTableView numberOfRowsInSection:(NSInteger )section
//{
//    return self.dataSource[section].child.count;
//}
//
//- (UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    HKLiveCourseCategoryCell* cell = [yuTableView  dequeueReusableCellWithIdentifier:NSStringFromClass([HKLiveCourseCategoryCell class])];
//    cell.model = self.dataSource[indexPath.section].child[indexPath.row];
//    return cell;
//}
//
//- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForHeaderInSection:(NSInteger )section
//{
//    // 软件入门
//    return 50;
//}
//- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 80;
//}
//- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger)section
//{
//    return self.dataSource[section].title;
//}
//
//- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    HKLiveDetailModel *model = self.dataSource[indexPath.section].child[indexPath.row];
//
//    // 当前选中的无法点击
//    if ([model.ID isEqualToString:self.model.live.ID]) return;
//
//    !self.didselectCourse? : self.didselectCourse(model);
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
//    return COLOR_27323F_EFEFF6;
//}
//
//- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView backgroundColorForHeaderInSection:(NSInteger )section {
//    return  COLOR_FFFFFF_3D4752;
//}
//
//- (void)setModel:(HKLiveDetailModel *)model {
//    _model = model;
//    self.foldingTableView.scrollViewDelegateTempValidate = NO;
//    self.dataSource = model.series_courses;
//    // 刷新和空处理
//    [self.foldingTableView reloadData];
//    self.foldingTableView.scrollViewDelegateTempValidate = YES;
//}
//
//
//
//@end
//
