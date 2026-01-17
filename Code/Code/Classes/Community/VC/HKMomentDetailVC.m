//
//  HKMomentDetailVC.m
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKMomentDetailVC.h"
#import "HKMomentCell.h"
#import "HKLiveMomentCell.h"
#import "HKWorksMomentCell.h"
#import "HKHotTopicCell.h"
#import "ACActionSheet.h"
#import "HKMomentTopCell.h"
#import "NewCommentCell.h"
#import "NewCommentModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "HKPostCommentView.h"
#import "YCInputBar.h"
#import "HKCommentListCell.h"
#import "HKMomentDetailModel.h"
#import "HKCommentModel.h"
#import "SingleCommentDetailVC.h"
#import "HKCommentEmptyCell.h"
#import "VideoPlayVC.h"
#import "HKLiveCourseVC.h"
#import "HKUserInfoVC.h"
#import "FeedbackVC.h"
#import "HKTeacherCourseVC.h"
#import "XLPhotoBrowser.h"
#import "UMpopView.h"

@interface HKMomentDetailVC ()<UITableViewDataSource,UITableViewDelegate,YCInputBarDelegate,HKMomentCellDelegate,HKCommentListCellDelegate,XLPhotoBrowserDelegate,UMpopViewDelegate>
//@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , assign) int page ;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) HKPostCommentView *bottomV ;
@property (nonatomic,strong) YCInputBar *bar;
@property (nonatomic , strong) HKMonmentVideoModel * videoModel;
@property (nonatomic , strong) NSMutableArray * replyArray;

@property (nonatomic , strong) HKCommentModel * selectComment; //主评论
@property (nonatomic , strong) HKCommentModel * replyComment; //次级评论
@property (nonatomic , strong) HKMomentDetailModel * detailM;

@end

@implementation HKMomentDetailVC

- (NSMutableArray *)replyArray{
    if (_replyArray == nil) {
        _replyArray = [NSMutableArray array];
    }
    return _replyArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MobClick event: content_view];
    
//    self.topic_id = @"4175";
//    self.connect_type = @"0";

    self.title = @"动态";
    [self createLeftBarButton];
    
    // 是否为黑暗模式
    //is_night  1为夜间模式 0为非夜间模式
    NSString * imageName = @"group_chat_tab_more";
    if (@available(iOS 13.0, *)) {
        DMUserInterfaceStyle mode = DMTraitCollection.currentTraitCollection.userInterfaceStyle;
        BOOL isHKNight = (DMUserInterfaceStyleDark == mode) ? YES : NO;
        imageName = isHKNight ? @"ic_more_detail_dark_2_31" : @"group_chat_tab_more";
    }

    [self createRightBarButtonWithImage:imageName];
    self.view.backgroundColor = COLOR_F8F9FA_3D4752;
    [self.view addSubview:self.tableView];
    
    
    //注：initBar参数，如果当前有navigationController，那么这里应该传self.navigationController.view
    _bar = [[YCInputBar alloc] initBar:self.view sendButtonTitle:@"发送" maxTextLength:500 isHideOnBottom:YES buttonColor:COLOR_7B8196_A8ABBE];
    //_bar.placeholder = [NSString stringWithFormat:@"回复 %@",self.detailM.user.username];

    _bar.delegate = self;
    
    self.bottomV = [HKPostCommentView viewFromXib];
    self.bottomV.frame = CGRectMake(0, self.view.height - 50 - TAR_BAR_XH, SCREEN_WIDTH, 50+ TAR_BAR_XH);
    //self.bottomV.txtLabel.text = [NSString stringWithFormat:@"回复 %@",self.detailM.user.username];
    [self.view addSubview:self.bottomV];
    WeakSelf
    self.bottomV.didTapClickBlock = ^{
        if (isLogin()) {
            [weakSelf checkBindPhone:^{
                [weakSelf.bar showKeyboard];
            } bindPhone:^{
                
            }];
        }else{
            [weakSelf setLoginVC];
        }
        
    };
    @weakify(self);
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        @strongify(self);
        [self loadData];
    }];
    
    [self loadData];
}


-(void)viewWillDisappear:(BOOL)animated{
    if (_bar) {
        [_bar removeSelf];
        _bar = nil;
    }
}

-(void)rightBarBtnAction{
    if (isLogin()){
        WeakSelf;
        NSArray *titleArr = nil;
        if ([self.detailM.user.uid isEqualToString:[CommonFunction getUserId]]) {
            titleArr =  @[@"分享",@"删除",@"取消"];
        }else{
            titleArr =  @[@"分享",@"举报",@"取消"];
        }
            
        ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:nil cancelTitleColor:nil destructiveButtonTitle:nil otherButtonTitles:titleArr buttonTitleColors:nil actionSheetBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                UMpopView *popView = [UMpopView sharedInstance];
                popView.delegate = weakSelf;
                [popView createUIWithModel:weakSelf.detailM.share_data];
                [MobClick event: content_share];
            }else if (1 == buttonIndex) {
                if ([self.detailM.user.uid isEqualToString:[CommonFunction getUserId]]) {
                    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                    [dic setObject:self.detailM.topic.ID forKey:@"id"];
                    [dic setObject:@"0" forKey:@"type"];
                    [dic setObject:self.detailM.topic.connectType forKey:@"connectType"];

                    [HKHttpTool POST:@"/topic/delete" parameters:dic success:^(id responseObject) {
                        if ([CommonFunction detalResponse:responseObject]) {
                            if (self.didDeleteBlock) {
                                self.didDeleteBlock(self.detailM);
                            }
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                            //[weakSelf.tableView reloadData];
                            
                        }
                    } failure:^(NSError *error) {

                    }];
                }else{
                    FeedbackVC *VC = [FeedbackVC new];
                    [self pushToOtherController:VC];
                }
            }else{
                //取消
            }
        }];
        [actionSheet show];
    } else{
        [self setLoginVC];
    }
}

- (UITableView*)tableView {
    if (!_tableView) {//138 * Ratio + KNavBarHeight64
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(IS_IPAD ? iPadContentMargin: 0, 0, IS_IPAD ? iPadContentWidth : SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        // 兼容iOS11
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = YES;
        _tableView.tb_EmptyDelegate = self;
        
        // 防止 reloadsection UI 错乱
        _tableView.estimatedRowHeight = 100;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        

        //任务项cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKMomentTopCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKMomentTopCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKMomentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKMomentCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKLiveMomentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKLiveMomentCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKWorksMomentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKWorksMomentCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKHotTopicCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKHotTopicCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([NewCommentCell class])];
        [_tableView registerClass:NSClassFromString(@"NewCommentCell") forCellReuseIdentifier:@"NewCommentCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKCommentListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKCommentListCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKCommentEmptyCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKCommentEmptyCell class])];
    }
    return _tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKMomentTopCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKMomentTopCell class])];
        cell.videoModel = self.videoModel;
        return cell;
    }else if(indexPath.section == 1 ) {
        if (!self.detailM.dynamic.isEmpty){
            if ([self.detailM.dynamic.connectType isEqual:[NSNumber numberWithInt:1]]&&[self.detailM.dynamic.contentType isEqual:[NSNumber numberWithInt:2]]){//社区动态 - 视频
                HKLiveMomentCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKLiveMomentCell class])];
                cell.model = self.detailM;
                return cell;
            }else if ([self.detailM.dynamic.connectType isEqual:[NSNumber numberWithInt:2]]&&[self.detailM.dynamic.contentType isEqual:[NSNumber numberWithInt:3]]){//社区动态 - 直播
                HKLiveMomentCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKLiveMomentCell class])];
                cell.model = self.detailM;
                return cell;
            }else if ([self.detailM.dynamic.connectType isEqual:[NSNumber numberWithInt:2]]&&[self.detailM.dynamic.contentType isEqual:[NSNumber numberWithInt:4]]){//社区动态 - 作品
                HKWorksMomentCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKWorksMomentCell class])];
                cell.model = self.detailM;
                return cell;
            }else{//纯文案
                HKMomentCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKMomentCell class])];
                cell.delegate = self;
                cell.model = self.detailM;
                cell.contentLabel.numberOfLines = 0;
                return cell;
            }
        }else{//纯文案
            HKMomentCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKMomentCell class])];
            cell.delegate = self;
            cell.model = self.detailM;
            cell.contentLabel.numberOfLines = 0;
            return cell;
        }
    }else{
        if (self.replyArray.count) {
            HKCommentListCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKCommentListCell class])];
            HKCommentModel * commentModel = self.replyArray[indexPath.row];
            cell.commentModel = commentModel;
            cell.delegate = self;
            WeakSelf
            cell.didLookMoreBlock = ^(HKCommentModel * _Nonnull commentModel) {
                SingleCommentDetailVC *singVC = [[SingleCommentDetailVC alloc]init];
                //singVC.detailM = weakSelf.detailM;
                singVC.comment_id = commentModel.ID;
                singVC.topic_id =  weakSelf.detailM.topic.ID;
                singVC.connect_type =  [NSString stringWithFormat:@"%@",weakSelf.detailM.topic.connectType];
                [self pushToOtherController:singVC];
            };
            return cell;

        }else{
            HKCommentEmptyCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKCommentEmptyCell class])];
            return cell;
        }
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:nil placeholderImage:nil
                                                   lookStatus:LookStatusInternetVideo videoId:[NSString stringWithFormat:@"%@",self.videoModel.videoId] model:nil];
        [MobClick event: content_class];
        [self pushToOtherController:VC];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
    //return self.dataArray.count ? 1 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.videoModel.videoId.length ? 80 : 0.0;

    }
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }else{
        if (self.replyArray.count == 0) {
            return 1;
        }else{
            return self.replyArray.count;
        }
    }
}

- (void)loadData{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.topic_id forKey:@"id"]; //主题ID topic.id
    [dic setObject:self.connect_type forKey:@"connectType"]; //主题类型 topic.connectType
    @weakify(self);
    [HKHttpTool POST:@"/topic/detail" parameters:dic success:^(id responseObject) {
     
        @strongify(self);
        if ([CommonFunction detalResponse:responseObject]) {
            self.videoModel = nil;
            self.selectComment = nil;
            self.replyComment = nil;
            
            self.detailM = [HKMomentDetailModel mj_objectWithKeyValues:responseObject[@"data"][@"topic"]];
            _bar.placeholder = [NSString stringWithFormat:@"回复 %@",self.detailM.user.username];
            self.bottomV.txtLabel.text = [NSString stringWithFormat:@"回复 %@",self.detailM.user.username];

            self.detailM.recentlyReplies = nil;
            if (self.detailM.video.videoId.length) {
                self.videoModel = self.detailM.video;
            }
            self.detailM.video = nil;
            self.replyArray = [HKCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"replies"]];
            [self.tableView reloadData];
        }else{
            showTipDialog(responseObject[@"msg"]);
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark ===== HKMomentCellDelegate
-(void)momentCellDidAttentionBtn:(HKMomentDetailModel *)model {
    if (isLogin()){
        WeakSelf;
        if (model.user.subscribed) {
            
            NSArray *titleArr =  @[@"不再关注",@"取消"];
            
            ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:nil cancelTitleColor:nil destructiveButtonTitle:nil otherButtonTitles:titleArr buttonTitleColors:nil actionSheetBlock:^(NSInteger buttonIndex) {
                
                if (0 == buttonIndex) {
                    [weakSelf loadAttentionData:model];
                }else{
                    //取消
                }
            }];
            [actionSheet show];
        }else{
            [self loadAttentionData:model];
        }
    } else{
        [self setLoginVC];
    }
}

- (void)loadAttentionData:(HKMomentDetailModel *)model{
    if (isLogin()){
        WeakSelf;
        if (model.user.uid.length == 0) {
            showTipDialog(@"关注失败");
            return;
        }
        [HKHttpTool POST:@"/switch/subscribe" parameters:@{@"uid":model.user.uid} success:^(id responseObject) {
            if ([CommonFunction detalResponse:responseObject]) {
                if (!model.user.subscribed) {
                    showTipDialog(@"关注成功");
                }
                self.detailM.user.subscribed = !self.detailM.user.subscribed;
                [weakSelf.tableView reloadData];
                if (self.didAttentionBlock) {
                    self.didAttentionBlock(model);
                }
            }
        } failure:^(NSError *error) {
            
        }];
    } else{
        [self setLoginVC];
    }
}


- (void)momentCellDidImgArray:(NSMutableArray *)imgArray andIndex:(NSInteger)index{
    [HKPhotoBrowserTool initPhotoBrowserWithUrlArray:imgArray withIndex:index delegate:self];
}

#pragma mark  XLPhotoBrowserDatasource
- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return imageName(HK_Placeholder);
}

- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex
   currentImageIndex:(NSInteger)currentImageIndex {
    switch (actionSheetindex) {
        case 0:
        {   //保存
            [browser saveCurrentShowImage];
        }
            break;
        default:
            break;
    }
}

-(void)momentCellDidHeaderBtn:(HKMomentDetailModel *)model{
    if (!model.user.uid.length) return;
        [HKHttpTool POST:@"/user/home-header" parameters:@{@"uid":model.user.uid} success:^(id responseObject) {
            if ([CommonFunction detalResponse:responseObject]) {
                BOOL isTeacher = [responseObject[@"data"][@"teacher"] boolValue];
                if (isTeacher) {
                    int teacher_id = [responseObject[@"data"][@"user"][@"teacherId"] intValue];
                    HKTeacherCourseVC *vc = [[HKTeacherCourseVC alloc] init];
                    vc.teacher_id = [NSString stringWithFormat:@"%d",teacher_id];
                    vc.followBlock = ^(BOOL is_follow, NSString *teacher_id) {
                        
                    };
                    [self pushToOtherController:vc];
                }else{
                    HKUserInfoVC *vc = [[HKUserInfoVC alloc] init];
                    vc.userId = model.user.uid;
                    [self.navigationController pushViewController:vc animated:YES];

                }
            }
        } failure:^(NSError *error) {
            
        }];
}

- (void)momentCellDidLikeBtn:(HKMomentDetailModel *)model{
    if (isLogin()) {
        if (model.topic.isLiked) return;
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:model.topic.ID forKey:@"id"];
        [dic setObject:@"0" forKey:@"type"];
        [dic setObject:model.topic.connectType forKey:@"connectType"];
        
        [HKHttpTool POST:@"/switch/likes" parameters:dic success:^(id responseObject) {
            if ([CommonFunction detalResponse:responseObject]) {
                model.topic.isLiked = !model.topic.isLiked;
                model.topic.likes_count = [NSNumber numberWithInt:[model.topic.likes_count intValue] + 1];
                [self.tableView reloadData];
                if (self.didLikeBlock) {
                    self.didLikeBlock(model);
                }
            }
        } failure:^(NSError *error) {
                
        }];
    }else{
        [self setLoginVC];
    }
}


-(void)momentCellDidCommentBtn:(HKMomentDetailModel *)model{
    @weakify(self);
    if (isLogin()) {
        [self checkBindPhone:^{
            @strongify(self);
            [self.bar showKeyboard];
            self.selectComment = nil;
            self.replyComment = nil;
            _bar.placeholder = [NSString stringWithFormat:@"回复 %@",self.detailM.user.username];
            self.bottomV.txtLabel.text = [NSString stringWithFormat:@"回复 %@",self.detailM.user.username];
        } bindPhone:^{

        }];
    }else{
        [self setLoginVC];
    }
}

-(void)momentCellDidShareBtn:(HKMomentDetailModel *)model{
    UMpopView *popView = [UMpopView sharedInstance];
    popView.delegate = self;
    [popView createUIWithModel:model.share_data];
}

#pragma mark - UMpopView 代理
- (void)uMShareWebSucess:(id)sender {
    if ([sender isKindOfClass:[ShareModel class]]) {
        ShareModel *model = (ShareModel*)sender;
        [self shareSucessWithModel:model];
    }
}

#pragma mark - 分享网页成功 回调 后台
- (void)shareSucessWithModel:(ShareModel*)model {
    
    if (!isLogin()) {
        showTipDialog(Share_Sucess);
        return;
    }
    [HKCommonRequest shareDataSucess:model success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)uMShareImageSucess:(id)sender {
    if ([sender isKindOfClass:[ShareModel class]]) {
        ShareModel *model = (ShareModel*)sender;
        [self shareSucessWithModel:model];
    }
}

#pragma mark - YCBar delegate
-(BOOL)sendButtonClick:(UITextView *)textView{
    
    if (textView.text.length == 0 && ![textView.text containsString:@"\n"]) {
        return NO;
    }

    if (textView.text == nil || textView.text == NULL) {

        return NO;

    }

    if ([textView.text isKindOfClass:[NSNull class]]) {

        return NO;

    }

    if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {

        return NO;

    }
    
    NSLog(@"你的评论：%@",textView.text);

    WeakSelf;
    if (isLogin()) {
        [self checkBindPhone:^{
            [weakSelf postCommentToServer:textView.text];
        } bindPhone:^{

        }];
    }else{
        [self setLoginVC];
    }
    return YES;
}


- (void)postCommentToServer:(NSString *)txt{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.detailM.topic.ID forKey:@"topic_id"];
    [dic setObject:self.detailM.topic.connectType forKey:@"connectType"];
    if (self.selectComment.ID.length) {
        if (self.replyComment.ID.length) {
            [dic setObject:self.selectComment.ID forKey:@"reply_to_main_id"];
            [dic setObject:self.replyComment.ID forKey:@"reply_to_id"];
        }else{
            [dic setObject:self.selectComment.ID forKey:@"reply_to_main_id"];
        }
    }
    [dic setObject:txt forKey:@"content"];
    WeakSelf
    [HKHttpTool POST:@"/topic/add-reply" parameters:dic success:^(id responseObject) {
        if ([CommonFunction detalResponse:responseObject]) {
            weakSelf.bar.txt = @"";
        }
        showTipDialog(responseObject[@"msg"]);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ========= HKCommentListCellDelegate
- (void)commentListCellDidMoreBtn:(HKCommentModel *)commentModel{
    if (isLogin()){
        WeakSelf;
        
        NSArray *titleArr = nil;
        if ([commentModel.uid isEqualToString:[CommonFunction getUserId]]) {
            titleArr =  @[@"删除",@"取消"];
        }else{
            titleArr =  @[@"举报",@"取消"];
        }
                    
        ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:nil cancelTitleColor:nil destructiveButtonTitle:nil otherButtonTitles:titleArr buttonTitleColors:nil actionSheetBlock:^(NSInteger buttonIndex) {
            
            if (0 == buttonIndex) {
                if ([commentModel.uid isEqualToString:[CommonFunction getUserId]]) {
                    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                    [dic setObject:commentModel.ID forKey:@"id"];
                    [dic setObject:@"1" forKey:@"type"];
                    [dic setObject:self.detailM.topic.connectType forKey:@"connectType"];

                    [HKHttpTool POST:@"/topic/delete" parameters:dic success:^(id responseObject) {
                        if ([CommonFunction detalResponse:responseObject]) {
                            for (int i= 0; i < self.replyArray.count; i++) {
                                HKCommentModel * model = self.replyArray[i];
                                if ([model.ID isEqualToString:commentModel.ID]) {
                                    [self.replyArray removeObject:model];
                                }
                            }
                            [weakSelf.tableView reloadData];
                        }
                    } failure:^(NSError *error) {

                    }];
                }else{
                    FeedbackVC *VC = [FeedbackVC new];
                    VC.commentId = commentModel.ID;
                    [self pushToOtherController:VC];
                }
            }else{
                //取消
            }
        }];
        [actionSheet show];
    } else{
        [self setLoginVC];
    }
}

- (void)commentListCellDidLikeBtn:(HKCommentModel *)commentModel{
    if (isLogin()){
        if (commentModel.isLiked) return;
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:commentModel.ID forKey:@"id"];
        [dic setObject:@"1" forKey:@"type"];
        [dic setObject:self.detailM.topic.connectType forKey:@"connectType"];
        
        [HKHttpTool POST:@"/switch/likes" parameters:dic success:^(id responseObject) {
            if ([CommonFunction detalResponse:responseObject]) {
                commentModel.isLiked = !commentModel.isLiked;
                commentModel.likes_count = [NSNumber numberWithInt:[commentModel.likes_count intValue] + 1];
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
                
        }];
    }else{
        [self setLoginVC];
    }
}

-(void)commentListCellDidLabel:(HKCommentModel *)commentModel subReplyModel:(HKCommentModel *)replyModel{
    @weakify(self);
    if (isLogin()) {
        [self checkBindPhone:^{
            @strongify(self);
            if (replyModel.ID.length) {
                _bar.placeholder = [NSString stringWithFormat:@"回复 %@",replyModel.username];
                self.bottomV.txtLabel.text = [NSString stringWithFormat:@"回复 %@",replyModel.username];

            }else{
                _bar.placeholder = [NSString stringWithFormat:@"回复 %@",commentModel.username];
                self.bottomV.txtLabel.text = [NSString stringWithFormat:@"回复 %@",commentModel.username];
            }
            self.selectComment = commentModel;
            self.replyComment = replyModel;
            [self.bar showKeyboard];
        } bindPhone:^{

        }];
    }else{
        [self setLoginVC];
    }
}

-(void)commentListCellDidHeaderBtn:(HKCommentModel *)commentModel{
    if (!commentModel.uid.length) return;
    [HKHttpTool POST:@"/user/home-header" parameters:@{@"uid":commentModel.uid} success:^(id responseObject) {
        if ([CommonFunction detalResponse:responseObject]) {
            BOOL isTeacher = [responseObject[@"data"][@"teacher"] boolValue];
            if (isTeacher) {
                int teacher_id = [responseObject[@"data"][@"user"][@"teacherId"] intValue];
                HKTeacherCourseVC *vc = [[HKTeacherCourseVC alloc] init];
                vc.teacher_id = [NSString stringWithFormat:@"%d",teacher_id];
                vc.followBlock = ^(BOOL is_follow, NSString *teacher_id) {
                    
                };
                [self pushToOtherController:vc];
            }else{
                HKUserInfoVC *vc = [[HKUserInfoVC alloc] init];
                vc.userId = commentModel.uid;
                [self.navigationController pushViewController:vc animated:YES];

            }
        }
    } failure:^(NSError *error) {
        
    }];
}



@end
