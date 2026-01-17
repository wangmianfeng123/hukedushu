//
//  HKUserInfoVC.m
//  Code
//
//  Created by Ivan li on 2018/5/16.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKUserInfoVC.h"
#import "HKCollectionPGCVC.h"
#import "UIBarButtonItem+Extension.h"
#import "HKUserDetailHeaderView.h"
#import "UMpopView.h"
#import "HKUserModel.h"
#import "HKTeacherVIPCourseVC.h"
#import "HKTeacherPGCVC.h"
#import "HKTeacherNavBarView.h"
#import "HKUserInfoSettingVC.h"
#import "XLPhotoBrowser.h"
#import "HKUserLearnedVC.h"
#import "HKTeacherDouYinVC.h"
#import "HKUserTaskVC.h"
#import "WMPageController+Category.h"


@interface HKUserInfoVC ()<UMpopViewDelegate,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource,HKUserDetailHeaderViewDelegate>

@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;

@property (nonatomic, strong)HKUserModel *user;

@property (nonatomic, weak)HKUserDetailHeaderView *headerView;

@property (nonatomic, assign)int page;

@property (nonatomic, weak)HKTeacherNavBarView *userNavBarView;

@property (nonatomic, assign)CGPoint offsetPoint;

@property (nonatomic, assign)BOOL isAppear;

@property (nonatomic, weak)UIScrollView *subview;

@property (nonatomic, strong)NSMutableDictionary *twoAccessDic; // 用于记录2次接口访问
@property (nonatomic , assign)BOOL is_set_privacy;

@end

@implementation HKUserInfoVC

- (NSMutableDictionary *)twoAccessDic {
    if (!_twoAccessDic) {
        _twoAccessDic = [NSMutableDictionary dictionary];
    }
    return _twoAccessDic;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isAppear = YES;
    [self setupTeacherNavbar:self.offsetPoint];    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isAppear = NO;
    if (self.userNavBarView) {
        [self.userNavBarView removeFromSuperview];
        self.userNavBarView = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLeftBarButton];
    [self getPersonInfo];
    [self isShowShortVideo];
    
    //用户信息改变通知
    HK_NOTIFICATION_ADD(HKUserInfoChangeNotification, userInfoChangeNotification);
    // KVO
    [self.view addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    self.zf_prefersNavigationBarHidden = YES;
    
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
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



- (void)userInfoChangeNotification {
    
    HKUserModel *model = [HKAccountTool shareAccount];
    if (model) {
        if ([self.headerView.user.ID isEqualToString:model.ID]&& !isEmpty(model.ID)) {
            self.headerView.user = model;
        }
    }
}


- (void)setupHeader {
    
    // 设置头部个人资料
    HKUserDetailHeaderView *headerView = [HKUserDetailHeaderView viewFromXib];
    headerView.delegate = self;
    
    // 点击返回的block
    __weak typeof(self) weakSelf = self;
    headerView.backClickBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    // 分享
    headerView.editInfoClickBlock = ^(HKUserModel *model){
        
        if (isLogin()) {
            HKUserInfoSettingVC *VC = [HKUserInfoSettingVC new];
            VC.userModel = [HKAccountTool shareAccount];
            VC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:VC animated:YES];
        }else{
            [weakSelf setLoginVC];
        }
    };;
    self.headerView = headerView;
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(kWMHeaderViewHeight);
    }];
    
    headerView.user = self.user;
}


- (void)headImageClick:(id)sender {
    [self setPhotoBrowser];
}


/**
 *  浏览图片
 */
- (void)setPhotoBrowser {
    // 创建图片浏览器
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:1 imageCount:1 datasource:self];
    // 自定义一些属性
    browser.pageDotColor = [UIColor grayColor];
    browser.currentPageDotColor = [UIColor whiteColor];
    //< 修改底部pagecontrol的样式为系统样式,默认是弹性动画的样式
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleAnimated;
    // 设置长按手势弹出的地步ActionSheet数据,不实现此方法则没有长按手势
    [browser setActionSheetWithTitle:nil delegate:self cancelButtonTitle:nil deleteButtonTitle:nil otherButtonTitles:@"保存图片",nil];
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
    NSString *picUrl = isEmpty(self.headerView.user.big_avator) ?self.headerView.user.avator :self.headerView.user.big_avator;
    return [NSURL URLWithString:picUrl];
}


- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex {
    switch (actionSheetindex) {
        case 0:
        {
            // 保存图片
            NSLog(@"点击了actionSheet索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);
            [browser saveCurrentShowImage];
        }
            break;
        default:{
            NSLog(@"点击了actionSheet索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);
        }
            break;
    }
}




#pragma mark <Server>

- (void)getPersonInfo {
    
    self.page = 1;
    
    //type *1-已学课程 2-收藏课程
    NSString *page = [NSString stringWithFormat:@"%d", self.page];
    NSDictionary *dict = @{@"page":page,@"uid":self.userId ,@"type":@"1"};
    
    //vip_type：3-终身全站通 2-全站通VIP 1-分类VIP 0-非VIP；is_self：1-自己 2-别人
    [HKHttpTool POST:USER_HOME baseUrl:BaseUrl parameters:dict success:^(id responseObject) {
        
        if (HKReponseOK) {
            HKUserModel *user = [HKUserModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.is_set_privacy = [responseObject[@"data"][@"is_set_privacy"] boolValue];
            
            //苦于后台不传userid 没得办法
            user.ID = self.userId;
            self.user = user;
            
            self.twoAccessDic[@"has_task"] = [NSString stringWithFormat:@"%d", self.user.has_task];
            
            // 是否显示短视频接口已经访问完毕
            if ([self.twoAccessDic objectForKey:@"status"]) {
                [self prepareSetup];
            }
            
            [self setupHeader];
            
            // 如果是自己 （存储课程数量 虎课币）
            if ([user.is_self isEqualToString:@"1"]) {
                [HKAccountTool shareAccount].gold = user.gold;
                [HKAccountTool shareAccount].count = user.count;
                [HKAccountTool saveOrUpdateAccount:[HKAccountTool shareAccount]];
            }
            self.headerView.user = self.user;
        }
    } failure:^(NSError *error) {
        
    }];
}


/**
 是否显示短视频
 */
- (void)isShowShortVideo {
    
    [HKHttpTool POST:@"/short-video/short-video-status" parameters:nil success:^(id responseObject) {
        
        if (HKReponseOK) {
            NSString *status = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"status"]];
            self.twoAccessDic[@"status"] = status;
            
            // 个人中心接口已经访问完毕
            if ([self.twoAccessDic objectForKey:@"has_task"]) {
                [self prepareSetup];
            }
        }
    } failure:^(NSError *error) {
        
        
        
    }];
}





static CGFloat const kWMMenuViewHeight = 44.0;
static CGFloat const kWMHeaderViewHeight = 518/2;


- (void)prepareSetup {
    
    self.controllerType = WMStickyPageControllerType_ordinary;
    self.automaticallyCalculatesItemWidths = YES;
    self.menuViewContentMargin = 0;//15;
    // 设置VC
    HKUserLearnedVC *learnVC = [HKUserLearnedVC new];
    learnVC.userModel = self.user;
    learnVC.type = @"1";
    
    HKUserLearnedVC *collectVC = [HKUserLearnedVC new];
    collectVC.userModel = self.user;
    collectVC.type = @"2";
    
    HKUserTaskVC *taskVC = [HKUserTaskVC new];
    taskVC.userModel = self.user;
    
    HKTeacherDouYinVC *douyinVC = [HKTeacherDouYinVC new];
    douyinVC.user = self.user;
    
    BOOL shortVideo = self.twoAccessDic[@"status"] && [self.twoAccessDic[@"status"] isEqualToString:@"1"];
    
    if (self.user.has_task && shortVideo) {
        self.titles = @[@"作品", @"已学教程", @"收藏教程", @"点赞短视频"];
        self.viewcontrollers = @[taskVC, learnVC, collectVC, douyinVC];
        self.itemsMargins = @[@15, @20, @20, @20, @20];
    } else if (self.user.has_task) {
        self.titles = @[@"作品", @"已学教程", @"收藏教程"];
        self.viewcontrollers = @[taskVC, learnVC, collectVC];
        self.itemsMargins = @[@15, @20, @20, @20];
    } else if (shortVideo) {
        self.titles = @[@"已学教程", @"收藏教程",  @"点赞短视频"];
        self.viewcontrollers = @[learnVC, collectVC, douyinVC];
        self.itemsMargins = @[@15, @20, @20, @20];
    } else {
        self.titles = @[@"已学教程",@"收藏教程"];
        self.viewcontrollers = @[learnVC, collectVC];
        self.itemsMargins = @[@15, @20, @20];
    }
    
    self.menuViewHeight = kWMMenuViewHeight;
    self.maximumHeaderViewHeight = kWMHeaderViewHeight;
    self.minimumHeaderViewHeight = KNavBarHeight64;
    
    [self reloadData];
}




- (BOOL)pageController:(WMStickyPageController *)pageController shouldScrollWithSubview:(UIScrollView *)subview {
    
    return YES;
}



// 监听这个方法回调2
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
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
    
    if (point.y > 0 && self.userNavBarView == nil) {
        
        HKTeacherNavBarView *userNavBarView = [HKTeacherNavBarView viewFromXib];
        userNavBarView.user = self.user;
        // 不是自己 隐藏编辑按钮
        userNavBarView.shareBtn.hidden = YES;//![self.user.is_self isEqualToString:@"1"];
        [userNavBarView.shareBtn setImage:imageName(@"edit_bg") forState:UIControlStateNormal];
        [self.navigationController.view addSubview:userNavBarView];
        userNavBarView.backClickBlock = ^{
            StrongSelf;
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
        userNavBarView.shareClickBlock = ^(HKUserModel *model) {
            StrongSelf;
            if (isLogin() && [model.is_self isEqualToString:@"1"]) {
                HKUserInfoSettingVC *VC = [HKUserInfoSettingVC new];
                VC.userModel = model;
                VC.hidesBottomBarWhenPushed = YES;
                [strongSelf.navigationController pushViewController:VC animated:YES];
            }else{
                [strongSelf setLoginVC];
            }
        };
        
        self.userNavBarView = userNavBarView;
        [userNavBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self.navigationController.view);
            make.height.mas_equalTo(KNavBarHeight64);
        }];
    } else if (point.y <= 0 && self.userNavBarView != nil) {
        [self.userNavBarView removeFromSuperview];
        self.userNavBarView = nil;
    }
    
    if (point.y >= 110 && self.userNavBarView != nil) {
        self.userNavBarView.nameLB.hidden = NO;
        self.userNavBarView.nameLB.text = self.user.username;
    } else if (0 < point.y && point.y < 110 && self.userNavBarView != nil) {
        self.userNavBarView.nameLB.hidden = YES;
    }
}


- (void)dealloc {
    // 注销 (移除KVO)
    //    if ([self.basicScrollView observationInfo]) {
    //        [self.basicScrollView removeObserver:self forKeyPath:@"contentOffset"];
    //    }
    
    if ([self.view observationInfo]) {
        [self.view removeObserver:self forKeyPath:@"contentOffset"];
    }
    HK_NOTIFICATION_REMOVE();
    
    !self.userVCDeallocBlock? : self.userVCDeallocBlock();
}



#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    UIViewController *vc = self.viewcontrollers[index];
    
    // 抖音短视频统计
    if ([vc isKindOfClass:[HKTeacherDouYinVC class]]) {
        [MobClick event:MYHOMEPAGE_LIKESHORTVIDEO];
    }
    
    return vc;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}

@end




