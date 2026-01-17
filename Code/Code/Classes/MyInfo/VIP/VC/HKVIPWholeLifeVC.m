
//
//  HKVIPOtherVC.m 11
//  Code
//
//  Created by Ivan li on 2017/9/7.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKVIPWholeLifeVC.h"
#import "HKOtherVipTopCell.h"
#import "HKVIPPrivilegeStringCell.h"
#import "HKVipPrivilegeCell.h"
#import "YHIAPpay.h"
#import "HKH5PushToNative.h"

#import "HKBuyVipModel.h"
#import "HKOtherVipMidCell.h"
#import "HKPayResultVC.h"
#import "HKVipInfoExModel.h"
#import "HKVipPrivilegeModel.h"
#import "HKComingCategoryCell.h"
#import "HKOtherProtocolCell.h"
#import "StoreKit/StoreKit.h"
#import "HKVIPCategoryVC_replace.h"
#import "HKVIPProtocolView.h"

@interface HKVIPWholeLifeVC ()<UITableViewDelegate,UITableViewDataSource,PayResultDelegate, HKOtherVipMidCellDelegate>

@property(nonatomic,strong)UIView *bottomBgView;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UIButton *buyBtn;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)YHIAPpay *apPay;

@property (nonatomic, strong)NSMutableArray<HKBuyVipModel *> *vipDataSource;
@property (nonatomic, strong)NSMutableArray<HKVipPrivilegeModel *> *vipPrivilegeDataSource;

// 即将到来的分类
@property (nonatomic, strong)NSMutableArray<HKVipPrivilegeModel *> *comingCategoryDataSource;

@property (nonatomic, strong)HKBuyVipModel *selectedModel; // 当前选中的model

@property (nonatomic, strong)HKVipInfoExModel *vipInfoExModel;
/// yes 已经绑定手机号
@property (nonatomic,assign)BOOL isBindPhone;
@property (nonatomic, assign) BOOL isAgree;
@property (nonatomic, strong) HKVIPProtocolView * protocolView;

@end

@implementation HKVIPWholeLifeVC

- (NSMutableArray<HKVipPrivilegeModel *> *)comingCategoryDataSource {
    if (_comingCategoryDataSource == nil) {
        _comingCategoryDataSource = [NSMutableArray array];
    }
    return _comingCategoryDataSource;
}

- (NSMutableArray<HKVipPrivilegeModel *> *)vipPrivilegeDataSource {
    if (_vipPrivilegeDataSource == nil) {
        _vipPrivilegeDataSource = [NSMutableArray array];
        HKVipPrivilegeModel *model0 = [[HKVipPrivilegeModel alloc] init];
        model0.header = @"ic_classifications of infinity_v2_2";
        model0.name = @"16大分类无限学";
        model0.des = @"包含新增分类";
        [_vipPrivilegeDataSource addObject:model0];
        
        HKVipPrivilegeModel *model1 = [[HKVipPrivilegeModel alloc] init];
        model1.header = @"ic_mycareer_v2_13";
        model1.name = @"职业路径无限学";
        model1.des = @"不断更新中";
        [_vipPrivilegeDataSource addObject:model1];
        
        
        HKVipPrivilegeModel *model7 = [[HKVipPrivilegeModel alloc] init];
        model7.header = @"ic_video_picture_v2_2";
        model7.name = @"视频+图文教程";
        model7.des = @"多场景学习";
        [_vipPrivilegeDataSource addObject:model7];
        
        HKVipPrivilegeModel *model2 = [[HKVipPrivilegeModel alloc] init];
        model2.header = @"ic_clear_v2_2";
        model2.name = @"APP离线缓存";
        model2.des = @"随时随地学";
        [_vipPrivilegeDataSource addObject:model2];
        
        HKVipPrivilegeModel *model3 = [[HKVipPrivilegeModel alloc] init];
        model3.header = @"ic_file_v2_2";
        model3.name = @"源文件下载";
        model3.des = @"边学边练";
        [_vipPrivilegeDataSource addObject:model3];
        
        HKVipPrivilegeModel *model4 = [[HKVipPrivilegeModel alloc] init];
        model4.header = @"ic_service_v2_9";
        model4.name = @"客服优先接待";
        model4.des = @"为您解疑答惑";
        [_vipPrivilegeDataSource addObject:model4];
        
        HKVipPrivilegeModel *model5 = [[HKVipPrivilegeModel alloc] init];
        model5.header = @"ic_vip_logo_v2_2";
        model5.name = @"VIP标识";
        model5.des = @"更尊贵更瞩目";
        [_vipPrivilegeDataSource addObject:model5];
        
        HKVipPrivilegeModel *model6 = [[HKVipPrivilegeModel alloc] init];
        model6.header = @"ic_teacher_comment_v2_2";
        model6.name = @"名师评改作品";
        model6.des = @"一对一点评";
        [_vipPrivilegeDataSource addObject:model6];
        
//        HKVipPrivilegeModel *model7 = [[HKVipPrivilegeModel alloc] init];
//        model7.header = @"ic_video_comment_v2_2";
//        model7.name = @"作品评改教程";
//        model7.des = @"专属权限";
//        [_vipPrivilegeDataSource addObject:model7];
        
        HKVipPrivilegeModel *model8 = [[HKVipPrivilegeModel alloc] init];
        model8.header = @"ic_week_comment_v2_2";
        model8.name = @"周练优先点评";
        model8.des = @"优先提高";
        [_vipPrivilegeDataSource addObject:model8];
        
    }
    return _vipPrivilegeDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAgree = YES;
    [self createUI];
    [CommonFunction checkAPPStatus];
    [self getVIPList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MobClick event:UM_RECORD_VIP_SINGLE_TAB];
    [MobClick event:UM_RECORD_VIP_SINGLE_CHANGE_TYPE];
}

- (void)dealloc {
    
    [MyNotification removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)loadView {
    [super loadView];
}

- (UITableView*)tableView {
    if (!_tableView) {
        HKVIPCategoryVC_replace * fatherVc = (HKVIPCategoryVC_replace *)self.parentViewController;
        CGFloat height;
        if (!fatherVc.isTabModule.length || ![fatherVc.isTabModule isEqualToString:@"1"]) {
            height = SCREEN_HEIGHT;
        }else{
            height = SCREEN_HEIGHT-KTabBarHeight49;
        }

        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)
                                                 style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        // 注册cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKOtherVipTopCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKOtherVipTopCell class])];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKComingCategoryCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKComingCategoryCell class])];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKVIPPrivilegeStringCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKVIPPrivilegeStringCell class])];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKVipPrivilegeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKVipPrivilegeCell class])];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKOtherVipMidCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKOtherVipMidCell class])];
        
        [_tableView registerClass:[HKOtherProtocolCell class] forCellReuseIdentifier:NSStringFromClass([HKOtherProtocolCell class])];
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        
        // 40 为标题高度
        [_tableView setContentInset:UIEdgeInsetsMake(KNavBarHeight64 + 40, 0, 111, 0)];
        _tableView.backgroundColor = COLOR_F8F9FA_333D48;
        
    }
    return _tableView;
}

- (void)makeConstraints {
    HKVIPCategoryVC_replace *vc= (HKVIPCategoryVC_replace *)self.parentViewController;
    if (!vc.isTabModule.length || ![vc.isTabModule isEqualToString:@"1"]) {
        [_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.height.mas_equalTo(61 + 40);
        }];
    }else{
        [_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-KTabBarHeight49);
            make.height.mas_equalTo(61 + 40);
        }];
    }
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.equalTo(self.bottomBgView);
        make.left.equalTo(self.bottomBgView).offset(15);
    }];
    
    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
        make.centerX.mas_equalTo(self.bottomBgView);
        //make.center.mas_equalTo(self.bottomBgView);
        make.bottom.mas_equalTo(self.bottomBgView).offset(-12);
    }];
    
    self.protocolView = [HKVIPProtocolView createView];
    self.protocolView.isOpenAutoBuy = NO;
    [self.bottomBgView addSubview:self.protocolView];
    @weakify(self);
    self.protocolView.seletBtnBlock = ^(BOOL selected) {
        @strongify(self);
        self.isAgree = selected;
    };
    self.protocolView.agreementBtnBlock = ^{
        @strongify(self);
        [self pushToVipProtocolHtmlVC];
    };
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.protocolView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
}

- (UIView*)bottomBgView {
    
    if (!_bottomBgView) {
        _bottomBgView = [[UIView alloc]init];
        _bottomBgView.backgroundColor = COLOR_FFFFFF_333D48;
    }
    return _bottomBgView;
}

- (UILabel*)priceLabel {
    
    if (!_priceLabel) {
        _priceLabel = [UILabel labelWithTitle:CGRectZero title:nil
                                   titleColor:[UIColor whiteColor]
                                    titleFont:nil titleAligment:NSTextAlignmentLeft];
        _priceLabel.textColor = [UIColor colorWithHexString:@"#dfc575"];
//        _priceLabel.backgroundColor = COLOR_333333;
        [_priceLabel setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ?18 :17]];
        _priceLabel.text = @"¥";
        _priceLabel.hidden = YES;
    }
    return _priceLabel;
}

- (UIButton*)buyBtn {
    if (_buyBtn == nil) {
        _buyBtn = [UIButton new];
        
        if (isLogin()) {
            NSString *temp =  [HKAccountTool shareAccount].vip_class;
            //NSString *temp =  [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_VIP_TYPE];
            [self vipTypeChange:temp];
        }else{
            if (APPSTATUS) {
                [self vipTypeChange:[CommonFunction getTouristVIPStatus]];
            } else {
                [self vipTypeChange:@"-1"];
            }
        }
        
        UIColor *color = [UIColor colorWithHexString:@"#ff685b"];
        UIColor *color1 = [UIColor colorWithHexString:@"#ff7a43"];
        UIColor *color2 = [UIColor colorWithHexString:@"#ff9423"];
        UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(307 * 0.5, 98 * 0.5) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        [_buyBtn setBackgroundImage:imageTemp forState:UIControlStateNormal];
        [_buyBtn.titleLabel setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ?19 :18 weight:UIFontWeightBold]];
        [_buyBtn.titleLabel  setTextColor: [UIColor whiteColor]];
        _buyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_buyBtn addTarget:self action:@selector(buyClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _buyBtn.clipsToBounds = YES;
        _buyBtn.layer.cornerRadius = 49 * 0.5;
    }
    return _buyBtn;
}

#pragma mark - VIP 发生改变
- (void)vipTypeChange:(NSString*)vipType {
    
    [_buyBtn setTitle:@"立即开通" forState:UIControlStateNormal];
}

- (void)createUI {
    self.title = @"VIP会员";
    [self createLeftBarButton];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomBgView];
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    [self.bottomBgView addSubview:self.priceLabel];
    [self.bottomBgView addSubview:self.buyBtn];
    [self makeConstraints];
    
    _apPay = [YHIAPpay instance];
    _apPay.delegate = self;
    
//    [MyNotification addObserver:self selector:@selector(lookPermissionsNotification:)
//                           name:KAPPStatusNotification object:nil];
    [MyNotification addObserver:self selector:@selector(networkNotification:)
                           name:KNetworkStatusNotification object:nil];
}


- (void)networkNotification:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    NSInteger  status  = [dict[@"status"] integerValue];
    if (status == 0) {
        showTipDialog(NETWORK_ALREADY_LOST);
    }
}

#pragma mark - APP 审核状态
//- (void)lookPermissionsNotification:(NSNotification *)noti {
//    
//    NSDictionary *dict = noti.userInfo;
//    NSString *status = dict[@"appStatus"];
//    if ([status isEqualToString:@"1"]) {
//        // 1------未通过状态
//        signOut();
//        YHIAPpay *apPay = [YHIAPpay instance];
//        apPay.delegate = self;
//        [apPay buyProductionModel:self.selectedModel];
//    }
//}


#pragma mark - 查询 APP线上状态
- (void)checkAPPStatus {
    
    UserInfoServiceMediator *mange = [UserInfoServiceMediator sharedInstance];
    [mange checkAppStatus:^(FWServiceResponse *response) {
        
//        NSDictionary *dict =  @{@"appStatus":response.msg};
//        [MyNotification postNotificationName:KAPPStatusNotification object:nil userInfo:dict];
        if ([response.msg isEqualToString:@"1"]) {
            // 1------未通过状态
            signOut();
            YHIAPpay *apPay = [YHIAPpay instance];
            apPay.delegate = self;
            [apPay buyProductionModel:self.selectedModel];
        }
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)buyClickAction:(id)sender {
    if (!self.isAgree) {
        showTipDialog(@"请认真阅读服务协议并同意");
        return;
    }
    [MobClick event:UM_RECORD_VIP_SINGLE_BUY];
    if (isLogin()) {
        @weakify(self);
        [HKHttpTool POST:@"/user-vip/has-purchased-lifelong-vip" parameters:nil success:^(id responseObject) {
            @strongify(self);
            if (HKReponseOK) {
                if ([responseObject[@"data"][@"status"] intValue] == 1) {
                    showTipDialog(@"已是最高会员不需要充值");
                }else{
                    YHIAPpay *apPay = [YHIAPpay instance];
                    apPay.delegate = self;
                    if (self.selectedModel) {
                        [apPay buyProductionModel:self.selectedModel];
                        // 检测 是否绑定手机号
                        @weakify(self);
                        // 默认认为已绑定
                        self.isBindPhone = YES;
                        [self buyVipCheckBindPhone:^{
                            @strongify(self);
                            self.isBindPhone = YES;
                        } bindPhoneBlock:^{
                            @strongify(self);
                            self.isBindPhone = NO;
                        }];
                    }
                }
            }else{
                showTipDialog(responseObject[@"data"][@"business_message"]);
            }
        } failure:^(NSError *error) {

        }];
        
        
        
    }else{
        [self resetUserLogin];
    }
}



#define dateTime @"2017-10-2"

#pragma mark - 登录过期,重新登录
- (void)resetUserLogin {
    WeakSelf;
    if (APPSTATUS) {
        [LEEAlert alert].config
        .LeeAddTitle(^(UILabel *label) {
            label.text = @"开通全站通VIP";
            label.textColor = [UIColor blackColor];
        })
        .LeeAddContent(^(UILabel *label) {
            label.text = @"登录虎课购买，可跨平台享受会员权益，直接购买，仅限当前设备开通会员";
            label.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ?13 :12];
            label.textColor = [UIColor blackColor];
        })
        .LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeDefault;
            action.title = @"登录虎课购买";
            action.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ?16 :15];
            action.titleColor = [UIColor colorWithHexString:@"#ff7c00"];
            action.backgroundColor = [UIColor whiteColor];
            action.clickBlock = ^{
                signOut();
                [weakSelf setLoginVC];
            };
        })
        .LeeAddAction(^(LEEAction *action) {
            //游客购买
            action.type = LEEActionTypeDefault;
            action.title = @"游客购买";
            action.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ?16 :15];
            action.titleColor = COLOR_333333;
            action.backgroundColor = [UIColor whiteColor];
            action.clickBlock = ^{
                [weakSelf checkAPPStatus];
            };
        })
        .LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeCancel;
            action.title = @"取消";
            action.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ?16 :15];
            action.titleColor = COLOR_333333;
            action.backgroundColor = [UIColor whiteColor];
        })
        .LeeHeaderColor([UIColor whiteColor])
        .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
        .LeeShow();
    }else{
        [LEEAlert alert].config
        .LeeAddTitle(^(UILabel *label) {
            label.text = @"开通全站通VIP";
            label.textColor = [UIColor blackColor];
        })
        .LeeAddContent(^(UILabel *label) {
            label.text = @"登录虎课购买，可跨平台享受会员权益，直接购买，仅限当前设备开通会员";
            label.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ?13 :12];
            label.textColor = [UIColor blackColor];
        })
        .LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeDefault;
            action.title = @"登录虎课购买";
            action.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ?16 :15];
            action.titleColor = [UIColor colorWithHexString:@"#ff7c00"];
            action.backgroundColor = [UIColor whiteColor];
            action.clickBlock = ^{
                signOut();
                [weakSelf setLoginVC];
            };
        })
        .LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeCancel;
            action.title = @"取消";
            action.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ?16 :15];
            action.titleColor = COLOR_333333;
            action.backgroundColor = [UIColor whiteColor];
        })
        .LeeHeaderColor([UIColor whiteColor])
        .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
        .LeeShow();
    }
    
    
}


- (void)payWithResult:(HKBuyVipModel *)model payResult:(BOOL)success{
    if (self.buyBtn && success) {
        [_buyBtn setTitle:@"立即开通" forState:UIControlStateNormal];
    }
    if (success) {
        HKPayResultVC *payVC = [[HKPayResultVC alloc] init];
        payVC.success = success;
        model.isBindPhone = self.isBindPhone;
        payVC.model = model;
        [self.navigationController pushViewController:payVC animated:YES];
    }
    
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.selectedModel? 4 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0;
    
    // 多少行VIP权限
    CGFloat otherVipPrivilegeHeight;
    if (self.vipPrivilegeDataSource.count) {
        int line = ceil(self.vipPrivilegeDataSource.count / 3.0);
        otherVipPrivilegeHeight = (line - 1) * 15 + line * (IS_IPHONEMORE4_7INCH? 84 : 78) + 30 + 39;
    }else {
        return otherVipPrivilegeHeight = 100;// 100占位符
    }
    
    // 即将到来的分类
    CGFloat comingCategoryHeight;
    if (self.comingCategoryDataSource.count) {
        int line = ceil(self.comingCategoryDataSource.count / 3.0);
        comingCategoryHeight = (line - 1) * 8 + line * (IS_IPHONEMORE4_7INCH? 50 : 45) + 48;
    }else {
        return comingCategoryHeight = 100;// 100占位符
    }
    
    // 特权描述行高
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setParagraphSpacing:8];
    [dic setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    CGFloat contentHeight = [self.vipInfoExModel.privilegeContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * 15.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height + 40;
    
    switch (indexPath.section) {
        case 0:
            // top cell是否有广告
            height = IS_IPHONEMORE4_7INCH? 169 : 159;
            height = self.selectedModel.ad.is_show? height + 50.0 : height;
            break;
        case 1:// 分类vip
            height = otherVipPrivilegeHeight;
            break;
        case 2:
            height = comingCategoryHeight;
            break;
        case 3:
            height = contentHeight;
            break;
        default:
            height = contentHeight;
            break;
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    if (indexPath.section == 0) {
        HKOtherVipTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKOtherVipTopCell class])];
        cell.model = self.selectedModel? self.selectedModel : self.vipDataSource.firstObject;
        cell.adImageViewTapBlock = ^(HKMapModel *model) {
            // 广告位的点击
            if (model.redirect_package.list.count > 0) {
                [HKH5PushToNative runtimePush:model.redirect_package.class_name arr:model.redirect_package.list currectVC:weakSelf];
                
                // 统计
                [[HomeServiceMediator sharedInstance] advertisClickCount:model.ad_id];
                [HKALIYunLogManage sharedInstance].button_id = @"5";
                [MobClick event: vippage_banner];
            }
        };
        return cell;
        
    } else if (indexPath.section == 1) { // VIP权限
        HKVipPrivilegeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKVipPrivilegeCell class])];
        [cell setDataSource:self.vipPrivilegeDataSource vipInfoExModel:self.vipInfoExModel];
        return cell;
    } else if (indexPath.section == 2) { // 即将到来的分类
        HKComingCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKComingCategoryCell class])];
        [cell setDataSource:self.comingCategoryDataSource vipInfoExModel:nil];
        return cell;
    } else if (indexPath.section == 3) {
        HKVIPPrivilegeStringCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKVIPPrivilegeStringCell class])];
        cell.vipInfoExModel = self.vipInfoExModel;
        return cell;
    }
    return nil;
}

#pragma mark <HKOtherVipMidCellDelegate>
- (void)HKOtherVIPSelected:(HKBuyVipModel *)model {
    self.selectedModel = model;
}

- (void)setSelectedModel:(HKBuyVipModel *)selectedModel {
    _selectedModel = selectedModel;
    
    // 设置价格信息
    NSString *string = [NSString stringWithFormat:@"%@￥%@", selectedModel.class_name, selectedModel.price];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0xFF3221, 1.0) range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0x7B8196, 1.0) range:NSMakeRange(0, selectedModel.class_name.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, selectedModel.class_name.length)];
    self.priceLabel.attributedText = attrString;
    
    [self.buyBtn setTitle:[NSString stringWithFormat:@"立即开通"] forState:UIControlStateNormal];
    
    // 修改cell
    HKOtherVipTopCell *cellTop = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([cellTop isKindOfClass:[HKOtherVipTopCell class]]) {
        cellTop.model = selectedModel;
    }
    
    HKVipPrivilegeCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    if ([cell isKindOfClass:[HKVipPrivilegeCell class]]) {
        self.vipPrivilegeDataSource.firstObject.name = [NSString stringWithFormat:@"%@无限学习", selectedModel.class_name];
        [cell setDataSource:self.vipPrivilegeDataSource vipInfoExModel:self.vipInfoExModel];
    }
}



#pragma mark <Server>
- (void) getVIPList{
    
    [HKHttpTool POST:@"/vip/vip-list" parameters:nil success:^(id responseObject) {
        
        if (HKReponseOK) {
            HKBuyVipModel *model = [HKBuyVipModel mj_objectWithKeyValues:responseObject[@"data"][@"lifelong_all_vip_data"]];
//            model.price = @"898";
//            model.name = @"活动终身全站通VIP";
//            model.class_name = @"活动终身全站通VIP";
            model.button_type = self.button_type;
            self.selectedModel = model;
            
            // 赋值广告位信息
            HKMapModel *adMapModel = nil;
            if ([responseObject[@"data"][@"advertises"] isKindOfClass:[NSDictionary class]] && [responseObject[@"data"][@"advertises"][@"lifelong_all_vip_data"] isKindOfClass:[NSDictionary class]]) {
                adMapModel = [HKMapModel mj_objectWithKeyValues:responseObject[@"data"][@"advertises"][@"lifelong_all_vip_data"]];
                model.ad = adMapModel;
            }
            
            self.vipInfoExModel = [HKVipInfoExModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.vipInfoExModel.privilegeString = @"6大权益+3大专属权益";
            self.vipInfoExModel.privilegeTitle = @"特权说明";
            self.vipInfoExModel.privilegeContent = @"1、VIP账号可在网页、APP客户端、ipad客户端通用，享受同等权益\n2、视频中的素材源文件请至网站下载\n3、终身VIP包含新增的分类VIP权益\n4、名师评改作品权益：全站通VIP专属权益，请至网站上“作品评改”模块上传自己的作品，虎课官方讲师会进行一对一点评\n5、周练优先点评权益：请至网站上“每周一练”模块参加练习并上传作品，虎课官方讲师会优先为您点评\n6、名师评改视频权益：全站通VIP专属权益，“视频评改”分类教程无限观看";
            
            // 更新数据 分类数据
            self.vipPrivilegeDataSource.firstObject.name = [NSString stringWithFormat:@"%@大分类无限学", self.vipInfoExModel.class_total];
            
            // 网络数据
            self.comingCategoryDataSource = [NSMutableArray array];
            if ([responseObject[@"data"][@"coming_class"] isKindOfClass:[NSArray class]]) {
                for (NSString *string in responseObject[@"data"][@"coming_class"]) {
                    HKVipPrivilegeModel *model = [[HKVipPrivilegeModel alloc] init];
                    model.name = string;
                    [_comingCategoryDataSource addObject:model];
                }
            }

            
            [self.tableView reloadData];
            
            // 移到下一个VC
            NSString* page_type = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"page_type"]];
            if ([page_type isEqualToString:@"2"] && [self.delegate respondsToSelector:@selector(moveToNextVC)]) {
                
                // 延时0.5
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 0.5)), dispatch_get_main_queue(), ^{
                    [self.delegate moveToNextVC];
                });
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}

@end


