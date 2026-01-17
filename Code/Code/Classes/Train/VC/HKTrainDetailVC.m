//
//  HKTrainDetailVC.m
//  Code
//
//  Created by Ivan li on 2018/5/16.22
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTrainDetailVC.h"
#import "HKCollectionPGCVC.h"
#import "UIBarButtonItem+Extension.h"
#import "HKTrainHeaderView.h"
#import "UMpopView.h"
#import "HKTrainDetailModel.h"
#import "HKTeacherVIPCourseVC.h"
#import "HKTeacherPGCVC.h"
#import "HKUserInfoSettingVC.h"
#import "XLPhotoBrowser.h"
#import "HKTrainItemVC.h"
#import "HKTrainTeacherQRCodeVC.h"
#import "HKUserTaskVC.h"
#import "WMPageController+Category.h"
#import "HKTrainShareWebVC.h"
#import "HKTrainTipsView.h"
#import "HKShareTrainView.h"
#import "HKRankVC.h"
#import "HKTrainSubVC.h"
#import "HKTrainHomeTopView.h"
#import "HKDayTaskVC.h"

@interface HKTrainDetailVC ()<UMpopViewDelegate,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource>

@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;

@property (nonatomic, strong)HKTrainDetailModel *detailModel;

@property (nonatomic, weak)HKTrainHeaderView *headerView;

@property (nonatomic, assign)int lastSelectIndex;

@property (nonatomic, strong) HKTrainTipsView * tipsView;
@property (nonatomic , strong) HKTrainHomeTopView * topView;
@property (nonatomic , strong) HKTrainSubVC * currentItemVC;
@end

@implementation HKTrainDetailVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.trainingId = self.trainingId.length? self.trainingId : @"66";
    self.view.backgroundColor = COLOR_F8F9FA_3D4752;
    [self setLeftBarButtonItem];
    self.title = @"日系清新";
    
    [self setupHeader];
    
    // 有上角的二维码
    [self createRightBarButtonWithImage:@"ic_code_v2_9"];
    //[self getNewData];
    [MobClick event:training_camp_view];
    [self prepareSetup];
    
    BOOL showed = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasShowedTips"];
    if (!showed) {
        self.tipsView = [HKTrainTipsView createView];
        [self.navigationController.view addSubview:self.tipsView];
    }
    
    self.topView = [HKTrainHomeTopView viewFromXib];
    self.topView.frame = CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, 60);
    [self.navigationController.view addSubview:self.topView];
    WeakSelf
    self.topView.previousBlock = ^{
        [MobClick event:training_camp_Switch_date];
        if (weakSelf.selectIndex > 0) {
            weakSelf.selectIndex = weakSelf.selectIndex - 1;
            HKTrainDetailTaskCalendarModel *taskCalendarModel = weakSelf.detailModel.date_list[weakSelf.selectIndex];
            weakSelf.topView.taskCalendarModel = taskCalendarModel;
            weakSelf.topView.detailModel = weakSelf.detailModel;
            
            UIScrollView * scroV= (UIScrollView *)weakSelf.view;
            [scroV setContentOffset:CGPointMake(scroV.contentOffset.x, 137 * Ratio) animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.currentItemVC scrollToHeaderViewHeight];
            });
        }
        weakSelf.topView.hidden = NO;
    };

    self.topView.nextBlock = ^{
        [MobClick event:training_camp_Switch_date];
        if (weakSelf.selectIndex < weakSelf.viewcontrollers.count -1) {
            weakSelf.selectIndex = weakSelf.selectIndex + 1;
            HKTrainDetailTaskCalendarModel *taskCalendarModel = weakSelf.detailModel.date_list[weakSelf.selectIndex];
            weakSelf.topView.taskCalendarModel = taskCalendarModel;
            weakSelf.topView.detailModel = weakSelf.detailModel;

            UIScrollView * scroV= (UIScrollView *)weakSelf.view;
            [scroV setContentOffset:CGPointMake(scroV.contentOffset.x, 137 * Ratio) animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.currentItemVC scrollToHeaderViewHeight];
            });
        }
        weakSelf.topView.hidden = NO;
        
    };

    self.topView.timeClickBlock = ^{
        [MobClick event:training_camp_date];
        UIScrollView * scroV= (UIScrollView *)weakSelf.view;
        [scroV setContentOffset:CGPointMake(scroV.contentOffset.x, 0) animated:YES];
        
        UIScrollView * scroV1= (UIScrollView *)weakSelf.currentItemVC.view;
        [scroV1 setContentOffset:CGPointMake(scroV.contentOffset.x, 0) animated:YES];
        [MyNotification postNotificationName:@"scroToTop" object:nil];
        //weakSelf.scrollView.contentOffset = CGPointMake(weakSelf.scrollView.contentOffset.x, 0);
    };
    
    self.topView.signInClickBlock = ^(HKTrainDetailModel * _Nonnull detailModel) {
        [MobClick event:training_camp_clockon];
        if (detailModel.task_list.is_clock) {
            if (weakSelf.currentItemVC.childViewControllers.count > 0) {
                weakSelf.currentItemVC.selectIndex = 1;
            }
        }else{
            HKTrainDetailTaskCalendarModel *taskCalendarModel = detailModel.date_list[weakSelf.selectIndex];
            HKDayTaskVC * vc = [HKDayTaskVC new];
            vc.date = taskCalendarModel.full_date;
            vc.trainingId = weakSelf.trainingId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getNewData];
    CGFloat offsetY = self.scrollView.contentOffset.y;
    NSLog(@"=======%f",offsetY);
    if (offsetY >= 137 * Ratio) {
        self.topView.hidden = NO;
    }else{
        self.topView.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.topView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGFloat offsetY = self.scrollView.contentOffset.y;
    NSLog(@"=======%f",offsetY);
    if (offsetY >= 137 * Ratio) {
        self.topView.hidden = NO;
    }else{
        self.topView.hidden = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.topView.hidden = YES;
//    [self.topView removeFromSuperview];
}


// 创建二维码
- (void)createRightBarButtonWithImage:(NSString*)image {
        
    UIImage *normalImage = [UIImage hkdm_imageWithNameLight:(@"ic_code_v2_9") darkImageName:(@"ic_code_v2_9_dark")];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem BarButtonRightItemWithBackgroudImage:normalImage highBackgroudImageName:normalImage target:self action:@selector(rightBarBtnAction)];
}

- (void)rightBarBtnAction {
    [MobClick event:training_camp_QRcode];
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 335, 570)];
    bgView.layer.cornerRadius = 10;
    bgView.layer.masksToBounds = YES;

    HKShareTrainView * shareView = [HKShareTrainView viewFromXib];
    shareView.qrCodeURL = self.detailModel.teacher_qrcode;
    [bgView addSubview:shareView];
    shareView.closeBlock = ^{
        [LEEAlert closeWithCompletionBlock:nil];
    };
    [LEEAlert alert].config
    .LeeCustomView(bgView)
    .LeeQueue(YES)
    .LeePriority(1)
    .LeeCornerRadius(10)
    .LeeHeaderColor([UIColor clearColor])
    .LeeHeaderInsets(UIEdgeInsetsZero)
    .LeeMaxWidth(335)
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}

- (void)setupHeader {
    
    
    // 设置头部资料
    WeakSelf;
    HKTrainHeaderView *headerView = [HKTrainHeaderView viewFromXib];
    headerView.seeCerBtnClickBlock = ^{
        if (!weakSelf.detailModel) return;
        
        
        
        HKTrainShareWebVC *vc = [[HKTrainShareWebVC alloc] initWithNibName:nil bundle:nil url:weakSelf.detailModel.taskProgress.certificate];
        vc.shareData = weakSelf.detailModel.taskProgress.shareData;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    self.headerView = headerView;
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(KNavBarHeight64);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(138 * Ratio);
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"----");
}

#pragma mark <Server>

static CGFloat const kWMMenuViewHeight = 60.0;
//static CGFloat const HKTrainHeaderViewHeight = 133 * Ratio;


- (void)prepareSetup {
    CGFloat kWMHeaderViewHeight = 138 * Ratio + KNavBarHeight64;
    self.controllerType = WMStickyPageControllerType_videoDetail;
    self.automaticallyCalculatesItemWidths = YES;
    self.titleSizeNormal = 17;
    self.titleSizeSelected = 17;

    self.menuViewHeight = kWMMenuViewHeight;
    self.maximumHeaderViewHeight = kWMHeaderViewHeight;
    self.minimumHeaderViewHeight = KNavBarHeight64;
    self.titleColorNormal = [UIColor clearColor];
    self.titleColorSelected = [UIColor clearColor];
    [self reloadData];
    
    
}




- (BOOL)pageController:(WMStickyPageController *)pageController shouldScrollWithSubview:(UIScrollView *)subview {
    
    return YES;
}



- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
    [self.topView removeFromSuperview];
    self.topView = nil;
}



#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.viewcontrollers.count;
    //return 15;
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    self.currentItemVC = (HKTrainSubVC *)self.viewcontrollers[index];
    return self.currentItemVC;
}




- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    [self setPageControllerMenuTitle:pageController titleAtIndex:index];
    //NSLog(@"%@",self.titles[index]);
    
    return self.titles[index];
    //return @"哈哈";
}



#pragma mark - 重置menu标题
- (void)setPageControllerMenuTitle:(WMPageController *)pageController  titleAtIndex:(NSInteger)index {
    
    HKTrainDetailTaskCalendarModel *taskCalendarModel = self.detailModel.date_list[index];
    // 标题
    NSString *title = [NSString stringWithFormat:@"%@\n%@", taskCalendarModel.date, taskCalendarModel.week];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, title.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium] range:NSMakeRange(title.length - taskCalendarModel.week.length, taskCalendarModel.week.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, taskCalendarModel.date.length)];
        
    if (taskCalendarModel.colorControl) {
        [attrString addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0x7B8196, 1.0) range:NSMakeRange(0, title.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_27323F_EFEFF6 range:NSMakeRange(title.length - taskCalendarModel.week.length, taskCalendarModel.week.length)];
    }else{
        [attrString addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0xA8ABBE, 1.0) range:NSMakeRange(0, title.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0xA8ABBE, 1.0) range:NSMakeRange(title.length - taskCalendarModel.week.length, taskCalendarModel.week.length)];
    }
    
    
    WMMenuItem *item = [pageController.menuView itemAtIndex:index];
    item.titleLB.attributedText = attrString;
    item.titleLB.hidden = NO;
    item.titleLB.textAlignment = NSTextAlignmentCenter;
    item.titleLB.backgroundColor = COLOR_FFFFFF_3D4752;
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {

    NSString *index = [info objectForKey:@"index"];
    NSInteger temp = [index integerValue];
    UIColor *color = [UIColor purpleColor];

    HKTrainDetailTaskCalendarModel * model = self.detailModel.date_list[temp];
    if (pageController.selectIndex == temp) {
        if (model.colorControl) {
            // 正在进行中的
            color =  HKColorFromHex(0xFFD305, 1.0);
        } else {
            color =  HKColorFromHex(0xA8ABBE, 1.0);
        }
    }
    pageController.menuView.progressView.color = CGColorCreateCopy(color.CGColor);
    [pageController.menuView.progressView setNeedsDisplay];
}


#pragma mark <Server>
- (void)getNewData {

    @weakify(self);
    NSString *trainingId = self.trainingId;
    NSDictionary *param = @{@"training_id" : trainingId};

    [HKHttpTool POST:HK_TrainingDatail_URL parameters:param success:^(id responseObject) {

        @strongify(self);
        if (HKReponseOK) {
            self.detailModel = [HKTrainDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.headerView.detailModel = self.detailModel;
            // 更新nav标题
            self.title = self.detailModel.name;

            // 设置VC
            NSMutableArray *arrayVC = [NSMutableArray array];
            NSMutableArray *arrayTitles = [NSMutableArray array];
            NSMutableArray *arrayMargins = [NSMutableArray array];
            [arrayMargins addObject:@13];
            int selectIndex = 0;
            for (int i = 0; i < self.detailModel.date_list.count; i++) {
                HKTrainDetailTaskCalendarModel *taskCalendarModel = self.detailModel.date_list[i];
                // 当前选中的index
                if (taskCalendarModel.is_open) {
                    selectIndex = i;
                }
                HKTrainSubVC *trainItemVC = [HKTrainSubVC new];
                WeakSelf
                trainItemVC.updateDataBlock = ^(HKTrainDetailModel * _Nonnull detailModel) {
                    weakSelf.detailModel = detailModel;
                };
                [arrayVC addObject:trainItemVC];
                
                trainItemVC.trainingId = self.trainingId;
                trainItemVC.date = taskCalendarModel.full_date;
                trainItemVC.taskCalendarModel = taskCalendarModel;
                trainItemVC.showWeChatCodeBlock = ^{
                    [weakSelf rightBarBtnAction];
                };
                // 标题
                NSString *title = [NSString stringWithFormat:@"%@", taskCalendarModel.week];
                [arrayTitles addObject:title];
                [arrayMargins addObject:i == self.detailModel.date_list.count - 1? @13 : @20];
            }
            self.itemsMargins = arrayMargins;
            self.titles = arrayTitles;
            self.viewcontrollers = arrayVC;

            if (self.viewcontrollers.count) {
                self.selectIndex = selectIndex;
                [self reloadData];
            }
        }

    } failure:^(NSError *error) {

    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
    
    if ([[CommonFunction topViewController] isKindOfClass:[HKTrainDetailVC class]]) {
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat offset = 138 * Ratio;
        NSLog(@"=======%f======%f",offsetY,offset);
        if (offsetY >= 137 * Ratio) {
            self.topView.hidden = NO;
            
            HKTrainDetailTaskCalendarModel *taskCalendarModel = self.detailModel.date_list[self.selectIndex];
            self.topView.taskCalendarModel = taskCalendarModel;
            self.topView.detailModel = self.detailModel;
        }else{
            self.topView.hidden = YES;
        }
    }
}

@end





