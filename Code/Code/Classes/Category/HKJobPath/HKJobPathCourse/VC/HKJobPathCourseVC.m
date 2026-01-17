//
//  HKJobPathCourseVC.m
//  Code
//
//  Created by Ivan li on 2019/6/5.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKJobPathCourseVC.h"
#import "HKJobPathCourseHeadView.h"
#import "UIButton+ImageTitleSpace.h"
#import "HKJobPathCourseListVC.h"
#import "HKJobPathCourseCoustomLeftBarView.h"
#import "WMPageController+Category.h"
#import "UMpopView.h"
#import "HKJobPathModel.h"


CGFloat  KheaderViewHeight = 200;

@interface HKJobPathCourseVC () <UMpopViewDelegate,HKJobPathCourseListVCDelegate>

@property (nonatomic,strong) HKJobPathCourseHeadView *courseHeadView;

@property (nonatomic,weak) UIButton *leftBarButton;

@property (nonatomic,assign)BOOL isShowBottomView;

@property (nonatomic,assign)CGFloat tagsContentHeight;

@property (nonatomic,strong)ShareModel *shareModel;
@property (nonatomic , strong) HKJobPathHeadGuideModel * guideModel;
@end


@implementation HKJobPathCourseVC


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [self.navigationController.navigationBar lt_reset];
//    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
//}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}


- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.courseHeadView];
    
    [self setBarButtonItems];
    [self prepareSetup];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat headerViewHeight = KheaderViewHeight;
    CGFloat headerViewX = 0;
    UIScrollView *scrollView = (UIScrollView *)self.view;
    if (scrollView.contentOffset.y < 0) {
        headerViewX = scrollView.contentOffset.y;
        headerViewHeight -= headerViewX;
    }
    self.courseHeadView.y = headerViewX;
    //self.courseHeadView.frame = CGRectMake(0, headerViewX, CGRectGetWidth(self.view.bounds), headerViewHeight);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat Y = scrollView.contentOffset.y;
    
    CGFloat H = IS_IPHONE_X ? 50:(KNavBarHeight64 +30);
    
    if (self.tagsContentHeight) {
        if (Y >= H ) {
            [self showLeftBarViewTitle:YES];
            self.courseHeadView.goVipBtn.hidden = YES;
            CGFloat apla = ((KheaderViewHeight - Y)<=KNavBarHeight64+13) ?0 : H/Y ;
            [self.courseHeadView showContentBgView:YES alpha:apla];
            
        } else if (Y < H) {
            [self showLeftBarViewTitle:NO];
            self.courseHeadView.goVipBtn.hidden = self.guideModel.is_show ? NO :YES;
            [self.courseHeadView showContentBgView:NO alpha:1];
        }
    }
}



- (void)setBarButtonItems {
    WeakSelf;
    HKJobPathCourseCoustomLeftBarView *leftBarView = [[HKJobPathCourseCoustomLeftBarView alloc] init];
    leftBarView.titleLB.text = self.jobPathModel.title;
    
    leftBarView.titleLB.hidden = YES;
    leftBarView.backBtnClickCallBack = ^{
        [weakSelf backAction];
    };
//    if (@available(iOS 11.0, *)) {
//        leftBarView.translatesAutoresizingMaskIntoConstraints = NO;
//    }
    // 低于 ios 11 按钮无法点击
    leftBarView.translatesAutoresizingMaskIntoConstraints = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarView];
    
    [self setShareButtonItemWithImageName:@"share_white"];
}


- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)showLeftBarViewTitle:(BOOL)show {
    
    HKJobPathCourseCoustomLeftBarView *leftBarView = (HKJobPathCourseCoustomLeftBarView *)self.navigationItem.leftBarButtonItem.customView;
    if ([leftBarView isKindOfClass:[HKJobPathCourseCoustomLeftBarView class]]) {
        leftBarView.titleLB.hidden = !show;
    }
}


- (void)shareBtnItemAction {

    if (self.isShowBottomView) {
        [self shareWithUI:self.shareModel];
    }
}


- (void)setJobPathModel:(HKJobPathModel *)jobPathModel {
    _jobPathModel = jobPathModel;
    self.courseId = jobPathModel.career_id;
}



- (HKJobPathCourseHeadView*)courseHeadView {
    if (!_courseHeadView) {
        WeakSelf;
        _courseHeadView = [[HKJobPathCourseHeadView alloc]initWithFrame:self.view.bounds];
        _courseHeadView.heightChangeBlock = ^(CGFloat viewHeight, CGFloat tagsContentHeight) {
            KheaderViewHeight = viewHeight;
            weakSelf.maximumHeaderViewHeight = KheaderViewHeight;
            weakSelf.tagsContentHeight = tagsContentHeight;
            [weakSelf.view setNeedsLayout];
            [weakSelf.view layoutIfNeeded];
        };
        _courseHeadView.didVipBtnBlock = ^{
            if (weakSelf.guideModel) {
                //应用内跳转
                [HKH5PushToNative runtimePush:weakSelf.guideModel.redirect_package.className arr:weakSelf.guideModel.redirect_package.list currectVC:nil];
            }
        };
        _courseHeadView.jobPathModel = self.jobPathModel;
    }
    return _courseHeadView;
}




- (void)prepareSetup {
    
    self.controllerType = WMStickyPageControllerType_videoDetail;
    self.menuItemWidth = self.view.width;
    
    self.menuViewHeight = 0;//标题栏高度
    self.maximumHeaderViewHeight = KheaderViewHeight;
    self.minimumHeaderViewHeight = KNavBarHeight64+13;
    self.menuViewStyle = WMMenuViewStyleDefault;
}



#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 1;
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    HKJobPathCourseListVC *listVC =  [HKJobPathCourseListVC new];
    [listVC setJobCourseId:self.courseId];
    [listVC setSourceId:self.jobPathModel.source];
    listVC.delegate = self;
    return listVC;
}



- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    contentView.backgroundColor = [UIColor clearColor];
    return CGRectMake(0, KheaderViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
}


- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return nil;
}




#pragma mark --- HKJobPathCourseListVC
- (void)hkJobPathCourseListVC:(HKJobPathCourseListVC*)VC showBottomView:(BOOL)showBottomView {
    self.isShowBottomView = YES;
}


- (void)hkJobPathCourseListVC:(HKJobPathCourseListVC*)VC shareModel:(ShareModel*)shareModel {
    
    self.shareModel = shareModel;
}

-(void)hkJobPathCourseListVC:(HKJobPathCourseListVC *)VC headGuideModel:(HKJobPathHeadGuideModel *)guideModel{
    _guideModel = guideModel;
    self.courseHeadView.guideModel = guideModel;
}

/** 职业路径 i信息 */
- (void)hkJobPathCourseListVC:(HKJobPathCourseListVC*)VC jobModel:(HKJobPathModel*)jobModel {
    
    BOOL isEqual = [self.jobPathModel.career_id isEqualToString: jobModel.career_id];
    self.jobPathModel = jobModel;
    
    //if (NO == isEqual) {
    self.courseHeadView.jobPathModel = jobModel;
    //}
    
    HKJobPathCourseCoustomLeftBarView *leftBarView = (HKJobPathCourseCoustomLeftBarView *)self.navigationItem.leftBarButtonItem.customView;
    if ([leftBarView isKindOfClass:[HKJobPathCourseCoustomLeftBarView class]]) {
        leftBarView.titleLB.text = self.jobPathModel.title;
    }
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



@end







