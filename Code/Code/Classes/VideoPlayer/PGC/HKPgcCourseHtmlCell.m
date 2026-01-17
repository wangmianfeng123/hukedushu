//
//  HKPgcCourseHtmlCell.m
//  Code
//／
//  Created by Ivan li on 2017/12/22.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKPgcCourseHtmlCell.h"
#import "DetailModel.h"



@implementation HKPgcCourseHtmlCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (instancetype)initCellWithTableView:(UITableView *)tableView  detailModel:(DetailModel *)detailModel {
    
    HKPgcCourseHtmlCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKPgcCourseHtmlCell"];
    if (!cell) {
        cell = [[HKPgcCourseHtmlCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HKPgcCourseHtmlCell" detailModel:detailModel];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier detailModel:(DetailModel *)detailModel  {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.detailModel = detailModel;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.webView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setDetailModel:(DetailModel *)detailModel {
    _detailModel = detailModel;
}


- (WKWebView*)webView {
    if (!_webView) {
        //        NSString *html = @"<p style=\"font-size:18px;font-family:微软雅黑,&quot;Microsoft YaHei&quot;; font-weight: normal; color: black;\"><img src=\"http://pic.huke88.com/upload/content/2017/12/12/15130757954273.jpg\"_src=\"http://pic.huke88.com/upload/content/2017/12/12/15130757954273.jpg\"/></p>";
        //        [_webView loadHTMLString:html baseURL:nil];
        
        NSString *html = self.detailModel.course_data.content;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_webView loadHTMLString:html baseURL:nil];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.userInteractionEnabled = NO;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return _webView;
}


#pragma mark  - navigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat height = 0.0;
        [webView sizeToFit];
        height = webView.scrollView.contentSize.height;
        CGRect webFrame = webView.frame;
        webFrame.size.height = height;
        webView.frame = webFrame;
        self.htmlHeightBlock ?self.htmlHeightBlock(height) :nil;
    });
    
    //    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    //        // 计算webView高度
    //       CGFloat height = [result doubleValue];
    //        // 刷新tableView
    //        //[self.tableView reloadData];
    //        self.htmlHeightBlock ?self.htmlHeightBlock(height) :nil;
    //    }];
}




@end
