//
//  HKVIPCategoryVC.m
//  Code
//
//  Created by eon Z on 2021/11/8.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKVIPCategoryVC.h"
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
#import "HKVipHeaderView.h"
#import "HKVipInfoExModel.h"
#import "HKAutoRenewalCell.h"
#import "HKVipPrivilegeInTopCell.h"
#import "HKVIPProtocolView.h"
#import "HKYeasVipPrivilegeCell.h"
#import "HKPrivilegeVC.h"
#import "HKVIPadsCell.h"
#import "HKPriceView.h"
#import "UIViewController+ZFNormalPlayerRotation.h"
#import "UINavigationController+ZFNormalFullscreenPopGesture.h"


@interface HKVIPCategoryVC ()<UITableViewDelegate,UITableViewDataSource,HKVipHeaderViewDelegate,HKOtherVipMidCellDelegate,PayResultDelegate,PayResultDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HKVipHeaderView * headView;

@property (nonatomic, strong)HKBuyVipModel * all_vip_Model; // 全站通会员
@property (nonatomic, strong)HKBuyVipModel * allVipAutoRenewalModel; // 全站通自动续费
@property (nonatomic, strong)HKBuyVipModel * lifelong_all_vip_Model; // 终生全站通
@property (nonatomic, strong)HKBuyVipModel * class_vip_Model; // 分类全站通
@property (nonatomic, strong)NSMutableArray<HKBuyVipModel *> *vipDataSource; //分类VIP数组
@property (nonatomic, assign)BOOL has_lifelong_vip; //是否是终生VIP

@property (nonatomic, strong)HKBuyVipModel *selectedCategoryModel; // 当前选中的分类VIP
@property (nonatomic, assign)int page_type; //分类，年会员 终生会员

@property(nonatomic,strong)UIView *bottomBgView;
@property(nonatomic,strong)UIButton *buyBtn;
@property (nonatomic, strong) HKVIPProtocolView * protocolView;
@property (nonatomic, assign) BOOL isAutoBuy;//标记是否选中
@property (nonatomic, assign) BOOL isAgree;//是否同意协议
@property (nonatomic,assign)BOOL isBindPhone; /// yes 已经绑定手机号,传递给支付成功结果页
@property (nonatomic , strong)NSMutableArray * dataArray;
@property (nonatomic , assign) NSInteger MobClickCount;//标记切换的时候只统计一次；
@property(nonatomic,strong)YHIAPpay *apPay;
@property (nonatomic , strong)HKPriceView * priceV;
@end

@implementation HKVIPCategoryVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor hkdm_colorWithColorLight:[UIColor colorWithHexString:@"3D414D"] dark:[UIColor colorWithHexString:@"#3D4752"]]];
//    HKStatusBarStyleLightContent;
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
//    HKStatusBarStyleDefault;

//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    self.MobClickCount = 999;
    [self getVIPList];
    [self createUI];
    [self showDownloadWarning];
}

- (UITableView*)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, SCREEN_HEIGHT-KNavBarHeight64)
                                                 style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
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
        //自动续费VIP
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKAutoRenewalCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKAutoRenewalCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKVipPrivilegeInTopCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKVipPrivilegeInTopCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKYeasVipPrivilegeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKYeasVipPrivilegeCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKVIPadsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKVIPadsCell class])];
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        
        // 40 为标题高度
        [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 111, 0)];
        //_tableView.backgroundColor = HKColorFromHex(0xF8F9FA, 1.0);
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        
    }
    return _tableView;
}

- (void)createUI {
    self.isAgree = YES;
    [self setupNav];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomBgView];
    [self.bottomBgView addSubview:self.buyBtn];
    [self.buyBtn addSubview:self.priceV];
    [self makeConstraints];
    
    _apPay = [YHIAPpay instance];
    _apPay.delegate = self;
    
    [MyNotification addObserver:self selector:@selector(networkNotification:) name:KNetworkStatusNotification object:nil];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    
    self.headView = [HKVipHeaderView viewFromXib];
    //self.headView.frame = CGRectMake(0, 0, 375 * Ratio ,225.0 * Ratio);
    self.headView.frame = IS_IPHONE ? CGRectMake(0, 0, SCREEN_WIDTH ,SCREEN_WIDTH * 255.0/375.0) : CGRectMake(0, 0, SCREEN_WIDTH ,SCREEN_WIDTH * 150.0/375.0);
    

    self.headView.delegate = self;
    self.tableView.tableHeaderView = self.headView;
    WeakSelf
    self.headView.didHeaderBlock = ^{
        if (!isLogin()) {
            [weakSelf setLoginVC];
        }
    };
}

-(HKPriceView *)priceV{
    if (_priceV == nil) {
        _priceV = [HKPriceView viewFromXib];
    }
    return _priceV;
}

/**
 * 设置导航栏1
 */
- (void)setupNav {
    [self setTitle:@"虎课VIP" color:[UIColor colorWithHexString:@"#DBC1A2"]];
    [self createLeftBarItemWithImageName:@"nac_back_dark"];
}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.page_type == 0) {
        return self.vipDataSource.count > 0? 4 : 0;
    }else if (self.page_type == 1){
        return 4;
    }else{
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.page_type == 0) {
        if (section == 0) {
            if (self.class_vip_Model.ad.is_show) {
                return 1;
            }else{
                return 0;
            }
        }
        return 1;
        
    }else if (self.page_type == 1){
        if (section == 0) {
            if (self.all_vip_Model.ad.is_show) {
                return 1;
            }else{
                return 0;
            }
        }else if (section == 1){
            if (!self.allVipAutoRenewalModel.canAutoRenewal) {
                return 0;
            }
            return 1;
        }else{
            return 1;
        }
        
    }else{
        if (section == 0) {
            if (self.lifelong_all_vip_Model.ad.is_show) {
                return 1;
            }
            return 0;
        }
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.page_type == 0) {
        CGFloat height = 0;
        switch (indexPath.section) {
                
            case 0:{
                if (self.class_vip_Model.ad.is_show) {
                    return (SCREEN_WIDTH - 30) * 40.0 / 345.0 + 20;
                }else{
                    return 0.0;
                }
            }
                break;
                
            case 1:// 分类vip
            {
                // 多少行VIP分类
                CGFloat otherVipHeight;
                if (self.vipDataSource.count) {
                    int line = ceil(self.vipDataSource.count / 3.0);
                    otherVipHeight = (line - 1) * 2 + line * ((IS_IPHONEMORE4_7INCH? 70 : 65) + 9) + 15 + 15;
                }else {
                    otherVipHeight = 100;// 100占位符
                }
                height = otherVipHeight;
            }
                break;
            case 2:{
                // 多少行VIP权限
                CGFloat otherVipPrivilegeHeight = 0;
                
                if (self.class_vip_Model.all_vip_privilege.count) {
                    int line = ceil(self.class_vip_Model.all_vip_privilege.count / 3.0);
                    otherVipPrivilegeHeight = (line - 1) * 15 + line * (IS_IPHONEMORE4_7INCH? 74 : 68) + 30 + 39 + 10;
                }
                height = otherVipPrivilegeHeight;
            }
                break;

            case 3:{
                // 特权描述行高
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
                NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:5];
                [dic setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
                CGFloat contentHeight = [self.class_vip_Model.vipInfoExModel.privilegeContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * 25.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height + 65;
                height = contentHeight;
            }
                break;

            default:{
            }
                break;
        }
        return height;
    }else if (self.page_type == 1){
        if (indexPath.section == 0) {
            if (self.all_vip_Model.ad.is_show) {
                return (SCREEN_WIDTH - 30) * 40.0 / 345.0 + 20 ;
            }else{
                return 0.0;
            }
        }else if (indexPath.section == 1) {
            if (self.allVipAutoRenewalModel.canAutoRenewal) {
                return 90.0;
            }
            return 0.0;
        }else if (indexPath.section == 2){
            // 多少行VIP权限
            CGFloat otherVipPrivilegeHeight = 0;
            int count = (int)self.all_vip_Model.all_vip_privilege.count - 1 ;
            otherVipPrivilegeHeight = [self getVipPrivilegeHeight:count];
            return otherVipPrivilegeHeight;
        }else{
            // 特权描述行高
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:5];
            [dic setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
            CGFloat contentHeight = [self.all_vip_Model.vipInfoExModel.privilegeContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * 25.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height + 65;
            return contentHeight;
        }
    }else{
        if (indexPath.section == 0) {
            if (self.lifelong_all_vip_Model.ad.is_show) {
                return (SCREEN_WIDTH - 30) * 40.0 / 345.0 + 20 ;
            }else{
                return 0.0;
            }
        }else if (indexPath.section == 1) {
            // 多少行VIP权限
            CGFloat otherVipPrivilegeHeight = 0;
            int count = (int)self.lifelong_all_vip_Model.all_vip_privilege.count - 1 ;
            otherVipPrivilegeHeight = [self getVipPrivilegeHeight:count];
            return otherVipPrivilegeHeight;
        }else{
            // 特权描述行高
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:13.0] forKey:NSFontAttributeName];
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:5];
            [dic setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];

            CGFloat contentHeight = [self.lifelong_all_vip_Model.vipInfoExModel.privilegeContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * 25.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height + 65;
            return contentHeight;
        }
    }
}

- (CGFloat)getVipPrivilegeHeight:(int)count{
    CGFloat otherVipPrivilegeHeight = 0;
    otherVipPrivilegeHeight = 15 + 15 + 15 + 60 + 10;
    if (count) {
        int line = ceil(count / 3.0);
        otherVipPrivilegeHeight = (line - 1) * 15 + line * (IS_IPHONEMORE4_7INCH? 84 : 78) + 25 + 15 + 15 + 60 + 10;
    }
    return otherVipPrivilegeHeight;
}


- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    if (self.page_type == 0) {
        if (section) {
            return 0.0;
        }
    }else if (self.page_type == 1){
        if (section == 0) {
            return 10;
        }else if (section == 1){
            return 0.0;
        }
        return 10;
    }else if (self.page_type == 2){
        if (section == 1) {
            return 0.0;
        }
    }
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    bgV.backgroundColor = COLOR_F8F9FA_333D48;
    return bgV;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.page_type == 0) {
        if (indexPath.section == 0) {
            HKVIPadsCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKVIPadsCell class])];
            [cell.adImgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:self.class_vip_Model.ad.img_url]] placeholderImage:HK_PlaceholderImage];
            WeakSelf
            cell.tapClickBlock = ^{
                [HKH5PushToNative runtimePush:weakSelf.class_vip_Model.ad.redirect_package.class_name arr:weakSelf.class_vip_Model.ad.redirect_package.list currectVC:weakSelf];
                
                // 统计
                [HKALIYunLogManage sharedInstance].button_id = @"5";
            };
            return cell;
        }else if (indexPath.section == 1) { // 分类vip
            HKOtherVipMidCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKOtherVipMidCell class])];
            [cell setDataSource:self.vipDataSource vipInfoExModel:nil];
            cell.delegate = self;
            return cell;
        } else if (indexPath.section == 2) { // VIP权限
            HKVipPrivilegeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKVipPrivilegeCell class])];
            [cell hiddenPrivilegeTagView];
            [cell setDataSource:self.class_vip_Model.all_vip_privilege vipInfoExModel:nil];
            return cell;
        } else if (indexPath.section == 3) { // 特权说明
            HKVIPPrivilegeStringCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKVIPPrivilegeStringCell class])];
            cell.privilegeContent = self.class_vip_Model.vipInfoExModel.privilegeContent;
            //cell.vipInfoExModel = self.vipInfoExModel;
            return cell;
        }
        return nil;
    }else if (self.page_type == 1){
        if (indexPath.section == 0) {
            HKVIPadsCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKVIPadsCell class])];
            [cell.adImgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:self.all_vip_Model.ad.img_url]] placeholderImage:HK_PlaceholderImage];
            WeakSelf
            cell.tapClickBlock = ^{
                [HKH5PushToNative runtimePush:weakSelf.all_vip_Model.ad.redirect_package.class_name arr:weakSelf.all_vip_Model.ad.redirect_package.list currectVC:weakSelf];
                
                // 统计
                [HKALIYunLogManage sharedInstance].button_id = @"5";
            };
            return cell;
        }else if (indexPath.section == 1) {
            HKAutoRenewalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKAutoRenewalCell class])];
            cell.autoBuyModel = self.allVipAutoRenewalModel;
            WeakSelf
            cell.selectBtnBlock = ^(BOOL selected) {
                weakSelf.isAutoBuy = selected;
                [weakSelf.tableView reloadData];
            };
            return cell;
        }else if (indexPath.section == 2){
            HKYeasVipPrivilegeCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKYeasVipPrivilegeCell class])];
            cell.dataSource = self.all_vip_Model.all_vip_privilege;
            cell.didMoreBlock = ^{
                HKPrivilegeVC * vc = [HKPrivilegeVC new];
                vc.dataArray = self.all_vip_Model.all_vip_privilege;
                [self pushToOtherController:vc];
            };
            return cell;
        }else{
            HKVIPPrivilegeStringCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKVIPPrivilegeStringCell class])];
            cell.privilegeContent = self.all_vip_Model.vipInfoExModel.privilegeContent;
            return cell;
        }
                
    }else{
        if (indexPath.section == 0) {
            HKVIPadsCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKVIPadsCell class])];
            [cell.adImgV sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:self.lifelong_all_vip_Model.ad.img_url]] placeholderImage:HK_PlaceholderImage];
            WeakSelf
            cell.tapClickBlock = ^{
                [HKH5PushToNative runtimePush:weakSelf.lifelong_all_vip_Model.ad.redirect_package.class_name arr:weakSelf.lifelong_all_vip_Model.ad.redirect_package.list currectVC:weakSelf];
                
                // 统计
                [HKALIYunLogManage sharedInstance].button_id = @"5";
            };
            return cell;
        }else if (indexPath.section == 1) { // VIP权限
            HKYeasVipPrivilegeCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKYeasVipPrivilegeCell class])];
            cell.dataSource = self.all_vip_Model.all_vip_privilege;
            cell.didMoreBlock = ^{
                HKPrivilegeVC * vc = [HKPrivilegeVC new];
                vc.dataArray = self.all_vip_Model.all_vip_privilege;
                [self pushToOtherController:vc];
            };
            return cell;
        }else if (indexPath.section == 2) { // 特权说明
            HKVIPPrivilegeStringCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKVIPPrivilegeStringCell class])];
            cell.privilegeContent = self.lifelong_all_vip_Model.vipInfoExModel.privilegeContent;
            return cell;
        }
        return nil;
    }
}

#pragma mark <Server>
- (void) getVIPList{
    
    NSDictionary *param = nil;
    if (self.class_type) {
        param = @{@"class_type" : self.class_type};
    }
    [HKHttpTool POST:@"/vip/vip-list" parameters:param success:^(id responseObject) {
        if (HKReponseOK) {
            //定位在哪个tab
            self.page_type = [responseObject[@"data"][@"page_type"] intValue];
            
            self.all_vip_Model= [HKBuyVipModel mj_objectWithKeyValues:responseObject[@"data"][@"all_vip_data"]];
            
            self.allVipAutoRenewalModel = [HKBuyVipModel mj_objectWithKeyValues:responseObject[@"data"][@"allVipAutoRenewalInfo"]];
            
            self.lifelong_all_vip_Model = [HKBuyVipModel mj_objectWithKeyValues:responseObject[@"data"][@"lifelong_all_vip_data"]];
            
             self.class_vip_Model = [HKBuyVipModel mj_objectWithKeyValues:responseObject[@"data"][@"class_vip_data"]];

            self.vipDataSource = [HKBuyVipModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"class_vip_list"]];
            
            self.has_lifelong_vip = [responseObject[@"data"][@"has_lifelong_vip"] boolValue];
            
            NSMutableArray * all_vip_privilege = [HKVipPrivilegeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"all_vip_privilege"]];
            self.all_vip_Model.all_vip_privilege = all_vip_privilege;
            self.allVipAutoRenewalModel.all_vip_privilege = all_vip_privilege;
            self.lifelong_all_vip_Model.all_vip_privilege = all_vip_privilege;
            
            HKVipInfoExModel * vipInfoExModel = [HKVipInfoExModel new];
            vipInfoExModel.privilegeString = @"6大权益";
            vipInfoExModel.privilegeTitle = @"特权说明";
            vipInfoExModel.privilegeContent = @"1、VIP账号可在网页、APP客户端、ipad客户端通用，享受同等权益\n2、视频中的素材源文件请至网站下载\n3、全站通VIP包含有效期内新增的分类VIP权益\n4、名师评改作品权益：全站通VIP专属权益，请至网站上“作品评改”模块上传自己的作品，虎课官方讲师会进行一对一点评\n5、周练优先点评权益：请至网站上“每周一练”模块参加练习并上传作品，虎课官方讲师会优先为您点评\n6、名师评改视频权益：全站通VIP专属权益，“视频评改”分类教程无限观看\n7、扣费成功之后VIP权益48小时内到账";
            self.all_vip_Model.vipInfoExModel = vipInfoExModel;
                        
            HKVipInfoExModel * vipInfoExModel1 = [HKVipInfoExModel new];
            vipInfoExModel1.privilegeString = @"6大权益";
            vipInfoExModel1.privilegeTitle = @"特权说明";
            vipInfoExModel1.privilegeContent = @"1、VIP账号可在网页、APP客户端、ipad客户端通用，享受同等权益\n2、视频中的素材源文件请至网站下载\n3、终身VIP包含新增的分类VIP权益\n4、名师评改作品权益：全站通VIP专属权益，请至网站上“作品评改”模块上传自己的作品，虎课官方讲师会进行一对一点评\n5、周练优先点评权益：请至网站上“每周一练”模块参加练习并上传作品，虎课官方讲师会优先为您点评\n6、名师评改视频权益：全站通VIP专属权益，“视频评改”分类教程无限观看";
            self.lifelong_all_vip_Model.vipInfoExModel = vipInfoExModel1;
            
            HKVipInfoExModel * vipInfoExModel2 = [HKVipInfoExModel new];
            vipInfoExModel2.privilegeString = @"6大权益";
            vipInfoExModel2.privilegeTitle = @"特权说明";
            vipInfoExModel2.privilegeContent = @"1、VIP账号可在网页、APP客户端、ipad客户端通用，享受同等权益\n2、素材源文件请至网站下载";
            self.class_vip_Model.vipInfoExModel = vipInfoExModel2;
            
            //self.allVipAutoRenewalModel.canAutoRenewal = NO ;
            //如果显示自动续费，默认是选中
            self.isAutoBuy = self.allVipAutoRenewalModel.canAutoRenewal ? YES : NO;
            //self.isAutoBuy = NO;
            
            [self.dataArray removeAllObjects];
            if (self.page_type == 0) {
                self.class_vip_Model.isFlag = YES;
            }else if (self.page_type == 1){
                self.all_vip_Model.isFlag = YES;
            }else if (self.page_type == 2){
                self.lifelong_all_vip_Model.isFlag = YES;
            }
            
            [self.dataArray addObject:self.class_vip_Model];
            [self.dataArray addObject:self.all_vip_Model];
            [self.dataArray addObject:self.lifelong_all_vip_Model];
            
            
            // 遍历处理附加信息
            for (HKBuyVipModel *model in self.vipDataSource) {

                // 默认选中的
                if (model.is_selected) {
                    self.selectedCategoryModel = model;
                    
                }
            }
            self.headView.dataArray = self.dataArray;
            
            //定位到当前page_type，更新数据
            [self vipHeaderViewDidScrollToPage:self.page_type];

        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark <HKOtherVipMidCellDelegate>
- (void)HKOtherVIPSelected:(HKBuyVipModel *)model {
    //self.selectedModel = model;
    self.selectedCategoryModel = model;
}


-(void)setSelectedCategoryModel:(HKBuyVipModel *)selectedCategoryModel{
    _selectedCategoryModel = selectedCategoryModel;
    self.class_vip_Model.price = selectedCategoryModel.price;
    self.class_vip_Model.categoryVipName = selectedCategoryModel.name;
    [self.headView refreshData];
    self.priceV.isClassVip = YES;
    self.priceV.vipModel = self.class_vip_Model;
    [self getVipPrivilegesList:selectedCategoryModel.vip_type];
}

#pragma mark - 分类VIP 权益列表
- (void)getVipPrivilegesList:(NSString*)page_type{
    
    if (isEmpty(page_type)) {
        return;
    }
    NSDictionary *param = @{@"vip_type" : page_type};
    [HKHttpTool POST:VIP_GET_PRIVILEGES parameters:param success:^(id responseObject) {
        if (HKReponseOK) {
            NSMutableArray<HKVipPrivilegeModel *> *vipPrivilegeArr = [HKVipPrivilegeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            self.class_vip_Model.all_vip_privilege = vipPrivilegeArr;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}


-(void)vipHeaderViewDidScrollToPage:(NSInteger)pageNumber{
    if (pageNumber != self.MobClickCount) {
        if (pageNumber == 0) {
            [MobClick event: @"C11008"];//切换分类vip
        }else if (pageNumber == 1){
            [MobClick event: @"C11006"];//切换全站通1年
        }else if (pageNumber == 2){
            [MobClick event: @"C11007"];//切换全站通终身
        }
        self.MobClickCount = pageNumber;
    }
    
    
    self.page_type = (int)pageNumber;
    if (self.page_type == 1) {
        [self setIsAutoBuy:_isAutoBuy];
    }else{
        if (self.page_type == 0) {
            self.priceV.isClassVip = YES;
            self.priceV.vipModel = self.class_vip_Model;
        }else if (self.page_type == 2){
            self.priceV.isClassVip = NO;
            self.priceV.vipModel = self.lifelong_all_vip_Model;
        }
        self.priceV.hidden = NO;
        self.protocolView.isOpenAutoBuy = NO;
        [self.buyBtn setTitle:@"立即开通" forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

-(void)setIsAutoBuy:(BOOL)isAutoBuy{
    _isAutoBuy = isAutoBuy;
    self.priceV.hidden = isAutoBuy ? YES : NO;
    self.priceV.isClassVip = NO;
    self.priceV.vipModel = self.all_vip_Model;
    [self.buyBtn setTitle:isAutoBuy ? self.allVipAutoRenewalModel.buy_button_title :@"立即开通" forState:UIControlStateNormal];
    self.protocolView.isOpenAutoBuy = self.isAutoBuy;
}


#pragma mark - VIP 发生改变
- (void)vipTypeChange:(NSString*)vipType {
    [_buyBtn setTitle:@"立即开通" forState:UIControlStateNormal];
}

- (void)makeConstraints {
    [_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(111);
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
    self.protocolView.autoBuyBtnBlock = ^{
        @strongify(self);
        NSString * webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_PRIVACY_AGREEMENT];
        HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:webUrl];
        [self pushToOtherController:htmlShowVC];
    };
    [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bottomBgView);
        make.height.mas_equalTo(40);
    }];
    
    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.protocolView.mas_bottom);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
        make.centerX.mas_equalTo(self.bottomBgView);
    }];
    
    [self.priceV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.buyBtn);
        make.left.mas_equalTo(self.buyBtn).offset(25);
        make.right.mas_equalTo(self.buyBtn).offset(-25);
        make.height.mas_equalTo(49);
    }];
}

- (UIButton*)buyBtn {
    if (_buyBtn == nil) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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
        _buyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ?19 :18 weight:UIFontWeightBold];
        [_buyBtn setTitleColor:[UIColor colorWithHexString:@"#694C2F"] forState:UIControlStateNormal];
        [_buyBtn setBackgroundColor:[UIColor colorWithHexString:@"#EFCDA6"]];
        [_buyBtn addTarget:self action:@selector(buyClickAction) forControlEvents:UIControlEventTouchUpInside];
        _buyBtn.clipsToBounds = YES;
        _buyBtn.layer.cornerRadius = 49 * 0.5;
    }
    return _buyBtn;
}

- (UIView*)bottomBgView {
    
    if (!_bottomBgView) {
        _bottomBgView = [[UIView alloc]init];
        _bottomBgView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _bottomBgView;
}

- (void)payWithResult:(HKBuyVipModel *)model payResult:(BOOL)success{
//    if (self.buyBtn && success) {
//        [_buyBtn setTitle:@"立即开通" forState:UIControlStateNormal];
//    }
    if (success) {
        HKPayResultVC *payVC = [[HKPayResultVC alloc] init];
        payVC.success = success;
        model.isBindPhone = self.isBindPhone;
        payVC.model = model;
        [self.navigationController pushViewController:payVC animated:YES];
    }
}


- (void)buyClickAction {
    if (!self.isAgree) {
        showTipDialog(@"请认真阅读服务协议并同意");
        return;
    }
    
    [MobClick event:UM_RECORD_VIP_BTN];
    [MobClick event:UM_RECORD_VIP_SINGLE_BUY];
    
    if (isLogin()) {
        if (self.has_lifelong_vip) {
            showTipDialog(@"已是最高会员不需要充值");
        }else{
            YHIAPpay *apPay = [YHIAPpay instance];
            apPay.delegate = self;
            
            HKBuyVipModel * model = nil;
            if (self.page_type == 0) {
                model = self.selectedCategoryModel;
                [MobClick event: @"C11003"];//分类vip购买

            }else if (self.page_type == 1){
                if (self.isAutoBuy) {
                    model = self.allVipAutoRenewalModel;
                    [MobClick event: @"C11002"];//全站通vip免费试用

                }else{
                    model = self.all_vip_Model;
                    [MobClick event: @"C11001"];//全站通vip购买

                }
            }else{
                model = self.lifelong_all_vip_Model;
                [MobClick event: @"C11004"];//终身vip购买

            }
            
            model.button_type = self.button_type;
            [apPay buyProductionModel:model];
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
    }else{
        [self resetUserLogin];
    }
}
    
#pragma mark - 查询 APP线上状态
- (void)checkAPPStatus {
    
    UserInfoServiceMediator *mange = [UserInfoServiceMediator sharedInstance];
    [mange checkAppStatus:^(FWServiceResponse *response) {
        if ([response.msg isEqualToString:@"1"]) {
                // 1------未通过状态
                signOut();
                YHIAPpay *apPay = [YHIAPpay instance];
                apPay.delegate = self;
                HKBuyVipModel * model = nil;
                if (self.page_type == 0) {
                    model = self.selectedCategoryModel;
                    [MobClick event: @"C11003"];//分类vip购买
                }else if (self.page_type == 1){
                    if (self.isAutoBuy) {
                        model = self.allVipAutoRenewalModel;
                        [MobClick event: @"C11002"];//全站通vip免费试用
                    }else{
                        model = self.all_vip_Model;
                        [MobClick event: @"C11001"];//全站通vip购买
                    }
                }else{
                    model = self.lifelong_all_vip_Model;
                    [MobClick event: @"C11004"];//终身vip购买
                }
                model.button_type = self.button_type;
                [apPay buyProductionModel:model];
            }
    } failBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

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


#pragma mark - 下载受限
- (void)showDownloadWarning {
    
    if (self.isShowDialg) {
        [LEEAlert alert].config
        .LeeAddTitle(^(UILabel *label) {
            
            label.text = @"缓存视频是分类SVIP、\n全站通VIP用户的特权哦~";
            label.font = [UIFont systemFontOfSize:15.0];
            label.textColor = HKColorFromHex(0x030303, 1.0);
        }).LeeAddContent(^(UILabel *label) {
            
        }).LeeAddAction(^(LEEAction *action) {
            
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

- (void)networkNotification:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    NSInteger  status  = [dict[@"status"] integerValue];
    if (status == 0) {
        showTipDialog(NETWORK_ALREADY_LOST);
    }
}

- (void)dealloc {
    [MyNotification removeObserver:self];
}

//#pragma mark ---- 屏幕切换
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}
//
//- (BOOL)prefersStatusBarHidden {
//    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
//    return NO;
//}
//
//- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
//    return UIStatusBarAnimationSlide;
//}


//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}
@end
