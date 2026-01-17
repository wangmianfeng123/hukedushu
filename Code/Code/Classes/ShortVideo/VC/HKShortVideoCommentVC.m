//
//  HKShortVideoCommentVC.m
//  Code
//
//  Created by hanchuangkeji on 2019/5/10.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKShortVideoCommentVC.h"
#import "HKShortVideoCommentModel.h"
#import "HKShortVideoCommentTopCell.h"
#import "HKShortVideoCommentBotMoreCell.h"
#import "HKShortVideoCommentSubCell.h"

#import "HKArticleInputTool.h"
#import "HKArticleModel.h"
#import "UIView+SNFoundation.h"


@interface HKShortVideoCommentVC () <UITableViewDelegate, UITableViewDataSource, HKArticleInputToolDelegate>

@property (nonatomic, strong)NSMutableArray<HKShortVideoCommentModel *> *dataArray;

@property (nonatomic, assign)int page;

@property (nonatomic, weak)UITableView *tableView;

/** 底部输入框 */
@property(nonatomic, strong)HKArticleInputTool *intputTool;

@end

@implementation HKShortVideoCommentVC

- (NSMutableArray<HKShortVideoCommentModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    // 加载第一页数据2
    [self loadNewData];
    
    self.emptyText = @"快来抢占沙发啦~";
}



#pragma 空视图
- (UIImage *)tb_emptyImage:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    return imageName(@"short_video_sofa");
}

- (CGPoint)tb_emptyViewOffset:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    return CGPointMake(0, 20);
}


- (void)setupUI {
    
    // 毛玻璃
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *beffectView = [[UIVisualEffectView alloc]initWithEffect:beffect];
    [self.view addSubview:beffectView];
    
    // 顶部退出按钮
    UIView *topExistView = [[UIView alloc] init];
    topExistView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topExistView];
    CGFloat topVIewHeight = 40.0;
    [topExistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(self.view.height * 0.5 - 20);
        make.left.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(self.view.width, topVIewHeight));
    }];
    
    [beffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topExistView.mas_top);
        make.bottom.left.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view.width);
    }];
    
    // 空白点击视图退出
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(beffectView.mas_top);
    }];
    [whiteView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitBtnClick)]];
    
    UILabel *commentLB = [[UILabel alloc] init]; // 中间的评论
    commentLB.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightBold];
    commentLB.text = @"评论";
    commentLB.textColor = [UIColor whiteColor];
    [topExistView addSubview:commentLB];
    [commentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(topExistView);
    }];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setImage:imageName(@"short_video_exit_btn") forState:UIControlStateNormal];
    [topExistView addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(topVIewHeight, topVIewHeight));
        make.right.mas_equalTo(topExistView);
        make.top.mas_equalTo(0);
    }];
    [exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *separator = [[UIView alloc] init]; // 分割线
    separator.backgroundColor = HKColorFromHex(0xD8D8D8, 0.1);
    [topExistView addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(topExistView);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(topExistView);
    }];
    
    // 底部的评论
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor clearColor];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(IS_IPHONE_X? -20.0 : 0.0);
        make.size.mas_equalTo(CGSizeMake(self.view.width, 55.0));
    }];
    
    UILabel *tipLB = [[UILabel alloc] init];
    [bottomView addSubview:tipLB];
    tipLB.clipsToBounds = YES;
    tipLB.layer.cornerRadius = 55 * 0.5 * 0.5;
    [tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(12.0, 15.0, 12.0, 15.0));
    }];
    tipLB.text = @"    用你的freestyle评论几句吧~";
    tipLB.font = [UIFont systemFontOfSize:14.0];
    tipLB.textColor = HKColorFromHex(0xA8ABBE, 1.0);
    tipLB.backgroundColor = HKColorFromHex(0x434343, 1.0);
    UITapGestureRecognizer *commentBottomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentBottomViewTap:)];
    tipLB.userInteractionEnabled = YES;
    [tipLB addGestureRecognizer:commentBottomTap];
    
    // 中部的tableView
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topExistView.mas_bottom);
        make.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(bottomView.mas_top);
        make.width.mas_equalTo(self.view.width);
    }];
    self.tableView = tableView;
    [tableView registerClass:[HKShortVideoCommentTopCell class] forCellReuseIdentifier:NSStringFromClass([HKShortVideoCommentTopCell class])];
    [tableView registerClass:[HKShortVideoCommentSubCell class] forCellReuseIdentifier:NSStringFromClass([HKShortVideoCommentSubCell class])];
   [tableView registerClass:[HKShortVideoCommentBotMoreCell class] forCellReuseIdentifier:NSStringFromClass([HKShortVideoCommentBotMoreCell class])];
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 100;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 刷新控件
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tableView.mj_header = header;
    
    MJRefreshFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
}

- (HKArticleInputTool *)intputTool {
    if (_intputTool == nil) {
        HKArticleInputTool *intputTool = [[HKArticleInputTool alloc] init];
        [self.view addSubview:intputTool];
        intputTool.delegate = self;
        self.intputTool = intputTool;
        intputTool.isShortVideoComment = YES;
        intputTool.x = 0;
        intputTool.bottom = UIScreenHeight;
        intputTool.articleModel = nil;
        intputTool.hidden = YES;
    }
    return _intputTool;
}

- (void)commentBottomViewTap:(HKShortVideoCommentModel *)model {
    NSLog(@"%s", __func__);
    
    if ([model isKindOfClass:[HKShortVideoCommentModel class]]) {
        self.intputTool.commentModel = model;
        self.intputTool.placeholder = [NSString stringWithFormat:@"回复 %@", model.commentUser.username];
    }
    self.intputTool.hidden = NO;
    [self.intputTool.textView becomeFirstResponder];
}


- (void)exitBtnClick {
    [self.view removeFromSuperview];
}


#pragma mark <Server>

/**
 提交评论
 
 @param video_id  video_id 视频id
 @param parent_id  父级评论id 为0回复为顶级评论
 @param tid  老师id
 @param content  回复内容
 */
- (void)postCommment:(NSString *)video_id parent_id:(NSString *)parent_id tid:(NSString *)tid content:(NSString *)content {
    
    // 没有登录
    if (![HKAccountTool shareAccount]) {
        [self setLoginVC];
        return;
    }
    
#warning 放开手机检测
    [self checkBindPhone:^{
    
        // 需要绑定手机
        NSDictionary *param = @{@"video_id" : video_id, @"parent_id" : parent_id, @"tid" : tid, @"content" : content};
        
        [HKHttpTool POST:@"short-video-comment/reply" parameters:param success:^(id responseObject) {
            NSLog(@"%@", responseObject);
            if (HKReponseOK) {
                
                [[HKALIYunLogManage sharedInstance]shortVideoClickLogWithIdentify:@"5"];
                
                showTipDialog(@"评论成功");
                
                HKShortVideoCommentModel *commentModel = [HKShortVideoCommentModel mj_objectWithKeyValues:responseObject[@"data"]];
                [self findSuperCommentModelAndInsert:parent_id model:commentModel];
            } else {
                showTipDialog(@"评论失败，请重试或者联系客服");
            }
            
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
        
    } bindPhone:nil];
}

- (void)findSuperCommentModelAndInsert:(NSString *)parentId model:(HKShortVideoCommentModel *)model {
    
    if (!model) return;
    
    if (model.root_id.intValue == 0) {
        // 顶层的评论
        [self.dataArray insertObject:model atIndex:0];
    } else {
        
        HKShortVideoCommentModel *targetModel = nil;
        
        for (HKShortVideoCommentModel *superModel in self.dataArray) {
            
            if ([parentId isEqualToString:superModel.ID]) {
                
                targetModel = superModel;
                break;
            }
            
            for (HKShortVideoCommentModel *subModel in superModel.comment) {
                if ([parentId isEqualToString:subModel.ID]) {
                    targetModel = superModel;
                    break;
                }
            }
        }
        
        // 自评论少于2个，直接插入
        model.isNewComment = YES;
        targetModel.comment = targetModel.comment == nil? [NSMutableArray array]: targetModel.comment; // 防止为空
        [targetModel.comment insertObject:model atIndex:targetModel.comment.count];
        targetModel.sub_count = [NSString stringWithFormat:@"%d", targetModel.sub_count.intValue + 1];
        [targetModel.newComment addObject:model]; // 自己最新的子评论
            [self.tableView reloadData];
    }
    
    // 刷新外部的评论数量
    self.shortVideoModel.commentCount = [NSString stringWithFormat:@"%d", self.shortVideoModel.commentCount.intValue + 1];
    !self.shortVideoCommentAddOne? : self.shortVideoCommentAddOne();
}


- (void)loadNewData {
    
    self.page = 1;
    self.tableView.mj_footer.hidden = YES;
    NSDictionary *param = @{@"video_id" : self.shortVideoModel.video_id.length? self.shortVideoModel.video_id : self.video_id, @"page" : @(self.page)};
    
    [HKHttpTool POST:@"short-video-comment/list" parameters:param success:^(id responseObject) {
        
        if (HKReponseOK) {
            self.dataArray = [HKShortVideoCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lists"]];
            NSString *pageCount = responseObject[@"data"][@"pageCount"];
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            if (self.page >= pageCount.intValue) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


- (void)loadMoreData {
    
    self.page++;
    NSDictionary *param = @{@"video_id" : self.shortVideoModel.video_id.length? self.shortVideoModel.video_id : self.video_id, @"page" : @(self.page)};
    
    [HKHttpTool POST:@"short-video-comment/list" parameters:param success:^(id responseObject) {
        
        if (HKReponseOK) {
            NSMutableArray *array = [HKShortVideoCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lists"]];
            NSString *pageCount = responseObject[@"data"][@"pageCount"];
            
            !array.count? : [self.dataArray addObjectsFromArray:array];
            
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            if (self.page >= pageCount.intValue) {
                self.tableView.mj_footer.hidden = YES;
            } else {
                self.tableView.mj_footer.hidden = NO;
            }
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreSubCommentData:(HKShortVideoCommentModel *)model cell:(HKShortVideoCommentBotMoreCell *)cell {
    
    model.subPage = model.subPage == 0 ? 1 : model.subPage + 1; // 防止从0开始
    NSDictionary *param = @{@"root_id" : model.ID, @"page" : @(model.subPage)};
    
    [HKHttpTool POST:@"short-video-comment/child-list" parameters:param success:^(id responseObject) {
        
        if (HKReponseOK) {
            NSMutableArray *array = [HKShortVideoCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lists"]];
            
            // 移除自己最新的自评论
            NSMutableArray *arrayTemp = [NSMutableArray array];
            for (HKShortVideoCommentModel *tempModel in array) {
                for (HKShortVideoCommentModel *newCommentModel in model.newComment) {
                    if ([tempModel.ID isEqualToString:newCommentModel.ID]) {
                        [arrayTemp addObject:tempModel];
                    }
                }
            }
            [array removeObjectsInArray:arrayTemp];
            
            // 插入
            NSInteger section = 0;
            for (int i = 0; i < self.dataArray.count; i++) {
                if (self.dataArray[i] == model) {
                    section = i;
                    break;
                }
            }
            
            NSMutableArray<NSIndexPath *> *indexPathArray = [NSMutableArray array];
            for (int i = 1; i <= array.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:model.comment.count + i inSection:section];
                [indexPathArray addObject:indexPath];
            }
            
            !array.count? : [model.comment addObjectsFromArray:array];
            
            [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            
            // 更新model
            cell.model = model;
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark --<UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HKShortVideoCommentModel *model = self.dataArray[section];
    if (model.sub_count.intValue > 3 && model.sub_count.intValue - 3 > model.newComment.count) {
        return model.comment.count + 1 + 1; // 底部的cell加载更多
    } else {
        return model.comment.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 顶级的评论model
    HKShortVideoCommentModel *model = self.dataArray[indexPath.section];
    WeakSelf;
    if (indexPath.row == 0) { // 第一个为顶级评论
        
        HKShortVideoCommentTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKShortVideoCommentTopCell class])];
        cell.model = model;
        cell.userTapActionBlock = ^(HKShortVideoCommentModel *modelTemp) {
            
            !weakSelf.userTapActionBlock? : weakSelf.userTapActionBlock(modelTemp);
        };
        return cell;
    } else if (model.comment.count + 1 + 1 == indexPath.row + 1) { // 底部加载更多
        HKShortVideoCommentBotMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKShortVideoCommentBotMoreCell class])];
        cell.model = model;
        // 点击加载更多
        __weak typeof (cell) weakCell = cell;
        cell.loadMoreBlock = ^(BOOL isExpand, HKShortVideoCommentModel * _Nonnull model) {
            
            // 展开的
            if (isExpand) {
                [weakSelf loadMoreSubCommentData:model cell:weakCell];
            } else {
                [weakSelf removeSubCommentCell:model cell:weakCell];
            }
        };
        return cell;
    } else { // 其他为子评论
        HKShortVideoCommentModel *submodel = model.comment[indexPath.row - 1];
        HKShortVideoCommentSubCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKShortVideoCommentSubCell class])];
        cell.model = submodel;
        cell.isLastCell = [tableView numberOfRowsInSection:indexPath.section] == indexPath.row + 1; // 最后一个cell 用于优化分割线
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKShortVideoCommentModel *model = self.dataArray[indexPath.section]; // 顶级评论
    
    // 加载更多的点击
    if (model.comment.count + 1 + 1 <= indexPath.row + 1) {
        return;
    }
    model = indexPath.row == 0? model : model.comment[indexPath.row - 1];
    [self commentBottomViewTap:model];
    
}

- (void)removeSubCommentCell:(HKShortVideoCommentModel *)model cell:(HKShortVideoCommentBotMoreCell *)cell {
    
    // 收起的
    NSInteger section = 0;
    for (int i = 0; self.dataArray.count; i++) {
        if (self.dataArray[i] == model) {
            section = i;
            break;
        }
    }
    
    NSMutableArray<NSIndexPath *> *removeIndexPathArray = [NSMutableArray array];
    NSMutableArray<HKShortVideoCommentModel *> *removeIndexModelArray = [NSMutableArray array];
    
    for (int i = 0; i < model.comment.count; i++) {
        if (model.comment[i].isNewComment || i < 3) {
            continue;
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i + 1 inSection:section];
            [removeIndexPathArray addObject:indexPath];
            [removeIndexModelArray addObject:model.comment[i]];
        }
    }
    [model.comment removeObjectsInArray:removeIndexModelArray];
    
    [self.tableView deleteRowsAtIndexPaths:removeIndexPathArray withRowAnimation:UITableViewRowAnimationNone];
    
    // 子页码清空
    model.subPage = 0;
    cell.model = model;
    
    // reload section最后一行
//    NSInteger totalRow = [self.tableView numberOfRowsInSection:section];
//    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:totalRow - 1 inSection:section];
//    [self.tableView reloadRowsAtIndexPaths:@[lastIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark <HKArticleInputToolDelegate>
- (void)sendComment:(NSString *)comment tool:(HKArticleInputTool *)tool commentId:(NSString *)commentId section:(NSInteger)section taskModel:(HKArticleModel *)articleModel {
    
    if (isLogin()) {
        
    }else{
        [self setLoginVC];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark <HKArticleInputToolDelegate>
- (void)textView:(UITextView *)textView isFirstResponder:(BOOL)isFirstResponder {
    if (!isFirstResponder) {
        [self.intputTool removeFromSuperview];
        self.intputTool = nil;
    }
}

- (void)sendShortVideoComment:(HKShortVideoCommentModel *)model tool:(HKArticleInputTool *)tool comment:(NSString *)comment{
    
    if (!comment.length) return;
    
    if (model == nil) {
        // 顶级评论
        [self postCommment:self.shortVideoModel.video_id parent_id:@"0" tid:self.shortVideoModel.tid content:comment];
    } else {
        // 子级评论
        [self postCommment:self.shortVideoModel.video_id parent_id:model.ID tid:self.shortVideoModel.tid content:comment];
    }
}

- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}

@end
