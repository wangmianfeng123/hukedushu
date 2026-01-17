//
//  HKContainerListVC.m
//  Code
//
//  Created by Ivan li on 2017/11/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKContainerListVC.h"
#import "HKBulidAlbumCell.h"
#import "HKBulidAlbumVCDialog.h"
#import "HKContainerModel.h"
  
#import "UIButton+ImageTitleSpace.h"



#define  BULID_NEW_ALBUM  @"点击创建您的第一个专辑"


#define  VIEW_HEIGHT  (IS_IPAD ?447 :SCREEN_HEIGHT-110*2)



@interface HKContainerListVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView    *tableView;
@property(nonatomic,strong)NSMutableArray <HKAlbumModel*>*dataArray;
@property(nonatomic,strong)UIView    *bgView;
@property(nonatomic,strong)UIView    *headView;

@property(nonatomic,assign)NSInteger    totalPage;
@property(nonatomic,assign)NSInteger    page;
/** 顶部右侧 新建专辑按钮 */
@property(nonatomic,weak)UIButton   *topBulidBtn;

@end

@implementation HKContainerListVC


- (void)dealloc {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - emptyView  delegate
- (UIView *)tb_emptyView:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    
    if (status == TBNetworkStatusReachableViaWWAN || status== TBNetworkStatusReachableViaWiFi) {
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, scrollView.bounds.size.width, scrollView.bounds.size.height);
        // scrollView.bounds;
        
        UIButton *bulidBtn = [UIButton buttonWithTitle:nil titleColor:COLOR_333333 titleFont:@"17" imageName:@"ic_add_yellow_large"];
        [bulidBtn addTarget:self action:@selector(bulidBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:bulidBtn];
        
        UILabel *titelLB = [UILabel labelWithTitle:CGRectZero title:BULID_NEW_ALBUM titleColor:COLOR_27323F_EFEFF6 titleFont:@"17" titleAligment:NSTextAlignmentCenter];
        [view addSubview:titelLB];
        
        [bulidBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(view.mas_top).offset(90);
        }];
        
        [titelLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(view);
            make.top.equalTo(bulidBtn.mas_bottom).offset(PADDING_20);
        }];
        return view;
    }
    return nil;
}




- (void)createUI {
    //self.view.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.3];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-46, VIEW_HEIGHT));
    }];
    
    UIView *view = [self tableHeaderView];
    [self.bgView addSubview:view];
    [self.bgView addSubview:self.tableView];
    
    [self refreshUI];
}



- (NSMutableArray <HKAlbumModel*> *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        //_bgView.frame = CGRectMake(23, 110, SCREEN_WIDTH-46, VIEW_HEIGHT);
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.clipsToBounds = YES;
        _bgView.layer.cornerRadius = PADDING_5;
    }
    return _bgView;
}



- (UIView*)tableHeaderView {
    

    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-46, 66)];
    bgView.backgroundColor = COLOR_FFFFFF_3D4752;
    
    UIButton *closeBtn = [UIButton buttonWithTitle:nil titleColor:COLOR_333333 titleFont:@"15" imageName:@"ic_close"];
    UIImage *normalImage = [UIImage hkdm_imageWithNameLight:@"ic_close" darkImageName:@"ic_close_dark"];
    [closeBtn setImage:normalImage forState:UIControlStateNormal];
    [closeBtn setHKEnlargeEdge:PADDING_15];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeBtn];
    
    UILabel *centerLB = [UILabel labelWithTitle:CGRectZero title:@"添加到专辑" titleColor:COLOR_7B8196_A8ABBE titleFont:@"15" titleAligment:NSTextAlignmentCenter];
    [bgView addSubview:centerLB];
    
    UIButton *bulidBtn = [UIButton buttonWithTitle:nil titleColor:COLOR_333333 titleFont:@"15"  imageName:(@"ic_add_yellow")];
    [bulidBtn setHKEnlargeEdge:PADDING_15];
    bulidBtn.hidden = YES;
    [bulidBtn addTarget:self action:@selector(bulidBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:bulidBtn];
    self.topBulidBtn = bulidBtn;
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(PADDING_20);
        make.top.equalTo(bgView).offset(23);
    }];
    
    [centerLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(closeBtn);
        make.centerX.equalTo(bgView);
        make.width.mas_greaterThanOrEqualTo(160);
    }];
    
    [bulidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-PADDING_20);
        make.centerY.equalTo(closeBtn);
    }];
    return bgView;
}



- (void)closeBtnClick {
    
    self.view.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5 animations:^{
        self.view.y = SCREEN_HEIGHT;
        self.containerCloseBlock ?self.containerCloseBlock(@"dd") :nil;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}



- (void)bulidBtnClick {
    
    // 如果已经添加就直接返回
    WeakSelf;
    UIViewController *topVC = [CommonFunction topViewController];
    if ([topVC.view viewWithTag:10]) return;
    
    HKBulidAlbumVCDialog *VC = [HKBulidAlbumVCDialog new];
    VC.hKBulidAlbumBlock = ^(HKAlbumModel *model) {
        StrongSelf;
        if (!isEmpty(model.album_id)) {
            [strongSelf.dataArray insertObject:model atIndex:0];
            NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:0];
            if (1 == strongSelf.dataArray.count) {
                [strongSelf.tableView reloadData];
            }else{
                [strongSelf.tableView insertRowsAtIndexPaths:@[indexP] withRowAnimation:UITableViewRowAnimationNone];
                [strongSelf.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }
            strongSelf.topBulidBtn.hidden = strongSelf.dataArray.count ?NO :YES ;
        }
    };
    VC.view.frame = topVC.view.bounds;
    VC.view.y = SCREEN_HEIGHT;
    VC.view.tag = 10;
    
    [topVC addChildViewController:VC];
    [topVC.view addSubview:VC.view];
    [UIView animateWithDuration:0.3 animations:^{
        VC.view.y = 0;
    } completion:^(BOOL finished) {
        
    }];
    
}





- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 66, SCREEN_WIDTH-46, VIEW_HEIGHT-66) style:UITableViewStylePlain];
        _tableView.rowHeight = IS_IPHONE6PLUS ?60+18 :60;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        _tableView.tableFooterView = [UIView new];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _tableView;
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count? 1 :0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKBulidAlbumCell *cell = [HKBulidAlbumCell initCellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HKAlbumModel *model = self.dataArray[indexPath.row];
    [self collectVideoWithAlbumModel:model videoId:self.detailModel.video_id];
}



- (void)refreshUI {
    WeakSelf;
    self.page = 1;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        strongSelf.page = 1;
        NSString  *pageNum = [NSString stringWithFormat:@"%lu",strongSelf.page];
        [strongSelf getAlbumListByPage:pageNum];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf
        NSString  *pageNum = [NSString stringWithFormat:@"%lu",strongSelf.page];
        strongSelf.tableView.mj_footer.hidden = NO;
        [strongSelf getAlbumListByPage:pageNum];
    }];
    [self.tableView.mj_header beginRefreshing];
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


#pragma mark - 专辑列表
- (void)getAlbumListByPage:(NSString*)page {
    
    //type 1-我的专辑 2-收藏专辑
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:page,@"page",@"1",@"type",nil];
    [HKHttpTool POST:ALBUM_MY_ALBUM parameters:parameters success:^(id responseObject) {
        
        [self tableHeaderEndRefreshing];
        self.tableView.mj_footer.automaticallyHidden = NO;
        self.tableView.mj_footer.hidden = YES;
        if (HKReponseOK) {
            HKContainerModel *model =[HKContainerModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            if ([page isEqualToString:@"1"]) {
                self.dataArray = model.album_list;
                self.totalPage = [model.total_page intValue];
            }else{
                [self.dataArray addObjectsFromArray:model.album_list];
            }
            if (self.page >= self.totalPage) {
                [self tableFooterEndRefreshing];
            }else{
                self.page++;
                [self tableFooterStopRefreshing];
            }
        }else{
            [self tableFooterStopRefreshing];
        }
        
        self.topBulidBtn.hidden = self.dataArray.count ?NO :YES ;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self tableFooterStopRefreshing];
        [self tableHeaderEndRefreshing];
    }];
}




#pragma mark - 收藏视频到指定专辑
- (void)collectVideoWithAlbumModel:(HKAlbumModel*)model videoId:(NSString*)videoId {
    
    if (isEmpty(videoId) || isEmpty(model.album_id)) {
        return;
    }
    
    WeakSelf;
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:videoId,@"video_id",model.album_id,@"album_id",nil];
    [HKHttpTool POST:ALBUM_COLLECT_VIDEO parameters:parameters success:^(id responseObject) {
        StrongSelf;
        if (HKReponseOK) {
            HKAlbumModel *albumM = [HKAlbumModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            if (NO == albumM.is_exist) {
                [strongSelf closeBtnClick];
                NSInteger count = [model.video_num integerValue];
                if (0 == count) {
                    [strongSelf alertWithName:model.name];
                }else {
                    NSString *msg = [NSString stringWithFormat:@"已添加到专辑“%@”中",model.name];
                    showTipDialog(msg);
                }
            }else{
                showTipDialog(Video_Exist_Album);
            }
        }
    } failure:^(NSError *error) {
        
    }];
}



#pragma mark - 第一次添加到专辑成功 弹框
- (void)alertWithName:(NSString*)albumName {
    
    [LEEAlert alert].config
    .LeeAddContent(^(UILabel *label) {
        label.font = HK_FONT_SYSTEM(15);
        label.text = [NSString stringWithFormat:@"已添加到专辑“%@”，可以在学习-我的专辑中进行管理",albumName];
        label.textColor = [UIColor colorWithHexString:@"#030303"];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"知道了";
        action.font = HK_FONT_SYSTEM(15);
        action.titleColor = COLOR_0076FF;
        action.backgroundColor = [UIColor whiteColor];
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}


@end


