//
//  HtmlShowVC.m
//  Code
//
//  Created by Ivan li on 2017/10/19.
//  Copyright © 2017年 pg. All rights reserved.11
//

#import "HtmlShowVC.h"
#import <WebKit/WebKit.h>
#import "BannerModel.h"
//#import "WebViewJavascriptBridge.h"
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
#import "HKHtmlTipView.h"

#import "SearchBar.h"
#import "PYSearch.h"
#import "SearchResultVC.h"
#import "TagModel.h"

#import "HKFetchMedalView.h"
#import "HKhtmlModel.h"

@interface HtmlShowVC ()<WKNavigationDelegate,WKUIDelegate,UMpopViewDelegate,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource, PayResultDelegate,HKCashPayDelegate,UIScrollViewDelegate,PYSearchViewControllerDelegate,PYSearchViewControllerDataSource>

@property(nonatomic,strong)WKWebView *webView;

@property(nonatomic,strong)NSString *web_url;
/** 进度条 */
@property(nonatomic,strong)UIProgressView *progressView;
/** JS 桥梁 */
//@property WebViewJavascriptBridge* bridge;
@property WKWebViewJavascriptBridge * bridge;


@property(nonatomic,copy)NSArray <NSString*>*methodArray;

@property (nonatomic, copy)NSString *open_share; // 是否开启分享

@property (nonatomic, copy)NSString *trigger_name;// 开启分享调用JS的名称

@property(nonatomic,strong)HKMapModel *liveMapModel;

@property (nonatomic, copy) NSString * isTabModule;  //如果是tab上需要隐藏按钮
@property (nonatomic, copy) NSString * isFromSearch;  //从搜索页面跳转过来
@property (nonatomic , strong) HKHtmlTipView * tipView;

/** 搜索栏 */
@property(nonatomic,strong)SearchBar *searchBar;
@property (nonatomic, weak) PYSearchViewController *searchViewController;
@property(nonatomic,strong)NSMutableArray<NSString*> *searchHistoryArray;
@property(nonatomic,strong)NSMutableArray<NSString*> *hotWordArray;
@property(nonatomic,strong)NSMutableArray<NSString*> *suggestArray;
@property(nonatomic,strong) NSMutableArray <NSURLSessionDataTask *> *sessionTaskArray;
@property(nonatomic,strong)NSMutableArray * redirectWordsArray;
@property (nonatomic , strong) HKFetchMedalView * medalView;
@end

@implementation HtmlShowVC

//搜索记录
- (NSMutableArray<NSString*>*)searchHistoryArray {
    if (!_searchHistoryArray) {
        _searchHistoryArray = [NSMutableArray array];
    }
    return _searchHistoryArray;
}

- (NSMutableArray<NSString*>*)hotWordArray {
    if (!_hotWordArray) {
        _hotWordArray = [NSMutableArray array];
    }
    return  _hotWordArray;
}

- (NSMutableArray <NSURLSessionDataTask *> *)sessionTaskArray{
    if (!_sessionTaskArray) {
        _sessionTaskArray = [NSMutableArray array];
    }
    return _sessionTaskArray;
}

- (BOOL)shouldAutorotate {
    if (IS_IPAD) {
        return YES;
    }
    return YES;
}
//
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (IS_IPAD) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}



- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(BannerModel*)model {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.web_url = model.field.msg;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSString *)url {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.web_url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self setShareBarButtonItem:NO];
    
    if (self.isFromSearch.length) {
        WeakSelf
        HKHtmlTipView * tipView = [HKHtmlTipView createViewFrame:CGRectMake(25, KNavBarHeight64 + 10, SCREEN_WIDTH - 50, 60)];
        tipView.descLabel.text = [NSString stringWithFormat:@"想找“%@”搜索结果？点击返回搜索页",self.isFromSearch];
        tipView.clickBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        [self.view addSubview:tipView];
        self.tipView = tipView;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tipView removeFromSuperview];
        });
    }
}

// 设置分享 bar 按钮
- (void)setShareBarButtonItem:(BOOL)isForce {
    
    if (self.open_share && [self.open_share isEqualToString:@"1"] && self.trigger_name.length) {
        [self createRightBarButton];
    }

    if (isForce) {
        if (nil == self.navigationItem.rightBarButtonItem) {
            [self createRightBarButton];
        }else{
            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        }
    }
}

- (UIButton*)customBarButtonWithTitle:(NSString*)title {
    UIButton *_rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBarBtn.titleLabel.font = HK_FONT_SYSTEM(14);
    [_rightBarBtn setTitle:title forState:UIControlStateNormal];
    [_rightBarBtn setTitle:title forState:UIControlStateSelected];
    [_rightBarBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
    [_rightBarBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateHighlighted];
    [_rightBarBtn setImage:[UIImage imageNamed:@"ic_mylive_2_34"] forState:UIControlStateNormal];
    [_rightBarBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    [_rightBarBtn setTitleEdgeInsets:UIEdgeInsetsMake(3, 0, 0, 0)];
    [_rightBarBtn addTarget:self action:@selector(customBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _rightBarBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_rightBarBtn sizeToFit];
    return _rightBarBtn;
}


- (void)customBarButtonClick:(UIButton*)btn {
    if ([btn.currentTitle isEqualToString:@"我的直播"]) {
        [MobClick event: hukewangxiao_mylivestudio];
    }
    [HKH5PushToNative runtimePush:self.liveMapModel.redirect_package.className arr:self.liveMapModel.redirect_package.list currectVC:self];
}



- (void)createRightBarButton{
    
    UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"share_black") darkImage:imageName(@"share_black_dark")];
    UIBarButtonItem *itme  = [UIBarButtonItem BarButtonItemWithImage:image highImage:image target:self action:@selector(shareRightBtnItemAction) size:CGSizeMake(40, 40)];
    self.navigationItem.rightBarButtonItem = itme;
}



/**
 右上角分享按钮
 */
- (void)shareRightBtnItemAction {
   [self.bridge callHandler:self.trigger_name];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    

    // 清除 JS注册的方法， 否则无法释放VC
    if (self.bridge) {
        for (NSString *methodName in self.methodArray) {
            [self.bridge removeHandler:methodName];
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.backActionCallBlock) {
        BOOL fullScreen = ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight);
        self.backActionCallBlock(fullScreen);
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
    
    [self brideRegisterNativeMethod];
    [self hotWordRequest];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
}


- (void)dealloc {
    if (self.webView) {
        [self.webView stopLoading];
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.webView removeObserver:self forKeyPath:@"title"];
        [self.webView removeObserver:self forKeyPath:@"URL"];
    }
    [HKWebTool clearnWebCache];
    TTVIEW_RELEASE_SAFELY(self.webView);
}


- (void)setLeftBarButtonItems {
    
//    UIBarButtonItem *backItem = [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"huke_login_close"
//                                  highBackgroudImageName:@"huke_login_close"
//                                                  target:self
//                                                  action:@selector(backAction)];
    
//    UIBarButtonItem *backPreviousItem = [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"nac_back"
//                                                              highBackgroudImageName:@"nac_back"
//                                                                              target:self
//                                                                              action:@selector(backPreviousAction)];
    
//    UIImage *barItemBackImage = [[self class]barItemBackImage];
//    UIBarButtonItem *backItem = [UIBarButtonItem BarButtonItemWithBackgroudImage:barItemBackImage highBackgroudImage:barItemBackImage target:self action:@selector(backAction)];
    
    
    UIImage *barItemBackPreviousImage = [[self class]barItemBackPreviousImage];
    UIBarButtonItem *backPreviousItem = [UIBarButtonItem BarButtonItemWithBackgroudImage:barItemBackPreviousImage highBackgroudImage:barItemBackPreviousImage target:self action:@selector(backPreviousAction)];
    //self.navigationItem.leftBarButtonItems = @[backPreviousItem,backItem];
    
    
    if (!self.isTabModule.length || ![self.isTabModule isEqualToString:@"1"]) {
        self.navigationItem.leftBarButtonItems = @[backPreviousItem];
    }else{
        backPreviousItem.customView.hidden = YES;
        self.navigationItem.leftBarButtonItems = @[backPreviousItem];
    }
}



/// baritem 图标
+ (UIImage*)barItemBackImage {
    return [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"huke_login_close") darkImage:imageName(@"huke_login_close_dark")];
}

///  baritem 图标
+ (UIImage*)barItemBackPreviousImage {
    return [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"nac_back") darkImage:imageName(@"nac_back_dark")];
}



#pragma mark - 返回前一个 html
- (void)backPreviousAction {
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        //返回前一控制器
        [self backAction];
    }
}

- (void)backAction {
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}


- (void)createUI {
    [self setLeftBarButtonItems];
    self.view.backgroundColor = COLOR_F8F9FA_333D48;// [UIColor whiteColor];
    
    [self setWebView];
    [self.webView loadRequest:[HKWebTool requestHeaderFieldWithUrl:self.web_url]];
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(IS_IPAD){
            make.left.equalTo(self.view).offset(iPadContentMargin);
            make.right.equalTo(self.view).offset(-iPadContentMargin);
            make.top.bottom.equalTo(self.view);
        }else{
            make.edges.equalTo(self.view);
        }
    }];
    
    // add 0308
    //进度条添加到navigationBar
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(  IS_IPHONE_X?KNavBarHeight64+4 : KNavBarHeight64);
        make.right.left.equalTo(self.view);
        make.height.mas_equalTo(2.0);
    }];
    
    
    //    [self.view insertSubview:self.webView belowSubview:self.progressView];
    // 注册 进度条 title URL 观察者
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:nil];
    
    //登录成功通知
    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, loginSuccessNotification);
}



- (void)testlocalHtml {
    //    //测试本地Html
    //    //[self loadExamplePage:_webView];
    //    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.web_url]];
    //    //[self.webView loadRequest:request];
    //
    //    [self setWebViewJavascriptBridge];
    //    [self.webView loadRequest:[self getRequestWithUrl:self.web_url]];
    //    [self.view addSubview:self.webView];
}


/** 创建 web */
- (void)setWebView {
    if (!self.webView) {
        self.webView = [[WKWebView alloc] init];
        self.webView.navigationDelegate= self;
        self.webView.scrollView.delegate = self;
        self.webView.backgroundColor = COLOR_FFFFFF_333D48;
        [self setWebViewJavascriptBridge];
    }
}


- (UIProgressView*)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
//        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        //_progressView.backgroundColor = [UIColor clearColor];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = [UIColor blueColor];
    }
    return _progressView;
}


// KVO 进度条 title 变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]){
        //加载进度值
        if (object == self.webView){
            self.progressView.alpha = 1;
            [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
            if(self.webView.estimatedProgress >= 1.0f)
            {
                [UIView animateWithDuration:0.5 animations:^{
                    self.progressView.alpha = 0;
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if ([keyPath isEqualToString:@"title"]){
        //网页title
        if (object == self.webView){
            self.navigationItem.title = self.webView.title;
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if ([keyPath isEqualToString:@"URL"]){
        //网页Url
        if (object == self.webView){
            NSURL *URL = change[@"new"];
            NSString *url = URL.absoluteString;
            if (!isEmpty(url) && [url containsString:@"loadHeader"]) {
                // web 内调整 需要重新设置header
                self.web_url = url;
                [self.webView loadRequest:[HKWebTool requestHeaderFieldWithUrl:self.web_url]];
            }

        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}




/** 接收 登录成功通知  */
- (void)loginSuccessNotification {
    
    if (self.webView) {
        [self.webView loadRequest:[HKWebTool requestHeaderFieldWithUrl:self.web_url]];
        [self.webView reloadInputViews];
        [self brideRegisterNativeMethod];
    }
}


/** 给 bridge 注册OC 方法 */
- (void)brideRegisterNativeMethod {
    
    // JS调用OC
    if (self.bridge) {
        for (NSString *methodName in self.methodArray) {
            [self registerMethodToJS:self.bridge methodName:methodName];//常规方法
        }
    }
}


- (NSArray<NSString*>*)methodArray {
    if (!_methodArray) {
        // share(分享方法)  H5Handle(常规方法跳转)  goBackFrontVC(返回前一页面)  picEnlarge(图片放大) HKAppleBuyJSFunction（支付） openBrowser(跳转至外部浏览器)
        _methodArray = @[@"share",@"H5Handle",@"goBackFrontVC",@"picEnlarge", @"HKAppleBuyJSFunction", @"Refresh" ,@"base64pic",@"openBrowser",@"saveImage",@"iosPayFuctionZFB",@"iosPayFuctionWX",@"openNativeShareBtn",@"openNativeLiveBtn",@"html_click_umeng",@"medalShare"];
    }
    return _methodArray;
}



- (void)loadExamplePage:(WKWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"TestH5" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
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
    //self.progressView.hidden = YES;
    
    if (self.webView.canGoBack) {
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    }else{
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    }
    
    
    if ([self.isTabModule isEqualToString:@"1"]) {
        NSArray * itemsArray = self.navigationItem.leftBarButtonItems;
        for (UIBarButtonItem * item in itemsArray) {
            item.customView.hidden = !self.webView.canGoBack;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.tipView removeFromSuperview];
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    //self.progressView.hidden = YES;
}

//-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//    NSURLRequest * request =   navigationAction.request;
//    NSString * urlString = request.URL.absoluteString;
//    NSLog(@"====== >>>>url----- %@ request %@",urlString,[request allHTTPHeaderFields]);
//    decisionHandler(WKNavigationActionPolicyAllow);
//}

#pragma mark - 注册 OC 方法 给 JS 调用 --JS调用OC
- (void)registerMethodToJS:(WKWebViewJavascriptBridge*) bridge methodName:(NSString *)methodName {
    
    @weakify(self);
    [bridge registerHandler:methodName handler:^(id data, WVJBResponseCallback responseCallback) {
        //NSLog(@"%@, %@", methodName, [NSDate date]);
        @strongify(self);
        /** share(分享方法)  H5Handle(常规方法跳转)  goBackFrontVC(返回前一页面)*/
        if ([methodName isEqualToString:@"share"]) {
            if (data) {
                ShareModel *tempModel =  [ShareModel mj_objectWithKeyValues:data];
                [self shareWithUI:tempModel];
            }
        }else if ([methodName isEqualToString:@"H5Handle"]) {
            //跳转至VC
            if (data) {
                HomeAdvertModel *adsModel = [HomeAdvertModel mj_objectWithKeyValues:data];
                if ([adsModel.className isEqualToString: @"com.huke.hk.controller.classify.ClassifyIntroducingSoftwareActivity"]) {
                    adsModel.className = @"HKSoftwareVC";
                }
                [HKH5PushToNative runtimePush:adsModel.className arr:adsModel.list currectVC:self];
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
            if (data && isLogin()) {
                HKBuyVipModel *model =  [HKBuyVipModel mj_objectWithKeyValues:data];
                YHIAPpay *apPay = [YHIAPpay instance];
                apPay.delegate = self;
                [apPay buyProductionModel:model];
            }else{
                [self setLoginVC];
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
        }else if ([methodName isEqualToString:@"openNativeShareBtn"]) {
            // 隐藏分享按钮  1打开0关闭
            if (data) {
                ShareModel *model =  [ShareModel mj_objectWithKeyValues:data];
                if (model.status) {
                    if (self.navigationItem.rightBarButtonItem) {
                        self.navigationItem.rightBarButtonItem.customView.hidden = !model.status;
                    }else{
                        [self setShareBarButtonItem:YES];
                    }
                }else{
                    if (self.navigationItem.rightBarButtonItem) {
                        self.navigationItem.rightBarButtonItem.customView.hidden = !model.status;
                    }
                }

                if (!isEmpty(model.triggerName)) {
                    self.trigger_name = model.triggerName;
                }
            }
        }else if ([methodName isEqualToString:@"openNativeLiveBtn"]) {
            if (data) {
                HKMapModel *mapModel = [HKMapModel mj_objectWithKeyValues:data];
                self.liveMapModel = mapModel;
//                if (mapModel.status) {
//                    if ([mapModel.redirect_package.class_name isEqualToString:@"HKMyLiveVC"]) {
                        [self setSearchBar];
//                    }
                    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self customBarButtonWithTitle:mapModel.button_name]];
//                }
            }
        }else if ([methodName isEqualToString:@"html_click_umeng"]){
            NSString * key = data[@"key"];
            [MobClick event:key];
        }else if ([methodName isEqualToString:@"medalShare"]){
            HKMedalModel *model =  [HKMedalModel mj_objectWithKeyValues:data];            
            [self.medalView removeFromSuperview];
            self.medalView = [HKFetchMedalView viewFromXib];
            self.medalView.frame = CGRectMake(0, 0, 375, 592);
            self.medalView.center = self.view.center;
            [self.view addSubview:self.medalView];
            [self.view sendSubviewToBack:self.medalView];
            self.medalView.model = model;
            self.medalView.fetchUrlBlock = ^(NSString * _Nonnull url) {
                responseCallback(url);
            };
        }
    }];
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
        // 分享图片成功 回调js
        [self.bridge callHandler:@"shareSuccess"];
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
    
    WeakSelf
    [HKCommonRequest shareDataSucess:model success:^(id responseObject) {
        if ([model.type isEqualToString:@"23"]) {
            HK_NOTIFICATION_POST(@"shareNotice", nil);
            [weakSelf.webView reload];
        }
    } failure:^(NSError *error) {
        
    }];
}



/********************** 浏览图片 *********************/

- (void)setPhotoBrowserWithUrl:(NSString *)url {
    
    if (isEmpty(url)) {
        return;
    }
    XLPhotoBrowser *browser = [HKPhotoBrowserTool initPhotoBrowserWithUrl:url];
    // 设置长按手势弹出的地步ActionSheet数据,不实现此方法则没有长按手势
    [browser setActionSheetWithTitle:nil delegate:self cancelButtonTitle:nil deleteButtonTitle:nil otherButtonTitles:@"保存图片",nil];
}

#pragma mark  XLPhotoBrowserDatasource
/**
 *  返回这个位置的占位图片
 *  @return 占位图片
 */
- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return imageName(HK_Placeholder);
}


- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex {
    switch (actionSheetindex) {
        case 0:
        {
            // 保存图片
            NSLog(@"点击了actionSheet索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);
            [browser saveCurrentShowImage];
        }
            break;
        default:{
            NSLog(@"点击了actionSheet索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);
        }
            break;
    }
}

#pragma mark <PayResultDelegate>
- (void)payWithResult:(HKBuyVipModel *)model payResult:(BOOL)success{
    
    if (success) {
        NSLog(@"h5苹果支付成功");
    } else {
        NSLog(@"h5苹果支付失败");
    }
    
    //if (!success) return;

    [self applePayResultCallObjcToJS:model payResult:success];
}


#pragma mark - 苹果支付结果
- (void)applePayResultCallObjcToJS:(HKBuyVipModel *)model payResult:(BOOL)success {
    
    //if (!success) return;
    //NSDictionary *dic = @{@"out_trade_no" :model.orderNo};
    NSDictionary *dict = @{@"out_trade_no" :model.orderNo, @"is_success" :success ? @(1) :@(0)};
    
    [self.bridge callHandler:@"paySuccess" data:dict responseCallback:^(id responseData) {
        
    }];
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

- (void)setSearchBar {
    UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"nac_back") darkImage:imageName(@"nac_back_dark")];
    UIButton *button = [[UIButton alloc] init];
    [button setImage:image forState:UIControlStateNormal];

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.size = CGSizeMake(22, PADDING_35);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.hk_hideNavBarShadowImage = YES;
    //self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    if ([self.isTabModule isEqualToString:@"1"]) {
        self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    }

    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH-160, 44);
    self.searchBar = [SearchBar searchBarWithPlaceholder:SEARCH_TIP_CATEGORY frame:rect];
    self.searchBar.searchBarBackgroundColor = COLOR_EFEFF6_333D48;
    
    if (@available(iOS 11.0, *)) {
        UIView *titleView = [[UIView alloc]initWithFrame:self.searchBar.bounds];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.clipsToBounds = YES;
        [titleView addSubview:self.searchBar];
        self.navigationItem.titleView = titleView;
    }else{
        self.navigationItem.titleView = self.searchBar;
    }
    WeakSelf;
    self.searchBar.searchBarShouldBeginEditingBlock = ^(UISearchBar *searchBar) {
        [weakSelf setSearchView];
        [searchBar resignFirstResponder];
    };
    
    self.searchBar.didClickBlock = ^(UISearchBar *searchBar,NSString *searchWord) {
        [weakSelf setSearchView];
        [searchBar resignFirstResponder];
        weakSelf.searchViewController.searchWord = searchWord;
    };
    self.searchBar.hotWordArray = self.hotWordArray;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 搜索UI
- (void)setSearchView{
    
    // 2. 创建控制器
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:self.hotWordArray withSearchsearchHistories:self.searchHistoryArray];
    // 3. 设置风格
    searchViewController.hotSearchStyle = PYHotSearchStyleRankTag; // 热门搜索风格根据选择
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleARCBorderTag;
    searchViewController.cancelButton.tintColor = [UIColor whiteColor];
    searchViewController.searchSuggestionHidden = NO;
    searchViewController.delegate = self;
    searchViewController.dataSource = self;
    searchViewController.searchHistoriesCount = 10;
    searchViewController.swapHotSeachWithSearchHistory = YES;

    searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
    if (@available(iOS 13.0, *)) {
        [searchViewController.searchBar.searchTextField setFont:HK_FONT_SYSTEM(14)];
    }
    [self.navigationController pushViewController:searchViewController animated:YES];
    //[self pushToOtherController:searchViewController];

    searchViewController.hk_hideNavBarShadowImage = YES;
    self.searchViewController = searchViewController;

    [self hotWordRequest];
}

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText {
    
    if (searchText.length>0) {
        [self suggestWordWithSearchText:searchText];
    }
}



- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectHotSearchAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText {

    if (searchText.length>0) {
        [MobClick event:UM_RECORD_SEARCH_PAGE_HOT];
        
        SearchResultVC * vc = [[SearchResultVC alloc]initWithNibName:nil bundle:nil keyWord:searchText];
        vc.redirectWordsArray = self.searchViewController.redirectWordsArray;
        searchViewController.searchResultController = vc;
        vc.selectIndex = 2;
    }
}


- (void)searchViewController:(PYSearchViewController *)searchViewController  didSelectSearchHistoryAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText {

    if (searchText.length>0) {
        SearchResultVC * vc = [[SearchResultVC alloc]initWithNibName:nil bundle:nil keyWord:searchText];
        vc.redirectWordsArray = self.searchViewController.redirectWordsArray;
        searchViewController.searchResultController = vc;
        vc.selectIndex = 2;
    }
    [MobClick event:um_searchpage_history];
}


- (void)searchViewController:(PYSearchViewController *)searchViewController didSearchWithSearchBar:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText {
    if (searchText.length>0) {
        SearchResultVC * vc = [[SearchResultVC alloc]initWithNibName:nil bundle:nil keyWord:searchText];
        vc.redirectWordsArray = self.searchViewController.redirectWordsArray;
        searchViewController.searchResultController = vc;
        vc.selectIndex = 2;
    }
}



- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectSearchSuggestionAtIndexPath:(NSIndexPath *)indexPath
                   searchBar:(UISearchBar *)searchBar {

    if (self.suggestArray.count > indexPath.row) {
        NSString *text = self.suggestArray[indexPath.row];
        searchBar.text = text;
        SearchResultVC * vc = [[SearchResultVC alloc]initWithNibName:nil bundle:nil keyWord:text];
        vc.redirectWordsArray = self.searchViewController.redirectWordsArray;
        searchViewController.searchResultController = vc;
        vc.selectIndex = 2;
    }
    [MobClick event:um_searchpage_related];
}

- (void)suggestWordWithSearchText:(NSString *)searchText {
    if (isEmpty(searchText)) {
        return;
    }
    
    [self.sessionTaskArray enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.state == NSURLSessionTaskStateRunning || obj.state == NSURLSessionTaskStateSuspended ) {
            [obj cancel];
        }
    }];
    
    
    NSString *url = hk_testServer == 1 ? SEARCH_RECOMMEND_WORD_TEST : SEARCH_RECOMMEND_WORD;
    //NSString *url = HKIsDebug ?SEARCH_RECOMMEND_WORD_TEST :SEARCH_RECOMMEND_WORD;
    
    NSURLSessionDataTask *sessionTask = [HKHttpTool hk_taskPost:nil allUrl:url isGet:YES parameters:@{@"word":searchText} success:^(id responseObject) {
        if ([responseObject[@"data"][@"lists"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = responseObject[@"data"][@"lists"];
            self.suggestArray = arr.mutableCopy;
            
            self.searchViewController.searchSuggestions = self.suggestArray;
            [self.searchViewController.searchSuggestionView reloadData];
            self.searchViewController.searchSuggestionView.hidden = NO;
        }
    } failure:^(NSError *error) {
        if (NSURLErrorCancelled == error.code) {
            
        }
    }];
    [self.sessionTaskArray removeAllObjects];
    [self.sessionTaskArray addObject:sessionTask];
}

- (void)hotWordRequest {
    // 无热门搜索数据
    [HKHttpTool POST:@"/search/search-words" parameters:nil success:^(id responseObject) {
        if (HKReponseOK){
            [self.searchHistoryArray removeAllObjects];
            [self.hotWordArray removeAllObjects];
            [self.redirectWordsArray removeAllObjects];
            NSMutableArray *arr = [TagModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"]objectForKey:@"hot"]];
            for (TagModel *model in arr ) {
                if (!isEmpty(model.words)) {
                    [self.hotWordArray addObject:model.words];
                }
            }
            
            NSMutableArray *hisArr = [NSMutableArray array];
            hisArr = responseObject[@"data"][@"history"];
            for (NSString * string in hisArr ) {
                if (!isEmpty(string)) {
                    [self.searchHistoryArray addObject:string];
                }
            }
            self.searchBar.hotWordArray = self.hotWordArray;
            self.redirectWordsArray = [preciseWordsModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"]objectForKey:@"redirect_words_list"]];
            
            if (self.searchViewController) {
                self.searchViewController.hotSearches = self.hotWordArray;
                self.searchViewController.hisSearches = self.searchHistoryArray;
                self.searchViewController.redirectWordsArray = self.redirectWordsArray;
            }
        }
    } failure:^(NSError *error) {

    }];
}


@end


