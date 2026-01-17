//
//  HKSoftwareVC.h
//  Code
// 
//  Created by Ivan li on 2018/3/31.
//  Copyright © 2018年 pg. All rights reserved.
//


#import "WMStickyPageControllerTool.h"

@interface HKSoftwareVC : WMStickyPageControllerTool

@property(nonatomic,copy)NSString *tagId;

@property(nonatomic,copy)NSString *classify_name;

@end


//
//
////
////  HKSoftwareVC.m
////  Code
////
////  Created by Ivan li on 2018/3/31.
////  Copyright © 2018年 pg. All rights reserved.
////
//
//#import "HKSoftwareVC.h"
//#import "HKSearchCourseVC.h"
//#import "HKSoftwareLearnCell.h"
//#import "HKSoftwareVipCell.h"
//#import "HKSoftwareNewOnlineVC.h"
//#import "HKSoftwareGrayView.h"
//#import "UIBarButtonItem+Extension.h"
//#import "HKVIPCategoryVC.h"
//#import "VideoPlayVC.h"
//#import "WMPageController+Category.h"
//#import "NSString+MD5.h"
//#import "HKBookModel.h"
//#import "HKScrollTextCell.h"
//
//
//@interface HKSoftwareVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
//
//@property (strong,nonatomic)UICollectionView *contentCollectionView;
//
//@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;
///** 热门 */
//@property (nonatomic,strong)NSMutableArray *hotArr;
///** 最新 */
//@property (nonatomic,strong)NSMutableArray *newestArr;
///** 最近已学 */
//@property (nonatomic,strong)NSMutableArray *studyArr;
///** YES - 显示VIP cell  NO - 不显示 */
//@property (nonatomic,assign)BOOL isShowOpenVipCell;
//
//@property (nonatomic,assign)NSInteger sections;
//
//@property (nonatomic,assign)BOOL isFisrt;
//
//@property (nonatomic,strong) UIButton *retryBtn;
//
//@property (nonatomic,strong)NSMutableArray <HKTagModel*>*tagArr;
//
//@property (nonatomic,strong)HKSoftwareTitleView *softwareTitleView;
//
//@property (nonatomic,strong)UIView *titleBgView;
//
//@property (nonatomic,weak)HKSoftwareNewOnlineVC  *onlineVC;
///// vip 描述
//@property (nonatomic,copy)NSString *vipDesc;
//
//@end
//
//
//@implementation HKSoftwareVC
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self createUI];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)dealloc {
//    HK_NOTIFICATION_REMOVE();
//}
//
//
//- (void)createUI {
//    self.title = @"软件入门";
//    [self setLeftBarButtonItem];
//    self.view.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_EFEFF6 dark:COLOR_333D48];
//    
//    [self getSoftwareList];
//    [self refreshUI];
//    // 成功登录
//    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, userloginSuccessNotification);
//    // 退出
//    HK_NOTIFICATION_ADD(HKLogoutSuccessNotification, userlogoutSuccessNotification);
//    self.hk_hideNavBarShadowImage = YES;
//}
//
//- (void)userloginSuccessNotification {
//    [self getSoftwareList];
//}
//
//
//- (void)userlogoutSuccessNotification {
//    [self getSoftwareList];
//}
//
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar lt_reset];
//    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
//}
//
//
//- (NSMutableArray <HKTagModel*>*)tagArr {
//    if (!_tagArr) {
//        _tagArr = [NSMutableArray array];
//    }
//    return _tagArr;
//}
//
//
//
///*************************  UICollectionView **************************/
//
//- (UICollectionView*)contentCollectionView {
//    if (!_contentCollectionView) {
//        
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.minimumLineSpacing = 0;
//        layout.minimumInteritemSpacing =0;
//        
//        _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
//        _contentCollectionView.frame = CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, kWMHeaderViewHeight);
//        _contentCollectionView.backgroundColor = [UIColor whiteColor];
//        _contentCollectionView.delegate = self;
//        _contentCollectionView.dataSource = self;
//        
//        [_contentCollectionView registerClass:[HKSoftwareVipCell class] forCellWithReuseIdentifier:NSStringFromClass([HKSoftwareVipCell class])];
//        [_contentCollectionView registerClass:[HKSoftwareLearnCell class] forCellWithReuseIdentifier:NSStringFromClass([HKSoftwareLearnCell class])];
//        
//        [_contentCollectionView registerClass:[HKScrollTextCell class] forCellWithReuseIdentifier:NSStringFromClass([HKScrollTextCell class])];
//        
//        [_contentCollectionView registerClass:[HKSoftwareGrayView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([HKSoftwareGrayView class])];
//        
//        // 兼容iOS11
//        HKAdjustsScrollViewInsetNever(self, _contentCollectionView);
//        _contentCollectionView.backgroundColor = COLOR_FFFFFF_3D4752;
//    }
//    return _contentCollectionView;
//}
//
//
//
//- (NSInteger)numberOfSections {
//    NSInteger count = 0;
//    if (self.isShowOpenVipCell) {
//        count++;
//    }
//    if (self.studyArr.count) {
//        count++;
//    }
//    
//    if (DEBUG) {
//        self.sections = count+1;
//    }else{
//        self.sections = count;
//    }
//    return count;
//}
//
//
//#pragma mark <UICollectionViewDelegate>
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return [self numberOfSections];
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    
//    NSInteger count = 0;
//    switch (section) {
//        case 0:
//            count = 1;
//        break;
//            
//        case 1:
//            count = 1;
//        break;
//        
//        case 2:
//            count = 1;
//        break;
//            
//        default:
//            break;
//    }
//    return count;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    WeakSelf;
//    NSInteger section = indexPath.section;
//    if (0 == section && self.isShowOpenVipCell) {
//        HKSoftwareVipCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSoftwareVipCell class]) forIndexPath:indexPath];
//        cell.openVipBlock = ^(NSString *vipType) {
//            
//            [MobClick event:UM_RECORD_VIP_RUANJIANRUMEN_HOME_BUY];
//            if (isLogin()) {
//                // VIP 购买页
//                HKVIPCategoryVC *VC = [HKVIPCategoryVC new];
//                VC.class_type = @"2";
//                VC.hidesBottomBarWhenPushed = YES;
//                [weakSelf.navigationController pushViewController:VC animated:YES];
//            }else{
//                [weakSelf setLoginVC];
//            }
//        };
//        [cell setVipDesc:self.vipDesc];
//        return cell;
//    }else{
//        HKSoftwareLearnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSoftwareLearnCell class]) forIndexPath:indexPath];
//        
//        cell.videoSelectedBlock = ^(NSIndexPath *indexPath, VideoModel *videoNodel) {
//            
//            [MobClick event:UM_RECORD_VIP_RUANJIANRUMEN_HOME_RECENT];
//            VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
//                                                        videoName:videoNodel.name
//                                                 placeholderImage:nil
//                                                       lookStatus:LookStatusInternetVideo
//                                                          videoId:videoNodel.video_id model:nil];
//            VC.hidesBottomBarWhenPushed = YES;
//            [weakSelf.navigationController pushViewController:VC animated:YES];
//        };
//        
//        VideoModel *model = [VideoModel new];
//        model.cover = @"https://pic.huke88.com/lesson/cover/2017-09-29/8EF4C12E-159E-FE51-ADAF-3123623F7383.jpg";
//        model.summary = @"顶尖级VIP";
//        model.title = @"顶尖级VIP课程";
//        model.video_id = @"3931";
//        //@[model,model,model,model,model,model,model];
//        
//        cell.seriesArr = self.studyArr;
//        return cell;
//    }
//}
//
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSInteger section = indexPath.section;
//    if (0 == section && self.isShowOpenVipCell) {
//        if (isLogin()) {
//            // VIP 购买页
//            HKVIPCategoryVC *VC = [HKVIPCategoryVC new];
//            VC.class_type = @"2";
//            VC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:VC animated:YES];
//        }else{
//            [self setLoginVC];
//        }
//    }
//}
//
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return  CGSizeMake(SCREEN_WIDTH, (indexPath.section == 0 && self.isShowOpenVipCell) ?100 :140);
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeZero;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    
//    NSInteger count = self.sections;
//    if (1 == count) {
//        return  CGSizeMake(SCREEN_WIDTH, 12);
//    }else if (2 == count) {
//        if (1 == section) {
//            return  CGSizeMake(SCREEN_WIDTH, 12);
//        }
//    }
//    
//    CGSize size = CGSizeZero;
//    switch (section) {
//        case 0:
//            size = CGSizeMake(SCREEN_WIDTH, 12);
//        break;
//            
//        case 1:
//            return  CGSizeMake(SCREEN_WIDTH, 12);
//        break;
//        
//        case 2:
//            count = 1;
//        break;
//            
//        default:
//            break;
//    }
//    
//    return CGSizeZero;
//}
//
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    
//    NSInteger count = self.sections;
//    if (1 == count) {
//        if (kind == UICollectionElementKindSectionFooter){
//            HKSoftwareGrayView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([HKSoftwareGrayView class]) forIndexPath:indexPath];
//            return view;
//        }
//    }else if (2 == count) {
//        if (kind == UICollectionElementKindSectionFooter && indexPath.section == 1){
//            HKSoftwareGrayView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([HKSoftwareGrayView class]) forIndexPath:indexPath];
//            return view;
//        }
//    }
//    return [UICollectionReusableView new];
//}
//
///*************************  UICollectionView **************************/
//
//
//
///*************************  UIViewController **************************/
//static CGFloat const kWMMenuViewHeight = 50.0;
//static CGFloat const kWMHeaderViewHeight = 252;
//
//
//- (void)prepareSetup {
//    
//    self.titles = @[@"热门排行"];
//    self.controllerType = WMStickyPageControllerType_ordinary;
//    self.itemsMargins = @[@0,@20,@20];
//    self.automaticallyCalculatesItemWidths = YES;
//    self.menuViewContentMargin = 15;
//    
//    self.menuViewStyle = WMMenuViewStyleDefault;
//    //self.menuViewHeight = kWMMenuViewHeight;
//    self.menuViewHeight = [self titleViewRect].size.height + 30;
//    
//    self.maximumHeaderViewHeight =kWMHeaderViewHeight+KNavBarHeight64;
//    
//    if (!self.isShowOpenVipCell) {
//        
//        self.maximumHeaderViewHeight -=  100;
//    }
//    if (0 == self.studyArr.count) {
//        
//        self.maximumHeaderViewHeight -= 140;
//    }
//    if (0 == self.studyArr.count && !self.isShowOpenVipCell) {
//        
//        self.maximumHeaderViewHeight -= 12;
//    }
//    
//    self.minimumHeaderViewHeight = KNavBarHeight64;
//    [self reloadData];
//}
//
//
//
//
//
//- (NSArray<UIViewController *> *)viewcontrollers {
//    // 设置VC
//    if (_viewcontrollers == nil) {
//        HKSoftwareNewOnlineVC *courseVC = [[HKSoftwareNewOnlineVC alloc]init];
//        courseVC.type = 0;
//        
//        __block HKTagModel *tagModel = [HKTagModel new];
//        if (isEmpty(self.tagId)) {
//            tagModel.tagId = self.tagId;
//        }else{
//            [self.tagArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(HKTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (obj.isSelect) {
//                    tagModel = obj;
//                    *stop = YES;
//                }
//            }];
//        }
//        courseVC.tagModel = tagModel;
//        self.onlineVC = courseVC;
//        
//        //HKSoftwareNewOnlineVC *courseVC1 = [[HKSoftwareNewOnlineVC alloc]init];
//        //courseVC1.type = 1;
//        //_viewcontrollers = @[courseVC,courseVC1];
//        _viewcontrollers = @[courseVC];
//    }
//    return _viewcontrollers;
//}
//
//
//
//#pragma mark - Datasource & Delegate
//- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
//    
//    return self.titles.count;
//}
//
//
//- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
//    return self.viewcontrollers[index];
//}
//
//- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
//    //pageController.menuView.backgroundColor = COLOR_FFFFFF_3D4752;
//    pageController.menuView.hiddenSeparatorLine = YES;
//    
//    if (NO == [pageController.menuView viewWithTag:1000]) {
//        [pageController.menuView addSubview:self.titleBgView];
//        [pageController.menuView addSubview:self.softwareTitleView];
//        
//        CGRect frame = [self titleViewRect];
//        self.titleBgView.frame = CGRectMake(0, 0, self.view.width, frame.size.height +30);
//        self.softwareTitleView.frame = frame;
//        self.softwareTitleView.titlesArr = self.tagArr;
//    }
//    if (_softwareTitleView) {
//        [_softwareTitleView resetBtnNormalUI];
//    }
//    return CGRectMake(0, self.maximumHeaderViewHeight+self.menuViewHeight-1, SCREEN_WIDTH, SCREEN_HEIGHT -self.menuViewHeight);
//}
//
//
//- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
//    
//    return self.titles[index];
//}
//
//
///*************************  UIViewController **************************/
//
//
//#pragma mark - 刷新
//- (void)refreshUI {
//    
//    WeakSelf;
//    [HKRefreshTools headerRefreshWithTableView:self.contentCollectionView completion:^{
//        StrongSelf;
//        [strongSelf getSoftwareList];
//    }];
//    
//}
//
//- (void)tableHeaderEndRefreshing {
//    [_contentCollectionView.mj_header endRefreshing];
//}
//
//- (void)tableFooterEndRefreshing {
//    [_contentCollectionView.mj_footer endRefreshingWithNoMoreData];
//}
//
//- (void)tableFooterStopRefreshing {
//    [_contentCollectionView.mj_footer endRefreshing];
//}
//
//
//
//#pragma mark - 分类列表
//- (void)getSoftwareList{
//    
//    // 解决无网络第一次的空视图问题
//    [self.contentCollectionView reloadData];
//    
//    [HKHttpTool POST:VIDEO_SOFTWARE_HEADER_INFO parameters:nil success:^(id responseObject) {
//        
//        [self tableHeaderEndRefreshing];
//        if (HKReponseOK) {
//            NSMutableArray *studyArr = [VideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"userPlan"]];
//            self.isShowOpenVipCell = [[NSString stringWithFormat:@"%@", responseObject[@"data"][@"is_vip"]] isEqualToString:@"1"] ? NO: YES;
//            self.studyArr = studyArr;
//            
//            self.tagArr = [HKTagModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"classList"]];
//            if (self.tagArr.count) {
//                
//                __block BOOL isFind = NO;
//                [self.tagArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(HKTagModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if ([obj.tagId isEqualToString:self.tagId]) {
//                        obj.isSelect = YES;
//                        isFind = YES;
//                        *stop = YES;
//                    }
//                }];
//                if (NO == isFind) {
//                    // 将全部标记为选中
//                    self.tagArr[0].isSelect = YES;
//                }
//            }
//            self.vipDesc = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"desc"]];
//        }
//        
//        if (!self.isFisrt) {
//            [self.view addSubview:self.contentCollectionView];
//            self.isFisrt = YES;
//        }
//        [self.contentCollectionView reloadData];
//        [self prepareSetup];
//        
//        if (self.studyArr.count<1) {
//            [self showOrHiddenRetryBtn:NO];
//        }
//    } failure:^(NSError *error) {
//        
//        [self tableHeaderEndRefreshing];
//        if (self.studyArr.count<1) {
//            [self.contentCollectionView reloadData];
//            [self showOrHiddenRetryBtn:YES];
//        }
//    }];
//}
//
//
//
//
//- (void)showOrHiddenRetryBtn:(BOOL)showOrHidden {
//    self.retryBtn.hidden = !showOrHidden;
//}
//
//
//
//- (UIButton*)retryBtn {
//    if (!_retryBtn) {
//        _retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _retryBtn.titleLabel.font = HK_FONT_SYSTEM(16);
//        
//        [_retryBtn setTitle:@"重试" forState:UIControlStateNormal];
//        [_retryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_retryBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//        [_retryBtn addTarget:self action:@selector(retryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        // 设置背景
//        [_retryBtn setBackgroundImage:[UIImage imageNamed:@"general_btn_bg"] forState:UIControlStateNormal];
//        [_retryBtn sizeToFit];
//        _retryBtn.hidden = YES;
//        [self.view addSubview:_retryBtn];
//        _retryBtn.center = self.view.center;
//    }
//    return _retryBtn;
//}
//
//
//- (void)retryBtnClick:(UIButton*)btn {
//    [self getSoftwareList];
//}
//
//
//
//
//- (CGRect)titleViewRect {
//    
//    CGFloat currentX = 0;
//    CGFloat currentY = 0;
//    CGFloat countRow = 0;
//    CGFloat countCol = 0;
//    
//    CGFloat margin_X = 6;
//    CGFloat margin_Y = 8;
//    
//    NSInteger count = self.tagArr.count;
//        
//    CGFloat title_W = 80;
//    CGFloat title_H = 26;
//    
//    CGFloat content_W = self.view.width - 30;
//    CGFloat leftMagin = 15;
//    if (NO == IS_IPAD) {
//        //一行显示 4个
////        leftMagin = (self.view.width - 4*80 -3*margin_X)/2.0;
////        if (leftMagin <0) {
////            //一行显示 3个
////            leftMagin = (self.view.width - 3*80 -2*margin_X)/2.0;
////        }
//        //content_W = self.view.width - 2*(leftMagin>0 ?leftMagin :30);
//        
//        title_W = floor((content_W - 3*margin_X)/4.0);
//        if (title_W <80) {
//            //一行显示 3个
//            title_W = floor((content_W - 2*margin_X)/3.0);
//        }
//    }
//    
//    
//    for (int i = 0; i < count; i++) {
//        if (currentX + title_W + margin_X * countRow > content_W) {
//            CGFloat x = 0;
//            CGFloat y = (currentY += title_H) + margin_Y * ++countCol;
//            currentX = title_W;
//            countRow = 1;
//        } else {
//            CGFloat x = (currentX += title_W) - title_W + margin_X * countRow;
//            CGFloat y = currentY + margin_Y * countCol;
//            countRow ++;
//        }
//    }
//    
//    CGFloat H = title_H*(countCol+1) + countCol*margin_Y;
//    
//    CGFloat W = content_W;
//    CGRect frame = CGRectMake(leftMagin, 16, W, H);
//    return frame;
//}
//
//
//- (HKSoftwareTitleView*)softwareTitleView {
//    
//    if (!_softwareTitleView) {
//        _softwareTitleView = [HKSoftwareTitleView new];
//        _softwareTitleView.tag = 1000;
//        WeakSelf;
//        _softwareTitleView.titleClickCallBack = ^(NSInteger index, HKTagModel *tagModel) {
//            [weakSelf.onlineVC loadNewDataWithModel:tagModel];
//            [MobClick event:um_ruanjianrumen_home_label];
//        };
//    }
//    return _softwareTitleView;
//}
//
//
//- (UIView*)titleBgView {
//    if (!_titleBgView) {
//        _titleBgView = [UIView new];
//        _titleBgView.backgroundColor = COLOR_FFFFFF_3D4752;
//    }
//    return _titleBgView;
//}
//
//@end
//
