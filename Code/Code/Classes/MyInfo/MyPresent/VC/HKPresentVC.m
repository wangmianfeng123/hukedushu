//
//  HKPresentVC.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/8.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKPresentVC.h"
#import "HKPresentHeader.h"
#import "HKPresentHeaderModel.h"
#import "HKMoreCoinCell.h"
#import "HKLuckPriceVC.h"
#import "HKLuckyResultView.h"
#import "LearnedVC.h"
#import "HKGoodsContainerCell.h"
#import "HKGoodsDetailVC.h"
#import "HKPresentHeader21.h"
#import "HKPrecentCell21.h"
#import "HtmlShowVC.h"
#import "HKPrecentImageShareVC.h"
#import "HKArticleDetailVC.h"
#import "VideoPlayVC.h"
#import "HKBookModel.h"
#import "HKPushNoticeModel.h"
#import "HKPushNotiTimeVC.h"
#import "AppDelegate.h"

@interface HKPresentVC ()<UITableViewDelegate, UITableViewDataSource, HKGoodsContainerCellDelegate, HKPresentHeader21Delegate>

@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)HKPresentHeaderModel *model;
@property (nonatomic, strong)HMMallDataModel *mallData;
@property (nonatomic, strong)HKMapModel *mapModel;
@end

@implementation HKPresentVC


- (instancetype)init {
    if (self = [super init]) {
        //登录成功通知
        HK_NOTIFICATION_ADD(HKLoginSuccessNotification, loginSuccessNotification);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:HKPresentVCRefreshNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    self.title = @"签到";
    [self createLeftBarButton];
    [self setupTabblewView];
    //[self getData];
    self.zf_prefersNavigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_F6F6F6 dark:COLOR_333D48];
    self.tableView.backgroundColor = COLOR_F6F6F6_3D4752;
    self.tableView.separatorColor = COLOR_FFFFFF_333D48;
}

- (void)loginSuccessNotification{
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}

- (void)setupTabblewView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.frame = self.view.bounds;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    MJRefreshHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    mj_header.automaticallyChangeAlpha = YES;
    tableView.mj_header = mj_header;
    tableView.backgroundColor = HKColorFromHex(0xf6f6f6, 1.0);
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    
    // 兼容iOS11
    HKAdjustsScrollViewInsetNever(self, tableView);
    
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKMoreCoinCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKMoreCoinCell class])];
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKGoodsContainerCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKGoodsContainerCell class])];
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKPrecentCell21 class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKPrecentCell21 class])];
    
    
    // 添加头部
//    HKPresentHeader *headerView = [HKPresentHeader viewFromXib];
//    headerView.delegate = self;
//    headerView.height = 274.5 + 49.0;
//    headerView.width = self.view.width;
//    tableView.tableHeaderView = headerView;
    WeakSelf;
    HKPresentHeader21 *headerView = [HKPresentHeader21 viewFromXib];
    headerView.delegate = self;
    headerView.medalBtnClickBlock = ^{
        if (isLogin()) {
            HKMapModel *mapModel = self.mapModel;
                if (!isEmpty(mapModel.redirect_package.class_name)) {
                    [HKH5PushToNative runtimePush:mapModel.redirect_package.class_name arr:mapModel.redirect_package.list currectVC:weakSelf];
                }
        }else{
            [weakSelf setLoginVC];
        }
    };
    
    headerView.btnStoreClickBlock = ^{
        
        //商城
        NSString *url = weakSelf.mallData.url;
        if (isEmpty(url)) { return;}

        HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:url];
        [weakSelf pushToOtherController:htmlShowVC];
        
//        [weakSelf enterLuckVC];
    };
    
    headerView.continueDaysViewTapBlock = ^{
        if (weakSelf.model.is_show == 2) {
            [weakSelf enterLuckVC]; // 签到
        } else {
            [weakSelf addShareImageVC:nil]; // 分享
        }
    };
        
    headerView.setBtnBlock = ^{
        HKPushNotiTimeVC * VC = [HKPushNotiTimeVC new];
        VC.key = @"checkinNotify";
        VC.j_push_hour = self.model.sign_notify_hour; //.j_push_hour;
        VC.j_push_type = self.model.sign_notify_type; //.j_push_type;
        VC.j_push_hour_type = self.model.sign_notify_hour_type; //.j_push_hour_type;
        [weakSelf pushToOtherController:VC];
    };
    
    // 连续签到提醒
    headerView.switchClickBlock = ^(BOOL isOn) {
        [weakSelf continuePresentDays:isOn];
    };
    headerView.height = IS_IPHONE_X? 482 + 20 + 16 + 68 + 31: 482 + 16 + 63 + 31;
    headerView.width = self.view.width;
    tableView.tableHeaderView = headerView;
}

#pragma  mark <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.model.goods_list) {
//        return self.model.moreCoinArray.count + 1;
//    }
//    return self.model.moreCoinArray.count;
    return self.model.task_list[section].list.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.task_list.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = COLOR_FFFFFF_3D4752;
    headerView.height = 45.0;
    
    // 小红点
    UILabel *redLabel = [[UILabel alloc] init];
    redLabel.size = CGSizeMake(7.5, 7.5);
    redLabel.backgroundColor = HKColorFromHex(0xFF3221, 1.0);
    redLabel.clipsToBounds = YES;
    redLabel.layer.cornerRadius = redLabel.height * 0.5;
    redLabel.centerY = 35 * 0.5 + 5;
    redLabel.x = 15.0;
    [headerView addSubview:redLabel];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.model.task_list[section].title;
    titleLabel.textColor = COLOR_27323F_EFEFF6;
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    [titleLabel sizeToFit];
    titleLabel.centerY = redLabel.centerY;
    titleLabel.x = CGRectGetMaxX(redLabel.frame) + 6;
    [headerView addSubview:titleLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKPrecentCell21 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKPrecentCell21 class])];
    HKTasktModel *tasktModel = self.model.task_list[indexPath.section];
    cell.model = tasktModel.list[indexPath.row];
    WeakSelf;
    cell.btnClickBlock = ^(HKTasktModel *model) {
        StrongSelf;
        
        if ([model.class_object.class_name isEqualToString:@"HKAllLearnedVC"]) {
            [strongSelf.navigationController popToRootViewControllerAnimated:NO];
            UITabBarController *tbc = (UITabBarController *)[AppDelegate sharedAppDelegate].window.rootViewController;
            tbc.selectedIndex = 3;
            HK_NOTIFICATION_POST(HKPushAllLearnNotification, nil);
        }else{
            [HKH5PushToNative runtimePush:model.class_object.class_name arr:model.class_object.list currectVC:strongSelf];
        }
        [strongSelf umRecord:model];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKTasktModel *tasktModel = self.model.task_list[indexPath.section];
    HKTasktModel *modelTemp = tasktModel.list[indexPath.row];
    
    if ([modelTemp.class_object.class_name isEqualToString:@"HKAllLearnedVC"]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        UITabBarController *tbc = (UITabBarController *)[AppDelegate sharedAppDelegate].window.rootViewController;
        tbc.selectedIndex = 3;
        HK_NOTIFICATION_POST(HKPushAllLearnNotification, nil);
    }else{
        [HKH5PushToNative runtimePush:modelTemp.class_object.class_name arr:modelTemp.class_object.list currectVC:self];
    }
    
    [self umRecord:modelTemp];
}


#pragma mark - 友盟统计
- (void)umRecord:(HKTasktModel *)model {
//    1  学习新教程  2  评价已学教程   3  分享教程给好友  4  完善职业资料   5  绑定手机 6  绑定微信 7  绑定QQ 8  绑定微博
    NSInteger row = [model.ID intValue];
        switch (row) {
            case 1:
                [MobClick event:UM_RECORD_TSKCENTER_LEARN];
                break;
            case 2:
                [MobClick event:UM_RECORD_TSKCENTER_EVALUATE];
                break;
            case 3:
                [MobClick event:UM_RECORD_TSKCENTER_SHARE];
                break;
            case 4:
                [MobClick event:UM_RECORD_TSKCENTER_JOB];
                break;
            case 5:
                [MobClick event:UM_RECORD_TSKCENTER_PHONE];
                break;
            case 6:
                [MobClick event:UM_RECORD_TSKCENTER_WECHAT];
                break;
            case 7:
                [MobClick event:UM_RECORD_TSKCENTER_QQ];
                break;
            case 8:
                [MobClick event:UM_RECORD_TSKCENTER_WEIBO];
                break;
        }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 121.0 * 0.5;
}

#pragma  mark <UITableViewDelegate>

#pragma  mark <Server>


// 连续签到
- (void)continuePresentDays:(BOOL)isOn {
    
    [HKHttpTool POST:@"/setting/switch-option" parameters:@{@"key" : @"checkinNotify"} success:^(id responseObject) {
        
        if ([CommonFunction detalResponse:responseObject]) {
            showTipDialog(isOn? @"设置成功" : @"关闭成功");
            self.model.is_sign_notify = isOn;
            
            NSMutableArray * arry = [NSKeyedUnarchiver unarchiveObjectWithFile:PushNoticeModelFile];
            for (HKPushNoticeModel * noticeModel in arry) {
                if ([noticeModel.key isEqualToString:@"checkinNotify"]) {
                    noticeModel.value = self.model.is_sign_notify;
                    [NSKeyedArchiver archiveRootObject:arry toFile:PushNoticeModelFile];
                }
            }
            
            
            if (isOn) {
                [MobClick event:UM_RECORD_TSKCENTER_REMIND];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)addShareImageVC:(HKPresentHeaderModel *)model {
    
    // 防止网络延迟model为空
    model = model? model : self.model;
    if (!model) return;
    
    HKPrecentImageShareVC *VC = [[HKPrecentImageShareVC alloc] init];
    
    @weakify(self);
    VC.recBlockClick = ^{
        @strongify(self);
        [MobClick event:UM_RECORD_TSKCENTER_SUCCESS_RECOMMEND];
        
        // 视频教程
        if (self.model.rec.type == 1) {
            VideoModel *model = self.model.rec.video;
            VideoPlayVC *VC = [[VideoPlayVC alloc] initWithNibName:nil bundle:nil fileUrl:model.img_cover_url
                                                        videoName:model.title
                                                 placeholderImage:model.img_cover_url
                                                       lookStatus:LookStatusInternetVideo videoId:model.video_id model:model];
            [self pushToOtherController:VC];
            
        } else if (self.model.rec.type == 2) {
            
            // 推荐文章
            HKArticleDetailVC *vc = [[HKArticleDetailVC alloc] init];
            vc.articleId = self.model.rec.article.ID;
            [self pushToOtherController:vc];
        }else if (self.model.rec.type == 3) {
            // 推荐读书
            [HKH5PushToNative runtimePush:self.model.rec.book.redirect_package.class_name arr:self.model.rec.book.redirect_package.list currectVC:self];
        }
    };
    VC.model = model;
    [self addChildViewController:VC];
    VC.view.frame = self.view.bounds;
    [self.view addSubview:VC.view];
}

- (void)enterLuckVC {
    WeakSelf;
    HKLuckPriceVC *VC = [[HKLuckPriceVC alloc] init];
    VC.model2 = self.model;
    VC.luckCompleteBlock = ^(HKPresentHeaderModel *model) {
        [weakSelf addShareImageVC:model];
    };
    VC.modelArray = self.model.reward_list;
    [self addChildViewController:VC];
    VC.view.frame = self.view.bounds;
    [self.view addSubview:VC.view];
}

- (void)getData {
    
    if (![HKAccountTool shareAccount]) {
        showTipDialog(@"请登录");
        return;
    }
    @weakify(self);
    [HKHttpTool POST:@"/activity/sign" parameters:nil success:^(id responseObject) {
        
        @strongify(self);
        HKPresentHeaderMoreCoinModel *child1 = [[HKPresentHeaderMoreCoinModel alloc] init];
        child1.title = @"认真评价已学教程";
        
        if (!HKReponseOK) return;
        
        HMMallDataModel *mallData = [HMMallDataModel mj_objectWithKeyValues:responseObject[@"data"][@"mall_data"]];
        HKMapModel *mapModel = [HKMapModel mj_objectWithKeyValues:responseObject[@"data"][@"achievement_redirect"]];
        self.mapModel = mapModel;
        self.mallData = mallData;
        HKPresentHeader21 *headerView = (HKPresentHeader21 *)self.tableView.tableHeaderView;
        headerView.hkStoreBtn.hidden = !mallData.is_show;
        
        child1.is_finish = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"is_comment"]].intValue == 1;
        child1.coinCount = @"30";
        
        HKPresentHeaderMoreCoinModel *child2 = [[HKPresentHeaderMoreCoinModel alloc] init];
        child2.title = @"绑定手机号";
        child2.is_finish = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"is_bind"]].intValue == 1;;
        child2.coinCount = @"100";
        
        HKPresentHeaderModel *model = [HKPresentHeaderModel mj_objectWithKeyValues:responseObject[@"data"]];
        model.moreCoinArray = @[child1, child2];
        
        // 推荐视频或者推荐文章
        if (model.rec.ID) {
            model.rec.video.ID = model.rec.video.video_id = model.rec.ID;
            model.rec.article.ID = model.rec.ID;
        }
        
        self.model = model;
        //            model.continue_num = @"3";
//        HKPresentHeader21 *headerView = (HKPresentHeader21 *)self.tableView.tableHeaderView;
        
        
        // 商品列表
        model.goods_list = [HKGoodsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"goods_list"]];
        model.task_list = [HKTasktModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"task_list"]];
        
//        ******* 模拟数据 *******
//        HKGoodsModel *model11 = [[HKGoodsModel alloc] init];
//        model11.title = @"全站通VIP 3天 限时抢购";
//        model11.goods_id = @"123";
//        model11.price = @"1000";
//        model11.stock = @"99";
//        model11.image = @"https://pic.huke88.com/mall/images/2017-11-03/AD57F0DC-967C-AD84-E229-EE48CB3AB45B.jpg";
//
//        HKGoodsModel *model22 = [[HKGoodsModel alloc] init];
//        model22.title = @"全站通VIP 3天 限时抢购";
//        model22.goods_id = @"123";
//        model22.price = @"1000";
//        model22.stock = @"99";
//        model22.image = @"https://pic.huke88.com/mall/images/2017-11-03/AD57F0DC-967C-AD84-E229-EE48CB3AB45B.jpg";
//
//
//        HKGoodsModel *model33 = [[HKGoodsModel alloc] init];
//        model33.title = @"全站通VIP 3天 限时抢购";
//        model33.goods_id = @"123";
//        model33.price = @"1000";
//        model33.stock = @"99";
//        model33.image = @"https://pic.huke88.com/mall/images/2017-11-03/AD57F0DC-967C-AD84-E229-EE48CB3AB45B.jpg";
//
//        model.goods_list = [NSMutableArray arrayWithArray:@[model11, model22, model33]];
//        ******* 模拟数据 *******
        
        headerView.model = model;
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
        // 抽奖
//        model.is_show = 2;
        if (model.is_show == 2) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 0.5)), dispatch_get_main_queue(), ^{
                [self enterLuckVC];
            });
        }else if (model.is_show == 1) {// 显示签到成功
            [self addShareImageVC:nil];
        }
        if (self.hkPresentResultCallback) {
            self.hkPresentResultCallback(YES);
        }
        //签到通知
        HK_NOTIFICATION_POST(HKPresentResultNotification, nil);
        
    } failure:^(NSError *error) {
        [self showFail];
    }];
}

- (void)showFail {
    
    // 显示提示
    HKLuckyResultView *resultView = [HKLuckyResultView viewFromXib];
    resultView.clipsToBounds = YES;
    resultView.layer.cornerRadius = 3.0;
    resultView.titleLabel.text = @"签到失败";
    resultView.detailLabel.text = @"当前网络状况不好，请重新签到哦~";
    [self.view.window addSubview:resultView];
    resultView.frame = CGRectMake(0, 0, 580*0.5, 162*0.5);
    resultView.centerX = SCREEN_WIDTH * 0.5;
    resultView.centerY = SCREEN_HEIGHT * 0.5;
    
    // 2.0秒移除
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 2.0)), dispatch_get_main_queue(), ^{
        [resultView removeFromSuperview];
    });
    
}


- (void)buyGoods:(HKGoodsModel *)model {
    
    // 提示消耗
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定兑换" message:[NSString stringWithFormat:@"此次兑换将消耗您%@虎课币哦~", model.price] preferredStyle:UIAlertControllerStyleAlert];
    // 兼容iPad alert
    if (alertVC.popoverPresentationController) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat width = 300;
        CGFloat height = 300;
        alertVC.popoverPresentationController.sourceView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
        alertVC.popoverPresentationController.sourceRect = CGRectMake((screenWidth - width ) * 0.5, (screenHeight - height ) * 0.5, 300, 300);
    }
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [HKHttpTool POST:@"/activity/buy-goods" parameters:@{@"goods_id" : model.goods_id} success:^(id responseObject) {
            //        state：1-兑换成功 2-虎课币不足
            if (!HKReponseOK) return;
            if ([[NSString stringWithFormat:@"%@", responseObject[@"data"][@"state"]] isEqualToString:@"1"]) {
                showTipDialog(@"兑换成功");
                // 刷新存库
                [self getData];
            } else if ([[NSString stringWithFormat:@"%@", responseObject[@"data"][@"state"]] isEqualToString:@"2"]) {
                showTipDialog(@"非常遗憾，您的虎课币不足，暂时无法兑换哦~");
            }
        } failure:^(NSError *error) {
            
        }];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:action2];
    [alertVC addAction:action1];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark <HKGoodsContainerCellDelegate>
- (void)HKOtherVIPClick:(HKGoodsModel *)model {
    [self buyGoods:model];
}

- (void)HKOtherVIPSelected:(HKGoodsModel *)model {
    
    // 进入商品详情
    WeakSelf;
    HKGoodsDetailVC *vc = [[HKGoodsDetailVC alloc] init];
    vc.model = model;
    vc.refreshBlock = ^{
        [weakSelf getData];
    };
    [self pushToOtherController:vc];
}

#pragma mark <HKPresentHeaderDelegate>
- (void)finishPresenBtnClcik:(HKPresentHeaderModel *)model {
    
    // 弹框签到
    if (model.is_show == 2) {
        HKLuckPriceVC *VC = [[HKLuckPriceVC alloc] init];
        VC.modelArray = self.model.reward_list;
        [self addChildViewController:VC];
        VC.view.frame = self.view.bounds;
        [self.view addSubview:VC.view];
    }
}



- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}

@end

@implementation HMMallDataModel

@end
