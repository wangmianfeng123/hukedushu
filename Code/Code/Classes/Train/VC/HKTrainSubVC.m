//
//  HKTrainSubVC.m
//  Code
//
//  Created by Ivan li on 2021/3/31.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKTrainSubVC.h"
#import "HKHotTopicHeaderView.h"
#import "HKTrainCommentVC.h"
#import "HKTaskTopView.h"
#import "HKAddWeChatView.h"
#import "HtmlShowVC.h"
#import "HKDayTaskVC.h"
#import "UIView+HKLayer.h"

@interface HKTrainSubVC ()
@property (nonatomic , strong) HKTaskTopView * headerView;
@property (nonatomic , strong) HKAddWeChatView * addWeChatView;

@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;


@property (nonatomic, copy) NSString * typeString;  //all: 全部 my:我的 black：小黑屋
@property (nonatomic, assign) int pages;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) HKTrainDetailModel * detailModel;
@property (nonatomic , strong) NSArray * titleArray;
@property (nonatomic , assign) BOOL isScrollToHeader ;
@end

@implementation HKTrainSubVC

- (void)menuTabProgressUI {
    self.menuViewStyle = WMMenuViewStyleLine;
    self.progressColor = COLOR_fddb3c;
    self.progressWidth = 30;
    self.progressHeight = 4;
}

- (void)viewDidLoad {
    [self menuTabProgressUI];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    self.hk_hideNavBarShadowImage = YES;
    self.titleArray = @[@"最新打卡",@"我的打卡",@"小黑屋"];
    
    if (self.taskCalendarModel.is_start == 1) {
        [self getNewData];
    }else{
        [self createEmptyView];
    }
}

- (void)scrollToHeaderViewHeight{
    if (self.kWMHeaderViewHeight > 0) {
        UIScrollView * scroV= (UIScrollView *)self.view;
        [scroV setContentOffset:CGPointMake(scroV.contentOffset.x, self.kWMHeaderViewHeight) animated:NO];
    }else{
        _isScrollToHeader = YES;
    }
}

/*************************  UIViewController **************************/

- (void)prepareSetup {
    NSMutableArray *arrayVC = [NSMutableArray array];
    for (int i  = 0; i < 3; i++) {
        HKTrainCommentVC *VC =  [[HKTrainCommentVC alloc] init];
        if (i == 0) {
            VC.typeString = @"all";
        }else if (i == 1){
            VC.typeString = @"my";
        }else{
            VC.typeString = @"black";
        }
        
        VC.trainingId = self.trainingId;
        VC.date = self.date;
        VC.taskCalendarModel = self.taskCalendarModel;
        [arrayVC addObject:VC];
    }
    self.viewcontrollers = arrayVC;
    self.menuViewHeight = 40.0;
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 15;
    //self.progressWidth = 60;
    
    self.titleColorNormal = COLOR_7B8196_A8ABBE;
    self.titleColorSelected = COLOR_27323F_EFEFF6;
    self.menuItemWidth = SCREEN_WIDTH * 0.2;
    self.maximumHeaderViewHeight = self.kWMHeaderViewHeight;
    self.minimumHeaderViewHeight = 0;
    self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
    self.isSelectedBold = NO;
    //self.progressViewWidths = @[@"50",@"50",@"10"];
    [self reloadData];
}


#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.viewcontrollers.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.viewcontrollers[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titleArray[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, self.maximumHeaderViewHeight+40, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(10, self.maximumHeaderViewHeight, SCREEN_WIDTH, 40);
}


#pragma mark - 获取数据
- (void)getNewData {
    @weakify(self);
    NSDictionary *param = @{@"date" : self.date, @"training_id" : self.trainingId};

    [HKHttpTool POST:HK_TrainingDatail_URL parameters:param success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            self.detailModel = [HKTrainDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (self.updateDataBlock) {
                self.updateDataBlock(self.detailModel);
            }
            self.headerView = [HKTaskTopView viewFromXib];
            self.headerView.detailModel = self.detailModel;
            self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.headerView.cellHight);
            self.headerView.backgroundColor = COLOR_FFFFFF_3D4752;
            WeakSelf
            self.headerView.punchViewClickBlock = ^(HKAllTrainTaskModel * _Nonnull allModel, HKTrainTaskModel * _Nonnull taskModel) {
                if (allModel) {
                    HKDayTaskVC * vc = [HKDayTaskVC new];
                    vc.date = weakSelf.date;
                    vc.trainingId = weakSelf.trainingId;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                };
                if (taskModel) {
                    if (taskModel.live_status == 1) {
                        HKLivingPlayVC2 *vc = [[HKLivingPlayVC2 alloc] init];
                        vc.live_id = taskModel.sp_task_value;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }else if (taskModel.live_status == 0){
                        showTipDialog(@"课程未开始");
                    }else{
                        showTipDialog(@"课程已结束");
                    }
                }
            };
            [self.view addSubview:self.headerView];
            
            self.addWeChatView = [HKAddWeChatView viewFromXib];
            self.addWeChatView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), SCREEN_WIDTH, 75);
            self.addWeChatView.addWxBlock = ^{
                weakSelf.showWeChatCodeBlock();
            };
            self.addWeChatView.thumbsLikeBlock = ^{
                if (weakSelf.detailModel.task_list.is_clock) {
                    HtmlShowVC * vc = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:weakSelf.detailModel.task_list.share_url];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else{
                    showTipDialog(@"你还没有作品可以展示哦");
                }
            };
            [self.view addSubview:self.addWeChatView];
            
            self.kWMHeaderViewHeight = self.headerView.cellHight + 75;
            [self prepareSetup];
            if (self.isScrollToHeader) {
                [self scrollToHeaderViewHeight];
                self.isScrollToHeader = NO;
            }
        }
    } failure:^(NSError *error) {
        @strongify(self);
        self.isScrollToHeader = NO;
    }];
}

- (void)createEmptyView{
    UIView *myView = [[UIView alloc] init];
    myView.frame = CGRectMake(0, 0, self.view.width, 300);
    
    // 锁的图标
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = imageName(@"pic_key_v2_9");
    imageView.size = CGSizeMake(110, 110);
    imageView.centerX = myView.width * 0.5;
    imageView.y = 25;
    imageView.contentMode = UIViewContentModeCenter;
    [myView addSubview:imageView];
    
    // 暂未开始
    UILabel *notStartLB = [[UILabel alloc] init];
    notStartLB.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    notStartLB.textColor = HKColorFromHex(0x27323F, 1.0);
    notStartLB.text = @"暂未开始";
    [notStartLB sizeToFit];
    notStartLB.centerX = imageView.centerX;
    notStartLB.y = CGRectGetMaxY(imageView.frame) + 6.0;
    [myView addSubview:notStartLB];
    
    // 开课当天即可解锁该课程
    UILabel *notStartDesLB = [[UILabel alloc] init];
    notStartDesLB.font = [UIFont systemFontOfSize:15.0];
    notStartDesLB.textColor = HKColorFromHex(0x7B8196, 1.0);
    notStartDesLB.text = @"开课当天即可解锁该课程";
    [notStartDesLB sizeToFit];
    notStartDesLB.centerX = imageView.centerX;
    notStartDesLB.y = CGRectGetMaxY(notStartLB.frame) + 10.0;
    [myView addSubview:notStartDesLB];
    
    UIButton * addWxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addWxBtn.size = CGSizeMake(159, 38);
    addWxBtn.center = CGPointMake(notStartDesLB.centerX, notStartDesLB.centerY + 60* Ratio);
    [addWxBtn addCornerRadius:19 addBoderWithColor:[UIColor colorWithHexString:@"#FF7820"]];
    [addWxBtn setTitleColor:[UIColor colorWithHexString:@"#FF7820"] forState:UIControlStateNormal];
    [addWxBtn setTitle:@"添加班主任微信" forState:UIControlStateNormal];
    addWxBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [myView addSubview:addWxBtn];
    [addWxBtn addTarget:self action:@selector(addWxClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:myView];
}

- (void)addWxClick{
    self.showWeChatCodeBlock();
}

@end
