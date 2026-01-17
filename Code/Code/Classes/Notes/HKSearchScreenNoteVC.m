//
//  HKSearchScreenNoteVC.m
//  Code
//
//  Created by Ivan li on 2020/12/30.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKSearchScreenNoteVC.h"
#import "HKSearchNoteCourseCell.h"
#import "HKNotesListModel.h"
#import "HKNotesListCell.h"
#import "VideoPlayVC.h"
#import "ACActionSheet.h"
#import "HKEditNoteVC.h"
#import "HKSearchNoteVC.h"
#import "SearchBar.h"


@interface HKSearchScreenNoteVC ()<UITableViewDataSource,UITableViewDelegate,HKNotesListCellDelegate>
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , assign) int page ;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation HKSearchScreenNoteVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = COLOR_F8F9FA_3D4752;
    //self.emptyText = @" ";
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
    
    
    //[self loadNewListData];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.emptyText = @" ";
//        [self.tableView reloadData];
//    });
}

- (void)loadNewListData{
    if (!_keyWord.length) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    self.emptyText = [NSString stringWithFormat:@"没有搜到“%@”笔记内容\n多写点笔记再来搜搜看吧",self.keyWord];
    self.page = 1;
    [self loadListData];
}

-(void)setKeyWord:(NSString *)keyWord{
    _keyWord = keyWord;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadNewListData];
    });
    
}

- (void)loadListData{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [dic setObject:self.keyWord forKey:@"keyword"];
    @weakify(self);
    [HKHttpTool POST:@"/note/search-my-note" parameters:dic success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            NSArray * resultArray = [HKNotesModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            HKPageInfoModel *pageModel = [HKPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            if (resultArray.count) {
                if (pageModel.current_page >= self.page) {
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //_tableView.rowHeight = 200;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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
        
        //[_tableView setContentInset:UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0)];
        //任务项cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKNotesListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKNotesListCell class])];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKNotesListCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKNotesListCell class])];
    cell.noteModel = self.dataArray[indexPath.row];
    cell.delegate = self;
    WeakSelf
    cell.didOpenBlock = ^{
        [weakSelf.tableView reloadData];
    };
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    HKNotesModel * model = self.dataArray[indexPath.row];
//    return model.cellHeight;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [MobClick event: notelist_search_click];
}

#pragma mark ======= HKNotesListCellDelegate
- (void)notesListCellDidTimeBtn:(HKNotesModel *)noteModel{
    [MobClick event: notelist_search_click];
    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:nil placeholderImage:nil
                                               lookStatus:LookStatusInternetVideo videoId:noteModel.video_id model:nil];
    VC.seekTime = [noteModel.seconds integerValue];
    [self pushToOtherController:VC];

}

-(void)notesListCellDidImgV:(HKNotesModel *)noteModel{
    [MobClick event: notelist_search_click];
    if (noteModel.screenshot.length) {
        [HKPhotoBrowserTool initPhotoBrowserWithUrl:noteModel.screenshot];
    }
}

-(void)notesListCellDidZanBtn:(HKNotesModel *)noteModel{
    [MobClick event: notelist_search_click];
    [HKHttpTool POST:@"/note/switch-liked" parameters:@{@"note_id":noteModel.ID} success:^(id responseObject) {
        [HKProgressHUD hideHUD];
        if ([CommonFunction detalResponse:responseObject]) {

        }else{
            int likeCount = [noteModel.likes_count intValue];
            noteModel.likes_count = [NSString stringWithFormat:@"%d",likeCount-1];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)notesListCellDidMoreBtn:(HKNotesModel *)noteModel{
    [MobClick event: notelist_search_click];
    NSArray *titleArr =  @[@"编辑笔记",@"删除笔记"];
    ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:nil cancelTitleColor:nil destructiveButtonTitle:nil otherButtonTitles:titleArr buttonTitleColors:nil actionSheetBlock:^(NSInteger buttonIndex) {
        if (0 == buttonIndex) {
           HKEditNoteVC * vc = [[HKEditNoteVC alloc] init];
           vc.noteModel = noteModel;
            vc.editNoteBlock = ^(HKNotesModel * _Nonnull noteModel) {
                for (int i = 0; i < self.dataArray.count; i++) {
                    HKNotesModel * noteM = self.dataArray[i];
                    if ([noteM.ID isEqualToString:noteModel.ID]) {
                        [self.dataArray replaceObjectAtIndex:i withObject:noteModel];
                        break;
                    }
                }
                [self.tableView reloadData];
            };
           [self pushToOtherController:vc];
        }else if (buttonIndex == 1){
            [self deleteNotes:noteModel];
        }
    }];
    [actionSheet show];
}

- (void)deleteNotes:(HKNotesModel *) noteModel{
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = @"";//@"确定注销登录吗?";
        label.textColor = COLOR_030303;
    })
    .LeeAddContent(^(UILabel *label) {
        
        //label.text = @"确定要退出吗?";
        label.text = @"笔记删除后不可恢复，确认删除？";
        [label setFont:[UIFont systemFontOfSize:15]];
        label.textColor = COLOR_030303;
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"取消";
        action.titleColor = COLOR_555555;
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            //[weakSelf.navigationController popViewControllerAnimated:YES];
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeDefault;
        action.title = @"删除";
        action.titleColor = COLOR_FF3221;
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            @weakify(self);
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setValue:noteModel.ID forKey:@"note_id"];
            [HKHttpTool POST:@"/note/delete-note" parameters:dic success:^(id responseObject) {
                showTipDialog(responseObject[@"msg"]);
                @strongify(self);
                if ([CommonFunction detalResponse:responseObject]) {
                    showTipDialog(@"删除成功");
                    
                    for (int i = 0; i < self.dataArray.count; i++) {
                        HKNotesModel * noteM = self.dataArray[i];
                        if ([noteM.ID isEqualToString:noteModel.ID]) {
                            [self.dataArray removeObject:noteM];
                            break;
                        }
                    }
                    [self.tableView reloadData];
                    
                }else{
                    showTipDialog(@"删除失败，请稍后重试");
                }
            } failure:^(NSError *error) {
        
            }];
        };
    })
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeHeaderColor([UIColor whiteColor])
    .LeeShow();
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"---------");
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"--------");
    HKSearchNoteVC * vc =  (HKSearchNoteVC *)self.parentViewController;
    [vc.searchBar resignFirstResponder];
}

-(void)dealloc{
    HK_NOTIFICATION_REMOVE();
}


//#pragma mark ======== TBSrollViewEmptyDelegate
//- (UIImage *)tb_emptyImage:(UIScrollView *)scrollView network:(TBNetworkStatus)status{
//    if (status == TBNetworkStatusNotReachable){
//        return imageName(NETWORK_ALREADY_LOST_IMAGE);
//    }else{
//        return [UIImage imageNamed:@"img_nothing_note_2_30"];
//    }
//}
//
//- (NSAttributedString *)tb_emptyTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status{
//    return nil;
//}

@end
