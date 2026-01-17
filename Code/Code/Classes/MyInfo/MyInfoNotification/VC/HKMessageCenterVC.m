//
//  HKMessageCenterVC.m
//  Code
//
//  Created by Ivan li on 2021/1/22.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKMessageCenterVC.h"
#import "WMPageController+Category.h"
#import "UIView+HKLayer.h"
#import "HKNotiTabModel.h"
#import "HKMessageSubVC.h"

@interface HKMessageCenterVC ()
@property (nonatomic, copy) NSMutableArray * viewcontrollers;
@property (nonatomic , strong) NSMutableArray * dataArray;
@end

@implementation HKMessageCenterVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        [self prepareSetup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    self.hk_hideNavBarShadowImage = YES;
    self.navigationItem.title = @"消息中心";
    [self setLeftBarButtonItem];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    [self loadData];

}

- (void)loadData{
    [HKHttpTool POST:@"/notice/tabs" parameters:nil success:^(id responseObject) {
        if ([CommonFunction detalResponse:responseObject]) {
            self.dataArray = [HKNotiTabModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"tabs"]];
            
            [self prepareSetup];
        }
    } failure:^(NSError *error) {
        
    }];
}



- (void)prepareSetup {
    [super prepareSetup];
    NSMutableArray * arry = [NSMutableArray array];
    for (HKNotiTabModel * tabModel in self.dataArray) {
        HKMessageSubVC * vc = [[HKMessageSubVC alloc] init];
        vc.tabModel = tabModel;
        [arry addObject:vc];
    }
    self.viewcontrollers =arry;
    self.menuItemWidth = 90;
    self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 15;
    [self reloadData];
    
//    HKNotiTabModel * model =self.dataArray[0];
//    HKNotiTabModel * model1 =self.dataArray[1];
//    if ([model1.unread intValue]>0 &&[model.unread intValue] == 0) {
//        self.selectIndex = 1;
//    }
}

- (NSMutableArray *)viewcontrollers {
    
    if (_viewcontrollers == nil) {
        _viewcontrollers = [NSMutableArray array];
    }
    return _viewcontrollers;
}


//视图切换菜单栏 高度
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    for (int i = 0; i< pageController.menuView.scrollView.subviews.count; i++) {
        if ([pageController.menuView.scrollView.subviews[i] isKindOfClass:[WMMenuItem class]]) {
            WMMenuItem * item = pageController.menuView.scrollView.subviews[i];
            [item removeAllSubviews];
            UILabel * redLabel = [[UILabel alloc] init];
            redLabel.backgroundColor = [UIColor redColor];
            redLabel.textColor = [UIColor whiteColor];
            redLabel.textAlignment = NSTextAlignmentCenter;
            redLabel.font = [UIFont systemFontOfSize:10];
            [redLabel addCornerRadius:8];
            
            if (self.dataArray.count > i-2) {
                HKNotiTabModel * model = self.dataArray[i-2];
                if ([model.unread intValue] > 99) {
                    redLabel.text = @"99+";
                    redLabel.frame = CGRectMake(item.width - 26, 0, 30, 16);
                    [item addSubview:redLabel];
                }else if ([model.unread intValue] > 0){
                    redLabel.text = [NSString stringWithFormat:@"%@",model.unread];
                    redLabel.frame = CGRectMake(item.width - 21, 0, 16, 16);
                    [item addSubview:redLabel];
                }
            }
        }
    }
    return CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, kHeight44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0,kHeight44, SCREEN_WIDTH, SCREEN_HEIGHT-kHeight44);
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.viewcontrollers.count;
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.viewcontrollers[index];
}


- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    HKNotiTabModel * model = self.dataArray[index];
    return model.name;
}

- (void)pageController:(WMPageController *)pageController menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index
          currentIndex:(NSInteger)currentIndex{
    NSLog(@"---------");
    [menu.selItem removeAllSubviews];
}

@end
