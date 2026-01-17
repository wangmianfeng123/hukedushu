//
//  HKLiveCourseInfoDesCell.m
//  Code
//
//  Created by hanchuangkeji on 2018/10/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLiveCourseInfoDesCell.h"
#import <WebKit/WebKit.h>
#import "XLPhotoBrowser.h"
#import "HKArticleModel.h"
#import "BannerModel.h"
#import "HKH5PushToNative.h"
//#import "WebViewJavascriptBridge.h"
#import "WKWebViewJavascriptBridge.h"

#import "XLPhotoBrowser.h"

@interface HKLiveCourseInfoDesCell()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property(nonatomic,strong)WKWebView *webView;

//@property WebViewJavascriptBridge * bridge;
@property WKWebViewJavascriptBridge * bridge;

@property (nonatomic ,assign)CGFloat contentHeight;
@end

@implementation HKLiveCourseInfoDesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupWebView];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.themeLb.textColor = COLOR_27323F_EFEFF6;
}

-(void)setH5_url:(NSString *)h5_url{
    if (h5_url.length) {
        if (!_h5_url) {
            _h5_url = h5_url;
            [self deleteCache];
            [self.webView loadRequest:[HKWebTool requestHeaderFieldWithUrl:h5_url]];
        }else{
            if (![_h5_url isEqualToString:h5_url]) {
                _h5_url = h5_url;
                [self deleteCache];
                [self.webView loadRequest:[HKWebTool requestHeaderFieldWithUrl:h5_url]];
            }
        }
    }
}

- (void)setModel:(HKLiveDetailModel *)model {
    if (!_model) {
        _model = model;
        [self deleteCache];
        [self.webView loadRequest:[HKWebTool requestHeaderFieldWithUrl:model.h5_url]];
    }
    
//    NSString *urlTest = @"https://app-test.huke88.com/live/introduce?live_course_id=1141";
}

- (void)setupWebView {
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    webView.navigationDelegate = self;
//    webView.UIDelegate = self;
    
    webView.scrollView.scrollEnabled = NO;
    webView.scrollView.bounces = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
//    webView.userInteractionEnabled = NO;
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    if (@available(iOS 11.0, *)) {
        /// 解决webview 高度不准确问题 大概少了 64
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [self.containerView addSubview:webView];
    self.webView = webView;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.containerView);
    }];
    
    [self setWebViewJavascriptBridge];
    
    //添加观察者
    [webView.scrollView addObserver:self forKeyPath:@"contentSize"
                                  options:NSKeyValueObservingOptionNew context:nil];
    //登录成功通知
    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, loginSuccessNotification);
    HK_NOTIFICATION_ADD(HKBuyVIPSuccessNotification,loginSuccessNotification);
    

}

-  (void)deleteCache{
    if ([[[UIDevice currentDevice]systemVersion]intValue ] >= 9.0) {
        // allWebsiteDataTypes清除所有缓存
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    }
}

- (void)loginSuccessNotification {
    if (self.h5_url.length) {
        [self deleteCache];
        [self.webView loadRequest:[HKWebTool requestHeaderFieldWithUrl:self.h5_url]];
    }
}
#pragma mark  - navigationDelegate
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        CGFloat height = 0.0;
//        [webView sizeToFit];
//        height = webView.scrollView.contentSize.height;
//        if (height < 30) {
//            height = 30;
//        }
//
//        CGRect webFrame = webView.frame;
//        webFrame.size.height = height;
//        self.containerView.height = height;
//        self.model.content.contentHeight = height;
//        webView.frame = webFrame;
//        self.htmlHeightBlock? self.htmlHeightBlock(height) :nil;
//    });
    
//        [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//            // 计算webView高度
//           CGFloat height = [result doubleValue];
//            if (height < 30) {
//                height = 30;
//            }else{
//                height = height;
//            }
//
//            CGRect webFrame = webView.frame;
//            webFrame.size.height = height;
//            self.containerView.height = height;
//            self.model.content.contentHeight = height;
//            webView.frame = webFrame;
//            self.htmlHeightBlock? self.htmlHeightBlock(height) :nil;
//        }];
//}

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
    WeakSelf
    [bridge registerHandler:methodName handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //NSLog(@"%@, %@", methodName, [NSDate date]);
        /** share(分享方法)  H5Handle(常规方法跳转)  goBackFrontVC(返回前一页面)*/
        if ([methodName isEqualToString:@"share"]) {
            
        }else if ([methodName isEqualToString:@"H5Handle"]) {
            //跳转至VC
            if (data) {
                HomeAdvertModel *adsModel = [HomeAdvertModel mj_objectWithKeyValues:data];
                if ([adsModel.className isEqualToString:@"LoginVC"]) {
                    if (weakSelf.loginBlock) {
                        weakSelf.loginBlock(adsModel);
                    }
                }else{
                    [HKH5PushToNative runtimePush:adsModel.className arr:adsModel.list currectVC:nil];
                }
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
                [weakSelf setPhotoBrowserWithUrl:adsModel.img_url];
            }else{
                [weakSelf setPhotoBrowserWithUrl:[NSString stringWithFormat:@"https:%@",adsModel.img_url]];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context{
    //由于图片在实时加载，监听到内容高度变化，需要实时刷新您的控件展示高度
    if([keyPath isEqualToString:@"contentSize"]) {
        //直接使用scrollView.contentSize.height来刷新cell高度，不再使用JS获取
        
        CGFloat height =  self.webView.scrollView.contentSize.height ;
 //定义一个属性保存高度，当上一次的高度等于这次的高度时就不要刷新cell了，不然cell会一直刷新
        if (self.contentHeight == height) {
            return ;
        }
        self.contentHeight = height;
        
        self.htmlHeightBlock? self.htmlHeightBlock(height) :nil;
    }
}

- (void)dealloc {
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [self.webView stopLoading];
    [self removeBriderHandler];
    HK_NOTIFICATION_REMOVE();
    TTVIEW_RELEASE_SAFELY(self.webView);
}


@end
