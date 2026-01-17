//
//  HKArticleDetailHtmlCell.m
//  Code
//／
//  Created by Ivan li on 2017/12/22.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKArticleDetailHtmlCell.h"
#import "HKArticleModel.h"
#import "BannerModel.h"
#import "HKH5PushToNative.h"
//#import "WebViewJavascriptBridge.h"
#import "WKWebViewJavascriptBridge.h"
#import "XLPhotoBrowser.h"


@interface HKArticleDetailHtmlCell()

@property (nonatomic, assign)CGFloat webViewHeightheight;

//@property WebViewJavascriptBridge * bridge;
@property WKWebViewJavascriptBridge * bridge;
@end


@implementation HKArticleDetailHtmlCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (void)dealloc {
    
    [self.webView stopLoading];
    [self removeBriderHandler];
    HK_NOTIFICATION_REMOVE();
    TTVIEW_RELEASE_SAFELY(self.webView);
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier detailModel:(HKArticleModel *)detailModel  {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.detailModel = detailModel;
        [self createUI];
    }
    return self;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;    
}



- (void)createUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.webView];
    //登录成功通知
    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, loginSuccessNotification);
}


/** 接收 登录成功通知  */
- (void)loginSuccessNotification {
    if (self.webView) {
        NSString *html = self.detailModel.h5_url;
        [self.webView loadRequest:[HKWebTool requestHeaderFieldWithUrl:html]];
    }
}



- (void)setDetailModel:(HKArticleModel *)detailModel {

    // 防止循环赋值
    if (!_detailModel) {
        _detailModel = detailModel;
        NSString *html = detailModel.h5_url;
        [self.webView loadRequest:[HKWebTool requestHeaderFieldWithUrl:html]];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setHKArticleModel:(HKArticleModel *)detailModel {
    _detailModel = detailModel;
}


- (WKWebView*)webView {
    if (!_webView) {

        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;

        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        //_webView.userInteractionEnabled = NO;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                
        [self setWebViewJavascriptBridge];
    }
    return _webView;
}



#pragma mark  - navigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 1.0)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
}

// 页面加载完成之后调用 此方法会调用多次
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    __block CGFloat webViewHeight;
    self.webViewHeightheight = webView.frame.size.height;
    //获取内容实际高度（像素）@"document.getElementById(\"content\").offsetHeight;"
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
        // 此处js字符串采用scrollHeight而不是offsetHeight是因为后者并获取不到高度，看参考资料说是对于加载html字符串的情况下使用后者可以，但如果是和我一样直接加载原站内容使用前者更合适
        //获取页面高度，并重置webview的frame
        webViewHeight = [result doubleValue] + 20;
        NSLog(@"%f",webViewHeight);

        CGRect webFrame = webView.frame;
        webFrame.size.height = webViewHeight;
        webView.frame = webFrame;
        self.htmlHeightBlock ? self.htmlHeightBlock(webViewHeight) :nil;
    }];
    NSLog(@"结束加载");
}




#pragma mark - web 和原生建立连接
- (void)setWebViewJavascriptBridge {
    
    if (self.bridge) { return; }
//    [WebViewJavascriptBridge enableLogging];
//    self.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [WKWebViewJavascriptBridge enableLogging];
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:_webView];

    [self.bridge setWebViewDelegate:self];
    [self brideRegisterNativeMethod];
}



/** 给 bridge 注册OC 方法 */
- (void)brideRegisterNativeMethod {
    // JS调用OC  ----- share(分享方法)  H5Handle(常规方法跳转)  goBackFrontVC(返回前一页面)
    if (self.bridge) {
        NSArray<NSString*> *arr = @[@"share",@"H5Handle",@"goBackFrontVC",@"picEnlarge", @"HKAppleBuyJSFunction",@"nativeGoTeacherHomePage",@"nativeSubscription"];
        for (NSString *methodName in arr) {
            [self registerMethodToJS:self.bridge methodName:methodName];
        }
    }
}


/** 移除 JS注册的方法 */
- (void)removeBriderHandler {
    if (self.bridge) {
        NSArray<NSString*> *arr = @[@"share",@"H5Handle",@"goBackFrontVC",@"picEnlarge", @"HKAppleBuyJSFunction",@"nativeGoTeacherHomePage",@"nativeSubscription"];
        for (NSString *methodName in arr) {
            [self.bridge removeHandler:methodName];
        }
    }
}



#pragma mark - 注册 OC 方法 给 JS 调用 --JS调用OC
- (void)registerMethodToJS:(WKWebViewJavascriptBridge*) bridge methodName:(NSString *)methodName {
    
    [bridge registerHandler:methodName handler:^(id data, WVJBResponseCallback responseCallback) {
        /** share(分享方法)  H5Handle(常规方法跳转)  goBackFrontVC(返回前一页面)*/
        if ([methodName isEqualToString:@"share"]) {

        }else if ([methodName isEqualToString:@"H5Handle"]) {
            //跳转至VC
            if (data) {
                HomeAdvertModel *adsModel = [HomeAdvertModel mj_objectWithKeyValues:data];
                [HKH5PushToNative runtimePush:adsModel.className arr:adsModel.list currectVC:nil];
            }
        }else if ([methodName isEqualToString:@"goBackFrontVC"]) {

        }else if ([methodName isEqualToString:@"picEnlarge"]) {
            //图片放大
            HomeAdvertModel *adsModel = [HomeAdvertModel mj_objectWithKeyValues:data];            
            if ([adsModel.img_url containsString:@"http://"]||
                [adsModel.img_url containsString:@"https://"]) {
                [self setPhotoBrowserWithUrl:adsModel.img_url];
            }else{
                [self setPhotoBrowserWithUrl:[NSString stringWithFormat:@"https:%@",adsModel.img_url]];
            }
        }else if ([methodName isEqualToString:@"nativeGoTeacherHomePage"]) {
            //讲师主页
            if ([self.delegate respondsToSelector:@selector(teacherIconClick:)]) {
                [self.delegate teacherIconClick:self.detailModel];
            }
        }else if ([methodName isEqualToString:@"nativeSubscription"]) {
            //关注讲师
            HomeAdvertModel *adsModel = [HomeAdvertModel mj_objectWithKeyValues:data];
            if ([self.delegate respondsToSelector:@selector(followTeacherAction:model:adsModel:)]) {
                [self.delegate followTeacherAction:self model:self.detailModel adsModel:adsModel];
            }
        }
    }];
}




#pragma mark - 关注教师成功后 调用 JS 改变关注按钮状态
- (void)callJsToObjc:(BOOL)isFollow {
    
//    [self.bridge callHandler:@"jsSubscription" data:@{ @"isSubscription":(isFollow ?@"1" : @"0")}];
    //[bridge callHandler:methodName data:@{ @"foo":@"before ready" }];
    NSString *str = isFollow? @"1" : @"0";
    NSDictionary *dic = @{@"isLogin" : @"1", @"isSubscription" : str};
    
    [self.bridge callHandler:@"jsSubscription" data:dic responseCallback:^(id responseData) {
//        showTipDialog([NSString stringWithFormat:@"网页回调成功 %@", responseData]);
//        NSLog(@"from js: %@", responseData);
    }];
    
//    [self.bridge callHandler:@"getUserInfos" data:@{@"name": @"标哥"} responseCallback:^(id responseData) {
//        NSLog(@"dddd");
//    }];
}




/********************** 浏览图片 *********************/
- (void)setPhotoBrowserWithUrl:(NSString *)url {
    if (isEmpty(url)) { return; }
    [HKPhotoBrowserTool initPhotoBrowserWithUrl:url];
}



@end
