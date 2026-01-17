

//
//  ReplyCommentVC.m
//  Code
//
//  Created by Ivan li on 2017/10/31.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "ReplyCommentVC.h"
#import "UIBarButtonItem+Extension.h"
#import "NewCommentModel.h"
#import "VideoServiceMediator.h"
#import "HKCommentModel.h"
#import "HKMomentDetailModel.h"

@interface ReplyCommentVC ()<UITextViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)UITextField *replyTextField;

@property(nonatomic,strong)UITextView *feedbackView;

@property(nonatomic,strong)UILabel  *pointLabel;

@property(nonatomic,strong)NewCommentModel  *commentModel;

@property(nonatomic,strong)CommentChildModel  *commentChildModel;

@property(nonatomic,strong)id  tempModel;

@property(nonatomic, assign) BOOL isFeedbackEmpty;

@end

@implementation ReplyCommentVC

- (instancetype)initWithModel:(id)commentModel {
//- (instancetype)initWithModel:(NewCommentModel *)commentModel {
    if (self = [super init]) {
        self.tempModel = commentModel;
        self.commentModel = commentModel;
        self.commentChildModel = commentModel;
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
    [MyNotification removeObserver:self];
}

- (void)createUI {
    [self createLeftBarButton];
    self.title = @"回复";
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"提交" target:self color:COLOR_27323F_EFEFF6 action:@selector(submit:)];
    //[UIBarButtonItem barButtonItemWithTitle:@"提交" target:self action:@selector(submit:)];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    WeakSelf;
    [self.view addSubview:self.feedbackView];
    [self.view addSubview:self.pointLabel];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [_feedbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(KNavBarHeight64+PADDING_15);
        make.right.equalTo(weakSelf.view.mas_right).offset(-PADDING_5);
        make.left.equalTo(weakSelf.view.mas_left).offset(PADDING_5);
        make.height.mas_equalTo(SCREEN_HEIGHT/3);
    }];
    
    [_pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.feedbackView.mas_top).offset(PADDING_5);
        make.left.equalTo(weakSelf.feedbackView.mas_left).offset(20);
        make.right.equalTo(weakSelf.feedbackView);
    }];
}

- (void)submit:(id)sender {
    if (_feedbackView.text.length > 0) {
        if (_feedbackView.text == nil || _feedbackView.text == NULL) return;
        if ([_feedbackView.text isKindOfClass:[NSNull class]]) return;
        if ([[_feedbackView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) return;
        
        [self submitWithContent:_feedbackView.text];
    }else{
        showTipDialog(@"您还未输入回复内容");
    }
}

#pragma mark - 提交评论
- (void)submitWithContent:(NSString *)content {
    WeakSelf;
    NSString * temp = nil;
    
    
    
    //字符长度不超过 200；
    if (content.length>200) {
        temp = [content substringWithRange:NSMakeRange(0, 199)];
    }else{
        temp = content;
    }
    
    if (self.mainComment.ID.length) {
        [self postCommentToServer:temp];
    }else{
        NSString *type = nil; // 1-回复一级评论 2-回复二级评论
        NSString *tempId = nil;
        if ([self.tempModel isKindOfClass:[CommentChildModel class]]) {
            tempId = self.commentChildModel.commentId;
            type = @"2";
        }else{
            tempId = self.commentModel.commentId;
            type = @"1";
        }
        
        [[VideoServiceMediator sharedInstance ]replayComment:tempId content:temp type:type completion:^(FWServiceResponse *response) {
            if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
                [weakSelf getSingleCommentInfo];
            }else{
                showTipDialog(response.data[@"business_message"]);
            }
        } failBlock:^(NSError *error) {
            
        }];
    }
}


- (void)postCommentToServer:(NSString *)txt{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.topic_id forKey:@"topic_id"];
    [dic setObject:self.connect_type forKey:@"connectType"];
    if (self.mainComment.ID.length) {
        if (self.replyModel.ID.length) {
            [dic setObject:self.mainComment.ID forKey:@"reply_to_main_id"];
            [dic setObject:self.replyModel.ID forKey:@"reply_to_id"];
        }else{
            [dic setObject:self.mainComment.ID forKey:@"reply_to_main_id"];
        }
    }
    [dic setObject:txt forKey:@"content"];
    
    [HKHttpTool POST:@"/topic/add-reply" parameters:dic success:^(id responseObject) {
        if ([CommonFunction detalResponse:responseObject]) {
                
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        showTipDialog(responseObject[@"msg"]);
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 获取单一评论内容
- (void)getSingleCommentInfo {
    
    NSString *tempId = nil;
    if ([self.tempModel isKindOfClass:[CommentChildModel class]]) {
        tempId = self.commentChildModel.partentId;
    }else{
        tempId = self.commentModel.commentId;
    }
    WeakSelf;
    [[VideoServiceMediator sharedInstance]getSingleCommentInfo:tempId completion:^(FWServiceResponse *response) {
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            showTipDialog(@"回复成功");
            NSMutableArray <CommentChildModel*>*array = [CommentChildModel mj_objectArrayWithKeyValuesArray:[response.data objectForKey:@"reply_list"]];
            !weakSelf.commentBlock? : weakSelf.commentBlock(nil,weakSelf.section,array);
            [weakSelf backAction];
        }else{
            showTipDialog(response.msg);
        }
    } failBlock:^(NSError *error) {
        
    }];
}



- (UITextView*)feedbackView {
    
    if (!_feedbackView) {
        _isFeedbackEmpty = YES;
        _feedbackView = [UITextView new];
        _feedbackView.delegate = self;
        _feedbackView.textColor = COLOR_333333;
        _feedbackView.font = [UIFont systemFontOfSize:(IS_IPHONE6PLUS ? 16:14)];
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
        self.pointLabel.font = [UIFont systemFontOfSize:(IS_IPHONE6PLUS ? 16:14)];
        if (self.mainComment.ID.length) {
            if (self.replyModel.ID.length) {
                self.pointLabel.text = [NSString stringWithFormat:@"回复%@：",self.replyModel.username];
            }else{
                self.pointLabel.text = [NSString stringWithFormat:@"回复%@：",self.mainComment.username];

            }
        }else{
            self.pointLabel.text = [NSString stringWithFormat:@"回复%@：",isEmpty(self.commentModel.username) ? @" " :self.commentModel.username];
        }
        self.pointLabel.numberOfLines = 0;
        self.pointLabel.textColor = COLOR_999999;
        self.pointLabel.enabled = NO;//lable必须设置为不可用
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
}


#pragma mark - textView delegate
-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        if (self.mainComment.ID.length) {
            if (self.replyModel.ID.length) {
                self.pointLabel.text = [NSString stringWithFormat:@"回复%@：",self.replyModel.username];
            }else{
                self.pointLabel.text = [NSString stringWithFormat:@"回复%@：",self.mainComment.username];

            }
        }else{
            self.pointLabel.text = [NSString stringWithFormat:@"回复%@：",isEmpty(self.commentModel.username) ? @" " :self.commentModel.username];
        }
    }else{
        self.pointLabel.text=nil;
    }
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}



@end
