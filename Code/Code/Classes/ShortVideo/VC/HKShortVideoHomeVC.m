//
//  HKShortVideoHomeVC.m
//  Code
//
//  Created by Ivan li on 2018/3/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKShortVideoHomeVC.h"
#import "HKShortVideoMainVC.h"
#import "HKShortVideoCategoryVC.h"
#import "VideoPlayVC.h"
#import "WMPageController+Category.h"


@interface HKShortVideoHomeVC ()

@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;

@property(nonatomic,weak)HKShortVideoMainVC *shortVideoMainVC;

@end


@implementation HKShortVideoHomeVC


- (instancetype)init{
    
    self = [super init];
    if (self) {
        [self prepareSetup];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setWhiteLeftBarButtonItem];
    [self setBlankRightBarButtonItem];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)prepareSetup {
    
    self.titles = @[@"推荐", @"分类"];
    self.automaticallyCalculatesItemWidths = YES;
    
    self.itemMargin = 20;
    self.menuViewContentMargin = 0;
    self.menuViewStyle = WMMenuViewStyleDefault;
    self.progressHeight = 0;
    self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
    
    self.titleSizeSelected = 17;
    self.titleSizeNormal = 17;
    self.titleColorSelected = COLOR_ffffff;
    self.titleColorNormal = COLOR_CBCDD8;
    self.preloadPolicy = WMPageControllerPreloadPolicyNeighbour;
    self.scrollEnable = NO;
    self.isAllItemBold = YES;
    self.showOnNavigationBar = YES;
}


- (NSArray<UIViewController *> *)viewcontrollers {

    if (_viewcontrollers == nil) {
        
        @weakify(self);
        HKShortVideoMainVC *shortVideoMainVC = [[HKShortVideoMainVC alloc]init];
        shortVideoMainVC.shortVideoTagClickCallBack = ^(HKShortVideoModel * _Nonnull model) {
            @strongify(self);
            [self scorllCategoryTab:model];
        };
        
        shortVideoMainVC.shortVideoWholeVideoClickCallBack = ^(HKShortVideoModel * _Nonnull model) {
            @strongify(self);
            [self pushVideoPlayWithModel:model];
        };
        shortVideoMainVC.shortVideoType = HKShortVideoType_main_tab;
        
        self.viewDelegate = shortVideoMainVC;
        
        HKShortVideoCategoryVC *categoryVC = [[HKShortVideoCategoryVC alloc] init];
        _viewcontrollers = @[shortVideoMainVC, categoryVC];
    }
    return _viewcontrollers;
}




#pragma mark 选中分类tab
- (void)scorllCategoryTab:(HKShortVideoModel *)model {
    self.selectIndex = 1;
    HKShortVideoCategoryVC *VC = (HKShortVideoCategoryVC*) self.viewcontrollers[1];
    if ([VC isKindOfClass:[HKShortVideoCategoryVC class]] ) {
        [self didEnterController:VC atIndex:1];
        [VC scorllSelectTabWithTagId:model.video_tag.tag_id];
    }
}


#pragma mark 跳转到 普通视频详情
- (void)pushVideoPlayWithModel:(HKShortVideoModel *)model {
    NSString *videoId = model.relation_video_id;
    
    if (isEmpty(videoId) || ([videoId integerValue] == 0)) {
        return ;
    }
    
    //2:相关视频按钮点击
    HKAlilogModel *aliLogModel = [HKAlilogModel new];
    if ([model.relation_type isEqualToString:@"2"]) {
        aliLogModel.shortVideoToVideoCollectFlag = @"3";
        aliLogModel.shortVideoToVideoPlayFlag = @"4";
    }
    
    if ([model.relation_type isEqualToString:@"1"]) {
        aliLogModel.shortVideoToVideoCollectFlag = @"5";
        aliLogModel.shortVideoToVideoPlayFlag = @"6";
    }

    VideoPlayVC *playVC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:nil placeholderImage:nil lookStatus:LookStatusInternetVideo videoId:videoId model:nil];
    playVC.alilogModel = aliLogModel;
    
    self.navigationController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playVC animated:YES];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.viewDelegate respondsToSelector:@selector(superViewWillDisappear:)]) {
        [self.viewDelegate superViewWillDisappear:animated];
    }
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.viewDelegate respondsToSelector:@selector(superViewDidAppear:)]) {
        [self.viewDelegate superViewDidAppear:animated];
    }
}


//视图切换菜单栏 高度
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    
    menuView.backgroundColor = [UIColor clearColor];
    menuView.hiddenSeparatorLine = YES;
    return CGRectMake(0, IS_IPHONE_X ?44 :20, SCREEN_WIDTH, 35);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return self.view.bounds;
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


- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController
              withInfo:(NSDictionary *)info {

    NSInteger index = [info[@"index"] integerValue];
    if (1 == index) {
        //分类
        [MobClick event:UM_RECORD_SHORTVIDEO_TYPE];
    }
}


@end



