//
//  HKNotesListVC.m
//  Code
//
//  Created by Ivan li on 2020/12/29.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKNotesListVC.h"
#import "YUFoldingTableView.h"
#import "YUFoldingSectionHeader.h"
#import "HKCourseListCell.h"
#import "ACActionSheet.h"
#import "HKSearchNoteVC.h"
#import "HKNotesListModel.h"
#import "HKNotesListCell.h"
#import "HKEditNoteVC.h"
#import "VideoPlayVC.h"
#import "UIBarButtonItem+Extension.h"

@interface HKNotesListVC ()<YUFoldingTableViewDelegate,UIGestureRecognizerDelegate,HKNotesListCellDelegate>
@property (nonatomic, weak) YUFoldingTableView *foldingTableView;
@property (nonatomic , assign) int page ;
@property (nonatomic , strong) NSMutableArray * dataArray;
@end

@implementation HKNotesListVC

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)createUI {
    self.title = @"我的笔记";
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;

    UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"nac_back") darkImage:imageName(@"nac_back_dark")];
    UIButton *button = [[UIButton alloc] init];
    [button setImage:image forState:UIControlStateNormal];

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    button.size = CGSizeMake(PADDING_35, PADDING_35);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.hk_hideNavBarShadowImage = YES;    
    self.navigationItem.rightBarButtonItem  = [UIBarButtonItem BarButtonItemWithImage:[UIImage hkdm_imageWithNameLight:@"ic_search_notes_2_30" darkImageName:@"search_gray_dark"] target:self action:@selector(rightBarBtnAction) size:CGSizeMake(40, 40)];
    
    [self setupFoldingTableView];
//    [self setupRefresh];
    
    @weakify(self);
//    [HKRefreshTools footerAutoRefreshWithTableView:self.foldingTableView completion:^{
//        @strongify(self);
//        [self loadListData];
//    }];
    
    [HKRefreshTools headerRefreshWithTableView:self.foldingTableView completion:^{
        @strongify(self);
        [self loadNewListData];
    }];
    self.foldingTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载");
        [self loadListData];
    }];
    
    if (!self.videoModel.video_id.length) {
        [self loadNewListData];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }    
}

- (void)loadNewListData{
    self.page = 1;
    [self loadListData];
}

-(void)setVideoModel:(HKNotesVideoModel *)videoModel{
    _videoModel = videoModel;
    [self loadNewListData];
}

- (void)loadListData{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    if (self.videoModel.video_id.length) {
        [dic setObject:self.videoModel.video_id forKey:@"video_id"];
    }
    @weakify(self);
    [HKHttpTool POST:@"/note/my-note-video-list" parameters:dic success:^(id responseObject) {
        @strongify(self);
        [self.foldingTableView.mj_header endRefreshing];
        if (HKReponseOK) {
            NSArray * resultArray = [HKNotesListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            HKPageInfoModel *pageModel = [HKPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            if (resultArray.count) {
                if (pageModel.current_page >= self.page) {
                    
                    for (HKNotesListModel * noteList in resultArray) {
                        for (HKNotesModel * note in noteList.notes) {
                            note.unfold = 0;
                        }
                    }
                                    
                    [self.dataArray addObjectsFromArray:resultArray];
                    
                    if (pageModel.current_page >= pageModel.page_total) {
                        [self.foldingTableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [self.foldingTableView.mj_footer endRefreshing];
                    }
                    self.page ++ ;
                }
                
                if (self.dataArray.count < 15) {
                    NSMutableArray *array = [NSMutableArray array];
                    for (int i = 0;  i < self.dataArray.count; i++) {
                        if (i == self.dataArray.count-1) {
                            [array addObject:[NSNumber numberWithInteger:1]];
                        }else{
                            [array addObject:[NSNumber numberWithInteger:0]];
                        }
                    }
                    self.foldingTableView.statusArray = array;
                }
                
            }else{
                [self.foldingTableView.mj_footer endRefreshing];
            }
        }else{
            [self.foldingTableView.mj_footer endRefreshing];
        }
        [self.foldingTableView reloadData];
    } failure:^(NSError *error) {
        [self.foldingTableView.mj_footer endRefreshing];
        [self.foldingTableView.mj_header endRefreshing];
    }];
}

//- (void)tableFooterEndRefreshing {
//    [self.foldingTableView.mj_footer endRefreshingWithNoMoreData];
//    self.foldingTableView.mj_footer.hidden = YES;
//}
//
//- (void)tableFooterStopRefreshing {
//    [self.foldingTableView.mj_footer endRefreshing];
////    self.foldingTableView.mj_footer.hidden = NO;
//}

-(void)rightBarBtnAction{
    [MobClick event: notelist_search];
    HKSearchNoteVC * vc = [[HKSearchNoteVC alloc] init];
    [self pushToOtherController:vc];
}

// 创建tableView
- (void)setupFoldingTableView {
    self.foldingTableView.foldingDelegate = self;
    
    // 注册Cell
    [self.foldingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKNotesListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKNotesListCell class])];
    
    self.foldingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.foldingTableView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.foldingTableView.separatorColor = COLOR_FFFFFF_3D4752;
}

/**
 设置表格刷新
 */
//- (void)setupRefresh {
//    MJRefreshNormalHeader *mj_header = nil;
//    mj_header.automaticallyChangeAlpha = YES;
//    self.foldingTableView.mj_header = mj_header;
//}

- (void)backClick{
    [self backAction];
}

- (YUFoldingTableView *)foldingTableView {
    if (nil == _foldingTableView) {
        CGFloat height = SCREEN_HEIGHT - KNavBarHeight64;
        YUFoldingTableView *foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, height)];
        _foldingTableView = foldingTableView;
        _foldingTableView.rowHeight = UITableViewAutomaticDimension;
        _foldingTableView.estimatedRowHeight = 100;
        
        _foldingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _foldingTableView.tb_EmptyDelegate = self;

        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, foldingTableView);
        [self.view addSubview:foldingTableView];
        if (@available(iOS 15.0, *)) {
            _foldingTableView.sectionHeaderTopPadding = 0;
        }
    }
    return _foldingTableView;
}

#pragma mark - YUFoldingTableViewDelegate / required（必须实现的代理）
// 返回箭头的位置
- (YUFoldingSectionHeaderArrowPosition)perferedArrowPositionForYUFoldingTableView:(YUFoldingTableView *)yuTableView {
    // 默认箭头在左
    return YUFoldingSectionHeaderArrowPositionRight;
}

- (NSInteger )numberOfSectionForYUFoldingTableView:(YUFoldingTableView *)yuTableView {
    return self.dataArray.count;
}

- (NSInteger )yuFoldingTableView:(YUFoldingTableView *)yuTableView numberOfRowsInSection:(NSInteger )section{
    HKNotesListModel * model = self.dataArray[section];
    return model.notes.count;
}

- (UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HKNotesListCell * cell = [yuTableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKNotesListCell class])];
    HKNotesListModel * model = self.dataArray[indexPath.section];
    cell.noteModel = model.notes[indexPath.row];
    cell.delegate = self;
    WeakSelf
    cell.didOpenBlock = ^{
        [weakSelf.foldingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    return cell;
}

- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForHeaderInSection:(NSInteger )section{
    // 软件入门
    return 50;
}

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger)section {
    HKNotesListModel * model = self.dataArray[section];
    return model.title;
}

- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [yuTableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)deleteNotes:(HKNotesModel *) noteModel{
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = @"";//@"确定注销登录吗?";
        label.textColor = COLOR_030303;
    })
    .LeeAddContent(^(UILabel *label) {
        label.text = @"笔记删除后不可恢复，确认删除？";
        [label setFont:[UIFont systemFontOfSize:15]];
        label.textColor = COLOR_030303;
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"取消";
        action.titleColor = COLOR_555555;
        action.backgroundColor = [UIColor whiteColor];
    })
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeDefault;
        action.title = @"删除";
        action.titleColor = COLOR_FF3221;
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setValue:noteModel.ID forKey:@"note_id"];
            @weakify(self);
            [HKHttpTool POST:@"/note/delete-note" parameters:dic success:^(id responseObject) {
                showTipDialog(responseObject[@"msg"]);
                @strongify(self);
                if ([CommonFunction detalResponse:responseObject]) {
                    showTipDialog(@"删除成功");
                    
                    for (int i = 0; i < self.dataArray.count; i++) {
                        HKNotesListModel * listM = self.dataArray[i];
                        for (int j = 0; j < listM.notes.count; j ++) {
                            HKNotesModel * noteM = listM.notes[j];
                            if ([noteM.ID isEqualToString:noteModel.ID]) {
                                [listM.notes removeObject:noteM];
                                break;
                            }
                        }
                    }
                    
                    for (int i = 0 ; i < self.dataArray.count; i ++) {
                        HKNotesListModel * listM = self.dataArray[i];
                        if (!listM.notes.count) {
                            [self.dataArray removeObject:listM];
                        }
                    }
                    [self.foldingTableView reloadData];
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

#pragma mark - YUFoldingTableViewDelegate / optional （可选择实现的）

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView descriptionForHeaderInSection:(NSInteger )section {
    
    NSInteger status = [yuTableView.statusArray[section] integerValue];
    HKNotesListModel * model = self.dataArray[section];
    if (status == 1) {
        return @"收起";
    }else{
        return [NSString stringWithFormat:@"展开(%@)",model.count];
    }
}

- (BOOL )yuFoldingTableView:(YUFoldingTableView *)yuTableView sectionTitle:(NSInteger)section isClick:(BOOL)isClick{
    NSInteger status = [yuTableView.statusArray[section] integerValue];
    HKNotesListModel * model = self.dataArray[section];
    NSString * str = nil;
    if (status == 1) {
        str = [NSString stringWithFormat:@"展开(%@)",model.count];
    }else{
        str = @"收起";
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sectionNoteCount" object:nil userInfo:@{@"text":str,@"section":[NSString stringWithFormat:@"%ld",section]}];
    return YES;
}
/**  section 点击 */
- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView sectionTitleClicked:(NSInteger)section{
    NSLog(@"%s",__func__);
}

- (BOOL)yuFoldingTableView:(YUFoldingTableView *)yuTableView sectionTitleShowAnimation:(NSInteger)section{
    NSLog(@"%s",__func__);
    return YES;
}

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView textColorForDescriptionInSection:(NSInteger )section{
    return COLOR_7B8196_A8ABBE;
}

- (UIFont *)yuFoldingTableView:(YUFoldingTableView *)yuTableView fontForDescriptionInSection:(NSInteger )section{
    return [UIFont systemFontOfSize:14];
}

- (UIImage *)yuFoldingTableView:(YUFoldingTableView *)yuTableView arrowImageForSection:(NSInteger)section {
    
    return [UIImage hkdm_imageWithNameLight:@"more_course_list_arrow_right" darkImageName:@"more_course_list_arrow_right_dark"];
}


- (UIFont *)yuFoldingTableView:(YUFoldingTableView *)yuTableView fontForTitleInSection:(NSInteger )section {
    return [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
}


- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView textColorForTitleInSection:(NSInteger )section{
    return COLOR_27323F_EFEFF6; HKColorFromHex(0x27323F, 1.0);
}

- (UIColor *)yuFoldingTableView:(YUFoldingTableView *)yuTableView backgroundColorForHeaderInSection:(NSInteger )section {
    return COLOR_FFFFFF_3D4752;
}


#pragma mark ======= HKNotesListCellDelegate
- (void)notesListCellDidTimeBtn:(HKNotesModel *)noteModel{
    [MobClick event: notelist_time];
    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:nil placeholderImage:nil
                                               lookStatus:LookStatusInternetVideo videoId:noteModel.video_id model:nil];
    VC.seekTime = [noteModel.seconds integerValue];
    [self pushToOtherController:VC];
}

-(void)notesListCellDidImgV:(HKNotesModel *)noteModel{
    if (noteModel.screenshot.length) {
        [HKPhotoBrowserTool initPhotoBrowserWithUrl:noteModel.screenshot];
    }
}

-(void)notesListCellDidZanBtn:(HKNotesModel *)noteModel{
    [MobClick event: notelist_like];
    [HKHttpTool POST:@"/note/switch-liked" parameters:@{@"note_id":noteModel.ID} success:^(id responseObject) {
        [HKProgressHUD hideHUD];
        if ([CommonFunction detalResponse:responseObject]) {
            //showTipDialog(@"作业已提交");
            //int likeCount = [noteModel.likes_count intValue];
            noteModel.liked = [NSNumber numberWithInt:1];
            //noteModel.likes_count = [NSString stringWithFormat:@"%d",likeCount+1];
            //showTipDialog(responseObject[@"msg"]);
        }else{
            int likeCount = [noteModel.likes_count intValue];
            noteModel.liked = [NSNumber numberWithInt:0];
            noteModel.likes_count = [NSString stringWithFormat:@"%d",likeCount-1];
            //showTipDialog(responseObject[@"msg"]);
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)notesListCellDidMoreBtn:(HKNotesModel *)noteModel{
    NSArray *titleArr =  @[@"编辑笔记",@"删除笔记"];
    ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:nil cancelTitleColor:nil destructiveButtonTitle:nil otherButtonTitles:titleArr otherButtonImgs:@[@"ic_edit_notes_2_30",@"ic_del_notes_2_30"] buttonTitleColors:@[[UIColor colorWithHexString:@"#27323F"],[UIColor colorWithHexString:@"#27323F"]] actionSheetBlock:^(NSInteger buttonIndex) {
        if (0 == buttonIndex) {
           HKEditNoteVC * vc = [[HKEditNoteVC alloc] init];
           vc.noteModel = noteModel;
            vc.editNoteBlock = ^(HKNotesModel * _Nonnull noteModel) {
                for (int i = 0; i < self.dataArray.count; i++) {
                    HKNotesListModel * listM = self.dataArray[i];
                    for (int j = 0; j < listM.notes.count; j ++) {
                        HKNotesModel * noteM = listM.notes[j];
                        if ([noteM.ID isEqualToString:noteModel.ID]) {
                            [listM.notes replaceObjectAtIndex:j withObject:noteModel];
                            break;
                        }
                    }
                }
                [self.foldingTableView reloadData];
            };
            [MobClick event: notelist_edit];

           [self pushToOtherController:vc];
        }else if (buttonIndex == 1){
            [MobClick event: notelist_delete];
            [self deleteNotes:noteModel];
        }
    }];
    [actionSheet show];
}

#pragma mark ======== TBSrollViewEmptyDelegate
- (UIImage *)tb_emptyImage:(UIScrollView *)scrollView network:(TBNetworkStatus)status{
    if (status == TBNetworkStatusNotReachable){
        return imageName(NETWORK_ALREADY_LOST_IMAGE);
    }else{
        return [UIImage imageNamed:@"img_nothing_note_2_30"];
    }
}

- (NSAttributedString *)tb_emptyTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status{
    return nil;
}

@end
