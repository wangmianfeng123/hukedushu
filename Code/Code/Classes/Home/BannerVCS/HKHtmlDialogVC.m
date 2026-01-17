//
//  HKHtmlDialogVC.m
//  Code
//
//  Created by Ivan li on 2018/8/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKHtmlDialogVC.h"
#import <WebKit/WebKit.h>
#import "BannerModel.h"
//#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import "WKWebViewJavascriptBridge.h"

#import "UMpopView.h"
#import "DetailModel.h"
#import "HomeVideoVC.h"
#import "HKH5PushToNative.h"
#import "XLPhotoBrowser.h"
#import "YHIAPpay.h"
//#import "HKPayResultVC.h"
#import "UIBarButtonItem+Extension.h"
#import "NSString+MD5.h"


@interface HKHtmlDialogVC ()<WKNavigationDelegate,WKUIDelegate,UMpopViewDelegate,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource, PayResultDelegate,HKCashPayDelegate>

@property(nonatomic,strong)WKWebView *webView;

@property(nonatomic,strong)NSString *web_url;
/** JS 桥梁 */
//@property WebViewJavascriptBridge* bridge;
@property WKWebViewJavascriptBridge * bridge;

/** web 调用 oc 方法 */
@property(nonatomic,copy)NSArray <NSString*>*methodArray;

@end

@implementation HKHtmlDialogVC


- (instancetype)initWithUrl:(NSString*)url {
    self = [super init];
    if (self) {
        self.web_url = url;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // 清除 JS注册的方法， 否则无法释放VC
    if (self.bridge) {
        for (NSString *methodName in self.methodArray) {
            [self.bridge removeHandler:methodName];
        }
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self brideRegisterNativeMethod];
    if (self.hiddenNavigationBar) {
        self.navigationController.navigationBar.hidden = YES;
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.hiddenNavigationBar) {
        self.navigationController.navigationBar.hidden = NO;
    }
}


- (void)dealloc {
    if (self.webView) {
        [self.webView stopLoading];
    }
    [HKWebTool clearnWebCache];
    TTVIEW_RELEASE_SAFELY(self.webView);
}



- (void)backAction {
    
    // 清除 JS注册的方法， 否则无法释放VC
    if (self.bridge) {
        for (NSString *methodName in self.methodArray) {
            [self.bridge removeHandler:methodName];
        }
    }
    
//    if (self.presentingViewController) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if (self.htmlCloseBlock) {
        self.htmlCloseBlock();
    }
}



- (void)dismissVC:(void (^)(void))completion {
      
    [self backAction];
    if (completion) {
        completion();
    }
}







- (void)createUI {
    self.view.backgroundColor = IS_IPAD ? [UIColor colorWithWhite:0.01 alpha:0.5] : [UIColor clearColor];
    [self.view addSubview:self.webView];
    [self setWebViewJavascriptBridge];
    
    if (!isEmpty(self.web_url)) {
        [self.webView loadRequest:[HKWebTool requestHeaderFieldWithUrl:self.web_url]];
    }

    // 兼容iOS11
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


- (WKWebView*)webView {
    if (!_webView) {

        _webView = [WKWebView new];
        _webView.frame = CGRectMake(IS_IPAD ? iPadContentMargin : 0, 0, IS_IPAD ? iPadContentWidth : SCREEN_WIDTH, SCREEN_HEIGHT);
        _webView.clipsToBounds = YES;
        _webView.layer.cornerRadius = PADDING_5;
        _webView.navigationDelegate= self;
        _webView.backgroundColor = [UIColor clearColor];
        //设置web 背景透明
        [_webView setOpaque:NO];
    }
    return _webView;
}



- (NSArray<NSString*>*)methodArray {
    if (!_methodArray) {
        _methodArray = @[@"share",@"H5Handle",@"goBackFrontVC",@"picEnlarge", @"HKAppleBuyJSFunction", @"Refresh" ,@"base64pic",@"openBrowser",@"saveImage",@"iosPayFuctionZFB",@"iosPayFuctionWX"];
    }
    return _methodArray;
}




- (void)closeBtnClick {
    
    [self backAction];
}




/** 给 bridge 注册OC 方法 */
- (void)brideRegisterNativeMethod {
    // JS调用OC  ----- share(分享方法)  H5Handle(常规方法跳转)  goBackFrontVC(返回前一页面)
    if (self.bridge) {
        for (NSString *methodName in self.methodArray) {
            [self registerMethodToJS:self.bridge methodName:methodName];//常规方法
        }
    }
}




#pragma mark - web 和原生建立连接
- (void)setWebViewJavascriptBridge {
    
    if (self.bridge) { return; }
//    [WebViewJavascriptBridge enableLogging];
//    self.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [WKWebViewJavascriptBridge enableLogging];
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:_webView];

    [self.bridge setWebViewDelegate:self];
    
    for (NSString *methodName in self.methodArray) {
        [self registerMethodToJS:self.bridge methodName:methodName];
    }
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad");
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
    self.htmlLoadFinishBlock ?self.htmlLoadFinishBlock(YES,self) : nil;
}



//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
}




#pragma mark - 注册 OC 方法 给 JS 调用 --JS调用OC
- (void)registerMethodToJS:(WKWebViewJavascriptBridge*) bridge methodName:(NSString *)methodName {
    WeakSelf;
    [bridge registerHandler:methodName handler:^(id data, WVJBResponseCallback responseCallback) {
        //responseCallback(@"Response from testObjcCallback");
        NSLog(@"%@, %@", methodName, [NSDate date]);
        /** share(分享方法)  H5Handle(常规方法跳转)  goBackFrontVC(返回前一页面)*/
        if ([methodName isEqualToString:@"share"]) {
            if (data) {
                ShareModel *tempModel =  [ShareModel mj_objectWithKeyValues:data];
                [weakSelf shareWithUI:tempModel];
            }
        }else if ([methodName isEqualToString:@"H5Handle"]) {
            //跳转至VC
            if (data) {
                
                [MobClick event:UM_RECORD_AD_POPUPS];
                __block HomeAdvertModel *adsModel = [HomeAdvertModel mj_objectWithKeyValues:data];
                if ([adsModel.className isEqualToString:@"LoginVC"]) {
                    [HKH5PushToNative runtimePush:adsModel.className arr:adsModel.list currectVC:self];
                }else{
                    WeakSelf;
                    [self dismissVC:^{
                        [HKALIYunLogManage sharedInstance].button_id = @"6";
                        [HKH5PushToNative runtimePush:adsModel.className arr:adsModel.list currectVC:weakSelf];
                    }];
                }

            }
        }else if ([methodName isEqualToString:@"goBackFrontVC"]) {
            //测试
            [self backAction];
        }else if ([methodName isEqualToString:@"picEnlarge"]) {
            //图片放大
            if (data) {
//                ShareModel *model =  [ShareModel mj_objectWithKeyValues:data];
//                [self setPhotoBrowserWithUrl:model.img_url];
                //图片放大
                ShareModel *model =  [ShareModel mj_objectWithKeyValues:data];

                if ([model.img_url containsString:@"http://"]||
                    [model.img_url containsString:@"https://"]) {
                    [self setPhotoBrowserWithUrl:model.img_url];
                }else{
                    [self setPhotoBrowserWithUrl:[NSString stringWithFormat:@"https:%@",model.img_url]];
                }
            }
        }else if ([methodName isEqualToString:@"HKAppleBuyJSFunction"]) {
            // 苹果支付
            if (data) {
                HKBuyVipModel *model =  [HKBuyVipModel mj_objectWithKeyValues:data];
                YHIAPpay *apPay = [YHIAPpay instance];
                apPay.delegate = self;
                [apPay buyProductionModel:model];
            }
        }else if ([methodName isEqualToString:@"Refresh"]) {
            // 刷新页面
            [self.webView loadRequest:[HKWebTool requestHeaderFieldWithUrl:self.web_url]];
            [self.webView reloadInputViews];
            
        }else if ([methodName isEqualToString:@"base64pic"]) {
            //下载图片 转换 base64 字符 给web
            ShareModel *model =  [ShareModel mj_objectWithKeyValues:data];
            [self loadImageWithURL:model.url  responseCallback:responseCallback];
            
        }else if ([methodName isEqualToString:@"openBrowser"]) {
            //跳转浏览器或APP商店
            ShareModel *model =  [ShareModel mj_objectWithKeyValues:data];
            [[UIApplication sharedApplication] openURL:HKURL(model.web_url)];
            
            
        }else if ([methodName isEqualToString:@"saveImage"]) {
            // 保存图片至相册
            ShareModel *model =  [ShareModel mj_objectWithKeyValues:data];
            [HKImagePickerController hk_savedPhotosAlbum:model.img_url];
            
        }else if ([methodName isEqualToString:@"iosPayFuctionZFB"]) {
            if (data) {
                HKBuyVipModel *model =  [HKBuyVipModel mj_objectWithKeyValues:data];
                [self hkCashpayType:HKCashPayType_AliPay buyModel:model];
            }
        }else if ([methodName isEqualToString:@"iosPayFuctionWX"]) {
            if (data) {
                HKBuyVipModel *model =  [HKBuyVipModel mj_objectWithKeyValues:data];
                [self hkCashpayType:HKCashPayType_WeChatPay buyModel:model];
            }
        }
    }];
}


#pragma mark - 下载图片
- (void)loadImageWithURL:(NSString*)url responseCallback:(WVJBResponseCallback) responseCallback {
    if (!isEmpty(url)) {
        [[SDWebImageManager sharedManager] loadImageWithURL:HKURL(url) options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
            NSString *encodedImageStr = (nil == image) ?@" " : [NSString imageToBase64Str:image];
            responseCallback(encodedImageStr);
        }];
    }
}


#pragma mark - 监听 JS 函数调用 --OC调用JS
- (void)callJsToObjc:(WKWebViewJavascriptBridge*) bridge methodName:(NSString *)methodName {
    [bridge callHandler:methodName data:@{ @"foo":@"before ready" }];
}



- (void)shareWithUI:(ShareModel*)model {
    
    UMpopView *popView = [UMpopView sharedInstance];
    [popView createUIWithModel:model];
    popView.delegate = self;
}



#pragma mark - UMpopView 代理
- (void)uMShareWebSucess:(id)sender {
    if ([sender isKindOfClass:[ShareModel class]]) {
        ShareModel *model = (ShareModel*)sender;
        [self shareSucessWithModel:model];
    }
}


- (void)uMShareWebFail:(id)sender {
    NSLog(@"分享失败");
}

- (void)uMShareImageSucess:(id)sender {
    if ([sender isKindOfClass:[ShareModel class]]) {
        ShareModel *model = (ShareModel*)sender;
        [self shareSucessWithModel:model];
    }
}

- (void)uMShareImageFail:(id)sender {
    
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



/********************** 浏览图片 *********************/

- (void)setPhotoBrowserWithUrl:(NSString *)url {
    
    if (isEmpty(url)) {
        return;
    }
    [HKPhotoBrowserTool initPhotoBrowserWithUrl:url];
}




#pragma mark <PayResultDelegate>
- (void)payWithResult:(HKBuyVipModel *)model payResult:(BOOL)success{
    
    if (success) {
        NSLog(@"h5苹果支付成功");
    } else {
        NSLog(@"h5苹果支付失败");
    }
    
    if (!success) return;
    WeakSelf;
    [LEEAlert alert].config
    .LeeAddContent(^(UILabel *label) {
        [label setFont:HK_FONT_SYSTEM(15)];
        label.textColor = [UIColor colorWithHexString:@"#030303"];
        label.text = @"购买成功";
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        action.title = @"确定";
        action.titleColor = [UIColor colorWithHexString:@"#555555"];
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            [weakSelf backAction];
        };
    })
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}




/// 微信 支付宝 支付
- (void)hkCashpayType:(HKCashPayType)payType buyModel:(HKBuyVipModel *)buyModel {
    HKCashPay *cashpay = [HKCashPay sharedInstance];
    [cashpay cashWithPayType:payType payModel:buyModel];
    cashpay.delegate = self;
}



#pragma mark --- 微信 支付宝 支付结果回调
- (void)hkCashPayWithResult:(HKBuyVipModel *)model payResult:(BOOL)success {
    
    NSLog(@"微信 支付宝 支付结果回调");
    [self cashPayResultCallObjcToJS:model payResult:success];
}


#pragma mark - 第三方支付结果 回调js
- (void)cashPayResultCallObjcToJS:(HKBuyVipModel *)model payResult:(BOOL)success {
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if (!isEmpty(model.orderNo)) {
        [dict setValue:model.orderNo forKey:@"out_trade_no"];
    }
    [dict setValue:success ? @(1) :@(0) forKey:@"is_success"];
    [self.bridge callHandler:@"paySuccess" data:dict responseCallback:^(id responseData) {
        
    }];
}

@end






