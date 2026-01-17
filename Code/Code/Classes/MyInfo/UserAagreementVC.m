//
//  UserAagreementVC.m
//  Code
//
//  Created by Ivan li on 2017/8/29.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "UserAagreementVC.h"
#import <WebKit/WebKit.h>
#import "HKWebTool.h"




@interface UserAagreementVC ()

@property(nonatomic,strong)WKWebView *webView;

@end

@implementation UserAagreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"虎课用户注册协议";
    [self createLeftBarButton];
    [self.view addSubview:self.webView];
}


- (WKWebView*)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.allowsBackForwardNavigationGestures = YES;
        
        // 本地 html
//        NSString *url = [[NSBundle mainBundle] pathForResource:@"zhuce_http" ofType:@"html"];
//        if (!isEmpty(url)) {
//            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:url]];
//            [_webView loadRequest:request];
//        }
        NSString *temp = BaseUrl;
        if ([temp hasSuffix:@"/v5"]) {
            temp = [temp substringWithRange:NSMakeRange(0, temp.length - 3)];
        }
        NSString *url = [NSString stringWithFormat:@"%@%@",temp,SITE_AGREEMENT];
        [_webView loadRequest:[HKWebTool requestHeaderFieldWithUrl:url]];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}



// KVO 进度条 title 变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"title"]){
        //网页title
        if (object == self.webView){
            self.navigationItem.title = self.webView.title;
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    if (self.webView) {
        [self.webView removeObserver:self forKeyPath:@"title"];
    }
    TTVIEW_RELEASE_SAFELY(self.webView);
}


@end
