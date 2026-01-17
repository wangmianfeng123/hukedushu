//
//  HKInteractionVC.m
//  Code
//
//  Created by eon Z on 2021/9/1.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKInteractionVC.h"
#import "NewVideoCommentVC.h"
#import "HKCommentScoreView.h"
#import "HKVideoEvaluationVC.h"

@interface HKInteractionVC ()
@property (nonatomic , strong) DetailModel * videoModel;
@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;
@property (nonatomic , strong) NSArray * dataArray;
@property (nonatomic , assign) CGFloat kWMHeaderViewHeight ;
@property (nonatomic , strong) HKCommentScoreView * commentScoreView;
@property (nonatomic , strong) NSMutableArray * titleArray;
@property (nonatomic , copy)NSString * pc_url;
@end

@implementation HKInteractionVC

- (instancetype)initWithDetailModel:(DetailModel*)model{
    if ([super init]) {
        _videoModel = model;
    }
    return self;
}

- (HKCommentScoreView*)commentScoreView {
    if (!_commentScoreView) {
        WeakSelf;
        _commentScoreView = [[HKCommentScoreView alloc]init];
        if (IS_IPAD) {
            _commentScoreView.frame = CGRectMake(iPadContentMargin, 0, iPadContentWidth, 70);
        }else{
            _commentScoreView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
        }
        _commentScoreView.commentScoreViewBlock = ^(id sender) {
            [weakSelf pushToCommentVC];
        };
    }
    return _commentScoreView;
}

- (void)menuTabProgressUI {
    self.menuViewStyle = WMMenuViewStyleDefault;
    self.progressColor = COLOR_fddb3c;
    self.progressWidth = 30;
    self.progressHeight = 4;
    
    
}

- (void)setCommentWithModel:(DetailModel*)model {
    self.videoModel = model;
//    if (self.dataArray) {
//        [self.dataArray removeAllObjects];
//        [self.tableView reloadData];
//    }
//    // 加载评论数据
//    [self getVideoCommentWithToken:nil videoId:self.videoId page:@"1"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.headerView.backgroundColor = COLOR_F8F9FA_333D48;
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    self.kWMHeaderViewHeight = 70;
    [self.view addSubview:self.commentScoreView];
    [MyNotification addObserver:self selector:@selector(updataVideoCommentCount) name:@"refreshVideoCommentData" object:nil];
    WeakSelf
    [HKHttpTool POST:@"/video/get-video-comment-header" parameters:@{@"video_id":self.videoModel.video_id} success:^(id responseObject) {
        if (HKReponseOK) {
            NSString * works = [responseObject[@"data"][@"exercise_count"] intValue] ? [NSString stringWithFormat:@"作业(%@)",responseObject[@"data"][@"exercise_count"]]:@"作业";
            NSString * question_count = [responseObject[@"data"][@"question_count"] intValue] ? [NSString stringWithFormat:@"提问(%@)",responseObject[@"data"][@"question_count"]]:@"提问";
            weakSelf.titleArray = [[NSMutableArray alloc] initWithObjects:@"全部",works,question_count,nil];
            weakSelf.commentScoreView.diff = responseObject[@"data"][@"diff"];
            weakSelf.commentScoreView.score = responseObject[@"data"][@"score"];
            weakSelf.pc_url = responseObject[@"data"][@"pc_url"];
            [weakSelf prepareSetup];
        }else{
            showTipDialog(responseObject[@"msg"]);
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)prepareSetup {
    NSMutableArray *arrayVC = [NSMutableArray array];
    for (int i  = 0; i < 3; i++) {
        WeakSelf;
        NewVideoCommentVC * videoCommentVC = [[NewVideoCommentVC alloc]initWithDetailModel:self.videoModel];
        videoCommentVC.type = i;
        videoCommentVC.pc_url =self.pc_url;
        videoCommentVC.commentCountChangeBlock = ^(NSString *count) {
            [weakSelf updataVideoCommentCount];
        };
        [arrayVC addObject:videoCommentVC];
    }
    self.viewcontrollers = arrayVC;
    self.controllerType = WMStickyPageControllerType_ordinary;
    self.menuItemWidth = 80;
    self.menuViewHeight = 40.0;
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 16;
    self.titleColorNormal = COLOR_7B8196_A8ABBE;
    self.titleColorSelected = COLOR_27323F_EFEFF6;
    self.maximumHeaderViewHeight = self.kWMHeaderViewHeight;
    self.minimumHeaderViewHeight = 0;
    self.bounces = NO;
    self.menuViewStyle = WMMenuViewStyleDefault;

    [self reloadData];
}

- (void)updataVideoCommentCount{
    WeakSelf
    [HKHttpTool POST:@"/video/get-video-comment-header" parameters:@{@"video_id":self.videoModel.video_id} success:^(id responseObject) {
        if (HKReponseOK) {
            NSString * works = [responseObject[@"data"][@"exercise_count"] intValue] ? [NSString stringWithFormat:@"作业(%@)",responseObject[@"data"][@"exercise_count"]]:@"作业";
            NSString * question_count = [responseObject[@"data"][@"question_count"] intValue] ? [NSString stringWithFormat:@"提问(%@)",responseObject[@"data"][@"question_count"]]:@"提问";
            [weakSelf updateTitle:works atIndex:1];
            [weakSelf updateTitle:question_count atIndex:2];
            NSString * video_reply = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"video_reply"]];
            weakSelf.CommentCountChangeBlock(video_reply);

        }else{
            showTipDialog(responseObject[@"msg"]);
        }
    } failure:^(NSError *error) {
        
    }];
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

- (void)pageController:(WMPageController *)pageController menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index
          currentIndex:(NSInteger)currentIndex{
    if (index == 1) {
        [MobClick event: detailpage_evaluate_task];
    }else if(index == 2){
        [MobClick event: detailpage_evaluate_question];
    }
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    if (IS_IPAD) {
        return CGRectMake(iPadContentMargin, self.maximumHeaderViewHeight+40, iPadContentWidth, self.view.height-50-44);
    }else{
        return CGRectMake(0, self.maximumHeaderViewHeight+40, SCREEN_WIDTH , self.view.height-(IS_IPHONE_X ?70 :50)-44);
    }
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    if (IS_IPAD) {
        return CGRectMake(iPadContentMargin, self.maximumHeaderViewHeight, iPadContentWidth, 40);

    }else{
        return CGRectMake(0, self.maximumHeaderViewHeight, SCREEN_WIDTH , 40);
    }
}

#pragma mark - commentBottomView 代理
- (void)pushToCommentVC {
    
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    
    if ([self.videoModel.is_play isEqualToString:@"1"]) {
        //is_play：1-可以评论 0-不可以评论
        WeakSelf;
        [self checkBindPhone:^{
            StrongSelf;
            [strongSelf setEvaluationVC];
        } bindPhone:^{
            
        }];
        
    }else{
        showTipDialog(@"学习后才能评价哦～");
    }
}

- (void)setEvaluationVC {
    HKVideoEvaluationVC *VC = [[HKVideoEvaluationVC alloc]initWithNibName:nil bundle:nil videoId:self.videoModel.video_id];
    //VC.delegate = self;
    [self pushToOtherController:VC];
}

- (void)pushToOtherController:(UIViewController*)VC {
    [self pushToViewController:VC animated:YES];
}

- (void)pushToViewController:(UIViewController*)VC  animated:(BOOL)animated {
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:animated];
}

- (void)dealloc {
    NSLog(@"控制器销毁 =%@",[self class]);
    
    HK_NOTIFICATION_REMOVE();
}
@end
