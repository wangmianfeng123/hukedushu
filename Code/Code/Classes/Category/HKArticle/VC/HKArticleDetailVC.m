
//
//  HKAudioHotVC.m
//  Code
//
//  Created by Ivan li on 2018/4/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKArticleDetailVC.h"
#import "VideoModel.h"
#import "VideoPlayVC.h"
#import "FeedbackVC.h"

#import "TagModel.h"
#import "HKAudioListCell.h"

#import "UIBarButtonItem+Extension.h"
#import "HKArticleCommentModel.h"
#import "HKArticleDetailCommentCell.h"
//#import "HKArticleRelationHeaderView.h"
#import "HKArticleCell.h"
#import "HKArticleInputTool.h"
#import "UIView+SNFoundation.h"
#import "HKArticleModel.h"
#import "HKArticleDetailHtmlCell.h"
#import "HKArticleCommentEmptyCell.h"
#import "DetailModel.h"
#import "HKUserModel.h"
#import "UMpopView.h"
#import "HKNavTeacherInfoBtn.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "HKTeacherCourseVC.h"
#import "HKArticleHeaderView.h"



@interface HKArticleDetailVC ()<TBSrollViewEmptyDelegate, UITableViewDelegate,UITableViewDataSource, HKArticleCommentCellDelegate, HKArticleInputToolDelegate,HKArticleDetailHtmlCellDelegate,UMpopViewDelegate>

@property(nonatomic,strong)NSMutableArray<HKArticleCommentModel *> *commentDataSource;
@property(nonatomic,strong)NSMutableArray<HKArticleModel *> *articleRelactionDataSource;

@property(nonatomic,strong)UITableView   *tableView;

@property (nonatomic, strong)HKUserModel *teacher;

@property (nonatomic, strong)UIButton *navFollowBtn;

//@property (nonatomic, strong)HKArticleRelationHeaderView *articleRelationHeaderView;

@property (nonatomic, strong)HKNavTeacherInfoBtn *navTeacherInfoBtn;

@property (nonatomic, strong)UIImageView *imageForNavTeacherInfoBtn; // 处理导航栏的图片

/** 接口数据 页码1 */
@property(nonatomic,assign)NSInteger page;

/** 评论数量 */
@property (nonatomic, copy)NSString *commentCount;

/** 点赞数量 */
@property (nonatomic, copy)NSString *likeCount;

/** 是否已经点赞数量 */
@property (nonatomic, assign)BOOL isLikeCount;

/** 评论数量UILabel */
@property (nonatomic, weak)UILabel *commentCountLB;

/** 底部输入框 */
@property(nonatomic, strong)HKArticleInputTool *intputTool;

@property(nonatomic, assign)CGFloat htmlCellHeigth;

@property(nonatomic, copy)NSString *comments_page; // 评论页数

@property(nonatomic, weak)HKArticleDetailHtmlCell *htmlCell;

@end


@implementation HKArticleDetailVC



- (void)dealloc {
    [HKWebTool clearnWebCache];
    if (self.htmlCell) {
        [self.htmlCell removeBriderHandler];
    }
    HK_NOTIFICATION_REMOVE();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showActivityMessageInWindow:@"加载中.."];
    self.hk_hideNavBarShadowImage = YES;
    [self creatUI];
    [self refreshUI];
    [self showOrHideLoadingView:YES];
    //登录成功通知
    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, loginSuccessNotification);
}

- (void)loginSuccessNotification {
    [self loadNewData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.htmlCell) {
        [self.htmlCell removeBriderHandler];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUD];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.htmlCell) {
        [self.htmlCell brideRegisterNativeMethod];
    }
}



/**
 加载等待view
 */
- (void)showOrHideLoadingView:(BOOL)isShow {

}

- (void)setBottomInputView {
    HKArticleInputTool *intputTool = [[HKArticleInputTool alloc] init];
    
    UIView *tagView = [self.view viewWithTag:333];
    if (tagView) {
        [self.view insertSubview:intputTool belowSubview:tagView];
    } else {
        [self.view addSubview:intputTool];
    }
    
    intputTool.delegate = self;
    self.intputTool = intputTool;
    intputTool.x = 0;
    intputTool.bottom = SCREEN_HEIGHT;
    intputTool.articleModel = self.model;
}



- (void)creatUI {
    [self createLeftBarButton];
    [self.view addSubview:self.tableView];
    [self createShareButtonItem];
}

- (void)createLeftBarButton {
    
    
    UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"nac_back") darkImage:imageName(@"nac_back_dark")];
    UIBarButtonItem *itme1 = [UIBarButtonItem BarButtonItemWithBackgroudImage:image highBackgroudImage:image target:self action:@selector(backAction)];
    
    HKNavTeacherInfoBtn *navTeacherInfoBtn = [HKNavTeacherInfoBtn buttonWithType:UIButtonTypeCustom];
    self.navTeacherInfoBtn = navTeacherInfoBtn;
    navTeacherInfoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [navTeacherInfoBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
    navTeacherInfoBtn.size = CGSizeMake(IS_IPHONEMORE4_7INCH? 120 : 100, 35);
    [navTeacherInfoBtn addTarget:self action:@selector(goToTeacherVC) forControlEvents:UIControlEventTouchUpInside];
    navTeacherInfoBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    UIBarButtonItem *itme2 = [[UIBarButtonItem alloc] initWithCustomView:navTeacherInfoBtn];
    self.navigationItem.leftBarButtonItems = @[itme1, itme2];
}

- (void)goToTeacherVC {
    
    [self pushToTeacherCourseVC];
}



/** 创建分享的 BarButtonItem */
- (void)createShareButtonItem {
    
    UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"share_black") darkImage:imageName(@"share_black_dark")];
    UIBarButtonItem *itme1  = [UIBarButtonItem BarButtonItemWithImage:image highImage:image target:self action:@selector(shareBtnItemAction) size:CGSizeMake(40, 40)];
    
    UIButton *navFollowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navFollowBtn = navFollowBtn;
    [navFollowBtn setBackgroundImage:imageName(@"aticle_follow_yellow") forState:UIControlStateNormal];
    [navFollowBtn setBackgroundImage:imageName(@"aticle_follow_gray") forState:UIControlStateSelected];
    [navFollowBtn setTitle:@"关注" forState:UIControlStateNormal];
    [navFollowBtn setTitle:@"已关注" forState:UIControlStateSelected];
    navFollowBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    navFollowBtn.size = CGSizeMake(IS_IPHONEMORE4_7INCH? 60 : 57, IS_IPHONEMORE4_7INCH? 30 : 27);
    [navFollowBtn addTarget:self action:@selector(navFollowBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [navFollowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navFollowBtn setTitleColor:HKColorFromHex(0x7B8196, 1.0) forState:UIControlStateSelected];
    UIBarButtonItem *itme2 = [[UIBarButtonItem alloc] initWithCustomView:navFollowBtn];
    self.navigationItem.rightBarButtonItems = @[itme1, itme2];
}

- (void)navFollowBtnClick {
    if (isLogin()) {
        [self followTeacher];
    }else{
        [self setLoginVC];
    }
}


/**
 右上角分享按钮
 */
- (void)shareBtnItemAction {
    [self shareWithUI:self.teacher.share_data];
}

/** 友盟分享 */
- (void)shareWithUI:(ShareModel *)model {
    UMpopView *popView = [UMpopView sharedInstance];
    popView.delegate = self;
    [popView createUIWithModel:model];
}




#pragma mark - UMpopView 代理
- (void)uMShareWebSucess:(id)sender {
    if ([sender isKindOfClass:[ShareModel class]]) {
        ShareModel *model = (ShareModel*)sender;
        [self shareSucessWithModel:model];
    }
}


- (void)uMShareImageSucess:(id)sender {
    if ([sender isKindOfClass:[ShareModel class]]) {
        ShareModel *model = (ShareModel*)sender;
        [self shareSucessWithModel:model];
    }
}

- (void)uMShareImageFail:(id)sender {
    
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





- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        _tableView.sectionHeaderHeight = 0.005;
        _tableView.sectionFooterHeight = 0.005;
        //_tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49 - 10, 0);
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, 50, 0);
        [_tableView setScrollIndicatorInsets:_tableView.contentInset];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKArticleDetailCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKArticleDetailCommentCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKArticleCommentEmptyCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKArticleCommentEmptyCell class])];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKArticleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKArticleCell class])];
        [_tableView registerClass:[HKArticleDetailHtmlCell class] forCellReuseIdentifier:NSStringFromClass([HKArticleDetailHtmlCell class])];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKArticleHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([HKArticleHeaderView class])];
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.tb_EmptyDelegate = self;
    }
    return _tableView;
}

#pragma mark <UITablViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 没获取数据
    if (!self.model.h5_url.length) return 0;
    
    if (section == 0) {
        // 网页
        return 1;
    } else if (section == 1) {
        
        // 相关文章
        return self.articleRelactionDataSource.count;
    } else if (section == 2) {
        
        // 评论
        return self.commentDataSource.count? self.commentDataSource.count : 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return self.htmlCellHeigth <= 0? SCREEN_HEIGHT * 2 : self.htmlCellHeigth;
        //        return 0.0;
    } else if (indexPath.section == 1) {
        return 112.0;
    } else if (indexPath.section == 2) {
        return self.commentDataSource.count? self.commentDataSource[indexPath.row].cellHeight : 210; // 210为空视图，缺省图
    }
    return 0.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    WeakSelf;
    
    if (indexPath.section == 0) {
        
        HKArticleDetailHtmlCell *pgcCellTemp = [tableView cellForRowAtIndexPath:indexPath];
        if (pgcCellTemp) {
            return pgcCellTemp;
        }
        
        HKArticleDetailHtmlCell *pgcCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKArticleDetailHtmlCell class])];
        pgcCell.delegate = self;
        pgcCell.detailModel = self.model;
        pgcCell.htmlHeightBlock = ^(float height) {
            if(height > 0){
                // 移除遮罩层
                [weakSelf showOrHideLoadingView:NO];
                weakSelf.htmlCellHeigth = height;
                [weakSelf.tableView reloadData];
            }
        };
        self.htmlCell = pgcCell;
        cell = pgcCell;
        
    } else if (indexPath.section == 1) {
        
        HKArticleCell *cellTemp = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKArticleCell class])];
        cellTemp.model = self.articleRelactionDataSource[indexPath.row];
        cell = cellTemp;
    } else if (indexPath.section == 2) {
        
        if (self.commentDataSource.count) {
            HKArticleDetailCommentCell *cellTemp = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKArticleDetailCommentCell class])];
            cellTemp.delegate = self;
            cellTemp.model = self.commentDataSource[[indexPath row]];
            cell = cellTemp;
        } else {
            
            // 空视图，缺省页
            HKArticleCommentEmptyCell *cellTemp = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKArticleCommentEmptyCell class])];
            cell = cellTemp;
        }
    }
    return cell;
}


- (UIView *)setSectionHeaderView {
    UIView *myHeaderView = [[UIView alloc] init];
    myHeaderView.backgroundColor = COLOR_FFFFFF_3D4752;
    myHeaderView.height = 60.0;
    UILabel *commentCountLB = [[UILabel alloc] init];
    commentCountLB.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
    commentCountLB.textColor = COLOR_27323F_EFEFF6;
    commentCountLB.text = (!self.commentCount || self.commentCount.intValue == 0)? @"暂无评论" : [NSString stringWithFormat:@"%@条评论", self.commentCount];
    commentCountLB.frame = CGRectMake(15, 23, SCREEN_WIDTH - 15, commentCountLB.font.lineHeight + 0.5);
    [myHeaderView addSubview:commentCountLB];
    self.commentCountLB = commentCountLB;
    return myHeaderView;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        WeakSelf;
        // 相关文章
//        HKArticleRelationHeaderView *headerView = [HKArticleRelationHeaderView viewFromXib];
//        headerView.likeBtnClickBlock = ^(UIButton *button) {
//
//            if (isLogin()) {
//                [weakSelf likeToServer:weakSelf.model];
//            }else {
//                [weakSelf setLoginVC];
//            }
//        };
//        [headerView setLikeBtn:self.model.appreciate_num isLike:self.model.is_appreciate];
//        self.articleRelationHeaderView = headerView;
        
        
        HKArticleHeaderView *headerView = (HKArticleHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([HKArticleHeaderView class])];
        headerView.likeBtnClickBlock = ^(UIButton *button) {
            
            if (isLogin()) {
                [weakSelf likeToServer:weakSelf.model];
            }else {
                [weakSelf setLoginVC];
            }
        };
        [headerView setLikeBtn:self.model.appreciate_num isLike:self.model.is_appreciate];

        return headerView;
    }else if (section == 2) {
        
        // 23条评论
        return [self setSectionHeaderView];
    } else {
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 393 * 0.5;
    } else if (section == 2) {
        return 60.0;
    } else {
        return 0.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    // 样式问题
    if (section == 1) {
        return 20;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    // 样式问题
    if (section == 1) {
        UIView *myView = [[UIView alloc] init];
        myView.backgroundColor = COLOR_FFFFFF_3D4752;
        myView.height = 20.0;
        return myView;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 输入框
    if ([self.intputTool.textView isFirstResponder]) {
        [self.intputTool.textView resignFirstResponder];
    }
    
    // 相关文章
    if (indexPath.section == 1) {
        HKArticleDetailVC *vc = [[HKArticleDetailVC alloc] init];
        vc.model = self.articleRelactionDataSource[indexPath.row];
        [self pushToOtherController:vc];
    }
    
    [self performSelector:@selector(deleselect) withObject:nil afterDelay:0.4f];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 输入框
    if ([self.intputTool.textView isFirstResponder]) {
        [self.intputTool.textView resignFirstResponder];
    }
    
    // 判断webView所在的cell是否可见，如果可见就layout
    NSArray *cells = self.tableView.visibleCells;
    for (UITableViewCell *cell in cells) {
        if ([cell isKindOfClass:[HKArticleDetailHtmlCell class]]) {
            HKArticleDetailHtmlCell *webCell = (HKArticleDetailHtmlCell *)cell;
            [webCell.webView setNeedsLayout];
        }
    }
    
    // 滑动隐藏导航栏关注按钮
    if (scrollView.contentOffset.y >= KNavBarHeight64 && self.navFollowBtn.hidden) {
        self.navFollowBtn.hidden = NO;
        self.navTeacherInfoBtn.hidden = NO;
    } else if (scrollView.contentOffset.y < KNavBarHeight64 && !self.navFollowBtn.hidden) {
        self.navFollowBtn.hidden = YES;
        self.navTeacherInfoBtn.hidden = YES;
    }
}


- (void) deleselect {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}



#pragma mark - 刷新
- (void)refreshUI {
    
    MJRefreshHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    
    MJRefreshFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    
    [self.tableView.mj_header beginRefreshing];
}




#pragma mark <HKArticleInputToolDelegate>

- (void)sendComment:(NSString *)comment tool:(HKArticleInputTool *)tool commentId:(NSString *)commentId section:(NSInteger)section taskModel:(HKArticleModel *)articleModel {
    
    if (isLogin()) {
        [self commentToServer:articleModel text:comment];
    }else{
        [self setLoginVC];
    }
    
}

- (void)likeBtnClick:(UIButton *)button model:(HKArticleModel *)model {
    if (isLogin()) {
        [self likeToServer:model];
    }else{
        [self setLoginVC];
    }
}

- (void)collectBtnClick:(UIButton *)button model:(HKArticleModel *)model {
    if (isLogin()) {
        [self collectToServer:model];
    }else{
        [self setLoginVC];
    }
}


#pragma mark <HKArticleCommentCellDelegate>
- (void)complainAction:(NSInteger)section model:(HKArticleCommentModel *)model sender:(id)sender {
    
    if (isLogin()) {
        FeedbackVC *VC = [FeedbackVC new]; VC.commentId = model.ID.length? model.ID : model.comment_id;
        [self pushToOtherController:VC];
    }else{
        [self setLoginVC];
    }
}

- (void)deleteCommentAction:(NSInteger)section model:(HKArticleCommentModel *)model {
    
    if (isLogin()) {
        [self deleteMyComment:model];
    }else{
        [self setLoginVC];
    }
    
}



#pragma mark <HKArticleDetailHtmlCellDelegate>

- (void)followTeacherAction:(HKArticleDetailHtmlCell*)cell model:(HKArticleModel*)model  adsModel:(HomeAdvertModel *)adsModel {
    self.htmlCell = cell;
    if (isLogin()) {
        [self followTeacher];
    }else{
        [self setLoginVC];
    }
}


- (void)teacherIconClick:(HKArticleModel*)model {
    [self pushToTeacherCourseVC];
}



- (void)pushToTeacherCourseVC {
    
    NSString *teacherId = self.teacher.ID;
    if (isEmpty(teacherId)) {
        return;
    }
    HKTeacherCourseVC *vc = [[HKTeacherCourseVC alloc] init];
    vc.teacher_id = teacherId;
    vc.followBlock = ^(BOOL is_follow, NSString *teacher_id) {
        
    };
    [self pushToOtherController:vc];
}






#pragma mark <Server>

- (void)followTeacher {
    
    if (isEmpty(self.teacher.ID)) {
        return;
    }
    [HKHttpTool POST:@"teacher/follow-teacher" parameters:@{@"teacher_id" : self.teacher.ID, @"type" : @(self.teacher.is_subscription)} success:^(id responseObject) {
        
        if (HKReponseOK) {
            self.teacher.is_subscription = !self.teacher.is_subscription;
            self.navFollowBtn.selected = self.teacher.is_subscription;
            if (self.teacher.is_subscription) {
                showTipDialog(@"关注成功");
//                showTipDialog(@"已收藏在【学习-收藏教程】里");
            } else {
                showTipDialog(@"取消关注");
            }
            if (self.htmlCell) {
                [self.htmlCell callJsToObjc:self.teacher.is_subscription];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)collectToServer:(HKArticleModel *)model {
    [HKHttpTool POST:@"article/hl-collect" parameters:@{@"art_id" : model.ID, @"is_collect" : @(model.is_collect)} success:^(id responseObject) {
        
        if (HKReponseOK) {
            
            model.is_collect = !model.is_collect;
            
            if (model.is_collect) {
                showTipDialog(@"已收藏在【学习-收藏教程】里");
            } else {
                showTipDialog(@"取消收藏");
            }
            
            // 刷新收藏样式
            self.intputTool.articleModel = model;
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)likeToServer:(HKArticleModel *)model {
    [HKHttpTool POST:@"article/hl-like" parameters:@{@"art_id" : model.ID, @"is_appreciate" : @(model.is_appreciate)} success:^(id responseObject) {
        
        if (HKReponseOK) {
            
            model.is_appreciate = !model.is_appreciate;
            
            if (model.is_appreciate) {
                showTipDialog(@"点赞成功");
                model.appreciate_num = [NSString stringWithFormat:@"%d", model.appreciate_num.intValue + 1];
            } else {
                model.appreciate_num = [NSString stringWithFormat:@"%d", model.appreciate_num.intValue - 1];
                showTipDialog(@"取消点赞");
            }
            // 刷新点赞样式
            self.intputTool.articleModel = model;
            
//            [self.articleRelationHeaderView setLikeBtn:model.appreciate_num isLike:model.is_appreciate];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)commentToServer:(HKArticleModel *)model text:(NSString *)content {
    
    if (!content.length) return;
    
    WeakSelf;
    [self checkBindPhone:^{
        StrongSelf;
        [strongSelf postCommentWithModel:model text:content];
    } bindPhone:^{
        
    }];
}


#pragma mark - 发送评论
- (void)postCommentWithModel:(HKArticleModel *)model text:(NSString *)content {
    
    [HKHttpTool POST:@"article/add-comment" parameters:@{@"art_id" : model.ID, @"content" : content} success:^(id responseObject) {
        if (HKReponseOK) {
            showTipDialog(@"评论成功");
            // 重新刷新数据
            [self loadNewData];
        }
    } failure:^(NSError *error) {
        
    }];
}



- (void)deleteMyComment:(HKArticleCommentModel *)model {
    
    NSDictionary *param = @{@"comment_id" : model.comment_id, @"article_id" : self.model.ID};
    
    [HKHttpTool POST:@"article/delete-comment" parameters:param success:^(id responseObject) {
        
        if (HKReponseOK) {
            showTipDialog(@"删除成功");
            
            self.commentCount = [NSString stringWithFormat:@"%d", self.commentCount.intValue - 1];
            self.commentCountLB.text = (self.commentCount.length && self.commentCount.intValue > 0)? [NSString stringWithFormat:@"%@条评论", self.commentCount] : @"暂无评论";
            
            // 移除model
            [self.commentDataSource removeObject:model];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)loadNewData {
    
    self.comments_page = @"1";
    self.tableView.mj_footer.hidden = NO;
    
    NSString *articleId = self.articleId.length? self.articleId : self.model.ID;
    if (!articleId.length) {
        showTipDialog(@"文章ID为空，无法观看，请联系客服");
        return;
    }
    
    [HKHttpTool POST:@"article/detail-info" parameters:@{@"id" : articleId, @"comments_page" : self.comments_page} success:^(id responseObject) {
        
        if (!HKReponseOK) return;
        
        // 接口有问题，防止接口数据不正常
        if (![responseObject[@"data"] isKindOfClass:[NSDictionary class]]) return;
        
         // 教师信息与分享信息
        self.teacher = [HKUserModel mj_objectWithKeyValues:responseObject[@"data"][@"teacher"]];
        
        ShareModel *shareModel = [ShareModel mj_objectWithKeyValues:responseObject[@"data"][@"share_data"]];
        self.teacher.share_data = shareModel;
        
        // 头部导航栏信息
        self.navFollowBtn.selected = self.teacher.is_subscription;
        self.imageForNavTeacherInfoBtn = [[UIImageView alloc] init];
        [self.imageForNavTeacherInfoBtn sd_setImageWithURL:[NSURL URLWithString:self.teacher.avator] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            if (!error) {
                UIImage *imageTemp = [UIImage changeImageSize:image AndSize:CGSizeMake(30, 30)];
                [self.navTeacherInfoBtn setImage:imageTemp forState:UIControlStateNormal];
            } else {
                UIImage *imageTemp = [UIImage changeImageSize:imageName(HK_Placeholder) AndSize:CGSizeMake(30, 30)];
                [self.navTeacherInfoBtn setImage:imageTemp forState:UIControlStateNormal];
            }
            
            [self.navTeacherInfoBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
            self.navTeacherInfoBtn.imageView.clipsToBounds = YES;
            self.navTeacherInfoBtn.imageView.layer.cornerRadius = 15.0;
            [self.navTeacherInfoBtn setTitle:self.teacher.name.length? self.teacher.name : nil forState:UIControlStateNormal];
            [self.navTeacherInfoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, -4)];
            
        }];
        
        
        self.model = [HKArticleModel mj_objectWithKeyValues:responseObject[@"data"][@"article"]];
        NSString *h5_url = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"h5_url"]];
        self.model.h5_url = h5_url;
        
        self.comments_page = [NSString stringWithFormat:@"%d", self.comments_page.intValue + 1];
        
        // 设置底部输入框
        [self setBottomInputView];
        
        // 评论
        NSMutableArray *articleCommentModelArray = [HKArticleCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"comments"]];
        
        // 相关
        NSMutableArray *relactionModelArray = [HKArticleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"tagRecommends"]];
        self.articleRelactionDataSource = relactionModelArray;
        self.commentDataSource = articleCommentModelArray;
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
        self.commentCount = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"count"]];
        self.commentCountLB.text = (self.commentCount.length && self.commentCount.intValue > 0)? [NSString stringWithFormat:@"%@条评论", self.commentCount] : @"暂无评论";
        
        if (self.commentDataSource.count >= self.commentCount.intValue) {
            self.tableView.mj_footer.hidden = YES;
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreData {
    
    NSString *articleId = self.articleId.length? self.articleId : self.model.ID;
    if (!articleId.length) {
        showTipDialog(@"文章ID为空，无法观看，请联系客服");
        return;
    }
    
    [HKHttpTool POST:@"article/detail-info" parameters:@{@"id" : articleId, @"comments_page" : self.comments_page} success:^(id responseObject) {
        
        if (!HKReponseOK) return;
        
        self.comments_page = [NSString stringWithFormat:@"%d", self.comments_page.intValue + 1];
        
        // 评论
        NSMutableArray *articleCommentModelArray = [HKArticleCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"comments"]];
        
        self.commentCount = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"count"]];
        
        [self.commentDataSource addObjectsFromArray:articleCommentModelArray];
        [self.tableView.mj_footer endRefreshing];
        
        if (self.commentDataSource.count >= self.commentCount.intValue) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
    
}







@end



