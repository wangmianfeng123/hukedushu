

//
//  HKMessageReplyVC.m
//  Code
//
//  Created by Ivan li on 2017/10/31.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKMessageReplyVC.h"
#import "UIBarButtonItem+Extension.h"
#import "NewCommentModel.h"
#import "VideoServiceMediator.h"
#import "HKMyInfoNotificationModel.h"
#import "HKBookCommentModel.h"


@interface HKMessageReplyVC ()<UITextViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)UITextField *replyTextField;

@property(nonatomic,strong)UITextView *feedbackView;

@property(nonatomic,strong)UILabel  *pointLabel;

@property(nonatomic,strong)NewCommentModel  *commentModel;

@property(nonatomic, assign) BOOL isFeedbackEmpty;

@property (nonatomic, strong)UIView *replyBackgroundView;

@property (nonatomic, strong)UILabel *replyBackgroundLB;

@end

@implementation HKMessageReplyVC

- (instancetype)initWithModel:(id)commentModel {
    if (self = [super init]) {
        self.commentModel = commentModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}

- (UIView *)replyBackgroundView {
    if (_replyBackgroundView == nil) {
        UIView *replyBackgroundView = [[UIView alloc] init];
        replyBackgroundView.backgroundColor = HKColorFromHex(0xF8F9FA, 1.0);
        _replyBackgroundView = replyBackgroundView;
    }
    return _replyBackgroundView;
}

- (UILabel *)replyBackgroundLB {
    if (_replyBackgroundLB == nil) {
        UILabel *replyBackgroundLB = [[UILabel alloc] init];
        replyBackgroundLB.font = HK_FONT_SYSTEM(14);
        replyBackgroundLB.numberOfLines = 0;
        _replyBackgroundLB = replyBackgroundLB;
    }
    return _replyBackgroundLB;
}



/// 设置 评论内容 文本
- (void)setReplyBackgroundLBText {
    
    NSString *username = nil;
    NSString *content = nil;
    switch (self.MessageType) {
        case HKMessageType_video:
        {
            // 普通的评论
            username = self.commentModel.username;
            content = self.commentModel.content;
        }
            break;
            
        case HKMessageType_shortVideo:
        {   /// 短视频的评论
            username = self.shortVideoCommentModel.commentUser.username;
            content = self.shortVideoCommentModel.content;
        }
            break;
            
        case HKMessageType_book:
        {   /// 读书的评论
            username = self.bookCommentModel.username;
            content = self.bookCommentModel.content;
        }
            break;
            
        default:
            break;
    }
    
    NSString *contentString = [NSString stringWithFormat:@"%@：%@",username, content];
    NSRange nameRange = [contentString rangeOfString:username];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM(14) range:NSMakeRange(0, attrString.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_7B8196  range:NSMakeRange(0, attrString.length)];
    
    if (nameRange.location != NSNotFound) {
        [attrString addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM_WEIGHT(14, UIFontWeightBold)range:NSMakeRange(nameRange.location, nameRange.length + 1)];
        [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_27323F range:NSMakeRange(nameRange.location, nameRange.length + 1)];
    }
    self.replyBackgroundLB.attributedText = attrString;
}



- (NSString *)pointLabelText {
    
    NSString *text = nil;
    switch (self.MessageType) {
        case HKMessageType_video:
        {
            // 普通的评论
           text = [NSString stringWithFormat:@"回复%@：",isEmpty(self.commentModel.username) ? @" " :self.commentModel.username];
        }
            break;
            
        case HKMessageType_shortVideo:
        {   /// 短视频的评论
            
            //commentModel.commentId = model.ID;
            //commentModel.username = model.commentUser.username;
           text = [NSString stringWithFormat:@"回复%@：",isEmpty(self.shortVideoCommentModel.commentUser.username) ? @" " :self.shortVideoCommentModel.commentUser.username];
        }
            break;
            
        case HKMessageType_book:
        {   /// 读书的评论
           text = [NSString stringWithFormat:@"回复%@：",isEmpty(self.bookCommentModel.username) ? @" " :self.bookCommentModel.username];
        }
            break;
            
        default:
            text = @"回复：";
            break;
    }
    
    return text;
}




- (void)createUI {
    [self createLeftBarButton];
    self.title = @"回复";
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"提交" target:self color:COLOR_27323F_EFEFF6 action:@selector(submit:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
    [self.view addSubview:self.feedbackView];
    [self.feedbackView becomeFirstResponder];
    [self.view addSubview:self.pointLabel];
    [self.view addSubview:self.replyBackgroundView];
    [self.replyBackgroundView addSubview:self.replyBackgroundLB];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self.feedbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(KNavBarHeight64+PADDING_15);
        make.right.equalTo(self.view.mas_right).offset(-PADDING_5);
        make.left.equalTo(self.view.mas_left).offset(PADDING_5);
        make.height.mas_equalTo(130);
    }];
    
    [self.pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedbackView.mas_top).offset(PADDING_5);
        make.left.equalTo(self.feedbackView.mas_left).offset(20);
        make.right.equalTo(self.feedbackView);
    }];
    
    [self.replyBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedbackView.mas_bottom).offset(10);
        make.left.equalTo(self.feedbackView).mas_offset(20);
        make.right.equalTo(self.feedbackView).mas_offset(-20);
    }];
    
    [self.replyBackgroundLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
    
    [self setReplyBackgroundLBText];
}

- (void)submit:(id)sender {
    
    if (isEmpty(_feedbackView.text)) {
        showTipDialog(@"您还未输入回复内容");
    }else{
        [self submitWithContent:_feedbackView.text];
    }
}


#pragma mark - 提交评论
- (void)submitWithContent:(NSString *)content {
    
    NSString *temp = nil;
    //字符长度不超过 200；
    if (content.length>200) {
        temp = [content substringWithRange:NSMakeRange(0, 199)];
    }else{
        temp = content;
    }

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *url = nil;
    
    
    switch (self.MessageType) {
        case HKMessageType_video:
        {
            // 普通的评论
            NSString *tempId = self.commentModel.commentId;
            NSString *type = @"2"; // 二级评论回复
            //param = @{@"comment_id" : tempId, @"content" : temp, @"type" : type};
            [param setValue:tempId forKey:@"comment_id"];
            [param setValue:temp forKey:@"content"];
            [param setValue:type forKey:@"type"];
            
            url = @"/video/comment-reply";
        }
            break;
            
        case HKMessageType_shortVideo:
        {   /// 短视频的评论
            [param setValue:self.shortVideoCommentModel.video_id forKey:@"video_id"];
            [param setValue:self.shortVideoCommentModel.ID forKey:@"parent_id"];
            [param setValue:self.shortVideoCommentModel.tid forKey:@"tid"];
            [param setValue:temp forKey:@"content"];
            
            //param = @{@"video_id" : self.shortVideoCommentModel.video_id, @"parent_id" : self.shortVideoCommentModel.ID, @"tid" : self.shortVideoCommentModel.tid, @"content" : temp};
            url = @"short-video-comment/reply";
        }
            break;
            
        case HKMessageType_book:
        {   /// 读书的评论
            // 回复子评论
            if (!isEmpty(self.bookCommentModel.reply_id)) {
                [param setValue:self.bookCommentModel.reply_id forKey:@"reply_id"];
            }
            if (!isEmpty(self.bookCommentModel.comment_id)) {
                [param setValue:self.bookCommentModel.comment_id forKey:@"comment_id"];
            }
            [param setValue:temp forKey:@"content"];
            url = BOOK_COMMENT_CREATE;
        }
            break;
            
        default:
            break;
    }
    
    @weakify(self);
    [HKHttpTool POST:url parameters:param success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"msg"]];
            if (!isEmpty(str)) {
                showTipDialog(str);
            }
            if (HKMessageType_book == self.MessageType) {
                [[HKALIYunLogManage sharedInstance]hkBookClickLogWithFlag:@"7" bookId:self.bookCommentModel.book_id courseId:self.bookCommentModel.course_id];
            }
            [self backAction];
        }
    } failure:^(NSError *error) {
        
    }];
}





- (UITextView*)feedbackView {
    
    if (!_feedbackView) {
        _isFeedbackEmpty = YES;
        _feedbackView = [UITextView new];
        _feedbackView.delegate = self;
        _feedbackView.textColor = COLOR_333333;
        _feedbackView.font = HK_FONT_SYSTEM(14);
        _feedbackView.keyboardType = UIKeyboardTypeDefault;
        _feedbackView.textAlignment = NSTextAlignmentLeft;
        _feedbackView.backgroundColor = [UIColor whiteColor];
        _feedbackView.clipsToBounds = YES;
        _feedbackView.layer.cornerRadius = 3;
        _feedbackView.textContainerInset = UIEdgeInsetsMake(PADDING_5, 15, PADDING_5, 15);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedbackInfoDidChange) name:UITextViewTextDidChangeNotification object:_feedbackView];
        
        _feedbackView.textColor = COLOR_27323F_EFEFF6;
        _feedbackView.tintColor = COLOR_27323F_EFEFF6;
        _feedbackView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _feedbackView;
}


- (UILabel*)pointLabel{
    
    if (!_pointLabel) {
        self.pointLabel = [UILabel new];
        self.pointLabel.font = HK_FONT_SYSTEM(14);
        self.pointLabel.text = [self pointLabelText];
        self.pointLabel.numberOfLines = 0;
        self.pointLabel.userInteractionEnabled = NO;
//        self.pointLabel.enabled = NO;//lable必须设置为不可用
        self.pointLabel.textColor = COLOR_A8ABBE_7B8196;
        //HKColorFromHex(0xA8ABBE, 1.0);
        self.pointLabel.backgroundColor = [UIColor clearColor];
        [self.pointLabel sizeToFit];
    }
    return _pointLabel;
}


- (void)feedbackInfoDidChange {
    if (_feedbackView.text.length > 0) {
        self.isFeedbackEmpty = NO;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blueColor]];
    }else{
        self.isFeedbackEmpty = YES;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    [self updateCaculateTextHeight];
}


// 计算高度
- (void)updateCaculateTextHeight {
    
    CGFloat realHeight = [self.feedbackView.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 25 * 2, CGFLOAT_MAX) options:1 attributes:@{NSFontAttributeName : self.feedbackView.font} context:nil].size.height;
    
    if (realHeight > self.feedbackView.font.pointSize * 2) {
        [self.replyBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.feedbackView.mas_bottom).offset(10 + realHeight - self.feedbackView.font.pointSize);
        }];
    } else {
        [self.replyBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.feedbackView.mas_bottom).offset(10);
        }];
    }
}



#pragma mark - textView delegate
-(void)textViewDidChange:(UITextView *)textView {
    [self updateCaculateTextHeight];
    if (textView.text.length == 0) {
        self.pointLabel.text = [self pointLabelText];
        
    }else{
        self.pointLabel.text=nil;
    }
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    [self updateCaculateTextHeight];
    return YES;
}



@end
