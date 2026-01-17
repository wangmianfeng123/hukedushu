//
//  HKAttentionVC.m
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKAttentionVC.h"
#import "HKMomentCell.h"
#import "HKAttentionTopCell.h"
#import "HKAttentionBottomCell.h"
#import "HKLiveMomentCell.h"
#import "HKWorksMomentCell.h"
#import "HKMomentDetailModel.h"
#import "HKMonmentTypeModel.h"
#import "HKMomentDetailVC.h"
#import "ACActionSheet.h"
#import "HKAttentionRefreshCell.h"
#import "VideoPlayVC.h"
#import "HKUserInfoVC.h"
#import "HKLiveCourseVC.h"
#import "HKTeacherCourseVC.h"
#import "HKHotTopicBaseVC.h"
#import "HtmlShowVC.h"
#import "XLPhotoBrowser.h"
#import "UMpopView.h"

@interface HKAttentionVC ()<UITableViewDataSource,UITableViewDelegate,HKMomentCellDelegate,HKLiveMomentCellDelegate,HKWorksMomentCellDelegate,HKAttentionBottomCellDelegate,UMpopViewDelegate>
@property (nonatomic , strong) NSMutableArray * tempArray;

@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , assign) int page ;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, copy)NSString * latestId;  //
@property (nonatomic , strong) NSMutableArray * recommendArray;
@property (nonatomic , strong) NSMutableArray * recommendUserArray;

@end

@implementation HKAttentionVC

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)tempArray{
    if (_tempArray == nil) {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}

-(NSMutableArray *)recommendArray{
    if (_recommendArray == nil) {
        _recommendArray = [NSMutableArray array];
    }
    return _recommendArray;
}

-(NSMutableArray *)recommendUserArray{
    if (_recommendUserArray == nil) {
        _recommendUserArray = [NSMutableArray array];
    }
    return _recommendUserArray;
}

- (void)refreshTableView{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
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
    [MyNotification addObserver:self selector:@selector(refreshData) name:@"postMomentSuccess" object:nil];
    // 成功登录
    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, userloginSuccessNotification);
}

- (void)userloginSuccessNotification{
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshData{
    [self loadNewListData];
}

- (void)loadNewListData{
    self.latestId = @"0";
    self.page = 1;
    [self loadListData];
}

- (void)loadListData{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.latestId forKey:@"latestId"];
    [dic setObject:self.typeModel.type forKey:@"type"];
    [dic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    
    @weakify(self);
    [HKHttpTool POST:@"/community/fetch-list" parameters:dic success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            [self.tempArray removeAllObjects];
            self.tempArray = [HKMomentDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            HKPageInfoModel *pageModel = [HKPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            NSString *latestId = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"latestId"]];
            self.recommendArray = [HKMomentDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"recommendTopics"]];
            
//            for (HKMomentDetailModel* model in self.tempArray) {
//                for (int i = 0; i < model.dynamic.images.count; i++) {
//                    NSLog(@"------------%@",model.dynamic.images[i]);
//                }
//
//                NSLog(@"------------*********** %@",model.dynamic.imageUrl);
//            }
            
            if (self.tempArray.count) {
                for (HKMomentDetailModel* model in self.tempArray) {
//                    NSMutableArray * array = [NSMutableArray array];
//                    for (int i = 0; i < model.dynamic.images.count; i++) {
//                        NSString * string = model.dynamic.images[i];
//                        string = [NSString stringWithFormat:@"%@!/format/jpeg/fw/200",string];
//                        [array addObject:string];
//                    }
//                    model.dynamic.images = array;

                    if (model.dynamic.imageUrl.length) {
                        NSString * imgUrls = [NSString stringWithFormat:@"%@!/format/jpeg/fw/500",model.dynamic.imageUrl];
                        model.dynamic.imageUrl = imgUrls;
                    }                    
                }
            }
            
//            for (HKMomentDetailModel* model in self.tempArray) {
//                for (int i = 0; i < model.dynamic.images.count; i++) {
//                    NSLog(@"===========%@",model.dynamic.images[i]);
//                }
//                
//                NSLog(@"===========*********** %@",model.dynamic.imageUrl);
//            }
            
            if (latestId.length) {
                self.latestId = latestId;
            }

                if (pageModel.current_page >= self.page) {
                    if (self.page == 1) {
                        if (!isLogin()) {//显示最顶部的提醒模块
                            [MobClick event: community_follow_tab_notlogin_view];

                        }else if (self.tempArray.count == 0){
                            [MobClick event: community_follow_tab_unfollow_view];
                        }
                        self.recommendUserArray = [HKrecommendUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"recommendUser"]];
                        [self.dataArray removeAllObjects];
                    }
                    [self.dataArray addObjectsFromArray:self.tempArray];
                    
                    
                    
                    if (self.dataArray.count <2) {//推荐动态
                        [MobClick event: community_follow_tab_nocontent_view];
                        [self.dataArray addObjectsFromArray:self.recommendArray];
                    }else{//头部隐藏，推荐讲师
                        if (self.page == 1 && self.recommendUserArray.count) {
                            HKMomentDetailModel * model = [[HKMomentDetailModel alloc] init];
                            model.isRecommandUser = YES;
                            [self.dataArray insertObject:model atIndex:2];
                        }
                    }
                    
                    if (pageModel.current_page >= pageModel.page_total) {
                        [self tableFooterEndRefreshing];
                    }else{
                        [self tableFooterStopRefreshing];
                    }
                    if (self.tempArray.count >= pageModel.page_size) {
                        self.page ++ ;
                    }
                    
                    [self.tableView.mj_header endRefreshing];
                }
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
    if (!isLogin()||self.tempArray.count<3) {//显示最顶部的提醒模块
        self.tableView.mj_footer.hidden = YES;
    }else{
        self.tableView.mj_footer.hidden = NO;
    }
}

- (UITableView*)tableView {
    if (!_tableView) {//138 * Ratio + KNavBarHeight64
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
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
        _tableView.contentInset = UIEdgeInsetsMake(40, 0, KTabBarHeight49+KNavBarHeight64, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = YES;
        _tableView.tb_EmptyDelegate = self;
        
        // 防止 reloadsection UI 错乱
        _tableView.estimatedRowHeight = 200;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        //[_tableView setContentInset:UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0)];
        //任务项cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKAttentionTopCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKAttentionTopCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKAttentionBottomCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKAttentionBottomCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKMomentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKMomentCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKLiveMomentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKLiveMomentCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKWorksMomentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKWorksMomentCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKAttentionRefreshCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKAttentionRefreshCell class])];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 2) {
        if (!isLogin()||self.tempArray.count<3) {//显示最顶部的提醒模块
            if (indexPath.section == 2) {
                return 40;
            }
            return 95;
        }else{
            return 0.0;
        }
    }else{
        return UITableViewAutomaticDimension;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 2) {
        if (!isLogin()||self.tempArray.count<3) {//显示最顶部的提醒模块
            return 1;
        }else{
            return 0;
        }
    }else{
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKAttentionTopCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKAttentionTopCell class])];
        cell.dataCount = (int)self.tempArray.count;
        return cell;
    }else if (indexPath.section == 1){
        HKMomentDetailModel * model = self.dataArray[indexPath.row];
        if (model.isRecommandUser) {
            HKAttentionBottomCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKAttentionBottomCell class])];
            cell.dataArray = self.recommendUserArray;
            cell.delegate = self;
            return cell;
        }else{
            if (!model.dynamic.isEmpty){
                if ([model.dynamic.connectType isEqual:[NSNumber numberWithInt:1]]&&[model.dynamic.contentType isEqual:[NSNumber numberWithInt:2]]){//社区动态 - 视频
                    HKLiveMomentCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKLiveMomentCell class])];
                    cell.model = model;
                    cell.commentBtn.userInteractionEnabled = NO;
                    cell.delegate = self;
                    return cell;
                }else if ([model.dynamic.connectType isEqual:[NSNumber numberWithInt:2]]&&[model.dynamic.contentType isEqual:[NSNumber numberWithInt:3]]){//社区动态 - 直播
                    HKLiveMomentCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKLiveMomentCell class])];
                    cell.model = model;
                    cell.commentBtn.userInteractionEnabled = NO;
                    cell.delegate = self;
                    return cell;
                }else if ([model.dynamic.connectType isEqual:[NSNumber numberWithInt:2]]&&[model.dynamic.contentType isEqual:[NSNumber numberWithInt:4]]){//社区动态 - 作品
                    HKWorksMomentCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKWorksMomentCell class])];
                    cell.model = model;
                    cell.delegate = self;
                    cell.commentBtn.userInteractionEnabled = NO;
                    return cell;
                }else{//纯文案
                    HKMomentCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKMomentCell class])];
                    cell.delegate = self;
                    cell.model = model;
                    cell.indexPath = indexPath;
                    cell.commentBtn.userInteractionEnabled = NO;
                    return cell;
                }
            }else{//纯文案
                HKMomentCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKMomentCell class])];
                cell.delegate = self;
                cell.model = model;
                cell.indexPath = indexPath;
                cell.commentBtn.userInteractionEnabled = NO;
                return cell;
            }
        }
    }else{
        HKAttentionRefreshCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKAttentionRefreshCell class])];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        [self.tableView.mj_header beginRefreshing];
    }else if(indexPath.section == 1){
        HKMomentDetailModel * model = self.dataArray[indexPath.row];
        if (!model.isRecommandUser) {
            HKMomentDetailModel * detailM = self.dataArray[indexPath.row];
            if ([detailM.dynamic.connectType isEqual:[NSNumber numberWithInt:2]]&&[detailM.dynamic.contentType isEqual:[NSNumber numberWithInt:4]]) {
                //跳转M站
                if (detailM.topic.url.length) {
                    HtmlShowVC * vc = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:detailM.topic.url];
                    [self pushToOtherController:vc];
                    [MobClick event: community_content_works];
                }
                
            }else if ([detailM.dynamic.connectType isEqual:[NSNumber numberWithInt:2]]&&[detailM.dynamic.contentType isEqual:[NSNumber numberWithInt:3]]){//社区动态 - 直播
                HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
                VC.course_id = detailM.dynamic.smallId;
                [self pushToOtherController:VC];
            }else if ([detailM.dynamic.connectType isEqual:[NSNumber numberWithInt:1]]&&[detailM.dynamic.contentType isEqual:[NSNumber numberWithInt:2]]){////社区动态 - 视频
                VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:nil placeholderImage:nil
                                                           lookStatus:LookStatusInternetVideo videoId:[NSString stringWithFormat:@"%@",detailM.dynamic.videoId] model:nil];
                [self pushToOtherController:VC];
            }else{
                if (!detailM.topic.ID.length) return;
                HKMomentDetailVC * vc = [[HKMomentDetailVC alloc] init];
                HKMomentDetailModel * detailM = self.dataArray[indexPath.row];
                vc.topic_id = detailM.topic.ID;
                vc.connect_type = [NSString stringWithFormat:@"%@",detailM.topic.connectType];
                WeakSelf
                vc.didAttentionBlock = ^(HKMomentDetailModel * _Nonnull model) {
                    for (HKMomentDetailModel * detailM in weakSelf.dataArray) {
                        if ([model.user.uid isEqualToString:detailM.user.uid]) {
                            detailM.user.subscribed = model.user.subscribed;
                        }
                    }
                    [weakSelf.tableView reloadData];
                };
                vc.didLikeBlock = ^(HKMomentDetailModel * _Nonnull model) {
                    for (HKMomentDetailModel * detailM in weakSelf.dataArray) {
                        if ([model.topic.ID isEqualToString:detailM.topic.ID]) {
                            detailM.topic.likes_count = model.topic.likes_count;
                            detailM.topic.isLiked = model.topic.isLiked;
                            [self.tableView reloadData];
                            break;
                        }
                    }
                };
                vc.didDeleteBlock = ^(HKMomentDetailModel * _Nonnull model) {
                    if (model) {
                        for (HKMomentDetailModel * M in weakSelf.dataArray) {
                            if ([M.topic.ID isEqualToString:model.topic.ID ]) {
                                [weakSelf.dataArray removeObject:M];
                                [weakSelf.tableView reloadData];
                                break;;
                            }
                        }
                    }
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else if (indexPath.section == 0){
        if (!isLogin()) {
            [self setLoginVC];
        }
    }
}

-(void)dealloc{
    HK_NOTIFICATION_REMOVE();
}

#pragma mark ========  HKLiveMomentCellDelegate
- (void)liveMomentCellDidAttentionBtn:(HKMomentDetailModel *)model{
    [self momentCellDidAttentionBtn:model];
}
- (void)liveMomentCellDidLikeBtn:(HKMomentDetailModel *)model{
    [self momentCellDidLikeBtn:model];
}
- (void)liveMomentCellDidHeaderBtn:(HKMomentDetailModel *)model{
    [self momentCellDidHeaderBtn:model];
}
- (void)liveMomentCellDidCoverView:(HKMomentDetailModel *)model{
    if ([model.dynamic.connectType isEqual:[NSNumber numberWithInt:1]]&&[model.dynamic.contentType isEqual:[NSNumber numberWithInt:2]]){//社区动态 - 视频
        VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:nil placeholderImage:nil
                                                   lookStatus:LookStatusInternetVideo videoId:[NSString stringWithFormat:@"%@",model.dynamic.videoId] model:nil];
        [self pushToOtherController:VC];
    }else if ([model.dynamic.connectType isEqual:[NSNumber numberWithInt:2]]&&[model.dynamic.contentType isEqual:[NSNumber numberWithInt:3]]){//社区动态 - 直播
        HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
        VC.course_id = model.dynamic.smallId;
        [self pushToOtherController:VC];
    }
}

- (void)liveMomentCellDidShareBtn:(HKMomentDetailModel *)model{
    [self momentCellDidShareBtn:model];
}

#pragma mark ===== HKWorksMomentCellDelegate
- (void)worksMomentCellDidAttentionBtn:(HKMomentDetailModel *)model{
    [self momentCellDidAttentionBtn:model];
}

- (void)worksMomentCellDidLikeBtn:(HKMomentDetailModel *)model{
    [self momentCellDidLikeBtn:model];
}

- (void)worksMomentCellDidHeaderBtn:(HKMomentDetailModel *)model{
    [self momentCellDidHeaderBtn:model];
}

- (void)worksMomentCellDidShareBtn:(HKMomentDetailModel *)model{
    [self momentCellDidShareBtn:model];
}

-(void)worksMomentCellDidImgs:(NSMutableArray *)imgArray index:(NSInteger)index{
    for (int i = 0; i < imgArray.count; i++) {
        NSString * string = imgArray[i];
        if ([string containsString:@"!/format/jpeg/fw/200"]) {
            [string stringByReplacingOccurrencesOfString:@"!/format/jpeg/fw/200" withString:@""];
        }
    }
    [HKPhotoBrowserTool initPhotoBrowserWithUrlArray:imgArray withIndex:index delegate:self];
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
        [HKHttpTool POST:@"/switch/subscribe" parameters:@{@"uid":model.user.uid} success:^(id responseObject) {
            if ([CommonFunction detalResponse:responseObject]) {
                if (!model.user.subscribed) {
                    showTipDialog(@"关注成功");
                }
                for (HKMomentDetailModel * detailM in self.dataArray) {
                    if ([detailM.user.uid isEqualToString:model.user.uid]) {
                        detailM.user.subscribed = !detailM.user.subscribed;
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
            }
        } failure:^(NSError *error) {
                
        }];
    }else{
        [self setLoginVC];
    }
}

- (void)momentCellDidImgArray:(NSMutableArray *)imgArray andIndex:(NSInteger)index{
    for (int i = 0; i < imgArray.count; i++) {
        NSString * string = imgArray[i];
        if ([string containsString:@"!/format/jpeg/fw/200"]) {
            [string stringByReplacingOccurrencesOfString:@"!/format/jpeg/fw/200" withString:@""];
        }
    }
    [HKPhotoBrowserTool initPhotoBrowserWithUrlArray:imgArray withIndex:index delegate:self];
}

-(void)momentCellDidTotalLabel:(NSIndexPath *)indexPath{
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
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


- (void)momentCellDidCourseView:(HKMomentDetailModel *)model{
    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:nil placeholderImage:nil
                                               lookStatus:LookStatusInternetVideo videoId:model.video.videoId model:nil];
    [self pushToOtherController:VC];

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

-(void)momentCellDidTagBtn:(HKMomentDetailModel *)model{
    if (model.subjects.count) {
        HKMonmentTagModel * tagModel = model.subjects[0];
        for (int i = 0; i < self.tabModel.tabs.count; i ++) {
            HKMonmentTypeModel * model = self.tabModel.tabs[i];
            if ([model.name isEqualToString:tagModel.name]) {
                self.didTagBtnBlock(i);
                return;
            }
        }
        HKHotTopicBaseVC * vc = [[HKHotTopicBaseVC alloc] init];
        vc.subjectId = [NSString stringWithFormat:@"%@",tagModel.ID];
        [self pushToOtherController:vc];
    }
}

#pragma mark ========== HKAttentionBottomCellDelegate
- (void)attentionBottomCellDidAttention:(HKrecommendUserModel *)model{
    if (isLogin()){
        WeakSelf;
        if (model.subscribed) {
            
            NSArray *titleArr =  @[@"不再关注",@"取消"];
            
            ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:nil cancelTitleColor:nil destructiveButtonTitle:nil otherButtonTitles:titleArr buttonTitleColors:nil actionSheetBlock:^(NSInteger buttonIndex) {
                
                if (0 == buttonIndex) {
                    [weakSelf loadUserAttentionData:model];
                }else{
                    //取消
                }
            }];
            [actionSheet show];
        }else{
            [self loadUserAttentionData:model];
        }
    } else{
        [self setLoginVC];
    }
}

- (void)loadUserAttentionData:(HKrecommendUserModel *)model{
    if (isLogin()){
        WeakSelf;
        [HKHttpTool POST:@"/switch/subscribe" parameters:@{@"uid":model.uid} success:^(id responseObject) {
            if ([CommonFunction detalResponse:responseObject]) {
                if (!model.subscribed) {
                    showTipDialog(@"关注成功");
                    [MobClick event: community_follow_tab_follow];
                }
                model.subscribed = !model.subscribed;
                for (HKMomentDetailModel * detailM in self.dataArray) {
                    if ([detailM.user.uid isEqualToString:model.uid]) {
                        detailM.user.subscribed = !detailM.user.subscribed;
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

- (void)attentionBottomCellDidHeader:(HKrecommendUserModel *)model{
    if (!model.uid.length) return;
    [HKHttpTool POST:@"/user/home-header" parameters:@{@"uid":model.uid} success:^(id responseObject) {
        if ([CommonFunction detalResponse:responseObject]) {
            BOOL isTeacher = [responseObject[@"data"][@"teacher"] boolValue];
            [MobClick event: community_follow_tab_homepage];

            if (isTeacher) {
                int teacher_id = [responseObject[@"data"][@"user"][@"teacherId"] intValue];
                HKTeacherCourseVC *vc = [[HKTeacherCourseVC alloc] init];
                vc.teacher_id = [NSString stringWithFormat:@"%d",teacher_id];
                vc.followBlock = ^(BOOL is_follow, NSString *teacher_id) {
                    
                };
                [self pushToOtherController:vc];
            }else{
                HKUserInfoVC *vc = [[HKUserInfoVC alloc] init];
                vc.userId = model.uid;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)momentCellDidCourseAvator:(HKMomentDetailModel *)model{
    if (!model.video.teacherId.length) return;
    HKTeacherCourseVC *vc = [[HKTeacherCourseVC alloc] init];
    vc.teacher_id = model.video.teacherId;
    vc.followBlock = ^(BOOL is_follow, NSString *teacher_id) {
        
    };
    [self pushToOtherController:vc];
}


-(void)momentCellDidShareBtn:(HKMomentDetailModel *)model{
    [MobClick event: community_content_share];
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

@end
