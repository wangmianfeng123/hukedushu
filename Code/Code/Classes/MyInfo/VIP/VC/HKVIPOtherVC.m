
//
//  HKVIPOtherVC.m 11
//  Code
//
//  Created by Ivan li on 2017/9/7.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKVIPOtherVC.h"
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
#import "HKOtherProtocolCell.h"
#import "HtmlShowVC.h"
#import "HKVIPCategoryVC_replace.h"


#define c4d198  @"com.cainiu.HuKeWang.171130c4d198"
#define chanpin98  @"com.cainiu.HuKeWang.171130chanpin98"
#define tuxiang98  @"com.cainiu.HuKeWang.171130tuxiang98"
#define ziti98  @"com.cainiu.HuKeWang.171130ziti98"
#define haibao98  @"com.cainiu.HuKeWang.171130haibao98"
#define zonghe98  @"com.cainiu.HuKeWang.171130zonghe98"
#define ruanjian98  @"com.cainiu.HuKeWang.171130ruanjian98"
#import "HKVIPProtocolView.h"

@interface HKVIPOtherVC ()<UITableViewDelegate,UITableViewDataSource,PayResultDelegate, HKOtherVipMidCellDelegate>

@property(nonatomic,strong)UIView *bottomBgView;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UIButton *buyBtn;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)YHIAPpay *apPay;

@property (nonatomic, strong)NSMutableArray<HKBuyVipModel *> *vipDataSource;
@property (nonatomic, strong)NSMutableArray<HKVipPrivilegeModel *> *vipPrivilegeDataSource;
@property (nonatomic, strong)HKBuyVipModel *selectedModel; // 当前选中的model

@property (nonatomic, strong)HKVipInfoExModel *vipInfoExModel;
/// vip 权益 section 高度
@property(nonatomic,assign)CGFloat vipPrivilegeSectionHeight;

@property (nonatomic,assign)BOOL isBindPhone;
@property (nonatomic, assign) BOOL isAgree;
@property (nonatomic, strong) HKVIPProtocolView * protocolView;


@end

@implementation HKVIPOtherVC

- (NSMutableArray<HKVipPrivilegeModel *> *)vipPrivilegeDataSource {
    if (_vipPrivilegeDataSource == nil) {
        _vipPrivilegeDataSource = [NSMutableArray array];
    }
    return _vipPrivilegeDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAgree = YES;
    [self createUI];
    //[CommonFunction checkAPPStatus];
    [self getVIPList];
    [self showDownloadWarning];
}

#pragma mark - 下载受限
- (void)showDownloadWarning {
    
    if (self.isShowDialg) {
        [LEEAlert alert].config
        .LeeAddTitle(^(UILabel *label) {
            
            label.text = @"缓存视频是分类SVIP、\n全站通VIP用户的特权哦~";
            label.font = [UIFont systemFontOfSize:15.0];
            label.textColor = HKColorFromHex(0x030303, 1.0);
        })
        .LeeAddContent(^(UILabel *label) {
            
//            label.text = Memory_Insufficient;
//            label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
        })
        .LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeCancel;
            action.title = @"我知道了";
            action.titleColor = [UIColor colorWithHexString:@"#0076FF"];
            action.backgroundColor = [UIColor whiteColor];
            action.font = [UIFont systemFontOfSize:15.0];
            action.clickBlock = ^{
                // 取消点击事件Block
            };
        })
        .LeeHeaderColor([UIColor whiteColor])
        .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
        .LeeShow();
    }
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
        //顶部headerCell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKOtherVipTopCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKOtherVipTopCell class])];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKVIPPrivilegeStringCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKVIPPrivilegeStringCell class])];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKVipPrivilegeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKVipPrivilegeCell class])];
        //内容区,vip分类cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKOtherVipMidCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKOtherVipMidCell class])];
        
        [_tableView registerClass:[HKOtherProtocolCell class] forCellReuseIdentifier:NSStringFromClass([HKOtherProtocolCell class])];
        
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        
        // 40 为标题高度
        [_tableView setContentInset:UIEdgeInsetsMake(KNavBarHeight64 + 40, 0, 111, 0)];
        _tableView.backgroundColor = HKColorFromHex(0xF8F9FA, 1.0);
        
    }
    return _tableView;
}



- (void)makeConstraints {
    HKVIPCategoryVC_replace *vc= (HKVIPCategoryVC_replace *)self.parentViewController;
    if (!vc.isTabModule.length || ![vc.isTabModule isEqualToString:@"1"]) {
        [_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.height.mas_equalTo(61+ 40);
        }];
    }else{
        [_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-KTabBarHeight49);
            make.height.mas_equalTo(61+ 40);
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
    [self.bottomBgView addSubview:self.protocolView];
    self.protocolView.isOpenAutoBuy = NO;
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

- (UIView*)bottomBgView {
    
    if (!_bottomBgView) {
        _bottomBgView = [[UIView alloc]init];
        _bottomBgView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomBgView;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.protocolView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
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
                //1审核状态游客购买 2表示是VIP 
                [self vipTypeChange:[CommonFunction getTouristVIPStatus]];
            } else {
                //线上
                [self vipTypeChange:@"-1"];
            }
        }
        
        UIColor *color = [UIColor colorWithHexString:@"#36b6ff"];
        UIColor *color1 = [UIColor colorWithHexString:@"#2aa4ff"];
        UIColor *color2 = [UIColor colorWithHexString:@"#198dff"];
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
    [self.bottomBgView addSubview:self.priceLabel];
    [self.bottomBgView addSubview:self.buyBtn];
    [self makeConstraints];
    
    _apPay = [YHIAPpay instance];
    _apPay.delegate = self;
    
//    [MyNotification addObserver:self selector:@selector(lookPermissionsNotification:)
//                           name:KAPPStatusNotification object:nil];
    [MyNotification addObserver:self selector:@selector(networkNotification:)
                           name:KNetworkStatusNotification object:nil];
    
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    self.bottomBgView.backgroundColor = COLOR_FFFFFF_333D48;
    self.tableView.backgroundColor = COLOR_F8F9FA_333D48;
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

#pragma mark ======= PayResultDelegate
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
    
    return self.vipDataSource.count > 0? 4 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0;
    switch (indexPath.section) {
        case 0:
            // top cell是否有广告
            height = IS_IPHONEMORE4_7INCH? 169 : 159;
            height = self.selectedModel.ad.is_show? height + 50.0 : height;
            break;
        case 1:// 分类vip
        {
            // 多少行VIP分类
            CGFloat otherVipHeight;
            if (self.vipDataSource.count) {
                int line = ceil(self.vipDataSource.count / 3.0);
                otherVipHeight = (line - 1) * 8 + line * (IS_IPHONEMORE4_7INCH? 70 : 65) + 15 + 36 + 10;
            }else {
                otherVipHeight = 100;// 100占位符
            }
            height = otherVipHeight;
        }
            break;
        case 2:{
            // 多少行VIP权限
            CGFloat otherVipPrivilegeHeight;
            if (self.vipPrivilegeDataSource.count) {
                int line = ceil(self.vipPrivilegeDataSource.count / 3.0);
                otherVipPrivilegeHeight = (line - 1) * 15 + line * (IS_IPHONEMORE4_7INCH? 84 : 78) + 30 + 39;
                self.vipPrivilegeSectionHeight = otherVipPrivilegeHeight;
            }else {
                otherVipPrivilegeHeight = (self.vipPrivilegeSectionHeight >0) ?self.vipPrivilegeSectionHeight :100;// 100占位符
            }
            height = otherVipPrivilegeHeight;
        }
            break;
            
        case 3:{
            // 特权描述行高
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setParagraphSpacing:8];
            [dic setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
            
            CGFloat contentHeight = [self.vipInfoExModel.privilegeContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * 15.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height + 40;
            height = contentHeight;
        }
            break;
                
        default:{
        }
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
        
    } else if (indexPath.section == 1) { // 分类vip
        HKOtherVipMidCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKOtherVipMidCell class])];
        [cell setDataSource:self.vipDataSource vipInfoExModel:self.vipInfoExModel];
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 2) { // VIP权限
        HKVipPrivilegeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKVipPrivilegeCell class])];
        [cell hiddenPrivilegeTagView];
        [cell setDataSource:self.vipPrivilegeDataSource vipInfoExModel:self.vipInfoExModel];
        return cell;
    } else if (indexPath.section == 3) { // VIP权限
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
    [self getVipPrivilegesList:selectedModel.vip_type];
    
    //HKVipPrivilegeCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    //if ([cell isKindOfClass:[HKVipPrivilegeCell class]]) {
        //self.vipPrivilegeDataSource.firstObject.name = [NSString stringWithFormat:@"%@无限学习", selectedModel.class_name];
        //[cell setDataSource:self.vipPrivilegeDataSource vipInfoExModel:self.vipInfoExModel];
    //}
}



#pragma mark <Server>
- (void) getVIPList{
    
    NSDictionary *param = nil;
    
    if (self.class_type) {
        param = @{@"class_type" : self.class_type};
    }
    
    [HKHttpTool POST:@"/vip/vip-list" parameters:param success:^(id responseObject) {
        
        if (HKReponseOK) {
            NSMutableArray<HKBuyVipModel *> *vipDataSource = [HKBuyVipModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"class_vip_list"]];
            
            self.vipInfoExModel = [HKVipInfoExModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.vipInfoExModel.privilegeString = @"6大权益";
            self.vipInfoExModel.privilegeTitle = @"特权说明";
            self.vipInfoExModel.privilegeContent = @"1、VIP账号可在网页、APP客户端、ipad客户端通用，享受同等权益\n2、素材源文件请至网站下载";
            
            // 赋值广告位信息
            HKMapModel *adMapModel = nil;
            if ([responseObject[@"data"][@"advertises"] isKindOfClass:[NSDictionary class]] && [responseObject[@"data"][@"advertises"][@"class_vip_list"] isKindOfClass:[NSDictionary class]]) {
                adMapModel = [HKMapModel mj_objectWithKeyValues:responseObject[@"data"][@"advertises"][@"class_vip_list"]];
            }
            
            // 赋值button_type
            if (self.button_type.length) {
                for (HKBuyVipModel *model in vipDataSource) {
                    model.button_type = self.button_type;
                }
            }
            
//            HKBuyVipModel *model0 = vipDataSource[0];
//            model0.price = @"98";
//            model0.name = @"海外教程";
//            model0.class_name = @"海外教程";
            
//            1、影视动画 98元/年
//            2、C4D教程 98元/年
//            3、海外教程 98元/年
//            4、终身全站通 998元
            
            
//            HKBuyVipModel *model0 = vipDataSource[1];
//            model0.price = @"98";
//            model0.name = @"办公软件SVIP";
//            model0.class_name = @"办公软件SVIP";
//
//
//            HKBuyVipModel *model0 = vipDataSource[2];
//            model0.price = @"98";
//            model0.name = @"办公软件SVIP";
//            model0.class_name = @"办公软件SVIP";
//
//            HKBuyVipModel *model0 = vipDataSource[3];
//            model0.price = @"148";
//            model0.name = @"办公软件SVIP";
//            model0.class_name = @"办公软件SVIP";
            
            
            
//            HKBuyVipModel *model1 = vipDataSource[1];
//            model1.price = @"298";
//            model1.name = @"加薪礼包";
//            model1.class_name = @"加薪礼包";
            
            // 遍历处理附加信息
            for (HKBuyVipModel *model in vipDataSource) {

                // 默认选中的
                if (model.is_selected) {
                    self.selectedModel = model;
                    //self.vipPrivilegeDataSource.firstObject.name = [NSString stringWithFormat:@"%@无限学习", model.class_name];
                }

                // 附加广告信息
                if (adMapModel) {
                    model.ad = adMapModel;
                }
            }
            
            self.vipDataSource = vipDataSource;
            [self.tableView reloadData];
            
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 分类VIP 权益列表
- (void)getVipPrivilegesList:(NSString*)vipType{
    
    if (isEmpty(vipType)) {
        return;
    }
    [self.vipPrivilegeDataSource removeAllObjects];
    NSDictionary *param = @{@"vip_type" : vipType};
    [HKHttpTool POST:VIP_GET_PRIVILEGES parameters:param success:^(id responseObject) {
        if (HKReponseOK) {
            NSMutableArray<HKVipPrivilegeModel *> *vipPrivilegeArr = [HKVipPrivilegeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            self.vipPrivilegeDataSource = vipPrivilegeArr;
            
            HKVipPrivilegeCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
            if ([cell isKindOfClass:[HKVipPrivilegeCell class]]) {
                [cell setDataSource:self.vipPrivilegeDataSource vipInfoExModel:self.vipInfoExModel];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
@end


