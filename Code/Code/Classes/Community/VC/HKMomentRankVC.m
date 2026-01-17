//
//  HKMomentRankVC.m
//  Code
//
//  Created by Ivan li on 2021/1/22.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKMomentRankVC.h"
#import "HKMomentRankSubVC.h"
#import "HKMomentRankMenu.h"
#import "HKFiltrateView.h"
#import "HKMyLiveModel.h"
#import "HKMonmentTypeModel.h"
#import "WMPageController+Category.h"
#import "HKPostMonmentVC.h"

@interface HKMomentRankVC ()<HKMomentRankMenuDelegate>
@property (nonatomic , strong) NSArray * dataArray;
@property (nonatomic, copy) NSArray<HKBaseVC *> *viewcontrollers;
@property (nonatomic , strong) HKMomentRankMenu * rankmenuView;
@property (nonatomic , strong) HKFiltrateView * filtrateV;
@property (nonatomic , strong) UIImageView * imgV;

@end

@implementation HKMomentRankVC

-(HKMomentRankMenu *)rankmenuView{
    if (_rankmenuView == nil) {
        _rankmenuView = [HKMomentRankMenu viewFromXib];
        _rankmenuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
        _rankmenuView.delegate =self;
        _rankmenuView.typeArray = self.typeModel.order;
        _rankmenuView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _rankmenuView;
}

- (NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareSetup];
    if (self.tabModel.categories.count) {
        [self createMenuView];
    }
    
    BOOL show = [[NSUserDefaults standardUserDefaults] boolForKey:@"showRequestionGuidView"];
    if ([self.typeModel.type intValue] == 2 && !show) {
        self.imgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-112-15,40+45 , 112, 38)];
        self.imgV.image = [UIImage imageNamed:@"toast_community_2_33"];
        [self.view addSubview:self.imgV];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadData];
    [self.view bringSubviewToFront:self.imgV];
    BOOL show = [[NSUserDefaults standardUserDefaults] boolForKey:@"showRequestionGuidView"];
    if (!show) {
        self.imgV.hidden = NO;
    }else{
        self.imgV.hidden = YES;
    }
}


- (void)refreshTableView{
    HKMomentRankSubVC *VC = (HKMomentRankSubVC *)self.viewcontrollers[self.selectIndex];
    [VC refreshTableView];
}


- (void)createMenuView{
    HKFiltrateView * filtrateV = [HKFiltrateView viewFromXib];
    filtrateV.isMonmentVC = YES;
    filtrateV.tagArray = self.tabModel.categories;
    filtrateV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:filtrateV];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.filtrateV.rightMargin.constant = SCREEN_WIDTH;
    });
    
    filtrateV.hidden = YES;
    self.filtrateV = filtrateV;
    self.filtrateV.bgView.alpha = 0.0;
    self.filtrateV.cancelFiltrateBlock = ^{

    };
    
//    [MyNotification addObserver:self selector:@selector(chooseTagModel:) name:@"selectedTagModel" object:nil];

}

//- (void)loadData:(NSNotification *)noti{
//    if ([self.typeModel.ID intValue] == 2) {
//        [MobClick event: community_question_tab_filter];
//    }
//    HKMonmentTagModel * tagModel = noti.userInfo[@"tagModel"];
//    self.categroyId = tagModel.ID;
//    [self loadNewListData];
//}


/*************************  UIViewController **************************/
- (void)prepareSetup {
    [super prepareSetup];
    NSMutableArray *arrayVC = [NSMutableArray array];

    for (int i = 0; i < self.typeModel.order.count; i++) {
        HKMonmentTagModel * model = self.typeModel.order[i];
        HKMomentRankSubVC *VC =  [[HKMomentRankSubVC alloc] init];
        VC.model = model;
        VC.tabModel = self.tabModel;
        VC.typeModel = self.typeModel;
        [arrayVC addObject:VC];
    }
    self.viewcontrollers = arrayVC;
    self.scrollEnable = NO;
    self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
    [self reloadData];
}


#pragma mark === HKMomentRankMenuDelegate
- (void)momentRankMenuDidRankBtn:(NSInteger)tag{
    self.selectIndex = (int)tag;
    
}

- (void)momentRankMenuDidfiltrateBtn{
    
    if ([self.typeModel.type intValue] == 2) {
        [MobClick event: community_question_quiz];
        if (isLogin()) {
            WeakSelf
            [self checkBindPhone:^{
                HKPostMonmentVC* vc = [[HKPostMonmentVC alloc] init];
                HKMonmentTagModel * model= [[HKMonmentTagModel alloc] init];
                model.ID = [NSNumber numberWithInt:1];
                model.name = @"提问答疑";
                vc.topicModel = model;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showRequestionGuidView"];
                [[NSUserDefaults standardUserDefaults] synchronize];

            } bindPhone:^{
                
            }];
        }else{
            [self setLoginVC];
        }
    }else{
        self.filtrateV.hidden = NO;
        [UIView animateWithDuration:0.15 animations:^{
            self.filtrateV.bgView.alpha = 0.3;
        } completion:^(BOOL finished) {
            self.filtrateV.rightMargin.constant = 0;
            [UIView animateWithDuration:0.25 animations:^{
                [self.filtrateV layoutIfNeeded];
            }];
        }];
    }
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.viewcontrollers.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.viewcontrollers[index];
}

//- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
////        if ([self.typeModel.ID intValue] == 2) {//提问答疑
////             HKMonmentTagModel * model = self.typeModel.order[index];
////            if ([model.ID intValue] == 0) {
////                [MobClick event: community_question_select];
////            }else if ([model.ID intValue] == 1){
////                [MobClick event: community_question_answered];
////            }else if ([model.ID intValue] == 2){
////                [MobClick event: community_question_unanswered];
////            }
////            //[MobClick event: community_question_tab_hot];
////        }else if ([self.typeModel.ID intValue] == 3){
////            if (index == 1) {
////                [MobClick event: community_task_tab_hot];
////            }
////
////        }else if ([self.typeModel.ID intValue] == 4){
////            if (index == 1) {
////                [MobClick event: community_works_tab_hot];
////            }
////
////        }
//
//    return nil;
//}

- (void)pageController:(WMPageController *)pageController menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index
          currentIndex:(NSInteger)currentIndex{
    if ([self.typeModel.type intValue] == 2) {//提问答疑
        if (self.typeModel.order.count > index) {
            HKMonmentTagModel * model = self.typeModel.order[index];
           if ([model.ID intValue] == 0) {
               [MobClick event: community_question_select];
           }else if ([model.ID intValue] == 1){
               [MobClick event: community_question_answered];
           }else if ([model.ID intValue] == 2){
               [MobClick event: community_question_unanswered];
           }
        }
    }else if ([self.typeModel.type intValue] == 3){
        if (index == 1) {
            [MobClick event: community_task_tab_hot];
        }
        
    }else if ([self.typeModel.type intValue] == 4){
        if (index == 1) {
            [MobClick event: community_works_tab_hot];
        }
        
    }
}

- (BOOL)pageController:(WMStickyPageController *)pageController shouldScrollWithSubview:(UIScrollView *)subview {
    
    return NO;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    [pageController.menuView addSubview:self.rankmenuView];
    if ([self.typeModel.type intValue] == 2) {
        self.rankmenuView.isRequestion = YES;
        self.rankmenuView.needFiltrateBtn = self.typeModel.categoryFilter;
        //return CGRectMake(0,90, SCREEN_WIDTH, SCREEN_HEIGHT - 90);
    }else{
        self.rankmenuView.isRequestion = NO;
        self.rankmenuView.needFiltrateBtn = self.typeModel.categoryFilter;
        //return CGRectMake(0,75, SCREEN_WIDTH, SCREEN_HEIGHT - 75);
    }
    return CGRectMake(0,90, SCREEN_WIDTH, SCREEN_HEIGHT - 90);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    self.rankmenuView.size = CGSizeMake(SCREEN_WIDTH, 50);
    if ([self.typeModel.type intValue] == 2) {
        self.rankmenuView.isRequestion = YES;
        self.rankmenuView.needFiltrateBtn = self.typeModel.categoryFilter;
        return CGRectMake(0, 40, SCREEN_WIDTH, 50);
    }else{
        self.rankmenuView.isRequestion = NO;
        self.rankmenuView.needFiltrateBtn = self.typeModel.categoryFilter;
        return CGRectMake(0, 40, SCREEN_WIDTH, 35);
    }
    
}
@end
