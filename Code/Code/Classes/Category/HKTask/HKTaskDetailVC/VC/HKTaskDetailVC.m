//
//  HKTaskDetailVC.m
//  Code
//
//  Created by Ivan li on 2018/7/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTaskDetailVC.h"
#import "HKTaskModel.h"
#import "HKUserInfoVC.h"
#import "HKTaskDetailHeadCell.h"
#import "HKTaskTeacCommentCell.h"
#import "HKTaskDetailCommentCell.h"
#import "HKTaskDetailUserCommentCell.h"
#import "HKTaskDetailUserCommentFootView.h"
#import "HKTaskDetailUserCommentHeadView.h"
#import "HKInputView.h"
#import "HKTaskTextView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "UMpopView.h"
#import "XLPhotoBrowser.h"
#import "HKTaskPraiseCell.h"
#import "FeedbackVC.h"
#import "HKInputTool.h"
#import "UIView+SNFoundation.h"

@interface HKTaskDetailVC ()<UITableViewDelegate,UITableViewDataSource,HKTaskDetailHeadCellDelegate,HKTaskTeacCommentCellDelegate,HKInputViewDelagete,
HKTaskTextViewDelegate,HKTaskDetailUserCommentFootViewDelegate,UMpopViewDelegate,HKTaskDetailCommentCellDelegate,HKTaskPraiseCellDelegate,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource,HKInputToolDelegate>

@property(nonatomic,strong)UITableView    *tableView;

@property(nonatomic,strong)HKTaskDetailModel *detailM;
/** 底部评价工具栏 */
@property(nonatomic,strong)HKTaskTextView *taskTextView;

@property(nonatomic,strong)NSMutableDictionary *heightAtIndexPath;//缓存高度
/**  选中图片的Cell */
@property(nonatomic,strong)id selectCell;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)NSInteger picCount;

@property(nonatomic,strong)HKInputTool *intputTool;

@end


@implementation HKTaskDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}


- (void)createUI {
    [self createLeftBarButton];
    [self createShareButtonItem];
    
    self.view.backgroundColor = COLOR_F8F9FA;
    [self.view addSubview:self.tableView];
    [self refreshUI];
}


#pragma mark - 滚动到相应的位置
- (void)scrollToRow {
    
    if (self.picCount == 2) {
        if (self.row >0 && self.row <=4 ) {
            NSInteger section = 0;
            switch (self.row) {
                case 1:
                    section = 1;
                    break;
                case 2:
                    section = 3;
                    break;
                case 3:
                    section = 4;
                    break;
                case 4:
                    section = 3;
                    break;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
                [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            });
        }
    }
}



#pragma mark - 底部评价工具栏
- (void)setUpCommentTool {

    [self.view addSubview:self.intputTool];
    self.intputTool.x = 0;
    self.intputTool.bottom = SCREEN_HEIGHT;
    self.intputTool.model = self.detailM;
}


- (HKInputTool *)intputTool {
    if (!_intputTool) {
        _intputTool = [[HKInputTool alloc]init];
        _intputTool.delegate = self;
    }
    return _intputTool;
}


#pragma mark - intputTool delegate
- (void)sendComment:(NSString*)comment tool:(HKInputTool*)tool commentId:(NSString*)commentId
            section:(NSInteger)section taskModel:(HKTaskModel *)taskModel {
    
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    if (!isEmpty(comment)) {
        [self submitComment:comment commentId:commentId section:section taskModel:taskModel];
    }
}


- (void)inputToolBeginEdit {
    if (!isLogin()) {
        [self.intputTool.textView resignFirstResponder];
        [self setLoginVC];
        return;
    }
}



- (void)shareBtnItemAction {
    [self shareWithUI:self.detailM.share_data];
}


/** 友盟分享 */
- (void)shareWithUI:(ShareModel*)model {
    
    UMpopView *popView = [UMpopView sharedInstance];
    [popView createUIWithModel:model];
    popView.delegate = self;
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


- (void)uMShareImageFail:(id)sender {
    
}



- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        
        [_tableView registerClass:[HKTaskDetailHeadCell class] forCellReuseIdentifier:@"HKTaskDetailHeadCell"];
        [_tableView registerClass:[HKTaskDetailUserCommentFootView class] forHeaderFooterViewReuseIdentifier:@"HKTaskDetailUserCommentFootView"];
        [_tableView registerClass:[HKTaskDetailUserCommentHeadView class] forHeaderFooterViewReuseIdentifier:@"HKTaskDetailUserCommentHeadView"];
        
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //ios 11
        HKAdjustsScrollViewInsetNever(self, _tableView)
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
    }
    return _tableView;
}


#pragma mark - Getters
- (NSMutableDictionary *)heightAtIndexPath {
    if (!_heightAtIndexPath) {
        _heightAtIndexPath = [NSMutableDictionary dictionary];
    }
    return _heightAtIndexPath;
}


- (HKTaskDetailModel*)detailM {
    if (!_detailM) {
        _detailM = [HKTaskDetailModel new];
    }
    return _detailM;
}



#pragma mark - 刷新
- (void)refreshUI {
    
    self.page = 1;
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        strongSelf.page = 1;
        [strongSelf getTaskDataWithPage:strongSelf.page];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf
        [strongSelf getTaskDataWithPage:strongSelf.page];
    }];
    [self getTaskDataWithPage:self.page];
}


- (void)tableHeaderEndRefreshing {
    [_tableView.mj_header endRefreshing];
}

- (void)tableFooterEndRefreshing {
    [_tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)tableFooterStopRefreshing {
    [_tableView.mj_footer endRefreshing];
}



- (void)getTaskList:(NSInteger)sort page:(NSInteger)page {
    //sort 排序：1-最新 2-最热    page
    WeakSelf;
    NSDictionary *dict = @{@"sort":@(sort),@"page":@(page)};
    [HKHttpTool POST:TASK_INDEX parameters:dict success:^(id responseObject) {
        StrongSelf;
        [strongSelf tableHeaderEndRefreshing];
        if (HKReponseOK) {
            NSString *totalPage = responseObject[@"data"][@"total_page"];
            
            if ([totalPage intValue] == strongSelf.page){
                [strongSelf tableFooterEndRefreshing];
            }else{
                [strongSelf tableFooterStopRefreshing];
            }
        } else {
            [strongSelf tableFooterStopRefreshing];
        }
        [strongSelf.tableView reloadData];
    } failure:^(NSError *error) {
        StrongSelf;
        [strongSelf tableHeaderEndRefreshing];
        [strongSelf tableFooterStopRefreshing];
    }];
}



- (void)getTaskDataWithPage:(NSInteger)page {
    WeakSelf;
    NSDictionary *dict = @{@"task_id":self.model.task_id,@"page":@(page)};
    [HKHttpTool POST:TASK_DETAIl parameters:dict success:^(id responseObject) {
        
        StrongSelf;
        [strongSelf tableHeaderEndRefreshing];
        if (HKReponseOK) {
            HKTaskDetailModel *detailM = [HKTaskDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            if (1 == page){
                strongSelf.detailM = detailM;
                [strongSelf setUpCommentTool];
                strongSelf.title = detailM.title;
            }else{
                [strongSelf.detailM.comment_list addObjectsFromArray:detailM.comment_list];
            }
            
            if (strongSelf.detailM.total_page <= page){
                [strongSelf tableFooterEndRefreshing];
            }else{
                strongSelf.page++;
                [strongSelf tableFooterStopRefreshing];
            }
            [strongSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        StrongSelf;
        [strongSelf tableHeaderEndRefreshing];
        [strongSelf tableFooterStopRefreshing];
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (isEmpty(self.detailM.uid)) {
        return 0;
    }
    NSInteger count = self.detailM.comment_list.count;
    return  count ? 3 + count: 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = 1;
            break;
        case 1:
            count = 1;
            break;
        case 2:
            count = 1;
            break;
        default:
            count += self.detailM.comment_list[section -3].reply_list.count+1;
            break;
    }
    return count;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    //    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    //    if(height){
    //        return height.floatValue;
    //    }else{
    //        return 150;
    //    }
    return 150;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    CGFloat height = 0;
    switch (section) {
        case 0: case 1:case 2:
            height = 0.005;
            break;
        default:
            height = 40;
            break;
    }
    return height;
}


- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section >2) {
        
        NSLog(@"section --- %ld",section);
        HKTaskDetailUserCommentFootView *footerView = (HKTaskDetailUserCommentFootView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HKTaskDetailUserCommentFootView"];
        footerView.delegate = self;
        HKTaskModel *model = self.detailM.comment_list[section - 3];
        model.secton = section;
        footerView.model = model;
        footerView.section = section;
        return footerView;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (3 == section) {
        return PADDING_30;
    }
    return 0.005;
}



- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (3 == section) {
        UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HKTaskDetailUserCommentHeadView"];
        return header;
    }
    return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        HKTaskDetailHeadCell *cell = [HKTaskDetailHeadCell initCellWithTableView:tableView];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = self.detailM;
        return cell;
    }else if (1 == indexPath.section) {
        HKTaskTeacCommentCell *cell = [HKTaskTeacCommentCell initCellWithTableView:tableView];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = self.detailM;
        return cell;
        
    }else if (2 == indexPath.section) {
        HKTaskPraiseCell *cell = [HKTaskPraiseCell initCellWithTableView:tableView];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = self.detailM;
        return cell;
    }else {
        if (0 == indexPath.row) {
            HKTaskDetailCommentCell *cell = [HKTaskDetailCommentCell initCellWithTableView:tableView model:self.detailM.comment_list[indexPath.section - 3]];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.model = self.detailM.comment_list[indexPath.section - 3];
            return cell;
        }else{
            HKTaskDetailUserCommentCell *cell = [HKTaskDetailUserCommentCell initCellWithTableView:tableView row:indexPath.row-1];
            cell.commentM = self.detailM.comment_list[indexPath.section - 3].reply_list[indexPath.row -1];
            return cell;
        }
    }
}


//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    NSNumber *height = @(cell.frame.size.height);
//    [self.heightAtIndexPath setObject:height forKey:indexPath];
//}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark HKTaskDetailHeadCellDelegate delegate

- (void)userInfoClick:(HKTaskModel*)model indexPath:(NSIndexPath *)indexPath {
    
    HKUserInfoVC *vc = [HKUserInfoVC new]; vc.userId = model.uid;
    [self pushToOtherController:vc];
}


- (void)didClickPraiseBtnInCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if (isLogin()) {
        
    }else{
        [self setLoginVC];
    }
}


/** 封面点击 */
- (void)didClickDetailHeadImageInCell:(HKTaskDetailHeadCell*)cell indexPath:(NSIndexPath *)indexPath {
    
    self.selectCell = cell;
    if ([self.intputTool.textView isFirstResponder]) {
        [self.intputTool.textView resignFirstResponder];
    }else{
        [self setPhotoBrowser];
    }
}


- (void)reloadTaskDetailHeadCell:(HKTaskDetailModel *)model indexPath:(NSIndexPath *)indexPath {
    self.detailM = model;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    self.picCount ++;
    [self scrollToRow];
}


#pragma mark - HKTaskTeacCommentCellDelegate
- (void)reloadTaskTeacCommentCell:(HKTaskDetailModel*)model indexPath:(NSIndexPath *)indexPath {
    self.detailM = model;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    self.picCount ++;
    [self scrollToRow];
}


/** 封面点击 */
- (void)didClickTeacCoverImageInCell:(HKTaskTeacCommentCell*)cell indexPath:(NSIndexPath *)indexPath {
    
    self.selectCell = cell;
    if ([self.intputTool.textView isFirstResponder]) {
        [self.intputTool.textView resignFirstResponder];
    }else{
        [self setPhotoBrowser];
    }
}


#pragma mark - HKTaskDetailCommentCellDelegate
- (void)commentUserInfoClick:(HKTaskModel*)model indexPath:(NSIndexPath *)indexPath {
    if (isLogin()) {
        HKUserInfoVC *vc = [HKUserInfoVC new]; vc.userId = model.uid;
        [self pushToOtherController:vc];
    }else{
        [self setLoginVC];
    }
}



- (void)didClickDetailCommentImageInCell:(HKTaskDetailCommentCell*)cell indexPath:(NSIndexPath *)indexPath {
    self.selectCell = cell;
    if ([self.intputTool.textView isFirstResponder]) {
        [self.intputTool.textView resignFirstResponder];
    }else{
        [self setPhotoBrowser];
    }
}


#pragma mark    HKTaskDetailUserCommentFootViewDelegate
- (void)commentAction:(NSInteger)section model:(HKTaskModel*)model {
    if (isLogin()) {
        NSString *temp = [NSString stringWithFormat:@"回复%@:",model.username];
        [self.intputTool showInputTool:temp commentId:model.comment_id section:section taskModel:model];
        
    }else{
        [self setLoginVC];
    }
}


/**举报*/
- (void)complainAction:(NSInteger)section model:(HKTaskModel*)model sender:(id)sender {
    if (isLogin()) {
        FeedbackVC *VC = [FeedbackVC new]; VC.commentId = model.comment_id;
        [self pushToOtherController:VC];
    }else{
        [self setLoginVC];
    }
}


#pragma mark  HKTaskPraiseCellDelegate
- (void)hkTaskPraiseAction:(HKTaskDetailModel *)model cell:(HKTaskPraiseCell *)cell indexPath:(NSIndexPath *)indexPath{
    if (isLogin()) {
        [self praiseWithTaskM:self.detailM cell:cell indexPath:indexPath];
    }else{
        [self setLoginVC];
    }
}


#pragma mark 评论工具栏
- (HKTaskTextView*)taskTextView {
    if (!_taskTextView) {
        _taskTextView = [[HKTaskTextView alloc]init];
        _taskTextView.delegate = self;
    }
    return _taskTextView;
}


#pragma mark HKTaskTextViewDelegate
- (void)didClick:(id)sender {
    //[self showInputView:nil placeholder:self.detailM.comment_default section:0];
}




- (void)submitComment:(NSString*)content commentId:(NSString*)commentId section:(NSInteger)section  taskModel:(HKTaskModel *)taskModel{
    
    //task_id 作品ID     comment_id 评论ID，回复评论时带上，不带上表示只是评论
    NSString *taskid = self.model.task_id;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:taskid forKey:@"task_id"];
    [dict setValue:content forKey:@"content"];
    if (!isEmpty(commentId)) {
        [dict setValue:commentId forKey:@"comment_id"];
    }
    
    [HKHttpTool POST:TASK_CREATE_COMMENT parameters:dict success:^(id responseObject) {
        
        if (HKReponseOK) {
            HKTaskModel *model = [HKTaskModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (isEmpty(commentId)) {
                //评论作品
                [self.detailM.comment_list insertObject:model atIndex:0];
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
                if (self.detailM.comment_list.count>=2) {
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }else{
                /** 通过数组 index 确定 section*/
                __block NSInteger index = 0;
                [self.detailM.comment_list indexOfObjectWithOptions:NSEnumerationReverse passingTest:^BOOL(HKTaskModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     if ([obj.comment_id isEqualToString:taskModel.comment_id]) {
                         index = idx;
                         return YES;
                     }
                     return NO;
                }];
                [self.detailM.comment_list replaceObjectAtIndex:index withObject:model];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index+3] withRowAnimation:UITableViewRowAnimationNone];
                
                //回复评论
                //[self.detailM.comment_list replaceObjectAtIndex:section-3 withObject:model];
                //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
                //[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
            }
            showTipDialog(responseObject[@"msg"]);
        }
    } failure:^(NSError *error) {
        
    }];
}



#pragma mark - 创建图片浏览器
- (void)setPhotoBrowser {
    
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:1 imageCount:1 datasource:self];
    browser.pageDotColor = [UIColor grayColor];
    browser.currentPageDotColor = [UIColor whiteColor];
    //修改底部pagecontrol的样式为系统样式,默认是弹性动画的样式
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleAnimated;
    // 设置长按手势弹出的地步ActionSheet数据,不实现此方法则没有长按手势
    [browser setActionSheetWithTitle:nil delegate:self cancelButtonTitle:nil deleteButtonTitle:nil otherButtonTitles:@"保存图片",nil];
}


#pragma mark  XLPhotoBrowserDatasource
- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return imageName(HK_Placeholder);
}


/**  返回指定位置图片的UIImageView,用于做图片浏览器弹出放大和消失回缩动画等 */
- (UIView *)photoBrowser:(XLPhotoBrowser *)browser sourceImageViewForIndex:(NSInteger)index {
    if ([self.selectCell isKindOfClass:[HKTaskTeacCommentCell class]]) {
        HKTaskTeacCommentCell *cell = (HKTaskTeacCommentCell*)self.selectCell;
        return cell.teacCommentIV;
    }else if ([self.selectCell isKindOfClass:[HKTaskDetailHeadCell class]]) {
        HKTaskDetailHeadCell *cell = (HKTaskDetailHeadCell*)self.selectCell;
        return cell.coverImageView;
    }else if ([self.selectCell isKindOfClass:[HKTaskDetailCommentCell class]]) {
        HKTaskDetailCommentCell *cell = (HKTaskDetailCommentCell*)self.selectCell;
        return cell.coverImageView;
    }
    return nil;
}


/**返回指定位置的高清图片URL */
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    NSString *picUrl = nil;
    if ([self.selectCell isKindOfClass:[HKTaskTeacCommentCell class]]) {
        HKTaskTeacCommentCell *cell = (HKTaskTeacCommentCell*)self.selectCell;
        picUrl = cell.model.modify_picture_url;
        
    }else if ([self.selectCell isKindOfClass:[HKTaskDetailHeadCell class]]) {
        HKTaskDetailHeadCell *cell = (HKTaskDetailHeadCell*)self.selectCell;
        picUrl = cell.model.picture;
    }else if ([self.selectCell isKindOfClass:[HKTaskDetailCommentCell class]]) {
        HKTaskDetailCommentCell *cell = (HKTaskDetailCommentCell*)self.selectCell;
        picUrl = cell.model.picture_url;
    }
    return HKURL(picUrl);
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


/** 点赞 */
- (void)praiseWithTaskM:(HKTaskDetailModel*)taskM cell:(HKTaskPraiseCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    [HKHttpTool POST:TASK_LIKE_TASK parameters:@{@"task_id":self.model.task_id} success:^(id responseObject) {
        if (HKReponseOK) {
            showTipDialog(responseObject[@"msg"]);
            taskM.is_like = !taskM.is_like;
            NSInteger count = (taskM.is_like ? 1:-1 )+taskM.thumbs;
            
            taskM.thumbs = count ?count :0;
            cell.model = taskM;
        }
    } failure:^(NSError *error) {
        
    }];
}


@end

