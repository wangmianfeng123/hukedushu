//
//  SingleCommentDetailVC.m
//  Code
//
//  Created by Ivan li on 2017/10/31.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "SingleCommentDetailVC.h"
#import "NewCommentModel.h"
#import "SingleCommentCell.h"
#import "VideoServiceMediator.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "CommentHeadView.h"
#import "CommentFootView.h"
#import "ReplyCommentVC.h"
#import "FeedbackVC.h"
#import "SQActionSheetView.h"
#import "DetailModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "HKCommentModel.h"
//#import "HKMonmentTypeModel.h"
#import "HKMomentDetailModel.h"
#import "HKTeacherCourseVC.h"
#import "HKUserInfoVC.h"

@interface SingleCommentDetailVC ()<UITableViewDelegate,UITableViewDataSource,CommentFootViewDelegate,CommentHeadViewDelegate> {
    
}

@property(nonatomic,strong)UITableView        *tableView;
@property(nonatomic,copy)NSString *videoId;
@property(nonatomic,strong)NewCommentModel *commentModel;
@property(nonatomic,strong)DetailModel *detailModel;
@property(nonatomic,assign)BOOL isComment;// 标记是否能评论

@property (nonatomic , strong) HKCommentModel * mainCommentModel;
//@property (nonatomic , strong) NSMutableArray * dataArray;
@end

@implementation SingleCommentDetailVC

//-(NSMutableArray *)dataArray{
//    if (!_dataArray) {
//        _dataArray = [NSMutableArray array];
//    }
//    return _dataArray;
//}

- (instancetype)initWithModel:(NewCommentModel *)commentModel {
    if (self = [super init]) {
        //self.commentModel = commentModel;
        self.videoComment_id = commentModel.commentId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.comment_id.length) {
        [self loadMonentCommentData];
    }else{
        [self getSingleCommentInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    [self createLeftBarButton];
    self.title = @"全部评论";
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.view addSubview:self.tableView];
    
//    if (self.detailM) {
//        [self loadMonentCommentData];
//    }
}

- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        
        [_tableView registerClass:NSClassFromString(@"SingleCommentCell") forCellReuseIdentifier:@"SingleCommentCell"];
        [_tableView registerClass:NSClassFromString(@"CommentHeadView") forHeaderFooterViewReuseIdentifier:@"CommentHeadView"];
        [_tableView registerClass:NSClassFromString(@"CommentFootView") forHeaderFooterViewReuseIdentifier:@"CommentFootView"];
        _tableView.sectionHeaderHeight = 0.0001;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}



#pragma mark - 跳转 评论 视图
- (void)pushToReplyCommentVC:(NSInteger)section model:(NewCommentModel*)model {
    if (isLogin()) {
        WeakSelf;
        if (self.comment_id.length) {
            ReplyCommentVC *VC = [[ReplyCommentVC alloc]init];
            VC.mainComment = self.mainCommentModel;
            VC.connect_type = self.connect_type;
            VC.topic_id = self.topic_id;

            //VC.detailM = self.detailM;
            [self pushToOtherController:VC];
        }else{
            ReplyCommentVC *VC = [[ReplyCommentVC alloc]initWithModel:model];
            VC.section = section;
            VC.commentBlock = ^(NSString *comment, NSInteger section, NSMutableArray<CommentChildModel *> *modelArr) {
                NSInteger tempSection = section;
                if (modelArr.count) {
                    weakSelf.commentModel.children = modelArr;
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:tempSection] withRowAnimation:UITableViewRowAnimationNone];
                }
            };
            [self pushToOtherController:VC];

        }

    }else{
        [self setLoginVC];
    }
}




#pragma mark - CommentFootViewDelegate
//点赞
- (void)praiseAction:(NSInteger)section model:(NewCommentModel*)model {
    if (isLogin()) {
        [model.is_like isEqualToString:@"1"] ? nil:[self praiseWithCommentId:model.commentId section:section];
    }else{
        [self setLoginVC];
    }
}

//评论
- (void)commentAction:(NSInteger)section model:(NewCommentModel*)model {
    [self pushToReplyCommentVC:section model:model];
}
//举报
- (void)complainAction:(NSInteger)section model:(NewCommentModel*)model sender:(id)sender {
    FeedbackVC *VC = [FeedbackVC new];
    
    VC.commentId = model.commentId;
    
    
    isLogin() ? [self pushToOtherController:VC] :[self setLoginVC];
}
//headview 评论
- (void)headViewCommentAction:(NSInteger)section model:(NewCommentModel*)model {
    [self pushToReplyCommentVC:section model:model];
}

//删除评论
- (void)deleteCommentAction:(NSInteger)section model:(NewCommentModel *)model {
    isLogin() ? [self deleteCommentWithCommentId:model.commentId section:section]:[self setLoginVC];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.comment_id.length) {
        if (self.mainCommentModel) {
            return 1;
        }else{
            return 0;
        }
    }else{
        return isEmpty(self.commentModel.commentId)? 0 : 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.comment_id.length) {
        return self.mainCommentModel.subs.count;
    }else{
        return _commentModel.children.count;
    }
}
//header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.comment_id.length) {
        HKCommentModel * model = self.mainCommentModel;
        return  model.headViewHeight;
    }else{
        NewCommentModel *model = _commentModel;
        return  model.headViewHeight;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CommentHeadView *headerView = (CommentHeadView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CommentHeadView"];
    headerView.delegate = self;
    headerView.section = section;
    
    
    if (self.comment_id.length) {
        headerView.mainCommentModel = self.mainCommentModel;
    }else{
        NewCommentModel *model = _commentModel;
        headerView.videoCommentModel = model;
    }
    return headerView;
}


////点击头像
- (void)headViewuserImageViewClick:(NSInteger)section model:(NewCommentModel *)model {
    if (!model.uid.length) return;
    [self getIdentity:model.uid];
}

- (void)headViewuserImageViewCommentModel:(HKCommentModel *)model{
    if (!model.uid.length) return;
    [self getIdentity:model.uid];
}

- (void)getIdentity:(NSString *)uid{
    [HKHttpTool POST:@"/user/home-header" parameters:@{@"uid":uid} success:^(id responseObject) {
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
                vc.userId = uid;
                [self.navigationController pushViewController:vc animated:YES];

            }
        }
    } failure:^(NSError *error) {

    }];
}

//footer
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return PADDING_25*2;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CommentFootView *footerView = (CommentFootView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CommentFootView"];
    footerView.delegate = self;
    footerView.isHiddenMore = YES;
    footerView.section = section;
    footerView.isHiddenLine = YES;
    if (self.comment_id.length) {
        footerView.mainCommentModel = self.mainCommentModel;
    }else{
        NewCommentModel *model = _commentModel;
        footerView.model = model;
    }
    return footerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;

    if (self.comment_id.length) {
        HKCommentModel * model = self.mainCommentModel.subs[indexPath.row];
        CGFloat height = [tableView fd_heightForCellWithIdentifier:@"SingleCommentCell"
                                                     configuration:^(SingleCommentCell *cell) {
                                                         [weakSelf configureCell:cell atIndexPath:indexPath.row commentModel:model];
                                                     }];
        return height;
    }else{
        CommentChildModel *model = _commentModel.children[indexPath.row];
        CGFloat height = [tableView fd_heightForCellWithIdentifier:@"SingleCommentCell"
                                                     configuration:^(SingleCommentCell *cell) {
                                                         [weakSelf configureCell:cell atIndexPath:[indexPath row] model:model];
                                                     }];
        return height;
    }
    
    
}


- (CGFloat)cellContentViewWith {
    CGFloat width = SCREEN_WIDTH - (IS_IPHONE6PLUS ?110:100);
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = SCREEN_HEIGHT - (IS_IPHONE6PLUS ?110:100);
    }
    return width;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SingleCommentCell* cell = [SingleCommentCell initCellWithTableView:tableView];
    
    if (self.comment_id.length) {
        HKCommentModel * model = _mainCommentModel.subs[indexPath.row];
        [self configureCell:cell atIndexPath:indexPath.row commentModel:model];

    }else{
        CommentChildModel * model = _commentModel.children[indexPath.row];
        [self configureCell:cell atIndexPath:[indexPath row] model:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    WeakSelf;
    if (self.comment_id.length) {
        ReplyCommentVC *VC = [[ReplyCommentVC alloc]init];
        VC.mainComment = self.mainCommentModel;
        VC.replyModel = self.mainCommentModel.subs[indexPath.row];
        //VC.detailM = self.detailM;
        VC.connect_type = self.connect_type;
        VC.topic_id = self.topic_id;
        [self pushToOtherController:VC];

    }else{
        NewCommentModel *tempNewModel = _commentModel;
        //tempNewModel.children[indexPath.row].commentId = tempNewModel.commentId;// 回复评论 ID 需要导入 外层评论ID
        tempNewModel.children[indexPath.row].partentId = tempNewModel.commentId;
        ReplyCommentVC *VC = [[ReplyCommentVC alloc]initWithModel:tempNewModel.children[indexPath.row]];
        VC.indexPath = indexPath;
        VC.section = indexPath.section;
        VC.commentBlock = ^(NSString *comment, NSInteger section, NSMutableArray<CommentChildModel *> *modelArr) {
                NSInteger tempSection = section;
                if (modelArr.count) {
                    weakSelf.commentModel.children = modelArr;
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:tempSection] withRowAnimation:UITableViewRowAnimationNone];
                }
        };
        [self pushToOtherController:VC];

    }
}







#pragma mark - 计算cell的高度
- (void)configureCell:(SingleCommentCell *)cell atIndexPath:(NSInteger)indexPath  model:(CommentChildModel*)model {
    cell.fd_enforceFrameLayout = YES;
    cell.model = model;
}

#pragma mark - 计算cell的高度
- (void)configureCell:(SingleCommentCell *)cell atIndexPath:(NSInteger)indexPath  commentModel:(HKCommentModel*)model {
    cell.fd_enforceFrameLayout = YES;
    cell.monmentCommentModel = model;
}



#pragma mark - 播放后可以评价 设置评价输入框
- (void)playCommentNotification:(NSNotification *)noti {
    self.isComment = YES;
}


- (void)replyCommentSucessNotification:(NSNotification *)noti {
    //[self getVideoCommentWithToken:[CommonFunction getUserToken] videoId:self.videoId page:@"1"];
}




#pragma mark - 点赞
- (void)praiseWithCommentId:(NSString*)commentId  section:(NSInteger)section  {
    
    if (self.comment_id.length) {
        if (self.mainCommentModel.isLiked) return;
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:self.mainCommentModel.ID forKey:@"id"];
        [dic setObject:@"1" forKey:@"type"];
        [dic setObject:self.connect_type forKey:@"connectType"];
        
        WeakSelf
        [HKHttpTool POST:@"/switch/likes" parameters:dic success:^(id responseObject) {
            if ([CommonFunction detalResponse:responseObject]) {
                weakSelf.mainCommentModel.isLiked = !weakSelf.mainCommentModel.isLiked;
                weakSelf.mainCommentModel.likes_count = [NSNumber numberWithInt:[weakSelf.mainCommentModel.likes_count intValue] + 1];
                
                [weakSelf.tableView reloadData];
            }
        } failure:^(NSError *error) {
                
        }];
    }else{
        WeakSelf;
        [[VideoServiceMediator sharedInstance] VideoPraise:[CommonFunction getUserToken]
                                                 commentId:commentId
                                                completion:^(FWServiceResponse *response) {
                                                    if ([response.code isEqualToString:@"1"]) {
                                                        weakSelf.commentModel.is_like = @"1";
                                                        NSInteger count = [weakSelf.commentModel.thumbs intValue];
                                                        weakSelf.commentModel.thumbs = [NSString stringWithFormat:@"%ld",count+1];
                                                        
                                                        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
                                                        
                                                        if (weakSelf.praiseBlock) {
                                                            weakSelf.praiseBlock(section, weakSelf.commentModel);//点赞 刷新评论页点赞
                                                        }
                                                    }
                                                } failBlock:^(NSError *error) {
                                            }];
    }
}


#pragma mark - 删除评论
- (void)deleteCommentWithCommentId:(NSString*)commentId  section:(NSInteger)section{
    
    if (self.comment_id.length) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:_mainCommentModel.ID forKey:@"id"];
        [dic setObject:@"1" forKey:@"type"];
        [dic setObject:self.connect_type forKey:@"connectType"];

        [HKHttpTool POST:@"/topic/delete" parameters:dic success:^(id responseObject) {
            if ([CommonFunction detalResponse:responseObject]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {

        }];
    }else{
        WeakSelf;
        [[VideoServiceMediator sharedInstance] deleteVideoCommentInfo:commentId completion:^(FWServiceResponse *response) {
            if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
                if (weakSelf.deleteCommentBlock) {
                    weakSelf.deleteCommentBlock(section, weakSelf.commentModel);//点赞 刷新评论页点赞
                }
                [weakSelf backAction];
                showTipDialog(@"删除成功");
            }
        } failBlock:^(NSError *error) {
            
        }];
    }    
}

- (void)loadMonentCommentData{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.comment_id forKey:@"id"]; //主题ID topic.id
    [dic setObject:self.connect_type forKey:@"connectType"]; //主题类型 topic.connectType
    [HKHttpTool POST:@"/topic/fetch-replies" parameters:dic success:^(id responseObject) {
        if ([CommonFunction detalResponse:responseObject]) {
            self.mainCommentModel = [HKCommentModel mj_objectWithKeyValues:responseObject[@"data"][@"reply"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 获取单一评论内容
- (void)getSingleCommentInfo {
    
    NSString *tempId = nil;
//    if ([self.tempModel isKindOfClass:[CommentChildModel class]]) {
//        tempId = self.commentChildModel.partentId;
//    }else{
        tempId = self.commentModel.commentId;
//    }
    WeakSelf;
    [[VideoServiceMediator sharedInstance]getSingleCommentInfo:self.videoComment_id completion:^(FWServiceResponse *response) {
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
            weakSelf.commentModel = [NewCommentModel mj_objectWithKeyValues:response.data];
            
            NSMutableArray <CommentChildModel*>*array = [CommentChildModel mj_objectArrayWithKeyValuesArray:[response.data objectForKey:@"reply_list"]];
            weakSelf.commentModel.children = array;
            //!weakSelf.commentBlock? : weakSelf.commentBlock(nil,weakSelf.section,array);
            //[weakSelf backAction];
            [self.tableView reloadData];
        }
    } failBlock:^(NSError *error) {
        
    }];
}

@end
