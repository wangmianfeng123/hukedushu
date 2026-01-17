//
//  HKPgcCourseHtmlCell.h
//  Code
//
//  Created by Ivan li on 2017/12/22.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef void(^HtmlHeightBlock)(float height);

@interface HKPgcCourseHtmlCell : UITableViewCell<WKNavigationDelegate,WKUIDelegate>

@property(nonatomic,strong)WKWebView *webView;

@property(nonatomic,copy)HtmlHeightBlock htmlHeightBlock;

+ (instancetype)initCellWithTableView:(UITableView *)tableView  detailModel:(DetailModel *)detailModel;

@property(nonatomic, strong)DetailModel *detailModel;

@end
