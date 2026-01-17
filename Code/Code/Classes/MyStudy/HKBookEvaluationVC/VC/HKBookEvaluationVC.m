//
//  HKBookEvaluationVC.m
//  Code
//
//  Created by Ivan li on 2019/8/21.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookEvaluationVC.h"
#import "StarView.h"
#import "VideoServiceMediator.h"
#import "HKFeedbackView.h"
#import "HKBookModel.h"

@interface HKBookEvaluationVC ()<StarViewDelegate>

@property(nonatomic,strong)HKFeedbackView *feedBackView;

@property(nonatomic,strong)StarView *starView;

@end

@implementation HKBookEvaluationVC




- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)createUI {
    
    self.hk_hideNavBarShadowImage = YES;
    [self createLeftBarButton];
    self.title = @"我要评论";
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    [self rightBarButtonItemWithTitle:@"提交" color:COLOR_FF7820 action:@selector(rightBarItemClick)];
    
    [self.view addSubview:self.starView];
    [self.view addSubview:self.feedBackView];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(KNavBarHeight64);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    
    [self.feedBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starView.mas_bottom).offset(38);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(IS_IPHONE6PLUS ?210:180);
    }];
}


- (void)rightBarItemClick {
    
    NSString *comment = self.feedBackView.feedbackView.text;
    NSInteger starIndex = self.starView.selectIndex;
    
    if (starIndex <=0 ) {
        showTipDialog(@"还没有完成评价哦");
        return;
    }
    
    if (comment.length<5) {
        showTipDialog(@"您的看法不足5个字，请多写点哦");
        return;
    }
    NSString *bookId = isEmpty(self.bookId) ?self.model.book_id : self.bookId;
    if (isEmpty(bookId)) {
        return;
    }
    
    [self submitCommentWithBookId:bookId score:[NSString stringWithFormat:@"%ld",starIndex] content:comment];
}


- (StarView*)starView {
    if (!_starView) {
        _starView = [[StarView alloc]init];
        _starView.deletate = self;
        _starView.commentType = HKCommentType_BookComment;
    }
    return _starView;
}


- (HKFeedbackView*)feedBackView {
    if (!_feedBackView) {
        _feedBackView = [[HKFeedbackView alloc]init];
        _feedBackView.commentType = HKCommentType_BookComment;
    }
    return _feedBackView;
}



- (void)submitComment:(NSInteger)selectIndex comment:(NSString *)comment {
    
}




#pragma mark - 提交评论
//BOOK_ID不为空时, 判断为主评论
//COMMENT_ID不为空时, 判断为回复主评论
//REPLY_ID不为空时, 判断为回复子评论
- (void)submitCommentWithBookId:(NSString*)bookId  score:(NSString *)score content:(NSString *)content {
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (!isEmpty(bookId)) {
        [dict setValue:bookId forKey:@"book_id"];
    }
    [dict setValue:score forKey:@"score"];
    [dict setValue:content forKey:@"content"];
    
    @weakify(self);
    [HKHttpTool POST:BOOK_COMMENT_CREATE parameters:dict success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            if (!isEmpty(msg)) {
                showTipDialog(msg);
            }
            if ([self.delegate respondsToSelector:@selector(bookEvaluationSucess:)]) {
                [self.delegate bookEvaluationSucess:content];
            }
            
            [[HKALIYunLogManage sharedInstance]hkBookClickLogWithFlag:@"7" bookId:bookId courseId:self.model.course_id];
            [self backAction];
        }
    } failure:^(NSError *error) {
        
    }];
}


@end







