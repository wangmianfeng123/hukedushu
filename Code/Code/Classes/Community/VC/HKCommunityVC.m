//
//  HKCommunityVC.m
//  Code
//
//  Created by Ivan li on 2021/1/18.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKCommunityVC.h"
#import "HKCommunityAllVC.h"
#import "WMPageController+Category.h"
#import "HKPostSuspensionView.h"
#import "HKPostMonmentVC.h"
#import "HKAttentionVC.h"
#import "HKMomentRankVC.h"
#import "HKMonmentTypeModel.h"
#import "WMPageController+Category.h"
#import "HKMessageCenterVC.h"

@interface HKCommunityVC ()<UITabBarControllerDelegate>
@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;
@property (nonatomic , strong) UIButton *  postCommentBtn;
@property (nonatomic , strong) HKMonmentTabModel * tabModel;
@property (nonatomic, assign) BOOL isFromHome;  //如果是tab上需要隐藏按钮
@property (nonatomic, copy) NSString * isTabModule;  //如果是tab上需要隐藏按钮
@property(nonatomic,assign)int i;
@property (nonatomic , strong) UILabel * tipCountLabel;
@property (nonatomic , strong) UIButton * moreButton;
@end

@implementation HKCommunityVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.postCommentBtn.hidden = NO;
    self.i=0;
    
    UIImage *image = [UIImage coustomSizeImageWithColor:COLOR_FFFFFF_3D4752 size:CGSizeMake(SCREEN_WIDTH, 0.5)];
    [[UINavigationBar appearance] setShadowImage:image];
    self.navigationController.navigationBar.barTintColor = NAVBAR_Color;
    
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    WeakSelf
    [HKHttpTool POST:@"/community/index" parameters:nil success:^(id responseObject) {
        if ([CommonFunction detalResponse:responseObject]) {
            weakSelf.tabModel = [HKMonmentTabModel mj_objectWithKeyValues:responseObject[@"data"]];
//            HKMonmentTypeModel * model = self.tabModel.tabs.lastObject;
//            [self.tabModel.tabs addObject:model];
//            [self.tabModel.tabs addObject:model];
//            [self.tabModel.tabs addObject:model];
            [weakSelf setBadge];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
//    self.tabBarController.delegate=self;
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
        
    self.postCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IS_IPAD) {
        self.postCommentBtn.frame = CGRectMake(SCREEN_WIDTH - 90, SCREEN_HEIGHT - KTabBarHeight49 - 110, 80, 80);
    }else{
        self.postCommentBtn.frame = CGRectMake(SCREEN_WIDTH - 62* Ratio, SCREEN_HEIGHT - KTabBarHeight49 - 80* Ratio, 54 * Ratio, 54* Ratio);
    }
    [self.postCommentBtn setBackgroundImage:[UIImage imageNamed:@"ic_question_2_35"] forState:UIControlStateNormal];
    [self.postCommentBtn addTarget:self action:@selector(postCommentClick) forControlEvents:UIControlEventTouchDown];
    [[UIApplication sharedApplication].keyWindow addSubview:self.postCommentBtn];
    
    if (![self.isTabModule isEqualToString:@"1"]) {
        [self setLeftBarButtonItem];
    }

    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadData];
    
    
}

- (void)postCommentClick{
    if (isLogin()) {
        [MobClick event: community_publish_question];

        WeakSelf
        [self checkBindPhone:^{
            HKPostMonmentVC* vc = [[HKPostMonmentVC alloc] init];
            HKMonmentTagModel * model= [[HKMonmentTagModel alloc] init];
            model.ID = [NSNumber numberWithInt:1];
            model.name = @"提问答疑";
            vc.topicModel = model;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        } bindPhone:^{
            
        }];
    }else{
        [self setLoginVC];
    }
    [MobClick event: community_publish];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.postCommentBtn.hidden = YES;
}

/*************************  UIViewController **************************/
- (void)prepareSetup {
    [super prepareSetup];
    NSMutableArray *arrayVC = [NSMutableArray array];
    
    NSMutableArray * titleArry = [NSMutableArray array];
    for (HKMonmentTypeModel * typeModel in self.tabModel.tabs) {
        if ([typeModel.type intValue]==1) {//关注
            HKAttentionVC * vc = [HKAttentionVC new];
            vc.tabModel = self.tabModel;
            vc.typeModel = typeModel;
            WeakSelf
            vc.didTagBtnBlock = ^(int index) {
                weakSelf.selectIndex = index;
            };
            [arrayVC addObject:vc];
        } else if (typeModel.order.count ) {
            HKMomentRankVC *rankVC= [[HKMomentRankVC alloc] init];
            rankVC.tabModel = self.tabModel;
            rankVC.typeModel = typeModel;
            [arrayVC addObject:rankVC];
        }else{

            HKCommunityAllVC *VC =  [[HKCommunityAllVC alloc] init];
            VC.tabModel = self.tabModel;
            VC.typeModel = typeModel;
            WeakSelf
            VC.didTagBtnBlock = ^(int index) {
                weakSelf.selectIndex = index;
            };
            [arrayVC addObject:VC];
            
        }
        [titleArry addObject:typeModel.name];
    }
    
    NSMutableArray * widthArray = [NSMutableArray array];
    for (int i = 0 ; i < titleArry.count; i++) {
        NSString * name = titleArry[i];
        if (i == 0) {
            [widthArray addObject:@90];
        }else if (name.length == 2){
            [widthArray addObject:@45];
        }else if (name.length == 3){
            [widthArray addObject:@55];
        }else if (name.length == 4){
            [widthArray addObject:@70];
        }else if (name.length == 5){
            [widthArray addObject:@80];
        }
    }
    
    self.viewcontrollers = arrayVC;
    //self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
//    self.automaticallyCalculatesItemWidths = YES;
    self.itemMargin = 10;
    self.itemsWidths = widthArray;
    self.titleSizeNormal = 16;
    self.titleSizeSelected = 16;
    self.titleColorNormal = COLOR_7B8196_A8ABBE;
    self.titleColorSelected = COLOR_27323F_EFEFF6;
    self.menuColorNormal = COLOR_FFFFFF_3D4752;
    self.menuView.backgroundColor = COLOR_FFFFFF_3D4752;

    //self.selectIndex = self.currentIndex;
    [self reloadData];
}


#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.viewcontrollers.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    NSLog(@"%ld-------",index);
    return self.viewcontrollers[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    HKMonmentTypeModel * model = self.tabModel.tabs[index];
    if ([model.type intValue]==1) {
        [MobClick event: community_follow_tab];
    }else if ([model.type intValue] == 2){
        if (model.page_filter.count) {
            for (HKParameterModel * paraM in model.page_filter) {
                if ([paraM.ParameterName isEqualToString:@"replies"]) {
                    if ([paraM.ParameterValue intValue] == 0) {
                        [MobClick event: community_question_select];
                    }else if ([paraM.ParameterValue intValue] == 1) {
                        [MobClick event: community_question_answered];
                    }else if ([paraM.ParameterValue intValue] == 2) {
                        [MobClick event: community_question_unanswered];
                    }
                }
            }
        }
    }else if ([model.type intValue] == 3){
        [MobClick event: community_task_tab];
    }else if ([model.type intValue] == 4){
        [MobClick event: community_works_tab];
    }else if ([model.type intValue] == 5){
        [MobClick event: community_personal_tab];
    }
    
    return model.name;
}

- (void)pageController:(WMPageController *)pageController menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index
          currentIndex:(NSInteger)currentIndex{
    NSLog(@"%ld=========%ld",index,currentIndex);
}

- (BOOL)menuView:(WMMenuView *)menu shouldSelesctedIndex:(NSInteger)index{
    NSLog(@"%ld*********",index);
    return YES;
}


- (BOOL)pageController:(WMStickyPageController *)pageController shouldScrollWithSubview:(UIScrollView *)subview {
    return NO;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,STATUS_BAR_EH, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_EH);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    self.moreButton = menuView.moreButton;
    [menuView.moreButton setImage:[UIImage hkdm_imageWithNameLight:@"ic_message_chosen_2_35" darkImageName:@"ic_message_chosen_dark_2_35"] forState:UIControlStateNormal];
    UIColor *darkColor = [UIColor colorWithRed:61/255.0 green:71/255.0 blue:82/255.0  alpha:1.0];
    [menuView.moreButton setBackgroundColor:[UIColor dm_colorWithLightColor:[UIColor whiteColor] darkColor:darkColor]];
    [self setBadge];
//    menuView.neededRefresh = NO;
    return CGRectMake(IS_IPAD ? iPadContentMargin : 0, STATUS_BAR_EH, IS_IPAD ? iPadContentWidth : SCREEN_WIDTH, 40);
}

- (void)setBadge{
    [self.tipCountLabel removeFromSuperview];
    if ([self.tabModel.message_count intValue] > 99) {
        self.tipCountLabel.text = @"99+";
        self.tipCountLabel.frame = CGRectMake(self.moreButton.width - 32, 0, 30, 16);
        [self.moreButton addSubview:self.tipCountLabel];

    }else if ([self.tabModel.message_count intValue] > 0){
        self.tipCountLabel.text = [NSString stringWithFormat:@"%@",self.tabModel.message_count];
        self.tipCountLabel.frame = CGRectMake(self.moreButton.width - 30, 0, 16, 16);
        [self.moreButton addSubview:self.tipCountLabel];
    }
}

- (void)menuView:(WMMenuView *)menu moreButtonClick:(UIButton *)button {
    
    if (isLogin()) {
        [self.tipCountLabel removeFromSuperview];
        HKMessageCenterVC * vc = [HKMessageCenterVC new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        [MobClick event: community_message];
    }else{
        [self setLoginVC];
    }
    
}

- (WMMenuItem *)menuView:(WMMenuView *)menu initialMenuItem:(WMMenuItem *)initialMenuItem atIndex:(NSInteger)index{
    if (index == 0) {
        HKMonmentTypeModel * model = self.tabModel.tabs[index];
        NSString *contentString =  model.name;
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
        attchment.bounds = CGRectMake(0, -5, 20, 20);//设置frame
        attchment.image = [UIImage hkdm_imageWithNameLight:@"ic_hot_chosen_2_35" darkImageName:@"ic_hot_chosen_2_35"];//[UIImage imageNamed:@""];//设置图片

        //4.创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
        [attrString insertAttributedString:string atIndex:0];//插入到第几个下标
        initialMenuItem.attributedText = attrString;
    }
    return initialMenuItem;
}


- (void)loadData{
    [HKHttpTool POST:@"/community/index" parameters:nil success:^(id responseObject) {
        if ([CommonFunction detalResponse:responseObject]) {
            self.tabModel = [HKMonmentTabModel mj_objectWithKeyValues:responseObject[@"data"]];
//            HKMonmentTypeModel * model = self.tabModel.tabs.lastObject;
//            [self.tabModel.tabs addObject:model];
//            [self.tabModel.tabs addObject:model];
//            [self.tabModel.tabs addObject:model];
            
//            NSMutableArray * array = self.tabModel.tabs;
//            if (array.count > 4) {
//                NSMutableArray *  ary = (NSMutableArray *)[array subarrayWithRange:NSMakeRange(0, 4)];
//                self.tabModel.tabs = ary;
//            }else{
//                self.tabModel.tabs = array;
//            }
            
            
            [self prepareSetup];
        }
    } failure:^(NSError *error) {
        
    }];
}

//双击处理,这里双击是指的点击两次，当然可以不连续。如果非要做到那种连续快速点击两次，我们还要做一个点击间隔的时间判断，这个少尉麻烦一点就不去试了，原谅我的懒惰.有兴趣的同学可以用时间戳来实现，用一个全局变量记录第一次点击时间，然后和第二次点击时间对比，如果间隔在自己设置的连续点击时间内（比如我们认为两次点击时间间隔在1秒内认为就是双击），就判断为双击，否则就认为单击，让第二次点击时间在赋给那个全局变量接着做判断，当然这里还有一些比如三连击等，要注意在判断双击之后再做一次判断以防三连击当成两次双击做处理了就行了。
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    //双击处理
//    UINavigationController *navdid=tabBarController.selectedViewController;
//    UINavigationController *nav=(UINavigationController*)viewController;
//    if (![navdid.topViewController isEqual:self]) {
//        self.i--;
//    }
//
//    if ([nav.topViewController isEqual:self]) {
//        self.i++;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.i=0;
//        });
//    }
//    if (self.i==3) {
//        self.i=0;
//        NSLog(@"点击两次");
//        
//        NSInteger index = self.selectIndex;
//        UIViewController * vc = self.viewcontrollers[index];
//        if ([vc isKindOfClass:[HKCommunityAllVC class]]){
//            HKCommunityAllVC * controller = (HKCommunityAllVC *)vc;
//            [controller refreshTableView];
//        }
//    }
//    return YES;
//}

-(UILabel *)tipCountLabel{
    if (_tipCountLabel == nil) {
        _tipCountLabel  = [[UILabel alloc] init];
        _tipCountLabel.textColor = COLOR_ffffff;
        _tipCountLabel.font = HK_FONT_SYSTEM(10);
        _tipCountLabel.textAlignment = NSTextAlignmentCenter;
        _tipCountLabel.backgroundColor = [UIColor colorWithHexString:@"#FF4E4E"];
        _tipCountLabel.clipsToBounds = YES;
        _tipCountLabel.layer.cornerRadius = 8;
    }
    return _tipCountLabel;
}

@end
