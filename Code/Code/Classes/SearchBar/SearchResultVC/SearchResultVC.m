//
//  SearchResultVC.m
//  Code
//
//  Created by Ivan li on 2017/9/1.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "SearchResultVC.h"
#import "PYSearch.h"
#import "HKSearchCourseVC.h"
#import "NSString+Size.h"
#import "MyInfoViewController.h"
#import "TagModel.h"

const NSInteger pageSize = 16;


@interface SearchResultVC ()<HKSearchCourseVCDelegate>

@property(nonatomic,strong)UITableView     *tableView;
@property(nonatomic,strong)NSMutableArray   *dataArray;
@property(nonatomic,copy)NSString           *keyWord;

@property(nonatomic,assign)NSInteger  videoCount;//视频总数

@property(nonatomic, copy)NSArray<NSString *> *tabTitleArray;

@end

@implementation SearchResultVC



- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil keyWord:(NSString *)keyWord {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.keyWord = keyWord;
        [self prepareSetup];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.hk_hideNavBarShadowImage = YES;
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    if (self.redirectWordsArray.count && self.keyWord.length) {
        for (preciseWordsModel * model in self.redirectWordsArray) {
            if ([model.word isEqualToString:self.keyWord]) {
                AdvertParameterModel * model1 = [[AdvertParameterModel alloc] init];
                model1.parameter_name = @"isFromSearch";
                model1.value = model.word;
                [model.redirect_package.list addObject:model1];
                //广告跳转
                [HKH5PushToNative runtimePush:model.redirect_package.className arr:model.redirect_package.list currectVC:self];
                return;
            }
        }
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //友盟页面路径统计
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
    //友盟页面路径统计
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)prepareSetup {
    
    //self.titles = @[@"教程", @"系列课", @"专辑", @"讲师"];
    self.titles = @[@"推荐", @"系列课", @"直播课", @"软件", @"专辑",@"读书",@"文章",@"讲师"];
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 17;
    self.menuViewStyle = WMMenuViewStyleLine;
    //self.itemMargin = 30;
    //self.menuViewContentMargin = PADDING_15;
    
//    NSNumber *temp = [[NSNumber alloc]initWithFloat:PADDING_20*2];
//    NSNumber *temp1 = [[NSNumber alloc]initWithFloat:PADDING_20*3];
//    NSNumber *temp2 = [[NSNumber alloc]initWithFloat:PADDING_20*4];
//    NSNumber *temp3 = [[NSNumber alloc]initWithFloat:PADDING_20*2];
//    NSNumber *temp4 = [[NSNumber alloc]initWithFloat:PADDING_20*2];
//    NSNumber *temp5 = [[NSNumber alloc]initWithFloat:PADDING_20*2];
    //self.itemsWidths = @[temp,temp1,temp2,temp3,temp4,temp5];
    
    NSNumber *margin_15 = [[NSNumber alloc]initWithFloat:PADDING_15];
    NSNumber *margin_25 = [[NSNumber alloc]initWithFloat:PADDING_25];
    
    //self.automaticallyCalculatesItemWidths = YES;
    NSNumber *temp = [[NSNumber alloc]initWithFloat:PADDING_20*2];
    NSNumber *temp1 = [[NSNumber alloc]initWithFloat:45];
    NSNumber *temp2 = [[NSNumber alloc]initWithFloat:45];
    NSNumber *temp3 = [[NSNumber alloc]initWithFloat:PADDING_20*2];
    NSNumber *temp4 = [[NSNumber alloc]initWithFloat:PADDING_20*2];
    NSNumber *temp5 = [[NSNumber alloc]initWithFloat:PADDING_20*2];
    NSNumber *temp6 = [[NSNumber alloc]initWithFloat:PADDING_20*2];
    NSNumber *temp7 = [[NSNumber alloc]initWithFloat:PADDING_20*2];
    self.itemsWidths = @[temp,temp1,temp2,temp3,temp4,temp5,temp6,temp7];
    
    self.itemsMargins = @[margin_15,margin_25,margin_25,margin_25,margin_25,margin_25,margin_25,margin_25,margin_15];
    
    self.progressColor = COLOR_fddb3c;
    self.titleColorNormal = COLOR_27323F_EFEFF6;
    self.titleColorSelected = COLOR_27323F_EFEFF6;
    self.progressWidth = PADDING_30;
    self.progressHeight = 4;
    self.menuColorNormal = COLOR_FFFFFF_3D4752;
    self.menuView.backgroundColor = COLOR_FFFFFF_3D4752;
    //self.preloadPolicy = WMPageControllerPreloadPolicyNear;//预加载
    
}


/****************  HKSearchCourseVCDelegate **************/
- (void)switchTabIndex:(NSInteger)index model:(VideoModel *)model {
    
    self.selectIndex = index;
    if (self.viewcontrollers.count >index) {
        [self didEnterController:self.viewcontrollers[index] atIndex:index];
    }
}



- (NSArray<UIViewController *> *)viewcontrollers {
    
    if (_viewcontrollers == nil) {
        WeakSelf;
        HKSearchCourseVC *courseVC = [[HKSearchCourseVC alloc]initWithKeyWord:self.keyWord category:SearchResultCourese];
        courseVC.delegate = self;
        
        HKSearchCourseVC *seriseVC = [[HKSearchCourseVC alloc]initWithKeyWord:self.keyWord category:SearchResultSerise];
        seriseVC.updateTitleCallBack = ^(NSInteger count) {
            [weakSelf updateItemTitle:1 count:count];
        };
        HKSearchCourseVC * liveCourseVC = [[HKSearchCourseVC alloc]initWithKeyWord:self.keyWord category:SearchResultLiveCourse];
        liveCourseVC.updateTitleCallBack = ^(NSInteger count) {
            [weakSelf updateItemTitle:2 count:count];
        };

        HKSearchCourseVC *softwareVC = [[HKSearchCourseVC alloc]initWithKeyWord:self.keyWord category:SearchResultSoftware];
        softwareVC.updateTitleCallBack = ^(NSInteger count) {
            [weakSelf updateItemTitle:3 count:count];
        };
        
        HKSearchCourseVC *albumVC = [[HKSearchCourseVC alloc]initWithKeyWord:self.keyWord category:SearchResultAlbum];
        albumVC.updateTitleCallBack = ^(NSInteger count) {
            [weakSelf updateItemTitle:4 count:count];
        };
        
        HKSearchCourseVC *readBookVC = [[HKSearchCourseVC alloc]initWithKeyWord:self.keyWord category:SearchResultReadBook];
        readBookVC.updateTitleCallBack = ^(NSInteger count) {
            [weakSelf updateItemTitle:5 count:count];
        };
        
        HKSearchCourseVC *articleVC = [[HKSearchCourseVC alloc]initWithKeyWord:self.keyWord category:SearchResultArticle];
        articleVC.updateTitleCallBack = ^(NSInteger count) {
            [weakSelf updateItemTitle:6 count:count];
        };
        
        HKSearchCourseVC *teachVC = [[HKSearchCourseVC alloc]initWithKeyWord:self.keyWord category:SearchResultTeacher];
        teachVC.updateTitleCallBack = ^(NSInteger count) {
            [weakSelf updateItemTitle:7 count:count];
        };
        
        _viewcontrollers = @[courseVC, seriseVC, liveCourseVC,softwareVC, albumVC ,readBookVC,articleVC, teachVC];
    }
    return _viewcontrollers;
}



/** 更新item 标题和宽度 */
- (void)updateItemTitle:(NSInteger)index count:(NSInteger)count {
    
    if (count) {
        NSString * text = self.titles[index];
//        NSString *text = nil;
//        if (count>99) {
//            text = [NSString stringWithFormat:@"%@(99)+",title];
//        }else{
//            text = [NSString stringWithFormat:@"%@(%ld)",title,(long)count];
//        }
        UIFont *font = (index == self.selectIndex) ?HK_FONT_SYSTEM_WEIGHT(self.titleSizeSelected, UIFontWeightMedium) :HK_FONT_SYSTEM(self.titleSizeNormal);
        CGFloat  width = [NSString sizeWithText:text font:font maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
        if (width<40) {
            width = 40;
        }
        [self updateTitle:text andWidth:width atIndex:index];
        //[self.menuView resetFrames];
    }
}


#pragma mark - Datasource & Delegate
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, SCREEN_WIDTH, kHeight44);//菜单栏 高度
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, kHeight44, SCREEN_WIDTH, SCREEN_HEIGHT- kHeight44);
}


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.viewcontrollers.count;
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.viewcontrollers[index];
}


- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}


- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    pageController.menuView.hiddenSeparatorLine = YES;
    NSInteger idenx = [info[@"index"] integerValue];
    for (int i = 1; i<self.titles.count; i++) {
        NSString *text = nil;
        WMMenuItem *item = [pageController.menuView itemAtIndex:i];
        text = item.text;
        UIFont *font = HK_FONT_SYSTEM(self.titleSizeNormal);
        if (idenx == i) {
            font = HK_FONT_SYSTEM_WEIGHT(self.titleSizeSelected, UIFontWeightMedium);
        }
        CGFloat  width = [NSString sizeWithText:text font:font maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
        if (width<40) {
            width = 40;
        }
        [self updateTitle:text andWidth:width atIndex:i];
    }
}


@end




