
//
//  PrivilegeVC.m
//  Code
//
//  Created by Ivan li on 2017/9/7.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "PrivilegeVC.h"
#import "vipBgCell.h"
#import "VipExplainCell.h"
#import "YHIAPpay.h"
#import "LEEAlert.h"
#import "LoginVC.h"
#import "DateChange.h"



#define VIP298  @"com.cainiu.HuKeWangVip298" //@"com.cainiu.HuKeWangAll298"

#define TEST_VIP_6  @"com.cainiu.HuKeWangVIP6"

#define VIP18 @"com.cainiu.HuKeWang18"



@interface PrivilegeVC ()<UITableViewDelegate,UITableViewDataSource,PayResultDelegate>

@property(nonatomic,strong)UIView *bottomBgView;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UIButton *buyBtn;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)YHIAPpay *apPay;




@end

@implementation PrivilegeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [CommonFunction checkAPPStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                 style:UITableViewStyleGrouped];
        //_tableView.separatorColor = RGB(240, 240, 240, 1);
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        _tableView.sectionHeaderHeight = 0.;
        _tableView.sectionFooterHeight = 0.;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        // 兼容iOS11
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [_tableView setContentInset:UIEdgeInsetsMake(110, 0, 50, 0)];
    }
    return _tableView;
}



- (void)makeConstraints {
    WeakSelf;
    [_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(PADDING_25*2);
    }];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.top.equalTo(weakSelf.bottomBgView);
        make.width.mas_equalTo(SCREEN_WIDTH*2/3);
    }];
    
    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.equalTo(weakSelf.priceLabel);
        make.left.equalTo(weakSelf.priceLabel.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH*1/3);
    }];
}

- (UIView*)bottomBgView {
    
    if (!_bottomBgView) {
        _bottomBgView = [[UIView alloc]init];
        //_bottomBgView.backgroundColor = [UIColor blueColor];
    }
    return _bottomBgView;
}




- (UILabel*)priceLabel {
    
    if (!_priceLabel) {
        _priceLabel = [UILabel labelWithTitle:CGRectZero title:nil
                                   titleColor:[UIColor whiteColor]
                                    titleFont:nil titleAligment:NSTextAlignmentLeft];
        _priceLabel.textColor = [UIColor colorWithHexString:@"#dfc575"];
        _priceLabel.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        [_priceLabel setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ?18 :17]];
        _priceLabel.text = @"   ¥298";
    }
    return _priceLabel;
}



- (UIButton*)buyBtn {
    if (_buyBtn == nil) {
        _buyBtn = [UIButton new];
        
        if (isLogin()) {
            NSString *temp =  [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_VIP_TYPE];
            [self vipTypeChange:temp];
        }else{
            if (APPSTATUS) {
                [self vipTypeChange:[CommonFunction getTouristVIPStatus]];
            }
        }
        _buyBtn.backgroundColor = [UIColor colorWithHexString:@"#dfc575"];
        [_buyBtn.titleLabel setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ?18 :17]];
        [_buyBtn.titleLabel  setTextColor: [UIColor colorWithHexString:@"#333333"]];
        _buyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_buyBtn addTarget:self action:@selector(buyClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}



#pragma mark - VIP 发生改变
- (void)vipTypeChange:(NSString*)vipType {
    
    //vip_type:0-非VIP 1-分类VIP 2-全站通VIP
    /*if (isEmpty(vipType)) {
     _allVipImageView.hidden = YES;
     _partVipImageView.hidden = YES;
     return;
     }*/
    if ([vipType isEqualToString:@"0"]) {
        [_buyBtn setTitle:@"立即开通" forState:UIControlStateNormal];
    }else if ([vipType isEqualToString:@"1"]){
        [_buyBtn setTitle:@"续费" forState:UIControlStateNormal];
        
    }else if ([vipType isEqualToString:@"2"]){
        [_buyBtn setTitle:@"续费" forState:UIControlStateNormal];
    }else{
        //特殊状态 隐藏VIP
        [_buyBtn setTitle:@"立即开通" forState:UIControlStateNormal];
    }
}



- (void)createUI {
    self.title = @"VIP会员";
    [self createLeftBarButton];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomBgView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.bottomBgView addSubview:self.priceLabel];
    [self.bottomBgView addSubview:self.buyBtn];
    [self makeConstraints];
    
    _apPay = [YHIAPpay instance];
    _apPay.delegate = self;
    
    [MyNotification addObserver:self selector:@selector(lookPermissionsNotification:)
                           name:KAPPStatusNotification object:nil];
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
- (void)lookPermissionsNotification:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    NSString *status = dict[@"appStatus"];
    if ([status isEqualToString:@"1"]) {
        // 1------未通过状态
        signOut();
        YHIAPpay *apPay = [YHIAPpay instance];
        apPay.delegate = self;
        [apPay buyProduction:VIP298];
    }
}


#pragma mark - 查询 APP线上状态
- (void)checkAPPStatus {
    
    UserInfoServiceMediator *mange = [UserInfoServiceMediator sharedInstance];
    [mange checkAppStatus:^(FWServiceResponse *response) {
        
        NSDictionary *dict =  @{@"appStatus":response.msg};
        [MyNotification postNotificationName:KAPPStatusNotification object:nil userInfo:dict];
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}




- (void)buyClickAction:(id)sender {
    
    if (isLogin()) {
        
        YHIAPpay *apPay = [YHIAPpay instance];
        apPay.delegate = self;
        NSString *temp = [CommonFunction getUserId];
        if ([temp isEqualToString:@"177583"]) {
            [apPay buyProduction:TEST_VIP_6];
        }else{
            [apPay buyProduction:VIP298];
        }
        [MobClick event:UM_RECORD_VIP_BTN];
    }else{
        [self resetUserLogin];
    }
}




// 得到的结果为相差的天数
- (int)intervalSinceNow:(NSString *) theDate {
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    // 这里的格式根据自己的需要自行确定（yyyy-MM-dd hh:mm:ss）
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *d=[date dateFromString:theDate];
    NSInteger unitFlags = NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear;
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [cal components:unitFlags fromDate:d];
    NSDate *newBegin = [cal dateFromComponents:comps];
    // 当前时间
    NSCalendar *cal2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps2 = [cal2 components:unitFlags fromDate:[NSDate date]];
    NSDate *newEnd = [cal2 dateFromComponents:comps2];
    NSTimeInterval interval = [newEnd timeIntervalSinceDate:newBegin];
    NSInteger resultDays=((NSInteger)interval)/(3600*24);
    return (int) resultDays;
}




#define dateTime @"2017-10-2"

#pragma mark - 登录过期,重新登录
- (void)resetUserLogin {
    WeakSelf;
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
            UINavigationController *loginVC = [[UINavigationController alloc]initWithRootViewController:[LoginVC new]];
            [weakSelf presentViewController:loginVC animated:YES completion:nil];
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
    .LeeShow();
    
}


- (void)payWithResult:(id)sender {
    if (self.buyBtn) {
        [_buyBtn setTitle:@"续费" forState:UIControlStateNormal];
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0;
    switch (indexPath.section) {
        case 0:
            height = 150;
            break;
            
        case 1:
            height = 190+60;
            break;
            
        default:
            height = 150;
            break;
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return PADDING_15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        vipBgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"vipBgCell"];
        if (!cell ) {
            cell = [[vipBgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"vipBgCell"];
        }
        return cell;
    }else{
        VipExplainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VipExplainCell"];
        if (!cell ) {
            cell = [[VipExplainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VipExplainCell"];
        }
        return cell;
    }
}







@end
