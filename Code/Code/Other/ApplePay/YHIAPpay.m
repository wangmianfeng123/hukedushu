//
//  YHIAPpay.m
//  GWSDK
//
//  Created by blazefire on 2017/8/17.
//  Copyright © 2017年 野火网络. All rights reserved.
//

#import "YHIAPpay.h"
#import "StoreKit/StoreKit.h"
#import "HKProgressHUD.h"
#import "SVProgressHUD.h"
#import "LUKeychainAccess.h"
#import "MyInfoViewController.h"
#import "YHIAPpay+Category.h"
#import "HKVersionModel.h"
#import "NSString+MD5.h"
#import "UIView+HKLayer.h"
#import "HKHttpTool.h"

#define Paying @"1" // 支付中   1
#define Payed @"2" // 支付成功   1
#define PayedAndSendReceipt @"3" // 支付成功并且上传凭证
//#define PayedCheckOK @"4" // 虎课服务器去苹果验证成功
#define PayFailed @"5" // 支付失败  1
#define PayRestored @"6" // 恢复购买  1
#define PayDeferred @"7" // 等待状态  1
#define PayUnknown @"8" // 未知状态  1

//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"

#define HKServerVIPOrderID @"HKServerVIPOrderID" //保存购买时从服务器获取生成的订单编号
#define HKServerVIPOrderIDTime @"HKServerVIPOrderIDTime" //保存购买时从服务器获取生成的订单编号的时间

#define HKServerVIPOrderBackUpID @"HKServerVIPOrderBackUpID" //保存购买时从服务器获取生成的订单编号 ，第二次备份
#define HKServerVIPOrderBackUpKeyChainID @"HKServerVIPOrderBackUpKeyChainID"  //保存购买时从服务器获取生成的订单编号到钥匙串中，防止APP卸载

#define AppStoreInfoLocalFilePath [NSString stringWithFormat:@"%@/%@/", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],@"EACEF35FE363A75A"]


@interface YHIAPpay()    <SKProductsRequestDelegate,SKPaymentTransactionObserver,SKRequestDelegate>

@property (nonatomic, copy) NSString *receipt;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, strong) NSMutableArray *productIds;

@property (nonatomic, strong)HKBuyVipModel *model;

@property (nonatomic, weak)UIView *blackProgressView;

@property (nonatomic, assign)int repairCount;// 默认3次

@property (nonatomic, assign)BOOL is_cancel_redirect;// 支付失败是否跳转


//@property (nonatomic, assign) BOOL isHomeRepairReceipt;

@end

@implementation YHIAPpay

- (NSString *)orderNo {
    if (!_orderNo.length) {
        
        // 偏好设置查询
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _orderNo = [userDefaults objectForKey:HKServerVIPOrderID];
        
        // 2次订单备份，确保万无一失
        if (!_orderNo.length) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            _orderNo = [userDefaults objectForKey:HKServerVIPOrderBackUpID];
        }
        
        // 防止删除APP
        if (!_orderNo.length) {
            _orderNo = [CommonFunction getKeyChainObject:HKServerVIPOrderBackUpKeyChainID];
        }
    }
    return _orderNo;
}


+ (instancetype)instance
{
    static YHIAPpay *payManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        payManager = [[YHIAPpay alloc] init];
    });
    return payManager;
    
}

- (NSMutableArray*)productIds {
    
    if (!_productIds) {
        _productIds = [[NSMutableArray alloc] init];
    }
    return _productIds;
}

-(instancetype)init{
    if (self = [super init]) {
        // 购买监听写在程序入口,程序挂起时移除监听,这样如果有未完成的订单将会自动执行并回调 paymentQueue:updatedTransactions:方法
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        self.productIds = [[NSMutableArray alloc] init];
    }
    return self;
}

//判断是否越狱
- (BOOL)isJailBreak{
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"]) {
        return YES;
    }
    return NO;
}



-(void)buyProductionModel:(HKBuyVipModel *)vipModel {
    
    self.touristOrderNo = nil;
    // 显示上次尚未完成的交易
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //取出购买时从服务器获取生成的订单编号的时间
    NSString *serverVIPOrderIDString = [userDefaults objectForKey:HKServerVIPOrderIDTime];
    if (serverVIPOrderIDString.length) {
        [self addProgressView:NO];
        
        //补单处理
        [self repairReceipt];
        return;
    } else {
        [self addProgressView:NO];
    }
    
    [[HKALIYunLogManage sharedInstance] applePayWithStep:@"buyProductionModel" stepDesc:@"购买vip" payInfo:@"" vipType:vipModel.vip_type];
    self.model = vipModel;
    //吊起苹果支付
    if ([SKPaymentQueue canMakePayments] && ![self isJailBreak]) {
        if (isLogin()) {
            [self getOrderWith:vipModel]; //获取内购信息;
        }else{
            //[self getProductInfo:vipModel.apple_product_id];  // 游客购买
            [self tourisBuyProductionModel:vipModel successBlock:^(NSString * _Nonnull orderNo) {
                [self getProductInfo:vipModel.apple_product_id];  // 游客购买
            } failBlock:^{
                [self getProductInfo:vipModel.apple_product_id];  // 游客购买
            }];
        }
    } else {
        [HKProgressHUD showFailure:@"您禁止应用内付费购买"];
    }
}

#pragma mark--2.请求服务器生成预订单
-(void)getOrderWith:(HKBuyVipModel *)buyVipModel {
    [[HKALIYunLogManage sharedInstance] applePayWithStep:@"getOrderWith" stepDesc:@"请求服务器生成预订单" payInfo:@"" vipType:buyVipModel.vip_type];
    
    [HKProgressHUD showLoading:@"正在购买，请稍后..."];
    [[UserInfoServiceMediator sharedInstance] setVipOrderWithToken:[CommonFunction getUserToken] model:buyVipModel completion:^(FWServiceResponse *response) {
        
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
            self.orderNo = [response.data objectForKey:@"out_trade_no"];
            self.is_cancel_redirect = [[response.data objectForKey:@"is_cancel_redirect"] boolValue];
            // 保存服务器的订单编号和生成订单编号的时间
            [self saveServerOrderId:self.orderNo];
            
            // 2次备份
            if (self.orderNo.length) {
                NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                //保存购买时从服务器获取生成的订单编号 ，第二次备份
                [userdefaults setObject:self.orderNo forKey:HKServerVIPOrderBackUpID];
                [userdefaults synchronize];
                
                //保存购买时从服务器获取生成的订单编号到钥匙串中，防止APP卸载
                [CommonFunction setKeyChainObject:HKServerVIPOrderBackUpKeyChainID value:self.orderNo];
            }
            
            //获取内购信息;
            [self getProductInfo:buyVipModel.apple_product_id];
        }else{
            // 修改蒙版状态
            [self.blackProgressView removeFromSuperview];
            if (![response.code isEqualToString: @"-1"] && ![response.code isEqualToString:@"401"]) {
                [HKProgressHUD showMessage:response.msg];
            }
            
        }
    } failBlock:^(NSError *error) {
        // 修改蒙版状态
        [self.blackProgressView removeFromSuperview];
        [HKProgressHUD showFailure:@"生成订单失败，请联系客服"];
    }];
}


#pragma mark - 刷新应用程序收据
- (void)restoreRefreshRequest {
    
    SKReceiptRefreshRequest *request = nil;
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSString *receipt = [receiptData base64EncodedStringWithOptions:0];
    
    request = [[SKReceiptRefreshRequest alloc] initWithReceiptProperties:@{SKReceiptPropertyIsVolumePurchase:receipt}];
    request.delegate = self;
    [request start];
    showTipDialog(@"正在恢复");
}

#pragma mark--3.从Apple查询用户点击购买的产品的信息
- (void)getProductInfo:(NSString *)productIdentifier {
    [[HKALIYunLogManage sharedInstance] applePayWithStep:@"getProductInfo" stepDesc:@"从Apple查询用户点击购买的产品的信息" payInfo:@"" vipType:@""];
    NSLog(@"--------------------------------请求对应的产品信息----------------------------------");
    NSArray *product = [[NSArray alloc] initWithObjects:productIdentifier, nil];
    NSSet *set = [NSSet setWithArray:product];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

#pragma mark--<SKProductsRequestDelegate>
// 查询成功后的回调
// 接收到产品的返回信息,然后用返回的商品信息进行发起购买请求
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    [[HKALIYunLogManage sharedInstance] applePayWithStep:@"productsRequest:didReceiveResponse:" stepDesc:@"查询成功后的回调" payInfo:@"" vipType:@""];
    NSLog(@"-------------------------收到产品反馈消息-------------------------------");
    
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
        NSLog(@"--------------没有商品------------------");
        [HKProgressHUD showFailure:@"无法获取产品信息，请重试"];
        return;
    }
    for(SKProduct *product in myProduct){
        NSLog(@"Detail product info\n");
        NSLog(@"SKProduct description: %@\n", [product description]);
        NSLog(@"Product localized title: %@\n" , product.localizedTitle);
        NSLog(@"Product localized descitption: %@\n" , product.localizedDescription);
        NSLog(@"Product price: %@\n" , product.price);
        NSLog(@"Product priceLocale: %@\n" , product.priceLocale.localeIdentifier);
        NSLog(@"Product identifier: %@\n" , product.productIdentifier);
        //        NSLog(@"游戏传进来的产品价格：%@\n", product.);
    }
    //购买商品
    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//查询失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [[HKALIYunLogManage sharedInstance] applePayWithStep:@"request:didFailWithError:" stepDesc:@"查询失败后的回调" payInfo:@"" vipType:@""];
    if (error) {
        [self removeServerOrderId];
    }
    
    [HKProgressHUD showFailure:[error localizedDescription]];
    NSLog(@"------------------查询商品信息错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request
{
    //[HKProgressHUD hide];
    NSLog(@"------------查询商品反馈信息结束-----------------");
    if ([request isKindOfClass:[SKReceiptRefreshRequest class]]) {
        //[HKProgressHUD showInfoMsg:@"正在恢复"];
    }
    
}

#pragma mark--4.购买操作后的回调
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions)
    {
        
        [[HKALIYunLogManage sharedInstance] applePayWithStep:@"paymentQueue:updatedTransactions:" stepDesc:@"购买操作后的回调" payInfo:@"" vipType:@""];
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
            {
                // 普通购买，以及第一次购买自动订阅
                NSLog(@"普通购买，以及第一次购买自动订阅");
                // 完成支付，去服务器验证
                //2
                [self checkReceiptIsValid:@"" orederNo:self.orderNo setp:Payed];
                [self checkTourisReceiptIsValidWithStep:Payed receipt:@""];
                
                if (self.iapSuccessBlock) {
                    self.iapSuccessBlock();
                }
                NSLog(@"购买成功 -- %@", transaction);
                [self completeTransaction:transaction];
            }
                break;
                
            case SKPaymentTransactionStateFailed://交易失败{}
            {
                [HKProgressHUD showMessage:@"购买失败"];
                //5
                [self checkReceiptIsValid:@"" orederNo:self.orderNo setp:PayFailed];
                [self checkTourisReceiptIsValidWithStep:PayFailed receipt:@""];
                [self failedTransaction:transaction];
                
                if ([[transaction.error.userInfo allKeys] containsObject:@"NSUnderlyingError"]) {
                    NSError * error = transaction.error.userInfo[@"NSUnderlyingError"];
                    if ([[error.userInfo allKeys] containsObject:@"NSUnderlyingError"]) {
                        NSError * error1 = error.userInfo[@"NSUnderlyingError"];
                        if (error1.localizedDescription.length || error1.localizedFailureReason.length) {
                            [[HKALIYunLogManage sharedInstance] applePayWithStep:@"paymentQueue:updatedTransactions:" stepDesc:@"购买操作后的回调" payInfo:[NSString stringWithFormat:@"%@=%@",error1.localizedDescription,error1.localizedFailureReason] vipType:@""];
                        }
                    }else{
                        if (transaction.error.localizedDescription.length || transaction.error.localizedFailureReason.length) {
                            [[HKALIYunLogManage sharedInstance] applePayWithStep:@"paymentQueue:updatedTransactions:" stepDesc:@"购买操作后的回调" payInfo:[NSString stringWithFormat:@"%@=%@",transaction.error.localizedDescription,transaction.error.localizedFailureReason] vipType:@""];
                        }
                    }
                }else{
                    if (transaction.error.localizedDescription.length || transaction.error.localizedFailureReason.length) {
                        [[HKALIYunLogManage sharedInstance] applePayWithStep:@"paymentQueue:updatedTransactions:" stepDesc:@"购买操作后的回调" payInfo:[NSString stringWithFormat:@"%@=%@",transaction.error.localizedDescription,transaction.error.localizedFailureReason] vipType:@""];
                    }
                }
            }
                //
                
                
                
                
                break;
                
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [HKProgressHUD showMessage:@"恢复购买成功"];
                //6
                [self checkReceiptIsValid:@"" orederNo:self.orderNo setp:PayRestored];
                [self checkTourisReceiptIsValidWithStep:PayRestored receipt:@""];
                [self restoreTransaction:transaction];
                break;
                
            case SKPaymentTransactionStatePurchasing://商品添加进列表
                // 准备支付
                // 1
                [self checkReceiptIsValid:@"" orederNo:self.orderNo setp:Paying];
                [self checkTourisReceiptIsValidWithStep:Paying receipt:@""];
                [HKProgressHUD showMessage:@"正在请求付费信息，请稍后"];
                break;
            case SKPaymentTransactionStateDeferred: // 等待/Users/ivanli/Desktop/com.cainiu.HuKeWang 2019-10-31 12:09.26.451.xcappdata/AppData/Documents/test.plist状态
                //等待确认，儿童模式需要询问家长同意
                // 准备支付
                // 7
                [self checkReceiptIsValid:@"" orederNo:self.orderNo setp:PayDeferred];
                [self checkTourisReceiptIsValidWithStep:PayDeferred receipt:@""];
                break;
            default:
                //                [self removeServerOrderId];
                // 8
                [self checkReceiptIsValid:@"" orederNo:self.orderNo setp:PayUnknown];
                [self checkTourisReceiptIsValidWithStep:PayUnknown receipt:@""];
                NSLog(@"I have no know");
                break;
        }
    }
}


//购买结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [[HKALIYunLogManage sharedInstance] applePayWithStep:@"completeTransaction:" stepDesc:@"购买结束" payInfo:@"" vipType:@""];
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    self.receipt = [receiptData base64EncodedStringWithOptions:0];
    //保存票据
    [self saveReceipt:self.receipt orderNo:self.orderNo];
    
    // 修改蒙版状态
    [self addProgressView:YES];
    
    if (isLogin()) {
        [self checkReceiptIsValid:self.receipt orederNo:self.orderNo setp:PayedAndSendReceipt];//把receipt发送到服务器验证是否有效
    }else{
        if (APPSTATUS) {
            [self checkTourisReceiptIsValidWithStep:PayedAndSendReceipt receipt:self.receipt];
            [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:NO];
        }
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

//购买失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    [[HKALIYunLogManage sharedInstance] applePayWithStep:@"failedTransaction:" stepDesc:@"购买失败" payInfo:@"" vipType:@""];
    [self removeServerOrderId];
    if(transaction.error.code != SKErrorPaymentCancelled) {
        //        [HKProgressHUD showMessage:@"购买失败，请重试"];
    } else {
        //        [HKProgressHUD showMessage:@"取消交易"];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    // 提示失败
    [self removeProgressView];
    
    [self popAlertView];
    
    if ([self.delegate respondsToSelector:@selector(payWithResult:payResult:)]) {
        self.model.orderNo = self.orderNo;
        [self.delegate payWithResult:self.model payResult:NO];
    }
}

- (void)popAlertView{
    NSString * url = [HKInitConfigManger sharedInstance].configModel.iosPayCancelRedirectUrl;
    
    NSString * date = [DateChange getCurrentTime_day];
    NSString * oldDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"flagday"];
    
    if (url.length && self.is_cancel_redirect && !APPSTATUS && [date isEqualToString:oldDate]) {
        UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 330, 270)];
        
        UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake((330 - 75) * 0.5, 20, 80, 80)];
        img.image = [UIImage imageNamed:@"img_matter_popup_2_40"];
        [contentView addSubview:img];
        
        UILabel * contentLabel = [UILabel labelWithTitle:CGRectMake((330 - 250) * 0.5, CGRectGetMaxY(img.frame) + 25, 250, 80) title:@"您好像支付过程遇到了问题？点此跳转m站支付" titleColor:COLOR_27323F_EFEFF6 titleFont:@"17" titleAligment:NSTextAlignmentCenter];
        contentLabel.numberOfLines = 2;
        [contentView addSubview:contentLabel];
        
        UIButton * btn = [UIButton buttonWithTitle:@"了解一下" titleColor:[UIColor whiteColor] titleFont:@"17" imageName:@""];
        btn.frame = CGRectMake((330 - 280) * 0.5, CGRectGetMaxY(contentLabel.frame)+ 10, 280, 46);
        [btn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [btn addCornerRadius:23];
        [btn addGradientLayerColors:@[(id)[UIColor colorWithHexString:@"#FF8A00"].CGColor,(id)[UIColor colorWithHexString:@"#FFB600"].CGColor]];
        [contentView addSubview:btn];
        [UILabel changeLineSpaceForLabel:contentLabel WithSpace:5];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        
        
        
        UIButton * closeBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor whiteColor] titleFont:@"17" imageName:@"ic_close_popup_2_40"];
        closeBtn.frame = CGRectMake(330 - 50, -20, 50, 50);
        [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:closeBtn];
        
        [LEEAlert alert].config
            .LeeCustomView(contentView)
            .LeeMaxWidth(330)
            .LeeHeaderColor(COLOR_FFFFFF_3D4752)
            .LeeShouldAutorotate(IS_IPAD?YES:NO)
            .LeeCloseAnimationDuration(0)
            .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
            .LeeShow();
        
        [MobClick event:@"C11010"];
        
    }else{
        
        if (self.is_cancel_redirect) {
            [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"flagday"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        WeakSelf
        [LEEAlert alert].config
            .LeeAddTitle(^(UILabel *label) {
                label.text = @"提示";
                label.textColor = [UIColor blackColor];
                label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
            })
            .LeeAddContent(^(UILabel *label) {
                label.text = @"对不起，支付没有成功，麻烦再试一次吧";
                label.textColor = [UIColor blackColor];
                label.font = [UIFont systemFontOfSize:14.0];
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeDefault;
                action.title = @"再试一次";
                action.titleColor = [UIColor colorWithHexString:@"#0076FF"];
                action.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
                action.backgroundColor = [UIColor whiteColor];
                action.clickBlock = ^{
                    if (weakSelf.model) {
                        [weakSelf buyProductionModel:weakSelf.model];
                    }
                };
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeCancel;
                action.title = @"取消";
                action.titleColor = [UIColor colorWithHexString:@"#0076FF"];
                action.backgroundColor = [UIColor whiteColor];
                action.font = [UIFont systemFontOfSize:15.0];
                action.clickBlock = ^{
                };
            })
            .LeeHeaderColor([UIColor whiteColor])
            .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
            .LeeShow();
    }
}

- (void)sureBtnClick{
    if (self.model) {
        [[HKALIYunLogManage sharedInstance]shortVideoClickLogWithIdentify:@"7"];
        NSString * url = [HKInitConfigManger sharedInstance].configModel.iosPayCancelRedirectUrl;
        //跳转浏览器
        if ([NSString isUrl:url]) {
            [MobClick event:@"C11011"];
            [[UIApplication sharedApplication] openURL:HKURL(url)];
        }
    }
    [LEEAlert closeWithCompletionBlock:nil];
}

- (void)closeBtnClick{
    [LEEAlert closeWithCompletionBlock:nil];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [self removeServerOrderId];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


#pragma mark--5.向服务器端验证购买凭证的有效性
//从服务端获取生成的订单信息，购买成功之后，需要和后台进行验证
- (void)checkReceiptIsValid:(NSString *)receipt orederNo:(NSString *)orderNo setp:(NSString *)step {
    
    // 处理空对象
    receipt = receipt? receipt : @"";
    orderNo = orderNo? orderNo : @"";
    step = step? step : @"";
    NSString *orderTemp = self.orderNo;
    [[HKALIYunLogManage sharedInstance] applePayWithStep:@"checkReceiptIsValid:orederNo:setp:" stepDesc:@"向服务器验证购买凭证" payInfo:receipt vipType:@""];
    //NSLog(@"++++++++++++++%@ ++++ %@",step,orderNo);
    [[UserInfoServiceMediator sharedInstance]checkReceiptIsValid:[CommonFunction getUserToken]
                                                         receipt:receipt orederNo:orderNo setp:step
                                                      completion:^(FWServiceResponse *response) {
        
        
        NSString *pay_step_signal = [NSString stringWithFormat:@"%@", response.data[@"pay_step_signal"]];
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
            if([[response.data allKeys] containsObject:@"business_code"]){
                int code = [response.data[@"business_code"] intValue];
                if (code == 204) {
                    //服务器校验订单存在
                    // 预留意想不到的情况 清除购买记录
                    [self deleteAllRecord];
                    // 移除蒙版
                    [self removeProgressView];
                    showTipDialog(response.msg);
                    [[HKALIYunLogManage sharedInstance] applePayWithStep:@"checkReceiptIsValid:orederNo:setp:" stepDesc:@"向服务器验证购买凭证，验证失败返回204" payInfo:receipt vipType:@""];
                    return;
                }
            }
            
            [[HKALIYunLogManage sharedInstance] applePayWithStep:@"checkReceiptIsValid:orederNo:setp:" stepDesc:[NSString stringWithFormat:@"向服务器验证购买凭证，pay_step_signal:%@",pay_step_signal] payInfo:receipt vipType:@""];
            
            if (pay_step_signal && [pay_step_signal isEqualToString:@"3"]) {
                NSString *vip_price = [NSString stringWithFormat:@"%@", response.data[@"vip_price"]];
                
                [[HKALIYunLogManage sharedInstance] applePayWithOrder_id:orderNo payPrice:vip_price];
                
                // 验证成功 付款成功 并且完成票据接受
                //[self deleteReceipt:orderNo]; //删除票据
                [self deleteAllRecord];
                [HKProgressHUD showMessage:@"验证成功"];
                [self checkUserVipType]; //查询VIP类型
                
                // 发送购买成功VIP的通知
                HKBuyVipModel *model = [HKBuyVipModel mj_objectWithKeyValues:response.data];
                NSDictionary *dict = nil;
                if (model) {
                    dict = @{@"model":model};
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:HKBuyVIPSuccessNotification object:nil userInfo:dict];
                //[[NSNotificationCenter defaultCenter] postNotificationName:HKBuyVIPSuccessNotification object:dict];
                //[self removeServerOrderId];
                // 移除蒙版
                [self removeProgressView];
                if ([self.delegate respondsToSelector:@selector(payWithResult:payResult:)]) {
                    self.model.orderNo = orderTemp;
                    [self.delegate payWithResult:self.model payResult:YES];
                }
                
            } else if (pay_step_signal && [pay_step_signal isEqualToString:@"1"]) {
                // 付款中
            } else if (pay_step_signal && [pay_step_signal isEqualToString:@"2"]) {
                // 付款成功
            } else if (pay_step_signal && [pay_step_signal isEqualToString:@"10000"]) {
                // 预留意想不到的情况 清除购买记录
                [self deleteAllRecord];
            }
        } else{
            [[HKALIYunLogManage sharedInstance] applePayWithStep:@"checkReceiptIsValid" stepDesc:@"向服务器验证购买凭证，response.code != 1" payInfo:receipt vipType:@""];
            // 移除蒙版
            [self removeProgressView];
            
            [HKProgressHUD showMessage:response.msg];
        }
    } failBlock:^(NSError *error) {
        // 移除蒙版
        [self removeProgressView];
        showTipDialog(@"网络出错或者服务器出错，请稍等或联系客服...");
        NSInteger count = [step intValue];
        if (2 == count || 3 == count ) {
            [self repairReceipt];
        }
    }];
}

#pragma mark--6.持久化存储用户购买凭证
-(void)saveReceipt:(NSString *)receipt orderNo:(NSString *)orderNo {
    [[HKALIYunLogManage sharedInstance] applePayWithStep:@"saveReceipt:orderNo:" stepDesc:@"持久化存储用户购买凭证" payInfo:receipt vipType:@""];
    if (isEmpty(receipt) || isEmpty(orderNo)) {
        return;
    }
    //    if ([receipt isEqualToString:@""] || [orderNo isEqualToString:@""]) {
    //            return;
    //    }
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath stringByAppendingPathComponent:@"test.plist"];
    NSMutableDictionary *allData = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath: filename]) {
        allData = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    }else {
        allData = [[NSMutableDictionary alloc] init];
    }
    
    if (orderNo) {
        //添加一项内容
        [allData setObject:receipt forKey:orderNo];
        //[allData setObject:[CommonFunction getUserId] forKey:USER_ID];
        //写入
        if ([allData writeToFile:filename atomically:YES]) {
            NSLog(@"本地保存票据 ok");
        }else{
            //
            [allData writeToFile:filename atomically:YES];
        }
    }
}


#pragma mark -删除票据
//购买流程正常完成，移除票据
- (void)deleteReceipt:(NSString *)orderNo {
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath stringByAppendingPathComponent:@"test.plist"];
    
    NSMutableDictionary *allData = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath: filename]) {
        allData = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    } else {
        allData = [[NSMutableDictionary alloc] init];
    }
    
    NSArray *orderArr = [allData allKeys];
    if ([orderArr count] > 0) {
        if (orderNo) {
            //删除一项内容
            NSObject *obj = [allData objectForKey:orderNo];
            if (obj) {
                [allData removeObjectForKey:orderNo];
                NSString * orderReceipt = (NSString *)obj;
                [[HKALIYunLogManage sharedInstance] applePayWithStep:@"deleteReceipt:" stepDesc:@"购买流程正常完成，移除票据" payInfo:orderReceipt vipType:@""];
            }
            //            else {// 开发测试时候的错误数据
            //                [allData removeObjectForKey:orderArr[0]];
            //            }
            //写入
            [allData writeToFile:filename atomically:YES];
            NSLog(@"移除票据 ok");
        }
    }
}


//补单逻辑
- (void)repairReceipt {
    // 每次重启默认补单3次
    if (++self.repairCount > 3) return;
    
    //获取应用程序沙盒的Documents目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath stringByAppendingPathComponent:@"test.plist"];
    //保存的订单字典，key是订单编号 values为订单凭证
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath: filename])
    {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    }
    else
    {
        data = [[NSMutableDictionary alloc] init];
    }
    //获取订单
    if (data && [data count]>0) {
        
        //[HKProgressHUD showMessage:@"您有未完成的订单"];
        //找出未完成的订单
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *orderArr = [data allKeys];
            NSArray *receiptArr = [data allValues];
            for (int i = 0; i<[orderArr count]; i++) {
                NSString *orderStr = [orderArr objectAtIndex:i];
                orderStr = orderStr.length? orderStr : self.orderNo;
                NSString *receiptStr = [receiptArr objectAtIndex:i];
                
                [[HKALIYunLogManage sharedInstance] applePayWithStep:@"repairReceipt" stepDesc:@"补单" payInfo:receiptStr vipType:@""];
                
                //服务器验证
                if (isLogin()) [self checkReceiptIsValid:receiptStr orederNo:orderStr setp:PayedAndSendReceipt];
            }
        });
    }else{
        [[HKALIYunLogManage sharedInstance] applePayWithStep:@"repairReceipt" stepDesc:@"不存在未验证的订单号" payInfo:@"" vipType:@""];
        [self removeProgressView];
        [self removeServerOrderId];
    }
}


//验证游客购买
- (void)verifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)flag {//flag = yes 沙盒验证 否则正式验证
    [[HKALIYunLogManage sharedInstance] applePayWithStep:@"verifyPurchaseWithPaymentTransaction:isTestServer:" stepDesc:@"验证游客购买" payInfo:@"" vipType:@""];
    //交易验证
    NSString *orderTemp = self.orderNo;
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    if(!receipt){
        dispatch_async(dispatch_get_main_queue(), ^{
            showTipDialog(@"凭证为空验证失败");
        });
        return;
    }
    //[self handleActionWithType:kIAPPurchSuccess data:receipt]; // 购买成功将交易凭证发送给服务端进行再次校验
    NSError *error;
    
    
    //exclude-old-transactions  password:72642461fbb140a7a909081ee1fe6866
    
    NSDictionary *requestContents = [NSDictionary dictionary];
    if (self.model.canAutoRenewal) {
        requestContents = @{ @"receipt-data": [receipt base64EncodedStringWithOptions:0] ,@"exclude-old-transactions":@1 ,@"password":[[NSUserDefaults standardUserDefaults] objectForKey:APP_PassWord]};
    }else{
        requestContents = @{ @"receipt-data": [receipt base64EncodedStringWithOptions:0] ,@"exclude-old-transactions":@0 ,@"password":[[NSUserDefaults standardUserDefaults] objectForKey:APP_PassWord]};
    }
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents options:0 error:&error];
    if (!requestData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            showTipDialog(@"凭证为空验证失败");
        });
        return;
    }
    NSLog(@"票据信息--%@",requestContents);
    
    NSString *serverString = @"https://buy.itunes.apple.com/verifyReceipt";
    if (flag) {
        serverString = @"https://sandbox.itunes.apple.com/verifyReceipt";
    }
    NSURL *storeURL = [NSURL URLWithString:serverString];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) { // 无法连接服务器,购买校验失败
            dispatch_async(dispatch_get_main_queue(), ^{
                showTipDialog(@"校验数据失败,请重试");
            });
        } else {
            NSError *error;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (!jsonResponse) {
                // 苹果服务器校验数据返回为空校验失败
                dispatch_async(dispatch_get_main_queue(), ^{
                    showTipDialog(@"校验数据失败,请重试");
                });
            }
            // 先验证正式服务器,如果正式服务器返回21007再去苹果测试服务器验证,沙盒测试环境苹果用的是测试服务器
            NSString *status = [NSString stringWithFormat:@"%@",jsonResponse[@"status"]];
            
            if (status && [status isEqualToString:@"21007"]) {
                
                [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:YES];
                
            }else if(status && [status isEqualToString:@"0"]){
                //设置VIP
                dispatch_async(dispatch_get_main_queue(), ^{
                    //showTipDialog(@"购买完成");
                    [self deleteReceipt:self.orderNo];
                    [self removeServerOrderId];
                    [CommonFunction setTouristVIPStatus];
                    
                    // 发送购买成功VIP的通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:HKBuyVIPSuccessNotification object:nil];
                    
                    [self removeProgressView];
                    if ([self.delegate respondsToSelector:@selector(payWithResult:payResult:)]) {
                        self.model.orderNo = orderTemp;
                        [self.delegate payWithResult:self.model payResult:YES];
                    }
                });
            }
            NSLog(@"----验证结果 %@",jsonResponse);
            // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        } }];
}


#pragma mark - 设置偏好设置存储
- (void)saveServerOrderId:(NSString *)orderId{
    [[HKALIYunLogManage sharedInstance] applePayWithStep:@"saveServerOrderId" stepDesc:@"保存购买时从服务器获取生成的订单编号" payInfo:@"" vipType:@""];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    //保存购买时从服务器获取生成的订单编号
    [userdefaults setObject:orderId forKey:HKServerVIPOrderID];
    
    // 保存时间
    NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dataString = [dateFormatter stringFromDate:currentDate];
    [userdefaults setObject:dataString forKey:HKServerVIPOrderIDTime];
    [userdefaults synchronize];
}

- (void)removeServerOrderId{
    [[HKALIYunLogManage sharedInstance] applePayWithStep:@"removeServerOrderId" stepDesc:@"移除购买时从服务器获取生成的订单编号" payInfo:@"" vipType:@""];
    _orderNo = nil;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:nil forKey:HKServerVIPOrderID];
    [userdefaults setObject:nil forKey:HKServerVIPOrderIDTime];
    [userdefaults synchronize];
}

#pragma mark - 查询VIP 类型
//- (void)checkUserVipType {
//
//    if (isLogin()) {
//        UserInfoServiceMediator *mange = [UserInfoServiceMediator sharedInstance];
//        [mange checkUserVipType:[CommonFunction getUserToken] completion:^(FWServiceResponse *response) {
//            //vip_type:0-非VIP 1-分类VIP 2-全站通VIP。
//            if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
//                if (response.data != nil) {
//                    NSString * type =[NSString stringWithFormat:@"%@",[response.data objectForKey:@"vip_type"]];;
////                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////                    NSLog(@"VIP---%@",type);
////                    [defaults setObject:type forKey:LOGIN_VIP_TYPE];
////                    [defaults synchronize];
//
//                    // 更新账号
//                    HKUserModel *updateModel = [HKAccountTool shareAccount]; updateModel.vip_type = type;
//                    [HKAccountTool saveOrUpdateAccount:updateModel];
//                }
//            }
//        } failBlock:^(NSError *error) {
//
//        }];
//    }
//}




#pragma mark - 获取额外个人数据  查询VIP 类型
- (void)checkUserVipType {
    
    [[UserInfoServiceMediator sharedInstance] getUserExtInfoCompletion:^(FWServiceResponse *response) {
        //vip_type:0-非VIP 1-分类VIP 2-全站通VIP 3- 终身VIP
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            if (response.data != nil) {
                //NSString *vip_type = [NSString stringWithFormat:@"%@",[response.data objectForKey:@"vip_type"]];
                NSString *vip_class = [NSString stringWithFormat:@"%@",[response.data objectForKey:@"vip_class"]];
                // 更新账号
                HKUserModel *updateModel = [HKAccountTool shareAccount];
                updateModel.vip_class = vip_class;
                [HKAccountTool saveOrUpdateAccount:updateModel];
            }
        }
    } failBlock:^(NSError *error) {
        
    }];
}






- (void)removeProgressView {
    if (self.blackProgressView) {
        [self.blackProgressView removeFromSuperview];
    }
}

- (void)addProgressView:(BOOL)serverProgressing {
    
    if (self.blackProgressView) {
        [self.blackProgressView removeFromSuperview];
    }
    
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    myView.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:myView];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];//指定进度轮的大小
    [activity setCenter:CGPointMake(myView.width * 0.5, myView.height * 0.5)];//指定进度轮中心点
    activity.tag = 520;
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    [activity startAnimating];
    
    // 显示上次尚未完成的交易
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *serverVIPOrderIDString = [userDefaults objectForKey:HKServerVIPOrderID];
    
    // 虎课服务器验证等待
    if (serverProgressing) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14.0];
        label.text = @"正在处理，请稍后...";
        [label sizeToFit];
        label.center = activity.center;
        label.y = CGRectGetMaxY(activity.frame) + 20;
        [myView addSubview:label];
    } else if (serverVIPOrderIDString.length) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14.0];
        label.text = @"上次交易进行中，请耐心等待切勿退出App...";
        [label sizeToFit];
        label.center = activity.center;
        label.y = CGRectGetMaxY(activity.frame) + 20;
        [myView addSubview:label];
    } else {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14.0];
        label.text = @"购买中，请耐心等待切勿退出App...";
        [label sizeToFit];
        label.center = activity.center;
        label.y = CGRectGetMaxY(activity.frame) + 20;
        [myView addSubview:label];
    }
    
    [myView addSubview:activity];
    
    self.blackProgressView = myView;
    
}


//移除监听
-(void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}



/** 删除所有的购买记录  */
- (void)deleteAllRecord {
    [[HKALIYunLogManage sharedInstance] applePayWithStep:@"deleteAllRecord" stepDesc:@"移除钥匙串中购买时从服务器获取生成的订单编号" payInfo:@"" vipType:@""];
    LUKeychainAccess *keychain = [LUKeychainAccess standardKeychainAccess];
    [keychain deleteObjectForKey:HKServerVIPOrderBackUpKeyChainID];
    [self deleteReceipt:self.orderNo];
    [self removeServerOrderId];
}




/// 记录游客订单步骤
- (void)checkTourisReceiptIsValidWithStep:(NSString*)step  receipt:(NSString *)receipt {
    [[HKALIYunLogManage sharedInstance] applePayWithStep:@"checkTourisReceiptIsValidWithStep:receipt:" stepDesc:@"记录游客订单步骤" payInfo:receipt vipType:@""];
    if (NO == isEmpty(self.touristOrderNo)) {//如果游客订单号存在，则为游客购买
        //[self checkReceiptIsValid:receipt orederNo:self.touristOrderNo setp:step];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:self.touristOrderNo forKey:@"out_trade_no"];
        [dict setValue:step forKey:@"state"];
        [dict setValue:receipt forKey:@"receipt"];
        [HKHttpTool POST:PAY_IOS_REVIEW_ORDER_RECORD parameters:dict success:^(id responseObject) {
            if (HKReponseOK) {
                NSLog(@" PAY_IOS_REVIEW_ORDER_RECORD ");
            }
        } failure:^(NSError *error) {
            
        }];
    }
}




- (void)buttonRestoreClick:(id)sender {
    [self restoreRefreshRequest];
    //[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}



- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue NS_AVAILABLE(10_7, 3_0) {
    NSMutableArray *purchasedItemIDs = [[NSMutableArray alloc] init];
    //NSLog(@"received restored transactions: %i", queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        [purchasedItemIDs addObject:productID];
        NSLog(@"%@",purchasedItemIDs);
    }
}


- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error API_AVAILABLE(ios(3.0), macos(10.7), watchos(6.2)) {
    NSLog(@"restoreCompletedTransactionsFailedWithError");
}



@end





