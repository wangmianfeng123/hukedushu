//
//  HKAudioListVC.m
//  Codeww
///
//  Created by Ivan li on 2018/3/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKShortVideoCategoryVC.h"
#import "VideoModel.h"
#import "VideoPlayVC.h"
#import "TagModel.h"
#import "HKAudioListCell.h"

#import "UIBarButtonItem+Extension.h"
#import "HKAudioHotVC.h"
#import "HKAudioAllSortVC.h"
#import "HKShortVideoListVC.h"
#import "WMPageController+Category.h"
#import "HKShortVideoCategoryModel.h"
#import "HKArticleCategoryListVC.h"
#import "HKShortVideoCategoryModel.h"


@interface HKShortVideoCategoryVC ()

@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;


@property(nonatomic,strong)NSMutableArray<HKShortVideoCategoryModel *> *categoryDataSource;

@end


@implementation HKShortVideoCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zf_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = COLOR_1A222B;
    [self loadCategoryData];
}



- (void)prepareSetup {
    
    self.automaticallyCalculatesItemWidths = YES;
    self.itemMargin = 25;
    self.menuViewContentMargin = 0;
    [super prepareSetup];
    
    self.titleColorNormal = COLOR_7B8196;
    self.titleColorSelected = COLOR_ffffff;
    self.menuColorNormal = COLOR_1A222B;
}



- (NSArray<UIViewController *> *)viewcontrollers {
    
    if (_viewcontrollers == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0 ; i < self.titles.count; i++) {
            HKShortVideoListVC *vc2 = [[HKShortVideoListVC alloc] init];
            vc2.tag_id = self.categoryDataSource[i].ID;
            [array addObject:vc2];
        }
        _viewcontrollers = [NSArray arrayWithArray:array];
    }
    return _viewcontrollers;
}



//视图切换菜单栏 高度222
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    
    menuView.backgroundColor = COLOR_1A222B;
    return CGRectMake(0, KNavBarHeight64 - 10, SCREEN_WIDTH, kHeight44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    return CGRectMake(0,KNavBarHeight64 + kHeight44 - 10, SCREEN_WIDTH, SCREEN_HEIGHT -KNavBarHeight64 - kHeight44 + 10);
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.viewcontrollers[index];
}


- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    pageController.menuView.hiddenSeparatorLine = YES;
    return self.titles[index];
}


- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController
              withInfo:(NSDictionary *)info {
    
}



#pragma mark <Server>
- (void)loadCategoryData {
    
    [HKHttpTool POST:@"short-video/get-tags" parameters:nil success:^(id responseObject) {
        
        if (HKReponseOK) {
            NSMutableArray *tagArr = [HKShortVideoCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lists"]];
            
            // 模拟数据
//            for (int i = 0; DEBUG && i < 10; i++) {
//                [tagArr addObject:tagArr.lastObject];
//            }
            
            self.titles = [tagArr valueForKey:@"tag"];
            self.categoryDataSource = tagArr;
            
            [self prepareSetup];
            [self reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}




#pragma mark - 滚动到需要选中的 tab
- (void)scorllSelectTabWithTagId:(NSString*)tagId {
    __block NSUInteger index = 0;
    [self.categoryDataSource enumerateObjectsUsingBlock:^(HKShortVideoCategoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.ID isEqualToString:tagId]) {
            index = idx;
            *stop = YES;
        };
    }];
    if (self.viewcontrollers.count > index) {
        self.selectIndex = (int)index;
        [self didEnterController:self.viewcontrollers[index] atIndex:index];
    }
}


@end

