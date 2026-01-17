//
//  HKTeacherCourseVC.m
//  Code
//
//  Created by Ivan li on 2018/3/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTeacherCourseVC.h"
#import "HKCollectionPGCVC.h"
#import "UIBarButtonItem+Extension.h"
#import "HKTeacherDetailHeaderView.h"
#import "UMpopView.h"
#import "HKUserModel.h"
#import "HKTeacherVIPCourseVC.h"
#import "HKTeacherPGCVC.h"
#import "HKTeacherNavBarView.h"
#import "XLPhotoBrowser.h"
#import "WMPageController+Category.h"
#import "HKArticleListVC.h"
#import "HKTeacherTagsModel.h"
#import "HKTeacherDouYinVC.h"
#import "HKTeacherLiveVC.h"


@interface HKTeacherCourseVC ()<UMpopViewDelegate,XLPhotoBrowserDatasource,HKTeacherDetailHeaderViewDelegate,UMpopViewDelegate>

@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;

@property (nonatomic, strong)HKUserModel *user;

@property (nonatomic, weak)HKTeacherDetailHeaderView *headerView;

@property (nonatomic, assign)int page;

@property (nonatomic, weak)HKTeacherNavBarView *teacherNavBarView;

@property (nonatomic, assign)CGPoint offsetPoint;

@property (nonatomic, assign)BOOL isAppear;
@property (nonatomic, weak)UIView *todayCountView;


@end

@implementation HKTeacherCourseVC

- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    
    if (@available(iOS 13.0, *)) {
        // 主题模式 发生改变
        if (self.titles.count) {
            [self prepareSetup];
        }
    }
}

- (void)setupHeader {
    
    // 设置头部个人资料
    HKTeacherDetailHeaderView *headerView = [HKTeacherDetailHeaderView viewFromXib];
    headerView.delegate = self;
    
    // 点击返回的block
    __weak typeof(self) weakSelf = self;
    headerView.backClickBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    // 分享
    headerView.shareClickBlock = ^(HKUserModel *model){
        [MobClick event:UM_RECORD_TEACHERPAGE_SHARE];
        [weakSelf shareWithUI:model.share_data];
    };;
    
    // 展开更多
    headerView.moreClickBlock = ^(HKUserModel *model) {
        weakSelf.headerView.user = model;
    };
    
    // 关注按钮点击
    headerView.followBtnClickBlock = ^{
        [MobClick event:UM_RECORD_TEACHERPAGE_FOLLOW];
        [weakSelf followTeacherToServer];
    };
    
    [headerView setHeightBlock:^(CGFloat height) {
        //weakSelf.headerViewHeight = height;
        int a = (int)height; // 修复plus不能下拉的bug
        weakSelf.maximumHeaderViewHeight = a;
        [weakSelf.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(a);
        }];
        [weakSelf forceLayoutSubviews];
    }];
    
    self.headerView = headerView;
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(kWMHeaderViewHeight);
    }];
    headerView.user = self.user;
}


#pragma mark headerView 代理
- (void)teacherHeadImageClick:(id)sender {
    [self setPhotoBrowser];
}




/** 友盟分享 */
- (void)shareWithUI:(ShareModel*)model {
    
    UMpopView *popView = [UMpopView sharedInstance];
    [popView createUIWithModel:model];
    popView.delegate = self;
}



#pragma mark - UMpopView 代理
- (void)uMShareWebSucess:(id)sender {
    if ([sender isKindOfClass:[ShareModel class]]) {
        ShareModel *model = (ShareModel*)sender;
        [self shareSucessWithModel:model];
    }
}


#pragma mark - 分享网页成功 回调 后台
- (void)shareSucessWithModel:(ShareModel*)model {
    
    if (!isLogin()) {
        showTipDialog(Share_Sucess);
        return;
    }
    
    [HKCommonRequest shareDataSucess:model success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)uMShareImageSucess:(id)sender {
    
    if ([sender isKindOfClass:[ShareModel class]]) {
        ShareModel *model = (ShareModel*)sender;
        [self shareSucessWithModel:model];
    }
}

- (void)uMShareImageFail:(id)sender {
    
}



#pragma mark <Server>

- (void)getPersonInfo {
    
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    self.page = 1;
    
    [mange teacherHomeWithToken:nil teacherId:self.teacher_id page:[NSString stringWithFormat:@"%d", self.page]
                     completion:^(FWServiceResponse *response) {
                         
                         if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
                             
                             HKUserModel *user = [HKUserModel mj_objectWithKeyValues:response.data];
                             
                             
                             self.user = user;
                             
                             // 教师教程
                             NSArray *tags = [HKTeacherTagsModel mj_objectArrayWithKeyValuesArray:response.data[@"tags"]];
                             self.user.teacherTags = tags;
                             
                             [self prepareSetup];
                             [self setupHeader];
                             self.headerView.user = self.user;
                             
                             int newVideoCount = [response.data[@"new_video_count"] intValue];
                             //if (newVideoCount.length && ![newVideoCount isEqualToString:@"0"]) {
                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                     [self videoCountTip:newVideoCount];
                                 });
                             //}
                             
                         }
                         
                     } failBlock:^(NSError *error) {
                         
                     }];
}

- (void)followTeacherToServer{
    
    WeakSelf;
    if (!isLogin()) {
        [weakSelf setLoginVC];
        return;
    }
    
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    [mange followTeacherVideoWithToken:nil teacherId:self.user.teacher_id type:((self.user.is_follow)? @"1":@"0")completion:^(FWServiceResponse *response) {
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
            // 反向取值
            self.user.is_follow = !self.user.is_follow;
            //粉丝 数量
            int count = [self.user.follow intValue];
            if (count>0) {
                //关注成功 +1
                self.user.follow = [NSString stringWithFormat:@"%d",count + (self.user.is_follow? 1 : -1)];
            }
            // 更新数据
            self.headerView.user = self.user;
            showTipDialog(self.user.is_follow? @"关注成功" : @"取消关注");
            
            // 执行block
            !self.followBlock? : self.followBlock(self.user.is_follow, self.user.teacher_id);
        }
    } failBlock:^(NSError *error) {
        
    }];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isAppear = YES;
    [self setupTeacherNavbar:self.offsetPoint];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isAppear = NO;
    
    if (self.teacherNavBarView) {
        [self.teacherNavBarView removeFromSuperview];
        self.teacherNavBarView = nil;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLeftBarButton];
    [self getPersonInfo];
    // KVO
    [self.view addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    self.zf_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
}

- (void)createLeftBarButton {
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"nac_back_black"
                                                                          highBackgroudImageName:@"nac_back_black"
                                                                                          target:self
                                                                                          action:@selector(backAction)];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






/**
 *  浏览图片
 */
- (void)setPhotoBrowser {
    // 创建图片浏览器
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:1 imageCount:1 datasource:self];
    // 自定义一些属性
    browser.pageDotColor = [UIColor purpleColor]; ///< 此属性针对动画样式的pagecontrol无效
    browser.currentPageDotColor = [UIColor greenColor];
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleAnimated;///< 修改底部pagecontrol的样式为系统样式,默认是弹性动画的样式
}

#pragma mark  XLPhotoBrowserDatasource
/**
 *  返回这个位置的占位图片
 *  @return 占位图片
 */
- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return imageName(HK_Placeholder);
}
/**
 *  返回指定位置图片的UIImageView,用于做图片浏览器弹出放大和消失回缩动画等
 *  如果没有实现这个方法,没有回缩动画,如果传过来的view不正确,可能会影响回缩动画效果
 *
 */
- (UIView *)photoBrowser:(XLPhotoBrowser *)browser sourceImageViewForIndex:(NSInteger)index {
    return self.headerView.headerIV;
}

/**
 *  返回指定位置的高清图片URL
 *
 */
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    NSString *picUrl = isEmpty(self.user.big_avator) ?self.user.avator :self.user.big_avator;
    return [NSURL URLWithString:picUrl];
}




static CGFloat const kWMMenuViewHeight = 44.0;
static CGFloat const kWMHeaderViewHeight = 276;



- (void)prepareSetup {
    
    self.controllerType = WMStickyPageControllerType_ordinary;
    self.automaticallyCalculatesItemWidths = YES;
    self.menuViewContentMargin = 0;
    
    NSMutableArray *titleArray = [NSMutableArray array];
    NSMutableArray *vcArray = [NSMutableArray array];
    
    NSMutableArray *itemsArray = [NSMutableArray array];
    [itemsArray addObject:@15];
    
    // 设置VC
    for (int i = 0; i < self.user.teacherTags.count; i++) {
        HKTeacherTagsModel *tag = self.user.teacherTags[i];
        
        if ([tag.type isEqualToString:@"0"]) {
            HKTeacherVIPCourseVC *VIPVC = [[HKTeacherVIPCourseVC alloc] init];
            VIPVC.teacher = self.user;
            [titleArray addObject:@"会员教程"];
            [vcArray addObject:VIPVC];
            [itemsArray addObject:@20];
        }
        
        if ([tag.type isEqualToString:@"1"]) {
            HKTeacherPGCVC *PGCVC = [[HKTeacherPGCVC alloc] init];
            PGCVC.teacher = self.user;
            [titleArray addObject:@"名师机构"];
            [vcArray addObject:PGCVC];
            [itemsArray addObject:@20];
        }
        
        if ([tag.type isEqualToString:@"2"]) {
            HKArticleListVC *articleListVC = [[HKArticleListVC alloc] init];
            articleListVC.isTeacherVC = YES;
            articleListVC.teacher = self.user;
            [titleArray addObject:@"文章"];
            [vcArray addObject:articleListVC];
            [itemsArray addObject:@20];
        }
        
        if ([tag.type isEqualToString:@"3"]) {
            HKTeacherDouYinVC *teacherDouYinVC = [[HKTeacherDouYinVC alloc] init];
            teacherDouYinVC.teacher = self.user;
            [titleArray addObject:@"短视频"];
            [vcArray addObject:teacherDouYinVC];
            [itemsArray addObject:@20];
        }
        
        if ([tag.type isEqualToString:@"4"]) {
            HKTeacherLiveVC *teacherLiveVC = [[HKTeacherLiveVC alloc] init];
            teacherLiveVC.teacher = self.user;
            [titleArray addObject:@"直播"];
            [vcArray addObject:teacherLiveVC];
            [itemsArray addObject:@20];
        }
    }
    
    self.itemsMargins = itemsArray;
    self.titles = titleArray;
    self.viewcontrollers = vcArray;
    
    self.menuViewHeight = kWMMenuViewHeight;
    self.maximumHeaderViewHeight = kWMHeaderViewHeight;
    self.minimumHeaderViewHeight = KNavBarHeight64;
    
    [self reloadData];
}

//下窜更新提醒框
- (void)videoCountTip:(int)count {
    //count = @"10";
    [self setTodayView:count hide:NO];
    // 消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 2.0)), dispatch_get_main_queue(), ^{
        [self setTodayView:count hide:YES];
    });
}

- (void)setTodayView:(int)count hide:(BOOL)hide {
    
    if (!self.todayCountView) {
        UIView *todayCountView = [[UIView alloc] init];
        todayCountView.backgroundColor = [UIColor orangeColor];
        todayCountView.frame = CGRectMake(0, CGRectGetMaxY(self.menuView.frame) - 30, self.view.width, 30);
        self.todayCountView = todayCountView;
        UILabel *countLB = [[UILabel alloc] init];
        countLB.frame = todayCountView.bounds;
        countLB.font = [UIFont systemFontOfSize:14.0];
        countLB.textColor = HKColorFromHex(0x27323F, 1.0);
        countLB.tag = 520;
        countLB.textAlignment = NSTextAlignmentCenter;
        countLB.backgroundColor = HKColorFromHex(0xFDDB3C, 1.0);
        [todayCountView addSubview:countLB];
        [self.view insertSubview:todayCountView belowSubview:self.menuView];
    }
    
    UILabel *countLB = [self.todayCountView viewWithTag:520];
    countLB.text = [NSString stringWithFormat:@"有%d个视频更新", count];
    
    // 显示
    if (!hide && count > 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.todayCountView.y = CGRectGetMaxY(self.menuView.frame);;
        }];
        
    } else {// 隐藏
        [UIView animateWithDuration:0.3 animations:^{
            self.todayCountView.y = CGRectGetMaxY(self.menuView.frame) - 30;
        }];
    }

}





// 监听这个方法回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    // 在这个方法里面监听属性变化
    if ([keyPath isEqualToString:@"contentOffset"] && object == self.view) {
        //if ([keyPath isEqualToString:@"contentOffset"] && object == self.basicScrollView) {
        CGPoint newPoint;
        id newValue = [change valueForKey:NSKeyValueChangeNewKey ];
        [(NSValue*)newValue getValue:&newPoint ];
        self.offsetPoint = newPoint;
        // 显示或者隐藏顶部导航栏
        [self setupTeacherNavbar:newPoint];
    }
}

- (void)setupTeacherNavbar:(CGPoint)point {
    WeakSelf;
    
    // 即将消失不做操作
    if (!self.isAppear) return;
    
    if (point.y > 0 && self.teacherNavBarView == nil) {
        
        HKTeacherNavBarView *teacherNavBarView = [HKTeacherNavBarView viewFromXib];
        teacherNavBarView.user = self.user;
        [self.navigationController.view addSubview:teacherNavBarView];
        teacherNavBarView.backClickBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        teacherNavBarView.shareClickBlock = ^(HKUserModel *model){
            
            [MobClick event:UM_RECORD_TEACHERPAGE_SHARE];
            [weakSelf shareWithUI:model.share_data];
        };;
        self.teacherNavBarView = teacherNavBarView;
        [teacherNavBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self.navigationController.view);
            make.height.mas_equalTo(KNavBarHeight64);
        }];
    } else if (point.y <= 0 && self.teacherNavBarView != nil) {
        [self.teacherNavBarView removeFromSuperview];
        self.teacherNavBarView = nil;
    }
    
    if (point.y >= 110 && self.teacherNavBarView != nil) {
        self.teacherNavBarView.nameLB.hidden = NO;
        self.teacherNavBarView.nameLB.text = self.user.name;
    } else if (0 < point.y && point.y < 110 && self.teacherNavBarView != nil) {
        self.teacherNavBarView.nameLB.hidden = YES;
    }
}


- (void)dealloc{
    // 注销
    //    if ([self.basicScrollView observationInfo]) {
    //        [self.basicScrollView removeObserver:self forKeyPath:@"contentOffset"];
    //    }
    if ([self.view observationInfo]) {
        [self.view removeObserver:self forKeyPath:@"contentOffset"];
    }
    
    !self.userVCDeallocBlock? : self.userVCDeallocBlock();
}



#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.viewcontrollers[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return self.titles[index];
}

@end





