//
//  HKStudyMenuVC.m
//  Code
//
//  Created by eon Z on 2021/11/1.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKStudyMenuVC.h"
#import "HKMenuVC.h"



@interface HKStudyMenuVC ()
@property (nonatomic , assign) CGFloat kWMHeaderViewHeight ;
@property (nonatomic, copy) NSArray *viewcontrollers;
@property (nonatomic , strong) NSMutableArray * titleArray;

@end

@implementation HKStudyMenuVC

- (NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.headerView.backgroundColor = COLOR_F8F9FA_333D48;
    self.kWMHeaderViewHeight = 44;
//    [self.view addSubview:self.commentScoreView];
//    WeakSelf
//    [HKHttpTool POST:@"/video/get-video-comment-header" parameters:@{@"video_id":self.videoModel.video_id} success:^(id responseObject) {
//        if (HKReponseOK) {
//            NSString * works = [responseObject[@"data"][@"exercise_count"] intValue] ? [NSString stringWithFormat:@"作业(%@)",responseObject[@"data"][@"exercise_count"]]:@"作业";
//            NSString * question_count = [responseObject[@"data"][@"question_count"] intValue] ? [NSString stringWithFormat:@"提问(%@)",responseObject[@"data"][@"question_count"]]:@"提问";
//            weakSelf.titleArray = [[NSMutableArray alloc] initWithObjects:@"全部",works,question_count,nil];
//            weakSelf.commentScoreView.diff = responseObject[@"data"][@"diff"];
//            weakSelf.commentScoreView.score = responseObject[@"data"][@"score"];
//            weakSelf.pc_url = responseObject[@"data"][@"pc_url"];
//            [weakSelf prepareSetup];
//        }else{
//            showTipDialog(responseObject[@"msg"]);
//        }
//    } failure:^(NSError *error) {
//
//    }];
    [self prepareSetup];
}

- (void)menuTabProgressUI {
    self.menuViewStyle = WMMenuViewStyleDefault;
    self.progressColor = COLOR_fddb3c;
    self.progressWidth = 30;
    self.progressHeight = 4;
}

- (void)prepareSetup {
    NSMutableArray *arrayVC = [NSMutableArray array];
    for (int i  = 0; i < 4; i++) {
        //WeakSelf;
        HKMenuVC * menuVC = [HKMenuVC new];
        [arrayVC addObject:menuVC];
    }
    self.viewcontrollers = arrayVC;
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"VIP教程",@"直播",@"读书",@"超职套课", nil];
    self.controllerType = WMStickyPageControllerType_ordinary;
    self.menuItemWidth = 80;
    self.menuViewHeight = 40.0;
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 16;
    self.titleColorNormal = COLOR_7B8196_A8ABBE;
    self.titleColorSelected = COLOR_27323F_EFEFF6;
    self.maximumHeaderViewHeight = self.kWMHeaderViewHeight;
    self.minimumHeaderViewHeight = self.kWMHeaderViewHeight;
    self.bounces = NO;
    self.menuViewStyle = WMMenuViewStyleDefault;

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
//    if (index == 1) {
//        [MobClick event: detailpage_evaluate_task];
//    }else if(index == 2){
//        [MobClick event: detailpage_evaluate_question];
//    }
    return self.titleArray[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, self.maximumHeaderViewHeight+40, SCREEN_WIDTH, self.view.height-70-40);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, self.maximumHeaderViewHeight, SCREEN_WIDTH, 40);
}


@end
