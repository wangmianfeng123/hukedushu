//
//  HKMusicDescrCell.m
//  Code
//
//  Created by Ivan li on 2019/7/16.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKListeningDescrCell.h"
#import <WebKit/WebKit.h>
#import "XLPhotoBrowser.h"
#import "HKH5PushToNative.h"
//#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import "WKWebViewJavascriptBridge.h"
#import "XLPhotoBrowser.h"
#import "HKBookModel.h"
#import "UIView+SNFoundation.h"

@interface HKListeningDescrCell() <WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) UIView *containerView;

@property(nonatomic,strong)WKWebView *webView;

//@property WebViewJavascriptBridge * bridge;
@property WKWebViewJavascriptBridge * bridge;
@end



@implementation HKListeningDescrCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupWebView];
    }
    return self;
}

- (void)setupWebView {
    
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.webView];
    [self setWebViewJavascriptBridge];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
}


- (void)setModel:(HKBookModel *)model {
    
    //if (nil == _model ) {
        _model = model;
        if (!isEmpty(model.introduce)) {
            [self.webView loadRequest:[HKWebTool requestHeaderFieldWithUrl:model.introduce]];
        }
    //}
}


- (WKWebView*)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.delegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        //_webView.userInteractionEnabled = YES;
        _webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _webView.backgroundColor = COLOR_FFFFFF_3D4752;
        
        if (@available(iOS 11.0, *)) {
            /// 解决webview 高度不准确问题 大概少了 64
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            _webView.scrollView.scrollIndicatorInsets = _webView.scrollView.contentInset;
        }
    }
    return _webView;
}



//#pragma mark
//// 高度监听
//[_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    /**  < loading：防止滚动一直刷新，出现闪屏 >  */
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        CGRect webFrame = self.webView.frame;
//        webFrame.size.height = self.webView.scrollView.contentSize.height;
//        self.webView.frame = webFrame;
//        self.containerView.frame = webFrame;
//        self.htmlHeightBlock? self.htmlHeightBlock(webFrame.size.height) :nil;
//    }
//}
//
//
//#pragma mark - 移除观察者
//- (void)removeWebViewObserver {
//    if ([self.webView.scrollView observationInfo]) {
//        [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
//    }
//}



- (UIView*)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _containerView;
}


#pragma mark  - navigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        CGFloat height = 0.0;
//        [webView sizeToFit];
//        height = webView.scrollView.contentSize.height;
//
//    });
    

        [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
            //获取页面高度，并重置webview的frame
           CGFloat  webViewHeight = [result doubleValue];
            webView.height = webViewHeight;

            CGRect webFrame = webView.frame;
            webFrame.size.height = webViewHeight;
            webView.frame = webFrame;
            self.containerView.frame = webFrame;
            self.htmlHeightBlock? self.htmlHeightBlock(webViewHeight) :nil;
        }];
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
        
        //NSLog(@"%@, %@", methodName, [NSDate date]);
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
//            //图片放大
//            HomeAdvertModel *adsModel = [HomeAdvertModel mj_objectWithKeyValues:data];
//            [self setPhotoBrowserWithUrl:adsModel.img_url];
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
        }else if ([methodName isEqualToString:@"nativeSubscription"]) {
            //关注讲师
        }
    }];
}


/********************** 浏览图片 *********************/
- (void)setPhotoBrowserWithUrl:(NSString *)url {
    if (isEmpty(url)) { return; }
    [HKPhotoBrowserTool initPhotoBrowserWithUrl:url];
}



- (void)dealloc {
    [self.webView stopLoading];
    //[self removeBriderHandler];
    HK_NOTIFICATION_REMOVE();
    TTVIEW_RELEASE_SAFELY(self.webView);
}


@end



