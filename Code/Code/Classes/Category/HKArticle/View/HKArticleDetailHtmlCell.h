//
//  HKArticleDetailHtmlCell.h
//  Code
//
//  Created by Ivan li on 2017/12/22.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "HKArticleModel.h"
//#import "WebViewJavascriptBridge.h"
//#import <WebViewJavascriptBridge.h>
#import "WKWebViewJavascriptBridge.h"

@class  HomeAdvertModel,HKArticleDetailHtmlCell;

@protocol HKArticleDetailHtmlCellDelegate <NSObject>

/** 关注讲师 */
- (void)followTeacherAction:(HKArticleDetailHtmlCell*)cell model:(HKArticleModel*)model  adsModel:(HomeAdvertModel *)adsModel;

/** 点击讲师头像 */
- (void)teacherIconClick:(HKArticleModel*)model;

@end


typedef void(^HtmlHeightBlock)(float height);

@interface HKArticleDetailHtmlCell : UITableViewCell<WKNavigationDelegate,WKUIDelegate>

@property(nonatomic,strong)WKWebView *webView;

@property(nonatomic,copy)HtmlHeightBlock htmlHeightBlock;

@property(nonatomic, strong)HKArticleModel *detailModel;

@property(nonatomic,weak)id <HKArticleDetailHtmlCellDelegate> delegate;

/**
 *关注教师成功后 调用 JS 改变关注按钮状态
 */
- (void)callJsToObjc:(BOOL)isFollow;

/** 移除 JS注册的方法 */
- (void)removeBriderHandler;

/** 给 bridge 注册OC 方法 */
- (void)brideRegisterNativeMethod;

@end

