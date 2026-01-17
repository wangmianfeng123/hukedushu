//
//  HKEditNoteVC.m
//  Code
//
//  Created by Ivan li on 2020/12/30.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKEditNoteVC.h"
#import "HKFeedbackView.h"
#import "UIView+HKLayer.h"
#import "QiniuSDK.h"
#import "ZFHKNormalUtilities.h"
#import "HKNotesListModel.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface HKEditNoteVC ()
@property (nonatomic , strong) HKFeedbackView * feedBackView;
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
@property (weak, nonatomic) IBOutlet UIButton *playTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgTopMargin;
@property (nonatomic , strong) UIButton *saveBtn;
@end

@implementation HKEditNoteVC

- (HKFeedbackView*)feedBackView {
    if (!_feedBackView) {
        _feedBackView = [[HKFeedbackView alloc]init];
        _feedBackView.commentType = HKCommentType_BookComment;
        _feedBackView.longestLenth = 2000;
    }
    return _feedBackView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    //注册键盘出现的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
 
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (self.feedBackView.frame.origin.y+self.feedBackView.frame.size.height) - (self.view.frame.size.height - kbHeight);
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
 
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.imgTopMargin.constant = -offset;
        }];
    }
}
 
///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
 
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.imgTopMargin.constant = 5;
    }];
}

- (void)createUI {
    self.title = @"编辑笔记";
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    [self createLeftBarItemWithImageName:@"nac_back"];
    
    [self.openBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    [self.openBtn setTitle:@"公开" forState:UIControlStateNormal];
    [self.openBtn setTitle:@"私密" forState:UIControlStateSelected];
    [self.openBtn addTarget:self action:@selector(openBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.openBtn addCornerRadius:15];
    [self.openBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    [self.openBtn setBackgroundColor:COLOR_F8F9FA_3C4651];
    [self.openBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
    
    self.saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.saveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.saveBtn];
    self.navigationItem.rightBarButtonItem  = barButtonItem;
    
    [self addTxtView];
    
    [self.playTimeBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    [self.playTimeBtn setTitle:@"00:00:00" forState:UIControlStateNormal];
    //[self.playTimeBtn addTarget:self action:@selector(playTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.playTimeBtn addCornerRadius:15];
    [self.playTimeBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    [self.playTimeBtn setBackgroundColor:COLOR_F8F9FA_3C4651];
    [self.playTimeBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];

    self.lineView.backgroundColor = COLOR_F8F9FA_333D48;
    
    [self.topImgView addCornerRadius:5];
    
    if (self.img) {//表示新增
        NSString * timeTxt = [ZFHKNormalUtilities convertTimeSecond:self.currentTime];
        [self.playTimeBtn setTitle:timeTxt forState:UIControlStateNormal];
        self.topImgView.image = self.img;
        self.openBtn.selected = NO;
        self.imgH.constant =  (SCREEN_WIDTH - 30) * 387.0 / 688.0;
    }else{//表示修改
        NSString * timeTxt = [ZFHKNormalUtilities convertTimeSecond:[self.noteModel.seconds integerValue]];
        self.currentTime = [self.noteModel.seconds integerValue];
        [self.playTimeBtn setTitle:timeTxt forState:UIControlStateNormal];
        [self.topImgView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:self.noteModel.screenshot]] placeholderImage:[UIImage imageNamed:HK_Placeholder]];
        self.openBtn.selected = NO;
        self.openBtn.selected = [self.noteModel.is_private intValue] ? YES : NO;
        self.feedBackView.feedbackView.text = self.noteModel.notes;
        self.feedBackView.pointLabel.hidden = self.noteModel.notes.length ? YES : NO;
        
        self.videoModel = [[DetailModel alloc] init];
        self.videoModel.video_id = self.noteModel.video_id;
        self.videoModel.video_titel = self.noteModel.title;
        if (self.noteModel.screenshot.length) {
            self.imgH.constant =  (SCREEN_WIDTH - 30) * 387.0 / 688.0;
        }else{
            self.imgH.constant = 0.0;
        }        
    }
}

-(void)backAction{
    if (self.feedBackView.feedbackView.text.length == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        WeakSelf
        [LEEAlert alert].config
        .LeeAddTitle(^(UILabel *label) {
            label.text = @"是否将此条笔记保存？";//@"确定注销登录吗?";
            label.textColor = COLOR_030303;
        })
        .LeeAddContent(^(UILabel *label) {
            
            //label.text = @"确定要退出吗?";
            label.text = @"我的-笔记中可以随时查看";
            [label setFont:[UIFont systemFontOfSize:15]];
            label.textColor = COLOR_030303;
        })
        .LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeCancel;
            action.title = @"不保存";
            action.titleColor = COLOR_555555;
            action.backgroundColor = [UIColor whiteColor];
            action.clickBlock = ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
        })
        .LeeAddAction(^(LEEAction *action) {
            action.type = LEEActionTypeDefault;
            action.title = @"保存";
            action.titleColor = COLOR_0076FF;
            action.backgroundColor = [UIColor whiteColor];
            action.clickBlock = ^{
                [weakSelf saveDataClick:YES];
            };
            
        })
        .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
        .LeeHeaderColor([UIColor whiteColor])
        .LeeShow();
    }
}

- (void)setNoteModel:(HKNotesModel *)noteModel{
    _noteModel = noteModel;
}

- (void)saveClick{
    self.saveBtn.enabled = NO;
    [self saveDataClick:NO];
}
- (void)saveDataClick:(BOOL)isPop{
    if (self.img) {//上传图片
        [self upLoadNotesData:self.img isPop:isPop];
    }else{
        [self upLoadServer:nil];
    }
}

- (void)openBtnClick:(UIButton *)btn{
    self.openBtn.selected = !self.openBtn.selected;
}

- (void)addTxtView{
    [self.view addSubview:self.feedBackView];
    self.feedBackView.pointLabel.text = @"记录下灵感火花~";
    self.feedBackView.feedbackView.layer.borderColor = [UIColor clearColor].CGColor;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.feedBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.lineView.mas_bottom).offset(0);
        make.height.mas_equalTo(250);
    }];
}

- (void)upLoadNotesData:(UIImage *)img isPop:(BOOL)isPop{//获取上传的token和key
    if (img == nil) return;
    NSData * data = UIImagePNGRepresentation(img);
    @weakify(self);
    [HKHttpTool POST:@"/note/generate-upload-screenshot-token" parameters:nil success:^(id responseObject) {
        
        @strongify(self);
        if ([CommonFunction detalResponse:responseObject]) {
            NSString *token = responseObject[@"data"][@"token"];
            NSString *key = responseObject[@"data"][@"saveKey"];
            if ([HkNetworkManageCenter shareInstance].networkStatus > 0) {
                [self upLoadImgData:data byToken:token byKey:key isPop:isPop];
            }else{
                self.saveBtn.enabled = YES;
                showTipDialog(NETWORK_ALREADY_LOST);
                if (isPop) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }
        }else{
            self.saveBtn.enabled = YES;
            showTipDialog(responseObject[@"msg"]);
            if (isPop) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
    } failure:^(NSError *error) {
        self.saveBtn.enabled = YES;
    }];
}

- (void)upLoadImgData:(NSData *)data byToken:(NSString *)token byKey:(NSString *)key isPop:(BOOL)isPop{//获取上传路径
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:data key:key token:token
    complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        self.saveBtn.enabled = YES;
        if (info.error) {
            showTipDialog(info.error.localizedFailureReason);
            if (isPop) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }else{
            NSLog(@"%@", info);
            NSLog(@"%@", resp);
            [self upLoadServer:key];
        }
    } option:nil];
}

- (void)upLoadServer:(NSString *)key{
    if (self.videoModel.video_id.length == 0 ) {
        showTipDialog(@"video_id不存在");
        return;
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (self.noteModel.ID.length) {
        [dic setValue:self.noteModel.ID forKey:@"note_id"];
    }
    if (key.length) {
        [dic setValue:key forKey:@"screenshot"];
    }
    if (self.feedBackView.feedbackView.text.length) {
        [dic setValue:self.feedBackView.feedbackView.text forKey:@"notes"];
    }
    
    [dic setValue:self.videoModel.video_id forKey:@"video_id"];
    [dic setValue:self.videoModel.video_titel forKey:@"title"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)self.currentTime] forKey:@"seconds"];
    [dic setValue:[NSNumber numberWithBool:self.openBtn.selected ? 1 : 0] forKey:@"is_private"];
    
    [HKProgressHUD showLoading:@""];
    [HKHttpTool POST:@"/note/upsert-note" parameters:dic success:^(id responseObject) {
        //@strongify(self);
        self.saveBtn.enabled = YES;
        [HKProgressHUD hideHUD];
        if ([CommonFunction detalResponse:responseObject]) {
            NSLog(@"%@",responseObject);
            showTipDialog(@"已保存，可在我的tab-我的笔记中查看");

            if(self.noteModel && self.editNoteBlock){
                self.noteModel.notes = self.feedBackView.feedbackView.text;
                self.noteModel.is_private = [NSNumber numberWithBool:self.openBtn.selected ? 1 : 0];
                self.editNoteBlock(self.noteModel);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            showTipDialog(responseObject[@"msg"]);
//            showTipDialog(@"保存失败，请稍后重试");
        }
        
    } failure:^(NSError *error) {
        self.saveBtn.enabled = YES;
    }];
}

@end
