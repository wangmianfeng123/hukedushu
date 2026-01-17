//
//  HKMessageSubVC.m
//  Code
//
//  Created by Ivan li on 2021/1/27.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKMessageSubVC.h"
#import "HKNotiTabModel.h"
#import "HKNotesThumbsCell.h"
#import "HKTeacherCourseVC.h"
#import "HKUserInfoVC.h"
#import "ACActionSheet.h"
#import "HKSystemNoticeCell.h"
#import "HtmlShowVC.h"

@interface HKMessageSubVC ()<UITableViewDataSource,UITableViewDelegate,HKNotesThumbsCellDelegate>
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , assign) int page ;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, copy)NSString * latestId;  //
@end

@implementation HKMessageSubVC

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = COLOR_F8F9FA_3D4752;
    [self.view addSubview:self.tableView];
    @weakify(self);
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        @strongify(self);
        [self loadNewListData];
    }];

    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        @strongify(self);
        [self loadListData];
    }];
    [self loadNewListData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.tabModel.ID intValue] == 1) {
        [MobClick event: personalcenter_news_comment];
    }else if ([self.tabModel.ID intValue] == 2){
        [MobClick event: personalcenter_news_like];
    }
}

- (void)loadNewListData{
    self.latestId = @"0";
    self.page = 1;
    [self loadListData];
}

- (void)loadListData{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.latestId forKey:@"latestId"];
    [dic setObject:self.tabModel.ID forKey:@"type"];
    [dic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    
    @weakify(self);
    [HKHttpTool POST:@"/notice/list" parameters:dic success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            NSArray * resultArray = nil;
            if ([self.tabModel.ID intValue] == 0) {
                resultArray =[HKSystemNotiMsgModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            }else{
                resultArray = [HKNotiMessageModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            }
            
            HKPageInfoModel *pageModel = [HKPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            NSString *latestId = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"latestId"]];
            if (latestId.length) {
                self.latestId = latestId;
            }

            if (resultArray.count) {
                if (pageModel.current_page >= self.page) {
                    if (self.page == 1) {
                        [self.dataArray removeAllObjects];
                    }
                    [self.dataArray addObjectsFromArray:resultArray];
                    if (pageModel.current_page >= pageModel.page_total) {
                        [self tableFooterEndRefreshing];
                    }else{
                        [self tableFooterStopRefreshing];
                    }
                    self.page ++ ;
                    [self.tableView.mj_header endRefreshing];
                }
            }else{
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            }
        }else{
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)tableFooterEndRefreshing {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    self.tableView.mj_footer.hidden = YES;
}

- (void)tableFooterStopRefreshing {
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_footer.hidden = NO;
}

- (UITableView*)tableView {
    if (!_tableView) {//138 * Ratio + KNavBarHeight64
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, SCREEN_HEIGHT-KNavBarHeight64) style:UITableViewStylePlain];
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
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, KTabBarHeight49, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = YES;
        _tableView.tb_EmptyDelegate = self;
        
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

//        _tableView.rowHeight = 80;
        
        // 防止 reloadsection UI 错乱
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        //[_tableView setContentInset:UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0)];
        //任务项cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKNotesThumbsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKNotesThumbsCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKSystemNoticeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKSystemNoticeCell class])];
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tabModel.ID intValue] == 0) {
        return UITableViewAutomaticDimension;
    }else{
        return 80;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tabModel.ID intValue] == 0) {
        HKSystemNoticeCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKSystemNoticeCell class])];
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }else{
        HKNotiMessageModel * model = self.dataArray[indexPath.row];
        HKNotesThumbsCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKNotesThumbsCell class])];
        cell.tabID = self.tabModel.ID;
        cell.messageModel = model;
        cell.delegate = self;
        @weakify(self);
        cell.didAvatorBlock = ^{
            if (!model.uid.length) return;
            [HKHttpTool POST:@"/user/home-header" parameters:@{@"uid":model.connectUser.uid} success:^(id responseObject) {
                @strongify(self);
                if ([CommonFunction detalResponse:responseObject]) {
                    BOOL isTeacher = [responseObject[@"data"][@"teacher"] boolValue];
                    if (isTeacher) {
                        int teacher_id = [responseObject[@"data"][@"user"][@"teacherId"] intValue];
                        HKTeacherCourseVC *vc = [[HKTeacherCourseVC alloc] init];
                        vc.teacher_id = [NSString stringWithFormat:@"%d",teacher_id];
                        [self pushToOtherController:vc];
                    }else{
                        HKUserInfoVC *vc = [[HKUserInfoVC alloc] init];
                        vc.userId = model.connectUser.uid;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
            } failure:^(NSError *error) {
                
            }];
        };
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
//    if ([self.tabModel.ID intValue] == 1) { //回复
//        [HKH5PushToNative runtimePush:model.connect.redirectPackage.class_name arr:model.connect.redirectPackage.list currectVC:nil];
//
//    }else if ([self.tabModel.ID intValue] == 2){
        
//    }
    
    if ([self.tabModel.ID intValue] == 0) {
        HKSystemNotiMsgModel * model = self.dataArray[indexPath.row];
        //跳转M站
        if (model.url.length) {
            HtmlShowVC * vc = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:model.url];
            [self pushToOtherController:vc];
            [MobClick event: community_content_works];
        }
    }else{
        HKNotiMessageModel * model = self.dataArray[indexPath.row];
        [HKH5PushToNative runtimePush:model.original.redirectPackage.class_name arr:model.original.redirectPackage.list currectVC:nil];
    }
        
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count ? 1 : 0;
}


#pragma mark ======= HKNotesThumbsCellDelegate
-(void)myNotesThumbsCellModel:(HKNotiMessageModel *)messageModel{
    if (isLogin()){
        WeakSelf;
        if (messageModel.connectUser.isSubscribed) {
            
            NSArray *titleArr =  @[@"不再关注",@"取消"];
            
            ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:nil cancelTitleColor:nil destructiveButtonTitle:nil otherButtonTitles:titleArr buttonTitleColors:nil actionSheetBlock:^(NSInteger buttonIndex) {
                
                if (0 == buttonIndex) {
                    [weakSelf loadAttentionData:messageModel];
                }else{
                    //取消
                }
            }];
            [actionSheet show];
        }else{
            [MobClick event: personalcenter_message_interact_follow];
            [self loadAttentionData:messageModel];
        }
    } else{
        [self setLoginVC];
    }
}

- (void)loadAttentionData:(HKNotiMessageModel *)messageModel{
    if (isLogin()){
        WeakSelf;
        [HKHttpTool POST:@"/switch/subscribe" parameters:@{@"uid":messageModel.connectUser.uid} success:^(id responseObject) {
            if ([CommonFunction detalResponse:responseObject]) {
                if (!messageModel.connectUser.isSubscribed) {
                    showTipDialog(@"关注成功");
                }
                for (HKNotiMessageModel * model in self.dataArray) {
                    if ([model.connectUser.uid isEqualToString:messageModel.connectUser.uid]) {
                        model.connectUser.isSubscribed = !model.connectUser.isSubscribed;
                    }
                }
                
                [weakSelf.tableView reloadData];
            }
        } failure:^(NSError *error) {
            
        }];
    } else{
        [self setLoginVC];
    }
}

-(void)dealloc{
    HK_NOTIFICATION_REMOVE();
}
@end
