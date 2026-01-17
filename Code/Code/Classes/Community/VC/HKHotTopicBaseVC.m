//
//  HKHotTopicBaseVC.m
//  Code
//
//  Created by Ivan li on 2021/1/20.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKHotTopicBaseVC.h"
#import "UIBarButtonItem+Extension.h"
#import "HKHotTopicHeaderView.h"
#import "HKRankVC.h"
#import "HKPostCommentView.h"
#import "HKMonmentTypeModel.h"
#import "HKPostMonmentVC.h"
#import "HKMomentDetailModel.h"
#import "WMPageController+Category.h"
#import "UMpopView.h"

@interface HKHotTopicBaseVC ()<UMpopViewDelegate>
@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;
@property (nonatomic , strong) NSArray * dataArray;
@property (nonatomic , strong) HKHotTopicHeaderView * headerView;
@property (nonatomic , assign) CGFloat kWMHeaderViewHeight ;
@property (nonatomic,strong) HKPostCommentView *bottomV ;

@property (nonatomic , strong) HKSubjectInfoModel * InfoModel;
@property (nonatomic , strong) NSMutableArray * orderArray;
@end

@implementation HKHotTopicBaseVC


- (void)menuTabProgressUI {
    self.menuViewStyle = WMMenuViewStyleLine;
    self.progressColor = COLOR_fddb3c;
    self.progressWidth = 30;
    self.progressHeight = 4;
}

- (NSMutableArray *)orderArray{
    if (_orderArray == nil) {
        _orderArray = [NSMutableArray array];
    }
    return _orderArray;
}


- (void)viewDidLoad {
    [self menuTabProgressUI];
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setTitle:@"热门话题"];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;


    self.hk_hideNavBarShadowImage = YES;
    UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"nac_back") darkImage:imageName(@"nac_back_dark")];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImage:image highBackgroudImage:image target:self action:@selector(backAction)];

    self.kWMHeaderViewHeight = 100 + ( IS_IPHONE_X ? 88 : 64);
    self.headerView = [HKHotTopicHeaderView viewFromXib];
    self.headerView.frame = CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, self.kWMHeaderViewHeight-KNavBarHeight64);
    self.headerView.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.view addSubview:self.headerView];
    WeakSelf
    self.headerView.didShareBlock = ^{
        [weakSelf shareWithUI:weakSelf.InfoModel.share_data];
    };
    
    [self loadHeaderData];
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImage:image highBackgroudImage:image target:self action:@selector(shareBtnItemAction)];
}

//- (void)shareBtnItemAction{
//    //  分享统计
//    //[MobClick event:UM_RECORD_HUKEDUSHU_DETAIL_PAGE_SHARE];
//    //[[HKALIYunLogManage sharedInstance]hkBookClickLogWithFlag:@"5" bookId:self.bookModel.book_id courseId:self.bookModel.course_id];
//    [self shareWithUI:self.InfoModel.share_data];
//}

/** 友盟分享 */
- (void)shareWithUI:(ShareModel *)model {
    UMpopView *popView = [UMpopView sharedInstance];
    popView.delegate = self;
    [popView createUIWithModel:model];
}


- (void)loadHeaderData{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.subjectId forKey:@"subject_id"];
    
    @weakify(self);
    [HKHttpTool POST:@"/community/subject-info" parameters:dic success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            self.InfoModel = [HKSubjectInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"subjectInfo"]];
            self.orderArray = [HKMonmentTagModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"order"]];
            self.headerView.info = self.InfoModel;
            self.bottomV.txtLabel.text = [NSString stringWithFormat:@"#%@#",self.InfoModel.name];
            [self prepareSetup];
        }else{
            showTipDialog(responseObject[@"msg"]);
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.bottomV = [HKPostCommentView viewFromXib];
    WeakSelf
    self.bottomV.didTapClickBlock = ^{
        [weakSelf checkBindPhone:^{
            HKPostMonmentVC* vc = [[HKPostMonmentVC alloc] init];
            HKMonmentTagModel * model = [[HKMonmentTagModel alloc] init];
            model.name = weakSelf.InfoModel.name;
            model.ID = weakSelf.InfoModel.ID;
            vc.topicModel = model;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } bindPhone:^{

        }];
    };
    self.bottomV.frame = CGRectMake(0, self.view.height - 50 - TAR_BAR_XH, SCREEN_WIDTH, 50+ TAR_BAR_XH);
    [[UIApplication sharedApplication].keyWindow addSubview:self.bottomV];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.bottomV removeFromSuperview];
    self.bottomV = nil;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


/*************************  UIViewController **************************/

- (void)prepareSetup {
    NSMutableArray *arrayVC = [NSMutableArray array];
    for (int i  = 0; i < self.orderArray.count; i++) {
        HKMonmentTagModel * tagModel = self.orderArray[i];
        HKRankVC *VC =  [[HKRankVC alloc] init];
        VC.subjectId = self.subjectId;//[NSString stringWithFormat:@"%@",self.tagModel.ID];
        VC.orderById = [NSString stringWithFormat:@"%@",tagModel.ID];
        VC.InfoModel = self.InfoModel;
        WeakSelf
        VC.pushPostBlock = ^{
            HKPostMonmentVC* vc = [[HKPostMonmentVC alloc] init];

            HKMonmentTagModel * model = [[HKMonmentTagModel alloc] init];
            model.name = weakSelf.InfoModel.name;
            model.ID = weakSelf.InfoModel.ID;
            vc.topicModel = model;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        [arrayVC addObject:VC];
    }
    self.viewcontrollers = arrayVC;
    //self.automaticallyCalculatesItemWidths = YES;
    self.menuViewHeight = 40.0;
    self.titleSizeNormal = 16;
    self.titleSizeSelected = 16;
    self.titleColorNormal = COLOR_7B8196_A8ABBE;
    self.titleColorSelected = COLOR_27323F_EFEFF6;
    self.menuItemWidth = SCREEN_WIDTH * 0.3;
    self.maximumHeaderViewHeight = self.kWMHeaderViewHeight;
    self.minimumHeaderViewHeight = KNavBarHeight64;
    //self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
    //self.menuViewStyle = WMMenuViewStyleDefault;
    self.controllerType = WMStickyPageControllerType_videoDetail;

    self.bounces = NO;

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
    if (index == 1) {
        [MobClick event: community_topic_tab_hot];
    }
    HKMonmentTagModel * tagModel = self.orderArray[index];
    return tagModel.name;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, self.maximumHeaderViewHeight+40, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, self.maximumHeaderViewHeight, SCREEN_WIDTH, 40);
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


- (void)uMShareImageFail:(id)sender {
    
}
@end
