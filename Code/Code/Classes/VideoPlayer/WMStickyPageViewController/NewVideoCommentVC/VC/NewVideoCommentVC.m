//
//  NewVideoCommentVC.m
//  Code
//
//  Created by Ivan li on 2017/10/30.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "NewVideoCommentVC.h"
#import "VideoServiceMediator.h"
#import "FeedbackVC.h"
#import "DetailModel.h"
#import "NewCommentModel.h"
#import "NewCommentCell.h"

#import "UITableView+SDAutoTableViewCellHeight.h"
#import "CommentHeadView.h"
#import "CommentFootView.h"
#import "SingleCommentDetailVC.h"
#import "ReplyCommentVC.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "HKCommentScoreView.h"
#import "HKCommentEmptyView.h"
#import "HKUserInfoVC.h"
#import "XLPhotoBrowser.h"
#import "HKInteractionHeaderView.h"
#import "HKVideoEvaluationVC.h"

@interface NewVideoCommentVC ()<UITableViewDelegate,UITableViewDataSource,
HKVideoEvaluationVCDelegate,CommentFootViewDelegate,CommentHeadViewDelegate,XLPhotoBrowserDelegate,XLPhotoBrowserDatasource,XLPhotoBrowserDelegate>{
    
}

@property(nonatomic,strong)UITableView        *tableView;

@property(nonatomic,strong)NSMutableArray <NewCommentModel*> *dataArray;

@property(nonatomic,copy)NSString *commentCount;
/** 评价分数 */
//@property(nonatomic,strong)HKCommentScoreView *commentScoreView;

//@property(nonatomic,copy)void(^commentDeletedBlock)();//评论被删除后 更新评论数量
/** 评论空视图 */
@property(nonatomic,strong)HKCommentEmptyView *commentEmptyView;
/** 评论简要信息 */
//@property(nonatomic,strong)NewCommentHeadModel *commentHeadModel;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)DetailModel *detailModel;
@property (nonatomic , strong) HKInteractionHeaderView * tabHeaderView;
@property (nonatomic , strong) NSMutableArray * picturesArray;

@end


@implementation NewVideoCommentVC


- (BOOL)tb_showEmptyView:(UIScrollView *)scrollView network:(TBNetworkStatus)status {

    if (TBNetworkStatusNotReachable == status) {
        return YES;
    }
    return NO;
}


- (CGPoint)tb_emptyViewOffset:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    return CGPointMake(0, 45);
}

- (instancetype)initWithDetailModel:(DetailModel*)model {
    
    if (self = [super init]) {
        self.videoId = model.video_id;
        self.detailModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)picturesArray{
    if (_picturesArray == nil) {
        _picturesArray = [NSMutableArray array];
    }
    return _picturesArray;
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick event:UM_RECORD_VIDEO_DETAIL_TAB_EVALUATETAB];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (0 == self.dataArray.count) {
        
        
        [self getVideoCommentWithToken:nil videoId:self.videoId page:@"1" only_type:[NSString stringWithFormat:@"%ld",self.type]];
    }
}



- (void)setCommentWithModel:(DetailModel*)model {
    self.detailModel = model;
    self.tableView.hidden = YES;
    if (self.dataArray) {
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
    }
    // 加载评论数据
    [self getVideoCommentWithToken:nil videoId:self.videoId page:@"1" only_type:[NSString stringWithFormat:@"%ld",self.type]];
}


- (void)setDetailModel:(DetailModel *)detailModel {
    _detailModel = detailModel;
    self.videoId = detailModel.video_id;
}



- (void)createUI {
    //self.emptyText = @"没有更多数据";
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    [self refreshUI];
    [MyNotification addObserver:self selector:@selector(loadVideoCommentData) name:@"refreshVideoCommentData" object:nil];
}



- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}



#pragma mark - commentBottomView 代理
- (void)pushToCommentVC {
    
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    
    if ([self.detailModel.is_play isEqualToString:@"1"]) {
        //is_play：1-可以评论 0-不可以评论
        WeakSelf;
        [self checkBindPhone:^{
            StrongSelf;
            [strongSelf setEvaluationVC];
        } bindPhone:^{
            
        }];
        
    }else{
        showTipDialog(@"学习后才能评价哦～");
    }
}



- (void)setEvaluationVC {
//    EvaluationVC *VC = [[EvaluationVC alloc]initWithNibName:nil bundle:nil videoId:self.videoId];
//    VC.delegate = self;
//    [self pushToOtherController:VC];
    
    HKVideoEvaluationVC *VC = [[HKVideoEvaluationVC alloc]initWithNibName:nil bundle:nil videoId:self.videoId];
    VC.delegate = self;
    [self pushToOtherController:VC];
    
}

- (void)loadVideoCommentData{
    [self getVideoCommentWithToken:nil videoId:self.videoId page:@"1" only_type:[NSString stringWithFormat:@"%ld",self.type]];
}

#pragma mark - EvaluationVC  代理
- (void)evaluationSucess {
    [self getVideoCommentWithToken:nil videoId:self.videoId page:@"1" only_type:[NSString stringWithFormat:@"%ld",self.type]];
}
-(void)videoEvaluationSucess{
    [self getVideoCommentWithToken:nil videoId:self.videoId page:@"1" only_type:[NSString stringWithFormat:@"%ld",self.type]];
}

#pragma mark - comment cell  代理
- (void)reportComment:(id)sender buttonIndex:(NSInteger)buttonIndex {
    //留言
    [self pushToOtherController:[FeedbackVC new]];
}



- (void)setCommentCount:(NSString *)commentCount {
    
    _commentCount = commentCount;
    //空视图
    if (0 == [commentCount intValue]) {
        [self.view addSubview:self.commentEmptyView];
    }else{
        TTVIEW_RELEASE_SAFELY(self.commentEmptyView);
    }
//    self.commentScoreView.model = self.commentHeadModel;
}


- (HKCommentEmptyView*)commentEmptyView {
    if (!_commentEmptyView) {
        WeakSelf;
        _commentEmptyView = [[HKCommentEmptyView alloc]init];
        _commentEmptyView.userInteractionEnabled = NO;
        _commentEmptyView.frame = CGRectMake(0, 0, (IS_IPAD ? iPadContentWidth : SCREEN_WIDTH), SCREEN_HEIGHT*2/3-44);
        _commentEmptyView.commentEmptyViewBlock = ^(id sender) {
            StrongSelf;
            [strongSelf pushToCommentVC];
        };
        _commentEmptyView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _commentEmptyView;
}

//- (HKCommentScoreView*)commentScoreView {
//    if (!_commentScoreView) {
//        WeakSelf;
//        _commentScoreView = [[HKCommentScoreView alloc]init];
//        _commentScoreView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.1);
//        _commentScoreView.commentScoreViewBlock = ^(id sender) {
//            [weakSelf pushToCommentVC];
//        };
//    }
//    return _commentScoreView;
//}



//- (HKCommentScoreView*)headerView {
//
//    WeakSelf;
//    self.commentDeletedBlock = ^{
//        int count = [weakSelf.commentCount intValue];
//        weakSelf.commentCount = [NSString stringWithFormat:@"%d",count-1];
//    };
//
//    return self.commentScoreView;
//}




- (UITableView*)tableView {
    
    if (!_tableView) {
        //CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2/3-44);
        CGFloat playerHeight = IS_IPAD ? SCREEN_HEIGHT * 0.5 : floor(SCREEN_WIDTH*9/16);
        CGFloat h = SCREEN_HEIGHT-playerHeight- 44 -40 -(IS_IPHONE_X ?70 :50);
        CGRect rect = CGRectMake(0, 0, (IS_IPAD ? iPadContentWidth : SCREEN_WIDTH),h);
        
        _tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
        
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
//        _tableView.tableHeaderView = [self headerView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:NSClassFromString(@"NewCommentCell") forCellReuseIdentifier:@"NewCommentCell"];
        [_tableView registerClass:NSClassFromString(@"CommentHeadView") forHeaderFooterViewReuseIdentifier:@"CommentHeadView"];
        [_tableView registerClass:NSClassFromString(@"CommentFootView") forHeaderFooterViewReuseIdentifier:@"CommentFootView"];
        
        // 防止 reloadsection UI 错乱
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
//        if (@available(iOS 11.0, *)) {
//            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        } else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.hidden = YES;
    }
    return _tableView;
}



#pragma mark - CommentFootViewDelegate
//点赞
- (void)praiseAction:(NSInteger)section model:(NewCommentModel*)model {
    if (isLogin()) {
        [model.is_like isEqualToString:@"1"] ? nil :[self praiseWithCommentId:model.commentId section:section];
    }else{
        [self setLoginVC];
    }
}


#pragma mark - 跳转 评论 视图
- (void)pushToReplyCommentVC:(NSInteger)section model:(NewCommentModel*)model {
    
    if (isLogin()) {
        WeakSelf;
        [self checkBindPhone:^{
            StrongSelf;
            [strongSelf setReplyCommentWithModel:model section:section];
        } bindPhone:^{
            
        }];
    }else{
        [self setLoginVC];
    }
}


#pragma mark - 建立评论视图
- (void)setReplyCommentWithModel:(NewCommentModel*)model section:(NSInteger)section {
    WeakSelf;
    ReplyCommentVC *VC = [[ReplyCommentVC alloc]initWithModel:model];
    VC.section = section;
    VC.commentBlock = ^(NSString *comment, NSInteger section, NSMutableArray<CommentChildModel *> *modelArr) {
        
        StrongSelf;
        NSInteger tempSection = section;
        if (modelArr.count) {
            strongSelf.dataArray[tempSection].children = modelArr;
            [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:tempSection] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    [self pushToOtherController:VC];
}


//评论
- (void)commentAction:(NSInteger)section model:(NewCommentModel*)model {
    [self pushToReplyCommentVC:section model:model];
}

//举报
- (void)complainAction:(NSInteger)section model:(NewCommentModel*)model sender:(id)sender {
    FeedbackVC *VC = [FeedbackVC new]; VC.commentId = model.commentId;
    isLogin() ? [self pushToOtherController:VC] :[self setLoginVC];
}

//headview 评论
- (void)headViewCommentAction:(NSInteger)section model:(NewCommentModel*)model {
    [self pushToReplyCommentVC:section model:model];
}
//点击头像
- (void)headViewuserImageViewClick:(NSInteger)section model:(NewCommentModel *)model {
    
    HKUserInfoVC *vc = [HKUserInfoVC new];
    vc.userId = model.uid;
    [self pushToOtherController:vc];
}

//删除评论
- (void)deleteCommentAction:(NSInteger)section model:(NewCommentModel *)model {
    isLogin() ? [self deleteCommentWithCommentId:model.commentId section:section]:[self setLoginVC];
}

//点击评论图片
- (void)headViewCommentImageViewClick:(NSInteger)section model:(NewCommentModel*)model index:(NSInteger)index{
    
    //[self setPhotoBrowserWithUrl:model.image ];
    [HKPhotoBrowserTool initPhotoBrowserWithUrlArray:model.pictures withIndex:index delegate:self];
}


#pragma mark - WMStickyPageViewControllerDelegate
//- (UIScrollView *)streachScrollView {
//    return self.tableView;
//}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count>0 ? _dataArray.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  _dataArray[section].childrenCount>3 ? 4 : _dataArray[section].childrenCount;
    //return  _dataArray[section].children.count>3 ? 4 : _dataArray[section].children.count;
}


//footer
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return PADDING_25*2;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CommentFootView *footerView = (CommentFootView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CommentFootView"];
    footerView.delegate = self;
    footerView.section = section;
    footerView.isHiddenLine = NO;
    NewCommentModel *model = _dataArray[section];
    footerView.model = model;
    return footerView;
}

//header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NewCommentModel *model = _dataArray[section];
    NSLog(@"model.headViewHeight---- %ld  ----> %f", section,model.headViewHeight);
    return model.headViewHeight;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CommentHeadView *headerView = (CommentHeadView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CommentHeadView"];
    headerView.delegate = self;
    headerView.section = section;
    NewCommentModel *model = _dataArray[section];
    //headerView.videoCommentModel = model;
    [headerView setVideoCommentModel:model hidden:(section==0)];
    return headerView;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewCommentModel *commentModel = _dataArray[indexPath.section];
    CommentChildModel *model = _dataArray[indexPath.section].children[indexPath.row];
    WeakSelf;
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"NewCommentCell"
                                                 configuration:^(NewCommentCell *cell) {
                                                     [weakSelf configureCell:cell atIndexPath:[indexPath row] model:model commentModel:commentModel];
                                                 }];
    //NSLog(@"heightForRowAtIndexPath --- >>%f",height);
    if (commentModel.childrenCount -1 == indexPath.row) {
        height += 7;
    }
    return indexPath.row>2 ? PADDING_15*2+5 : height;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewCommentCell* cell = [NewCommentCell initCellWithTableView:tableView row:indexPath.row];
    NewCommentModel *commentModel = _dataArray[indexPath.section];
    CommentChildModel *model = _dataArray[indexPath.section].children[indexPath.row];
    [self configureCell:cell atIndexPath:[indexPath row] model:model commentModel:commentModel];
    return cell;
}

#pragma mark - 计算cell的高度
- (void)configureCell:(NewCommentCell *)cell atIndexPath:(NSInteger)indexPath  model:(CommentChildModel*)model
         commentModel:(NewCommentModel *)commentModel {
    //cell.commentModel = commentModel;
    cell.fd_enforceFrameLayout = YES;
    cell.model = model;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    if (0 == self.dataArray.count) {
        return;
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NewCommentModel *newModel = _dataArray[section];
    CommentChildModel *childModel = _dataArray[section].children[row];
    childModel.partentId = newModel.commentId; // 回复评论 ID 需要导入 外层评论ID
    if (row >2) {
        
        SingleCommentDetailVC *singVC = [[SingleCommentDetailVC alloc]initWithModel:newModel];
        singVC.praiseBlock = ^(NSInteger section, NewCommentModel *commentModel) {
            if (commentModel) {
                [weakSelf.dataArray replaceObjectsAtIndexes:[NSIndexSet indexSetWithIndex:section]  withObjects:@[commentModel]];
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
            }
        };
        singVC.deleteCommentBlock = ^(NSInteger section, NewCommentModel *commentModel) {
            [weakSelf.dataArray removeObjectAtIndex:section];
            [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
//            weakSelf.commentDeletedBlock(); // 评论删除回调
            self.commentCount = [NSString stringWithFormat:@"%d",[self.commentCount intValue] -1] ;
            self.commentCountChangeBlock ? self.commentCountChangeBlock(self.commentCount) :nil;
        };
        [self pushToOtherController:singVC];
        //[self pushToOtherController:[[SingleCommentDetailVC alloc]initWithModel:newModel]];
    }else{
        if (!isLogin()) {
            [self setLoginVC];
            return;
        }
        //childModel.commentId = newModel.commentId; // 回复评论 ID 需要导入 外层评论ID
        ReplyCommentVC *VC = [[ReplyCommentVC alloc]initWithModel:childModel];
        VC.section = section;
        VC.indexPath = indexPath;
        VC.commentBlock = ^(NSString *comment, NSInteger section, NSMutableArray<CommentChildModel *> *modelArr) {
            
            NSInteger tempSection = section;
            if (modelArr.count) {
                weakSelf.dataArray[tempSection].children = modelArr;
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:tempSection] withRowAnimation:UITableViewRowAnimationNone];
            }
        };
        [self pushToOtherController:VC];
    }
}




#pragma mark - 刷新
- (void)refreshUI {
    self.page = 1;
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        strongSelf.page = 1;
        [strongSelf getVideoCommentWithToken:nil videoId:strongSelf.videoId page:[NSString stringWithFormat:@"%ld",strongSelf.page] only_type:[NSString stringWithFormat:@"%ld",self.type]];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        [strongSelf getVideoCommentWithToken:nil videoId:strongSelf.videoId page:[NSString stringWithFormat:@"%ld",strongSelf.page] only_type:[NSString stringWithFormat:@"%ld",self.type]];
    }];
    self.tableView.mj_footer.automaticallyHidden = NO;
}


- (void)createTabHeader{
    
    if (self.type == InteractionTypeAll && self.picturesArray.count) {
        CGFloat h = ((IS_IPAD ? iPadContentWidth :SCREEN_WIDTH) - 30 - 30 - 20) / 3.0;
                
        HKInteractionHeaderView * header = [[HKInteractionHeaderView alloc] initWithFrame:CGRectMake(0, 0, IS_IPAD ? iPadContentWidth:SCREEN_WIDTH , h + 55)];
        self.tabHeaderView = header;
        self.tableView.tableHeaderView = header;
        self.tabHeaderView.urlArray = self.picturesArray;
    
        header.tipBlock = ^{
            [LEEAlert alert].config
            .LeeAddContent(^(UILabel *label) {
                label.text = @"素材及源文件\n请在电脑端虎课网下载";
                [label setFont:[UIFont systemFontOfSize:15]];
                label.textColor = COLOR_030303;
            })
            .LeeAddAction(^(LEEAction *action) {

                action.type = LEEActionTypeCancel;
                action.title = @"取消";
                action.titleColor = COLOR_555555;
                action.backgroundColor = [UIColor whiteColor];
                action.clickBlock = ^{

                };
            })
            .LeeAddAction(^(LEEAction *action) {

                action.type = LEEActionTypeDefault;
                action.title = @"复制链接";
                action.titleColor = COLOR_0076FF;
                action.backgroundColor = [UIColor whiteColor];
                action.clickBlock = ^{
                    if (self.pc_url.length) {
                        UIPasteboard *pab = [UIPasteboard generalPasteboard];
                        pab.string = self.pc_url;
                        showTipDialog(@"链接已复制，请在电脑浏览器打开");
                        [MobClick event: detailpage_evaluate_all_copylink];
                    }
                };
            })
            .LeeShouldAutorotate(NO)
            .LeeHeaderColor([UIColor whiteColor])
            .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
            .LeeShow();
        };
        WeakSelf
        header.didImgBlock = ^(NSInteger index) {
            [MobClick event: detailpage_evaluate_all_taskpic];
            [HKPhotoBrowserTool initPhotoBrowserWithUrlArray:weakSelf.picturesArray withIndex:index delegate:weakSelf];
        };
    }
}


- (void)tableHeaderEndRefreshing {
    [self.tableView.mj_header endRefreshing];
}

- (void)tableFooterEndRefreshing {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    self.tableView.mj_footer.hidden = YES;
}

- (void)tableFooterStopRefreshing {
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_footer.hidden = NO;
}


#pragma mark - 获取视频评价列表
- (void)getVideoCommentWithToken:(NSString*)token videoId:(NSString*)videoId  page:(NSString*)page only_type:(NSString *)typeString{
    @weakify(self);
    [[VideoServiceMediator sharedInstance] getVideoComment:token videoId:videoId page:page only_type:typeString
                                                completion:^(FWServiceResponse *response) {
        @strongify(self);
        [self tableHeaderEndRefreshing];
        if ([response.code isEqualToString:@"1"]) {
            
            NSMutableArray <NewCommentModel*>*array = [NewCommentModel mj_objectArrayWithKeyValuesArray:[response.data objectForKey:@"list"]];
            if ([page isEqualToString:@"1"] && self.type == 0) {
                self.picturesArray = response.data[@"work_pictures"];
                [self createTabHeader];
            }
            
            
            NSString *commentCount = [NSString stringWithFormat:@"%@",response.data[@"pageObj"][@"total_count"]];
            self.commentCount = commentCount;
            
            NSString *count = [NSString stringWithFormat:@"%@",[response.data objectForKey:@"total_page"]];
            if (self.page >= [count integerValue]) {
                [self tableFooterEndRefreshing];
            }else{
                [self tableFooterStopRefreshing];
            }
            
            //[self tableFooterStopRefreshing];
            
            if ([page isEqualToString:@"1"]) {
                self.dataArray = array;
            }else{
                [self.dataArray addObjectsFromArray:array];
            }
            self.page ++;
            
        }else{
            [self tableFooterStopRefreshing];
        }
        [self.tableView reloadData];
        self.tableView.hidden = NO;
        
    } failBlock:^(NSError *error) {
        @strongify(self);
        [self tableHeaderEndRefreshing];
        [self tableFooterStopRefreshing];
        self.tableView.hidden = NO;
        if (0 == self.dataArray.count) {
            [self.tableView reloadData];
        }
    }];
}


#pragma mark - 点赞
- (void)praiseWithCommentId:(NSString*)commentId  section:(NSInteger)section  {
    
    if (isLogin() && !isEmpty(commentId)) {
        WeakSelf;
        [[VideoServiceMediator sharedInstance] VideoPraise:nil
                                                 commentId:commentId
                                                completion:^(FWServiceResponse *response) {
                                                    if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
                                                        NewCommentModel *model =  weakSelf.dataArray[section];
                                                        NSInteger count = [model.thumbs intValue];
                                                        model.thumbs = [NSString stringWithFormat:@"%ld",count+1];
                                                        model.is_like = @"1";
                                                        [weakSelf.dataArray replaceObjectAtIndex: section withObject:model];
                                                        
                                                        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
                                                    }
                                                } failBlock:^(NSError *error) {
                                                    
                                                }];
    }else{
        [self setLoginVC];
    }
}




#pragma mark - 删除评论
- (void)deleteCommentWithCommentId:(NSString*)commentId  section:(NSInteger)section{
    if (isEmpty(commentId)) {
        return;
    }
    WeakSelf;
    [[VideoServiceMediator sharedInstance] deleteVideoCommentInfo:commentId completion:^(FWServiceResponse *response) {
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            [weakSelf.dataArray enumerateObjectsUsingBlock:^(NewCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj.commentId isEqualToString:commentId]) {
                    [weakSelf.dataArray removeObjectAtIndex:idx];
                    [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:UITableViewRowAnimationFade];
                    *stop = YES;
                    self.commentCount = [NSString stringWithFormat:@"%d",[self.commentCount intValue] -1] ;

                    self.commentCountChangeBlock ? self.commentCountChangeBlock(self.commentCount) :nil;
                }
            }];
        }
    } failBlock:^(NSError *error) {
        
    }];
}





/********************** 浏览图片 *********************/
//- (void)setPhotoBrowserWithUrl:(NSString *)url {
//
//    if (isEmpty(url)) {
//        return;
//    }
//    [HKPhotoBrowserTool initPhotoBrowserWithUrl:url];
//}


#pragma mark  XLPhotoBrowserDatasource
- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return imageName(HK_Placeholder);
}


- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex {
    switch (actionSheetindex) {
        case 0:
        {
            // 保存图片
            [browser saveCurrentShowImage];
        }
            break;
        default:
            break;
    }
}

@end


