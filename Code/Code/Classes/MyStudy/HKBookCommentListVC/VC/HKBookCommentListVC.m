//
//  HKBookCommentListVC.m
//  Code
//
//  Created by Ivan li on 2019/8/21.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookCommentListVC.h"
#import "HKArticleInputTool.h"
#import "HKArticleModel.h"
#import "UIView+SNFoundation.h"
#import "HKShortVideoModel.h"

#import "HKBookCommentTopCell.h"
#import "HKBookCommentChildrenCell.h"
#import "HKBookCommentMoreCell.h"
#import "HKBookCommentModel.h"
#import "HKJobPathModel.h"
#import <IGListKit/IGListKit.h>
#import "HKBookCommentSectionController.h"
#import "HKBookCommentTopCell.h"
#import "HKBookCommentChildrenCell.h"
#import "HKBookCommentMoreCell.h"
#import "HKBookCommentModel.h"
#import "HKBookCommentActionCell.h"
#import "HKBookEvaluationVC.h"
#import "FeedbackVC.h"
#import "HKUserInfoVC.h"
#import "HKBookEvaluationView.h"
#import "HKBookModel.h"
#import "XLPhotoBrowser.h"


@interface HKBookCommentListVC () <HKArticleInputToolDelegate,IGListAdapterDataSource,HKBookCommentSectionControllerDelegate,HKBookEvaluationViewDelegate>

@property (nonatomic, strong)NSMutableArray<HKBookCommentModel *> *dataArray;

@property (nonatomic, assign)int page;

@property (nonatomic, strong)UICollectionView *collectionView;
/** 底部输入框 */
@property (nonatomic, strong)HKArticleInputTool *intputTool;

@property(nonatomic,strong) IGListAdapter *adapter;

@property(nonatomic,strong) NSMutableArray *objects;

@property (nonatomic, strong)HKBookEvaluationView *evaluationView;

@end

@implementation HKBookCommentListVC

- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}



- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    self.emptyText = @"快来抢占沙发啦~";
}


- (void)setupUI {
    self.title = @"评论";
    [self createLeftBarButton];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.evaluationView];
    
    [self refreshUI];
    self.adapter = [[IGListAdapter alloc] initWithUpdater:[IGListAdapterUpdater new] viewController:self];
    self.adapter.dataSource = self;
    self.adapter.collectionView = self.collectionView;
}


- (HKBookEvaluationView*)evaluationView {
    if (!_evaluationView) {
        CGFloat height = IS_IPHONE_X ?65: 50;
        _evaluationView =  [[HKBookEvaluationView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT- height, SCREEN_WIDTH, height)];
        _evaluationView.delegate = self;
        _evaluationView.bookModel = self.bookModel;
        _evaluationView.evaluationViewType = HKBookEvaluationViewType_commentList;
    }
    return _evaluationView;
}

#pragma mark --- ListeningEvaluationViewDelegate
// 评价按钮点击
- (void)bookEvaluationView:(HKBookEvaluationView*)view commentLB:(nonnull UILabel *)commentLB {
    
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    
    @weakify(self);
    [self checkBindPhone:^{
        @strongify(self);
        HKBookEvaluationVC *VC = [HKBookEvaluationVC new];
        VC.model = view.bookModel;
        [self pushToOtherController:VC];
    } bindPhone:^{
        
    }];
}



#pragma mark - 刷新
- (void)refreshUI {
    
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.collectionView completion:^{
        StrongSelf;
        strongSelf.page = 1;
        [strongSelf loadNewData];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.collectionView completion:^{
        StrongSelf;
        [strongSelf loadMoreData];
    }];
    [self.collectionView.mj_header beginRefreshing];
    //self.collectionView.mj_footer.hidden = NO;
    self.collectionView.mj_footer.automaticallyHidden = YES;
    self.collectionView.mj_footer.automaticallyChangeAlpha = NO;
}


- (void)tableHeaderEndRefreshing {
    [self.collectionView.mj_header endRefreshing];
}


- (void)tableFooterEndRefreshing {
    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
}


- (void)tableFooterStopRefreshing {
    [self.collectionView.mj_footer endRefreshing];
}


- (UICollectionView*)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        HKAdjustsScrollViewInsetNever(self, _collectionView);
        _collectionView.contentInset = UIEdgeInsetsMake(KNavBarHeight64+10, 0, KTabBarHeight49, 0);
    }
    return _collectionView;
}


- (NSMutableArray<HKBookCommentModel *> *)dataArray {
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



- (HKArticleInputTool *)intputTool {
    if (nil == _intputTool) {
        _intputTool = [[HKArticleInputTool alloc] init];
        _intputTool.delegate = self;
        _intputTool.x = 0;
        _intputTool.bottom = SCREEN_HEIGHT;
        _intputTool.articleModel = nil;
        _intputTool.isShortVideoComment = YES;
        _intputTool.hidden = YES;
        [self.view addSubview:_intputTool];
    }
    return _intputTool;
}

#pragma mark <HKArticleInputToolDelegate>
- (void)sendHKBookComment:(HKBookCommentModel *)model tool:(HKArticleInputTool *)tool comment:(NSString *)comment {
    if (isLogin()) {
        WeakSelf;
        [self checkBindPhone:^{
            StrongSelf;
            [strongSelf addHKBookComment:model mainCommentModel:tool.mainCommentModel content:comment isMainComment:tool.isMainComment];
        } bindPhone:^{
            
        }];
        
    }else{
        [self setLoginVC];
    }
}


#pragma mark <HKArticleInputToolDelegate>
- (void)textView:(UITextView *)textView isFirstResponder:(BOOL)isFirstResponder {
    
    self.intputTool.hidden = !isFirstResponder;
}



#pragma mark - model(子评论)  mainCommentModel (父评论)
- (void)showInputToolWithModel:(HKBookCommentModel *)model mainCommentModel:(HKBookCommentModel*)mainCommentModel isMainComment:(BOOL)isMainComment {
    
    if ([model isKindOfClass:[HKBookCommentModel class]]) {
        self.intputTool.bookCommentModel = model;
        self.intputTool.mainCommentModel = mainCommentModel;
        self.intputTool.isMainComment = isMainComment;
        self.intputTool.placeholder = [NSString stringWithFormat:@"回复 %@", model.username];
    }
    [self.intputTool.textView becomeFirstResponder];
    [UIView animateWithDuration:0.35 animations:^{
        self.intputTool.hidden = NO;
    }];
}



#pragma mark --- IGListAdapterDataSource
- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.objects;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    HKBookCommentSectionController <HKBookCommentModel *>*sectionController = [HKBookCommentSectionController <HKBookCommentModel *> new];
    sectionController.delegate = self;
    return sectionController;
}


- (NSMutableArray *)objects {
    if (!_objects) {
        _objects = [NSMutableArray array];
    }
    return _objects;
}





#pragma mark <Server>
- (void)loadNewData {
    if (isEmpty(self.self.bookId)) {
        return;
    }
    NSDictionary *param = @{@"book_id" : self.bookId, @"page" : @(self.page)};
    
    [HKHttpTool POST:BOOK_COMMENT_FETCH parameters:param success:^(id responseObject) {
        
        [self tableHeaderEndRefreshing];
        if (HKReponseOK) {
            self.dataArray = [HKBookCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            self.objects = self.dataArray;
            [self editDataArray];
            [self.adapter reloadDataWithCompletion:^(BOOL finished) {
                
            }];
            
            HKJobPathPageInfoModel *pageModel = [HKJobPathPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (self.page >= pageModel.page_total) {
                [self tableFooterEndRefreshing];
            }else{
                [self tableFooterStopRefreshing];
            }
            self.page ++;
        }
        
    } failure:^(NSError *error) {
        [self tableHeaderEndRefreshing];
        [self tableFooterStopRefreshing];
    }];
}



- (void)loadMoreData {
    
    NSDictionary *param = @{@"book_id" : self.bookId, @"page" : @(self.page)};
    [HKHttpTool POST:BOOK_COMMENT_FETCH parameters:param success:^(id responseObject) {
        
        [self tableFooterStopRefreshing];
        if (HKReponseOK) {
            NSMutableArray *array = [HKBookCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            [self.dataArray addObjectsFromArray:array];
            
            [self editDataArray];
            [self.adapter reloadDataWithCompletion:^(BOOL finished) {
                
            }];
            HKJobPathPageInfoModel *pageModel = [HKJobPathPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (self.page >= pageModel.page_total) {
                [self tableFooterEndRefreshing];
            }
            self.page++;
        }
    } failure:^(NSError *error) {
        [self tableHeaderEndRefreshing];
        [self tableFooterStopRefreshing];
    }];
}



- (void)editDataArray {
    __block NSInteger count = self.dataArray.count;
    [self.dataArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(HKBookCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (count == idx +1) {
            obj.isHiddenBottomLine = YES;
        }else{
            obj.isHiddenBottomLine = NO;
        }
    }];
}




#pragma mark -- HKBookCommentSectionController
//评论
- (void)bookCommentSectionController:(HKBookCommentSectionController*)sectionController bookCommentTopCell:(HKBookCommentTopCell*)cell headViewCommentAction:(NSInteger)section model:(HKBookCommentModel*)model {
    
    if (isLogin()) {
        [self showInputToolWithModel:model mainCommentModel:model isMainComment:YES];
    }else{
        [self setLoginVC];
    }
    //[self.objects addObject:model];
    //[self.adapter performUpdatesAnimated:YES completion:nil];
}


//头像
- (void)bookCommentSectionController:(HKBookCommentSectionController*)sectionController bookCommentTopCell:(HKBookCommentTopCell*)cell headViewuserImageViewClick:(NSInteger)section model:(HKBookCommentModel*)model {
    
    HKUserInfoVC *vc = [HKUserInfoVC new];
    vc.userId = model.uid;
    [self pushToOtherController:vc];
}


//评论图片
- (void)bookCommentSectionController:(HKBookCommentSectionController*)sectionController bookCommentTopCell:(HKBookCommentTopCell*)cell headViewCommentImageViewClick:(NSInteger)section model:(HKBookCommentModel*)model {
    
    [self setPhotoBrowserWithUrl:model.image_url];
}


#pragma mark - HKBookCommentActionCell
///  评价
- (void)bookCommentSectionController:(HKBookCommentSectionController*)sectionController hkBookCommentActionCell:(HKBookCommentActionCell*)cell  commentBtn:(UIButton*)btn {
    if (isLogin()) {
        [self showInputToolWithModel:cell.model mainCommentModel:cell.model isMainComment:YES];
    }else{
        [self setLoginVC];
    }
}


///  举报
- (void)bookCommentSectionController:(HKBookCommentSectionController*)sectionController hkBookCommentActionCell:(HKBookCommentActionCell*)cell  complainAction:(UIButton*)btn {
    
    if (isLogin()) {
        FeedbackVC *VC = [FeedbackVC new];
        VC.commentId = cell.model.comment_id;
        [self pushToOtherController:VC];
    }else{
        [self setLoginVC];
    }
}


///  删除
- (void)bookCommentSectionController:(HKBookCommentSectionController*)sectionController hkBookCommentActionCell:(HKBookCommentActionCell*)cell  deleteAction:(UIButton*)btn {
    if (isLogin()) {
        [self deleteHKBookComment:cell.model];
    }else{
        [self setLoginVC];
    }
}


#pragma mark --- HKBookCommentChildrenCell
- (void)bookCommentSectionController:(HKBookCommentSectionController*)sectionController bookCommentChildrenCell:(HKBookCommentChildrenCell*)cell model:(HKBookCommentModel*)model mainCommentModel:(HKBookCommentModel*)mainCommentModel {
    if (isLogin()) {
        [self showInputToolWithModel:cell.model mainCommentModel:mainCommentModel isMainComment:NO];
    }else{
        [self setLoginVC];
    }
}



/// 更新
- (void)bookCommentSectionController:(HKBookCommentSectionController*)sectionController updateCell:(HKBookCommentModel*)model {
    
    [self.adapter reloadDataWithCompletion:^(BOOL finished) {
        
    }];
//    [self.adapter performUpdatesAnimated:YES completion:^(BOOL finished) {
//
//    }];
}



#pragma mark - 删除评论
- (void)deleteHKBookComment:(HKBookCommentModel*)model {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (!isEmpty(model.reply_id)) {
        [param setValue:model.reply_id forKey:@"reply_id"];
    }
    if (!isEmpty(model.comment_id)) {
        [param setValue:model.comment_id forKey:@"comment_id"];
    }
    
    [HKHttpTool POST:BOOK_COMMENT_DELETE parameters:param success:^(id responseObject) {
        if (HKReponseOK) {
            //删除成功
            [self.dataArray enumerateObjectsUsingBlock:^(HKBookCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.comment_id isEqualToString:model.comment_id]) {
                    //index = idx;
                    [self.dataArray removeObjectAtIndex:idx];
                    *stop = YES;
                }
            }];
            //self.objects = self.dataArray;
            [self.adapter performUpdatesAnimated:YES completion:^(BOOL finished) {

            }];
        }
    } failure:^(NSError *error) {

    }];
}



#pragma mark - 评价
- (void)addHKBookComment:(HKBookCommentModel*)model mainCommentModel:(HKBookCommentModel*)mainCommentModel content:(NSString *)content isMainComment:(BOOL)isMainComment {
    
    if (isEmpty(content)) {
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (isMainComment) {
        if (!isEmpty(mainCommentModel.comment_id)) {
            // 回复主评论
            [param setValue:model.comment_id forKey:@"comment_id"];
        }
    }else{
        // 回复子评论
        if (!isEmpty(model.reply_id)) {
            [param setValue:model.reply_id forKey:@"reply_id"];
        }
        if (!isEmpty(model.comment_id)) {
            [param setValue:model.comment_id forKey:@"comment_id"];
        }
    }
    [param setValue:content forKey:@"content"];
    //[param setValue:model.content forKey:@"score"];
    
    [HKHttpTool POST:BOOK_COMMENT_CREATE parameters:param success:^(id responseObject) {
        if (HKReponseOK) {
            NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"msg"]];
            if (!isEmpty(str)) {
                showTipDialog(str);
            }
            
            __block HKBookCommentModel *commentModel = [HKBookCommentModel mj_objectWithKeyValues:responseObject[@"data"][@"replyData"]];
            [self.dataArray enumerateObjectsUsingBlock:^(HKBookCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.comment_id isEqualToString:commentModel.comment_id]) {
                    commentModel.expanded = obj.expanded;
                    [self.dataArray replaceObjectAtIndex:idx withObject:commentModel];
                    *stop = YES;
                }
            }];
            
            [self.adapter performUpdatesAnimated:YES completion:^(BOOL finished) {
                
            }];
            
            [[HKALIYunLogManage sharedInstance]hkBookClickLogWithFlag:@"7" bookId:self.bookModel.book_id courseId:self.bookModel.course_id];
        }
    } failure:^(NSError *error) {
        
    }];
}




/********************** 浏览图片 *********************/
- (void)setPhotoBrowserWithUrl:(NSString *)url {
    if (isEmpty(url)) {
        return;
    }
    [HKPhotoBrowserTool initPhotoBrowserWithUrl:url];
}


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
